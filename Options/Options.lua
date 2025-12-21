local name, ns = ...

Options = {}

function Options.IsPlayeriLvlEnabled()
    return ns.db.playerLevel == true
end

function Options.IsPlayerBorderEnabled()
    return ns.db.playerBorder == true
end

function Options.IsPlayerAverageiLvlEnabled()
    return ns.db.playerAverage == true
end

function Options.IsPlayerAverageAlternatePositionEnabled()
    return ns.db.playerAverageAlternatePosition == true
end

function Options.IsTargetiLvlEnabled()
    return ns.db.targetLevel == true
end

function Options.IsTargetBorderEnabled()
    return ns.db.targetBorder == true
end

function Options.IsTargetAverageiLvlEnabled()
    return ns.db.targetAverage == true
end

function Options.IsTooltipiLvlEnabled()
    return ns.db.tooltipLevel == true
end

function Options.IsTooltipIDEnabled()
    return ns.db.tooltipID == true
end

function Options.IsTooltipTargetAverageiLvlEnabled()
    return ns.db.tooltipAverage == true
end
