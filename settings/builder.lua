local name, ns = ...

ns.builder = {}

local section = {}
section.__index = section

function ns.builder.StyleText(fontString, options)
    options = options or {}

    local font, size, flags = fontString:GetFont()
    fontString:SetFont(
        tostring(options.font or font),
        options.fontSize or size,
        options.fontFlags or flags
    )

    local color = options.textColor or { 1, 1, 1, 1 }
    fontString:SetTextColor(unpack(color))
end

function section:SetAnchor(anchor)
    self.anchor = anchor
    self.builder.anchor = anchor
end

function section:AddControl(control)
    self.controls[#self.controls + 1] = control
    self:SetAnchor(self.anchor)
    return control
end

function section:AddCheckBox(text, key)
    return self:AddControl(ns.builder.CreateCheckBox(self, text, key))
end

function section:AddDropDown(text, key, values, default, options)
    return self:AddControl(ns.builder.CreateDropDown(self, text, key, values, default, options))
end

function section:AddText(text, options)
    return self:AddControl(ns.builder.CreateText(self, text, options))
end

function section:Fetch()
    for _, control in ipairs(self.controls) do
        if control.Fetch then control:Fetch() end
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
    ns.builder.StyleText(title, {
        fontSize = 20,
        textColor = { 0.2, 0.6, 1, 1 },
    })
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
    ns.builder.StyleText(title, { textColor = { 1, 0.82, 0, 1 } })
    title:SetHeight(30)
    title:SetText(text)
    title:Show()

    local section = setmetatable({
        builder = self,
        optionsPanel = self.optionsPanel,
        anchor = title,
        controls = {},
    }, section)

    self.optionsPanel.sections[#self.optionsPanel.sections + 1] = section
    self.anchor = title
    return section
end

function ns.builder.Fetch(self)
    for _, section in ipairs(self.optionsPanel.sections) do
        section:Fetch()
    end
end

function ns.builder.Register(self)
    if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
        ns.settingsCategory = Settings.RegisterCanvasLayoutCategory(self.optionsPanel, name)
        Settings.RegisterAddOnCategory(ns.settingsCategory)
    end
end
