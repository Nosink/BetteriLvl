local name, _ = ...

local items = {}

local function cacheItem(unit, invSlotId)
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
    for invSlotId = INVSLOT_AMMO, INVSLOT_LAST_EQUIPPED do
        local itemData = items[unit].slots[invSlotId]
        if not itemData or not itemData.cached then return end
    end
    BIBus:TriggerEvent(name .. "_ITEMS_CACHED", unit, items[unit].slots)
end

local function createItems(unit)
    items[unit] = items[unit] or { slots = {} }

    for invSlotId = INVSLOT_AMMO, INVSLOT_LAST_EQUIPPED do
        if not items[unit].slots[invSlotId] then
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
        cacheItem(unit, invSlotId)
    end
end

local function onAddonLoaded(_)
    createItems("player")
end

local function onPlayerEquipmentChanged(_, equipmentSlot)
    cacheItem("player", equipmentSlot)
end

local function onInspectReady(_, unit)
    createItems(unit)
end

BIBus:RegisterEvent(name .. "_PLAYER_EQUIPMENT_CHANGED", onPlayerEquipmentChanged)
BIBus:RegisterEvent(name .. "_ADDON_LOADED", onAddonLoaded)

BIBus:RegisterEvent(name .. "_INSPECT_READY", onInspectReady)
