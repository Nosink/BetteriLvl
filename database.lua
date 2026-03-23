local name, ns = ...

ns.db = ns.db or {}
ns.dbHandle = ns.dbHandle or nil

local LibSharedVariables = LibStub("LibSharedVariables-1.0")

local defaults = {
    -- player
    playerAverage = true,
    playerAverageAlternatePosition = false,
    playerLevel = true,
    playerBorder = true,

    -- target
    targetAverage = true,
    targetLevel = true,
    targetBorder = true,

    -- tooltip
    tooltipLevel = true,
    tooltipID = false
}

local defaultsPC = {

}


local function handleOnLoadDatabase(db)
    ns.db = db
    BIBus:TriggerEvent(name .. "_VARIABLES_LOADED")
end

local function onVariablesLoaded()
    LibSharedVariables:Load(name, defaults, defaultsPC, handleOnLoadDatabase)
end

BIBus:RegisterEvent("VARIABLES_LOADED", onVariablesLoaded)
