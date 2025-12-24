
local function IsLabelEnabledFor(unit)
    if UnitHelper.IsPlayer(unit) then
        return Settings.IsPlayeriLvlEnabled()
    elseif UnitHelper.IsTarget(unit) then
        return Settings.IsTargetiLvlEnabled()
    end
    return false
end

local function IsBorderEnabledFor(unit)
    if UnitHelper.IsPlayer(unit) then
        return Settings.IsPlayerBorderEnabled()
    elseif UnitHelper.IsTarget(unit) then
        return Settings.IsTargetBorderEnabled()
    end
    return false
end

local function ShowBorderOn(slot, itemQuality)
    if not Border.IsValid(slot) then
        Border.CreateOn(slot)
    end
    Border.ConfigureWith(slot, itemQuality)
    Border.ShowOn(slot)
end

local function ShowLabelOn(slot, itemQuality, itemLevel)
    if not ItemLabel.IsValid(slot) then
        ItemLabel.CreateOn(slot)
    end
    ItemLabel.ConfigureWith(slot, itemQuality)
    ItemLabel.ShowOn(slot, itemLevel)
end

function ShowSlotiLvlOn(unit)

    local isLabelEnabled = IsLabelEnabledFor(unit)
    local isBorderEnabled = IsBorderEnabledFor(unit)

    if not isLabelEnabled and not isBorderEnabled then
        return
    end

    for _, slotName in ipairs(SlotHelper.slots) do
        isLabelEnabled = isLabelEnabled and not SlotHelper.IsAmmoSlot(slotName)

        local slot = SlotHelper.GetUnitSlot(unit, slotName)
        local _, itemQuality, itemLevel = SlotHelper.GetItemInfoFrom(unit, slotName)

        if isBorderEnabled and itemQuality then
            ShowBorderOn(slot, itemQuality)
        else
            Border.HideFrom(slot)
        end

        if isLabelEnabled and itemQuality and itemLevel then
            ShowLabelOn(slot, itemQuality, itemLevel)
        else
            ItemLabel.HideFrom(slot)
        end

    end

end

function HideSlotiLvlFrom(unit)
    for _, slotName in ipairs(SlotHelper.slots) do
        local slot = SlotHelper.GetUnitSlot(unit, slotName)
        ItemLabel.HideFrom(slot)
        Border.HideFrom(slot)
    end
end