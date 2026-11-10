# Release checklist

Release is **not ready**. All boxes below are pending; prototype source presence and successful import do not satisfy gameplay gates. Trace IDs reference docs/05 and docs/08. Record evidence and accepted exceptions in docs/09.

- [ ] Approved engine version and launch scene configured; fresh import and scene/script load without errors (N01, V01).
- [ ] Movement, sprint, camera, visible lighting and environment collisions tested (R01–02, V02).
- [ ] Interaction prompts and once-only key pickup work; locked exit rejects keyless player; escape wins and resets correctly (R04–05, V03–04).
- [ ] Approved enemy count, patrol/detection/chase/return/LOS and catch loss work throughout layout (R06–07, V05).
- [ ] Start, pause/resume, win, lose, restart and menu return all work; terminal input/AI and state reset correct (R08, V04).
- [ ] Battery drain/recharge, notes and safe-room rules complete if retained in approved release scope (R03, R09–10, V06). Any scope reduction requires explicit approval.
- [ ] Approved licensed ambience/cues play cleanly; no clipping or duplicated playback after restarts (R11, V06–07).
- [ ] Manual visual checks: darkness remains navigable, prompt/UI readable, correct camera, no missing textures or unintended stretching at supported window sizes (V02, V07).
- [ ] Representative full runs and repeated win/lose/restart cycles show no crashes, stuck progression, accumulating nodes or runtime errors (N01, V07).
- [ ] Profile on approved target hardware; document frame times/memory and agree performance budget before claiming performance readiness (V07).
- [ ] Choose platforms and engine-matched export templates; create approved presets (proposed; none currently exist); exclude secrets/development artifacts (N03, V08).
- [ ] Each target export launches outside editor and completes full loop; verify input/window/audio/resources and document known platform limitations (V08).
- [ ] Asset provenance/attribution and distribution rights reviewed; learning/portfolio README text is not a license grant.
- [ ] All required tasks verified complete, acceptance linked to evidence, unresolved critical defects zero, remaining issues and exceptions explicitly accepted; docs/Git diff reviewed (N02–03, V00).
- [ ] User explicitly approves packaging/publication. No upload, release tag, commit or push without the corresponding authorization.
