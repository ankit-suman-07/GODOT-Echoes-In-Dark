# Reference level design

Status: structural geometry, basic doors/key/escape implemented; **full gameplay incomplete**. Original visual review: 2026-11-09. See implementation supplement below; original registers remain intended design. The user designates [map/game_map.png](../map/game_map.png) authoritative for intended room layout, connections and marked object locations, despite its internal “MAP EXAMPLE” caption. Mechanics not specified by the image remain decisions, not inferred requirements. **The latest user-approved vertical correction below supersedes the original image’s compass orientation: start at bottom, escape at top.**

Source image: 1402×1122 pixels; SHA-256 `89089e9ab5a4ab74a3fc954a0de798ecd3251ddc776e5ef99841734fd987f790`. Coordinates in the preserved original-image registers below are approximate image-pixel centers from top-left, x right/y down, generally within ~10 pixels. They are reference anchors, **not Godot world coordinates**, scale, tile size or collider dimensions. Legend/sidebar icons are excluded from counts. Preserve this image; approve any design departure explicitly.

## Approved runtime orientation — Security bottom, Exit top

The user explicitly corrected vertical orientation after the level/visual implementation. Preserve the original image as the source of room topology, proportions and object associations, but apply the approved reflection to all spatial coordinates. Do not restore its original top-start orientation or flip the image’s labels into the game.

Reflection: **world `(x, y)` → `(x, 3328 − y)`** about y=1664. Existing floor bounds y=96…3232 are preserved. For 32-unit cells use `cell_y′ = 103 − cell_y`; rectangle `(x, y, width, height)` becomes `(x, 104 − y − height, width, height)`. Image ×3/grid-snapped calibration is followed by this reflection; image pixels are not themselves world coordinates. All room sizes, X coordinates, connections, door rules, actor hitboxes and object counts remain unchanged.

| Runtime area | Current location / connections |
| --- | --- |
| Security Room | Southernmost/bottom, world y=2688…3232. Player `(1713,2881)` faces up; northern neck/D01 leads into Hall |
| Main Hall | Central joined passages (grid rects `(41,70,25,5)`, `(50,62,7,15)`, `(32,48,41,15)`); D01 toward bottom, D08 toward top |
| Storage Room | Lower-left branch, y=2112…2624; east D02 and north D03 connect to Hall |
| Electrical Room | Lower-right branch, y=2112…2624; west D04 and north D05 connect to Hall |
| Utility Room | Upper-left branch, y=1344…2016; east D06 connects to Hall |
| Observation Room | Upper-right branch, y=1344…2016; west D07 connects to Hall |
| Safe Room | Above Hall, y=928…1472; south D08 leads to Hall, north C01 to Corridor |
| Exit Corridor | Above Safe Room, y=544…896; south C01 and north D09; exit key remains before the locked exit |
| Exit | Northernmost/top, y=96…512; southern D09 from Corridor; E01/trigger `(1716,232)` |

Progression is now **upward**: Security → Hall → Safe Room → Exit Corridor/key → Exit. Room adjacency and optional locked branches are unchanged. D01/D08 are openable, D02–D07 remain locked under the existing unresolved key policy, and D09 still unlocks with the exit key. C01 remains an opening without a new door mechanic.

```mermaid
flowchart BT
  Security[Security / Start at bottom] --- Hall[Main Hall]
  Hall --- Storage[Storage]
  Hall --- Electrical[Electrical]
  Hall --- Utility[Utility]
  Hall --- Observation[Observation]
  Hall --- Safe[Safe Room]
  Safe --- Corridor[Exit Corridor / Key]
  Corridor --- Exit[Exit at top]
```

