local name, ns = ...

local function setText(checkBox, text, options)
    local cbText = checkBox.Text or checkBox.text
    local font, _, flags = cbText:GetFont()
    options = options or {}
    cbText:SetPoint("LEFT", checkBox, "RIGHT", options.textOffset or 4, 0)
    cbText:SetFont(tostring(options.font or font), options.fontSize or 12, options.fontFlags or flags)
    local color = options.textColor or { 1, 1, 1, 1 }
    cbText:SetTextColor(unpack(color))
    cbText:SetText(text)
end

local function setFetch(checkBox, key)
    checkBox:SetScript("OnClick", function(self)
        ns.db[key] = self:GetChecked() or false
        ns.bus:TriggerEvent(name .. "_SETTINGS_CHANGED", key)
    end)

    checkBox.FetchFromDB = function(self)
        self:SetChecked(ns.db[key] or false)
    end
end

function ns.builder.CreateCheckBox(section, text, key, options)
    options = options or {}
    local checkBox = CreateFrame("CheckButton", nil, section.optionsPanel,
        "InterfaceOptionsCheckButtonTemplate")
    checkBox:SetPoint("TOPLEFT", section.anchor, "BOTTOMLEFT", options.x or 0, options.y or 0)

    setText(checkBox, text, options)
    setFetch(checkBox, key)

    section.anchor = checkBox
    return checkBox
end
