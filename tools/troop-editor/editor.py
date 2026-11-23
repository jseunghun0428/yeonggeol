"""Windows desktop editor for common troop data."""

import io
import struct
import sys
import tkinter as tk
from pathlib import Path
from tkinter import filedialog, messagebox, ttk

from lupa.lua52 import LuaError
from PIL import Image, ImageOps, ImageTk

from attack_range import load_attack_ranges
from troop_data import ART, COUNTERS, GENERAL, STRATEGIES, TERRAIN, TroopProject


class Editor(tk.Tk):
    def __init__(self, root):
        super().__init__()
        self.title("병종 편집기")
        self.geometry("1040x720")
        self.minsize(850, 650)
        self.root_path = root
        self.project = None
        self.selected = None
        self.draft = None
        self.keys = []
        self.tabs = None

        toolbar = ttk.Frame(self, padding=10)
        toolbar.pack(fill="x")
        ttk.Button(toolbar, text="프로젝트 폴더 열기", command=self.open_project).pack(side="left")
        self.status = tk.StringVar(self)
        ttk.Label(toolbar, textvariable=self.status).pack(side="left", padx=10)

        body = ttk.Frame(self, padding=(10, 0, 10, 10))
        body.pack(fill="both", expand=True)
        sidebar = ttk.Frame(body, padding=(0, 0, 10, 0))
        sidebar.pack(side="left", fill="y")
        ttk.Label(sidebar, text="병종 이름·번호").pack(anchor="w")
        self.query = tk.StringVar(self)
        ttk.Entry(sidebar, textvariable=self.query, width=22).pack(fill="x", pady=(0, 5))
        list_frame = ttk.Frame(sidebar)
        list_frame.pack(fill="both", expand=True)
        self.listbox = tk.Listbox(list_frame, width=27, exportselection=False)
        scroll = ttk.Scrollbar(list_frame, command=self.listbox.yview)
        self.listbox.configure(yscrollcommand=scroll.set)
        scroll.pack(side="right", fill="y")
        self.listbox.pack(side="left", fill="both", expand=True)
        self.listbox.bind("<<ListboxSelect>>", self.choose)

        self.right = ttk.Frame(body)
        self.right.pack(side="left", fill="both", expand=True)
        self.query.trace_add("write", lambda *_: self.refresh())
        self.protocol("WM_DELETE_WINDOW", lambda: self.destroy() if self.discard() else None)
        self.bind("<Control-s>", lambda _: self.save())
        self.load(root)

    def discard(self):
        if self.draft is None:
            return True
        name, description, fields = self.project.fields(self.draft)
        changed = (self.selected == self.project.next_id()
                   or self.name.get() != name or self.description.get("1.0", "end-1c") != description.replace("*", "\n")
                   or any(self.inputs[key].get() != self.field_label(key, value) for key, value in fields.items()))
        return not changed or messagebox.askyesno("저장하지 않은 변경", "병종 편집 내용을 버릴까요?", parent=self)

    def open_project(self):
        path = filedialog.askdirectory(parent=self, initialdir=self.root_path)
        if path and self.discard():
            self.load(Path(path))

    def load(self, root, selected=None):
        try:
            project = TroopProject(root)
            attack_ranges = load_attack_ranges(root / "yeonggeol" / "script" / "jymain.lua")
        except (OSError, ValueError, struct.error, LuaError) as error:
            messagebox.showerror("프로젝트를 열 수 없습니다", str(error), parent=self)
            return
        self.project, self.root_path = project, root
        self.attack_ranges = attack_ranges
        self.draft = None
        self.selected = selected if selected in project.troops else next((i for i in project.troops if i), None)
        self.status.set(f"네 이야기 공통 · {root}")
        self.refresh()
        self.render()

    def refresh(self):
        if self.project is None:
            return
        query = self.query.get().strip().casefold()
        self.keys = [i for i, name in self.project.troops.items() if i and query in f"{i} {name}".casefold()]
        self.listbox.delete(0, "end")
        for troop in self.keys:
            self.listbox.insert("end", f"{troop:>4}  {self.project.troops[troop]}")
        self.highlight()

    def highlight(self):
        self.listbox.selection_clear(0, "end")
        if self.selected in self.keys:
            index = self.keys.index(self.selected)
            self.listbox.selection_set(index)
            self.listbox.see(index)

    def choose(self, _event):
        selection = self.listbox.curselection()
        if not selection:
            return
        troop = self.keys[selection[0]]
        if troop == self.selected:
            return
        if self.discard():
            self.selected, self.draft = troop, None
            self.render()
        else:
            self.highlight()

    def render(self):
        selected_tab = self.tabs.select() if self.tabs is not None else ""
        active_tab = self.tabs.index(selected_tab) if selected_tab else 0
        for child in self.right.winfo_children():
            child.destroy()
        self.tabs = None
        if self.selected is None:
            return
        added = self.selected == self.project.next_id()
        if not added:
            self.draft = self.project.row(self.selected)
        name, description, numbers = self.project.fields(self.draft)
        self.inputs = {}
        self.counter_names = {0: "없음", **{i: name for i, name in self.project.troops.items() if i}}
        for offset in COUNTERS:
            self.counter_names.setdefault(numbers[offset], "알 수 없는 병종")
        self.counter_choices = {f"{name} ({i})": i for i, name in self.counter_names.items()}
        ttk.Label(self.right, text=f"#{self.selected}  {name}" + (" · 저장 대기" if added else ""),
                  font=("Malgun Gothic", 16, "bold")).pack(anchor="w", pady=(0, 8))
        buttons = ttk.Frame(self.right)
        buttons.pack(side="bottom", fill="x", pady=(8, 0))
        ttk.Button(buttons, text="네 이야기 저장", command=self.save).pack(side="right")
        if not added:
            ttk.Button(buttons, text="복제하여 추가", command=self.clone).pack(side="left")
            ttk.Button(buttons, text="사용처 확인", command=self.show_usages).pack(side="left", padx=5)
            ttk.Button(buttons, text="삭제", command=self.delete).pack(side="left")

        tabs = self.tabs = ttk.Notebook(self.right)
        tabs.pack(fill="both", expand=True)
        base = ttk.Frame(tabs, padding=10)
        tabs.add(base, text="기본")
        ttk.Label(base, text="이름").pack(anchor="w")
        self.name = tk.StringVar(self, value=name)
        ttk.Entry(base, textvariable=self.name).pack(fill="x", pady=(0, 5))
        ttk.Label(base, text="설명").pack(anchor="w")
        self.description = tk.Text(base, height=3, wrap="char")
        self.description.insert("1.0", description.replace("*", "\n"))
        self.description.pack(fill="x", pady=(0, 9))
        ttk.Label(base, text="사용 가능·반격·원거리·기마는 0 또는 1입니다.").pack(anchor="w")
        self.range_page = ttk.Frame(tabs, padding=10)
        tabs.add(self.range_page, text="공격 범위")
        self.render_fields(base, GENERAL, numbers, 2)
        self.render_attack_range(self.range_page)
        strategies = {i: self.project.strategies.get(i - 195, f"책략 {i - 195}") for i in STRATEGIES}
        for title, fields, columns, note in (
            ("전투 조형·효과음", ART, 2, "등급과 진영별 기본 전투 조형입니다."),
            ("지형", TERRAIN, 3, "지형별 이동 비용입니다. 0은 통과할 수 없는 지형입니다."),
            ("상성", COUNTERS, 2, "이 병종이 유리한 상대 병종을 선택합니다. 비워 둘 칸은 ‘없음’을 고르세요."),
            ("책략", strategies, 3, "각 책략을 배울 레벨을 입력합니다. 0은 배우지 않습니다."),
        ):
            page = ttk.Frame(tabs, padding=10)
            tabs.add(page, text=title)
            ttk.Label(page, text=note).pack(anchor="w", pady=(0, 8))
            self.render_fields(page, fields, numbers, columns)
            if fields is ART:
                self.render_battle_previews(page)
        tabs.select(active_tab)

    def render_fields(self, page, fields, numbers, columns):
        grid = ttk.Frame(page)
        grid.pack(fill="x")
        rows = (len(fields) + columns - 1) // columns
        for pos, (offset, title) in enumerate(fields.items()):
            row, column = pos % rows, (pos // rows) * 2
            value = self.inputs[offset] = tk.StringVar(self, value=self.field_label(offset, numbers[offset]))
            ttk.Label(grid, text=title).grid(row=row, column=column, sticky="w", padx=(0, 4), pady=2)
            if offset in COUNTERS:
                options = [label for label, troop in self.counter_choices.items()
                           if troop == 0 or troop in self.project.troops or troop == numbers[offset]]
                field = ttk.Combobox(grid, textvariable=value, values=options, state="readonly", width=17)
            elif offset == 133:
                field = ttk.Button(grid, text="범위 보기 / 변경",
                                   command=lambda: self.tabs.select(self.range_page))
            else:
                field = ttk.Entry(grid, textvariable=value, width=7)
            field.grid(row=row, column=column + 1, sticky="w", padx=(0, 12), pady=2)
            grid.columnconfigure(column + 1, weight=1)

    def render_battle_previews(self, page):
        archive = self.project.base.archives["전투"]
        tiers = {138: "초급", 140: "중급", 142: "고급"}
        sides = {148: "아군", 146: "우군", 144: "적군"}
        entries = {offset: self.inputs[offset] for offset in (*tiers, *sides)}
        grid = ttk.Frame(page)
        grid.pack(anchor="w", pady=(10, 0))
        previews = {}
        for column, (side, name) in enumerate(sides.items(), 1):
            ttk.Label(grid, text=name).grid(row=0, column=column)
            for row, tier in enumerate(tiers, 1):
                frame = ttk.Frame(grid, padding=(4, 2))
                frame.grid(row=row, column=column)
                image = ttk.Label(frame, width=16, anchor="center", background="#e8ecf0")
                image.grid(row=0, column=0, sticky="nsew")
                frame.rowconfigure(0, minsize=72)
                slot_label = ttk.Label(frame, anchor="center")
                slot_label.grid(row=1, column=0, sticky="ew")
                previews[tier, side] = image, slot_label
        for row, name in enumerate(tiers.values(), 1):
            ttk.Label(grid, text=name).grid(row=row, column=0, padx=(0, 8))

        def refresh(*_):
            for (tier, side), (image, slot_label) in previews.items():
                try:
                    slot = int(entries[tier].get()) + int(entries[side].get())
                except ValueError:
                    slot = None
                photo = None
                if slot is not None and slot >= 0:
                    for frame_offset in (19, 18, 17, 16):
                        try:
                            cell = archive.cell(slot + frame_offset)
                            if cell:
                                with Image.open(io.BytesIO(cell)) as source:
                                    sprite = ImageOps.contain(source.convert("RGBA"), (72, 72), Image.Resampling.NEAREST)
                                photo = ImageTk.PhotoImage(sprite, master=page)
                                break
                        except (OSError, ValueError):
                            continue
                image.configure(image=photo or "", text="" if photo else "미리보기 없음")
                image.photo = photo
                slot_label.configure(text=f"#{slot}" if slot is not None else "번호를 입력하세요")

        traces = [(entry, entry.trace_add("write", refresh)) for entry in entries.values()]

        def stop_refresh(_event):
            for entry, trace in traces:
                entry.trace_remove("write", trace)

        page.bind("<Destroy>", stop_refresh)
        refresh()

    def render_attack_range(self, page):
        value = self.inputs[133]
        choices = {number: f"범위 {number} · {len(tiles)}칸" if tiles else f"범위 {number} · 표시할 칸 없음"
                   for number, tiles in self.attack_ranges.items()}
        current = int(value.get())
        choices.setdefault(current, f"범위 {current} · 미지원")
        range_numbers = list(choices)
        picker = ttk.Combobox(page, values=list(choices.values()), state="readonly", width=28)
        picker.current(range_numbers.index(current))
        picker.pack(anchor="w", pady=(0, 8))

        ttk.Label(page, text="● 사용 위치    파란 칸은 범위에 포함됩니다.").pack(anchor="w", pady=(0, 6))
        radius = max(max(abs(x), abs(y)) for tiles in self.attack_ranges.values() for x, y in tiles)
        cell_size = 24
        side = (radius * 2 + 1) * cell_size
        canvas = tk.Canvas(page, width=side + 1, height=side + 1, highlightthickness=0)
        canvas.pack(anchor="w")

        def draw(number):
            tiles = self.attack_ranges.get(number, set())
            canvas.delete("all")
            for y in range(-radius, radius + 1):
                for x in range(-radius, radius + 1):
                    left, top = (x + radius) * cell_size, (y + radius) * cell_size
                    in_range = (x, y) in tiles
                    canvas.create_rectangle(left, top, left + cell_size, top + cell_size,
                                            fill="#93c5fd" if in_range else "#f8fafc", outline="#94a3b8",
                                            tags=("range_tile",) if in_range else ())
            center = radius * cell_size + cell_size / 2
            canvas.create_oval(center - 5, center - 5, center + 5, center + 5, fill="#0f172a", outline="")

        def change(_event):
            number = range_numbers[picker.current()]
            value.set(str(number))
            draw(number)

        picker.bind("<<ComboboxSelected>>", change)
        draw(current)

    def field_label(self, offset, value):
        if offset in COUNTERS:
            return f"{self.counter_names[value]} ({value})"
        return str(value)

    def clone(self):
        if not self.discard():
            return
        try:
            self.selected, self.draft = self.project.clone(self.selected)
        except ValueError as error:
            messagebox.showerror("병종을 복제할 수 없습니다", str(error), parent=self)
            return
        self.highlight()
        self.render()

    def show_usages(self, entries=None):
        if entries is None:
            entries = self.project.usages(self.selected)
        window = tk.Toplevel(self)
        window.title(f"병종 #{self.selected} 사용처")
        window.transient(self)
        window.geometry("700x420")
        ttk.Label(window, text=f"사용처 {len(entries)}건" if entries else "기본 무장과 전투 데이터에서 사용처를 찾지 못했습니다.",
                  padding=8).pack(anchor="w")
        frame = ttk.Frame(window, padding=8)
        frame.pack(fill="both", expand=True)
        items = tk.Listbox(frame)
        scroll = ttk.Scrollbar(frame, command=items.yview)
        items.configure(yscrollcommand=scroll.set)
        scroll.pack(side="right", fill="y")
        items.pack(fill="both", expand=True)
        if entries:
            items.insert("end", *entries)

    def delete(self):
        entries = self.project.usages(self.selected)
        if entries:
            self.show_usages(entries)
            return
        if not self.discard() or not messagebox.askyesno("병종 삭제", "이 병종을 네 이야기의 목록에서 삭제할까요?", parent=self):
            return
        try:
            self.project.save(self.selected, self.project.row(self.selected), delete=True)
        except (OSError, ValueError) as error:
            messagebox.showerror("삭제할 수 없습니다", str(error), parent=self)
            return
        self.load(self.root_path)
        self.status.set("삭제 완료 · 네 이야기 공통")

    def save(self):
        if self.selected is None:
            return
        try:
            values = {offset: self.counter_choices[value.get()] if offset in COUNTERS else int(value.get().strip())
                      for offset, value in self.inputs.items()}
            row = self.project.encode_fields(self.draft, self.name.get().strip(),
                                             self.description.get("1.0", "end-1c").replace("\n", "*"), values)
            self.project.save(self.selected, row)
        except (OSError, ValueError) as error:
            messagebox.showerror("저장할 수 없습니다", str(error), parent=self)
            return
        self.load(self.root_path, self.selected)
        self.status.set("저장 완료 · 네 이야기 공통")


if __name__ == "__main__":
    root = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path(__file__).resolve().parents[2]
    Editor(root).mainloop()
