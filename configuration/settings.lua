local _, ns = ...

Settings = {}

function Settings.IsPlayeriLvlEnabled()
    return ns.db.playerLevel == true
end

function Settings.IsPlayerBorderEnabled()
    return ns.db.playerBorder == true
end

function Settings.IsPlayerAverageiLvlEnabled()
    return ns.db.playerAverage == true
end

function Settings.IsPlayerAverageAlternatePositionEnabled()
    return ns.db.playerAverageAlternatePosition == true
end

function Settings.IsTargetiLvlEnabled()
    return ns.db.targetLevel == true
end

function Settings.IsTargetBorderEnabled()
    return ns.db.targetBorder == true
end

function Settings.IsTargetAverageiLvlEnabled()
    return ns.db.targetAverage == true
end

function Settings.IsTooltipiLvlEnabled()
    return ns.db.tooltipLevel == true
end

function Settings.IsTooltipIDEnabled()
    return ns.db.tooltipID == true
end

function Settings.IsTooltipTargetAverageiLvlEnabled()
    return ns.db.tooltipAverage == true
end
