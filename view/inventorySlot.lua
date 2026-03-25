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

local function createUntSlots(_, unit)
    local slots = ns[unit].slots
    local frameName = (unit == "player") and "Character" or "Inspect"
    for slot = INVSLOT_AMMO, INVSLOT_LAST_EQUIPPED do
        local inventorySlot = _G[frameName .. slotNames[slot]]
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



local settings = ns.settings

local function isItemDataValid(itemData)
    return itemData and itemData.cached and itemData.item and itemData.item:IsItemDataCached()
end

local function retrieveItemData(itemData)
    return itemData.item:GetCurrentItemLevel(), itemData.item:GetItemQuality()
end

local function isItemBorderEnabled(unit)
    return not settings.IsUnitBorderDisabled(unit)
end

local function isItemLevelEnabled(unit, slot)
    return not settings.IsItemLevelDisabled(unit) and slot ~= INVSLOT_AMMO
end

local function displayUniSlotInfo(_, unit)
    if settings.IsUnitSlotInfoDisabled(unit) then return end

    local slots = ns[unit].slots
    local items = ns[unit].items

    for slot = INVSLOT_AMMO, INVSLOT_LAST_EQUIPPED do
        local inventorySlot = slots[slot]
        local itemData = items[slot]
        if inventorySlot and isItemDataValid(itemData) then
            local itemLevel, itemQuality = retrieveItemData(itemData)

            if isItemBorderEnabled(unit) then
                inventorySlot:ShowBorder(itemQuality)
            end

            if isItemLevelEnabled(unit, slot) then
                inventorySlot:ShowLabel(itemQuality, itemLevel)
            end

            if unit == "player" then
                local current, maximum = GetInventoryItemDurability(slot)
                local durabilityPercent = (current and maximum and maximum > 0) and math.floor((current / maximum) * 100)
                if durabilityPercent then
                    inventorySlot:ShowDurability(durabilityPercent)
                else
                    inventorySlot:HideDurability()
                end
            end
        end
    end
end

BIBus:RegisterEvent(name .. "_SLOTS_READY", displayUniSlotInfo)
