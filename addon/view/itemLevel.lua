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
    if not frame or frame.ItemLevel and frame.ItemLevel.isInitialized then return end

    frame.ItemLevel = frame:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    frame.ItemLevel:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -2)
    frame.ItemLevel:SetShadowOffset(1, -1)
    frame.ItemLevel:SetShadowColor(0, 0, 0, 1)

    frame.ShowItemLabel = function(self, itemData)
        if not self.ItemLevel then return end
        local r, g, b = itemData.itemQualityColor.r, itemData.itemQualityColor.g, itemData.itemQualityColor.b
        self.ItemLevel:SetTextColor(r, g, b)
        self.ItemLevel:SetText(itemData.itemLevel)
        self.ItemLevel:Show()
    end

    frame.HideItemLabel = function(self)
        if not self.ItemLevel then return end
        self.ItemLevel:SetText("")
        self.ItemLevel:Hide()
    end

    frame.ItemLevel.isInitialized = true
    frame:HideItemLabel()
end


local function retrieveFrame(unit, slotName)
    local frameName = (unit == "player") and "Character" or "Inspect"
    return _G[frameName .. slotName]
end

local function displayItemLevel(unit, frame, key)
    if not frame then return end
    local itemData = cachedSlots[unit] and cachedSlots[unit][enums.slotIdType[key]]

    if itemData then
        frame:ShowItemLabel(itemData)
    else
        frame:HideItemLabel()
    end
end

local function canRangedWeaponUseAmmo(unit)
    local itemData = cachedSlots[unit] and cachedSlots[unit][enums.slotIdType.INVSLOT_RANGED]
    if not itemData then return false end

    return (itemData.itemSubType == "Crossbow" or itemData.itemSubType == "Bows" or itemData.itemSubType == "Guns")
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
