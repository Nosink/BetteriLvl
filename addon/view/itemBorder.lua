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

local function getItemBorderFrame(frame)
    if frame.IconBorder then return frame.IconBorder end
    frame.IconBorder = frame:CreateTexture(nil, "OVERLAY")
    return frame.IconBorder
end
local function setItemBorderPoint(frame)
    if (ns.expansion == enums.expansion.CLASSIC
            or ns.expansion == enums.expansion.BURNING_CRUSADE
            or ns.expansion == enums.expansion.WRATH_OF_THE_LICH_KING
            or ns.expansion == enums.expansion.CATACLYSM
            or ns.expansion == enums.expansion.MISTS_OF_PANDARIA) then
        frame.IconBorder:SetPoint("TOPLEFT", frame, "TOPLEFT", -15, 15)
        frame.IconBorder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 15, -15)
    end
end

local function createBorderTexture(frame)
    if not frame or frame.IconBorder and frame.IconBorder.isInitialized then return end

    frame.IconBorder = getItemBorderFrame(frame)
    setItemBorderPoint(frame)
    frame.IconBorder:SetTexture("Interface/Buttons/UI-ActionButton-Border")
    frame.IconBorder:SetBlendMode("ADD")
    frame.IconBorder:SetAlpha(0.5)

    frame.ShowBorder = function(self, itemData)
        if not self.IconBorder then return end
        local r, g, b = itemData.itemQualityColor.r, itemData.itemQualityColor.g, itemData.itemQualityColor.b
        self.IconBorder:SetVertexColor(r, g, b)
        self.IconBorder:Show()
    end

    frame.HideBorder = function(self)
        if not self.IconBorder then return end
        self.IconBorder:Hide()
    end

    frame.IconBorder.isInitialized = true
    frame:HideBorder()
end

local function retrieveFrame(unit, slotName)
    local frameName = (unit == "player") and "Character" or "Inspect"
    return _G[frameName .. slotName]
end

local function isItemValid(unit, invSlotId)
    return cachedSlots[unit] and cachedSlots[unit][invSlotId]
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
    if not frame or not frame.IconBorder then return else frame:HideBorder() end
end

local function hideBorders(unit)
    for _, slotName in pairs(enums.slotNameType) do
        local frame = retrieveFrame(unit, slotName)
        if frame and frame.IconBorder then
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
