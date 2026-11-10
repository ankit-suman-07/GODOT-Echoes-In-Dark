# Development plan

The latest user instruction approves reference-level implementation and focused commits (no push). Current status is recorded below; unresolved gameplay decisions remain blocked. Original task tables define acceptance, not current completion. Complexity: S = one localized change; M = several coupled edits; L = multiple gameplay paths. Baseline functionality must be verified and preserved, not reimplemented. “Done” requires acceptance evidence, documentation updates and no unresolved relevant regressions. Commits below are suggested checkpoints only; no commits without instruction.

| Milestone / task | Scope and files (new files explicitly proposed) | Dependencies | Acceptance / verification | Size | Suggested branch; checkpoint |
| --- | --- | --- | --- | --- | --- |
| M0 / D00 — documentation complete | AGENTS, start guide, docs/00 and 05–10 | Repository inspection | Links/IDs consistent; only Markdown diff; evidence in docs/08 | M | `docs/repository-audit`; `docs: document audited baseline` |
| M1 / T01 — establish runnable baseline | `project.godot`, existing scenes; record supported engine in docs/09 | Implementation approval, engine and P01 decision | N01: approved engine imports cleanly; explicit level runs; baseline V02 results recorded; configure entry only as approved; V01 | S | `fix/runnable-baseline`; `fix: establish project entry` |
| M1 / T02 — finish interaction and key | `scripts/player.gd`, `scripts/interactables.gd`, `scenes/key.tscn`, `scenes/prompt.tscn`, input map; proposed specialized key/session script if needed | T01; P02/P04 decisions | R04: proximity prompt, one pickup, key flag, out-of-range rejection; V03 and V02 regression | M | `feat/key-interaction`; `feat: complete key pickup` |
| M2 / T03 — minimal session lifecycle | `scenes/hame_manager.tscn`, `scenes/ui.tscn`, `scenes/main_menu.tscn`, level/project; proposed scripts for these roots | T02; P04 and catch/terminal policy decisions | R08: start/pause/resume and fresh restart/menu reset reliably; implement terminal entry points for T04/T06; V04 transition checks | M | `feat/session-flow`; `feat: add session lifecycle` |
| M2 / T04 — complete key-to-exit loop | `scenes/level.tscn`, existing key/manager/UI; proposed exit scene/script | T03, L02–L03; LD-Q03 exit decision | R05/LD04: corridor key precedes final exit, locked before key, win once after key, restart resets; LV04 and V03–04 | M | `feat/escape-loop`; `feat: complete escape progression` |
| M2 / T05 — build map collision layout | `scenes/level.tscn`, reference `map/game_map.png` and docs/11 (not optional design); proposed static collision geometry | T01, L01; LD-Q05 scale/clearance decision | LD01/LD06: all nine areas and map openings, no extra cross-wall routes, solid walls/bounds; LV01/LV06 and V01–02; foundation only, no functional locks/pickups | M | `feat/level-collisions`; `feat: add playable level layout` |
| M3 / T06 — finish existing enemy behavior | Both enemy scripts/scenes, level and session owner | T05, L03, L05; P03/LD-Q05 enemy count, patrol/LOS/catch decisions | R06–07: patrol/chase/return, wall occlusion, catch loss once, reset; V05 and V04, preserve fire-light behavior if retained | L | `feat/enemy-lifecycle`; separate `feat: add enemy states` and `feat: connect catch to loss` checkpoints |
| M4 / T07 — battery loop | Player, UI, interactables; proposed battery scene/script | T06, L04; approved charge/drain/recharge values | R02–03: depletion/recharge bounded and reset, repeated toggles safe; V06 plus V02–05 regression | M | `feat/flashlight-resources`; `feat: complete battery loop` |
| M4 / T08 — notes and safe room | Level, prompt/UI, enemy behavior; proposed note/room assets or scripts | T07, L04–L05; content and safe-room rules | R09–10: readable/dismissible notes and safe entry/exit with enemy exclusion; V06 and V05 | M | `feat/exploration-content`; separate notes and safe-room checkpoints |
| M5 / T09 — audio and presentation | Level/UI and approved audio assets (proposed); avoid unapproved downloads | T08; asset provenance, audio policy | R11/N03: audible clean cues, no restart duplication, readable prompts and UI; V06–07 | M | `feat/atmosphere`; `feat: add approved audio cues` |
| M6 / T10 — release verification | Docs/10, approved export configuration (proposed), focused tests (proposed) | T09, L06; target/platform/license decisions | N01–03: full regression V00–08, clean target export run and all release gates met | L | `test/release-readiness`; `test: record release evidence` |

