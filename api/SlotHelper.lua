
SlotHelper = {}

SlotHelper.secondaryHandSlotName = "SecondaryHandSlot"
SlotHelper.ammoSlotName = "AmmoSlot"
SlotHelper.slots = {
    "HeadSlot",
    "NeckSlot",
    "ShoulderSlot",
    "BackSlot",
    "ChestSlot",
    "ShirtSlot",
    "TabardSlot",
    "WristSlot",
    "HandsSlot",
    "WaistSlot",
    "LegsSlot",
    "FeetSlot",
    "Finger0Slot",
    "Finger1Slot",
    "Trinket0Slot",
    "Trinket1Slot",
    "MainHandSlot",
    "SecondaryHandSlot",
    "RangedSlot",
    "AmmoSlot"
}

function SlotHelper.IsAmmoSlot(slotName)
    return SlotHelper.ammoSlotName == slotName
end

function SlotHelper.GetItemInfoFrom(unit, slotName)
    local slotId = GetInventorySlotInfo(slotName)
    if not slotId then return nil end

    local itemId = GetInventoryItemID(unit, slotId)
    if not itemId then return nil end

    local itemLink, _, itemQuality, itemLevel = C_Item.GetItemInfo(itemId)
    return itemLink, itemQuality, itemLevel
end

function SlotHelper.GetUnitSlot(unit, slotName)
    if UnitHelper.IsPlayer(unit) then
        return _G["Character" .. slotName]
    elseif UnitHelper.IsTarget(unit) then
        return _G["Inspect" .. slotName] 
    end
end