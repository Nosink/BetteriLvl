local name, ns = ...

local function onLoad()
    ns.bus:TriggerEvent(name .. "_VARIABLES_LOADED")
end

local function onVariablesLoaded()
    ns.database.Load(onLoad)
end

ns.bus:RegisterEvent("VARIABLES_LOADED", onVariablesLoaded)
