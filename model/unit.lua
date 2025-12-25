
local name, ns = ...

ns["player" .. "items"] = ns["player" .. "items"] or {}
ns["target" .. "items"] = ns["target" .. "items"] or {}

local function evaluateItemsCache(unit)
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local itemData = ns[unit .. "items"][slot]
        if not itemData or not itemData.cached then return end
    end
    ns:TriggerEvent("BETTERILVL_ITEMS_CACHED", unit)
end

local function cacheItemSlot(slot, unit)
    local itemSlot = ns[unit .. "items"][slot]

    itemSlot:Initialize()

    local itemID = GetInventoryItemID(unit, slot)
    if not itemID then itemSlot:Clear() return end
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
    print("Created items for unit: " .. unit)
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
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
        ns[unit .. "items"][slot] = item
    end
end

local function cacheUnitItems(unit)
    print("Caching items for unit: " .. unit)
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        cacheItemSlot(slot, unit)
    end
end

local function onInspectReady(_)
    ns:TriggerEvent("BETTERILVL_REQUEST_SLOTS", "target")
    cacheUnitItems("target")
end

local function onAddonLoaded(_, addon)
    if addon ~= name then return end
    createUnitItems("player")
    ns:TriggerEvent("BETTERILVL_REQUEST_SLOTS", "player")
    cacheUnitItems("player")

    createUnitItems("target")
end

ns:RegisterEvent("ADDON_LOADED", onAddonLoaded, MID_PRIORITY)
ns:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", onPlayerEquipmentChanged)

ns:RegisterEvent("INSPECT_READY", onInspectReady)