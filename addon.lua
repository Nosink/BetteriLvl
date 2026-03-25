local name, _ = ...

local LibEventBus = LibStub("LibEventBus-1.0")
if not LibEventBus then return end

BIBus = LibEventBus:NewBus("BIBus", true)

local function onAddonLoaded(addonName, _)
    if addonName ~= name then return end

    BIBus:TriggerEvent(name .. "_INITIALIZE_UNITS_REQUEST")
end

BIBus:RegisterEvent("ADDON_LOADED", onAddonLoaded)
