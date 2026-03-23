local _, ns = ...

ns.settings = ns.settings or {}

function ns.settings.IsUnitSlotInfoDisabled(unit)
    return ns.db[unit .. "Level"] == false and ns.db[unit .. "Border"] == false
end

function ns.settings.IsItemLevelDisabled(unit)
    return ns.db[unit .. "Level"] == false
end

function ns.settings.IsUnitBorderDisabled(unit)
    return ns.db[unit .. "Border"] == false
end
