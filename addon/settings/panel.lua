local name, ns = ...
local L = ns.L
local durabilityType = ns.enums.durabilityType

local builder = ns.builder

-- Panel Frame
builder:CreateOptionsPanel()

-- Title
builder:CreateTitle(L["OPTIONS_TITLE"])

-- Options
builder:CreateSection(L["OPTIONS_PLAYER_FRAME"])
local playerLevelCB = builder:CreateCheckBox(L["OPTIONS_PLAYER_ITEM_LEVEL"], "itemLevel")
local playerBorderCB = builder:CreateCheckBox(L["OPTIONS_PLAYER_BORDER"], "borderColor")

builder:CreateSection(L["OPTIONS_DURABILITY"])
local durabilityCB = builder:CreateCheckBox(L["OPTIONS_DURABILITY_ENABLE"], "durability")
local durabilityTypeDropdown = builder:CreateDropDown(L["OPTIONS_DURABILITY_TYPE"], "durabilityType", {
    { value = durabilityType.Bars, text = L["OPTIONS_DURABILITY_TYPE_BAR"] },
    { value = durabilityType.Text, text = L["OPTIONS_DURABILITY_TYPE_TEXT"] },
})
local durabilityColorCB = builder:CreateCheckBox(L["OPTIONS_DURABILITY_COLOR"], "durabilityColor")

builder:CreateSection(L["OPTIONS_TARGET_FRAME"])
local targetLevelCB = builder:CreateCheckBox(L["OPTIONS_TARGET_ITEM_LEVEL"], "targetItemLevel")
local targetBorderCB = builder:CreateCheckBox(L["OPTIONS_TARGET_BORDER"], "targetBorderColor")

-- Register
builder:Register()

local function onShow()
    if not ns.db then return end

    playerLevelCB:FetchFromDB()
    playerBorderCB:FetchFromDB()
    durabilityCB:FetchFromDB()
    durabilityTypeDropdown:FetchFromDB()
    durabilityColorCB:FetchFromDB()
    targetLevelCB:FetchFromDB()
    targetBorderCB:FetchFromDB()
end

ns.bus:HookScript(builder.optionsPanel, "OnShow", onShow)
ns.bus:RegisterEvent(name .. "_VARIABLES_LOADED", onShow)
