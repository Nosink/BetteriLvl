local _, ns = ...

ns.tooltip = ns.tooltip or {}

local validItemTypes = {
    ["Armor"] = true,
    ["Weapon"] = true,
    ["Projectile"] = true,
}

local function GetIsEquipmentType(itemType)
    if not itemType then return false end
    return validItemTypes[itemType] == true
end

local function displayTooltipInfo()
    local tooltip = ns.tooltip.frame
    if not tooltip or tooltip:IsForbidden() then return end

    local itemType = ns.tooltip.itemType or nil    
    local isArmor = GetIsEquipmentType(itemType)

    if isArmor then 
        tooltip.ShowItemLevel()
    end

    tooltip.ShowItemID()
    
end

ns:RegisterEvent("TOOLTIP_READY", displayTooltipInfo)