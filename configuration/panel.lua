local name, ns = ...
local L = ns.L

local data = {
    title = { anchor = "TOPLEFT", x = 8, y = -16, text = L["LKEY_OPTIONS_TITLE"], template = "GameFontNormalLarge", font = "Fonts/FRIZQT__.TTF", fontSize = 18, color = {0.2, 0.6, 1} },
    body = { anchor = "TOPLEFT", x = 16, y = -32, size = { width = 1, height = 1 } },
    titleSeparator = { origin = "TOPLEFT", destiny = "TOPRIGHT", offset = { x = 8, y = -38 }, color = {1, 1, 1, 0.15} , height = 2 },
    sectionTitle = { anchor = "TOPLEFT", relative = "BOTTOMLEFT", template = "GameFontNormalLarge", color = {1, 0.82, 0}, offset = { x = 0, y = -18 } , height = 20 },
}

-- Panel Frame
local panel = CreateFrame("Frame", "BetteriLvlOptionsPanel", UIParent)
panel.name = name

-- Title
local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint(data.title.anchor, data.title.x, data.title.y)
title:SetText(data.title.text)
title:SetFont(data.title.font, data.title.fontSize, select(4, title:GetFont()))
title:SetTextColor(unpack(data.title.color))

-- Body Frame
local bodyFrame = CreateFrame("Frame", nil, panel)
bodyFrame:SetPoint(data.body.anchor, data.body.x, data.body.y)
bodyFrame:SetSize(data.body.size.width, data.body.size.height)

-- Title Separator
local separator = bodyFrame:CreateTexture(nil, "BORDER")
separator:SetColorTexture(unpack(data.titleSeparator.color))
separator:SetHeight(data.titleSeparator.height)
separator:SetPoint(data.titleSeparator.origin, panel, data.titleSeparator.origin, data.titleSeparator.offset.x, data.titleSeparator.offset.y)
separator:SetPoint(data.titleSeparator.destiny, panel, data.titleSeparator.destiny, -data.titleSeparator.offset.x, data.titleSeparator.offset.y)

local previousAnchor = bodyFrame

-- Option Section
local function CreateSectionTitle(key)
    local header = panel:CreateFontString(nil, "ARTWORK", data.sectionTitle.template)
    header:SetPoint(data.sectionTitle.anchor, previousAnchor, data.sectionTitle.relative, data.sectionTitle.offset.x, data.sectionTitle.offset.y)
    header:SetHeight(data.sectionTitle.height)
    header:SetText(key)
    header:SetTextColor(unpack(data.sectionTitle.color))
    previousAnchor = header
    return header
end

-- Checkbox Option
local function CreateCheckbox(key, dbKey)
    local checkBox = CreateFrame("CheckButton", "BetteriLvlOptions_" .. dbKey, panel, "InterfaceOptionsCheckButtonTemplate")
    checkBox:SetPoint("TOPLEFT", previousAnchor, "BOTTOMLEFT")

    local cbText = _G[checkBox:GetName() .. "Text"]
    if cbText then
        cbText:SetText(key)
    end

    checkBox:SetScript("OnClick", function(self)
        BetteriLvlDB = BetteriLvlDB or {}
        BetteriLvlDB[dbKey] = self:GetChecked() and true or false
    end)

    checkBox.SyncFromDB = function()
        local enabled = true
        if BetteriLvlDB and BetteriLvlDB[dbKey] ~= nil then
            enabled = BetteriLvlDB[dbKey] and true or false
        end
        checkBox:SetChecked(enabled)
    end
    
    previousAnchor = checkBox
    return checkBox
end

local playerTitle = CreateSectionTitle(L["LKEY_OPTIONS_PLAYER_FRAME"])
local playerAverageCheckbox = CreateCheckbox(L["LKEY_OPTIONS_PLAYER_AVERAGE"], "playerAverage")
local playerAverageAlternatePositionCheckbox = CreateCheckbox(L["LKEY_OPTIONS_PLAYER_AVERAGE_ALTERNATE_POSITION"], "playerAverageAlternatePosition")
local playerItemLevelCheckbox = CreateCheckbox(L["LKEY_OPTIONS_PLAYER_ITEM_LEVEL"], "playerLevel")
local playerBorderCheckbox = CreateCheckbox(L["LKEY_OPTIONS_PLAYER_BORDER"], "playerBorder")

local targetTitle = CreateSectionTitle(L["LKEY_OPTIONS_TARGET_FRAME"])
local targetAverageCheckbox = CreateCheckbox(L["LKEY_OPTIONS_TARGET_AVERAGE"], "targetAverage")
local targetItemLevelCheckbox = CreateCheckbox(L["LKEY_OPTIONS_TARGET_ITEM_LEVEL"], "targetLevel")
local targetBorderCheckbox = CreateCheckbox(L["LKEY_OPTIONS_TARGET_BORDER"], "targetBorder")

local tooltipTitle = CreateSectionTitle(L["LKEY_OPTIONS_TOOLTIP"])
local tooltipItemLevelCheckbox = CreateCheckbox(L["LKEY_OPTIONS_TOOLTIP_ITEM_LEVEL"], "tooltipLevel")
local tooltipItemIdCheckbox = CreateCheckbox(L["LKEY_OPTIONS_TOOLTIP_ITEM_ID"], "tooltipID")

local function SyncOptionsFromDB()
    playerAverageCheckbox:SyncFromDB()
    playerAverageAlternatePositionCheckbox:SyncFromDB()
    playerItemLevelCheckbox:SyncFromDB()
    playerBorderCheckbox:SyncFromDB()
    targetAverageCheckbox:SyncFromDB()
    targetItemLevelCheckbox:SyncFromDB()
    targetBorderCheckbox:SyncFromDB()
    tooltipItemLevelCheckbox:SyncFromDB()
    tooltipItemIdCheckbox:SyncFromDB()
end

panel:HookScript("OnShow", SyncOptionsFromDB)

-- Register in Interface Options
local settingsCategory -- keep a reference for settings API
if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
    settingsCategory = Settings.RegisterCanvasLayoutCategory(panel, name)
    Settings.RegisterAddOnCategory(settingsCategory)
end

SLASH_BETTERILVL1 = "/betterilvl"
SLASH_BETTERILVL2 = "/bilvl"
SlashCmdList.BETTERILVL = function()
    if Settings and Settings.OpenToCategory and settingsCategory then
        Settings.OpenToCategory(settingsCategory:GetID())
    end
end