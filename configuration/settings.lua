local _, ns = ...

ns.settings = ns.settings or {}

-- Unit Slots Settingsed(unit)
function ns.settings.IsItemLevelDisabled(unit)
    return ns.database[unit.."Level"] ~= true
end

function ns.settings.IsUnitBorderDisabled(unit)
    return ns.database[unit.."Border"] ~= true
end

-- Average Item Level Settings
function ns.settings.IsAverageiLvlDisabled(unit)
    return ns.database[unit.."Average"] ~= true
end

function ns.settings.IsAverageiLvlOnAlternatePosition(unit)
    if unit ~= "player" then return false end
    return ns.database[unit.."AverageAlternatePosition"] == true
end

-- Tooltip Settings
function ns.settings.IsTooltipDisabled()
    return ns.database.tooltipLevel ~= true and ns.database.tooltipID ~= true
end

function ns.settings.IsTooltipiLvlEnabled()
    return ns.database.tooltipLevel == true
end

function ns.settings.IsTooltipIDEnabled()
    return ns.database.tooltipID == true
end
