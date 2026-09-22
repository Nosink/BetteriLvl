local _, ns = ...

local defaults = {
    enabled = true,

    -- player
    itemLevel = true,
    borderColor = true,

    -- durability
    durability = true,
    durabilityType = "BAR",
    durabilityColor = true,

    -- target
    targetItemLevel = true,
    targetBorderColor = true,
}

local defaultsPC = {
}

ns.database.Register(ns.defaults, defaults)
ns.database.Register(ns.defaultsPC, defaultsPC)
