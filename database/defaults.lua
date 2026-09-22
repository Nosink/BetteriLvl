local _, ns = ...

ns.defaults = ns.defaults or {}
ns.defaultsPC = ns.defaultsPC or {}

local function evaluate(key, value)
    if value == nil then return end
    error(("Duplicate key " .. tostring(key) .. " found in defaults."))
end

local function registerOn(target, source)
    if not source then return end
    for k, v in pairs(source) do
        evaluate(k, target[k])
        target[k] = v
    end
end

function ns.RegisterDefaults(account, perChar)
    registerOn(ns.defaults, account)
    registerOn(ns.defaultsPC, perChar)
end

local enums = ns.enums
local durabilityType = enums.durabilityType

local moduleName = "CHARACTER_FRAME"

local defaults = {
    [moduleName] = {
        enabled = true,

        -- player
        itemLevel = true,
        borderColor = true,

        -- durability
        durability = true,
        durabilityType = durabilityType.Bars, -- Bars, Text
        durabilityColor = true,

        -- target
        targetItemLevel = true,
        targetBorderColor = true,
    }
}

local defaultsPC = {
    [moduleName] = {
    }
}

ns.RegisterDefaults(defaults, defaultsPC)