| Placed node(s) | Reflected world position |
| --- | --- |
| D01 | `(1712, 2464)` |
| D02 | `(1296, 2320)` |
| D03 | `(1152, 2064)` |
| D04 | `(2128, 2320)` |
| D05 | `(2240, 2064)` |
| D06 | `(1008, 1632)` |
| D07 | `(2352, 1632)` |
| D08 | `(1728, 1504)` |
| C01 | `(1713, 928)` |
| D09 | `(1728, 528)` |
| B01 | `(951, 2350)` |
| B02 | `(2487, 2323)` |
| N01 | `(675, 1582)` |
| N02 | `(1497, 1780)` |
| N03 | `(2682, 1582)` |
| key | `(2100, 709)` |
| S01 | `(1716, 1066)` |
| enemy | `(2100, 1792)` |
| enemy_fire | `(1152, 1792)` |
| SecurityDesk | `(1450, 2998)` |
| ElectricalTerminal | `(2780, 2528)` |
| SafeRoomGlow | `(1716, 1218)` |
| E01 and ExitTrigger | `(1716,232)` |

`scenes/level.tscn` contains the reflected placed nodes and Hall label rectangle. `scripts/level_geometry.gd` contains reflected room/connection rectangles; its unchanged generator rebuilds floors, colliders and occluders. No negative scale is used. Actor/prop textures, local animation transforms, door sizes, light textures/local aim and screen-space UI remain upright. Room labels anchor inside the reflected rooms. Player instance rotation is 0 instead of PI, so forward W/Up initially moves up, S/Down initially moves down, and the flashlight aims up. Existing tank turning remains unchanged; no controller redesign.

No NavigationRegion2D, NavigationAgent2D, patrol route or custom Camera2D limits exists to reflect. Existing camera follows the repositioned player with rotation ignored; unchanged global bounds require no limit adjustment. Patrol/safety/save/battery gaps remain exactly as before this correction.

**LD07 acceptance:** Security spawn lies below Exit; every existing floor/collider/node is vertically reflected with dimensions and X preserved; original door gating and key-to-exit route remain; all text/visual transforms stay upright; forward/back input, follow camera, lights and current chase work at the new positions. Verify with `tests/test_level_orientation.gd` (63 checks), the existing level/actor/lighting suites, and manual upward-route/visual/camera playtesting. Automated verification passes; rendered aesthetics and a full manual playthrough remain pending (docs/08).

## Original-image room layout and connections (historical orientation)

The Main Hall is a continuous cross-shaped circulation space, including the upper horizontal passage and the central north/south spine. Small outlined recesses flanking that spine have no room labels; do not invent additional rooms or passages through them. No direct Storage–Utility or Electrical–Observation connection is depicted.

| Area | Relative layout / intended purpose | Visible connections |
| --- | --- | --- |
| Security Room / Start Area | North; player entry and orientation. Green start at (571,149); facing unspecified | Southern neck opens onto north Main Hall via D01 |
| Main Hall | Central circulation/exploration hub; note N02 | Security, both Storage entrances, both Electrical entrances, Utility, Observation, Safe Room |
| Storage Room | Northwest; battery B01 | East wall D02 and south wall D03 both lead into Main Hall |
| Electrical Room | Northeast; battery B02. No power puzzle is specified | West wall D04 and south wall D05 both lead into Main Hall |
| Utility Room | Southwest side of hall; note N01 | East wall D06 to Main Hall |
| Observation Room | Southeast side of hall; note N03 | West wall D07 to Main Hall |
| Safe Room | South of Main Hall; blue outlined rest area and marked save point S01 | North D08 to Main Hall; apparent south opening C01 to Exit Corridor |
| Exit Corridor | South of Safe Room; contains exit key K01 on right | North C01 to Safe Room; south D09 to Exit |
| Exit | Southernmost room/area; green exit sign E01 | North D09 from Exit Corridor; no further exterior geometry shown |

