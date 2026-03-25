local name, ns = ...

local utils = ns.utils

local fontStrings = {}

local function createItemLevelText(slotFrame)
    if fontStrings[slotFrame] then return end

    slotFrame.itemLevel = slotFrame:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    slotFrame.itemLevel:SetPoint("TOPLEFT", slotFrame, "TOPLEFT", 1, -2)
    slotFrame.itemLevel:SetShadowOffset(1, -1)
    slotFrame.itemLevel:SetShadowColor(0, 0, 0, 1)

    slotFrame.ShowItemLabel = function(self, itemQuality, itemLevel)
        if not self.itemLevel then return end
        local r, g, b = utils.GetItemQualityColor(itemQuality)
        self.itemLevel:SetTextColor(r, g, b)
        self.itemLevel:SetText(itemLevel)
        self.itemLevel:Show()
    end

    slotFrame.HideItemLabel = function(self)
        if not self.itemLevel then return end
        self.itemLevel:Hide()
    end

    slotFrame:HideItemLabel()
    return slotFrame.itemLevel
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


local function retrieveItemData(itemData)
    return itemData.item:GetCurrentItemLevel(), itemData.item:GetItemQuality()
end

local function onItemsCached(_, unit, slots)
    local frameName = (unit == "player") and "Character" or "Inspect"
    for invSlotId = INVSLOT_AMMO, INVSLOT_LAST_EQUIPPED do
        local slotFrame = _G[frameName .. slotNames[invSlotId]]
        for k, v in pairs(slotFrame) do
            print(k .. ": " .. tostring(v))
        end
        createItemLevelText(slotFrame)

        local itemData = slots[invSlotId]
        if itemData and itemData.item then
            local itemLevel, itemQuality = retrieveItemData(itemData)
            slotFrame:ShowItemLabel(itemQuality, itemLevel)
        else
            slotFrame:HideItemLabel()
        end
    end
end

BIBus:RegisterEvent(name .. "_ITEMS_CACHED", onItemsCached)
