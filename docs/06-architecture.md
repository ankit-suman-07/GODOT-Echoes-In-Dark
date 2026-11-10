# Current implementation supplement

The original audit below is historical. `project.godot` now launches `scenes/level.tscn`. Existing player/camera/light code is unchanged; existing enemy scenes remain siblings of player. `scripts/level_geometry.gd` builds a floor TileMapLayer/TileSet from asset-pack SVG and generates boundary StaticBody2D colliders, wall sprites and occluders from grid cells at runtime. No autoload added.

`level.gd` owns session key/completion flags, selects nearby interactables through an occlusion ray, handles E interaction, listens for key collection/exit-door unlock and ExitTrigger body entry, and stops actors on completion. R reloads the level. `exit_key.gd` extends existing interactables base; emits `collected` once and removes key. `level_door.gd` uses that same base, a StaticBody2D barrier, separate state sprites, safe-close physics query and `unlock_requested` signal. Level grants only D09 unlock on exit-key ownership; six side doors have no approved unlock policy.

Battery/note/save-point sprites are placement markers, not gameplay systems. Enemy patrol, safety, resource charge, notes content, persistence, menus/pause and catch/loss remain unimplemented. See docs/07 current status and docs/11 spatial register. Tests are built-in SceneTree integration checks in `tests/test_level.gd`.

---

# Architecture

This describes serialized source at audit, not the legacy intended Main/GameManager architecture. `project.godot` has no main scene or autoload. Explicitly run `scenes/level.tscn` for the prototype.

```text
level (Node2D; no script)
├── demo_background (ColorRect)
├── demo_obstacle (ColorRect; visual only)
├── CanvasModulate (dark gray)
├── player (player.tscn / CharacterBody2D / player.gd)
│   ├── Sprite2D (icon.svg)
│   ├── CollisionShape2D (circle, effective radius ~32)
│   ├── flashlight (PointLight2D, lights/3.png, off)
│   ├── light_all_around (PointLight2D, lights/2.png, off)
│   └── Camera2D
├── enemy (enemy.tscn / CharacterBody2D / enemy.gd)
│   ├── Sprite2D + CollisionShape2D (80×80 rectangle)
│   └── DetectionArea / CollisionShape2D (circle radius ~304)
├── enemy_fire (enemy_fire.tscn / CharacterBody2D / enemy_fire.gd)
│   ├── Sprite2D + CollisionShape2D (80×80 rectangle)
│   ├── Area2D / CollisionShape2D (circle radius 192)
│   └── fire_light (PointLight2D, lights/2.png, off)
├── key (key.tscn / Area2D / interactables.gd)
│   ├── Sprite2D (assets/key.png)
│   └── CollisionShape2D (circle radius ~128)
└── prompt (prompt.tscn / CanvasLayer / Label; fixed text)
```

`main_menu.tscn`, `ui.tscn` and `hame_manager.tscn` are disconnected root-only placeholders. No scene transitions exist.

## Responsibilities and interactions

- `player.gd::_physics_process(delta)` polls input, toggles lights, rotates, sets speed and velocity, then `move_and_slide()`. It does not scan interactables or track health, key, battery or terminal state.
- `enemy.gd::_physics_process` directly moves toward sibling player position at speed 200 when `player_chase` is true; otherwise zero velocity. No navigation or LOS ray. Local positions assume a shared parent.
- `enemy_fire.gd` duplicates chase and toggles its own light in overlap callbacks.
- `interactables.gd` exports `prompt_text`, returns it from `get_prompt()`, and defines no-op `interact()`. No callers exist.
- Serialized `DetectionArea.body_entered/body_exited` connect to enemy `_on_detection_area_body_entered/_exited`; fire `Area2D` connects to `_on_area_2d_body_entered/_exited`. Each filters `body.name == "player"`; both cache `$"../player"`. No custom signals or key connections exist. Legacy signal examples are not implemented.

## Input and state

`project.godot` maps physical W/Up→`forward`, S/Down→`back`, A/Left→`left` rotation, D/Right→`right` rotation, Shift→`sprint`, F/Space→`flashlight`. Deadzones are 0.2. No interaction or pause action is configured. Back wins if forward/back both held; opposite rotation inputs cancel.

State is local only: velocity/rotation, light enabled flags and enemy `player_chase`. No persistent state, autoload, inventory, terminal state or pause handling. Physics collision nodes use defaults; level ColorRects add no collision.

## Resources and proposed evolution

Scenes reference existing textures, scripts and PackedScenes via resource paths/UIDs. Enemy sprites come from `sprites/enemy/`; lighting from `assets/lights/`; player uses `icon.svg`. `map/game_map.png`, `assets/treasure.png`, `assets/lights/1.png` have no scene consumers. No audio resources or external packages.

**Proposed, approval required:** reuse the placeholder manager as a minimal session-state owner; connect key/exit/catch events to it and UI by signals, define reset/pause rules, add environment collisions and explicit AI states. Names, signatures and additional file paths are deliberately unspecified until tasks are approved. Do not install a framework or autoload by default. See P01–P05 and the development plan.
