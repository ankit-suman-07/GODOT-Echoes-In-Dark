# Echoes in the Dark

A 2D top-down horror game built with Godot and GDScript. Explore a small facility, avoid its creatures, find the exit key, and escape.

**Status:** In development. The level, basic interactions, and escape flow are implemented; several survival and progression systems remain unfinished. This is a learning and portfolio project.

## Implemented

- Nine-area facility based on the [reference map](map/game_map.png): Security Room, Main Hall, Storage Room, Electrical Room, Utility Room, Observation Room, Safe Room, Exit Corridor, and Exit.
- Tiled floors, collision walls, connected passages, and door boundaries.
- Tank-style movement, sprinting, and a following camera.
- Animated player and enemy artwork from the supplied minimalist asset pack.
- Toggleable flashlight and surrounding light, with wall and door shadows.
- Two enemies with proximity detection and direct chase/idle behavior.
- Nearby E interaction, openable doors, once-only exit-key pickup, a keyed exit door, completion trigger, and restart after escape.
- Automated level, actor-visual, and lighting checks.

Implementation does not imply complete manual gameplay or visual verification. See [testing and evidence](docs/08-testing-and-evidence.md) for recorded results and limitations.

## Run locally

The project declares **Godot 4.7** with the **GL Compatibility** renderer. Recorded validation used Godot **4.7.2**. No third-party plugins or package installation are required.

1. Open Godot's Project Manager and import this folder's `project.godot`.
2. Let Godot import the supplied assets.
3. Press **F6** to run the current level scene, or **F5** to run the configured main scene, `scenes/level.tscn`.

From the folder containing `project.godot`, if your Godot executable is on PATH:

```bash
godot --path . --editor
godot --path .
```

Replace `godot` with your executable path if necessary. Export presets and packaged platform builds are not supplied.

## Controls

| Input | Action |
| --- | --- |
| W / Up | Move forward along the player's facing |
| S / Down | Move backward |
| A / Left | Turn left |
| D / Right | Turn right |
| Shift | Sprint |
| F / Space | Toggle flashlight and surrounding light |
| E | Interact with a nearby door or exit key |
| R | Restart after escaping |

Left/right turn the player rather than strafe. The flashlight follows body facing; movement artwork follows travel direction when backing up.

## Incomplete systems and known limitations

- Enemy patrol, enemy line-of-sight checks, and catch/loss handling are not implemented. Interaction occlusion checks are separate from enemy detection.
- Battery depletion/recharge, readable story notes, save behavior, and Safe Room protection are not implemented. Their placed sprites are visual markers.
- The map summary calls for three batteries, but only two locations are identified and placed; the third location needs a design decision.
- Six side-room doors remain locked pending their key rules. The exit key currently unlocks the final exit door.
- Main/pause menus, audio, release exports, and full manual playtesting remain unfinished.

See [requirements](docs/05-requirements-and-acceptance.md), [level design](docs/11-level-design.md), and [decisions/progress](docs/09-decisions-and-progress.md) before implementing missing mechanics.

## Validation

Run from the project root using your Godot executable:

```bash
godot --headless --path . --editor --quit
godot --headless --path . --script res://tests/test_level.gd
godot --headless --path . --script res://tests/test_actor_visuals.gd
godot --headless --path . --script res://tests/test_lighting.gd
godot --headless --path . --quit-after 120
```

Import can write generated files; inspect Git status afterward. Check logs as well as exit codes: restricted environments have produced editor TCP listener errors despite exit code 0. Headless checks do not verify rendered appearance or a complete interactive playthrough. Detailed procedures and manual checklists are in [docs/08](docs/08-testing-and-evidence.md).

## Repository guide

| Path | Purpose |
| --- | --- |
| `scenes/` | Level, actors, doors, pickups, UI, and placeholder scenes |
| `scripts/` | Controllers, interactions, runtime geometry, and presentation |
| `assets/echoes_assets/` | Minimalist characters, environment, items, and UI artwork |
| `resources/lighting/` | Beam texture and native radial glow resource |
| `map/` | Visual layout reference |
| `tests/` | Dependency-free Godot integration checks |
| `docs/` | Design, implementation plans, decisions, and validation evidence |

Floors and walls are generated at runtime by `scripts/level_geometry.gd`; play the level to inspect the complete generated layout.

## Documentation

- [Codex start guide](CODEX-START-HERE.md) and [agent instructions](AGENTS.md)
- [Repository audit](docs/00-repository-audit.md)
- [Requirements and acceptance](docs/05-requirements-and-acceptance.md)
- [Architecture](docs/06-architecture.md)
- [Development plan](docs/07-development-plan.md)
- [Testing and evidence](docs/08-testing-and-evidence.md)
- [Decisions and progress](docs/09-decisions-and-progress.md)
- [Release checklist](docs/10-release-checklist.md)
- [Level design](docs/11-level-design.md)
- [Character and lighting integration](docs/12-character-lighting-assets.md)

Original vision and historical material remain in [project overview](docs/01-project-overview.md), [game design](docs/02-game-design.md), [technical design](docs/03-technical-design.md), and [development journal](docs/04-dev-journal.md). Their feature claims should be checked against current source and newer implementation records.

## License

Developed for learning and portfolio use. No repository-wide license file is currently supplied; this statement does not grant redistribution rights. Asset provenance and distribution permissions must be established before release.
