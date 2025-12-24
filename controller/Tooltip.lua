

local function HandleOnTooltipSetItem(tooltip)
    OnTooltipSetItemHandler(tooltip)
end

GameTooltip:HookScript("OnTooltipSetItem", HandleOnTooltipSetItem)