```mermaid
flowchart TD
  Security[Security Room / Start] --- Hall[Main Hall]
  Hall ---|D02 + D03 locked| Storage[Storage Room]
  Hall ---|D04 + D05 locked| Electrical[Electrical Room]
  Hall ---|D06 locked| Utility[Utility Room]
  Hall ---|D07 locked| Observation[Observation Room]
  Hall ---|D08 openable| Safe[Safe Room / Save Point]
  Safe ---|C01 apparent opening: confirm type| Corridor[Exit Corridor / Exit Key]
  Corridor ---|D09 green threshold: confirm lock| Exit[Exit]
```

Diagram edges show adjacency, not initial traversability. D01 is the Security–Hall openable threshold. Both connections per upper side room must be retained; do not collapse them into one doorway.

## Original-image door and opening register

Legend: red = “Locked Door (Requires Key)”; tan = “Door (Can Open)”; white = wall/boundary. Red does not identify which key, whether keys are consumed, or whether doors unlock together. Do not assume the exit key opens every red door.

| ID | Boundary / image anchor | Type from image |
| --- | --- | --- |
| D01 | Security southern neck ↔ north Hall, (~570,293); tan marks at both jambs | Openable threshold; two jamb marks treated as one passage, not two independent doors |
| D02 | Storage east ↔ upper Hall, (430,335) | Red locked door |
| D03 | Storage south ↔ west Hall branch, (378,427) | Red locked door |
| D04 | Electrical west ↔ upper Hall, (709,335) | Red locked door |
| D05 | Electrical south ↔ east Hall branch, (746,427) | Red locked door |
| D06 | Utility east ↔ Hall, (335,565) | Red locked door |
| D07 | Observation west ↔ Hall, (787,565) | Red locked door |
| D08 | Hall south ↔ Safe Room north, (572,621) | Tan openable door |
| C01 | Safe Room south ↔ Corridor north, (~571,803) | Apparent opening with faint tan segments; exact door type/width unclear. Preserve adjacency, confirm treatment before building it |
| D09 | Corridor south ↔ Exit north, (572,936) | Green highlighted threshold, not red/tan legend type. Flow says unlock exit; locking implementation must be clarified |

Six clear red markers and two clear tan thresholds; C01 is not counted as a confirmed third openable door. Door swing, initial open/closed state for tan doors, use from either side, interaction distance and enemy operation rules are unspecified.

## Original-image object register and counts

| ID | Marker / intended room and position | Count / certainty |
| --- | --- | --- |
| START | Green circle inside Security Room, (571,149), below room label | 1 clear start; orientation unknown |
| B01 | Storage, left-central interior, (317,326) | 1 visible battery marker |
| B02 | Electrical, central-right interior, (829,335) | 1 visible battery marker |
| B03 | No identifiable third room marker | Summary says batteries: 3; third position unresolved. Do not place arbitrarily or assume stacks |
| N01 | Utility, lower-left interior, (225,582) | 1 story note |
| N02 | Main Hall, left of center, (499,516) | 1 story note |
| N03 | Observation, lower-central interior, (894,582) | 1 story note |
| K01 | Exit Corridor, right side, (700,873) | 1 exit key |
| S01 | Safe Room, lower-central interior, (572,754), blue circled S | 1 save-point marker; behavior conflicts with existing scope |
| E01 | Exit, lower-central interior, (572,1032) | 1 exit destination sign; not a collectible |

Visible collectible total: 2 battery markers + 3 notes + 1 key = 6. Summary target total: 3 batteries + 3 notes + 1 key = 7; one battery location is unallocated. No enemy spawn, patrol waypoint, extra key, switch, medkit or battery in Security/Safe Room is marked. Asset availability does not add objects to this register.

## Exit progression, patrol and safety

Image flow: start → explore/collect batteries and notes → find exit key → unlock exit → escape. Geometric route to key/exit: Security → Main Hall → Safe Room → Exit Corridor (K01) → Exit. Side rooms are branches; the map does not establish that every collectible is mandatory. No dependency on powering Electrical Room, collecting notes or unlocking all side doors is shown.

