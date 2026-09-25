local name, ns = ...

local L = ns.L
local builder = ns.builder
local durabilityType = ns.enums.durabilityType

-- Panel Frame
builder:CreateOptionsPanel()

-- Title
builder:CreateTitle(L["OPTIONS_TITLE"])

-- Options
local playerSection = builder:CreateSection(L["OPTIONS_PLAYER_FRAME"])
playerSection:AddCheckBox(L["OPTIONS_PLAYER_ITEM_LEVEL"], "itemLevel")
playerSection:AddCheckBox(L["OPTIONS_PLAYER_BORDER"], "borderColor")

local durabilitySection = builder:CreateSection(L["OPTIONS_DURABILITY"])
durabilitySection:AddCheckBox(L["OPTIONS_DURABILITY_ENABLE"], "durability")
durabilitySection:AddCheckBox(L["OPTIONS_DURABILITY_COLOR"], "durabilityColor")
durabilitySection:AddDropDown(L["OPTIONS_DURABILITY_TYPE"], "durabilityType", {
    { value = durabilityType.Bars, text = L["OPTIONS_DURABILITY_TYPE_BAR"] },
    { value = durabilityType.Text, text = L["OPTIONS_DURABILITY_TYPE_TEXT"] } })

local targetSection = builder:CreateSection(L["OPTIONS_TARGET_FRAME"])
targetSection:AddCheckBox(L["OPTIONS_TARGET_ITEM_LEVEL"], "targetItemLevel")
targetSection:AddCheckBox(L["OPTIONS_TARGET_BORDER"], "targetBorderColor")

-- Register
builder:Register()

local function onShow()
    if not ns.db then return end
    builder:Fetch()
end

ns.bus:HookScript(builder.optionsPanel, "OnShow", onShow)
ns.bus:RegisterEvent(name .. "_SETTINGS_CHANGED", onShow)
ns.bus:RegisterEvent(name .. "_VARIABLES_LOADED", onShow)
