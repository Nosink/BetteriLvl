local _, ns = ...

local settings = ns.settings

AverageLabel = {}

AverageLabel.data = {
    font = "GameFontNormal",
    anchor = "TOP",
    relative = "CENTER",
    fontSize = 14,
    position = { x = -112, y = -5},
    alternatePosition = { x = 0, y = 40},
    slotsAmount = 16,
    text = "iLvl: ",
    shadow = {offset = { x = 1 , y = -1}, color = { r = 0, g = 0, b = 0, a = 1} }
}

function AverageLabel.IsValid(slot)
    if slot and slot.avgLabel then
        return true
    end
    return false
end

function AverageLabel.CreateOn(slot)
    if AverageLabel.IsValid(slot) then
        return
    end
    slot.avgLabel = slot:CreateFontString(nil, "OVERLAY", AverageLabel.data.font)
end

local function GetAverageLabelPositionFor(unit)
    if UnitHelper.IsPlayer(unit) and not settings.IsPlayerAverageAlternatePositionEnabled() then
        return AverageLabel.data.position
    end
    return AverageLabel.data.alternatePosition
end

function AverageLabel.ConfigureWith(unit, unitSlot, maxQuality)
    local r, g, b = BetteriLvl.API.GetItemQualityColor(maxQuality)
    local position = GetAverageLabelPositionFor(unit)
    unitSlot.avgLabel:SetPoint(AverageLabel.data.anchor, unitSlot, AverageLabel.data.relative, position.x, position.y)
    unitSlot.avgLabel:SetShadowOffset(AverageLabel.data.shadow.offset.x, AverageLabel.data.shadow.offset.y)
    unitSlot.avgLabel:SetShadowColor(AverageLabel.data.shadow.color.r, AverageLabel.data.shadow.color.g, AverageLabel.data.shadow.color.b, AverageLabel.data.shadow.color.a) 
    unitSlot.avgLabel:SetTextColor(r, g, b)
    local font = unitSlot.avgLabel:GetFont()
    unitSlot.avgLabel:SetFont(font, AverageLabel.data.fontSize)
end

function AverageLabel.ShowOn(slot, averageItemLevel)
    local averageItemLevelByWow = select(2, GetAverageItemLevel())
    slot.avgLabel:SetText(string.format("%s%.2f", AverageLabel.data.text, averageItemLevel, (averageItemLevelByWow - averageItemLevel)))
    slot.avgLabel:Show()
end

function AverageLabel.HideFrom(slot)
    if not AverageLabel.IsValid(slot) then
        return
    end
    slot.avgLabel:SetText("")
    slot.avgLabel:Hide()
end