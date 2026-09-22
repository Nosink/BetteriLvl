local name, ns = ...

ns.builder = ns.builder or {}

local sectionPrototype = {}
sectionPrototype.__index = sectionPrototype

function sectionPrototype:AddControl(control)
    self.controls[#self.controls + 1] = control
    return control
end

function sectionPrototype:AddCheckBox(text, key, options)
    return self:AddControl(ns.builder.CreateCheckBox(self, text, key, options))
end

function sectionPrototype:AddDropDown(text, key, values, default, options)
    return self:AddControl(ns.builder.CreateDropDown(self, text, key, values, default, options))
end

function sectionPrototype:AddText(text, options)
    return self:AddControl(ns.builder.CreateText(self, text, options))
end

function sectionPrototype:FetchFromDB()
    for _, control in ipairs(self.controls) do
        if control.FetchFromDB then
            control:FetchFromDB()
        end
    end
end

function ns.builder.CreateOptionsPanel(self)
    local optionsPanel = CreateFrame("Frame", name .. "OptionsPanel", UIParent)
    optionsPanel.name = name
    optionsPanel.sections = {}
    self.optionsPanel = optionsPanel
    return optionsPanel
end

function ns.builder.CreateTitle(self, text)
    local title = self.optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 8, -16)
    local fontName, _, flags = title:GetFont()
    title:SetFont(tostring(fontName), 18, flags)
    title:SetTextColor(0.2, 0.6, 1, 1)
    title:SetText(text)

    local body = CreateFrame("Frame", nil, self.optionsPanel)
    body:SetPoint("TOPLEFT", 16, -38)
    body:SetSize(1, 1)

    local separator = body:CreateTexture(nil, "BORDER")
    separator:SetPoint("TOPLEFT", self.optionsPanel, "TOPLEFT", 8, -38)
    separator:SetPoint("TOPRIGHT", self.optionsPanel, "TOPRIGHT", -8, -38)
    separator:SetColorTexture(1, 1, 1, 0.15)
    separator:SetHeight(2)

    self.anchor = body
end

function ns.builder.CreateSection(self, text, anchor)
    local title = self.optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", anchor or self.anchor, "BOTTOMLEFT", 0, -8)
    title:SetTextColor(1, 0.82, 0, 1)
    title:SetHeight(30)
    title:SetText(text)
    title:Show()

    local section = setmetatable({
        optionsPanel = self.optionsPanel,
        anchor = title,
        controls = {},
    }, sectionPrototype)

    self.optionsPanel.sections[#self.optionsPanel.sections + 1] = section
    return section
end

function ns.builder.FetchFromDB(self)
    for _, section in ipairs(self.optionsPanel.sections) do
        section:FetchFromDB()
    end
end

function ns.builder.Register(self)
    if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
        ns.settingsCategory = Settings.RegisterCanvasLayoutCategory(self.optionsPanel, name)
        Settings.RegisterAddOnCategory(ns.settingsCategory)
    end
end
