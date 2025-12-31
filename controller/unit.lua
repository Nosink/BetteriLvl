local name, ns = ...

local settings = ns.settings

local function isItemDataValid(itemData)
    return itemData and itemData.cached and itemData.item and itemData.item:IsItemDataCached()
end

local function retrieveItemData(itemData)
    return itemData.item:GetCurrentItemLevel(),  itemData.item:GetItemQuality()
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
        end
    end
end

ns:RegisterEvent(name .. "_SLOTS_READY", displayUniSlotInfo, MID_PRIORITY)