The key is in the corridor **before** the final Exit threshold. Do not move it behind a gate it must unlock, relocate it into Storage, or add a puzzle to force exploration. Approve D09's lock type and six side-door key requirements before progression implementation; only one key is marked.

The map note says the enemy patrols throughout the facility. It specifies no route, spawn, enemy count, dwell times, door access or LOS. Intended navigation must respect room walls, door states and confirmed connections; closed locked doors must not become navigation shortcuts. Proposed enemy exclusion from Safe Room follows docs/05 R10, but conflicts with a literal “throughout” interpretation. Resolve both Safe Room thresholds, chase cancellation/return behavior and corridor/exit access before patrol implementation. Do not infer teleportation, wall crossing, automatic door opening or new enemies.

Safe Room is visually identified and marked “Save Point”; it supports the legacy rest/safety intent. Invulnerability, exclusion, resource refills, autosave/manual save, respawn and persistence across launches are **not specified**. Keep the marker's intended location in planning; no working save system is authorized. Docs/01 excludes saves and docs/05 P04 proposes session-only state. Resolve this conflict before enabling any save behavior.

## Original audit comparison (historical; see implementation supplements)

- `scenes/level.tscn` contains only demo ColorRects, dark CanvasModulate, player, two enemy instances, key and fixed prompt. No named map rooms, physical walls, doors, navigation, save point, exit, batteries or notes. Map texture is not referenced by scenes.
- Current player position (758,764) and key (150,135) are prototype world positions and do not correspond to map anchors. No image-to-world transform exists.
- `scripts/player.gd` has movement/sprint/light input only; `scripts/interactables.gd::interact()` is a stub. Preserve these foundations while planning future pickup/door integration.
- `scripts/enemy.gd` and `scripts/enemy_fire.gd` use direct proximity chase/idle, not facility patrol or door-aware navigation. Both require a sibling named `player`; room organization must preserve or deliberately adapt this dependency after approval.
- Docs/01–02 support escape, batteries, notes, patrol and safety but provide no room geometry. This document/map now supplies intended spatial design. Docs/06 describes actual architecture, not this future layout.
- Existing `assets/echoes_assets/docs/ASSET-INTEGRATION.md` describes available art and proposed integration, not functioning doors/items. Its integration/commit instructions do not override this documentation-only scope or the no-commit instruction. Its colored keys/medkit do not authorize additional mechanics.
- Working tree already has a user modification declaring Godot feature 4.7 in `project.godot` and an untracked asset pack; older audit's 4.6 observation is historical. These changes were preserved; this review does not approve an engine migration or asset integration.

## Unresolved discrepancies / decision gates

| ID | Decision needed | Dependent work |
| --- | --- | --- |
| LD-Q01 | Third battery position/count discrepancy: identify it or explicitly revise summary | Final placement/count acceptance |
| LD-Q02 | Which key opens each of D02–D07? Are other keys intended? Consumption/reset rules? | Side-door behavior, branch reachability |
| LD-Q03 | C01 opening/door treatment and D09 lock/exit trigger behavior | South connections and escape integration |
| LD-Q04 | Save point versus no-save scope; precise safety and enemy behavior at both Safe Room boundaries | Save behavior and patrol exclusion |
| LD-Q05 | World scale, passage clearances, enemy spawn/count/routes and door permissions | Geometry calibration and AI; preserve player/enemy hitboxes unless separately approved |

## Level requirements and acceptance

LD IDs supplement docs/05, not implemented features. LV checks below are future manual/static procedures, not executed tests. Use docs/08 reporting format and V01–V06 regressions after implementation approval.

