# Agent instructions — Echoes in the Dark

Act as a Godot/GDScript developer maintaining this existing 2D horror prototype. The repository root is this directory, not its parent workspace. **Current authorization is documentation only. Wait for explicit implementation approval.**

## Read and resolve evidence

Before implementation read `CODEX-START-HERE.md`, `docs/00-repository-audit.md`, `docs/05-requirements-and-acceptance.md`, `docs/06-architecture.md`, `docs/07-development-plan.md`, `docs/08-testing-and-evidence.md`, and `docs/09-decisions-and-progress.md`; consult `docs/10-release-checklist.md` for milestones. Read `docs/11-level-design.md`, relevant source and legacy docs 01–04. Before modifying level geometry, door placement, collectible locations or navigation, inspect `map/game_map.png` directly and consult its registers/decision gates in docs/11. The map is authoritative for intended spatial design; record ambiguity/conflicts instead of inventing mechanics.

Precedence: current user instructions → approved requirements/recorded decisions → accepted task scope → architecture/testing guidance → legacy design/README. Source establishes what exists, not what is intended. Mark conflicts and unknowns; never turn an implementation defect into a requirement. Legacy technical diagrams and README checkmarks are not runtime evidence.

## Implementation conventions (after approval)

- Use Godot 4.x GDScript, built-in nodes, signals, physics and resources. Original audit metadata targeted 4.6; the current user-modified metadata declares 4.7. Installed engine was 4.7.2 at audit. Do not silently migrate or pin an engine version.
- Use tabs, UTF-8/LF, snake_case functions/variables/signals/files, PascalCase types, UPPER_CASE constants; prefer typed signatures and exported tunables. Existing exported `SPEED` is mutable legacy state: avoid incidental renames breaking serialization.
- Keep existing flat `scenes/` and `scripts/` organization. Reuse player, enemy, key and prompt scenes. Do not restructure folders or rename `hame_manager.tscn` incidentally.
- Preserve scene node paths and signal connections when editing. Enemies currently require a sibling named `player`. Check scene instances and resource UIDs after changes. Prefer signals for new cross-system interactions; avoid unnecessary global managers.
- No plugins, test frameworks, downloaded assets, services or dependencies without approval. Preserve asset provenance; do not assume supplied art is licensed for distribution.

## Autonomous workflow and boundaries

1. Inspect Git status/diff and relevant source. Preserve user changes; never reset, clean or overwrite them.
2. Select one approved, dependency-ready task from the plan; identify requirement IDs, acceptance checks, affected files and assumptions.
3. Implement the smallest scoped change. Continue routine implementation choices autonomously within approval. Ask before scope changes, core control/AI redesign, engine migration, dependencies, destructive actions or publication.
4. Run relevant checks from docs/08, inspect logs as well as exit codes, and run affected manual regressions. Never label a headless load as gameplay testing.
5. Update requirements traceability, task status, architecture if changed, and progress/evidence. A milestone completes only when all required tasks and acceptance checks pass or the user accepts explicit exceptions.

Use suggested task branches only when implementation is approved and branch changes will preserve existing work. Do not commit or push unless explicitly requested. When requested, stage only scoped files and use small `fix:`, `feat:`, `test:` or `docs:` commits at validated checkpoints; no force-push or history rewriting.

If blocked, record the exact failing command, output, dependency and smallest decision needed in docs/09; continue independent approved tasks. Do not invent requirements to bypass blockers. Stop dependent work when a product decision is required.

End each session with task IDs/status, files changed, commands/results, manual checks pending, known risks, Git state/commits (or none), next eligible task and approval gates. Use the handoff format in docs/09. Do not mark unverified acceptance complete.
