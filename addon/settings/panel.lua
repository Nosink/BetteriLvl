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
player:AddCheckBox(L["OPTIONS_PLAYER_ITEM_LEVEL"], "itemLevel")
player:AddCheckBox(L["OPTIONS_PLAYER_BORDER"], "borderColor")

local durability = builder:CreateSection(L["OPTIONS_DURABILITY"])
durability:AddCheckBox(L["OPTIONS_DURABILITY_ENABLE"], "durability")
durability:AddCheckBox(L["OPTIONS_DURABILITY_COLOR"], "durabilityColor")
durability:AddDropDown(L["OPTIONS_DURABILITY_TYPE"], "durabilityType", {
    { value = durabilityType.Bars, text = L["OPTIONS_DURABILITY_TYPE_BAR"] },
    { value = durabilityType.Text, text = L["OPTIONS_DURABILITY_TYPE_TEXT"] },
})

local target = builder:CreateSection(L["OPTIONS_TARGET_FRAME"])
target:AddCheckBox(L["OPTIONS_TARGET_ITEM_LEVEL"], "targetItemLevel")
target:AddCheckBox(L["OPTIONS_TARGET_BORDER"], "targetBorderColor")
target:AddText("Este esu n textoo", { point = "LEFT", relativePoint = "RIGHT" })

-- Register
builder:Register()

local function onShow()
    if not ns.db then return end
    builder:Fetch()
end

ns.bus:HookScript(builder.optionsPanel, "OnShow", onShow)
ns.bus:RegisterEvent(name .. "_SETTINGS_CHANGED", onShow)
ns.bus:RegisterEvent(name .. "_VARIABLES_LOADED", onShow)
