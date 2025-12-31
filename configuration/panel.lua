local _, ns = ...
local L = ns.L

local builder = ns.builder

-- Panel Frame
builder:CreateOptionsPanel()

-- Title
builder:CreateTitle(L["LKEY_OPTIONS_TITLE"])

builder:CreateSection(L["LKEY_OPTIONS_PLAYER_FRAME"])
local playerAverageCB = builder:CreateCheckBox(L["LKEY_OPTIONS_PLAYER_AVERAGE"], "playerAverage")
local playerAverageAlternatePositionCB = builder:CreateCheckBox(L["LKEY_OPTIONS_PLAYER_AVERAGE_ALTERNATE_POSITION"], "playerAverageAlternatePosition")
local playerItemLevelCB = builder:CreateCheckBox(L["LKEY_OPTIONS_PLAYER_ITEM_LEVEL"], "playerLevel")
local playerBorderCB = builder:CreateCheckBox(L["LKEY_OPTIONS_PLAYER_BORDER"], "playerBorder")

builder:CreateSection(L["LKEY_OPTIONS_TARGET_FRAME"])
local targetAverageCB = builder:CreateCheckBox(L["LKEY_OPTIONS_TARGET_AVERAGE"], "targetAverage")
local targetItemLevelCB = builder:CreateCheckBox(L["LKEY_OPTIONS_TARGET_ITEM_LEVEL"], "targetLevel")
local targetBorderCB = builder:CreateCheckBox(L["LKEY_OPTIONS_TARGET_BORDER"], "targetBorder")

builder:CreateSection(L["LKEY_OPTIONS_TOOLTIP"])
local tooltipItemLevelCB = builder:CreateCheckBox(L["LKEY_OPTIONS_TOOLTIP_ITEM_LEVEL"], "tooltipLevel")
local tooltipItemIdCB = builder:CreateCheckBox(L["LKEY_OPTIONS_TOOLTIP_ITEM_ID"], "tooltipID")
local function onShow()
    playerAverageCB:FetchFromDB()
    playerAverageAlternatePositionCB:FetchFromDB()
    playerItemLevelCB:FetchFromDB()
    playerBorderCB:FetchFromDB()
    targetAverageCB:FetchFromDB()
    targetItemLevelCB:FetchFromDB()
    targetBorderCB:FetchFromDB()
    tooltipItemLevelCB:FetchFromDB()
    tooltipItemIdCB:FetchFromDB()
end

builder.optionsPanel:HookScript("OnShow", onShow)

builder:Register()