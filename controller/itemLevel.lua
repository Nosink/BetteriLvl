local _, ns = ...

local settings = ns.settings

local function clearLabels(unit)
    local slot = ns[unit].itemLevel.slot
    if slot then
        slot:HideAverageLabel()
    end
end

local function displayAverageItemLevel(_, unit)
    if not unit then unit = "player" end
    if settings.IsAverageiLvlDisabled(unit) then clearLabels(unit) return end

    local slot = ns[unit].itemLevel.slot
    if not slot then return end

    local itemLevel = ns[unit].itemLevel.average or 0
    local itemQuality = ns[unit].itemLevel.dominantQuality or 0
    local alternatePosition = settings.IsAverageiLvlOnAlternatePosition(unit)

    slot:ConfigureAverageLabel(itemQuality, itemLevel, alternatePosition)
    slot:ShowAverageLabel()
end

ns:RegisterEvent("BETTERILVL_ITEMLEVEL_READY", displayAverageItemLevel, MID_PRIORITY)
ns:RegisterEvent("BETTERILVL_SETTINGS_CHANGED", displayAverageItemLevel, MID_PRIORITY)