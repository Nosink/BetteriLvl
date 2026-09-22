local _, ns = ...

ns.settings = ns.settings or {}

function ns.settings.IsUnitSlotInfoDisabled(unit)
    local levelKey = unit == "player" and "itemLevel" or "targetItemLevel"
    local borderKey = unit == "player" and "borderColor" or "targetBorderColor"
    return ns.db[levelKey] == false and ns.db[borderKey] == false
end

function ns.settings.IsItemLevelDisabled(unit)
    return ns.db[unit == "player" and "itemLevel" or "targetItemLevel"] == false
end

function ns.settings.IsUnitBorderDisabled(unit)
    return ns.db[unit == "player" and "borderColor" or "targetBorderColor"] == false
end
