
local _, ns = ...

ns.tooltip = ns.tooltip or {}
ns.tooltip.item = ns.tooltip.item or nil

local function onTooltipSetItem(tooltip)
    if not tooltip or tooltip:IsForbidden() then return end

    local _, itemLink = tooltip:GetItem()
    if not itemLink then return end

    local previousItem = ns.tooltip.item or nil
    local item = Item:CreateFromItemLink(itemLink)

    if previousItem and previousItem:GetItemLink() == itemLink then 
        ns:TriggerEvent("TOOLTIP_ITEM_SET")
    return end

    item:ContinueOnItemLoad(function()
        ns.tooltip = ns.tooltip or {}
        local _, itemType = C_Item.GetItemInfoInstant(item:GetItemID())
        ns.tooltip.item = item
        ns.tooltip.itemType = itemType
        ns.tooltip.frame = tooltip
        ns:TriggerEvent("TOOLTIP_ITEM_SET")
    end)

end

ns:HookScript(_G.GameTooltip, "OnTooltipSetItem", onTooltipSetItem)