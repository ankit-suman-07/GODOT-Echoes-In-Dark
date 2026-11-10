# Agent instructions — Echoes in the Dark

Maintain this existing Godot 2D horror game within the user's current scope. The Git/Godot root is this directory, containing `project.godot`, not the parent workspace. Inspect and extend existing implementations before creating replacements. A plan, asset or README checkmark is not proof of working gameplay or authorization to expand scope.

## Read and resolve evidence

Before implementation read:

- `CODEX-START-HERE.md` and `docs/00-repository-audit.md` for orientation/history.
- `docs/05-requirements-and-acceptance.md`, `docs/06-architecture.md`, `docs/07-development-plan.md` for requirements, architecture and tasks.
- `docs/08-testing-and-evidence.md`, `docs/09-decisions-and-progress.md` for validation and the latest handoff; `docs/10-release-checklist.md` for milestone/release work.
- `docs/11-level-design.md` and the actual `map/game_map.png` before geometry, doors, collectible placement or navigation changes.
- `docs/12-character-lighting-assets.md` and `assets/echoes_assets/docs/ASSET-INTEGRATION.md` before visual changes. Consult README and docs 01–04 for legacy vision/history.

Precedence: current user instructions → approved requirements/recorded decisions → accepted task scope → architecture/testing guidance → legacy design/README. The approved map and docs/11 govern intended room layout, connections and marked object positions; do not replace them with a new layout. Record discrepancies or ambiguous mechanics in docs/09 and docs/11 rather than guessing. Source and dated test evidence establish actual implementation; newer implementation supplements supersede historical audit descriptions, not approved intent.

## Current structure and interfaces

- `project.godot` declares Godot 4.7, GL Compatibility, and `scenes/level.tscn` as entry. Recorded local validation used 4.7.2; recheck installed engine, do not silently migrate.
- Keep flat `scenes/` and `scripts/`. `scripts/level_geometry.gd` constructs TileMapLayer floors, collision walls and occluders at runtime; inspect it as well as the scene before editing geometry. `scripts/level.gd` owns interaction, session key/completion state and restart; no autoload exists.
- Preserve player tank movement/sprint, camera, E interaction, key/door/exit flow, and flashlight toggle unless the approved task changes them. Enemies use proximity chase/idle and expect a sibling named `player`; no patrol currently exists.
- Actor art uses the existing `Sprite2D` paths and `scripts/actor_visual.gd`. Functional lights remain `flashlight`, `light_all_around`, `fire_light` and `SafeRoomGlow`; `scripts/door_shadow.gd` follows door state.
- Battery, note and save-point sprites are markers, not working mechanics. Third battery position, side-door key policy, safety/patrol and save behavior remain unresolved in docs/11. Menu/UI/`scenes/hame_manager.tscn` are placeholders; do not rename or claim them complete incidentally.

## Code, scenes and assets

- Use built-in Godot nodes, signals, resources, physics and typed GDScript where practical. Use tabs, UTF-8/LF, snake_case functions/variables/signals/files, PascalCase types and UPPER_CASE constants. Existing exported `SPEED` is mutable legacy state: avoid incidental renames that break serialization.
- Reuse existing scenes/components. Preserve node paths, exported properties, resource UIDs, collision layers/shapes and signal connections; inspect dependent instances/callers before changes. Prefer signals for new interactions, without unnecessary managers, folder restructuring or abstractions.
- Prefer approved `assets/echoes_assets/` art over legacy placeholders. Keep player, enemy, environment and lighting scale, palette, facing and readability consistent with docs/12. Preserve current `resources/lighting/` beam/glow resources where the pack has no functional equivalent; the flashlight item icon is not a beam. `icon.svg` remains the application icon.
- For visual replacement, change presentation independently of movement, AI, collision, interaction, camera and light-toggle state. Inspect sheet dimensions/frame regions first; SVG imports do not create animations automatically. Supplied enemy direction sheets are identical; current visuals rotate toward motion. Preserve actual PointLight2D illumination and wall/door shadows; decorative sprites do not replace lights or add gameplay.
- No new plugins, frameworks, dependencies, services or downloaded assets without approval. Preserve provenance; supplied artwork is not by itself evidence of distribution rights. Never delete unrelated files or expose secrets.

## Execute and validate

1. Inspect status/diff, task evidence, relevant scripts/scenes/resources and their callers. Preserve unrelated work; never reset, clean or overwrite it.
2. Select a dependency-ready approved task; identify requirement/task/check IDs, acceptance, affected files and assumptions. Make the smallest scoped change; continue routine decisions autonomously. Ask before core design/scope changes, engine migration, dependencies, destructive actions or publication.
3. For implementation changes, run relevant checks from docs/08: headless import/load, existing tests and affected manual regressions. The recorded executable is `/home/ankitsuman/Applications/Godot/godot`; confirm availability. Tests run with `--headless --path . --script` followed by `res://tests/test_level.gd`, `res://tests/test_actor_visuals.gd` or `res://tests/test_lighting.gd`. Bound runs and inspect logs as well as exit codes; editor imports may emit sandbox TCP errors despite exit 0.
4. Headless checks do not prove rendered visuals or full playability. Record manual checks as pending until performed. For documentation-only work verify paths, consistency and `git diff --check`; avoid editor imports or game-file changes. Do not install a test framework merely to validate a change.
5. Update relevant requirements/architecture, docs/07 task status and docs/08–09 evidence/progress. A task or milestone completes only when required acceptance is verified or the user explicitly accepts documented exceptions; never rewrite requirements to match a defect.

## Git, commits and pull requests

- Inspect branch/history before choosing a task branch (`feat/`, `fix/`, `test/` or `docs/`). If required work is on an unmerged feature branch, disclose the dependency and branch from that work; do not silently start from outdated main. Preserve dirty work when switching.
- Commit only when requested or already authorized. Review the full diff and validation first; stage explicit scoped files, excluding unrelated changes, secrets and generated `.godot/` caches. Use focused `feat:`, `fix:`, `test:` or `docs:` commits at validated checkpoints; separate independent visual components when requested.
- Push or open a PR only when authorized; creating commits does not authorize either. Before an authorized PR, check the intended base and dependency diff; describe the concrete change, requirement/task IDs, validation, pending manual checks and blockers. For a dependent branch, identify the parent PR/branch and intended merge order. Do not include unrelated parent work as if newly implemented.
- Do not merge, force-push, rewrite shared history, publish or release without explicit authorization.

## Blockers and handoff

Record blockers in docs/09 with reproduction, command/output, affected acceptance and the smallest decision needed. Continue independent approved work; stop dependent work instead of inventing mechanics. Use docs/09's handoff format: task/status, changed files/behavior, commands/results, manual checks pending, risks/decisions, branch/status/commits (or none), and next eligible task. Do not report unverified gameplay or visuals as tested.
