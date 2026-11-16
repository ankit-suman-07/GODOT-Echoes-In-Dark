# Testing and evidence

## Check catalog

| ID | Type | Procedure / expected evidence |
| --- | --- | --- |
| V00 | Static/document review | Inspect Git status/diff, resource paths, links, requirement/task IDs and scoped changes. Verify no user changes overwritten. |
| V01 | Automated engine load/smoke, not gameplay | Import in isolated copy; load explicit level and normal project entry; record engine, command, exit status and all errors/warnings. Extend scene coverage after fixes. |
| V02 | Manual gameplay | Run level; test W/S and arrows forward/back, A/D turning, Shift speed, opposite keys, F/Space single toggles, initial darkness, camera follow and collisions. Check responsiveness and visibility. |
| V03 | Manual or future integration | Approach/leave key; prompt appears/disappears, E (if approved) collects once, distant press fails; confirm ownership/removal and restart reset. |
| V04 | Manual or future integration | Start, pause/resume, keyless exit, keyed escape, enemy loss, repeated terminal triggers, restart and menu return; confirm controls/AI stop and all local/session state resets. |
| V05 | Manual or future integration | Patrol route, chase detection, wall blocks LOS, loss of target, return, corner collisions, catch, fire light, safe-room boundary and resets; use approved AI rules. |
| V06 | Manual plus future focused state tests | Drain to zero; toggle at zero; collect battery at empty/full; read/dismiss notes; safe room entry/exit; verify audio and UI across pause/restart. Values and policies must be approved first. |
| V07 | Manual stability/presentation | Full loop with sound/display; repeated win/lose/restart cycles, no errors, no accumulating nodes/audio; profile representative play on target hardware and record frame-time/memory observations. No numerical performance budget approved. |
| V08 | Export/manual platform | Export approved target with matching templates, run outside editor, complete full loop and check controls/assets/window/audio. Record artifact/version/platform and results. |

At the original audit no automated test suite, test framework, CI or test runner existed. A dependency-free integration suite is now available as recorded below. V03–V06 automation is proposed, not available. Engine load checks do not assert movement, collisions, rendering, AI correctness or acceptance of gameplay. Missing coverage includes interaction, resources, AI, state transitions and resets.

## Safe environment commands

Run from the Git root (the folder containing `project.godot`):

```bash
git status --short
git log -8 --oneline
git diff --check
git diff --stat
/home/ankitsuman/Applications/Godot/godot --version
```

Godot was not on PATH at audit; the absolute executable above exists. Recheck availability in future environments. Godot editor imports can write caches and sidecars. For documentation-only validation copy the source to a temporary directory excluding `.git` and `.godot`, then run the following **against that copy**, replacing the placeholder with its actual path:

```bash
/home/ankitsuman/Applications/Godot/godot --headless --path /tmp/REPLACE_WITH_COPY --editor --quit
/home/ankitsuman/Applications/Godot/godot --headless --path /tmp/REPLACE_WITH_COPY res://scenes/level.tscn --quit-after 120
/home/ankitsuman/Applications/Godot/godot --headless --path /tmp/REPLACE_WITH_COPY --quit-after 1
```

`/tmp/REPLACE_WITH_COPY` is a placeholder, not an existing project path. Use a timeout, capture stdout/stderr, and inspect error text even for exit 0. After approval normal editor/play commands may run in the working project; inspect resulting diffs. Export commands depend on approved presets/templates; none are supplied yet.

## Audit evidence — 2026-11-09

Static: every GDScript, scene, project setting, legacy document, import sidecar and tracked-file inventory inspected at `ff57e1e`. Initial status clean. Source resource targets checked separately from generated `.godot/imported` outputs. Engine validation results follow. No manual playtesting performed.

## Reporting and regression

For each check record: date, baseline commit plus dirty files, engine/platform, requirement/task/check IDs, exact command or manual steps, expected/actual outcome, exit code/log excerpt, pass/fail/blocked and remaining uncertainty. A failed check includes reproduction and affected acceptance; a skipped check includes reason. Keep large logs outside tracked source unless deliberately adding a small evidence artifact.

After a change run load checks and affected check IDs; after interactions/AI/state changes repeat V02–05; after content/resources repeat V02–06; before release repeat all. Repeat only when changes or unresolved failures justify it. A task with pending essential manual acceptance is implemented/unverified, not verified complete.

