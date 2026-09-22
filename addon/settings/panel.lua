local name, ns = ...
local L = ns.L

local builder = ns.builder
local durabilityType = ns.enums.durabilityType

-- Panel Frame
builder:CreateOptionsPanel()

-- Title
builder:CreateTitle(L["OPTIONS_TITLE"])

-- Options
local player = builder:CreateSection(L["OPTIONS_PLAYER_FRAME"])
local playerLevelCB = player:AddCheckBox(L["OPTIONS_PLAYER_ITEM_LEVEL"], "itemLevel")
local playerBorderCB = player:AddCheckBox(L["OPTIONS_PLAYER_BORDER"], "borderColor")

local durability = builder:CreateSection(L["OPTIONS_DURABILITY"])
local durabilityCB = durability:AddCheckBox(L["OPTIONS_DURABILITY_ENABLE"], "durability")
local durabilityTypeDropdown = durability:AddDropDown(L["OPTIONS_DURABILITY_TYPE"], "durabilityType", {
    { value = durabilityType.Bars, text = L["OPTIONS_DURABILITY_TYPE_BAR"] },
    { value = durabilityType.Text, text = L["OPTIONS_DURABILITY_TYPE_TEXT"] },
})
local durabilityColorCB = durability:AddCheckBox(L["OPTIONS_DURABILITY_COLOR"], "durabilityColor")

local target = builder:CreateSection(L["OPTIONS_TARGET_FRAME"])
local targetLevelCB = target:AddCheckBox(L["OPTIONS_TARGET_ITEM_LEVEL"], "targetItemLevel")
local targetBorderCB = target:AddCheckBox(L["OPTIONS_TARGET_BORDER"], "targetBorderColor")

-- Register
builder:Register()

local function onShow()
    if not ns.db then return end

    builder:FetchFromDB()
end

ns.bus:HookScript(builder.optionsPanel, "OnShow", onShow)
ns.bus:RegisterEvent(name .. "_SETTINGS_CHANGED", onShow)
ns.bus:RegisterEvent(name .. "_VARIABLES_LOADED", onShow)
