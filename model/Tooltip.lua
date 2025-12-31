
local name, ns = ...

local function onTooltipSetItem(tooltip)
    if not tooltip or tooltip:IsForbidden() then return end

    local _, itemLink = tooltip:GetItem()
    if not itemLink then return end

    local previousItem = ns.tooltip.item or nil
    local item = Item:CreateFromItemLink(itemLink)

    if previousItem and previousItem:GetItemLink() == itemLink then 
        ns:TriggerEvent(name .. "_TOOLTIP_ITEM_SET")
    return end

    item:ContinueOnItemLoad(function()
        local _, itemType = C_Item.GetItemInfoInstant(item:GetItemID())
        ns.tooltip.item = item
        ns.tooltip.itemType = itemType
        ns.tooltip.frame = tooltip
        ns:TriggerEvent(name .. "_TOOLTIP_ITEM_SET")
    end)

end

ns:HookScript(_G.GameTooltip, "OnTooltipSetItem", onTooltipSetItem)