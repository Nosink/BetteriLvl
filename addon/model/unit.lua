local _, ns = ...

local enums = ns.enums

local moduleName = "CHARACTER_FRAME"
local bus = ns.Module(moduleName):GetBus()

local items = {}

local function cacheItem(unit, invSlotId)
    items[unit] = items[unit] or { slots = {} }
    local itemSlot = items[unit].slots[invSlotId]

    itemSlot:ClearItem()

    local itemId = GetInventoryItemID(unit, invSlotId)
    if not itemId or itemId == 0 then return end

    if itemSlot.itemID == itemId and itemSlot.cached then return end

    local item = Item:CreateFromItemID(itemId)
    if not item then return end

    item:ContinueOnItemLoad(function()
        itemSlot:SetItem(item)
    end)
end

local function evaluateItemsCache(unit)
    for slotKey, _ in pairs(enums.slotIdType) do
        local invSlotId = enums.slotIdType[slotKey]
        local itemData = items[unit].slots[invSlotId]
        if not itemData or not itemData.cached then return end
    end
    bus:TriggerEvent(moduleName .. "_ITEMS_CACHED", unit, items[unit].slots)
end

local function createItem(unit, invSlotId)
    if items[unit].slots[invSlotId] then return end

    local itemData = { item = nil, cached = false }
    itemData.SetItem = function(self, item)
        self.item = item
        self.cached = true
        evaluateItemsCache(unit)
    end
    itemData.ClearItem = function(self)
        self.item = nil
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

bus:RegisterEvent(moduleName .. "_VARIABLES_LOADED", onVariablesLoaded)
bus:RegisterEvent(moduleName .. "_PLAYER_EQUIPMENT_CHANGED", onPlayerEquipmentChanged)
bus:RegisterEvent(moduleName .. "_UPDATE_INVENTORY_DURABILITY", onPlayerDurabilityChanged)

bus:RegisterEvent(moduleName .. "_INSPECT_READY", onInspectReady)
