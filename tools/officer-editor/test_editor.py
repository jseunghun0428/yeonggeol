import shutil
import tempfile
import unittest
from pathlib import Path

from PIL import Image, ImageDraw

from appearances import AppearanceRules, AppearanceUsage
from awakening import AwakeningStories
from data import ART_COUNTS, ASSETS, CAMPAIGNS, INPUTS, BattleAssignment, Game, import_cells
from editor import SORTS, sorted_ids


ROOT = Path(__file__).resolve().parents[2]


class OfficerEditorTest(unittest.TestCase):
    def test_campaigns_and_sorting(self):
        games = [Game(ROOT, campaign) for campaign in CAMPAIGNS.values()]
        self.assertEqual([g.people[1] for g in games[:2]], ["유비", "조조"])
        for game in games:
            self.assertTrue(game.troops and game.skills)
            for kind in ASSETS:
                self.assertTrue(game.choices(kind))
        names = {1: "유비", 2: "관우", 3: "장비"}
        self.assertEqual(sorted_ids(names, SORTS[2]), [2, 1, 3])
        self.assertEqual(sorted_ids(names, SORTS[1]), [3, 2, 1])

    def test_register_assign_and_reopen(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            assets = root / "yeonggeol" / "data"
            assets.mkdir(parents=True)
            original = ROOT / "yeonggeol"
            shutil.copyfile(original / "hzmb.dat", assets.parent / "hzmb.dat")
            for stem in ("newgame", *ASSETS.values()):
                for extension in ("idx", "grp"):
                    name = f"{stem}.{extension}"
                    shutil.copyfile(original / "data" / name, assets / name)
            game = Game(root, "")
            old = game.raw
            for kind, inputs in INPUTS.items():
                for stem, width, height, _ in inputs:
                    image = Image.new("RGBA", (width, height))
                    ImageDraw.Draw(image).rectangle((6, 6, width - 6, height - 6), fill="#a84a28")
                    image.save(root / f"{stem}.png")
            Image.new("RGB", (48, 48)).save(root / "wrong.png")
            with self.assertRaisesRegex(ValueError, "64×80"):
                import_cells("얼굴", root / "wrong.png")
            self.assertEqual(game.path.read_bytes(), old)
            self.assertFalse(game.flags_path.exists())
            with self.assertRaisesRegex(ValueError, "BMP"):
                Image.new("RGB", (64, 80)).save(root / "face.jpg")
                import_cells("얼굴", root / "face.jpg")
            art = {kind: import_cells(kind, root / "face.png" if kind == "얼굴" else root) for kind in ASSETS}
            game.save(1, {48: 91, 64: 4, 138: 10, 140: 12}, art)
            updated = Game(root, "")
            for offset, expected in ((48, 91), (64, 4), (138, 10), (140, 12)):
                self.assertEqual(updated.value(1, offset), expected)
            self.assertEqual(updated.flags[1][0], 31)
            for kind in ASSETS:
                slot = updated.appearance(1, kind)
                self.assertIn(slot, updated.choices(kind))
                self.assertTrue(all(updated.preview(kind, slot)))
                first = next(iter(game.choices(kind)))
                self.assertEqual(updated.preview(kind, first), game.preview(kind, first))
            start = updated.offset(1)
            self.assertEqual(updated.raw[:start], old[:start])
            self.assertEqual(updated.raw[start + 152:], old[start + 152:])
            with self.assertRaisesRegex(ValueError, "외부에서"):
                game.save(2, {48: 92}, {})

            for kind, start in (("얼굴", 1), ("평상시", 32), ("전투", 5370)):
                with self.subTest(kind=kind):
                    archive = updated.archives[kind]
                    old_index, old_art = archive.idx.read_bytes(), archive.grp.read_bytes()
                    updated.revise_art(kind, start, art[kind])
                    self.assertNotEqual(updated.archives[kind].grp.read_bytes(), old_art)
                    # The second replacement must leave the first backup untouched.
                    updated.revise_art(kind, start, art[kind][:ART_COUNTS[kind]])
                    updated = Game(root, "")
                    updated.revise_art(kind, start)
                    self.assertEqual(updated.archives[kind].idx.read_bytes(), old_index)
                    self.assertEqual(updated.archives[kind].grp.read_bytes(), old_art)

            for name in ("jymain.lua", "addon/unique.lua", "addon/spriteclass.lua", "addon/officer_editor.lua"):
                destination = assets.parent / "script" / name
                destination.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(original / "script" / name, destination)
            baseline = AppearanceRules(updated, "")
            original_other_class = baseline.slot(80, "전투", 7)
            original_other_officer = baseline.slot(81, "전투", 8)
            updated.save(80, {}, {"전투": BattleAssignment(8, False, 5370)})
            updated = Game(root, "")
            rules = AppearanceRules(updated, "")
            self.assertEqual(rules.slot(80, "전투", 8), 5370)
            self.assertEqual(rules.slot(80, "전투", 7), original_other_class)
            self.assertEqual(rules.slot(81, "전투", 8), original_other_officer)
            updated.save(80, {}, {"전투": BattleAssignment(8, True, 6320)})
            updated = Game(root, "")
            rules = AppearanceRules(updated, "")
            self.assertEqual(rules.slot(80, "전투", 8), 6320)
            self.assertEqual(rules.slot(81, "전투", 8), 6320)
            updated.save(80, {}, {"전투": BattleAssignment(8, True, -1)})
            rules = AppearanceRules(Game(root, ""), "")
            self.assertEqual(rules.slot(80, "전투", 8), 5370)
            self.assertEqual(rules.slot(81, "전투", 8), original_other_officer)
            updated = Game(root, "")
            troop = updated.value(80, 64)
            updated.save(80, {}, {}, (
                BattleAssignment(7, False, art["전투"]),
                BattleAssignment(9, False, art["전투"]),
            ))
            updated = Game(root, "")
            rules = AppearanceRules(updated, "")
            cavalry, elite = (rules.slot(80, "전투", i) for i in (7, 9))
            self.assertNotEqual(cavalry, elite)
            self.assertTrue(all(updated.preview("전투", cavalry)))
            self.assertTrue(all(updated.preview("전투", elite)))
            self.assertEqual(updated.value(80, 64), troop)

    def test_art_usage(self):
        usage = AppearanceUsage(ROOT, Game(ROOT, ""), "")
        base = usage.for_story("")
        slot = base.slot(80, "전투", 8)
        self.assertTrue(any("영걸전 · #80 장료 · " in row and "중기병" in row
                            for row in usage.users("전투", slot)))
        self.assertEqual({story for story, slug in CAMPAIGNS.items()
                          if usage.for_story(slug).slot(1, "얼굴") >= 0}, set(CAMPAIGNS))

    def test_awakening_skill_edit(self):
        for campaign in CAMPAIGNS.values():
            game = Game(ROOT, campaign)
            self.assertTrue(game.awakening_skills(1))
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            original = ROOT / "yeonggeol"
            for name in ("hzmb.dat", "data/newgame.idx", "data/newgame.grp",
                         "script/addon/record.lua", "script/addon/awakeperson_data.lua",
                         "script/addon/awakeperson_roster.lua", "script/addon/genedit_roster.lua",
                         "script/addon/statsync_data.lua",
                         *(f"data/camp/{slug}/newgame.grp" for slug in CAMPAIGNS.values() if slug),
                         *(f"script/camp/{slug}/camp.lua" for slug in CAMPAIGNS.values() if slug),
                         *(f"data/{stem}.{ext}" for stem in ASSETS.values() for ext in ("idx", "grp"))):
                path = root / "yeonggeol" / name
                path.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(original / name, path)
            game = Game(root, "")
            base = game.awakening_skills(1)
            other = game.awakening_skills(2)
            game.save(1, {}, {}, awakening=(23,))
            changed = Game(root, "")
            self.assertEqual(changed.awakening_skills(1), (23,))
            self.assertEqual(changed.awakening_skills(2), other)
            self.assertEqual(changed.raw, game.raw)
            changed.save(1, {}, {}, awakening=())
            cleared = Game(root, "")
            self.assertEqual(cleared.awakening_skills(1), ())
            cleared.save(1, {}, {}, awakening=base)
            self.assertEqual(Game(root, "").awakening_skills(1), base)
            game = Game(root, "")
            stories = AwakeningStories(root, game)
            targets = stories.targets(1)
            self.assertEqual({slug: pid for slug, (_, pid) in targets.items()},
                             {"": 1, "wuje": 9, "sunjian": 142, "yuanshao": 226})
            self.assertNotEqual(stories.targets(63)["wuje"][1], stories.targets(171)["wuje"][1])
            self.assertNotIn("wuje", stories.targets(175))
            wuje, target = targets["wuje"]
            game.save(1, {}, {}, linked_awakenings=[(wuje, target, (23,))])
            self.assertEqual(Game(root, "").awakening_skills(1), base)
            self.assertEqual(Game(root, "wuje").awakening_skills(target), (23,))
            stories = AwakeningStories(root, Game(root, ""))
            targets = stories.targets(1)
            game.save(1, {}, {}, linked_awakenings=[(match, pid, (23, 10)) for match, pid in targets.values()])
            for slug, (_, pid) in targets.items():
                self.assertEqual(Game(root, slug).awakening_skills(pid), (23, 10))


if __name__ == "__main__":
    unittest.main()
