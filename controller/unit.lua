local _, ns = ...

local bus = ns.Module(moduleName):GetBus()

local unitId = nil

local function onNotifyInspect(unit)
    unitId = unit
end

local function onInspectReady()
    if not unitId then return end
    bus:TriggerEvent(moduleName .. "_INSPECT_READY", unitId)
end

local function onPlayerEquipmentChanged(_, equipmentSlot)
    bus:TriggerEvent(moduleName .. "_PLAYER_EQUIPMENT_CHANGED", equipmentSlot)
end

local function onPlayerDurabilityChanged()
    bus:TriggerEvent(moduleName .. "_UPDATE_INVENTORY_DURABILITY")
end

bus:HookSecureFunc("NotifyInspect", onNotifyInspect)
bus:RegisterEvent("INSPECT_READY", onInspectReady)

bus:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", onPlayerEquipmentChanged)
bus:RegisterEvent("UPDATE_INVENTORY_DURABILITY", onPlayerDurabilityChanged)
