# Start here

The Git/Godot root is `GODOT-Echoes-In-Dark/` inside the parent workspace. Open that folder in Codex or change into it before starting a session. Read `AGENTS.md`, then docs/00 and 05–09; use docs/10 for release work. For level work read `docs/11-level-design.md` and visually inspect `map/game_map.png` before changing geometry, doors, item placements or navigation. Legacy docs/01–04 retain the original vision but are not verified implementation descriptions.

## Audit or resume

Start with `git status --short`, `git log -8 --oneline` and relevant diffs. Read docs/09 handoff/progress and docs/08 evidence. Inspect relevant source again; do not assume the last session's tree or test results still apply. Run V00 and safe V01 copy-based checks as appropriate. Do not launch an editor import on the working tree during a documentation-only audit. Never reset user work.

Example audit prompt:

> Read AGENTS.md and refresh docs/00 and docs/08–09 against the current repository. Documentation only. Verify claims against source, run safe copy-based load checks if available, and report discrepancies without modifying game files or committing.

## Start implementation after approval

The current user instruction approves reference-level implementation and focused commits. Read the latest docs/09 handoff for implemented work and design blockers; older documentation-only instructions below are historical examples. Resolve Q01 in docs/09, select the smallest ready task in docs/07, state requirement/check IDs, and implement only approved scope. Preserve existing movement/lights/camera/chase foundations. Engine load success is not gameplay acceptance. Commands and manual checklists are in docs/08.

Example approval prompt (send only when ready):

> I approve T01 only, using Godot [chosen version] and [chosen entry scene]. Follow AGENTS.md, establish and verify the runnable baseline, record V01/V02 results or explicit pending manual checks, and update docs/07–09. Do not implement T02 or commit/push.

Example later task prompt:

> I approve T02 with E interaction and [approved pickup range/session policy]. Implement R04 after confirming T01 evidence. Preserve existing controls and lights, perform V01–03, update traceability/progress, and stop before T03. No commit or push.

## Resume interrupted work and verify progress

> Read AGENTS.md and docs/09. Inspect status/diff before edits, identify unfinished approved task [ID] and its acceptance checks, preserve all user changes, and resume only that scope. Report blockers, evidence and next task; do not commit/push.

Verify progress by comparing requirements acceptance, task status, actual source diffs and dated test evidence. “Implemented/unverified” is distinct from “verified complete.” For a review-only session:

> Review task [ID] against docs/05 and its docs/08 check IDs. Run available safe checks, report missing evidence and regressions, and update only documentation. Do not change gameplay.

End every session with docs/09's handoff fields. Continue only within current authorization; do not push.
