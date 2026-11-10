# Decisions and progress

## Current status

Documentation phase only, dated 2026-11-09. Baseline `ff57e1e`; implementation is not approved. D00 complete: repository inspected, documentation authored and validated. T01–T10 pending approval. No gameplay changes, commits or pushes made. Runtime load evidence is in docs/08; manual gameplay remains untested.

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
