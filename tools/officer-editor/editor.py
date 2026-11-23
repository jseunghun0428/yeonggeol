"""Windows desktop editor for the project's default officer data."""

import io
import sys
import tkinter as tk
from pathlib import Path
from tkinter import filedialog, messagebox, ttk

from lupa.lua52 import LuaError
from PIL import Image, ImageTk

from appearances import AppearanceUsage
from awakening import AwakeningStories
from data import BattleAssignment, CAMPAIGNS, INPUTS, SKILLS, STATS, Game, import_cells


SORTS = ("번호 오름차순", "번호 내림차순", "이름 가나다순", "이름 역순")
OFFICER_STATS = {"무력": 48, "통솔": 52, "지력": 50}


def sorted_ids(items, order):
    key = (lambda i: (items[i].casefold(), i)) if order.startswith("이름") else None
    return sorted(items, key=key, reverse=order in (SORTS[1], SORTS[3]))


def sort_box(parent, callback):
    widget = ttk.Combobox(parent, values=SORTS, state="readonly", width=16)
    widget.current(0)
    widget.bind("<<ComboboxSelected>>", callback)
    return widget


def fill_list(widget, items, order, query=""):
    widget.delete(0, "end")
    keys = [i for i in sorted_ids(items, order) if query in f"{i} {items[i]}".casefold()]
    for key in keys:
        widget.insert("end", f"{key:>4}  {items[key]}")
    return keys


def show_images(panel, cells, kind):
    for child in panel.winfo_children():
        child.destroy()
    for cell in cells:
        if not cell:
            continue
        with Image.open(io.BytesIO(cell)) as source:
            image = source.convert("RGBA")
        image.thumbnail((72, 116), Image.Resampling.LANCZOS)
        photo = ImageTk.PhotoImage(image)
        label = ttk.Label(panel, image=photo)
        label.image = photo
        label.pack(side="left", padx=3, pady=3)
    if not panel.winfo_children():
        ttk.Label(panel, text="미리보기 없음").pack(side="left")


class BattlePreview(ttk.Frame):
    ACTIONS = {"대기": (16, 1, 1), "이동": (0, 4, 2), "공격": (30, 4, 4)}
    DIRECTIONS = ("오른쪽 위", "왼쪽 아래", "왼쪽 위", "오른쪽 아래")

    def __init__(self, parent, game):
        super().__init__(parent)
        self.game = game
        self.source = None
        self.timer = None
        self.frames = []
        self.position = 0
        picture = self.picture = tk.Canvas(self, width=132, height=132, highlightthickness=1,
                                           highlightbackground="#b7b7b7", background="#ececec")
        picture.grid(row=0, column=0, rowspan=4, sticky="nw", padx=(0, 10))
        self.sprite = picture.create_image(66, 66)
        self.hint = picture.create_text(66, 66, text="미리보기 없음")
        self.direction = ttk.Combobox(self, values=self.DIRECTIONS, state="readonly", width=13)
        self.direction.grid(row=0, column=1, sticky="ew")
        self.direction.current(3)
        self.action = ttk.Combobox(self, values=tuple(self.ACTIONS), state="readonly", width=13)
        self.action.grid(row=1, column=1, sticky="ew")
        self.action.current(1)
        for control in (self.direction, self.action):
            control.bind("<<ComboboxSelected>>", lambda _: self.refresh())
        self.button = ttk.Button(self, text="재생", command=self.toggle)
        self.button.grid(row=2, column=1, sticky="ew")
        self.frame_label = ttk.Label(self)
        self.frame_label.grid(row=3, column=1, sticky="w")
        self.bind("<Destroy>", lambda event: self.stop() if event.widget is self else None)

    def set_art(self, source):
        self.source = source
        self.refresh()

    def refresh(self):
        self.stop()
        self.frames = []
        start, step, count = self.ACTIONS[self.action.get()]
        first = start + self.direction.current() * step
        for index in range(first, first + count):
            try:
                if isinstance(self.source, list):
                    cell = self.source[index]
                elif self.source is not None and self.source >= 0:
                    cell = self.game.archives["전투"].cell(self.source + index)
                else:
                    cell = b""
                if cell:
                    with Image.open(io.BytesIO(cell)) as source:
                        image = source.convert("RGBA")
                    image = image.resize((image.width * 2, image.height * 2), Image.Resampling.NEAREST)
                    self.frames.append(ImageTk.PhotoImage(image, master=self))
            except (OSError, ValueError):
                continue
        self.position = 0
        self.button.configure(state="normal" if len(self.frames) > 1 else "disabled")
        self.draw()

    def draw(self):
        self.picture.itemconfigure(self.sprite, image=self.frames[self.position] if self.frames else "")
        self.picture.itemconfigure(self.hint, state="hidden" if self.frames else "normal")
        self.frame_label.configure(text=f"{self.position + 1}/{len(self.frames)} 프레임" if self.frames else "")

    def tick(self):
        self.draw()
        self.position = (self.position + 1) % len(self.frames)
        self.timer = self.after(150 if self.position else 250, self.tick)

    def toggle(self):
        if self.timer is not None:
            self.stop()
        elif len(self.frames) > 1:
            self.button.configure(text="일시 정지")
            self.tick()

    def stop(self):
        if self.timer is not None:
            self.after_cancel(self.timer)
            self.timer = None
            if self.button.winfo_exists():
                self.button.configure(text="재생")


