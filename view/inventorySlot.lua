local _, ns = ...

local itemBorderData = {
    texture = "Interface/Buttons/UI-ActionButton-Border",
    alpha = 0.5,
    blendMode = "ADD",
    origin = { anchor = "TOPLEFT", relative = "TOPLEFT", offset = { x = -15, y = 15}},
    destination = { anchor = "BOTTOMRIGHT", relative = "BOTTOMRIGHT", offset = { x = 15, y = -15}},
    offset = { x = 15, y = 15},
}

local itemLevelLabelData = {
    font = "NumberFontNormal",
    anchor = "TOPLEFT",
    relative = "TOPLEFT",
    offset = { x = 1, y = -2},
    shadow = {offset = { x = 1 , y = -1}, color = { r = 0, g = 0, b = 0, a = 1} }
}

local function createFrontString(slot)
    if slot.itemLevel then
        return
    end
    slot.itemLevel = slot:CreateFontString(nil, "OVERLAY", itemLevelLabelData.font)
    slot.ConfigureLabel = function (self, itemQuality, itemLevel)
        local r, g, b = ns.utils.GetItemQualityColor(itemQuality)
        self.itemLevel:SetPoint(itemLevelLabelData.anchor, self, itemLevelLabelData.relative, itemLevelLabelData.offset.x, itemLevelLabelData.offset.y)
        self.itemLevel:SetShadowOffset(itemLevelLabelData.shadow.offset.x, itemLevelLabelData.shadow.offset.y)
        self.itemLevel:SetShadowColor(itemLevelLabelData.shadow.color.r, itemLevelLabelData.shadow.color.g, itemLevelLabelData.shadow.color.b, itemLevelLabelData.shadow.color.a)
        self.itemLevel:SetTextColor(r, g, b)
        self.itemLevel:SetText(itemLevel)
    end

    slot.ShowLabel = function(self)
        self.itemLevel:Show()
    end

    slot.HideLabel = function(self)
        if not self.itemLevel then
            return
        end
        self.itemLevel:SetText("")
        self.itemLevel:Hide()
    end
    slot:HideLabel()
end

local function createBorder(slot)
    if slot.itemBorder then
        return
    end
    slot.itemBorder = slot:CreateTexture(nil, "OVERLAY")
    slot.ConfigureBorder = function (self, itemQuality)
        local r, g, b = ns.utils.GetItemQualityColor(itemQuality)
        self.itemBorder:SetPoint(itemBorderData.origin.anchor, self, itemBorderData.origin.relative, itemBorderData.origin.offset.x, itemBorderData.origin.offset.y)
        self.itemBorder:SetPoint(itemBorderData.destination.anchor, self, itemBorderData.destination.relative, itemBorderData.destination.offset.x, itemBorderData.destination.offset.y)
        self.itemBorder:SetAlpha(itemBorderData.alpha)
        self.itemBorder:SetBlendMode(itemBorderData.blendMode)
        self.itemBorder:SetTexture(itemBorderData.texture)
        self.itemBorder:SetVertexColor(r, g, b)
    end
    slot.ShowBorder = function(self)
        self.itemBorder:Show()
    end
    slot.HideBorder = function(self)
        self.itemBorder:Hide()
    end
    slot:HideBorder()
end

local function createUntSlots(_, unit)
    local slots = ns[unit].slots
    local frameName = (unit == "target") and "Inspect" or "Character"
    for slot = INVSLOT_AMMO, INVSLOT_LAST_EQUIPPED do
        local inventorySlot = _G[frameName .. ns.data.slotNames[slot]]
        if inventorySlot then
            createBorder(inventorySlot)
            createFrontString(inventorySlot)
            slots[slot] = inventorySlot
        end
    end
    ns[unit].slots = slots
    ns:TriggerEvent("BETTERILVL_SLOTS_READY", unit)
end

ns:RegisterEvent("BETTERILVL_ITEMS_CACHED", createUntSlots)