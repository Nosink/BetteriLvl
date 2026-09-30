local name, ns = ...

local enums = ns.enums
local items = {}
local function getItemQualityColor(quality)
    if C_Item and C_Item.GetItemQualityColor then
        local r, g, b = C_Item.GetItemQualityColor(quality)
        return { r = r, g = g, b = b }
    else
        return { r = 1, g = 1, b = 1 }
    end
end

local function cacheItem(unit, invSlotId)
    items[unit] = items[unit] or { slots = {} }
    local itemSlot = items[unit].slots[invSlotId]

    itemSlot:ClearItem()

    local itemId = GetInventoryItemID(unit, invSlotId)
    local itemLink = GetInventoryItemLink(unit, invSlotId)
    if not itemLink or itemId == 0 then return end

    if itemSlot.itemID == itemId and itemSlot.cached then return end

    itemSlot:SetItem(itemLink)
end

local function evaluateItemsCache(unit)
    for slotKey, _ in pairs(enums.slotIdType) do
        local invSlotId = enums.slotIdType[slotKey]
        local itemData = items[unit].slots[invSlotId]
        if not itemData or not itemData.cached then return end
    end
    ns.bus:TriggerEvent(name .. "_ITEMS_CACHED", unit, items[unit].slots)
end

local function createItem(unit, invSlotId)
    if items[unit].slots[invSlotId] then return end

    local itemData = { item = nil, cached = false }
    itemData.SetItem = function(self, itemLink)
        local _, _, itemQuality, itemLevel, _, _, itemSubType = C_Item.GetItemInfo(itemLink)
        self.itemLevel = itemLevel
        self.itemQuality = itemQuality
        self.itemSubType = itemSubType
        self.itemQualityColor = getItemQualityColor(itemQuality)
        self.cached = true
        evaluateItemsCache(unit)
    end
    itemData.ClearItem = function(self)
        self.cached = true
        evaluateItemsCache(unit)
    end
    items[unit].slots[invSlotId] = itemData
end

local function loadEquipment(unit)
    items[unit] = items[unit] or { slots = {} }

    for slotKey, _ in pairs(enums.slotIdType) do
        local invSlotId = enums.slotIdType[slotKey]
        createItem(unit, invSlotId)
        cacheItem(unit, invSlotId)
    end
end

local function onVariablesLoaded(_)
    loadEquipment("player")
end

local function onCharacterFrameShown(_)
    loadEquipment("player")
end

local function onPlayerEquipmentChanged(_, equipmentSlot)
    cacheItem("player", equipmentSlot)
end

local function onPlayerDurabilityChanged()
    for slotKey, _ in pairs(enums.slotIdType) do
        local invSlotId = enums.slotIdType[slotKey]
        cacheItem("player", invSlotId)
    end
end

local function onInspectReady(_, unit)
    loadEquipment(unit)
end

ns.bus:RegisterEvent(name .. "_VARIABLES_LOADED", onVariablesLoaded)

ns.bus:RegisterEvent(name .. "_CHARACTER_FRAME_SHOWN", onCharacterFrameShown)
ns.bus:RegisterEvent(name .. "_PLAYER_EQUIPMENT_CHANGED", onPlayerEquipmentChanged)
ns.bus:RegisterEvent(name .. "_UPDATE_INVENTORY_DURABILITY", onPlayerDurabilityChanged)

ns.bus:RegisterEvent(name .. "_INSPECT_READY", onInspectReady)
