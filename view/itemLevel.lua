local _, ns = ...

local slotNames = {
    [INVSLOT_AMMO] = "AmmoSlot",
    [INVSLOT_HEAD] = "HeadSlot",
    [INVSLOT_NECK] = "NeckSlot",
    [INVSLOT_SHOULDER] = "ShoulderSlot",
    [INVSLOT_BACK] = "BackSlot",
    [INVSLOT_CHEST] = "ChestSlot",
    [INVSLOT_BODY] = "ShirtSlot",
    [INVSLOT_TABARD] = "TabardSlot",
    [INVSLOT_WRIST] = "WristSlot",
    [INVSLOT_HAND] = "HandsSlot",
    [INVSLOT_WAIST] = "WaistSlot",
    [INVSLOT_LEGS] = "LegsSlot",
    [INVSLOT_FEET] = "FeetSlot",
    [INVSLOT_FINGER1] = "Finger0Slot",
    [INVSLOT_FINGER2] = "Finger1Slot",
    [INVSLOT_TRINKET1] = "Trinket0Slot",
    [INVSLOT_TRINKET2] = "Trinket1Slot",
    [INVSLOT_MAINHAND] = "MainHandSlot",
    [INVSLOT_OFFHAND] = "SecondaryHandSlot",
    [INVSLOT_RANGED] = "RangedSlot",
}

local labelData = {
    font = "GameFontNormalLarge",
    anchor = "TOP",
    relative = "CENTER",
    fontSize = 14,
    position = { x = -112, y = -5},
    alternatePosition = { x = 0, y = 40},
    text = "iLvl: ",
    shadow = {offset = { x = 1 , y = -1}, color = { r = 0, g = 0, b = 0, a = 1} }
}

local function createFrontString(slot)
    if slot.averageItemLevel then
        return
    end
    slot.averageItemLevel = slot:CreateFontString(nil, "OVERLAY", labelData.font)
    if GameFontNormal and GameFontNormal.GetFont then
        local fontPath, _, fontFlags = GameFontNormal:GetFont()
        if fontPath then
            slot.averageItemLevel:SetFont(fontPath, labelData.fontSize, fontFlags)
        end
    end
    slot.ConfigureAverageLabel = function (self, itemQuality, itemLevel, alternatePosition)
        local r, g, b = BetteriLvl.API.GetItemQualityColor(itemQuality)
        local pos = alternatePosition and labelData.alternatePosition or labelData.position
        self.averageItemLevel:SetPoint(labelData.anchor, self, labelData.relative, pos.x, pos.y)
        self.averageItemLevel:SetShadowOffset(labelData.shadow.offset.x, labelData.shadow.offset.y)
        self.averageItemLevel:SetShadowColor(labelData.shadow.color.r, labelData.shadow.color.g, labelData.shadow.color.b, labelData.shadow.color.a)
        self.averageItemLevel:SetTextColor(r, g, b)
        self.averageItemLevel:SetText(string.format("%s%.1f", labelData.text, itemLevel))
    end

    slot.ShowAverageLabel = function(self)
        self.averageItemLevel:Show()
    end

    slot.HideAverageLabel = function(self)
        if not self.averageItemLevel then
            return
        end
        self.averageItemLevel:SetText("")
        self.averageItemLevel:Hide()
    end
    slot:HideAverageLabel()
end

local function createAverageItemLevelLabel(_, unit)
    local frameName = (unit == "target") and "Inspect" or "Character"
    local inventorySlot = _G[frameName .. "SecondaryHandSlot"]
    createFrontString(inventorySlot)
    ns[unit].itemLevel.slot = inventorySlot
    ns:TriggerEvent("BETTERILVL_ITEMLEVEL_READY", unit)
end

ns:RegisterEvent("BETTERILVL_ITEMLEVEL_CALCULATED", createAverageItemLevelLabel)