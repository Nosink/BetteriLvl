local _, ns = ...

local function getItemEquipLoc(item)
    if not item then return nil end
    return select(4, C_Item.GetItemInfoInstant(item:GetItemID()))
end

local function calculateUnitItemLevel(_, unit)
    local items = ns[unit].items

    local mainHandEquipLoc = getItemEquipLoc(items[INVSLOT_MAINHAND].item)
    local offHandEquipLoc = getItemEquipLoc(items[INVSLOT_OFFHAND].item)
    local rangedEquipLoc = getItemEquipLoc(items[INVSLOT_RANGED].item)

    local twoHands = "INVTYPE_2HWEAPON" == (mainHandEquipLoc or offHandEquipLoc)
    local mainHand = mainHandEquipLoc ~= nil
    local offHand = offHandEquipLoc ~= nil
    local bothHands = mainHand and offHand
    local ranged = rangedEquipLoc ~= nil and not bothHands and not twoHands

    local totalLevel = 0
    local itemsQuality = {}

    for slot = INVSLOT_AMMO, INVSLOT_LAST_EQUIPPED do
        local item = items[slot].item
        if item then
            local itemEquipLoc = getItemEquipLoc(item)
            if itemEquipLoc ~= "INVTYPE_TABARD" and itemEquipLoc ~= "INVTYPE_BODY" then
                local itemLevel = item:GetCurrentItemLevel()
                local itemQuality = item:GetItemQuality()
                if ranged then
                    totalLevel = totalLevel + itemLevel
                else
                    if (slot ~= INVSLOT_RANGED) then
                        totalLevel = totalLevel + itemLevel
                    end
                end
                itemsQuality[itemQuality] = (itemsQuality[itemQuality] or 0) + 1
            end
        end
    end

    local dominantQuality, maxCount = 0, -1
    for index = Enum.ItemQuality.Poor, Enum.ItemQuality.Artifact do
        local count = itemsQuality[index] or 0
        if count >= maxCount then
            dominantQuality, maxCount = index, count
        end
    end

    local numSlots = 16
    if offHand or (mainHand and not twoHands and not bothHands) then
        numSlots = numSlots + 1
    end

    ns[unit].itemLevel.average = totalLevel / numSlots
    ns[unit].itemLevel.dominantQuality = dominantQuality

    ns:TriggerEvent("BETTERILVL_ITEMLEVEL_CALCULATED", unit)
end

ns:RegisterEvent("BETTERILVL_ITEMS_CACHED", calculateUnitItemLevel)