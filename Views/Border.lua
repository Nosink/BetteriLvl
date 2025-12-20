
Border = {}

Border.data = {
    texture = "Interface/Buttons/UI-ActionButton-Border",
    alpha = 0.5,
    blendMode = "ADD",
    origin = { anchor = "TOPLEFT", relative = "TOPLEFT", offset = { x = -13, y = 13}},
    destination = { anchor = "BOTTOMRIGHT", relative = "BOTTOMRIGHT", offset = { x = 13, y = -13}},
    offset = { x = 13, y = 13},
}

function Border.IsValid(slot)
    if slot and slot.border then
        return true
    end
    return false
end

function Border.CreateOn(slot)
    if Border.IsValid(slot) then
        return
    end
    slot.border = slot:CreateTexture(nil, "OVERLAY")
end

function Border.ConfigureWith(slot, itemQuality)
    local r, g, b = BetteriLvl.API.GetQualityColor(itemQuality)
    slot.border:SetPoint(Border.data.origin.anchor, slot, Border.data.origin.relative, Border.data.origin.offset.x, Border.data.origin.offset.y)
    slot.border:SetPoint(Border.data.destination.anchor, slot, Border.data.destination.relative, Border.data.destination.offset.x, Border.data.destination.offset.y)
    slot.border:SetAlpha(Border.data.alpha)
    slot.border:SetBlendMode(Border.data.blendMode)
    slot.border:SetTexture(Border.data.texture)
    slot.border:SetVertexColor(r, g, b)
end

function Border.ShowOn(slot)
    slot.border:Show()
end

function Border.HideFrom(slot)
    if not Border.IsValid(slot) then
        return
    end
    slot.border:Hide()
end