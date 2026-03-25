local name, ns = ...

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

local function initializeUnitTargetVars()
    ns.targets = ns.targets or {}
end

local function initializeUnitVars(unit)
    ns.targets[unit] = true
    ns[unit] = ns[unit] or {}
    ns[unit].slots = ns[unit].slots or {}
    ns[unit].items = ns[unit].items or {}
    ns[unit].itemLevel = ns[unit].itemLevel or {}
end

local function onTargetRequestVars(_, unit)
    if not unit or unit == "" then return end

    if not ns.targets[unit] then
        initializeUnitVars(unit)
    end

    BIBus:TriggerEvent(name .. "_TARGET_VARS_READY", unit)
end

local function onInitializeUnitRequested()
    initializeUnitTargetVars()
    initializeUnitVars("player")

    BIBus:TriggerEvent(name .. "_ADDON_LOADED")
end

BIBus:RegisterEvent(name .. "_REQUEST_VARS", onTargetRequestVars)
BIBus:RegisterEvent(name .. "_INITIALIZE_UNITS_REQUEST", onInitializeUnitRequested)
