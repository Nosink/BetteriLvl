
local _, namespace = ...
local L = namespace.L


function OnTooltipSetItemHandler(tooltip)

    if not tooltip or tooltip:IsForbidden() then
        return
    end

    local showItmeLevel = Options.IsTooltipiLvlEnabled()
    local showItemID = Options.IsTooltipIDEnabled()

    if not showItmeLevel and not showItemID then
        return
    end

    local _, itemLink = tooltip:GetItem()
    if not itemLink then
        return
    end

    local itemID = C_Item.GetItemInfoInstant(itemLink)

    local _, _, _, itemLevel, _, itemType = C_Item.GetItemInfo(itemLink)
    local isArmor = ItemHelper.GetIsEquipmentType(itemType)

    local yellowR, yellowG, yellowB = 1.00, 0.82, 0.00

    if showItmeLevel and isArmor then
        tooltip:AddDoubleLine(L["LKEY_TOOLTIP_ITEM_LEVEL"], tostring(itemLevel or "N/A"), 1, 1, 1, 1, 1, 1)
    end

    if showItemID then
        tooltip:AddDoubleLine(L["LKEY_TOOLTIP_ITEM_ID"], tostring(itemID or "N/A"), yellowR, yellowG, yellowB, yellowR, yellowG, yellowB)
    end

    tooltip:Show()

end
