# Decisions and progress

## Current status

Historical documentation baseline, dated 2026-11-09 (superseded by implementation handoff below). Baseline `ff57e1e`; implementation is not approved. D00 complete: repository inspected, documentation authored and validated. T01–T10 pending approval. No gameplay changes, commits or pushes made. Runtime load evidence is in docs/08; manual gameplay remains untested.

## Evidence-backed decisions

- Preserve existing scripts/scenes and tank movement baseline until approved changes (player source).
- Treat README/legacy completion marks as claims, not verification. Keep docs/01–04 unchanged for design/history; docs/06 supersedes their current-architecture claims.
- Retain flat folders and misspelled manager filename for now; it is an empty placeholder, not an operational game manager.
- Use built-in Godot capabilities and no new dependencies. This documentation does not authorize new mechanics or automatic commits.
- Local engine is 4.7.2; project declares feature version 4.6. Local availability is not a supported-version decision.

## Open decisions and blockers

| ID | Decision needed | Blocks |
| --- | --- | --- |
| Q01 | Approve implementation scope and supported Godot version (README 4.6.1 vs local 4.7.2); decide entry scene | T01 and following work |
| Q02 | Keep tank controls? Approve E interaction, pause binding, pickup range and simultaneous movement policy | T02–03 |
| Q03 | One enemy versus current two? Define patrol route, LOS, loss-of-target, catch and safe-room behavior | T06, T08 |
| Q04 | Approve session owner/reset policy and minimal menu/terminal flow, key consumption and exit placement | T02–05 |
| Q05 | Charge/drain/recharge values, note content, room layout, audio sources and license evidence | T05, T07–09 |
| Q06 | Supported release targets (README Windows/macOS), export templates, performance budget and distribution rights | T10 |

Validation: isolated explicit level smoke passed on installed 4.7.2; normal launch failed for missing main scene. Editor import still emits sandbox TCP listener errors (exit 0); no script/resource errors reported. These results do not verify gameplay or 4.6 compatibility. See docs/08 for reproduction.

Known implementation gaps are enumerated in docs/00. No main scene blocks normal launch; no key/exit/catch/session flow blocks completion of a run. Runtime errors or unavailable tools must be added here with exact evidence, not bypassed by speculative changes. Nonblocking: tracked `.DS_Store` cleanup and duplicate enemy code; neither is authorized in this phase.

## Progress ledger

| Task | Status | Evidence / next action |
| --- | --- | --- |
| D00 | Complete | docs/00 and 05–10, AGENTS and start guide; docs/08 validation record |
| T01 | Pending approval | Resolve Q01, reproduce V01 in approved engine |
| T02–T10 | Pending approval | Follow dependency order in docs/07; resolve relevant questions before dependent edits |

Keep this ledger and docs/07 aligned. Suggested states: pending approval, ready, in progress, implemented/unverified, blocked, verified complete. Record evidence/check IDs for every completion; record any accepted exception explicitly.

## Session handoff template

```text
Date / baseline commit / engine / branch:
Authorization and constraints:
Task and requirement IDs; status before → after:
Files changed and behavior affected:
Commands and exit codes; manual checks and results; evidence location:
Failures, unverified acceptance and blockers:
Decisions made (rationale) / decisions awaiting approval:
Git status; commits (only if requested):
Next eligible task, dependencies and exact next verification:
```

Next session: request or read implementation approval, resolve Q01 and select T01. Do not interpret this plan as permission to begin implementation.

## Map documentation handoff — 2026-11-09

D11 complete (documentation only): visually inspected `map/game_map.png`, compared all scenes/scripts and existing docs including `assets/echoes_assets/docs/ASSET-INTEGRATION.md`; added docs/11, map-alignment workstream in docs/07, reading/authority rules and requirements/start-guide links. L01–L06 remain pending implementation approval. LD-Q01–05 in docs/11 refine Q03–05: third battery, six side-door locks, south thresholds, save/safety conflict, world scale and patrol permissions. Map fixes intended layout and exit-key position; those are no longer free layout choices.

Pre-existing changes preserved: project metadata now declares 4.7, generated import sidecars differ on disk, and an untracked asset pack exists. Historical docs/00 and runtime results in docs/08 describe their original baseline, not a fresh runtime validation. No scene/script/config/image/asset edits or new runtime tests in D11; static validation and file hashes used to confirm this session's Markdown-only changes. No commit/push. Next: review LD-Q01–05; after explicit implementation approval select L01 after T01, then map geometry T05. Do not treat map documentation approval as level/save implementation approval.

## Implementation handoff — reference-level foundation

