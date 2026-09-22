local name, ns = ...

local enums = ns.enums

local cachedSlots = {}

local function isItemBorderenabled(unit)
    if (unit == "player") then
        return ns.db.borderColor
    else
        return ns.db.targetBorderColor
    end
end

local function createBorderTexture(frame)
    if not frame or frame.border then return end

    frame.border = frame:CreateTexture(nil, "OVERLAY")
    frame.border:SetPoint("TOPLEFT", frame, "TOPLEFT", -15, 15)
    frame.border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 15, -15)
    frame.border:SetTexture("Interface/Buttons/UI-ActionButton-Border")
    frame.border:SetBlendMode("ADD")
    frame.border:SetAlpha(0.5)

    frame.ShowBorder = function(self, itemQuality)
        if not self.border then return end
        local r, g, b = itemQuality[1], itemQuality[2], itemQuality[3]
        self.border:SetVertexColor(r, g, b)
        self.border:Show()
    end

    frame.HideBorder = function(self)
        if not self.border then return end
        self.border:Hide()
    end

    frame:HideBorder()
end

local function retrieveFrame(unit, slotName)
    local frameName = (unit == "player") and "Character" or "Inspect"
    return _G[frameName .. slotName]
end

local function isItemValid(invSlotId)
    local itemData = cachedSlots[invSlotId]
    return itemData and itemData.item
end

local function displayItemBorder(frame, slotId)
    if not frame then return end
    local invSlotId = enums.slotIdType[slotId]
    if isItemValid(invSlotId) then
        local itemData = cachedSlots[invSlotId]
        frame:ShowBorder(itemData.itemQualityColor)
    else
        frame:HideBorder()
    end
end

local function canRangedWeaponUseAmmo()
    local itemData = cachedSlots[enums.slotIdType.INVSLOT_RANGED]
    if not itemData or not itemData.item then return false end

    local itemId = itemData.item:GetItemID(itemData)
    local _, _, _, _, _, _, itemSubType = C_Item.GetItemInfo(itemId)
    return (itemSubType == "Crossbow" or itemSubType == "Bows" or itemSubType == "Guns")
end

local function evaluateAmmoSlot(unit)
    if canRangedWeaponUseAmmo() then return end

    local frame = retrieveFrame(unit, enums.slotNameType.INVSLOT_AMMO)
    if not frame or not frame.border then return else frame:HideBorder() end
end

local function onItemsCached(_, unit, slots)
    cachedSlots = slots or {}
    for slotId, slotName in pairs(enums.slotNameType) do
        if isItemBorderenabled(unit) then
            local frame = retrieveFrame(unit, slotName)
            createBorderTexture(frame)
            displayItemBorder(frame, slotId)
        end
    end

    evaluateAmmoSlot(unit)
end

ns.bus:RegisterEvent(name .. "_ITEMS_CACHED", onItemsCached)

local function onSettingsChanged(_, key)
    if key == "border" then
        onItemsCached(nil, "player", cachedSlots)
        onItemsCached(nil, "target", cachedSlots)
    end
end

ns.bus:RegisterEvent(name .. "_SETTINGS_CHANGED", onSettingsChanged)
