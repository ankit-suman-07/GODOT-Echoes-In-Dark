# Current implementation supplement

The original audit below is historical. The approved orientation is now Security/start at bottom and Exit at top: reflected rectangles in `scripts/level_geometry.gd` and explicit world placements in `scenes/level.tscn`, not a negative parent scale. Geometry generation, actor/local visual and light transforms, interactions and camera follow are unchanged. See docs/11 for transform/positions and `tests/test_level_orientation.gd` for regression coverage.  Actor visuals are now asset-pack four-frame Sprite2D sheets driven by presentation-only `scripts/actor_visual.gd`; PointLight2D nodes use authored beam/native radial resources, and closed doors have state-following `scripts/door_shadow.gd` occluders. Details and visual limitations: `docs/12-character-lighting-assets.md`. Controllers/AI and colliders are unchanged.  `project.godot` now launches `scenes/level.tscn`. Existing player/camera/light code is unchanged; existing enemy scenes remain siblings of player. `scripts/level_geometry.gd` builds a floor TileMapLayer/TileSet from asset-pack SVG and generates boundary StaticBody2D colliders, wall sprites and occluders from grid cells at runtime. No autoload added.

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

## EA01 implementation supplement

Both existing enemy scripts retain separate overlap callbacks and local player_chase state. Targets are acquired from body_entered (existing player name filter), cleared on matching body_exited or invalid/queued deletion; movement uses global positions. _ready duplicates the existing circular shape per instance and applies exported detection_radius (250). SPEED defaults to 150. Existing node paths, layers/masks and signal connections are preserved. Level adds enemy_2 from enemy.tscn at (1712,2304); the existing completion actor list includes it. No manager, navigation, player or visual controller change.

## EA02 chase stopping clearance

Both enemy scripts retain detection/target/fire-light state and move_and_slide. While detected, remaining travel is target center distance minus stopping_distance (default 96); velocity is zero within 0.01 of that threshold, otherwise capped at min(SPEED, remaining / delta). This clears the player radius 32 plus the enemy rectangle's half diagonal (~56.57), leaving ~7.4 units at the worst angle. No collision masks, player controller or scene changes. Player_chase continues to represent detection even when proximity stops motion; target exit still clears it.

## PC01 control supplement

player.gd reuses left/right/forward/back via Input.get_vector for world-axis movement and bounded diagonals; existing SPEED assignment remains 200/500. get_global_mouse_position minus body global position drives global_rotation with +PI/2 for the authored -Y beam. Zero aim vector retains rotation. Existing child PointLight2D transforms/resources and default Camera2D.ignore_rotation=true remain. Legacy exported TURN_SPEED is retained for serialized compatibility, unused by immediate mouse aim. No InputMap or node-path changes.

actor_visual.gd adds optional facing_follows_body (false by default); only player.tscn enables it. Cardinal sheets follow body aim while movement velocity still drives animation cadence. Enemy rotate_to_motion behavior stays unchanged. Interactions use distance/occlusion, independent of facing. Historical tank-control descriptions above are superseded by PC01.
