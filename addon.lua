local name, ns = ...

local function onLoad()
    ns.bus:TriggerEvent(name .. "_VARIABLES_LOADED")
end

local function onVariablesLoaded(_)
    ns.database.Load(onLoad)
end

ns.bus:RegisterEventOnce("VARIABLES_LOADED", onVariablesLoaded, true)
