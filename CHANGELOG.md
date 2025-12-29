# Changelog

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