## Executed validation results

Engine: `4.7.2.stable.official.ed1daf0bf`. Copy: `/tmp/echoes-audit-vj9zyweq/project` (ephemeral audit artifact, not a source dependency). The commands above used this path.

| Check | Exit | Actual outcome |
| --- | --- | --- |
| Version probe | 0 | Installed engine reports 4.7.2. |
| Copy editor import `--editor --quit`, initial run | 0 | Assets imported; restricted user-data/config writes and editor TCP listener creation emitted errors. Not an error-free pass. |
| Explicit level `res://scenes/level.tscn --quit-after 120`, initial run | 0 | User-data/log directory errors; no script/resource error reported. |
| Normal launch `--quit-after 1` | 1 | “Can't run project: no main scene defined in the project.” Also user-data errors and display warning from dialog. Confirmed launch blocker. |
| Editor import rerun with isolated XDG directories | 0 | User-data/config errors resolved; editor TCP listen errors remain under network restrictions. No script/resource errors reported, but editor validation remains qualified. |
| Explicit level rerun with isolated XDG directories | 0 | No stderr or reported errors. Bounded headless scene smoke check only; no input or visual assertions. |
| V00 static review | 0 | 25 source/import-input resource path occurrences resolve; generated cache outputs excluded. Only nine Markdown files changed/added; README and docs/01–04 unchanged; `git diff --check` clean. Requirements/tasks/check references reviewed; suggested branch names are not file paths. |

For the rerun, Python passed an environment copy with `XDG_DATA_HOME=/tmp/echoes-audit-vj9zyweq/data`, `XDG_CONFIG_HOME=/tmp/echoes-audit-vj9zyweq/config` and `XDG_CACHE_HOME=/tmp/echoes-audit-vj9zyweq/cache`, after creating those directories. Reproduce with fresh temporary directories rather than relying on this copy. No home variable was changed. No manual gameplay or export checks were run; standalone scene coverage beyond the level's instances remains pending.

## Reference-level implementation evidence — 2026-11-09

Baseline `1015c12`, branch `feat/reference-level`; installed Godot `4.7.2.stable.official.ed1daf0bf`. No pre-existing working-tree edits at implementation start. Environment used temporary `XDG_DATA_HOME=/tmp/echoes-level-data`, `XDG_CONFIG_HOME=/tmp/echoes-level-config`, `XDG_CACHE_HOME=/tmp/echoes-level-cache`.

Commands (from repository root, using that environment):

```bash
/home/ankitsuman/Applications/Godot/godot --headless --path . --editor --quit
/home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_level.gd
/home/ankitsuman/Applications/Godot/godot --headless --path . --quit-after 120
git diff --check
```

- Editor import exited 0; sandbox TCP listener errors remain. No script/resource errors reported; do not call editor import error-free.
- Final integration suite: **72 checks, 0 failures**, exit 0. All ten scene resources load. Checks cover structural floor connectivity, object anchors on floor, closed barriers, open doorway clearance for unchanged player/enemy shapes, locked-side-door refusal, closure obstruction by actor, external/internal wall blocking, interaction selection, one-shot key ownership/removal, keyless completion rejection, final exit unlock, real physics `body_entered` completion and fresh key/completion reset.
- Earlier integration run waited only two physics ticks after teleporting the test actor into the exit trigger; it failed the timing assertion. Waiting four ticks for physics overlap delivery resolved this test synchronization issue. Final suite tests actual trigger signal delivery rather than directly calling completion for its success case.
- Main-scene bounded runtime smoke: exit 0, no errors reported. Resource path/static whitespace checks pass; original player/enemy scripts and player/camera scene remain unchanged.

Limitations: tests temporarily disable barriers to measure structural clearances; this does not prove side rooms are reachable with unresolved locked-door keys. No safe behavior, patrol, battery depletion/recharge, note reading, save persistence, catch/loss, pause/menu or exports tested because these are not implemented. Fresh scene instantiation reset is tested; R keyboard reload still needs a manual check. Headless physics is not a visual check or complete player-input playthrough. Manual LV01–LV06/V02–V07 remain pending for the implemented subset; full acceptance remains blocked by docs/11 decisions.

## Character and lighting asset evidence — 2026-11-09