D00 is the only completed task in this phase; completion means documentation and recorded checks, not gameplay approval. Add focused automated checks alongside approved changes when they protect state transitions, once-only events or resets; no test framework currently exists. Split M/L tasks further before implementation if their acceptance cannot be reviewed in one change. Prefer completing T02–T06 before new resource/content mechanics.

## Map alignment workstream

Authority: `map/game_map.png` and docs/11. Spatial layout is now supplied, but unresolved mechanics remain gated. D11 (map documentation) is complete; see current status below for implemented subsets. These tasks refine, rather than duplicate, T05/T04/T06/T07/T08. T05 now runs before final T04 integration; prototype interaction/session work T02–T03 may proceed separately once approved. No task may invent a third battery, extra keys, or save behavior.

| Task / scope | Files and dependencies | Acceptance / verification | Complexity | Suggested branch; commit checkpoint (only if requested) |
| --- | --- | --- | --- | --- |
| L01 — resolve map decisions and calibrate geometry | docs/11, docs/09; reference image; implementation approval and T01. Proposed coordinate/scale specification recorded in docs before geometry | Resolve LD-Q05 scale and passage clearance; annotate unresolved LD-Q01–04; confirm room/door register and body sizes without silently resizing hitboxes; static LV01/LV06 review | S | `docs/level-calibration`; `docs: define map coordinate mapping` |
| L02 — align starting point and threshold anchors | `scenes/level.tscn`; proposed markers/door instances; T05 geometry and L01. C01/D09 final type waits for LD-Q03 | Security spawn and D01–D09/C01 accounted for; preserve two entrances per Storage/Electrical; unresolved semantics remain blocked, not functional placeholders claimed done; LD01–02, LV01–02, V01–02 | M | `feat/map-anchors`; `feat: align map spawn and thresholds` |
| L03 — implement map door behavior | Level, player/interactables and session integration; proposed door scene/script; L02, T02–T03, LD-Q02–03 decisions | Six red locked doors plus openable thresholds follow approved key/door rules; corridor key is reachable before exit unlock; no extra keys or self-lock; LD02/LD04, LV02/LV04, V01–04 | M | `feat/map-doors`; `feat: implement approved map door rules` |
| L04 — align collectibles and exit destination | Level, key scene; proposed battery/note instances and exit trigger; L02, T02, LD-Q01 resolved before final battery placement; behaviors remain T07/T08/T04 | B01/B02 and approved B03, N01–N03, K01, E01 match register/counts; no duplicate prototype key; LV03 static placement plus V01; functional LV03/LV04 only after T04/T07/T08 | M | `feat/map-placements`; `feat: align reference collectible positions` |
| L05 — define and enforce safe boundaries | Level and enemy scripts, proposed safety/navigation constraints; T05/L02/L03; LD-Q04–05 resolved | S01 position recorded; approved safety at both north/south thresholds; no save implementation unless separately approved; LD05 boundary portion: inspect exclusion geometry and test both entrances with existing chase; LV05 boundary checks/V05–06; full patrol acceptance belongs to T06/L06 | M | `feat/map-safe-room`; `feat: enforce approved safe-room boundaries` |
| L06 — verify complete reference level | Level-related scenes/scripts and docs/08–11; T04/T06–T08, L03–L05 complete | Room/edge/door/item inventory matches image and approved discrepancies; full start/key/escape and patrol/safety/reset checks; LV01–06, V01–06 all recorded; preserve baseline; no manual pass inferred from headless load | M | `test/reference-level`; `test: record map alignment evidence` |

