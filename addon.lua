local name, _ = ...

local LibEventBus = LibStub("LibEventBus-1.0")
BIBus = LibEventBus:NewBus("BIBus", true)

local function onAddonLoaded(_, _, _)
    BIBus:TriggerEvent(name .. "_INITIALIZE_UNITS_REQUEST")
end

BIBus:RegisterEvent("ADDON_LOADED", onAddonLoaded)
