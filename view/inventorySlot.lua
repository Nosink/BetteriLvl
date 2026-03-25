local name, ns = ...

local utils = ns.utils

local function createItemLevelText(slot)
    if slot.itemLevel then
        slot:HideLabel()
        return
    end

    slot.itemLevel = slot:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    slot.itemLevel:SetPoint("TOPLEFT", slot, "TOPLEFT", 1, -2)
    slot.itemLevel:SetShadowOffset(1, -1)
    slot.itemLevel:SetShadowColor(0, 0, 0, 1)

    slot.ShowLabel = function(self, itemQuality, itemLevel)
        if not self.itemLevel then return end
        local r, g, b = utils.GetItemQualityColor(itemQuality)
        self.itemLevel:SetTextColor(r, g, b)
        self.itemLevel:SetText(itemLevel)
        self.itemLevel:Show()
    end

    slot.HideLabel = function(self)
        if not self.itemLevel then return end
        self.itemLevel:Hide()
    end

    slot:HideLabel()
end

local function createBorder(slot)
    if slot.itemBorder then
        slot:HideBorder()
        return
    end

    slot.itemBorder = slot:CreateTexture(nil, "OVERLAY")
    slot.itemBorder:SetPoint("TOPLEFT", slot, "TOPLEFT", -15, 15)
    slot.itemBorder:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", 15, -15)
    slot.itemBorder:SetTexture("Interface/Buttons/UI-ActionButton-Border")
    slot.itemBorder:SetBlendMode("ADD")
    slot.itemBorder:SetAlpha(0.5)

    slot.ShowBorder = function(self, itemQuality)
        if not self.itemBorder then return end
        local r, g, b = utils.GetItemQualityColor(itemQuality)
        self.itemBorder:SetVertexColor(r, g, b)
        self.itemBorder:Show()
    end

    slot.HideBorder = function(self)
        if not self.itemBorder then return end
        self.itemBorder:Hide()
    end

    slot:HideBorder()
end

local function createDurabilityText(slot)
    if slot.durability then
        slot:HideDurability()
        return
    end

    slot.durability = slot:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    slot.durability:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", -1, 2)
    slot.durability:SetShadowOffset(1, -1)
    slot.durability:SetShadowColor(0, 0, 0, 1)

    slot.ShowDurability = function(self, durabilityPercent)
        if not self.durability then return end
        local r, g = utils.GetDurabilityColor(durabilityPercent)
        self.durability:SetTextColor(r, g, 0)
        self.durability:SetText(durabilityPercent .. "%")
        self.durability:Show()
    end

    slot.HideDurability = function(self)
        if not self.durability then return end
        self.durability:Hide()
    end

    slot:HideDurability()
end

local function createUntSlots(_, unit)
    local slots = ns[unit].slots
    local frameName = (unit == "player") and "Character" or "Inspect"
    for slot = INVSLOT_AMMO, INVSLOT_LAST_EQUIPPED do
        local inventorySlot = _G[frameName .. ns.data.slotNames[slot]]
        if inventorySlot then
            createBorder(inventorySlot)
            createItemLevelText(inventorySlot)
            createDurabilityText(inventorySlot)
            slots[slot] = inventorySlot
        end
    end
    ns[unit].slots = slots
    BIBus:TriggerEvent(name .. "_SLOTS_READY", unit)
end

local function validateUnitSlots()
    createUntSlots(nil, "player")
end

BIBus:RegisterEvent(name .. "_ITEMS_CACHED", createUntSlots)
BIBus:RegisterEvent(name .. "_SETTINGS_CHANGED", validateUnitSlots)