Dependency sequence: T01 → L01 → T05 → L02; T02 → T03 can run independently of geometry. L03 joins L02 + T03; L04 joins L02 + T02; T04 joins T03 + L02 + L03; L05 joins L02/L03 + resolved safety/door policies; T06 follows L03/L05, then T07/T08 complete placed content; L06 gates T10 alongside T09. L04 does not claim functional batteries/notes before T07/T08. Save implementation is excluded from this sequence pending a separate scope decision/task.

## Implementation status — reference-level branch

Baseline `1015c12`, branch `feat/reference-level`. This is a usable geometry/interaction/escape foundation, **not a complete playable release**. Automated evidence is in docs/08. All visual/manual acceptance remains pending.

| Tasks | Current status / evidence / remaining work |
| --- | --- |
| T01 | Main scene configured to level on existing 4.7 metadata; runtime smoke passes on installed 4.7.2. Manual V02 pending; no engine migration. |
| L01 | Coordinate calibration implemented: image ×3, snapped to 32-unit grid. Minimum clear doorway 120 units after wall thickness, fitting existing 64-diameter player and 80×80 enemies. Other LD-Q05 gameplay decisions remain blocked. |
| T05 | Nine-area structural layout implemented with TileMapLayer floors and physics/occluding walls. Automated floor connectivity, wall casts and open-door clearances pass. LV01 manual map/visual walk-through pending. |
| L02 | Security spawn, all eight side/start/safe door instances, final D09 door, C01 opening and E01 marker placed. C01 is structural opening only; final semantics pending. |
| T02 | E proximity/LOS interaction and key collection once/session ownership implemented. Real-time manual control checks pending. |
| T04 | R05 subset implemented: final door unlock with exit key, physical completion trigger, stop actors, R reload. Key retained; full menu/pause/loss lifecycle (T03) not implemented. Automated trigger/reset checks pass. |
| L03 | Two openable doors implemented; six red doors remain locked with no invented unlocking key policy. Blocked LD-Q02. |
| L04 | B01/B02 and N01–N03 visual markers, functional K01, S01 terminal marker and E01 exit placed. No third battery location invented; battery/note/save gameplay remains blocked/unimplemented. |
| L05 / T06 | Existing two enemies and their original chase/light scripts preserved, repositioned in Hall. No patrol added; safe exclusion/patrol/door permissions await decisions. Safe lighting is visual only. |
| T07 / T08 | Battery charge/drain parameters, note text, safe behavior and save persistence unresolved. Markers do not satisfy gameplay acceptance. |
| L06 / T10 | 72 automated checks pass for the implemented subset; full level/gameplay/release acceptance blocked. No manual/visual/export verification. |

Next decision input: third battery location, side-door key assignment, C01 door semantics, save persistence and safety/enemy access. User requested a save point, superseding the old blanket no-save exclusion, but did not define save data/lifetime. Continue dependent systems only when clarified; no working save is claimed.

## Actor and lighting asset task — `feat/character-lighting-assets`

User-approved visual-only scope, based on `cd2c61c` from `feat/reference-level` (required dependency retained). No level redesign or pending gameplay decision was resolved by this work. Asset mapping, limitations and acceptance are in docs/12.

| Task | Status | Acceptance / evidence / remaining checks |
| --- | --- | --- |
| AV01 — player art | Implemented; automated checks pass | VX01: four directional 128×32 sheets, 32×32 frames at 2×; original Sprite2D path, player controller/collider/camera intact. Manual V02/VX01 pending. Player commit `1ac0e93`. |
| AV02 — enemy art | Implemented; automated checks pass | VX02: shared four-frame sheet at 2.5×, movement-facing rotation (supplied direction sheets identical), warm fire tint; AI/detection/collision unchanged. Manual VX02 pending. Enemy commit `e62665b`. |
| AV03 — functional light visuals | Implemented; automated checks pass | VX03: soft forward cone, native radial glow, inherited aim and soft wall/door shadows; no toggle/charge mechanics change. 28 lighting + 58 actor + 72 level checks pass. Rendered VX03/manual V02 checks pending. |

These task statuses do not mark manual visual acceptance, T06 patrol or T07 battery mechanics complete. No push/merge authorized.
