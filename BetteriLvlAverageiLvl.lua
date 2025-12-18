
function ShowAverageiLvlOf(unit)

    local slot = SlotHelper.GetUnitSlot(unit, SlotHelper.secondaryHandSlotName)
    local averageItemLevel, maxQuality = UnitHelper.GetAverageiLvlFor(unit)

    if not AverageLabel.IsValid(slot) then
        AverageLabel.CreateOn(slot)
    end

    AverageLabel.ConfigureWith(unit, slot, maxQuality)
    AverageLabel.ShowOn(slot, averageItemLevel)

end

function HideAverageiLvlFrom(unit)
    local slot = SlotHelper.GetUnitSlot(unit, SlotHelper.secondaryHandSlotName)
    AverageLabel.HideFrom(slot)
end