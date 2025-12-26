local name, ns = ...

ns["player" .. "slots"] = ns["player" .. "slots"] or {}
ns["target" .. "slots"] = ns["target" .. "slots"] or {}

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

local borderData = {
    texture = "Interface/Buttons/UI-ActionButton-Border",
    alpha = 0.5,
    blendMode = "ADD",
    origin = { anchor = "TOPLEFT", relative = "TOPLEFT", offset = { x = -15, y = 15}},
    destination = { anchor = "BOTTOMRIGHT", relative = "BOTTOMRIGHT", offset = { x = 15, y = -15}},
    offset = { x = 15, y = 15},
}

local labelData = {
    font = "NumberFontNormal",
    anchor = "TOPLEFT",
    relative = "TOPLEFT",
    offset = { x = 1, y = -2},
    shadow = {offset = { x = 1 , y = -1}, color = { r = 0, g = 0, b = 0, a = 1} }
}

local function createFrontString(slot)
    if slot.label then
        return
    end
    slot.label = slot:CreateFontString(nil, "OVERLAY", labelData.font)
    slot.ConfigureLabel = function (self, itemQuality, itemLevel)
        local r, g, b = BetteriLvl.API.GetItemQualityColor(itemQuality)
        self.label:SetPoint(labelData.anchor, self, labelData.relative, labelData.offset.x, labelData.offset.y)
        self.label:SetShadowOffset(labelData.shadow.offset.x, labelData.shadow.offset.y)
        self.label:SetShadowColor(labelData.shadow.color.r, labelData.shadow.color.g, labelData.shadow.color.b, labelData.shadow.color.a)
        self.label:SetTextColor(r, g, b)
        self.label:SetText(itemLevel)
    end

    slot.ShowLabel = function(self)
        self.label:Show()
    end

    slot.HideLabel = function(self)
        if not self.label then
            return
        end
        self.label:SetText("")
        self.label:Hide()
    end
    slot:HideLabel()
end

local function createBorder(slot)
    if slot.border then
        return
    end
    slot.border = slot:CreateTexture(nil, "OVERLAY")
    slot.ConfigureBorder = function (self, itemQuality)
        local r, g, b = _G.BetteriLvl.API.GetItemQualityColor(itemQuality)
        self.border:SetPoint(borderData.origin.anchor, self, borderData.origin.relative, borderData.origin.offset.x, borderData.origin.offset.y)
        self.border:SetPoint(borderData.destination.anchor, self, borderData.destination.relative, borderData.destination.offset.x, borderData.destination.offset.y)
        self.border:SetAlpha(borderData.alpha)
        self.border:SetBlendMode(borderData.blendMode)
        self.border:SetTexture(borderData.texture)
        self.border:SetVertexColor(r, g, b)
    end
    slot.ShowBorder = function(self)
        self.border:Show()
    end
    slot.HideBorder = function(self)
        self.border:Hide()
    end
    slot:HideBorder()
end

local function createUntiSlots(_, unit)
    local slots = ns[unit .. "slots"] or {}
    local frameName = (unit == "target") and "Inspect" or "Character"
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local inventorySlot = _G[frameName .. slotNames[slot]]
        if inventorySlot then
            createBorder(inventorySlot)
            createFrontString(inventorySlot)
            slots[slot] = inventorySlot
        end
    end
    ns[unit .. "slots"] = slots
    ns:TriggerEvent("BETTERILVL_SLOTS_READY", unit)
end

ns:RegisterEvent("BETTERILVL_ITEMS_CACHED", createUntiSlots)