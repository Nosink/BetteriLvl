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
        slot:HideLabel()
        return
    end
    slot.itemLevel = slot:CreateFontString(nil, "OVERLAY", itemLevelLabelData.font)
    slot.ConfigureLabel = function (self)
        local x, y = unpack(itemLevelLabelData.offset)
        local anchor, relative = itemLevelLabelData.anchor, itemLevelLabelData.relative
        self.itemLevel:SetPoint(anchor, self, relative, x, y)
        local sx, sy = unpack(itemLevelLabelData.shadow.offset)
        self.itemLevel:SetShadowOffset(sx, sy)
        local sr, sg, sb, sa = unpack(itemLevelLabelData.shadow.color)
        self.itemLevel:SetShadowColor(sr, sg, sb, sa)
    end
    
    slot.ShowLabel = function(self, itemQuality, itemLevel)
        local r, g, b = ns.utils.GetItemQualityColor(itemQuality)
        self.itemLevel:SetTextColor(r, g, b)
        self.itemLevel:SetText(itemLevel)
        self.itemLevel:Show()
    end

    slot.HideLabel = function(self)
        if not self.itemLevel then
            return
        end
        self.itemLevel:SetText("")
        self.itemLevel:Hide()
    end
    slot:ConfigureLabel()
    slot:HideLabel()
end

local function createBorder(slot)
    if slot.itemBorder then
        slot:HideBorder()
        return
    end
    slot.itemBorder = slot:CreateTexture(nil, "OVERLAY")
    slot.ConfigureBorder = function (self)
        local oanchor, orelative = itemBorderData.origin.anchor, itemBorderData.origin.relative
        local ox, oy = unpack(itemBorderData.origin.offset)
        self.itemBorder:SetPoint(oanchor, self, orelative, ox, oy)
        local danchor, drelative = itemBorderData.destination.anchor, itemBorderData.destination.relative
        local dx, dy = unpack(itemBorderData.destination.offset)
        self.itemBorder:SetPoint(danchor, self, drelative, dx, dy)
        local alpha, blend = itemBorderData.alpha, itemBorderData.blendMode
        self.itemBorder:SetAlpha(alpha)
        self.itemBorder:SetBlendMode(blend)
        local texture = itemBorderData.texture
        self.itemBorder:SetTexture(texture)
    end
    slot.ShowBorder = function(self, itemQuality)
        local r, g, b = ns.utils.GetItemQualityColor(itemQuality)
        self.itemBorder:SetVertexColor(r, g, b)
        self.itemBorder:Show()
    end
    slot.HideBorder = function(self)
        self.itemBorder:Hide()
    end
    slot:ConfigureBorder()
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

local function validateUnitSlots()
    createUntSlots(nil, "player")
end

ns:RegisterEvent("BETTERILVL_ITEMS_CACHED", createUntSlots)
ns:RegisterEvent("BETTERILVL_SETTINGS_CHANGED", validateUnitSlots)