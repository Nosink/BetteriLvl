local _, ns = ...
local L = ns.L

local builder = ns.builder

-- Panel Frame
builder:CreateOptionsPanel()

-- Title
builder:CreateTitle(L["LKEY_OPTIONS_TITLE"])

-- Options
builder:CreateSection(L["LKEY_OPTIONS_PLAYER_FRAME"])
local playerLevelCB = builder:CreateCheckBox(L["LKEY_OPTIONS_PLAYER_ITEM_LEVEL"], "itemLevel")
local playerBorderCB = builder:CreateCheckBox(L["LKEY_OPTIONS_PLAYER_BORDER"], "borderColor")

builder:CreateSection(L["LKEY_OPTIONS_DURABILITY"])
local durabilityCB = builder:CreateCheckBox(L["LKEY_OPTIONS_DURABILITY_ENABLE"], "durability")
local durabilityTypeDropdown = builder:CreateDropDown(L["LKEY_OPTIONS_DURABILITY_TYPE"], "durabilityType", {
    { value = "BAR",  text = L["LKEY_OPTIONS_DURABILITY_TYPE_BAR"] },
    { value = "TEXT", text = L["LKEY_OPTIONS_DURABILITY_TYPE_TEXT"] },
})
local durabilityColorCB = builder:CreateCheckBox(L["LKEY_OPTIONS_DURABILITY_COLOR"], "durabilityColor")

builder:CreateSection(L["LKEY_OPTIONS_TARGET_FRAME"])
local targetLevelCB = builder:CreateCheckBox(L["LKEY_OPTIONS_TARGET_ITEM_LEVEL"], "targetItemLevel")
local targetBorderCB = builder:CreateCheckBox(L["LKEY_OPTIONS_TARGET_BORDER"], "targetBorderColor")

-- Register
builder:Register()

local function onShow()
    playerLevelCB:FetchFromDB()
    playerBorderCB:FetchFromDB()
    durabilityCB:FetchFromDB()
    durabilityTypeDropdown:FetchFromDB()
    durabilityColorCB:FetchFromDB()
    targetLevelCB:FetchFromDB()
    targetBorderCB:FetchFromDB()
end

ns.bus:HookScript(builder.optionsPanel, "OnShow", onShow)
