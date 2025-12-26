local _, ns = ...
local L = ns.L

local tooltipData = {
    itemIdColor = { 1.00, 0.82, 0.00 },
    itemLevelColor = { 1.00, 1.00, 1.00 },
    headerFont = "GameFontNormalLarge",
    subHeaderFont = "GameFontNormal",
    textFont = "GameFontHighlight",
    labelFont = "NumberFontNormal",
}

local function createTooltipLines()
    local item = ns.tooltip.item or nil
    if not item or not item:IsItemDataCached() then return end

    local itemID = tostring(item:GetItemID() or "N/A")
    local itemLevel = tostring(item:GetCurrentItemLevel() or "N/A")

    local r, g, b = unpack(tooltipData.itemLevelColor)
    local rID, gID, bID = unpack(tooltipData.itemIdColor)

    ns.tooltip.frame.ShowItemLevel = function () 
        ns.tooltip.frame:AddDoubleLine(L["LKEY_TOOLTIP_ITEM_LEVEL"], itemLevel, r, g, b, r, g, b)
    end
    ns.tooltip.frame.ShowItemID = function () 
        ns.tooltip.frame:AddDoubleLine(L["LKEY_TOOLTIP_ITEM_ID"], itemID, rID, gID, bID, g, b, b)
    end

    ns:TriggerEvent("BETTERILVL_TOOLTIP_READY")
end

ns:RegisterEvent("BETTERILVL_TOOLTIP_ITEM_SET", createTooltipLines)