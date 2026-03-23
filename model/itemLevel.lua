local name, ns = ...

local function getItemEquipLoc(item)
    if not item then return nil end
    return select(4, C_Item.GetItemInfoInstant(item:GetItemID()))
end

local function retrieveItemData(item)
    return item:GetCurrentItemLevel() or 0,  item:GetItemQuality() or 0
end

local function calculateUnitItemLevel(_, unit)
    local items = ns[unit].items

    local totalLevel, itemsQuality = 0, {}
    local itemCount = 0
    for slot = INVSLOT_AMMO, INVSLOT_LAST_EQUIPPED do
        local item = items[slot].item
        if item then
            local itemEquipLoc = getItemEquipLoc(item)
            if itemEquipLoc ~= "INVTYPE_TABARD" and itemEquipLoc ~= "INVTYPE_BODY" and slot ~= INVSLOT_AMMO then
                local itemLevel, itemQuality = retrieveItemData(item)
                if itemQuality == (Enum.ItemQuality and Enum.ItemQuality.Heirloom) or itemQuality == 7 then
                    itemLevel = 0
                end
                totalLevel = totalLevel + itemLevel
                itemCount = itemCount + 1
                itemsQuality[itemQuality] = (itemsQuality[itemQuality] or 0) + 1
            end
        end
    end

    local dominantQuality, maxCount = 0, -1
    local endQuality = (Enum.ItemQuality and (Enum.ItemQuality.Heirloom or Enum.ItemQuality.Artifact)) or 7
    for index = Enum.ItemQuality.Poor, endQuality do
        local count = itemsQuality[index] or 0
        if count >= maxCount then
            dominantQuality, maxCount = index, count
        end
    end

    local average = (itemCount > 0) and (totalLevel / itemCount) or 0
    ns[unit].itemLevel.average = average
    ns[unit].itemLevel.dominantQuality = dominantQuality

    BIBus:TriggerEvent(name .. "_ITEMLEVEL_CALCULATED", unit)
end

BIBus:RegisterEvent(name .. "_ITEMS_CACHED", calculateUnitItemLevel)