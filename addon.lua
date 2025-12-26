local _, ns = ...

local function initializeToolTipVars()
    ns.tooltip = ns.tooltip or {}
end

local function initializeUnitVars(unit)
    ns[unit] = ns[unit] or {}
    ns[unit].slots = ns[unit].slots or {}
    ns[unit].items = ns[unit].items or {}
    ns[unit].itemLevel = ns[unit].itemLevel or {}
end

local function onPlayerEnteringWorld()

    initializeToolTipVars()
    initializeUnitVars("player")
    initializeUnitVars("target")

    ns:TriggerEvent("BETTERILVL_ADDON_LOADED")
end

ns:RegisterEvent("PLAYER_ENTERING_WORLD", onPlayerEnteringWorld)