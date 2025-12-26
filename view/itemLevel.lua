local name, ns = ...

ns["player" .. "itemLevel"] = ns["player" .. "itemLevel"] or {}
ns["target" .. "itemLevel"] = ns["target" .. "itemLevel"] or {}

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

local function createFrontString(slot)
    if slot.average then
        return
    end
    slot.average = slot:CreateFontString(nil, "OVERLAY", labelData.font)
    slot.ConfigureAverageLabel = function (self, itemQuality, itemLevel)
        local r, g, b = BetteriLvl.API.GetItemQualityColor(itemQuality)
        self.average:SetPoint(labelData.anchor, self, labelData.relative, labelData.position.x, labelData.position.y)
        self.average:SetShadowOffset(labelData.shadow.offset.x, labelData.shadow.offset.y)
        self.average:SetShadowColor(labelData.shadow.color.r, labelData.shadow.color.g, labelData.shadow.color.b, labelData.shadow.color.a)
        self.average:SetTextColor(r, g, b)
        self.average:SetText(itemLevel)
    end

    slot.ShowAverageLabel = function(self)
        self.average:Show()
    end

    slot.HideAverageLabel = function(self)
        if not self.average then
            return
        end
        self.average:SetText("")
        self.average:Hide()
    end
    slot:HideLabel()
end

local function createAverageItemLevelLabel(_, unit)
    local frameName = (unit == "target") and "Inspect" or "Character"
    local inventorySlot = _G[frameName .. slotNames[INVSLOT_OFFHAND]]
    createFrontString(inventorySlot)
    ns[unit .. "itemLevel"].slot = inventorySlot
    ns:TriggerEvent("BETTERILVL_ITEMLEVEL_READY", unit)
end

ns:RegisterEvent("BETTERILVL_ITEMLEVEL_CALCULATED", createAverageItemLevelLabel)