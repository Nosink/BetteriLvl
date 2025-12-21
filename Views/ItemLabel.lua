ItemLabel = {}

ItemLabel.data = {
    font = "NumberFontNormal",
    anchor = "TOPLEFT",
    relative = "TOPLEFT",
    offset = { x = 0, y = -1},
    shadow = {offset = { x = 1 , y = -1}, color = { r = 0, g = 0, b = 0, a = 1} }
}

function ItemLabel.IsValid(slot)
    if slot and slot.label then
        return true
    end
    return false
end

function ItemLabel.CreateOn(slot)
    if ItemLabel.IsValid(slot) then
        return
    end
    slot.label = slot:CreateFontString(nil, "OVERLAY", ItemLabel.data.font)
end

function ItemLabel.ConfigureWith(slot, itemQuality)
    local r, g, b = BetteriLvl.API.GetItemQualityColor(itemQuality)
    slot.label:SetPoint(ItemLabel.data.anchor, slot, ItemLabel.data.relative, ItemLabel.data.offset.x, ItemLabel.data.offset.y)
    slot.label:SetShadowOffset(ItemLabel.data.shadow.offset.x, ItemLabel.data.shadow.offset.y)
    slot.label:SetShadowColor(ItemLabel.data.shadow.color.r, ItemLabel.data.shadow.color.g, ItemLabel.data.shadow.color.b, ItemLabel.data.shadow.color.a)
    slot.label:SetTextColor(r, g, b)
end

function ItemLabel.ShowOn(slot, itemLevel)
    slot.label:SetText(itemLevel)
    slot.label:Show()
end

function ItemLabel.HideFrom(slot)
    if not ItemLabel.IsValid(slot) then
        return
    end
    slot.label:SetText("")
    slot.label:Hide()
end
