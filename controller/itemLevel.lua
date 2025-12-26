local _, ns = ...

local function displayAverageItemLevel(_, unit)
    local slot = ns[unit].itemLevel.slot
    if not slot then return end

    local itemLevel = ns[unit].itemLevel.average or 0
    local itemQuality = ns[unit].itemLevel.dominantQuality or 0
    local alternatePosition = true

    slot:ConfigureAverageLabel(itemQuality, itemLevel, alternatePosition)
    slot:ShowAverageLabel()
end

ns:RegisterEvent("BETTERILVL_ITEMLEVEL_READY", displayAverageItemLevel, MID_PRIORITY)