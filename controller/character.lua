local name, ns = ...

ns["player" .. "slots"] = ns["player" .. "slots"] or {}
ns["player" .. "items"] = ns["player" .. "items"] or {}

local function displayCharacterBorders()
    local slots = ns["player" .. "slots"]
    local items = ns["player" .. "items"]
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local equipSlot = slots[slot]
        local itemData = items and items[slot]
        if equipSlot and itemData and itemData.cached and itemData.item then
            local itemQuality = itemData.item:GetItemQuality()
            equipSlot:Configure(itemQuality)
            equipSlot:Show()
        elseif equipSlot then
            equipSlot:Hide()
        end
    end
end

ns:RegisterEvent("BETTERILVL_ALL_ITEMS_CACHED", displayCharacterBorders)