| Requirement | Acceptance criteria | Verification |
| --- | --- | --- |
| LD01 — topology (R01, N01) | All nine areas in relative map positions, every registered connection retained, no unmarked cross-wall route; scale documented, wall/door clearances fit existing bodies | LV01: compare editor top-down view/overlay and room/door inventory against image; walk every permitted edge and probe walls/bounds; V01–02 |
| LD02 — spawn/doors (R01, R04–05) | Start maps to Security anchor; D01–D09/C01 each accounted for; six red locks preserved; unresolved C01/D09 semantics decided before implementation; no wall tunneling or door blockage | LV02: spawn fresh; inspect threshold types/states; traverse open doors, test blocked locks from both sides under approved rules; V02–04 |
| LD03 — placements (R03–05, R09) | B01/B02, N01–N03, K01 match room/relative anchors; third battery resolved explicitly; S01 location retained without invented save behavior; one exit destination | LV03: inspect instance counts/positions against register; collect once, test prompts/ranges and fresh reset; V03, V06. Final battery count cannot pass with LD-Q01 open |
| LD04 — progression (R05, R08) | Fresh start can reach corridor key via confirmed connections and escape only after approved unlock; side-door requirements produce no self-lock; no new mandatory collectible gates | LV04: keyless exit rejection, key pickup/unlock/win, restart; check each side-door key route for circular dependencies; V04 |
| LD05 — patrol/safety (R06–07, R10) | Approved route reaches permitted facility areas, respects walls and door state; approved Safe Room behavior holds at north and south boundaries | LV05: patrol/chase/loss and closed/open door tests, approach both safety thresholds, test return/reset; V05–06 |
| LD06 — preserve baseline (R01–02, N02) | Movement, sprint, camera, lights, scene resources/signals retained; no incidental framework, save system or asset migration | LV06: scoped diff, V01–02 plus affected V03–06; record manual results separately from engine smoke |

Implementation tasks and ordering are in docs/07. This review performed visual inspection, source/document comparison and documentation checks only; no runtime tests or level implementation.

## Implementation supplement — `feat/reference-level`

Before the vertical correction, image ×3 approximated world coordinates, snapped to a 32-unit floor grid (each cell corresponds to 10⅔ image pixels). `scripts/level_geometry.gd` records eight peripheral room rectangles, three joined Main Hall rectangles and ten connection rectangles. Boundary colliders/occluders derive from the union, preserving both upper side-room entrances; actor hitboxes unchanged. Minimum door span 128 units, 120 clear between wall faces. Geometry is constructed at runtime; the editor shows authored actors/doors/markers but generated floors/walls require Play/Remote inspection.

`scenes/level.tscn` now places registered objects and doors; two confirmed batteries and all three notes are visual-only sprites, S01 is a terminal marker. No save behavior, third battery or extra keys were invented. Existing enemies remain direct-chase actors in Hall, without patrol/safety enforcement. Safe Room glow is visual, not a safety guarantee. These are explicit gaps, not completed requirements.

D01/D08 can open/close via E. D02–D07 remain red/locked, awaiting LD-Q02. D09 now uses the exit key and an escape trigger as required by R05 and the user's implementation instruction; key is retained in session state. C01 has connected floor geometry with no door behavior; this does not resolve LD-Q03's door-type question. LD-Q01, LD-Q02, C01 semantics, safety/persistence and enemy navigation policy remain open. The user's save-point request authorizes that feature in principle, superseding the older exclusion, but session checkpoint versus persistent-save rules still need input.

Automated subset evidence: docs/08; task states: docs/07. No manual map alignment, aesthetic or full player-input playthrough verified.

## EA01 spawn supplement — 2026-11-15

User explicitly authorizes 3–5 enemies if fewer exist. Retained both reflected Hall spawns; added enemy_2 at (1712,2304) in the lower Hall passage using enemy.tscn, away from the Security spawn and D01 barrier. No topology/door/object-marker change. Three enemies remain direct proximity chase/idle with physical wall collisions; patrol/LOS/door access/safety decisions in LD-Q04–05 remain unresolved. Automated floor containment and completion-stop checks pass; manual crowding/doorway and route balance checks pending.
