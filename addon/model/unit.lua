local name, ns = ...

local enums = ns.enums
local items = { player = { slots = {} }, target = { slots = {} } }

local function cacheItem(unit, invSlotId)
    if not items[unit].slots[invSlotId] then return end

    items[unit].slots[invSlotId]:ClearItem()

    local itemLink = GetInventoryItemLink(unit, invSlotId)
    if not itemLink then return end
    items[unit].slots[invSlotId]:SetItem(itemLink)
end

local function createItem(unit, invSlotId)
    if items[unit].slots[invSlotId] then return end

    local itemData = { item = nil, cached = false }

    itemData.SetItem = function(self, itemLink)
        local _, _, itemQuality, itemLevel, _, _, itemSubType = C_Item.GetItemInfo(itemLink)
        local itemQualiityColor = { C_Item.GetItemQualityColor(itemQuality) }
        self.itemLevel = itemLevel
        self.itemQuality = itemQuality
        self.itemSubType = itemSubType
        self.itemQualityColor = itemQualiityColor
    end

    itemData.ClearItem = function(self)
        self.itemLevel = nil
        self.itemQuality = nil
        self.itemSubType = nil
        self.itemQualityColor = nil
    end

    items[unit].slots[invSlotId] = itemData
end

local function loadEquipment(unit)
    for slotKey, _ in pairs(enums.slotIdType) do
        local invSlotId = enums.slotIdType[slotKey]
        createItem(unit, invSlotId)
        cacheItem(unit, invSlotId)
    end
    ns.bus:TriggerEvent(name .. "_ITEMS_CACHED", unit, items[unit].slots)
end

local function onCharacterFrameShown()
    loadEquipment("player")
end

local function onPlayerEquipmentChanged()
    loadEquipment("player")
end

local function onPlayerDurabilityChanged()
    loadEquipment("player")
end

local function onInspectReady(_)
    loadEquipment("target")
end


ns.bus:RegisterEvent(name .. "_CHARACTER_FRAME_SHOWN", onCharacterFrameShown)
ns.bus:RegisterEvent(name .. "_PLAYER_EQUIPMENT_CHANGED", onPlayerEquipmentChanged)
ns.bus:RegisterEvent(name .. "_UPDATE_INVENTORY_DURABILITY", onPlayerDurabilityChanged)

ns.bus:RegisterEvent(name .. "_INSPECT_READY", onInspectReady)