Authorization: latest user instruction approves level implementation and focused commits, no push. Baseline `1015c12`; working tree was clean. Branch `feat/reference-level`, Godot 4.7.2. Full task statuses in docs/07 override old pending-approval entries above.

Implemented: runtime TileMapLayer floors and collision/occluder walls for all nine map areas; calibrated spawn and ten structural connections; eight registered side/start/safe door instances plus final exit door; two openable doors; six locked side doors without invented key mapping; proximity/occlusion-aware E interaction; one-shot exit key; final keyed door, physical completion trigger, movement stop and R restart. Existing movement/camera/light and enemy chase scripts unchanged. Asset-pack floor/wall/door/item/prop art integrated; safe ambient glow is visual only. Two batteries, three notes and save terminal are visual markers, not functional resource/content/save systems.

Validation: 72 engine-backed integration checks pass; main scene smoke passes. Editor import exit 0 still reports sandbox TCP errors. Full evidence/commands and test timing correction in docs/08. Manual visuals/control playthrough pending. No third-party dependencies.

Major blockers requiring user input (question sent during implementation): third battery location; six red-door key policy; Safe Room south door semantics; save checkpoint/persistence and safe/enemy boundary rules. Patrol/spawn/door access and battery values/note text also remain unspecified. Existing two enemies are retained and repositioned in Hall; no patrol exists to reuse. Final keyed exit follows explicit R05 without changing collectible gates. C01 is structural connected floor, not an approved door behavior. A full playable level is not claimed.

Next: resolve these design choices, then finish L03–L05/T06–T08 and run full LV01–LV06. Do not add an arbitrary third battery or a save lifetime to bypass blockers. Commit identifiers are reported in the session response; inspect `git log -2 --oneline`. No push authorized.

## Visual replacement handoff — 2026-11-09

Scope: user authorized player/enemy/lighting replacements and separate focused commits, no push/merge. Dedicated branch `feat/character-lighting-assets` begins at `cd2c61c` on required level branch; working tree initially clean. No stale-main branch reset. Read docs/12 for audit/mapping and VX01–VX03 acceptance.

Implemented: four player direction sheets on preserved Sprite2D; enemy four-frame sheet rotated toward velocity, warm fire variant; shared presentation script only reads actor state; locally authored soft SVG beam and native radial light mask replace all active legacy light textures; PointLight2D paths/toggle interface retained, beam source follows body near muzzle, soft wall/closed-door shadows. `door_shadow.gd` reads door state and never changes gameplay. No player/AI/session/door/geometry script or project configuration edits; colliders/detection signals unchanged.

Commits: `1ac0e93` player, `e62665b` enemy; lighting commit follows (use `git log -3 --oneline`). AV01–AV03 implemented with automated evidence; manual visual acceptance pending. Tests: actor 58, lighting 28, level 72 checks pass; smoke pass; editor TCP sandbox errors remain qualified in docs/08. Existing battery/patrol/save gaps remain unchanged. Enemy direction artwork is identical across supplied sheets; rotation is the intentional visual fallback. Pack has a flashlight item icon but no beam asset, so no decorative icon replaces functional lighting.

Next action: manually play the level and check VX01–VX03, especially backwards sprite motion versus forward beam aim, cone range/readability, enemy facing and door shadows. No additional gameplay implementation, push or merge is authorized by this visual task.

## Orientation correction handoff

User explicitly authorizes vertical correction and one focused commit; no push/merge. Clean baseline `4bfb5a6` on main, branch `fix/invert-level-vertical`. OR01/LD07 implemented and automated checks pass; manual visual acceptance pending. Original image retained unchanged; docs/11 now records the approved bottom-start/top-exit transform, current room positions and object register separately from historical image analysis.

Changes: explicit geometry rectangles and all 25 placed world-node coordinates reflected via y′=3328−y, player initial rotation set to 0 (forward up), upright Hall label bounds reflected; room labels generated within reflected rooms. Walls/colliders/occluders rebuilt by unchanged generator. No negative Y scale, moved screen UI, gameplay/AI rewrite or asset replacement. No navigation/patrol/custom camera limits exist; camera follow and unchanged bounds are preserved.

Verification: 63 orientation + 72 level + 58 actor + 28 lighting checks pass; scene smoke passes. Editor import sandbox TCP errors remain; see docs/08 for exact commands and limitations. All existing door/key gating and pre-existing gameplay blockers remain unchanged. Next action: manual upward-route, art/UI/camera and shadow inspection. Commit ID in session report/`git log -1 --oneline`; no publication.

## EA01 handoff — 2026-11-15