class Picker:
    def __init__(self, editor, title, items, selected, kind=None, describe=None, battle_troop=None):
        window = self.window = tk.Toplevel(editor)
        window.title(title)
        window.transient(editor)
        window.geometry("780x700" if kind == "전투" else "700x660" if kind else "500x470" if describe else "430x425")
        window.columnconfigure(0, weight=1)
        window.rowconfigure(1, weight=1)
        window.grab_set()
        self.result = None
        battle = kind == "전투"
        saved_art = selected.art if isinstance(selected, BattleAssignment) else selected
        if isinstance(selected, BattleAssignment):
            selected = saved_art
        search = ttk.Entry(window)
        search.grid(row=0, column=0, sticky="ew", padx=10, pady=8)
        order = sort_box(window, lambda _: refresh())
        order.grid(row=0, column=1, sticky="ew", padx=(0, 10))
        listbox = tk.Listbox(window, exportselection=False)
        scroll = ttk.Scrollbar(window, command=listbox.yview)
        listbox.configure(yscrollcommand=scroll.set)
        listbox.grid(row=1, column=0, columnspan=2, sticky="nsew", padx=(10, 24))
        scroll.grid(row=1, column=1, sticky="nse", padx=10)
        panel = ttk.Frame(window)
        panel.grid(row=2, column=0, columnspan=2, sticky="ew", padx=10, pady=5)
        if describe:
            details = ttk.LabelFrame(panel, text="특기 설명", padding=8)
            details.pack(fill="x")
            description = tk.StringVar()
            ttk.Label(details, textvariable=description, wraplength=440, justify="left").pack(anchor="w")
        keys = []
        pending = saved_art if isinstance(saved_art, list) else None
        replacement = None
        users = None
        if kind:
            if battle:
                animation = BattlePreview(panel, editor.game)
                animation.pack(side="left", padx=(0, 12))
                assignment = ttk.LabelFrame(panel, text="전투 조형 적용", padding=6)
                assignment.pack(side="left", fill="x", expand=True)
                troop_ids = sorted(editor.game.troops)
                troop = ttk.Combobox(assignment, state="readonly", width=18,
                                     values=[editor.game.troops[i] for i in troop_ids])
                troop.pack(fill="x", pady=(0, 5))
                previous = editor.pending_battle(battle_troop)
                default_troop = previous.troop if previous else battle_troop
                troop.current(troop_ids.index(default_troop) if default_troop in troop_ids else 0)
                shared = tk.BooleanVar(window, value=previous is not None and previous.shared)
                ttk.Radiobutton(assignment, text="선택한 무장만", variable=shared, value=False).pack(anchor="w")
                ttk.Radiobutton(assignment, text="선택한 병종 전체", variable=shared, value=True).pack(anchor="w")
                ttk.Button(assignment, text="이 병종의 현재 조형 보기", command=lambda: show_current()).pack(anchor="w", pady=(4, 0))
            use_panel = ttk.LabelFrame(window, text="이 조형을 사용하는 무장", padding=6)
            use_panel.grid(row=5, column=0, columnspan=2, sticky="ew", padx=10, pady=(0, 8))
            users = tk.Listbox(use_panel, height=5, exportselection=False)
            user_scroll = ttk.Scrollbar(use_panel, command=users.yview)
            users.configure(yscrollcommand=user_scroll.set)
            user_scroll.pack(side="right", fill="y")
            users.pack(fill="x")

        def usage(slot):
            users.delete(0, "end")
            if slot is None:
                users.insert("end", "기존 조형 번호를 선택하면 사용 무장을 확인할 수 있습니다.")
                return
            try:
                rows = list(editor.appearances.users(kind, slot))
            except (OSError, ValueError, LuaError) as error:
                users.insert("end", f"사용 현황을 읽지 못했습니다. {error}")
                return
            users.insert("end", *(rows or ["기본 데이터에서 연결된 무장이 없습니다."]))

        def current_slot():
            index = listbox.curselection()
            return keys[index[0]] if index and keys[index[0]] >= 0 else None

        def preview():
            index = listbox.curselection()
            if describe:
                description.set(describe(keys[index[0]]) if index else "목록에서 특기를 선택해 주세요.")
            if not kind:
                return
            slot = current_slot()
            source = replacement if replacement is not None else pending if pending is not None else slot
            if battle:
                animation.set_art(source)
            else:
                try:
                    show_images(panel, source if isinstance(source, list) else (
                        editor.game.preview(kind, slot) if slot is not None else []), kind)
                except (OSError, ValueError):
                    show_images(panel, [], kind)
            usage(slot)
            overwrite.configure(state="normal" if slot is not None else "disabled")
            restore.configure(state="normal" if slot is not None and editor.game.original_art_path(
                kind, slot).exists() else "disabled")
            save_replacement.configure(state="normal" if replacement is not None else "disabled")

        def refresh(preferred=None):
            nonlocal keys, replacement
            active = listbox.curselection()
            value = preferred if preferred is not None else keys[active[0]] if active else selected
            if kind and pending is not None:
                value = None
            visible = items
            if describe and editor.exclude_held_skills.get():
                visible = {key: name for key, name in items.items() if name != "보류"}
            keys = fill_list(listbox, visible, order.get(), search.get().strip().casefold())
            if value in keys:
                i = keys.index(value)
                listbox.selection_set(i)
                listbox.see(i)
            else:
                replacement = None
            preview()

        def show_current():
            nonlocal pending, replacement
            slot = editor.appearance_slot(kind, troop_ids[troop.current()])
            if slot < 0:
                return
            items.setdefault(slot, f"전투 {slot}")
            pending = replacement = None
            search.delete(0, "end")
            refresh(slot)

        def choose():
            index = listbox.curselection()
            if pending is not None or index:
                value = pending if pending is not None else keys[index[0]]
                if battle and value != -2:
                    value = BattleAssignment(troop_ids[troop.current()], shared.get(), value)
                self.result = value
                window.destroy()

        def read_image():
            if kind == "얼굴":
                chosen = filedialog.askopenfilename(parent=window, filetypes=[("PNG/BMP", "*.png *.bmp")])
            else:
                chosen = filedialog.askdirectory(parent=window, title="필수 이미지 파일이 들어 있는 폴더")
            if chosen:
                try:
                    return import_cells(kind, Path(chosen))
                except (OSError, ValueError, Image.DecompressionBombError, SyntaxError) as error:
                    messagebox.showerror("등록할 수 없는 이미지", str(error), parent=window)
            return None

        def load_image():
            nonlocal pending, replacement
            images = read_image()
            if images is not None:
                replacement = None
                pending = images
                listbox.selection_clear(0, "end")
                preview()

        def stage_replacement():
            nonlocal replacement
            images = read_image()
            if images is not None:
                replacement = images
                preview()

        def revise(reset=False):
            nonlocal pending, replacement
            slot = current_slot()
            if slot is None:
                return
            images = None if reset else replacement
            if not reset and images is None:
                return
            operation = "원본으로 초기화" if reset else "이미지 교체"
            if not messagebox.askyesno(operation, f"{kind} #{slot}에 {operation}를 적용할까요?\n"
                                       "목록의 무장과 병종이 함께 바뀝니다. 그림 파일에 즉시 저장됩니다.",
                                       parent=window):
                return
            try:
                editor.game.revise_art(kind, slot, images)
            except (OSError, ValueError) as error:
                messagebox.showerror("조형을 저장할 수 없습니다", str(error), parent=window)
                return
            pending = replacement = None
            editor.refresh_art_previews()
            preview()

        def select(_event):
            nonlocal pending, replacement
            if listbox.curselection():
                pending = replacement = None
            preview()

        buttons = ttk.Frame(window, padding=10)
        buttons.grid(row=4, column=0, columnspan=2, sticky="ew")
        if describe:
            ttk.Checkbutton(window, text="보류 제외", variable=editor.exclude_held_skills,
                            command=refresh).grid(row=3, column=0, sticky="w", padx=10)
        if kind:
            lines = [f"{name}.bmp / {name}.png · {w}×{h} · {role}"
                     for name, w, h, role in INPUTS[kind]]
            if kind == "얼굴":
                lines[0] = "예: " + lines[0] + " (파일명 자유)"
            elif kind == "평상시":
                lines.append("높이는 64의 배수, 맨 위 3프레임 사용")
            else:
                lines.append("세 시트는 한 폴더에 넣어 주세요.")
            ttk.Label(window, text="\n".join(lines), padding=(10, 2)).grid(row=3, column=0, columnspan=2, sticky="w")
            ttk.Button(buttons, text="새 조형 가져오기", command=load_image).pack(side="left")
            overwrite = ttk.Button(buttons, text="교체 이미지 선택", command=stage_replacement)
            overwrite.pack(side="left", padx=4)
            restore = ttk.Button(buttons, text="원본으로 초기화", command=lambda: revise(True))
            restore.pack(side="left")
            save_replacement = ttk.Button(use_panel, text="교체 저장", command=revise)
            save_replacement.pack(anchor="e", pady=(4, 0))
        ttk.Button(buttons, text="선택 적용", command=choose).pack(side="right")
        ttk.Button(buttons, text="취소", command=window.destroy).pack(side="right", padx=5)
        listbox.bind("<<ListboxSelect>>", select)
        listbox.bind("<Double-1>", lambda _: choose())
        window.bind("<Escape>", lambda _: window.destroy())
        search.bind("<KeyRelease>", lambda _: refresh())
        refresh()
        search.focus_set()
        editor.wait_window(window)


