local name, ns = ...

local inspectFrame = nil
local characterFrame = nil

local onShowPlayerFrameHook = false
local onShowInspectFrameHook = false

local function onCharacterFrameShown()
    if not characterFrame then return end
    ns.bus:TriggerEvent(name .. "_CHARACTER_FRAME_SHOWN")
end

local function onVariablesLoaded()
    characterFrame = _G["CharacterFrame"]
    if not characterFrame or onShowPlayerFrameHook then return end

    onShowPlayerFrameHook = true
    ns.bus:HookScript(characterFrame, "OnShow", onCharacterFrameShown)
end

local function onInspectReady()
    if not inspectFrame then return end
    ns.bus:TriggerEvent(name .. "_INSPECT_READY")
end

local function onInspectFrameLoaded()
    inspectFrame = _G["InspectFrame"]
    if not inspectFrame or onShowInspectFrameHook then return end

    onShowInspectFrameHook = true
    ns.bus:HookScript(inspectFrame, "OnShow", onInspectReady)
end

local function onPlayerEquipmentChanged(_, equipmentSlot)
    ns.bus:TriggerEvent(name .. "_PLAYER_EQUIPMENT_CHANGED", equipmentSlot)
end

local function onPlayerDurabilityChanged()
    ns.bus:TriggerEvent(name .. "_UPDATE_INVENTORY_DURABILITY")
end

ns.bus:RegisterEvent(name .. "_VARIABLES_LOADED", onVariablesLoaded)
ns.bus:HookSecureFunc("InspectFrame_LoadUI", onInspectFrameLoaded)

ns.bus:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", onPlayerEquipmentChanged)
ns.bus:RegisterEvent("UPDATE_INVENTORY_DURABILITY", onPlayerDurabilityChanged)
