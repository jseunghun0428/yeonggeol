"""Windows editor for the game's shared skills, strategies, and strategy art."""

import sys
import tkinter as tk
from pathlib import Path
from tkinter import filedialog, messagebox, ttk

from PIL import Image, ImageTk
from lupa.lua52 import LuaError

from tactic_data import (CONDITIONS, EFFECTS, ELEMENT_SKILL_STRATEGIES, EVENTS, FIELDS,
                         RECOVERY_PARAMETERS, STRATEGY_KINDS, TARGETS, TacticProject,
                         effect_frames, skill_description)


class Editor(tk.Tk):
    def __init__(self, root):
        super().__init__()
        self.title("특기·책략 편집기")
        self.geometry("1020x700")
        self.minsize(860, 610)
        self.root = root
        self.project = None
        self.number = None
        self.kind = "S"
        self.timer = None
        self.status = tk.StringVar(self)
        self.query = tk.StringVar(self)
        self.show_reserved = tk.BooleanVar(self)
        toolbar = ttk.Frame(self, padding=10)
        toolbar.pack(fill="x")
        ttk.Button(toolbar, text="프로젝트 폴더 열기", command=self.open_project).pack(side="left")
        ttk.Label(toolbar, textvariable=self.status).pack(side="left", padx=10)
        body = ttk.Frame(self, padding=(10, 0, 10, 10))
        body.pack(fill="both", expand=True)
        sidebar = ttk.Frame(body, padding=(0, 0, 10, 0))
        sidebar.pack(side="left", fill="y")
        self.kind_box = ttk.Combobox(sidebar, values=("특기", "책략"), state="readonly", width=22)
        self.kind_box.current(0)
        self.kind_box.pack(fill="x")
        self.kind_box.bind("<<ComboboxSelected>>", self.change_kind)
        ttk.Entry(sidebar, textvariable=self.query).pack(fill="x", pady=5)
        ttk.Checkbutton(sidebar, text="보류 포함", variable=self.show_reserved, command=self.refresh_list).pack(anchor="w")
        list_panel = ttk.Frame(sidebar)
        list_panel.pack(fill="both", expand=True)
        self.items = tk.Listbox(list_panel, width=23, exportselection=False)
        scroll = ttk.Scrollbar(list_panel, command=self.items.yview)
        self.items.configure(yscrollcommand=scroll.set)
        scroll.pack(side="right", fill="y")
        self.items.pack(side="left", fill="both", expand=True)
        self.items.bind("<<ListboxSelect>>", self.change_item)
        self.add_button = ttk.Button(sidebar, text="책략 추가", command=self.add)
        self.detail = ttk.Frame(body)
        self.detail.pack(side="left", fill="both", expand=True)
        self.query.trace_add("write", lambda *_: self.refresh_list())
        self.protocol("WM_DELETE_WINDOW", lambda: self.destroy() if self.discard() else None)
        self.bind("<Control-s>", lambda _: self.save())
        self.load(root)

    def open_project(self):
        root = filedialog.askdirectory(parent=self, initialdir=self.root)
        if root and self.discard():
            self.load(Path(root))

    def load(self, root, number=None):
        try:
            project = TacticProject(root)
        except (OSError, ValueError, LuaError) as error:
            messagebox.showerror("프로젝트를 열 수 없습니다", str(error), parent=self)
            return
        self.project, self.root = project, root
        entries = project.entries(self.kind)
        self.number = number if number in entries else next(iter(entries), None)
        self.status.set(f"네 이야기 공통 · {root}")
        self.refresh_list()
        self.render()

    def refresh_list(self):
        if self.project is None:
            return
        query = self.query.get().strip().casefold()
        if self.kind == "M":
            self.add_button.pack(fill="x", pady=(6, 0))
        else:
            self.add_button.pack_forget()
        self.keys = []
        self.items.delete(0, "end")
        for number, name in self.project.entries(self.kind).items():
            if (self.show_reserved.get() or name != "보류") and query in f"{number} {name}".casefold():
                self.keys.append(number)
                self.items.insert("end", f"{number:>3}  {name}")
        self.highlight()

    def highlight(self):
        self.items.selection_clear(0, "end")
        if self.number in self.keys:
            index = self.keys.index(self.number)
            self.items.selection_set(index)
            self.items.see(index)

    def change_kind(self, _event):
        if self.project is None or not self.discard():
            self.kind_box.current(self.kind == "M")
            return
        self.kind = ("S", "M")[self.kind_box.current()]
        self.number = next(iter(self.project.entries(self.kind)), None)
        self.refresh_list()
        self.render()

    def change_item(self, _event):
        selection = self.items.curselection()
        if not selection:
            return
        number = self.keys[selection[0]]
        if number != self.number and self.discard():
            self.number = number
            self.render()
        else:
            self.highlight()

    def snapshot(self):
        return (self.name.get(), self.description.get("1.0", "end-1c"), tuple(v.get() for v in self.values),
                tuple(self.rules), self.learning.copy(), self.pending_image,
                tuple((key, var.get()) for key, var in self.rule_numbers.items()))

    def discard(self):
        return (self.number is None or (not self.adding and self.snapshot() == self.original)
                or messagebox.askyesno("저장하지 않은 변경", "편집 내용을 버릴까요?", parent=self))

    def add(self):
        if self.project is None or self.kind != "M" or not self.discard():
            return
        try:
            number = self.project.next_id(self.kind)
        except (OSError, ValueError, LuaError) as error:
            messagebox.showerror("항목을 추가할 수 없습니다", str(error), parent=self)
            return
        template = self.number
        self.number = number
        self.highlight()
        self.render(adding=True, template=template)

    def render(self, adding=False, template=None):
        self.stop_preview()
        for child in self.detail.winfo_children():
            child.destroy()
        if self.number is None:
            return
        self.adding = adding
        self.pending_image = None
        self.rule_numbers = {}
        name, description, values = self.project.fields(self.kind, self.number)
        source = self.number
        if adding:
            name = "새 책략"
            description = ""
            candidate = self.project.fields("M", template or 1)[2]
            values = candidate if 1 <= candidate[0] <= len(STRATEGY_KINDS) else self.project.fields("M", 1)[2]
        if self.kind == "S":
            _, description, _ = self.project.fields("S", source)
            values = self.project.skill_values(source)
            description = skill_description(source, description, values)
        self.rules = list(self.project.rules.get((self.kind, source), ()))
        self.learning = self.project.learning.get(self.number, {}).copy() if self.kind == "M" else {}
        ttk.Label(self.detail, text=f"#{self.number}  {name}", font=("Malgun Gothic", 15, "bold")).pack(anchor="w")
        actions = ttk.Frame(self.detail)
        actions.pack(side="bottom", fill="x", pady=(8, 0))
        if self.kind == "M" or name != "보류":
            ttk.Button(actions, text="네 이야기 저장", command=self.save).pack(side="right")
        if not adding:
            ttk.Button(actions, text="사용처 확인", command=self.show_usages).pack(side="left")
            if self.kind == "M":
                ttk.Button(actions, text="삭제", command=self.delete).pack(side="left", padx=5)
        tabs = self.tabs = ttk.Notebook(self.detail)
        tabs.pack(fill="both", expand=True, pady=(8, 0))
        data_page = ttk.Frame(tabs, padding=10)
        tabs.add(data_page, text="기본 정보")
        ttk.Label(data_page, text="이름").pack(anchor="w")
        self.name = tk.StringVar(self, value=name)
        ttk.Entry(data_page, textvariable=self.name,
                  state="readonly" if self.kind == "S" and not adding else "normal").pack(fill="x", pady=(0, 8))
        ttk.Label(data_page, text="효과 설명" if self.kind == "S" else "설명 (편집기 메모)").pack(anchor="w")
        self.description = tk.Text(data_page, height=5, wrap="char")
        self.description.insert("1.0", description)
        if self.kind == "S":
            self.description.configure(state="disabled")
        self.description.pack(fill="x")
        fields = ttk.Frame(data_page)
        fields.pack(fill="x", pady=8)
        self.values = [tk.StringVar(self, value=str(value)) for value in values]
        if self.kind == "S":
            self.render_skill_parameters(fields, source)
            if source == 39:
                def update_poison_description(*_):
                    try:
                        numbers = [int(value.get()) for value in self.values]
                    except ValueError:
                        return
                    self.description.configure(state="normal")
                    self.description.delete("1.0", "end")
                    self.description.insert("1.0", skill_description(source, description, numbers))
                    self.description.configure(state="disabled")

                for value in self.values:
                    value.trace_add("write", update_poison_description)
            if self.rules:
                self.render_rules(data_page)
        else:
            for position, i in enumerate((0, 1, 2, 5, 6)):
                title, value = FIELDS["M"][i], self.values[i]
                row, col = divmod(position, 2)
                ttk.Label(fields, text=title).grid(row=row, column=col*2, sticky="w", padx=(0, 6), pady=3)
                if i == 0:
                    choices = {f"{n} · {label}": str(n) for n, label in enumerate(STRATEGY_KINDS, 1)}
                    shown = next((label for label, n in choices.items() if n == value.get()), value.get())
                    field = ttk.Combobox(fields, values=tuple(choices), width=14, state="readonly")
                    field.set(shown)
                    field.bind("<<ComboboxSelected>>", lambda event, var=value: var.set(choices[event.widget.get()]))
                else:
                    field = ttk.Entry(fields, textvariable=value, width=12, state="readonly" if i == 5 else "normal")
                field.grid(row=row, column=col*2+1, sticky="w", padx=(0, 16), pady=3)
        if self.kind == "M":
            self.render_strategy_ranges(data_page)
            rule_page = ttk.Frame(tabs, padding=10)
            tabs.add(rule_page, text="발동 규칙")
            self.render_rules(rule_page)
            fx = ttk.Frame(tabs, padding=10)
            tabs.add(fx, text="이펙트")
            self.render_effect(fx)
            learning = ttk.Frame(tabs, padding=10)
            tabs.add(learning, text="병종 습득")
            self.render_learning(learning)
        self.original = self.snapshot()

    def render_strategy_ranges(self, parent):
        try:
            ranges = self.project.strategy_ranges
        except (OSError, ValueError, LuaError):
            ranges = {}

        radius = max((max(abs(x), abs(y)) for tiles in ranges.values() for x, y in tiles), default=0)
        cell_size = 18
        side = (radius * 2 + 1) * cell_size
        choices = {number: (f"범위 {number} · {len(tiles)}칸" if tiles else f"범위 {number} · 표시할 칸 없음")
                   for number, tiles in ranges.items()}
        if not ranges:
            choices = {number: f"범위 {number}" for number in range(27)}
        previews = ttk.Frame(parent)
        previews.pack(fill="x")

        def preview(index, origin, fill):
            value = self.values[index]
            panel = ttk.LabelFrame(previews, text=FIELDS["M"][index], padding=8)
            panel.pack(side="left", anchor="n", padx=(0, 12))
            current = int(value.get())
            options = choices.copy()
            options.setdefault(current, f"범위 {current} · 미지원")
            numbers = list(options)
            picker = ttk.Combobox(panel, values=tuple(options.values()), state="readonly", width=23)
            picker.current(numbers.index(current))
            picker.pack(fill="x", pady=(0, 6))
            picker.bind("<<ComboboxSelected>>", lambda event: value.set(str(numbers[event.widget.current()])))
            if not ranges:
                return
            canvas = tk.Canvas(panel, width=side + 1, height=side + 1, highlightthickness=0)
            canvas.pack()
            ttk.Label(panel, text=f"● {origin}").pack(anchor="w", pady=(4, 0))

            def draw(*_):
                tiles = ranges.get(int(value.get()), set())
                canvas.delete("all")
                for y in range(-radius, radius + 1):
                    for x in range(-radius, radius + 1):
                        left, top = (x + radius) * cell_size, (y + radius) * cell_size
                        highlighted = (x, y) in tiles
                        canvas.create_rectangle(left, top, left + cell_size, top + cell_size,
                                                fill=fill if highlighted else "#f8fafc", outline="#94a3b8",
                                                tags=("range_tile",) if highlighted else ())
                center = radius * cell_size + cell_size / 2
                canvas.create_oval(center - 3, center - 3, center + 3, center + 3, fill="#0f172a", outline="")

            value.trace_add("write", draw)
            draw()

        preview(3, "시전자 위치", "#93c5fd")
        preview(4, "선택한 대상 위치", "#86efac")
        if not ranges:
            ttk.Label(parent, text="게임 스크립트에서 범위 미리보기를 불러올 수 없습니다.").pack(anchor="w")

    def render_skill_parameters(self, parent, number):
        parameters = [(i, label) for i, label in enumerate(self.project.skill_parameters(number)) if label]
        frame = ttk.LabelFrame(parent, text="독계 강화·책략 습득" if number == 39 else "효과 수치", padding=8)
        frame.pack(fill="x")
        for row, (i, name) in enumerate(parameters):
            ttk.Label(frame, text=name).grid(row=row, column=0, sticky="w", padx=(0, 10), pady=2)
            ttk.Entry(frame, textvariable=self.values[i], width=12).grid(row=row, column=1, sticky="w")
        if not parameters and not self.rules:
            ttk.Label(frame, text="조절할 수치가 없는 효과입니다.").pack(anchor="w")
        if number in ELEMENT_SKILL_STRATEGIES:
            ttk.Label(parent, text="습득 레벨을 0으로 두면 요술사 습득 레벨을 따릅니다.").pack(anchor="w", pady=(6, 0))
        if number in RECOVERY_PARAMETERS:
            ttk.Label(parent, text="회복 배율 100%는 게임의 기본 회복량입니다.").pack(anchor="w", pady=(6, 0))

    def render_rules(self, page):
        if not self.rules:
            ttk.Label(page, text="등록된 규칙이 없습니다. 게임 기본 효과가 적용됩니다.").pack(anchor="w")
            return
        frame = ttk.LabelFrame(page, text="기존 발동 규칙", padding=8)
        frame.pack(fill="both", expand=True, pady=(4, 0))
        table = tk.Canvas(frame, highlightthickness=0, height=180)
        scroll = ttk.Scrollbar(frame, command=table.yview)
        scroll.pack(side="right", fill="y")
        table.configure(yscrollcommand=scroll.set)
        table.pack(side="left", fill="both", expand=True)
        body = ttk.Frame(table)
        grid = table.create_window(0, 0, anchor="nw", window=body)
        body.bind("<Configure>", lambda _event: table.configure(scrollregion=table.bbox("all")))
        table.bind("<Configure>", lambda event: table.itemconfigure(grid, width=event.width))
        body.columnconfigure(0, weight=1)
        units = ("병력", "%", "병력", "MP", "MP", "사기", "사기", None, None, "턴", None)
        for row, (event, condition, threshold, target, effect, amount) in enumerate(self.rules):
            label = f"{EVENTS[self.kind][event]} · {CONDITIONS[condition]} · {TARGETS[target]} · {EFFECTS[effect]}"
            ttk.Label(body, text=label, wraplength=330).grid(row=row, column=0, sticky="w", pady=3)
            for col, (index, caption, value, enabled) in enumerate((
                (2, "기준 (%)", threshold, condition in (1, 2, 3)),
                (5, f"효과량 ({units[effect]})", amount, units[effect] is not None),
            )):
                if enabled:
                    ttk.Label(body, text=caption).grid(row=row, column=col*2+1, padx=(4, 0))
                    self.rule_numbers[row, index] = var = tk.StringVar(self, value=str(value))
                    ttk.Entry(body, textvariable=var, width=6).grid(row=row, column=col*2+2, padx=4)

    def render_effect(self, page):
        row = ttk.Frame(page)
        row.pack(fill="x")
        archive = self.project.archives["영걸전"]
        choices = sorted(self.project.effect_numbers())
        picker = ttk.Combobox(row, values=choices, state="readonly", width=12)
        picker.set(self.values[5].get())
        picker.pack(side="left")
        ttk.Button(row, text="새 PNG 등록", command=lambda: import_image()).pack(side="left", padx=6)
        self.play_button = ttk.Button(row, text="재생", command=self.toggle_preview)
        self.play_button.pack(side="left")
        ttk.Label(page, text="PNG 한 장에 같은 크기의 정사각형 프레임을 두 장 이상 세로로 배치하세요.",
                  wraplength=540).pack(anchor="w", pady=8)
        self.effect_info = ttk.Label(page)
        self.effect_info.pack(anchor="w")
        self.canvas = tk.Canvas(page, width=240, height=240, background="#e7ebf0", highlightthickness=0)
        self.canvas.pack(anchor="w", pady=5)
        self.canvas_sprite = self.canvas.create_image(120, 120)

        def load_preview(raw, number):
            self.stop_preview()
            self.frames = []
            self.position = 0
            try:
                frames = effect_frames(raw, number)
                self.effect_info.configure(text=f"{frames[0].width}×{frames[0].height} · {len(frames)}프레임"
                                                + (" · 등록 대기" if number is None else f" · #{number}"))
                for frame in frames:
                    frame.thumbnail((230, 230), Image.Resampling.NEAREST)
                    self.frames.append(ImageTk.PhotoImage(frame, master=self))
            except ValueError as error:
                self.effect_info.configure(text=str(error))
            self.canvas.itemconfigure(self.canvas_sprite, image=self.frames[0] if self.frames else "")
            self.play_button.configure(state="normal" if len(self.frames)>1 else "disabled")

        def choose(_event):
            number = int(picker.get())
            self.pending_image = None
            self.values[5].set(str(number))
            load_preview(archive.cell(number), number)

        def import_image():
            name = filedialog.askopenfilename(parent=self, filetypes=[("PNG 이미지", "*.png")])
            if not name:
                return
            try:
                raw = Path(name).read_bytes()
                effect_frames(raw)
            except (OSError, ValueError) as error:
                messagebox.showerror("이펙트를 등록할 수 없습니다", str(error), parent=self)
                return
            self.pending_image = raw
            picker.set("새 PNG")
            load_preview(raw, None)

        picker.bind("<<ComboboxSelected>>", choose)
        number = int(self.values[5].get())
        load_preview(archive.cell(number), number)

    def toggle_preview(self):
        if self.timer is not None:
            self.stop_preview()
        elif len(self.frames)>1:
            self.play_button.configure(text="정지")
            self.advance_preview()

    def advance_preview(self):
        self.canvas.itemconfigure(self.canvas_sprite, image=self.frames[self.position])
        self.position = (self.position+1) % len(self.frames)
        self.timer = self.after(100, self.advance_preview)

    def stop_preview(self):
        if self.timer is not None:
            self.after_cancel(self.timer)
            self.timer = None
            self.play_button.configure(text="재생")

    def render_learning(self, page):
        ttk.Label(page, text="병종을 선택해 습득 레벨을 지정하세요. 0을 넣으면 이 편집기에서 지정한 습득 설정이 해제됩니다.",
                  wraplength=560).pack(anchor="w")
        panel = ttk.Frame(page)
        panel.pack(fill="x", pady=8)
        troops = list(self.project.troops)
        selector = ttk.Combobox(panel, state="readonly",
                                values=[f"{self.project.troops[i]} (#{i})" for i in troops])
        selector.pack(side="left")
        level = ttk.Entry(panel, width=5)
        level.pack(side="left", padx=6)
        ttk.Button(panel, text="습득 레벨 적용", command=lambda: set_level()).pack(side="left")
        table = ttk.Treeview(page, columns=("troop", "level"), show="headings", height=11)
        table.heading("troop", text="병종")
        table.heading("level", text="습득 레벨")
        table.pack(fill="both", expand=True)

        def redraw():
            table.delete(*table.get_children())
            for i, value in sorted(self.learning.items()):
                table.insert("", "end", iid=str(i), values=(self.project.troops.get(i, f"#{i}"), value))

        def set_level():
            try:
                value = int(level.get())
                if selector.current()<0 or not 0<=value<=99:
                    raise ValueError
            except ValueError:
                messagebox.showerror("습득 레벨", "병종을 선택하고 0~99 사이 레벨을 입력하세요.", parent=self)
                return
            troop = troops[selector.current()]
            if value:
                self.learning[troop] = value
            else:
                self.learning.pop(troop, None)
            redraw()

        def select(_event):
            if table.selection():
                troop = int(table.selection()[0])
                if troop in troops:
                    selector.current(troops.index(troop))
                    level.delete(0, "end")
                    level.insert(0, str(self.learning[troop]))

        table.bind("<<TreeviewSelect>>", select)
        redraw()

    def show_usages(self, entries=None):
        if entries is None:
            try:
                entries = self.project.usages(self.kind, self.number)
            except (OSError, ValueError, LuaError) as error:
                messagebox.showerror("사용처를 읽을 수 없습니다", str(error), parent=self)
                return
        window = tk.Toplevel(self)
        window.title(f"#{self.number} 사용처")
        window.geometry("750x420")
        ttk.Label(window, text=f"사용처 {len(entries)}건" if entries else "사용처가 없습니다.", padding=8).pack(anchor="w")
        box = tk.Listbox(window)
        scroll = ttk.Scrollbar(window, command=box.yview)
        box.configure(yscrollcommand=scroll.set)
        scroll.pack(side="right", fill="y")
        box.pack(side="left", fill="both", expand=True)
        if entries:
            box.insert("end", *entries)

    def delete(self):
        if self.kind != "M":
            return
        try:
            entries = self.project.usages(self.kind, self.number)
            if entries:
                self.show_usages(entries)
                return
            if not self.discard() or not messagebox.askyesno("항목 삭제", f"#{self.number} 항목을 삭제할까요?", parent=self):
                return
            self.project.save(self.kind, self.number, delete=True)
        except (OSError, ValueError, LuaError) as error:
            messagebox.showerror("삭제할 수 없습니다", str(error), parent=self)
            return
        self.load(self.root)
        self.status.set("삭제 완료 · 네 이야기 공통")

    def save(self):
        if self.number is None:
            return
        try:
            name, description, values, rules, learning, image, amounts = self.snapshot()
            values = list(map(int, values))
            if self.kind == "S":
                values = self.project.encode_skill_values(self.number, values)
            rules = [list(rule) for rule in rules]
            for (row, index), value in amounts:
                rules[row][index] = int(value)
            self.project.save(self.kind, self.number, name, description, values, rules, learning, image)
        except (OSError, ValueError, LuaError) as error:
            messagebox.showerror("저장할 수 없습니다", str(error), parent=self)
            return
        tab = self.tabs.index("current")
        self.load(self.root, self.number)
        self.tabs.select(tab)
        self.status.set("저장 완료 · 네 이야기 공통")


if __name__ == "__main__":
    root = Path(sys.argv[1]).resolve() if len(sys.argv)>1 else Path(__file__).resolve().parents[2]
    Editor(root).mainloop()
