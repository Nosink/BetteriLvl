local _, ns = ...

local settings = ns.settings

local function GetIsEquipmentType(itemType)
    if not itemType then return false end
    return ns.data.validItemTypes[itemType] == true
end

local function displayTooltipInfo()
    if settings.IsTooltipDisabled() then return end

    local tooltip = ns.tooltip.frame or nil
    if not tooltip or tooltip:IsForbidden() then return end

    local itemType = ns.tooltip.itemType or nil
    local isArmor = GetIsEquipmentType(itemType)

    if isArmor and settings.IsTooltipiLvlEnabled() then
        tooltip.ShowItemLevel()
    end

    if settings.IsTooltipIDEnabled() then
        tooltip.ShowItemID()
    end
end

ns:RegisterEvent("BETTERILVL_TOOLTIP_READY", displayTooltipInfo)
ns:RegisterEvent("BETTERILVL_SETTINGS_CHANGED", displayTooltipInfo)