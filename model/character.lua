
local name, ns = ...

ns["player" .. "items"] = ns["player" .. "items"] or {}

local function evaluateItemsCache()
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local itemData = ns["player" .. "items"][slot]
        if not itemData or not itemData.cached then return end
    end
    ns:TriggerEvent("BETTERILVL_ALL_ITEMS_CACHED")
end

local function cacheItemSlot(slot)
    local itemSlot = ns["player" .. "items"][slot]

    itemSlot:Initialize()

    local itemID = GetInventoryItemID("player", slot)
    if not itemID then itemSlot:Clear() return end
    if itemSlot.itemID == itemID and itemSlot.cached then return end

    local item = Item:CreateFromItemID(itemID)
    if not item then itemSlot:Clear() return end

    item:ContinueOnItemLoad(function()
        itemSlot:SetItem(item)
    end)
end

local function onPlayerEquipmentChanged(_, slot)
    cacheItemSlot(slot)
end

local function cacheCharacterItems()
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        cacheItemSlot(slot)
    end
end

local function createCharacterItems()
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local item = {}
        item.Initialize = function(self)
            self.item = nil
            self.cached = false
        end
        item.SetItem = function (self, item)
            self.item = item
            self.cached = true
            evaluateItemsCache()
        end
        item.Clear = function(self)
            self.item = nil
            self.cached = true
            evaluateItemsCache()
        end
        item:Initialize()
        ns["player" .. "items"][slot] = item
    end
end

local function onAddonLoaded(_, addon)
    if addon ~= name then return end
    createCharacterItems()
    cacheCharacterItems()
end

ns:RegisterEvent("ADDON_LOADED", onAddonLoaded, MID_PRIORITY)
ns:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", onPlayerEquipmentChanged)