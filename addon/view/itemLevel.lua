local name, ns = ...

local enums = ns.enums
local cachedSlots = {}

local function isItemLevelEnabled(unit)
    if (unit == "player") then
        return ns.db.itemLevel
    else
        return ns.db.targetItemLevel
    end
end

local function createItemLevelText(frame)
    if not frame or frame.itemLevel then return end

    frame.itemLevel = frame:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    frame.itemLevel:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -2)
    frame.itemLevel:SetShadowOffset(1, -1)
    frame.itemLevel:SetShadowColor(0, 0, 0, 1)

    frame.ShowItemLabel = function(self, itemQualityColor, itemLevel)
        if not self.itemLevel then return end
        local r, g, b = itemQualityColor[1], itemQualityColor[2], itemQualityColor[3]
        self.itemLevel:SetTextColor(r, g, b)
        self.itemLevel:SetText(itemLevel)
        self.itemLevel:Show()
    end

    frame.HideItemLabel = function(self)
        if not self.itemLevel then return end
        self.itemLevel:SetText("")
        self.itemLevel:Hide()
    end

    frame:HideItemLabel()
    return frame.itemLevel
end


local function retrieveItemData(itemData)
    return itemData.item:GetCurrentItemLevel(), itemData.itemQualityColor
end

local function retrieveFrame(unit, slotName)
    local frameName = (unit == "player") and "Character" or "Inspect"
    return _G[frameName .. slotName]
end

local function displayItemLevel(unit, frame, key)
    if not frame then return end
    local itemData = cachedSlots[unit] and cachedSlots[unit][enums.slotIdType[key]]

    if itemData and itemData.item then
        local itemLevel, itemQuality = retrieveItemData(itemData)
        frame:ShowItemLabel(itemQuality, itemLevel)
    else
        frame:HideItemLabel()
    end
end

local function canRangedWeaponUseAmmo(unit)
    local itemData = cachedSlots[unit] and cachedSlots[unit][enums.slotIdType.INVSLOT_RANGED]
    if not itemData or not itemData.item then return false end

    local itemId = itemData.item:GetItemID(itemData)
    local _, _, _, _, _, _, itemSubType = C_Item.GetItemInfo(itemId)
    return (itemSubType == "Crossbow" or itemSubType == "Bows" or itemSubType == "Guns")
end

local function evaluateAmmoSlot(unit)
    if canRangedWeaponUseAmmo(unit) then return end

    local frame = retrieveFrame(unit, enums.slotNameType.INVSLOT_AMMO)
    if not frame or not frame.itemLevel then return else frame:HideItemLabel() end
end

local function hideItemLevels(unit)
    for _, slotName in pairs(enums.slotNameType) do
        local frame = retrieveFrame(unit, slotName)
        if frame and frame.itemLevel then
            frame:HideItemLabel()
        end
    end
end

local function refreshItemLevels(unit)
    if not isItemLevelEnabled(unit) then
        hideItemLevels(unit)
        return
    end

    for key, slotName in pairs(enums.slotNameType) do
        local frame = retrieveFrame(unit, slotName)
        createItemLevelText(frame)
        displayItemLevel(unit, frame, key)
    end

    evaluateAmmoSlot(unit)
end

local function onItemsCached(_, unit, slots)
    cachedSlots[unit] = slots or {}
    refreshItemLevels(unit)
end

ns.bus:RegisterEvent(name .. "_ITEMS_CACHED", onItemsCached)

local function onSettingsChanged(_, key)
    if key == "itemLevel" then
        refreshItemLevels("player")
    elseif key == "targetItemLevel" then
        refreshItemLevels("target")
    end
end

ns.bus:RegisterEvent(name .. "_SETTINGS_CHANGED", onSettingsChanged)
