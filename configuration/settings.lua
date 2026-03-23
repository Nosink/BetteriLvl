local _, ns = ...

ns.settings = ns.settings or {}

-- Unit Slots Settingsed(unit)
function ns.settings.IsUnitSlotInfoDisabled(unit)
    return ns.db[unit .. "Level"] == false and ns.db[unit .. "Border"] == false
end

function ns.settings.IsItemLevelDisabled(unit)
    return ns.db[unit .. "Level"] == false
end

function ns.settings.IsUnitBorderDisabled(unit)
    return ns.db[unit .. "Border"] == false
end

-- Average Item Level Settings
function ns.settings.IsAverageiLvlDisabled(unit)
    return ns.db[unit .. "Average"] == false
end

function ns.settings.IsAverageiLvlOnAlternatePosition(unit)
    if unit ~= "player" then return true end
    return ns.db[unit .. "AverageAlternatePosition"] == true
end

-- Tooltip Settings
function ns.settings.IsTooltipDisabled()
    return ns.db.tooltipLevel == false and ns.db.tooltipID == false
end

function ns.settings.IsTooltipiLvlEnabled()
    return ns.db.tooltipLevel == true
end

function ns.settings.IsTooltipIDEnabled()
    return ns.db.tooltipID == true
end
