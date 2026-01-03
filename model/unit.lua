
local name, ns = ...

local function evaluateItemsCache(unit)
    for slot = INVSLOT_AMMO, INVSLOT_LAST_EQUIPPED do
        local itemData = ns[unit].items[slot]
        if not itemData or not itemData.cached then return end
    end
    ns:TriggerEvent(name .. "_ITEMS_CACHED", unit)
end

local function cacheItemSlot(slot, unit)
    local itemSlot = ns[unit].items[slot]
    itemSlot:Initialize()

    local itemID = GetInventoryItemID(unit, slot)
    if not itemID or itemID == 0 then itemSlot:Clear() return end
    if itemSlot.itemID == itemID and itemSlot.cached then return end

    local item = Item:CreateFromItemID(itemID)
    if not item then itemSlot:Clear() return end

    item:ContinueOnItemLoad(function()
        itemSlot:SetItem(item)
    end)
end


local function onPlayerEquipmentChanged(_, slot)
    cacheItemSlot(slot, "player")
end

local function createUnitItems(unit)
    for slot = INVSLOT_AMMO, INVSLOT_LAST_EQUIPPED do
        local item = {}
        item.Initialize = function(self)
            self.item = nil
            self.cached = false
        end
        item.SetItem = function (self, item)
            self.item = item
            self.cached = true
            evaluateItemsCache(unit)
        end
        item.Clear = function(self)
            self.item = nil
            self.cached = true
            evaluateItemsCache(unit)
        end
        item:Initialize()
        ns[unit].items[slot] = item
    end
end

local function cacheUnitItems(unit)
    for slot = INVSLOT_AMMO, INVSLOT_LAST_EQUIPPED do
        cacheItemSlot(slot, unit)
    end
end

local function onInspectReady(_, _)
    createUnitItems(ns.unit)
    cacheUnitItems(ns.unit)
end

local function onAddonLoaded()
    createUnitItems("player")
    cacheUnitItems("player")
end

local function onNotifyInspect(unit)
    ns:TriggerEvent(name .. "_REQUEST_VARS", unit)
end

local function onTargetVarsReady(_, unit)
    ns.unit = unit
end

ns:RegisterEvent(name .. "_ADDON_LOADED", onAddonLoaded)
ns:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", onPlayerEquipmentChanged)
ns:RegisterEvent("INSPECT_READY", onInspectReady)
ns:HookSecureFunc("NotifyInspect", onNotifyInspect)
ns:RegisterEvent(name .. "_TARGET_VARS_READY", onTargetVarsReady)