
UnitHelper = {}

UnitHelper.Target = "target"
UnitHelper.Player = "player"

function UnitHelper.IsTarget(unit)
    return unit == UnitHelper.Target
end

function UnitHelper.IsPlayer(unit)
    return unit == UnitHelper.Player
end

function UnitHelper.CalculateItemLevelAndQualityFor(unit)
    local totalItemLevel = 0
    local itemsQuality = {}

    for _, slotName in ipairs(SlotHelper.slots) do
        local _, itemQuality, itemLevel = SlotHelper.GetItemInfoFrom(unit, slotName)
        if itemQuality and itemLevel then
            totalItemLevel = totalItemLevel + itemLevel
            itemsQuality[itemQuality] = (itemsQuality[itemQuality] or 0) + 1
        end
    end

    local maxQuality, maxCount = 0, -1
    for index = 0, 7 do
        local count = itemsQuality[index] or 0
        if count >= maxCount then
            maxQuality, maxCount = index, count
        end
    end

    return totalItemLevel, maxQuality
end

function UnitHelper.GetAverageiLvlFor(unit)
    local totalItemLevel, maxQuality = UnitHelper.CalculateItemLevelAndQualityFor(unit)
    local averageItemLevel = totalItemLevel / AverageLabel.data.slotsAmount
    print("Total item level: " .. tostring(totalItemLevel) .. ", slots: " .. tostring(AverageLabel.data.slotsAmount) .. " ave " .. averageItemLevel)
    return averageItemLevel, maxQuality
end