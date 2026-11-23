import shutil
import struct
import tempfile
import unittest
from pathlib import Path

from troop_data import CAMPAIGNS, TroopProject
from usages import find_battle_usages


ROOT = Path(__file__).resolve().parents[2]


class TroopEditorTest(unittest.TestCase):
    def test_builtin_battle_refs(self):
        found = find_battle_usages(ROOT / "yeonggeol" / "script")
        self.assertTrue(any("적군" in usage for usage in found[5]))
        self.assertTrue(any("아군" in usage for usage in found[5]))
        self.assertTrue(found[38])
        self.assertFalse(found.get(40))

    def test_shared_update_clone_and_delete(self):
        original = ROOT / "yeonggeol"
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            names = ["hzmb.dat", "data/newgame.idx", "data/newgame.grp"]
            names += [f"data/camp/{slug}/newgame.grp" for slug in CAMPAIGNS.values() if slug]
            names += [f"data/{stem}.{ext}" for stem in ("hdgrp", "smap", "wmap") for ext in ("idx", "grp")]
            for name in names:
                target = root / "yeonggeol" / name
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(original / name, target)
            project = TroopProject(root)
            before = {name: game.raw for name, game in project.games.items()}
            old_idx = project.base.index
            row = project.row(1)
            name, desc, fields = project.fields(row)
            fields[132] = 6
            changed = project.encode_fields(row, "연습병", desc, fields)
            project.save(1, changed)
            project = TroopProject(root)
            for story, game in project.games.items():
                start = game.offsets[1] + 232
                self.assertEqual(game.raw[:start], before[story][:start])
                self.assertEqual(game.raw[start:start + 232], changed)
                self.assertEqual(game.raw[start + 232:], before[story][start + 232:])
                self.assertEqual(game.index, old_idx)
            with self.assertRaisesRegex(ValueError, "사용 중"):
                project.save(1, project.row(1), delete=True)
            number, copy = project.clone(1)
            project.save(number, copy)
            project = TroopProject(root)
            self.assertTrue(all(game.troops[number] == f"새 병종 {number}" for game in project.games.values()))
            self.assertEqual(project.fields(project.row(number))[2][132], 6)

            script = root / "yeonggeol" / "script"
            script.mkdir()
            battle = script / "test.lua"
            battle.write_text(f"-- SelectEnemy({{0,1,1,1,0,1,99,0,0,-1,0}})\n"
                              f"SnrSetEnemies({{0,1,1,1,0,1,{number},0,0,-1,0}})\n", encoding="ascii")
            self.assertIn("적군 전투 배치 · script/test.lua:2", project.usages(number))
            with self.assertRaisesRegex(ValueError, "사용 중"):
                project.save(number, project.row(number), delete=True)
            battle.write_text(f'JY.Person[1][BZ]={number} -- ally\n', encoding="ascii")
            self.assertIn("전투·병종 지정 · script/test.lua:1", project.usages(number))
            battle.unlink()
            project.save(number, project.row(number), delete=True)
            project = TroopProject(root)
            self.assertTrue(all(number not in game.troops for game in project.games.values()))
            self.assertEqual(struct.unpack_from("<h", project.row(number), 136)[0], 0)
            self.assertEqual(project.next_id(), number + 1)
            self.assertEqual(project.row(1), changed)


if __name__ == "__main__":
    unittest.main()
