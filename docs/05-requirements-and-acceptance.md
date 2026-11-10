# Requirements and acceptance

“Confirmed” means intent supported by existing design, not user approval to implement now and not a claim of working gameplay. Baseline behavior is static unless docs/08 records a runtime check. Proposed choices require approval. Stable IDs connect tasks and checks; do not silently change acceptance criteria to match code.

| ID | Requirement / source | Current trace | Acceptance criteria | Check |
| --- | --- | --- | --- | --- |
| R01 | Movement, sprint and camera (docs/01, README) | `scripts/player.gd`, `scenes/player.tscn`; present, unverified | Preserve rotation and forward/back controls, 200 walk/500 sprint, collisions and following camera; control redesign requires approval | V02 |
| R02 | Toggle light (docs/02) | Player script and two light nodes; present | F and Space toggle both lights once per press; initially off | V02 |
| R03 | Battery drain and recharge (docs/02) | Missing | Charge bounded between zero/max; drains only while enabled; depleted light cannot illuminate; battery restores bounded charge. Rates/capacity approved first | V06 |
| R04 | Key interaction (docs/01–02) | `scenes/key.tscn`, `scripts/interactables.gd`; stub | In-range action collects once, removes pickup and updates key ownership; no out-of-range pickup; prompt reflects availability | V03 |
| R05 | Locked exit and escape (docs/02) | Missing | Exit stays locked without key, accepts key and enters win exactly once; fresh run resets ownership | V04 |
| R06 | Patrol, detect, chase, return (docs/01–02) | Enemy scripts only overlap chase/idle | Approved patrol route executes; detection enters chase; loss returns to patrol; walls obey approved LOS rule and movement does not remain stuck on test route | V05 |
| R07 | Enemy catch loses game (docs/02) | Missing | Approved catch condition enters loss once; movement/interaction stop in terminal states | V04–05 |
| R08 | Main, pause, win and lose UI (docs/01) | Empty menu/UI/manager scenes | Start enters playable level; pause freezes gameplay and resumes; terminal screens offer working fresh restart/menu transitions | V04 |
| R09 | Story notes (docs/02) | Missing | Approved note content can be read and dismissed; movement/pause behavior defined; no duplicate pickup errors | V06 |
| R10 | Safe room (docs/02) | Missing | Approved room visibly identifiable; enemy exclusion and player safety follow recorded rule and remain valid on entry/exit | V06 |
| R11 | Atmospheric audio (README, docs/01 milestone) | No audio files/nodes | Approved licensed ambience and cues play at suitable levels, obey pause/restart policy and do not multiply after restarts | V06–07 |
| N01 | Loadable, stable Godot 2D project (docs/01) | No main scene; support version undecided | Approved engine imports and loads all scenes without errors; configured launch works; no errors during full loop | V01, V07 |
| N02 | Maintainability/minimal dependencies (docs/01, AGENTS) | Four scripts, built-in nodes | Scoped reusable changes, preserved resource references, no unapproved dependencies; task/docs/evidence updated | V00 |
| N03 | Portfolio release (docs/01, README platforms) | No export setup | Approved target build launches outside editor, full loop completes, attribution and release checks pass | V07–08 |

## Proposed decisions, not approved requirements

- P01: configure entry via main menu after boot flow works; use explicit level launch during development.
- P02: retain tank controls by default; E interaction is suggested by prompt but not bound. Pause binding and simultaneous movement-key policy require decisions.
- P03: choose one active enemy or approve two variants; define LOS, patrol, catch distance and safe-room rules before AI expansion.
- P04: use a small session state owner and signals for key/terminal state; no full inventory or save system.
- P05: approve resource values, note content, level layout, audio provenance, supported engine and export targets.

Out of scope per docs/01: combat, inventory, multiple enemies (conflicts with current level), procedural generation, multiplayer, saves, dialogue and bosses. Docs/03 “future improvements” do not authorize them. Full inventory is distinct from a boolean exit-key flag.

## Spatial reference supplement

The user-designated authoritative layout/object reference is `map/game_map.png`, interpreted in docs/11 with LD01–LD06 acceptance and LV01–LV06 verification. It fixes intended rooms/connections and marked positions, not working gameplay. Consult that register before level edits. Unresolved: third battery location versus summary count; keys for six red doors; final exit lock and southern Safe Room threshold; save-point marker versus existing no-save scope. Keep saves out of implementation until explicitly resolved; do not discard the marker or infer persistence. P05's layout question is now narrowed to scale, ambiguous thresholds and documented discrepancies rather than freely selecting a new layout.

## Implementation trace update

Original table status is the audit baseline. Current R04 key subset uses `scripts/exit_key.gd` + `scripts/level.gd`; R05 uses final `scenes/level_door.tscn` instance D09 and ExitTrigger. Geometry uses `scripts/level_geometry.gd`. E interaction, 144-unit range and grid calibration are routine implementation choices; player movement/camera/lights remain unchanged. R03/R09/S01 visuals alone do not implement their mechanics. R10 safety and R06 patrol remain pending decisions. The latest user instruction explicitly requests a save point, overriding the old no-save exclusion in principle; persistence/reset details remain unresolved. No extra key types or battery placement is inferred from asset availability.
