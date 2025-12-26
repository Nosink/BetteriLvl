
local secondaryHandSlotName = "SecondaryHandSlot"

local function GetUnitSlot(unit, slotName)
    if unit == "player" then
        return _G["Character" .. slotName]
    elseif unit == "target" then
        return _G["Inspect" .. slotName] 
    end
end


local function RetrieveItem(unit, slot)
    if slot == INVSLOT_BODY or slot == INVSLOT_TABARD then return nil end

    local itemID = GetInventoryItemID(unit, slot)
    local itemLink = GetInventoryItemLink(unit, slot)

    if itemLink or itemID then
        local item = itemLink and Item:CreateFromItemLink(itemLink) or Item:CreateFromItemID(itemID)
        local equipLoc = select(4, C_Item.GetItemInfoInstant(itemLink or itemID))
        return item, equipLoc
    end
end

local function CalculateItemLevelAndQualityFor(unit)

    local items = {}
    local mainhandEquipLoc, offhandEquipLoc, rangedEquipLoc
    for slot = INVSLOT_AMMO, INVSLOT_LAST_EQUIPPED do
        local item, equipLoc = RetrieveItem(unit, slot)
        if item then
            local it = {item, slot}
            table.insert(items, it)
            if slot == INVSLOT_MAINHAND then mainhandEquipLoc = equipLoc end
            if slot == INVSLOT_OFFHAND then offhandEquipLoc = equipLoc end
            if slot == INVSLOT_RANGED then rangedEquipLoc = equipLoc end
        end
    end

    local numSlots = 16

    local twoHandPriority = "INVTYPE_2HWEAPON" == (mainhandEquipLoc or offhandEquipLoc)
    local somethingOnHands = mainhandEquipLoc or offhandEquipLoc
    local bothHandsOccupied = mainhandEquipLoc and offhandEquipLoc
    local rangedPriority = rangedEquipLoc and somethingOnHands and not bothHandsOccupied and not twoHandPriority

    local totalLevel = 0
    local itemsQuality = {}

    for _, item in ipairs(items) do
        local itemLevel = item[1]:GetCurrentItemLevel()
        local itemQuality = item[1]:GetItemQuality()
        local itemSlot = item[2]
        if rangedPriority then
            if (itemSlot ~= INVSLOT_MAINHAND and itemSlot ~= INVSLOT_OFFHAND) then 
                totalLevel = totalLevel + itemLevel
            end
        else
            if (itemSlot ~= INVSLOT_RANGED) then 
                totalLevel = totalLevel + itemLevel 
            end
        end
        itemsQuality[itemQuality] = (itemsQuality[itemQuality] or 0) + 1
    end

    local maxQuality, maxCount = 0, -1
    for index = 0, 7 do
        local count = itemsQuality[index] or 0
        if count >= maxCount then
            maxQuality, maxCount = index, count
        end
    end

    return (totalLevel / numSlots), maxQuality
end

local function GetAverageiLvlFor(unit)
    local averageItemLevel, maxQuality = CalculateItemLevelAndQualityFor(unit)
    return averageItemLevel, maxQuality
end

function ShowAverageiLvlOf(unit)

    local slot = GetUnitSlot(unit, secondaryHandSlotName)
    local averageItemLevel, maxQuality = GetAverageiLvlFor(unit)

    if not AverageLabel.IsValid(slot) then
        AverageLabel.CreateOn(slot)
    end

    AverageLabel.ConfigureWith(unit, slot, maxQuality)
    AverageLabel.ShowOn(slot, averageItemLevel)

end

function HideAverageiLvlFrom(unit)
    local slot = GetUnitSlot(unit, secondaryHandSlotName)
    AverageLabel.HideFrom(slot)
end