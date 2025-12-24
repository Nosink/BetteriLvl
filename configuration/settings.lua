local _, ns = ...

ns.settings = ns.settings or {}

function ns.settings.IsPlayeriLvlEnabled()
    return ns.db.playerLevel == true
end

function ns.settings.IsPlayerBorderEnabled()
    return ns.db.playerBorder == true
end

function ns.settings.IsPlayerAverageiLvlEnabled()
    return ns.db.playerAverage == true
end

function ns.settings.IsPlayerAverageAlternatePositionEnabled()
    return ns.db.playerAverageAlternatePosition == true
end

function ns.settings.IsTargetiLvlEnabled()
    return ns.db.targetLevel == true
end

function ns.settings.IsTargetBorderEnabled()
    return ns.db.targetBorder == true
end

function ns.settings.IsTargetAverageiLvlEnabled()
    return ns.db.targetAverage == true
end

function ns.settings.IsTooltipiLvlEnabled()
    return ns.db.tooltipLevel == true
end

function ns.settings.IsTooltipIDEnabled()
    return ns.db.tooltipID == true
end

function ns.settings.IsTooltipTargetAverageiLvlEnabled()
    return ns.db.tooltipAverage == true
end