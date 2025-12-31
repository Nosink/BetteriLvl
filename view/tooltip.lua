local name, ns = ...
local L = ns.L

local function createTooltipLines()
    local item = ns.tooltip.item or nil
    if not item or not item:IsItemDataCached() then return end

    local itemID = tostring(item:GetItemID() or "N/A")
    local itemLevel = tostring(item:GetCurrentItemLevel() or "N/A")

    local frame = ns.tooltip.frame

    frame.ShowItemLevel = function ()
        frame:AddDoubleLine(L["LKEY_TOOLTIP_ITEM_LEVEL"], itemLevel, 1, 1, 1, 1, 1, 1)
    end

    frame.ShowItemID = function () 
        frame:AddDoubleLine(L["LKEY_TOOLTIP_ITEM_ID"], itemID, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8)
    end

    ns:TriggerEvent(name .. "_TOOLTIP_READY")
end

ns:RegisterEvent(name .. "_TOOLTIP_ITEM_SET", createTooltipLines)