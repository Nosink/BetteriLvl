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
    if not frame or frame.Border and frame.Border.isInitialized then return end

    if frame.IconBorder then frame.IconBorder:Hide() end

    frame.Border = frame:CreateTexture(nil, "OVERLAY")
    frame.Border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 15, -15)
    frame.Border:SetPoint("TOPLEFT", frame, "TOPLEFT", -15, 15)
    frame.Border:SetTexture("Interface/Buttons/UI-ActionButton-Border")
    frame.Border:SetBlendMode("ADD")
    frame.Border:SetAlpha(0.5)

    frame.ShowBorder = function(self, itemData)
        if not self.Border then return end
        local r, g, b = unpack(itemData.itemQualityColor)
        self.Border:SetVertexColor(r, g, b)
        self.Border:Show()
    end

    frame.HideBorder = function(self)
        if not self.Border then return end
        self.Border:Hide()
    end

    frame.Border.isInitialized = true
    frame:HideBorder()
end

local function retrieveFrame(unit, slotName)
    local frameName = (unit == "player") and "Character" or "Inspect"
    return _G[frameName .. slotName]
end

local function isItemValid(unit, invSlotId)
    return cachedSlots[unit]
        and cachedSlots[unit][invSlotId]
        and cachedSlots[unit][invSlotId].itemQualityColor
end

local function displayItemBorder(unit, frame, slotId)
    if not frame then return end
    local invSlotId = enums.slotIdType[slotId]

    if isItemValid(unit, invSlotId) then
        local itemData = cachedSlots[unit][invSlotId]
        frame:ShowBorder(itemData)
    else
        frame:HideBorder()
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
    if not frame or not frame.Border then return else frame:HideBorder() end
end

local function hideBorders(unit)
    for _, slotName in pairs(enums.slotNameType) do
        local frame = retrieveFrame(unit, slotName)
        if frame and frame.Border then
            frame:HideBorder()
        end
    end
end

local function refreshBorders(unit)
    if not isItemBorderenabled(unit) then
        hideBorders(unit)
        return
    end

    for slotId, slotName in pairs(enums.slotNameType) do
        local frame = retrieveFrame(unit, slotName)
        createBorderTexture(frame)
        displayItemBorder(unit, frame, slotId)
    end

    evaluateAmmoSlot(unit)
end

local function onItemsCached(_, unit, slots)
    cachedSlots[unit] = slots or {}
    refreshBorders(unit)
end

ns.bus:RegisterEvent(name .. "_ITEMS_CACHED", onItemsCached)

local function onSettingsChanged(_, key)
    if key == "borderColor" then
        refreshBorders("player")
    elseif key == "targetBorderColor" then
        refreshBorders("target")
    end
end

ns.bus:RegisterEvent(name .. "_SETTINGS_CHANGED", onSettingsChanged)