- Baseline / engine / branch: 7250348 / Godot 4.7.2 / feat/enemies-update; initially clean.
- Authorization: current user requests minimal enemy extension; no commit/push. EA01/R06 proximity subset implemented with automated checks passing; manual acceptance pending. Full T06/R07 unchanged.
- Changed behavior/files: scripts/enemy.gd and enemy_fire.gd speed/radius/target guards; scenes/level.tscn adds third existing-scene Hall instance; scripts/level.gd completion list stops it. tests/test_enemies.gd (+ engine UID) adds physics checks; four existing suites updated for third actor/configured radius. docs/05–09 and 11 record scope/evidence/spawn. Player, geometry, assets, input, camera and gameplay progression rules unchanged.
- Commands/results: docs/08 EA01; import exit 0 with known restricted TCP listener errors; enemy 32, level 72, actor 58, lighting 28, orientation 63 checks all pass (exit 0). Runtime smoke and static review recorded below.
- Decisions: three total enemies, SPEED 150, detection_radius 250; copy shape per instance, retain existing overlap semantics and body-name filter. Hall spawn (1712,2304), no new layout.
- Risks/pending manual: rendered chase/animation/light, Hall doorway crowding/balance, full movement/key/door/exit/R restart regression. No manual gameplay claim. Proximity still detects through walls; collisions still constrain direct chase. No navigation, patrol, catch or safety policy invented.
- Git: scoped uncommitted work, no commits/push. Next eligible verification: manual V02–05/VX02 for EA01; broader AI remains dependent on existing patrol/LOS/catch/safety decisions.

EA01 final review: bounded main-scene `--headless --path . --quit-after 120` (timeout 30, same XDG environment) exit 0, no errors. Full scoped diff reviewed; `git diff --check` passes. No unrelated import-sidecar or game-system changes.

## EA02 handoff — 2026-11-15

- Baseline/branch/engine: 7250348 plus existing dirty EA01 work, feat/enemies-update, Godot 4.7.2. Preserved all prior edits.
- Authorization/status: user requests minimal wall-trap fix, no commit/push. EA02 R01/R06 subset implemented; manual acceptance pending.
- Files/behavior: scripts/enemy.gd and scripts/enemy_fire.gd add configurable stopping_distance 96, zero pursuit velocity within clearance and capped final step. tests/test_enemies.gd adds physics wall/escape/oversized-step checks; tests/test_level_orientation.gd target distance 96→120 preserves its chase-motion assertion. docs/05–09 updated. No additional scene, collision layer, geometry, player or detection changes in EA02.
- Root-cause evidence: constant pursuit into solid player reproduced continuous wall-adjacent contact for all three enemies before fix (6 failing assertions), resolved after fix. Complete intermittent lockup not reproduced by straight-wall fixture. Commands/results in docs/08.
- Decisions: 96 clears unchanged rectangle half diagonal plus player radius; preserve solid enemies and wall boundaries. No collision exceptions or new escape mechanics necessary for tested encounter.
- Manual/risk: inspect corners and simultaneous crowd encounters; solid enemies can still obstruct a player who deliberately walks into them. No universal anti-enclosure guarantee or manual playability claim.
- Git: prior EA01 and current EA02 remain uncommitted, no push. Next eligible action: manual wall/corner/crowd V02/V05 regression; broader AI policies remain unresolved and outside scope.

EA02 final validation: expanded enemy suite **53/53**, exit 0; total across five suites **274 checks, zero failures**. Bounded main-scene smoke (`timeout 30`, same XDG environment, `--headless --path . --quit-after 120`) exit 0 without errors. Scoped changes and preserved prior work reviewed; `git diff --check` passes. Manual checks remain pending.

## IN01 / launch-freeze investigation handoff — 2026-11-15

Task/status: user reports frozen Play launch/all keys inactive; investigation ongoing, not claimed fixed. Baseline 7250348 plus preserved EA01/EA02 edits, feat/enemies-update, Godot 4.7.2. Graphical temporary diagnostic renders and advances player/physics, and shows first-door prompt. Headless and normal graphical main launch exit 0, logs show no script errors; no connected editor MCP session.

Files/behavior: project.godot interact device 16→-1; tests/test_level.gd adds normal-keyboard mapping and real event-delivery/first-door opening assertions; docs/05,07–09 record IN01. Identified E-specific binding defect with before/after event checks. No other input/controller/renderer changes. tests/test_level.gd 75/75, exit 0; commands/evidence and diagnostic limitations in docs/08. Broader all-input freeze cause pending.

Manual pending: Play launch after focusing game, F toggle and held W, editor debugger/focus state if neither works. E fix needs editor settings reloaded if its in-memory project configuration is stale. No assertion of full manual playability; temporary screenshots in /tmp are diagnostic artifacts only. Existing dirty work preserved, no commits/push. Next: inspect failing running game and response to requested input/focus test.
