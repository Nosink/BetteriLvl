local name, ns = ...


local unitId = nil

local function onNotifyInspect(unit)
    unitId = unit
end

local function onInspectReady()
    if not unitId then return end
    ns.bus:TriggerEvent(name .. "_INSPECT_READY", unitId)
end

local function onPlayerEquipmentChanged(_, equipmentSlot)
    ns.bus:TriggerEvent(name .. "_PLAYER_EQUIPMENT_CHANGED", equipmentSlot)
end

local function onPlayerDurabilityChanged()
    ns.bus:TriggerEvent(name .. "_UPDATE_INVENTORY_DURABILITY")
end

ns.bus:HookSecureFunc("NotifyInspect", onNotifyInspect)
ns.bus:RegisterEvent("INSPECT_READY", onInspectReady)

ns.bus:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", onPlayerEquipmentChanged)
ns.bus:RegisterEvent("UPDATE_INVENTORY_DURABILITY", onPlayerDurabilityChanged)
