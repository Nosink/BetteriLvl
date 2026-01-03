# Changelog

## [1.2.1] - 2026-01-03
Fixed inspect error on party, raid, etc frames.

### Fixed
- Now correctly inspect for all type of targets.
- Created events "_TARGET_VARS_READY" and "_REQUEST_VARS" to create on demand storage for inspected units.

### Notes
- Not hard tested, but looks working good on party groups and raids groups.

---

## [1.2.0] - 2025-12-31
Refactored options panel with a reusable settings builder and events.

### Added
- New configuration builder with reusable UI frames:
	- Checkboxes
	- Edit boxes
	- Sliders

### Changed
- Options panel rebuilt to use the builder API: cleaner layout, consistent fonts/colors, less duplication.
- Custom events are now namespaced using the addon name (e.g., `name .. "_ITEMLEVEL_READY"`, `name .. "_SLOTS_READY"`, `name .. "_TOOLTIP_READY"`) replacing hardcoded `BETTERILVL_*` strings across controllers and views.
- Tooltip model guards against empty items before loading.

### Notes
- Primary focus is maintainability and robustness of the options UI and event handling.
- Functional behavior remains equivalent to 1.1.2 with minor resilience improvements.

---

## [1.1.2] - 2025-12-29
Improved performance, resilience, and accuracy across the board.

### Added
- Centralized error handling and safe hooks to prevent UI taints and silent failures.
- More accurate average item level calculation covering edge cases (e.g., dual-wield, two‑handers, ranged/offhand scenarios, and empty slots).

### Changed
- Performance overhaul: fewer frame updates, smarter throttling, and reduced GC churn during equip/inspect/tooltip events.
- Tooltip pipeline optimized to avoid unnecessary item queries and string rebuilds.
- Inventory slot refresh logic now batches updates to minimize layout thrashing.

### Fixed
- Rare issues when item data is temporarily unavailable or cached, ensuring graceful fallbacks instead of errors.
- Occasional mismatches between displayed per-slot iLvl and the recalculated average after rapid equipment changes.

### Notes
- Existing settings are preserved, will be handled in next updates.
- Inspect data still relies on `INSPECT_READY`, so extremely brief delays may occur before target values appear.

---

## [1.0.0] - 2025-12-19
First release of BetteriLvl.

### Added
- Per-slot item level labels on Character and Inspect Target frames.
- Quality-colored item borders based on item rarity.
- Average item level display; alternate player-position option.
- Tooltip enhancements: show item level (equipment only) and item ID.
- Options panel with Settings API integration and slash commands.
- English (enUS) and Spanish (esES/esMX) localization.
- SavedVariables with sensible defaults.

### Compatibility
- WoW Classic Era 1.15.8

### Notes
- Target information appears after the inspect event; slight delay is expected.
- Ammo slot is excluded from item level labels.
- Tooltip item level shows only for equipment (Armor, Weapon, Projectile).