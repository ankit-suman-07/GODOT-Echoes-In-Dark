# Character and lighting visual integration

Audit baseline: `cd2c61c` on `feat/reference-level`; working tree clean. `feat/character-lighting-assets` branches from that work intentionally, not from older main. Scope: presentation only, separate player/enemy/lighting commits; no push or merge. No controller, AI, collider, input, battery or level-layout redesign.

## Asset mapping and limitations

| Existing scene/node and legacy asset | Replacement / intended treatment |
| --- | --- |
| `scenes/player.tscn` / `Sprite2D`: `icon.svg` | `assets/echoes_assets/characters/player_{up,down,left,right}.svg`, four 32×32 frames per 128×32 sheet; 2× scale (64×64 world footprint) |
| `scenes/enemy.tscn` / `Sprite2D`: `sprites/enemy/enemy_ghost.png` | `assets/echoes_assets/characters/enemy_down.svg`, four frames; 2.5× scale (80×80 footprint) |
| `scenes/enemy_fire.tscn` / `Sprite2D`: `sprites/enemy/enemy_fire.png` | Same enemy sheet with muted warm tint; retain own light and detection behavior |
| Player `flashlight`: `assets/lights/3.png` | `resources/lighting/flashlight_beam.svg` (locally authored vector cone); retain PointLight2D, toggle interface and player-local forward orientation |
| Player `light_all_around`, enemy `fire_light`, level `SafeRoomGlow`: `assets/lights/2.png` | `resources/lighting/radial_glow.tres`, a shared native GradientTexture2D for functional PointLight2D illumination |
| Pack `assets/echoes_assets/items/flashlight.svg` | Item icon, not a beam texture; do not use as Light2D illumination mask or invent a pickup |

No SpriteFrames, AnimatedSprite2D or AnimationPlayer resources existed on these actors. Existing `Sprite2D` node names/types are retained, using `hframes = 4` and a shared presentation script. Player directional sheets differ mainly in face details; gait is a subtle four-frame bob. All four enemy direction files are byte-identical (SHA-256 `5e57cfceaab0178122decfa84192ec67e0ee220fa35e3087e8eb458fdcd5918a`), so switching them cannot show direction. Rotate the single enemy sheet toward motion instead. No unique fire-enemy sheet or dedicated beam/glow asset exists in the supplied pack.

## Presentation behavior

`scripts/actor_visual.gd` reads parent CharacterBody2D velocity and facing, never changes it. Player uses cardinal artwork upright in world space despite tank-body rotation; moving direction selects the sheet, idle turning uses body forward. Thus backing up changes movement artwork while the light retains the controller's forward aim. Enemy art rotates continuously from its down-facing source toward motion and retains its last orientation at rest. Frame 0 is idle; movement cadence follows speed and stops when actor physics processing stops. No collision/node hierarchy/controller changes are needed.

## Verification status

All replacements implemented; automated checks pass on installed Godot 4.7.2: 58 actor-presentation checks, 28 lighting checks and all 72 existing level checks. Main-scene smoke passes. Editor import reports only the known sandbox TCP listener errors (exit 0); no missing script, scene or texture references reported. Full commands/results are in docs/08.

Flashlight source sits 24 units ahead of the player. Its texture offset places the cone apex at that source while the light itself stays near the actor, avoiding the old shadow origin 240 units ahead. The cone points along local -Y and inherits body rotation. Existing light energy, toggle state, parent paths and halo/fire/safe light sizing remain; mask dimensions move from 500 to 512. Soft PCF shadows are enabled, using existing wall occluders and presentation-only `scripts/door_shadow.gd` for closed doors. Opening a door hides its occluder without changing collisions or door logic. Safe Room glow and fire light use the same radial resource with their respective cool/warm colors.

No beam texture was supplied, so the new cone is a small authored SVG with layered shoulders and distance fade; the radial glow is a native resource. No raster image generation, dependency, shader or asset download. Legacy files are retained for history; active actor/lighting scenes no longer reference them. `icon.svg` remains the project application icon.

| ID | Acceptance / automated evidence | Manual verification still pending |
| --- | --- | --- |
| VX01 | Player uses all four sheets, valid frame crops, movement/idle facing and animation stop; body transform and original collider untouched. `tests/test_actor_visuals.gd` | Turn at all headings, forward/back movement, sprint cadence, camera and sprite alignment at runtime |
| VX02 | Both enemies use new animated art, face motion, retain collider/detection geometry and fire-light callbacks. Same test suite | Judge rotated enemy silhouette, diagonal movement, warm fire variant distinction and original chase behavior |
| VX03 | Real PointLight2D nodes use new textures, source/direction follow body, injected input toggles both player lights, gradient boundaries and door occlusion states correct. `tests/test_lighting.gd` | Rendered beam aim, softness/range/readability, wall shadows and opening/closing door shadows in light/dark areas |

No manual visual or full gameplay playthrough was performed; headless tests verify resources/state/geometry, not rendered aesthetics. Existing missing patrol/battery/save mechanics remain unchanged, as recorded in docs/07 and docs/09.