Baseline `cd2c61c`, clean tree, branch `feat/character-lighting-assets` from required `feat/reference-level`. Engine `4.7.2.stable.official.ed1daf0bf`. Environment: temporary `XDG_DATA_HOME=/tmp/echoes-visual-data`, `XDG_CONFIG_HOME=/tmp/echoes-visual-config`, `XDG_CACHE_HOME=/tmp/echoes-visual-cache`.

Commands from repository root (each test/smoke bounded with `timeout 30`):

```bash
/home/ankitsuman/Applications/Godot/godot --headless --path . --editor --quit
/home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_actor_visuals.gd
/home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_lighting.gd
/home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_level.gd
/home/ankitsuman/Applications/Godot/godot --headless --path . --quit-after 120
git diff --check
```

Results: actor suite **58/58**, lighting suite **28/28**, existing level suite **72/72**, all exit 0. Smoke exit 0 with no errors. Import exit 0 still emits restricted editor TCP listener errors; no script/resource/texture failures. Static resource path validation passes; original gameplay scripts and project configuration byte-identical to baseline, actor collider resource/node blocks, detection areas and signal connections unchanged. No active scene references to legacy actor PNGs or `assets/lights/` textures; application icon intentionally retained.

Test harness corrections during development: frame wrapping legitimately returns frame 0 during movement, so animation checks assert progression rather than nonzero frame; native gradient textures cannot return rendered image pixels under the dummy headless renderer, so the radial check samples its CPU Gradient instead. Approximate comparison is used for float energy values. The stalled initial lighting test was interrupted; bounded reruns pass. These corrections do not establish rendered shadow/gradient quality.

Manual VX01–VX03 (docs/12), V02 and relevant V05 remain pending: sprite facing/alignment, diagonal/backwards motion, sprint cadence, camera, visual light range/readability, rendered wall/door shadows and chase appearance. No gameplay/visual pass is inferred from import or headless checks. No battery or patrol test is claimed: those mechanics do not exist in current source and were outside this task.

## Vertical orientation correction evidence

Baseline `4bfb5a6`, clean tree, branch `fix/invert-level-vertical`. Installed engine 4.7.2. Runs used temporary `XDG_DATA_HOME=/tmp/echoes-orientation-data`, `XDG_CONFIG_HOME=/tmp/echoes-orientation-config`, `XDG_CACHE_HOME=/tmp/echoes-orientation-cache` and `timeout 30` per command:

```bash
/home/ankitsuman/Applications/Godot/godot --headless --path . --editor --quit
/home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_level_orientation.gd
/home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_level.gd
/home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_actor_visuals.gd
/home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_lighting.gd
/home/ankitsuman/Applications/Godot/godot --headless --path . --quit-after 120
```

Results: orientation **63/63**, level **72/72**, actor **58/58**, lighting **28/28**, all exit 0. Main-scene smoke exit 0 with no runtime errors. Editor import exit 0 with the known restricted TCP listener errors; no script/resource import errors reported.

New orientation regression checks inverse-reflected runtime floor and wall signatures against pre-correction geometry (all 3640 cells and 710 colliders), all 25 placed world positions, spawn/exit containment, upright transforms/labels/UI, follow-camera configuration, injected upward/downward input at initial facing, structural door-gated reachability to corridor key/top Exit, and existing chase callbacks/motion at mirrored spawns. Existing tests retain body-shape casts, key/completion/reset and flashlight/shadow state coverage, with old absolute coordinates reflected. No patrol or navigation verification is claimed: these systems are absent. Locked side rooms remain locked exactly as before; tests do not invent a key policy.

The first new test run used a Node2D-style property on a Control label; the test harness was corrected to `get_global_transform()` and rerun successfully. No game logic change was needed. Static resource checks, baseline-preservation review and `git diff --check` pass. Manual checks pending: upward full-route playthrough/restart, readable upright art/text, camera framing, rendered flashlight/door/wall shadows and chase appearance. Headless validation alone does not prove visual or full gameplay acceptance.

## EA01 enemy extension evidence — 2026-11-15

Baseline 7250348, initially clean feat/enemies-update, installed Godot 4.7.2.stable.official.ed1daf0bf. V00/V01 and V02–05 automated subsets only. Commands from root with XDG_DATA_HOME=/tmp/echoes-enemy-data, XDG_CONFIG_HOME=/tmp/echoes-enemy-config, XDG_CACHE_HOME=/tmp/echoes-enemy-cache:

