local _, ns = ...

ns["target" .. "slots"] = ns["target" .. "slots"] or {}
ns["target" .. "items"] = ns["target" .. "items"] or {}

local function clearUnitSlots(unit)
    local slots = ns[unit .. "slots"]
    if not slots then return end
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local equipSlot = slots[slot]
        if equipSlot then
            equipSlot:HideBorder()
        end
    end
end

local function onPlayerTargetChanged()
    clearUnitSlots("target")
end

local function onNotifyInspect(_)
    clearUnitSlots("target")
end

ns:RegisterEvent("PLAYER_TARGET_CHANGED", onPlayerTargetChanged)
ns:HookSecureFunc(_G, "NotifyInspect", onNotifyInspect)

local function displayUnitBorders(_, unit)
    local slots = ns[unit .. "slots"]
    local items = ns[unit .. "items"]
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local equipSlot = slots[slot]
        local itemData = items[slot]
        if equipSlot and itemData and itemData.cached and itemData.item then
            local itemQuality = itemData.item:GetItemQuality()
            equipSlot:ConfigureBorder(itemQuality)
            equipSlot:ShowBorder()
        elseif equipSlot then
            equipSlot:HideBorder()
        end
    end
end

ns:RegisterEvent("BETTERILVL_SLOTS_READY", displayUnitBorders, MID_PRIORITY)