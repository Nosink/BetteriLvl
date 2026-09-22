local _, ns = ...
local durabilityType = ns.enums.durabilityType

local defaults = {
    enabled = true,

    -- player
    itemLevel = true,
    borderColor = true,

    -- durability
    durability = true,
    durabilityType = durabilityType.Bars,
    durabilityColor = true,

    -- target
    targetItemLevel = true,
    targetBorderColor = true,
}

local defaultsPC = {
}

ns.database.Register(defaults, defaultsPC)
