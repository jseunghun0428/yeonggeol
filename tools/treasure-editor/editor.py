"""Windows editor for treasure stats and artwork."""

import sys
import tkinter as tk
from pathlib import Path
from tkinter import filedialog, messagebox, ttk

from PIL import Image, ImageTk

from treasure_data import PERCENT_OPTIONS, STAT_NAMES, TreasureProject, import_picture


class Editor(tk.Tk):
    def __init__(self, root):
        super().__init__()
        self.title("보물 편집기")
        self.geometry("940x660")
        self.minsize(820, 580)
        self.root = root
        self.project = self.number = self.pending = None
        self.keys = []
        self.status = tk.StringVar(self)
        self.query = tk.StringVar(self)
        self.variant = tk.StringVar(self, "전체")
        self.exclude_exclusive = tk.BooleanVar(self)

        toolbar = ttk.Frame(self, padding=10)
        toolbar.pack(fill="x")
        ttk.Button(toolbar, text="프로젝트 폴더 열기", command=self.open_project).pack(side="left")
        ttk.Label(toolbar, textvariable=self.status).pack(side="left", padx=10)
        body = ttk.Frame(self, padding=(10, 0, 10, 10))
        body.pack(fill="both", expand=True)
        sidebar = ttk.Frame(body, padding=(0, 0, 12, 0))
        sidebar.pack(side="left", fill="y")
        variant = ttk.Combobox(sidebar, textvariable=self.variant, values=("전체", "일반", "★ 각성"),
                               state="readonly", width=22)
        variant.pack(fill="x")
        variant.bind("<<ComboboxSelected>>", self.refresh_list)
        ttk.Label(sidebar, text="이름 또는 번호 검색").pack(anchor="w", pady=(8, 0))
        ttk.Entry(sidebar, textvariable=self.query).pack(fill="x", pady=(2, 6))
        ttk.Checkbutton(sidebar, text="전용 장비 제외", variable=self.exclude_exclusive,
                        command=self.refresh_list).pack(anchor="w", pady=(0, 6))
        list_panel = ttk.Frame(sidebar)
        list_panel.pack(fill="both", expand=True)
        self.items = tk.Listbox(list_panel, width=25, exportselection=False)
        scrollbar = ttk.Scrollbar(list_panel, command=self.items.yview)
        self.items.configure(yscrollcommand=scrollbar.set)
        scrollbar.pack(side="right", fill="y")
        self.items.pack(side="left", fill="both", expand=True)
        self.items.bind("<<ListboxSelect>>", self.select)
        pane = ttk.Frame(body)
        pane.pack(side="left", fill="both", expand=True)
        footer = ttk.Frame(pane)
        footer.pack(side="bottom", fill="x", pady=(10, 0))
        self.save_button = ttk.Button(footer, text="저장", command=self.save, state="disabled")
        self.save_button.pack(side="right")
        ttk.Label(footer, text="네 이야기 공통 적용").pack(side="left")
        self.detail_canvas = tk.Canvas(pane, bg=self.cget("bg"), highlightthickness=0, yscrollincrement=24)
        detail_scroll = ttk.Scrollbar(pane, command=self.detail_canvas.yview)
        self.detail_canvas.configure(yscrollcommand=detail_scroll.set)
        detail_scroll.pack(side="right", fill="y")
        self.detail_canvas.pack(side="left", fill="both", expand=True)
        self.detail = ttk.Frame(self.detail_canvas)
        detail_window = self.detail_canvas.create_window(0, 0, window=self.detail, anchor="nw")
        self.detail_canvas.bind("<Configure>", lambda event: self.detail_canvas.itemconfigure(detail_window, width=event.width))
        self.detail.bind("<Configure>", lambda _: self.detail_canvas.configure(scrollregion=self.detail_canvas.bbox("all")))
        self.bind("<MouseWheel>", self.scroll_detail)

        self.query.trace_add("write", lambda *_: self.refresh_list())
        self.protocol("WM_DELETE_WINDOW", lambda: self.destroy() if self.leave() else None)
        self.bind("<Control-s>", lambda _: self.save())
        self.load(root)

    def open_project(self):
        root = filedialog.askdirectory(parent=self, initialdir=self.root)
        if root and self.leave():
            self.load(Path(root))

    def load(self, root):
        try:
            project = TreasureProject(root)
        except (OSError, ValueError) as error:
            messagebox.showerror("프로젝트를 열 수 없습니다", str(error), parent=self)
            return
        self.project, self.root = project, root
        self.number = next(iter(project.entries))
        self.render()
        self.save_button.configure(state="normal")
        self.status.set(f"네 이야기 공통 · {root}")
        self.refresh_list()

    def refresh_list(self, _event=None):
        if self.project is None:
            return
        self.keys.clear()
        self.items.delete(0, "end")
        query, variant = self.query.get().strip().casefold(), self.variant.get()
        exclude_exclusive = self.exclude_exclusive.get()
        for treasure in self.project.entries.values():
            if variant != "전체" and treasure.awakened != (variant == "★ 각성"):
                continue
            if query not in f"{treasure.number} {treasure.name} {treasure.category}".casefold():
                continue
            if exclude_exclusive and self.project.owner(treasure.number):
                continue
            self.keys.append(treasure.number)
            self.items.insert("end", f"{treasure.number:>3}  {treasure.name}")
        self.highlight()

    def scroll_detail(self, event):
        if event.widget in (self.detail_canvas, self.detail) or str(event.widget).startswith(f"{self.detail}."):
            if not isinstance(event.widget, (ttk.Combobox, ttk.Spinbox, tk.Text)):
                self.detail_canvas.yview_scroll(-int(event.delta / 120), "units")
                return "break"

    def highlight(self):
        self.items.selection_clear(0, "end")
        if self.number in self.keys:
            index = self.keys.index(self.number)
            self.items.selection_set(index)
            self.items.see(index)

    def select(self, _event):
        selection = self.items.curselection()
        if selection:
            number = self.keys[selection[0]]
            if number != self.number:
                if self.leave():
                    self.number = number
                    self.render()
                self.highlight()

    def snapshot(self):
        return ({offset: field.get() for offset, field in self.fields.items()},
                {key: combo.get() for key, combo in self.skill_fields.items()})

    def leave(self):
        if self.number is None or (self.pending is None and self.snapshot() == self.original):
            return True
        answer = messagebox.askyesnocancel("저장하지 않은 변경", "현재 보물의 편집 내용을 저장할까요?", parent=self)
        if answer is None:
            return False
        return self.save() if answer else True

    def render(self):
        for child in self.detail.winfo_children():
            child.destroy()
        self.detail_canvas.yview_moveto(0)
        self.pending = None
        treasure = self.project.entries[self.number]
        variant = "★ 각성" if treasure.awakened else "일반"
        ttk.Label(self.detail, text=treasure.name, font=("맑은 고딕", 19, "bold")).pack(anchor="w")
        ttk.Label(self.detail, text=f"#{treasure.number} · {treasure.category} · {variant}").pack(anchor="w", pady=(0, 10))

        columns = ttk.Frame(self.detail)
        columns.pack(fill="x")
        numbers = ttk.LabelFrame(columns, text="기본 능력치", padding=10)
        numbers.pack(side="left", fill="both", expand=True, padx=(0, 10))
        numbers.columnconfigure(0, weight=1)
        self.fields = {}
        saved_stats = self.project.stats(self.number)
        for row, (offset, value) in enumerate(saved_stats.items()):
            label = STAT_NAMES[offset]
            if offset in PERCENT_OPTIONS:
                label += " %"
            ttk.Label(numbers, text=label).grid(row=row, column=0, sticky="w", pady=3)
            field = tk.StringVar(self, str(value))
            ttk.Spinbox(numbers, from_=-32768, to=32767, textvariable=field, width=9).grid(row=row, column=1, pady=3)
            self.fields[offset] = field
        art = ttk.LabelFrame(columns, text="보물 이미지", padding=10)
        art.pack(side="left", fill="y")
        self.preview = tk.Canvas(art, width=250, height=161, bg="#24242b", highlightthickness=0)
        self.preview.pack()
        buttons = ttk.Frame(art)
        buttons.pack(fill="x", pady=(8, 0))
        ttk.Button(buttons, text="이미지 선택…", command=self.choose_picture).pack(side="left")
        self.undo_picture = ttk.Button(buttons, text="교체 취소", command=self.cancel_picture, state="disabled")
        self.undo_picture.pack(side="right")
        try:
            self.current_picture = self.project.picture(self.number)
        except (OSError, ValueError) as error:
            self.current_picture = None
            messagebox.showerror("이미지를 읽을 수 없습니다", str(error), parent=self)
        self.show_picture()

        self.skill_choices = {"없음": 0}
        self.skill_choices.update({f"{number:>3}  {name}": number
                                   for number, name in self.project.skills.items() if number})
        self.skill_fields = {}
        skills = ttk.LabelFrame(self.detail, text="보물 특기", padding=8)
        skills.pack(fill="x", pady=(10, 0))
        skills.columnconfigure(1, weight=1)
        fields = self.project.skill_fields(self.number)
        if not fields:
            ttk.Label(skills, text="편집할 수 있는 특기가 없는 보물입니다.").grid(sticky="w")
        skill_descriptions = []
        for row, (key, (label, value)) in enumerate(fields.items()):
            row *= 2
            ttk.Label(skills, text=label).grid(row=row, column=0, padx=(0, 10), pady=2, sticky="w")
            selected = next((text for text, number in self.skill_choices.items() if number == value), None)
            if selected is None:
                selected = f"{value:>3}  (기존 특기)"
                self.skill_choices[selected] = value
            combo = ttk.Combobox(skills, values=tuple(self.skill_choices), state="readonly", height=16)
            combo.set(selected)
            combo.grid(row=row, column=1, pady=2, sticky="ew")
            self.skill_fields[key] = combo
            description = ttk.Label(skills, text=self.project.base.skill_description(value), justify="left", wraplength=560)
            description.grid(row=row + 1, column=0, columnspan=2, pady=(0, 8), sticky="w")
            skill_descriptions.append(description)
            combo.bind("<<ComboboxSelected>>",
                       lambda event, label=description: self.show_skill_description(event, label, lines, saved_stats))
        skills.bind("<Configure>", lambda event: self.wrap_skills(event.width, skill_descriptions))
        self.original = self.snapshot()

        description = ttk.LabelFrame(self.detail, text="게임 설명", padding=6)
        description.pack(fill="both", expand=True, pady=(10, 0))
        lines = tk.Text(description, height=5, wrap="word", relief="flat", bg=self.cget("bg"))
        lines.pack(fill="both", expand=True)
        self.show_description(lines, saved_stats)
        for offset in PERCENT_OPTIONS:
            self.fields[offset].trace_add("write", lambda *_: self.show_description(lines, saved_stats))

    def show_description(self, lines, saved_stats):
        stats = saved_stats.copy()
        for offset in PERCENT_OPTIONS:
            try:
                stats[offset] = int(self.fields[offset].get())
            except ValueError:
                pass
        lines.configure(state="normal")
        lines.delete("1.0", "end")
        skills = {key: self.skill_choices[combo.get()] for key, combo in self.skill_fields.items()}
        lines.insert("1.0", self.project.description(self.number, stats, skills))
        lines.configure(state="disabled")

    def wrap_skills(self, width, labels):
        for label in labels:
            label.configure(wraplength=max(1, width - 20))

    def show_skill_description(self, event, label, lines, saved_stats):
        number = self.skill_choices[event.widget.get()]
        label.configure(text=self.project.base.skill_description(number))
        self.show_description(lines, saved_stats)

    def choose_picture(self):
        path = filedialog.askopenfilename(parent=self, filetypes=(("PNG 또는 BMP 이미지", "*.png *.bmp"),))
        if not path:
            return
        try:
            self.pending = import_picture(Path(path))
        except (OSError, ValueError, Image.DecompressionBombError) as error:
            messagebox.showerror("이미지를 열 수 없습니다", str(error), parent=self)
            return
        self.show_picture()

    def cancel_picture(self):
        self.pending = None
        self.show_picture()

    def show_picture(self):
        self.preview.delete("all")
        self.undo_picture.configure(state="normal" if self.pending is not None else "disabled")
        image = self.pending if self.pending is not None else self.current_picture
        title = "교체 미리보기" if self.pending is not None else "현재 이미지"
        self.preview.create_text(78, 149, text=title, fill="white")
        self.preview.create_text(201, 149, text="장비창 크기", fill="white")
        if image is not None:
            self.big = ImageTk.PhotoImage(image)
            self.small = ImageTk.PhotoImage(image.resize((38, 38), Image.Resampling.LANCZOS))
            self.preview.create_image(78, 70, image=self.big)
            self.preview.create_image(201, 70, image=self.small)

    def save(self):
        if self.number is None:
            return True
        try:
            values = {offset: int(field.get()) for offset, field in self.fields.items()}
        except ValueError:
            messagebox.showerror("저장할 수 없습니다", "기본 능력치를 정수로 입력해 주세요.", parent=self)
            return False
        try:
            skills = {key: self.skill_choices[combo.get()] for key, combo in self.skill_fields.items()}
            saved = self.project.save(self.number, values, self.pending, skills=skills)
        except (OSError, ValueError) as error:
            messagebox.showerror("저장할 수 없습니다", str(error), parent=self)
            return False
        if saved:
            try:
                self.project = TreasureProject(self.root)
            except (OSError, ValueError) as error:
                self.number = None
                self.save_button.configure(state="disabled")
                for widget in self.detail.winfo_children():
                    widget.destroy()
                messagebox.showerror("저장 후 다시 열 수 없습니다", str(error), parent=self)
                return False
        self.render()
        self.status.set("저장했습니다" if saved else "저장할 변경이 없습니다")
        return True


if __name__ == "__main__":
    project_root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parents[2]
    Editor(project_root).mainloop()
