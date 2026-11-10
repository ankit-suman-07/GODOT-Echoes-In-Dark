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

No automated test suite, test framework, CI or test runner exists in this repository. V03–V06 automation is proposed, not available. Engine load checks do not assert movement, collisions, rendering, AI correctness or acceptance of gameplay. Missing coverage includes interaction, resources, AI, state transitions and resets.

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
