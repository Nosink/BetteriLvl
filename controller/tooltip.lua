local name, ns = ...

local settings = ns.settings

local function IsValidItemType(itemType)
    if not itemType then return false end
    return ns.data.validItemTypes[itemType] == true
end

local function displayTooltipInfo()
    if settings.IsTooltipDisabled() then return end

    local tooltip = ns.tooltip.frame or nil
    if not tooltip or tooltip:IsForbidden() then return end

    if settings.IsTooltipiLvlEnabled() then
        local itemType = ns.tooltip.itemType or nil
        if IsValidItemType(itemType) then
            tooltip.ShowItemLevel()
        end
    end

    if settings.IsTooltipIDEnabled() then
        tooltip.ShowItemID()
    end
end

ns:RegisterEvent(name .. "_TOOLTIP_READY", displayTooltipInfo)