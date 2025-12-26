local _, ns = ...

local settings = ns.settings

local function displaySlotBorder(_, unit)
    if settings.IsUnitBorderDisabled(unit) then return end

    local slots = ns[unit].slots
    local items = ns[unit].items
    for slot = INVSLOT_AMMO, INVSLOT_LAST_EQUIPPED do
        local equipSlot = slots[slot]
        local itemData = items[slot]
        if equipSlot and itemData and itemData.cached and itemData.item and itemData.item:IsItemDataCached() then
            local itemQuality = itemData.item:GetItemQuality()
            equipSlot:ConfigureBorder(itemQuality)
            equipSlot:ShowBorder()
        elseif equipSlot then
            equipSlot:HideBorder()
        end
    end
end

local function displaySlotItemLevel(_, unit)
    if settings.IsItemLevelDisabled(unit) then return end

    local slots = ns[unit].slots
    local items = ns[unit].items
    for slot = INVSLOT_AMMO, INVSLOT_LAST_EQUIPPED do
        local equipSlot = slots[slot]
        local itemData = items[slot]
        if equipSlot and itemData and itemData.cached and itemData.item and itemData.item:IsItemDataCached() then
            local itemLevel = itemData.item:GetCurrentItemLevel()
            local itemQuality = itemData.item:GetItemQuality()
            if slot ~= INVSLOT_AMMO then
                equipSlot:ConfigureLabel(itemQuality, itemLevel)
                equipSlot:ShowLabel()
            end
        elseif equipSlot then
            equipSlot:HideLabel()
        end
    end
end

ns:RegisterEvent("BETTERILVL_SLOTS_READY", displaySlotBorder, MID_PRIORITY)
ns:RegisterEvent("BETTERILVL_SLOTS_READY", displaySlotItemLevel, MID_PRIORITY)