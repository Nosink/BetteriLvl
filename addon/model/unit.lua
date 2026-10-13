local name, ns = ...

local enums = ns.enums
local items = { player = { slots = {} }, target = { slots = {} } }

local function cacheItem(unit, invSlotId)
    local itemData = items[unit].slots[invSlotId]
    if not itemData then return end

    itemData:ClearItem()
    local itemLink = GetInventoryItemLink(unit, invSlotId)

    if not itemLink then
        itemData:SetRetry(unit, invSlotId)
    else
        itemData:SetItem(itemLink)
    end
end

local function getItemQualityColor(itemQuality)
    if type(itemQuality) == "number" then
        return { C_Item.GetItemQualityColor(itemQuality) }
    end
    return { 1, 1, 1, 1 }
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
    end

    itemData.ClearItem = function(self)
        self.itemLevel = nil
        self.itemQuality = nil
        self.itemSubType = nil
        self.itemQualityColor = nil
    end

    itemData.PerformRetry = function(self)
        local itemLink = GetInventoryItemLink(self.unit, self.invSlotId)
        if itemLink then
            self:SetItem(itemLink)
            ns.bus:TriggerEvent(name .. "_ITEMS_CACHED", self.unit, items[self.unit].slots)
        else
            if self.retries <= 0 then return end
            self.retries = self.retries - 1
            C_Timer.After(0.2, function() self:PerformRetry() end)
        end
    end

    itemData.SetRetry = function(self, unit, invSlotId)
        self.unit = unit
        self.retries = 3
        self.invSlotId = invSlotId
        self:PerformRetry()
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
