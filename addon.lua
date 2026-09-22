local name, ns = ...

local function onAddonLoaded(_, addonName)
    if addonName ~= name then return end

    ns.bus:TriggerEvent(name .. "_ADDON_LOADED")
end

local function onLoad()
    ns.bus:TriggerEvent(name .. "_VARIABLES_LOADED")
end

local function onVariablesLoaded()
    ns.database.Load(onLoad)
end

ns.bus:RegisterEvent("ADDON_LOADED", onAddonLoaded)
ns.bus:RegisterEvent("VARIABLES_LOADED", onVariablesLoaded)
