local _, ns = ...
local L = ns.L

local tooltipData = {
    itemIdColor = {l = {0.80, 0.80, 0.80 }, r = {0.80, 0.80, 0.80 }},
    itemLevelColor = { l = {1.00, 1.00, 1.00 } , r = {1.00, 1.00, 1.00 }},
}

local function createTooltipLines()
    local item = ns.tooltip.item or nil
    if not item or not item:IsItemDataCached() then return end

    local itemID = tostring(item:GetItemID() or "N/A")
    local itemLevel = tostring(item:GetCurrentItemLevel() or "N/A")

    ns.tooltip.frame.ShowItemLevel = function () 
        local lr, lg, lb = unpack(tooltipData.itemLevelColor.l)
        local rr, rg, rb = unpack(tooltipData.itemLevelColor.r)
        ns.tooltip.frame:AddDoubleLine(L["LKEY_TOOLTIP_ITEM_LEVEL"], itemLevel, lr, lg, lb, rr, rg, rb)
    end

    ns.tooltip.frame.ShowItemID = function () 
        local lr, lg, lb = unpack(tooltipData.itemIdColor.l)
        local rr, rg, rb = unpack(tooltipData.itemIdColor.r)
        ns.tooltip.frame:AddDoubleLine(L["LKEY_TOOLTIP_ITEM_ID"], itemID, lr, lg, lb, rr, rg, rb)
    end

    ns:TriggerEvent("BETTERILVL_TOOLTIP_READY")
end

ns:RegisterEvent("BETTERILVL_TOOLTIP_ITEM_SET", createTooltipLines)