```bash
timeout 45 /home/ankitsuman/Applications/Godot/godot --headless --path . --editor --quit
timeout 40 /home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_enemies.gd
```

Same test command used for test_level.gd, test_actor_visuals.gd, test_lighting.gd and test_level_orientation.gd. Results: enemy 32/32, level 72/72, actor 58/58, lighting 28/28, orientation 63/63; all exit 0, no runtime errors. Enemy suite tests actual physics overlaps, independent idle/chase/exit, per-instance shape/radius isolation, walking escape from all three, unchanged input speeds, deleted targets, floor-contained level spawns and completion stopping every enemy. Existing suites freeze/include the third instance in actor exclusions where needed.

Initial enemy escape checks failed because standalone player facing differed from the level override and the test duration was insufficient for radius 350. Harness now explicitly faces up and runs 330 ticks per escape; corrected suite passes without player changes. Import exit 0 with known restricted editor TCP socket/listen errors; no script/resource errors, not an error-free editor pass. No rendered/manual testing performed. Manual V02–05/VX02 pending, particularly Hall crowding, doors, chase appearance, camera/light and full key/escape/restart. Existing absent patrol/LOS/catch/safety remain outside this scope.

EA01 final review: bounded main-scene `--headless --path . --quit-after 120` (timeout 30, same XDG environment) exit 0, no errors. Full scoped diff reviewed; `git diff --check` passes. No unrelated import-sidecar or game-system changes.

## EA02 wall-contact regression — 2026-11-15

Baseline 7250348 plus preserved uncommitted EA01 work on feat/enemies-update, Godot 4.7.2.stable.official.ed1daf0bf. Source cause: both solid actors use default layer/mask 1 and enemies unconditionally request SPEED toward the player's center while detected, including during contact. Player tank movement offers no lateral strafe, so continued contact removes maneuvering space at walls. A new real-wall test against pre-fix enemy scripts failed clearance and sustained-contact assertions for all three enemies (47 checks, 6 failures). The simple straight-wall setup still permitted parallel escape before the fix: a complete intermittent gameplay lockup was not reproduced or claimed.

Fix uses 96 center-distance clearance, exceeding 32 + sqrt(40²+40²), and caps each approach step; collision masks/shapes remain unchanged. Modified enemy suite exercises each of three enemies approaching a player against a wall, zero motion/contact once stopped, input-driven parallel escape, player/enemy wall blocking, oversized diagonal step and player entry inside the gap, alongside EA01 physics entry/exit, independent instances, target deletion and walking escape.

Commands from repository root with XDG_DATA_HOME=/tmp/echoes-enemy-data, XDG_CONFIG_HOME=/tmp/echoes-enemy-config, XDG_CACHE_HOME=/tmp/echoes-enemy-cache:

```bash
timeout 30 /home/ankitsuman/Applications/Godot/godot --headless --path . --editor --quit
timeout 55 /home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_enemies.gd
```

Existing test_level.gd, test_actor_visuals.gd, test_lighting.gd and test_level_orientation.gd ran with the same script command/environment. Results: level 72/72, actor 58/58, lighting 28/28, orientation 63/63 (exit 0). Initial post-fix wall suite 47/47, exit 0. Import exit 0; known restricted editor TCP listener errors only, no script/resource errors. Final expanded suite/smoke results below. No manual gameplay test performed; narrow corners, several enemies surrounding the player, player intentionally walking into a stationary enemy, visual idle/fire-light behavior and full route remain manual checks. Clearance prevents enemy-driven contact, but does not enable walking through solid enemies or guarantee an escape from arbitrary enclosing configurations.

EA02 final validation: expanded enemy suite **53/53**, exit 0; total across five suites **274 checks, zero failures**. Bounded main-scene smoke (`timeout 30`, same XDG environment, `--headless --path . --quit-after 120`) exit 0 without errors. Scoped changes and preserved prior work reviewed; `git diff --check` passes. Manual checks remain pending.

## IN01 / launch investigation — 2026-11-15

