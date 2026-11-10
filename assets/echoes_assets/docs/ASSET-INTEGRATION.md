# Echoes in the Dark — Minimalist 2D asset pack

Original vector assets for a top-down 2D horror game. SVG files are individually importable into Godot; Godot rasterizes SVG textures on import. No third-party art is required.

## Sizes
- Character sheets: 128×32, four horizontal 32×32 frames per facing direction.
- Tiles/items: 32×32.
- Doors and locker: 32×48.
- Desk: 48×32.
- UI: 24×24.

## Import
Copy the `echoes_assets` folder into your Godot project at `res://assets/echoes_assets/` (omit `docs/` if desired). Let Godot import the SVGs. For a player or enemy AnimatedSprite2D, create a SpriteFrames resource and add each of the four 32×32 regions from the corresponding directional sheet. Set FPS around 5–8 initially. For tile sprites, create a TileSet with tile size 32×32. Door sprites are taller than one tile; place them as individual Sprite2D/scene instances, with collision geometry set separately.

The sheets use vector silhouettes and transparent backgrounds. These are original minimalist assets, not pixel art. Adjust texture filtering to Linear for smooth edges or Nearest for crisp scaling. SVGs may be rasterized to PNG using Inkscape if needed.

## Codex instructions
1. Read AGENTS.md and the existing architecture/requirements first.
2. Audit current textures, animations, scene node names, and collision shapes; do not overwrite existing art or scene files without approval.
3. Inventory these files and create a mapping table from existing nodes to proposed assets.
4. Integrate one representative player animation and one floor tile, verify visually in Godot, then continue with enemies, doors, items, and props.
5. Preserve existing mechanics, scene signals, hitboxes, light masks, and input mappings. Artwork must not alter gameplay behavior.
6. Do not assume SVG sheet import automatically creates animations; configure SpriteFrames and regions explicitly.
7. Run Godot headless import/load validation, report manual visual checks as pending, and commit each validated integration step.
