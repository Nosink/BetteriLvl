local name, _ = ...

local unitId = nil

local function onNotifyInspect(unit)
    unitId = unit
end

local function onInspectReady()
    if not unitId then return end
    BIBus:TriggerEvent(name .. "_INSPECT_READY", unitId)
end

local function onPlayerEquipmentChanged(_, equipmentSlot)
    BIBus:TriggerEvent(name .. "_PLAYER_EQUIPMENT_CHANGED", equipmentSlot)
end

BIBus:HookSecureFunc("NotifyInspect", onNotifyInspect)
BIBus:RegisterEvent("INSPECT_READY", onInspectReady)
BIBus:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", onPlayerEquipmentChanged)