Preserved prior EA01/EA02 dirty tree on feat/enemies-update (7250348). Installed Godot 4.7.2. Main-scene headless launch exit 0; normal graphical main-scene bounded launch exit 0 without errors. Connected Godot MCP sessions list empty. Normal user-data logs contain renderer/version only, no script errors. Temporary /tmp/echoes_launch_probe.gd loads the existing level under a SceneTree diagnostic and captures game-only images /tmp/echoes-launch-before.png and /tmp/echoes-launch-after.png. Rendered frames advance; paused=false, player physics processing=true; player moved from (1713,2881) to (1736.649,2504.067), and later image shows E — Open door. Real keyboard activity may have overlapped injected W, so movement is evidence of an active scene, not a controlled OS-input acceptance pass.

Concrete defect found: project.godot interact event has device 16; device-0 KEY_E fails InputMap.event_is_action while W/F pass. Setting interact device to -1 repairs event matching. /tmp/echoes_interaction_probe.gd confirms a device-0 physical E event delivered through Input.parse_input_event opens D01 from 90 units away. Added both mapping and real input-path regression to tests/test_level.gd. Command with existing isolated XDG environment: timeout 30 /home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_level.gd → 75 checks, 0 failures, exit 0.

This repairs E but does not establish the cause of the user-reported all-key/editor freeze. User launches with Play and sees no start/pickup prompt. Level has no start prompt and begins with both lights off. Awaiting focus/flashlight/movement test in the failing editor launch; no speculative renderer/controller changes.

## PC01 controls evidence — 2026-11-15

Baseline 6ca9c74 (merged enemy PR #5), initially clean main; fetch and ff-only pull confirmed latest origin/main, feature branch feat/wasd-mouse-controls created at that exact commit. Godot 4.7.2.stable.official.ed1daf0bf. Environment XDG_DATA_HOME=/tmp/echoes-controls-data, XDG_CONFIG_HOME=/tmp/echoes-controls-config, XDG_CACHE_HOME=/tmp/echoes-controls-cache.

Commands from repository root:

```bash
timeout 30 /home/ankitsuman/Applications/Godot/godot --headless --path . --editor --quit
timeout 30 /home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_player_controls.gd
timeout 55 /home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_enemies.gd
timeout 30 /home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_level.gd
timeout 30 /home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_actor_visuals.gd
timeout 30 /home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_lighting.gd
timeout 30 /home/ankitsuman/Applications/Godot/godot --headless --path . --script res://tests/test_level_orientation.gd
timeout 30 /home/ankitsuman/Applications/Godot/godot --headless --path . --quit-after 120
git diff --check
```

All six suites exit 0: controls 41, enemies 53, level 75, visuals 58, lighting 28, orientation 63; **318 checks, zero failures**. Main-scene smoke exit 0, no errors. Sandbox editor import exit 0 with TCP listener errors; rerun outside sandbox exit 0 with no reported errors, confirming that restriction. No script/resource import failures.

Controls suite injects physical device-0 WASD/arrows, diagonal combinations, opposite keys and Shift; flushes buffered keyboard events before synchronous ticks. Verifies 200/500 speeds, world-axis motion despite differing facing, zero-vector aim, flashlight direction/emitter, upright camera view, idle aim artwork and F/Space toggles. Dummy headless DisplayServer cannot move an OS cursor; aim checks position the actor relative to the actual viewport mouse query. This exercises runtime aiming math without claiming physical mouse motion or input-focus acceptance. Early harness failures came from buffered events and immovable dummy cursor; corrected harness passes without changing runtime aiming.

Existing actor suite now checks aim-facing art while moving opposite. Enemy wall-block fixture uses right (rather than turn + forward); all independent chase/exit, stop-distance, deletion and wall-escape assertions pass. Orientation suite preserves reflection/connectivity while checking mouse-facing instead of initial fixed-up facing. Level suite retains real E event/door, key/exit/reset and collision checks. No gameplay scripts for enemies/geometry/interactions changed.

Manual pending: focus game view first; WASD/arrows and diagonal sprint feel, mouse aim at all angles while strafing/backing, animation/readability, camera behavior, F/Space and rendered shadows, E door/key, enemy wall/corner/crowd escapes and complete key-to-exit/R restart. No manual gameplay or graphical acceptance performed in PC01. Earlier apparent launch freeze was confirmed by user as missing game-view keyboard focus; no engine/controller workaround added.
