local _, ns = ...
local L = ns.L

local builder = ns.builder

-- Panel Frame
builder:CreateOptionsPanel()

-- Title
builder:CreateTitle(L["LKEY_OPTIONS_TITLE"])

-- Options
builder:CreateSection(L["LKEY_OPTIONS_PLAYER_FRAME"])
local playerAverageCB = builder:CreateCheckBox(L["LKEY_OPTIONS_PLAYER_AVERAGE"], "playerAverage")
local playerAverageAlternatePositionCB = builder:CreateCheckBox(L["LKEY_OPTIONS_PLAYER_AVERAGE_ALTERNATE_POSITION"], "playerAverageAlternatePosition")
local playerLevelCB = builder:CreateCheckBox(L["LKEY_OPTIONS_PLAYER_ITEM_LEVEL"], "playerLevel")
local playerBorderCB = builder:CreateCheckBox(L["LKEY_OPTIONS_PLAYER_BORDER"], "playerBorder")

builder:CreateSection(L["LKEY_OPTIONS_TARGET_FRAME"])
local targetAverageCB = builder:CreateCheckBox(L["LKEY_OPTIONS_TARGET_AVERAGE"], "targetAverage")
local targetLevelCB = builder:CreateCheckBox(L["LKEY_OPTIONS_TARGET_ITEM_LEVEL"], "targetLevel")
local targetBorderCB = builder:CreateCheckBox(L["LKEY_OPTIONS_TARGET_BORDER"], "targetBorder")

builder:CreateSection(L["LKEY_OPTIONS_TOOLTIP"])
local tooltipLevelCB = builder:CreateCheckBox(L["LKEY_OPTIONS_TOOLTIP_ITEM_LEVEL"], "tooltipLevel")
local tooltipIDCB = builder:CreateCheckBox(L["LKEY_OPTIONS_TOOLTIP_ITEM_ID"], "tooltipID")

-- Register
builder:Register()

local function onShow()
    playerAverageCB:FetchFromDB()
    playerAverageAlternatePositionCB:FetchFromDB()
    playerLevelCB:FetchFromDB()
    playerBorderCB:FetchFromDB()
    targetAverageCB:FetchFromDB()
    targetLevelCB:FetchFromDB()
    targetBorderCB:FetchFromDB()
    tooltipLevelCB:FetchFromDB()
    tooltipIDCB:FetchFromDB()
end

ns:HookScript(builder.optionsPanel, "OnShow", onShow)