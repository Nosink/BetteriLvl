local name, ns = ...

local settings = ns.settings

local function displayAverageItemLevel(_, unit)
    if settings.IsAverageiLvlDisabled(unit) then return end

    local slot = ns[unit].itemLevel.slot
    if not slot then return end

    local itemLevel = ns[unit].itemLevel.average or 0
    local itemQuality = ns[unit].itemLevel.dominantQuality or 0
    local alternatePosition = settings.IsAverageiLvlOnAlternatePosition(unit)

    slot:ShowAverageLabel(itemQuality, itemLevel, alternatePosition)
end

ns:RegisterEvent(name .. "_ITEMLEVEL_READY", displayAverageItemLevel)