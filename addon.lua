local name, ns = ...

ns.expansion = GetExpansionLevel()

local function onLoad()
    ns.bus:TriggerEvent(name .. "_VARIABLES_LOADED")
end

local function onVariablesLoaded(_)
    ns.database.Load(onLoad)
end

ns.bus:RegisterEvent("VARIABLES_LOADED", onVariablesLoaded)
