local _, ns = ...
local L = ns.L

local builder = ns.builder

-- Panel Frame
builder:CreateOptionsPanel()

-- Title
builder:CreateTitle(L["LKEY_OPTIONS_TITLE"])

-- Options
builder:CreateSection(L["LKEY_OPTIONS_PLAYER_FRAME"])
local playerLevelCB = builder:CreateCheckBox(L["LKEY_OPTIONS_PLAYER_ITEM_LEVEL"], "playerLevel")
local playerBorderCB = builder:CreateCheckBox(L["LKEY_OPTIONS_PLAYER_BORDER"], "playerBorder")

builder:CreateSection(L["LKEY_OPTIONS_TARGET_FRAME"])
local targetLevelCB = builder:CreateCheckBox(L["LKEY_OPTIONS_TARGET_ITEM_LEVEL"], "targetLevel")
local targetBorderCB = builder:CreateCheckBox(L["LKEY_OPTIONS_TARGET_BORDER"], "targetBorder")

-- Register
builder:Register()

local function onShow()
    playerLevelCB:FetchFromDB()
    playerBorderCB:FetchFromDB()
    targetLevelCB:FetchFromDB()
    targetBorderCB:FetchFromDB()
end

BIBus:HookScript(builder.optionsPanel, "OnShow", onShow)