class Editor(tk.Tk):
    def __init__(self, root):
        super().__init__()
        self.title("무장 편집기")
        self.geometry("1000x720")
        self.minsize(850, 675)
        self.root_path = root
        self.exclude_held_skills = tk.BooleanVar(self, value=True)
        self.game = None
        self.active = None
        self.fields = {}
        self.art = {}
        self.battle_edits = {}
        self.awakening_pending = {}
        self.awakening_tabs = None
        self.keys = []
        self.columnconfigure(0, weight=1)
        self.rowconfigure(1, weight=1)

        top = ttk.Frame(self, padding=10)
        top.grid(row=0, column=0, sticky="ew")
        ttk.Button(top, text="프로젝트 폴더 열기", command=self.open_project).pack(side="left")
        self.campaign = ttk.Combobox(top, values=list(CAMPAIGNS), state="readonly", width=11)
        self.campaign.current(0)
        self.campaign.pack(side="left", padx=10)
        self.campaign.bind("<<ComboboxSelected>>", lambda _: self.load(self.root_path, self.campaign.get()))
        self.campaign_name = self.campaign.get()
        self.status = tk.StringVar(value="")
        ttk.Label(top, textvariable=self.status).pack(side="left")

        main = ttk.Panedwindow(self, orient="horizontal")
        main.grid(row=1, column=0, sticky="nsew", padx=10, pady=(0, 10))
        left = ttk.Frame(main, padding=(0, 0, 6, 0))
        main.add(left, weight=1)
        options = ttk.Frame(left)
        options.pack(fill="x", pady=(0, 5))
        options.columnconfigure(1, weight=1)
        ttk.Label(options, text="이름·번호").grid(row=0, column=0, sticky="w", padx=(0, 6))
        self.search = ttk.Entry(options, width=12)
        self.search.grid(row=0, column=1, columnspan=2, sticky="ew")
        self.search.bind("<KeyRelease>", lambda _: self.refresh_list())
        ttk.Label(options, text="병종").grid(row=1, column=0, sticky="w", padx=(0, 6))
        self.troop_filter = ttk.Combobox(options, state="readonly", width=12)
        self.troop_filter.grid(row=1, column=1, columnspan=2, sticky="ew", pady=3)
        self.troop_ids = (None,)
        ttk.Label(options, text="정렬").grid(row=2, column=0, sticky="w", padx=(0, 6))
        self.sort_key = ttk.Combobox(options, state="readonly", width=6,
                                     values=("번호", "이름", *OFFICER_STATS))
        self.sort_key.grid(row=2, column=1, sticky="ew", padx=(0, 5))
        self.sort_key.current(0)
        self.sort_direction = ttk.Combobox(options, state="readonly", width=8,
                                           values=("오름차순", "내림차순"))
        self.sort_direction.grid(row=2, column=2, sticky="ew")
        self.sort_direction.current(0)
        for control in (self.troop_filter, self.sort_key, self.sort_direction):
            control.bind("<<ComboboxSelected>>", lambda _: self.refresh_list())
        self.listbox = tk.Listbox(left, exportselection=False, width=26)
        scroll = ttk.Scrollbar(left, command=self.listbox.yview)
        self.listbox.configure(yscrollcommand=scroll.set)
        scroll.pack(side="right", fill="y")
        self.listbox.pack(fill="both", expand=True)
        self.listbox.bind("<<ListboxSelect>>", self.select_person)

        self.right = ttk.Frame(main, padding=6)
        main.add(self.right, weight=3)
        self.protocol("WM_DELETE_WINDOW", self.close)
        self.bind("<Control-s>", lambda _: self.save())
        self.load(root, self.campaign_name)

    def allow_switch(self):
        return not (self.fields or self.art or self.battle_edits or self.awakening_pending) or messagebox.askyesno(
            "저장하지 않은 변경", "현재 무장의 변경을 버릴까요?", parent=self)

    def open_project(self):
        path = filedialog.askdirectory(parent=self, initialdir=self.root_path)
        if path:
            self.load(Path(path), self.campaign.get())

    def close(self):
        if self.allow_switch():
            self.destroy()

    def load(self, root, campaign, keep=None):
        if keep is None and not self.allow_switch():
            self.campaign.set(self.campaign_name)
            return
        try:
            game = Game(root, CAMPAIGNS[campaign])
        except (OSError, ValueError) as error:
            self.campaign.set(self.campaign_name)
            messagebox.showerror("프로젝트를 열 수 없습니다", str(error), parent=self)
            return
        self.game, self.root_path, self.campaign_name = game, root, campaign
        self.appearances = AppearanceUsage(root, game, CAMPAIGNS[campaign])
        self.awakening_stories = None
        self.status.set(str(root))
        previous = self.troop_filter.current()
        troop = self.troop_ids[previous] if previous >= 0 else None
        self.troop_ids = (None, *sorted(game.troops, key=lambda i: (game.troops[i], i)))
        self.troop_filter.configure(values=("전체 병종", *(f"{game.troops[i]} ({i})" for i in self.troop_ids[1:])))
        self.troop_filter.current(self.troop_ids.index(troop) if troop in self.troop_ids else 0)
        self.active = keep
        self.refresh_list()
        if keep is None:
            self.active = next(iter(self.keys), None)
            self.highlight()
        self.render_person()

    def refresh_list(self):
        if not self.game:
            return
        game = self.game
        query = self.search.get().strip().casefold()
        troop = self.troop_ids[self.troop_filter.current()]
        criterion = self.sort_key.get()
        stat = OFFICER_STATS.get(criterion)
        matches = [pid for pid, name in game.people.items()
                   if query in f"{pid} {name}".casefold()
                   and (troop is None or game.value(pid, 64) == troop)]
        values = {pid: game.value(pid, stat) for pid in matches} if stat is not None else {}
        if stat is not None:
            key = values.__getitem__
        elif criterion == "이름":
            key = lambda pid: game.people[pid].casefold()
        else:
            key = None
        self.keys = sorted(matches, key=key, reverse=self.sort_direction.current() == 1)
        self.listbox.delete(0, "end")
        for pid in self.keys:
            row = f"{pid:>4}  {game.people[pid]}"
            if stat is not None:
                row += f"  ·  {criterion} {values[pid]}"
            self.listbox.insert("end", row)
        self.highlight()

    def highlight(self):
        self.listbox.selection_clear(0, "end")
        if self.active in self.keys:
            index = self.keys.index(self.active)
            self.listbox.selection_set(index)
            self.listbox.see(index)

    def select_person(self, _event):
        index = self.listbox.curselection()
        if not index or self.active == self.keys[index[0]]:
            return
        if not self.allow_switch():
            self.highlight()
            return
        self.active = self.keys[index[0]]
        self.render_person()

    def render_person(self):
        self.fields, self.art, self.stats = {}, {}, {}
        self.battle_edits = {}
        self.awakening_pending = {}
        self.awakening_tabs = None
        for child in self.right.winfo_children():
            child.destroy()
        if self.active is None:
            return
        pid = self.active
        ttk.Label(self.right, text=f"{self.game.people[pid]}  #{pid}", font=("Malgun Gothic", 16, "bold")).pack(anchor="w")
        tabs = self.tabs = ttk.Notebook(self.right)
        tabs.pack(fill="both", expand=True, pady=8)
        looks, assignments, stats, awakening = [ttk.Frame(tabs, padding=10) for _ in range(4)]
        for tab, name in zip((looks, assignments, stats, awakening), ("조형", "병종·특기", "능력치", "각성 특기")):
            tabs.add(tab, text=name)
        self.art_panels = {}
        for kind in INPUTS:
            box = ttk.LabelFrame(looks, text=kind, padding=5)
            box.pack(fill="x", pady=3)
            if kind == "전투":
                controls = ttk.Frame(box)
                controls.pack(fill="x", pady=(0, 5))
                self.preview_troop_ids = sorted(self.game.troops)
                ttk.Label(controls, text="미리볼 병종").pack(side="left", padx=(0, 5))
                self.preview_troop = ttk.Combobox(
                    controls, state="readonly", width=14,
                    values=[f"{self.game.troops[i]} ({i})" for i in self.preview_troop_ids])
                self.preview_troop.pack(side="left", padx=(0, 5))
                self.select_preview_troop(self.current_troop())
                self.preview_troop.bind("<<ComboboxSelected>>", lambda _: self.refresh_art_previews())
                ttk.Button(controls, text="선택한 병종 조형 편집",
                           command=lambda: self.pick_art("전투")).pack(side="right")
            label = tk.StringVar()
            ttk.Label(box, textvariable=label).pack(side="left", padx=5)
            panel = BattlePreview(box, self.game) if kind == "전투" else ttk.Frame(box)
            panel.pack(side="left")
            self.art_panels[kind] = panel, label
            if kind != "전투":
                ttk.Button(box, text="조형 선택 / 등록",
                           command=lambda k=kind: self.pick_art(k)).pack(side="right")
        self.refresh_art_previews()
        self.render_assignments(assignments, pid)
        self.render_awakening(awakening, pid)
        for row, (offset, (name, maximum)) in enumerate(STATS.items()):
            value = self.game.value(pid, offset)
            variable = tk.StringVar(value=str(value))
            self.stats[offset] = variable
            variable.trace_add("write", lambda *_, o=offset, v=variable: self.set_field(o, v.get()))
            ttk.Label(stats, text=f"{name} (0~{maximum})").grid(row=row, column=0, padx=8, pady=5, sticky="w")
            ttk.Spinbox(stats, from_=0, to=maximum, textvariable=variable, width=10).grid(row=row, column=1)
        ttk.Button(self.right, text="이 무장 저장 (Ctrl+S)", command=self.save).pack(anchor="e")

    def render_awakening(self, panel, pid):
        try:
            if self.awakening_stories is None:
                self.awakening_stories = AwakeningStories(self.root_path, self.game)
            targets = self.awakening_stories.targets(pid)
            saved = {slug: skills for slug, (game, target) in targets.items()
                     if (skills := game.awakening_skills(target)) is not None}
        except (OSError, ValueError, LuaError) as error:
            ttk.Label(panel, text=f"각성 특기를 읽지 못했습니다. {error}", wraplength=440).pack(anchor="w")
            return
        tabs = self.awakening_tabs = ttk.Notebook(panel)
        tabs.pack(fill="both", expand=True)
        panes = {}
        self.awakening_targets = targets
        for story, slug in CAMPAIGNS.items():
            page = panes[slug] = ttk.Frame(tabs, padding=8)
            tabs.add(page, text=f"각성 특기 ({story})")

        def stage(slug, values):
            if values == saved[slug]:
                self.awakening_pending.pop(slug, None)
            else:
                self.awakening_pending[slug] = values

        def apply_common(slug):
            values = self.awakening_pending.get(slug, saved[slug])
            for other in saved:
                game, _ = targets[other]
                if any(value not in game.skills for value in values):
                    messagebox.showerror("공통 적용할 수 없습니다", "다른 이야기에서 사용할 수 없는 특기가 있습니다.", parent=self)
                    return
            for other in saved:
                stage(other, values)
            for other in saved:
                render_story(other)

        def render_story(slug):
            page = panes[slug]
            for child in page.winfo_children():
                child.destroy()
            if slug not in saved:
                text = "이 이야기의 각성 대상이 아닌 무장입니다." if slug in targets else "이 이야기에는 연결된 무장이 없습니다."
                ttk.Label(page, text=text).pack(anchor="w")
                return
            game, target = targets[slug]
            values = list(self.awakening_pending.get(slug, saved[slug]))
            count = max(1, len(values), len(saved[slug]), len(game.awakening.skills[target]))
            values.extend([0] * (count - len(values)))
            header = ttk.Frame(page)
            header.pack(fill="x", pady=(0, 7))
            state = " · 저장 대기" if slug in self.awakening_pending else ""
            ttk.Label(header, text=f"#{target} {game.people[target]}{state}").pack(side="left")
            ttk.Button(header, text="네 이야기 공통 적용", command=lambda: apply_common(slug)).pack(side="right")
            if len(saved) < len(CAMPAIGNS):
                ttk.Label(page, text="공통 적용은 각성 대상인 이야기만 변경합니다.").pack(anchor="w", pady=(0, 5))

            def choose(index):
                title = tabs.tab(page, "text")
                value = Picker(self, title, game.skills, values[index], describe=game.skill_description).result
                if value is not None:
                    values[index] = value
                    stage(slug, tuple(skill for skill in values if skill))
                    render_story(slug)

            for index, skill in enumerate(values):
                name = game.skills.get(skill, f"#{skill}")
                row = ttk.LabelFrame(page, padding=8, text=name)
                row.pack(fill="x", pady=(0, 6))
                row.columnconfigure(0, weight=1)
                ttk.Label(row, text=game.skill_description(skill), wraplength=330, justify="left").grid(row=0, column=0, sticky="w")
                ttk.Button(row, text="선택", command=lambda i=index: choose(i)).grid(row=0, column=1)

        for slug in panes:
            render_story(slug)
        tabs.select(panes[self.game.campaign])

    def render_assignments(self, assignments, pid):
        canvas = tk.Canvas(assignments, highlightthickness=0, background=ttk.Style(self).lookup("TFrame", "background"))
        scroll = ttk.Scrollbar(assignments, command=canvas.yview)
        canvas.configure(yscrollcommand=scroll.set)
        scroll.pack(side="right", fill="y")
        canvas.pack(side="left", fill="both", expand=True)
        rows = ttk.Frame(canvas, padding=(0, 0, 6, 0))
        content = canvas.create_window(0, 0, window=rows, anchor="nw")
        rows.bind("<Configure>", lambda _: canvas.configure(scrollregion=canvas.bbox("all")))
        descriptions = []

        def resize(event):
            canvas.itemconfigure(content, width=event.width)
            for text in descriptions:
                text.configure(wraplength=max(100, event.width - 28))

        def wheel(event):
            canvas.yview_scroll(1 if event.delta < 0 else -1, "units")
            return "break"

        canvas.bind("<Configure>", resize)
        canvas.bind("<MouseWheel>", wheel)
        rows.bind("<MouseWheel>", wheel)
        for offset, name in {64: "병종", **SKILLS}.items():
            items = self.game.troops if offset == 64 else self.game.skills
            value = self.game.value(pid, offset)
            label = tk.StringVar(value=items.get(value, f"#{value}"))
            is_skill = offset in SKILLS
            description = tk.StringVar(value=self.game.skill_description(value)) if is_skill else None
            row = ttk.Frame(rows)
            row.pack(fill="x", pady=(4, 0))
            ttk.Label(row, text=name, width=12).grid(row=0, column=0, sticky="w")
            ttk.Label(row, textvariable=label).grid(row=0, column=1, sticky="w")
            row.columnconfigure(1, weight=1)
            ttk.Button(row, text="선택",
                       command=lambda o=offset, n=name, it=items, l=label, d=description: self.pick_field(o, n, it, l, d)).grid(row=0, column=2, sticky="e")
            if is_skill:
                text = ttk.Label(row, textvariable=description, justify="left", wraplength=440)
                text.grid(row=1, column=0, columnspan=3, sticky="w", padx=(8, 0), pady=(2, 7))
                descriptions.append(text)
            row.bind("<MouseWheel>", wheel)
            for widget in row.winfo_children():
                widget.bind("<MouseWheel>", wheel)

    def current_troop(self):
        return self.fields.get(64, self.game.value(self.active, 64))

    def select_preview_troop(self, troop):
        ids = self.preview_troop_ids
        self.preview_troop.current(ids.index(troop) if troop in ids else 0)

    def preview_troop_id(self):
        return self.preview_troop_ids[self.preview_troop.current()]

    def pending_battle(self, troop):
        return next((edit for edit in reversed(self.battle_edits.values()) if edit.troop == troop), None)

    def appearance_slot(self, kind, troop=None):
        try:
            rules = self.appearances.for_story(CAMPAIGNS[self.campaign_name])
            return rules.slot(self.active, kind, self.current_troop() if troop is None else troop)
        except (OSError, ValueError, LuaError):
            return self.game.appearance(self.active, kind)

    def refresh_art_previews(self):
        for kind, (panel, label) in self.art_panels.items():
            troop = self.preview_troop_id() if kind == "전투" else None
            current = self.appearance_slot(kind, troop)
            pending = (self.pending_battle(troop) or current) if kind == "전투" else self.art.get(kind, current)
            detail = ""
            is_pending = isinstance(pending, BattleAssignment)
            if isinstance(pending, BattleAssignment):
                scope = "병종 전체" if pending.shared else "이 무장"
                detail = f"\n{self.game.troops[pending.troop]} · {scope}"
                pending = pending.art
            if isinstance(pending, list):
                label.set("새 조형 · 저장 대기" + detail)
            elif pending < 0:
                label.set(("배정 해제 · 저장 대기" if is_pending else "미리보기 없음") + detail)
            else:
                label.set(f"#{pending}" + (" · 저장 대기" if is_pending else "") + detail)
            if kind == "전투":
                panel.set_art(pending if not isinstance(pending, int) or pending >= 0 else current)
            else:
                try:
                    show_images(panel, pending if isinstance(pending, list) else self.game.preview(kind, pending), kind)
                except (ValueError, OSError):
                    show_images(panel, [], kind)

    def pick_art(self, kind):
        troop = self.preview_troop_id() if kind == "전투" else None
        current = self.appearance_slot(kind, troop)
        items = self.game.choices(kind)
        if current >= 0 and current not in items:
            items[current] = f"{kind} {current}"
        if kind == "전투":
            items[-1] = "선택한 범위의 배정 해제"
            if self.game.flags.get(self.active, (0, -1))[1] >= 0:
                items[-2] = "이 무장의 기존 전체 병종 배정 해제"
        selection = (self.pending_battle(troop) or current) if kind == "전투" else self.art.get(kind, current)
        value = Picker(self, kind + " 조형", items, selection, kind, battle_troop=troop).result
        if value is not None:
            if isinstance(value, BattleAssignment):
                key = (value.troop, value.shared)
                self.battle_edits.pop(key, None)
                self.battle_edits[key] = value
                self.select_preview_troop(value.troop)
            elif value == current and kind == "얼굴":
                self.art.pop(kind, None)
            else:
                self.art[kind] = -1 if value == -2 else value
            self.refresh_art_previews()

    def set_field(self, offset, value):
        original = self.game.value(self.active, offset)
        if str(value) == str(original):
            self.fields.pop(offset, None)
        else:
            self.fields[offset] = value

    def pick_field(self, offset, title, items, label, description):
        selected = self.fields.get(offset, self.game.value(self.active, offset))
        describe = self.game.skill_description if description is not None else None
        value = Picker(self, title, items, selected, describe=describe).result
        if value is not None:
            follows_current = offset == 64 and self.preview_troop_id() == self.current_troop()
            self.set_field(offset, value)
            label.set(items[value])
            if description is not None:
                description.set(describe(value))
            elif offset == 64:
                if follows_current:
                    self.select_preview_troop(value)
                self.refresh_art_previews()

    def save(self):
        if self.active is None or not (self.fields or self.art or self.battle_edits or self.awakening_pending):
            return
        preview_troop = self.preview_troop_id()
        tab = self.tabs.index(self.tabs.select())
        awake_tab = self.awakening_tabs.index(self.awakening_tabs.select()) if self.awakening_tabs is not None else None
        try:
            fields = {}
            for offset, value in self.fields.items():
                if offset in STATS:
                    name, maximum = STATS[offset]
                    if not str(value).isascii() or not str(value).isdecimal() or not 0 <= int(value) <= maximum:
                        raise ValueError(f"{name}: 0~{maximum} 사이의 정수를 입력해 주세요.")
                fields[offset] = int(value)
            linked = [(*self.awakening_targets[slug], skills) for slug, skills in self.awakening_pending.items()]
            self.game.save(self.active, fields, self.art, self.battle_edits.values(), linked_awakenings=linked)
        except (OSError, ValueError) as error:
            messagebox.showerror("저장할 수 없습니다", str(error), parent=self)
            return
        self.load(self.root_path, self.campaign_name, keep=self.active)
        self.select_preview_troop(preview_troop)
        self.refresh_art_previews()
        self.tabs.select(tab)
        if awake_tab is not None and self.awakening_tabs is not None:
            self.awakening_tabs.select(awake_tab)
        self.status.set(f"저장 완료 · {self.campaign_name}")


if __name__ == "__main__":
    root = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path(__file__).resolve().parents[2]
    Editor(root).mainloop()
