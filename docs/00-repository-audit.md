# Repository audit

Audit date: 2026-11-09. Baseline: `ff57e1e` (`agents: add agents instruction`), clean working tree before documentation edits. Repository lives in `GODOT-Echoes-In-Dark/` beneath the initial workspace. All paths below are relative to the Git root.

## Inventory and evidence

- `project.godot`: format 5, feature version 4.6, GL Compatibility renderer, black clear color, 1500×1500 viewport; no `run/main_scene`, no autoloads. Jolt is configured for 3D but gameplay is 2D.
- `scripts/`: all four scripts are `player.gd`, `enemy.gd`, `enemy_fire.gd`, `interactables.gd`, each with a `.gd.uid` sidecar.
- `scenes/`: all nine scenes are `level.tscn`, `player.tscn`, `enemy.tscn`, `enemy_fire.tscn`, `key.tscn`, `prompt.tscn`, `main_menu.tscn`, `ui.tscn`, `hame_manager.tscn` (actual spelling).
- `assets/`: key and treasure PNGs; `assets/lights/`: 1, 2, 3 PNG light textures. `sprites/enemy/`: ghost and fire PNGs. `map/game_map.png` exists but is not referenced by any scene. All PNGs and `icon.svg` have import sidecars. Treasure and light texture 1 are also unused by scenes.
- `README.md`, legacy `docs/01-project-overview.md` through `docs/04-dev-journal.md`, and an existing generic `AGENTS.md` were read. This phase replaces AGENTS because its document references did not exist and its workflow authorized automatic commits. Legacy docs and README remain unchanged.
- `.editorconfig`, `.gitattributes`, `.gitignore`: UTF-8/LF; ignore `.godot/` and `/android/`. `.DS_Store` files are tracked at root and asset subdirectories. No tests, CI, audio, custom resource files, addons, export presets or dependency manifests were found. `.git/` is repository metadata, not game content.

Recent history: `4e00213` interactable script; `1288576` key; `873fc00` camera; `149e5ac` docs; `87b05a1` fire enemy; `302af18` enemy AI; `f927161` enemy sprite. Commit titles are provenance, not proof of functionality.

## Observed implementation versus claims

| Feature | Static evidence and limits |
| --- | --- |
| Movement/sprint | `player.gd::_physics_process`: rotation plus forward/back movement, speeds 200/500. This is tank-style control, not lateral strafing. Back overrides forward when both held. |
| Flashlight | Same method toggles both child lights together; both start disabled. No charge/drain/recharge. |
| Camera | `player.tscn` has child `Camera2D`; visual behavior untested. |
| Enemy | Both scripts chase on detection-area overlap and stop on exit; otherwise idle. No patrol, FSM, LOS, navigation or catch consequence. |
| Interactions | `interactables.gd::get_prompt` returns text; `interact()` is `pass`. Key instanced, no pickup logic or caller. No interact input action. |
| Prompt | `prompt.tscn` always-visible fixed label says “Press E to pick up Key”; unrelated to proximity or input. |
| Level | Demo ColorRects, dark CanvasModulate, player, two enemies, key and prompt. ColorRect obstacle has no physics collision. No walls, boundaries or exit. |
| Menus/state | Main menu, UI and misspelled manager scenes contain only root nodes; not instanced by level. No global game-state flow. |

README claims LOS and lists progression, notes, audio, safe room and win/lose features; none is implemented. Its AI completion checkmark exceeds proximity-chase evidence. Docs/03 diagrams, managers and example signals are aspirational. Docs/04 includes an explicitly labeled example entry, not a test log. Docs/01 excludes multiple enemies yet level instances two variants; this needs a design decision, not deletion.

## Risks, debt and uncertainties

- Standard project launch has no configured main scene; explicitly opening level is the current entry route.
- Engine disagreement: README 4.6.1, project feature metadata 4.6, previous AGENTS 4.7.2. Installed executable reports 4.7.2; intended support version remains open.
- Enemy `$"../player"` and body-name checks tightly couple instances to scene naming. Standalone enemy execution lacks its expected sibling.
- Two duplicated chase scripts; do not refactor until behavior is specified and protected by checks.
- Default collision layers/masks, no occluders, environment collision or navigation; overlap detection does not establish visibility.
- Mutable exported SPEED is overwritten every physics frame; its inspector value does not configure walk speed.
- Key collision radius (~128) is large relative to its displayed sprite; pickup range is undecided.
- No runtime gameplay evidence, balancing, accessibility assessment, asset licenses or export validation. See docs/08 for exact validation evidence and docs/09 for decisions.
