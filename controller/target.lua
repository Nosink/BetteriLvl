local name, ns = ...

ns["target" .. "slots"] = ns["target" .. "slots"] or {}
ns["target" .. "items"] = ns["target" .. "items"] or {}

local function clearTargetSlots()
    local slots = ns["target" .. "slots"]
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local equipSlot = slots[slot]
        if equipSlot then
            equipSlot:Hide()
        end
    end
end

local function onPlayerTargetChanged()
    clearTargetSlots()
end

local function onNotifyInspect(unit)
    clearTargetSlots()
end

ns:RegisterEvent("PLAYER_TARGET_CHANGED", onPlayerTargetChanged)
ns:HookSecureFunc(_G, "NotifyInspect", onNotifyInspect)

local function displayTargetBorders()
    local slots = ns["target" .. "slots"]
    local items = ns["target" .. "items"]
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

ns:RegisterEvent("BETTERILVL_TARGET_CACHED", displayTargetBorders, MID_PRIORITY)