local name, ns = ...

local function initializeToolTipVars()
    ns.tooltip = ns.tooltip or {}
end

local function initializeUnitTargetVars()
    ns.targets = ns.targets or {}
end

local function initializeUnitVars(unit)
    ns.targets[unit] = true
    ns[unit] = ns[unit] or {}
    ns[unit].slots = ns[unit].slots or {}
    ns[unit].items = ns[unit].items or {}
    ns[unit].itemLevel = ns[unit].itemLevel or {}
end

local function onPlayerEnteringWorld()

    initializeToolTipVars()
    initializeUnitTargetVars()
    initializeUnitVars("player")

    ns:TriggerEvent(name .. "_ADDON_LOADED")
end
local function onTargetRequestVars(_, unit)
    if not unit or unit == "" then return end

    if not ns.targets[unit] then
        initializeUnitVars(unit)
    end

    ns:TriggerEvent(name .. "_TARGET_VARS_READY", unit)
end

ns:RegisterEvent("PLAYER_ENTERING_WORLD", onPlayerEnteringWorld)
ns:RegisterEvent(name .. "_REQUEST_VARS", onTargetRequestVars)