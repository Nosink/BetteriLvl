local name, ns = ...

local checkBox = {}

local function createCheckBox(section)
    checkBox = CreateFrame("CheckButton", nil, section.optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    checkBox:SetPoint("TOPLEFT", section.anchor, "BOTTOMLEFT")
end

local function setText(text)
    local font, _, flags = checkBox.Text:GetFont()
    checkBox.Text:SetPoint("LEFT", checkBox, "RIGHT", 4, 0)
    checkBox.Text:SetFont(tostring(font), 12, flags)
    checkBox.Text:SetTextColor(1, 1, 1, 1)
    checkBox.Text:SetText(text)
end

local function setOnClick(key)
    checkBox:SetScript("OnClick", function(self)
        ns.db[key] = self:GetChecked() or false
        ns.bus:TriggerEvent(name .. "_SETTINGS_CHANGED", key)
    end)
end

local function setFetch(key)
    checkBox.Fetch = function(self)
        self:SetChecked(ns.db[key] or false)
    end
end

function ns.builder.CreateCheckBox(section, text, key)
    createCheckBox(section)

    setText(text)
    setOnClick(key)
    setFetch(key)

    section:SetAnchor(checkBox)
    return checkBox
end
