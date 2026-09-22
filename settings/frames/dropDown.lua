local name, ns = ...

function ns.builder.CreateDropDown(section, text, key, values, default, config)
    config = config or {}
    local label = section.optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("TOPLEFT", section.anchor, "BOTTOMLEFT", config.x or 0, config.y or -16)
    local font, _, flags = label:GetFont()
    label:SetFont(tostring(config.font or font), config.fontSize or 12, config.fontFlags or flags)
    local color = config.textColor or { 1, 1, 1, 1 }
    label:SetTextColor(unpack(color))
    label:SetText(" " .. text)

    local dropDown = CreateFrame("Frame", name .. "Options" .. key .. "DD", section.optionsPanel,
        "UIDropDownMenuTemplate")
    dropDown:SetPoint("LEFT", label, "RIGHT", config.controlOffset or 10, 0)

    local function normalizeValues(vals)
        local out = {}
        if type(vals) == "table" then
            local isArray = (#vals > 0)
            if isArray then
                for _, v in ipairs(vals) do
                    if type(v) == "table" then
                        table.insert(out, { value = v.value, text = v.text or tostring(v.value) })
                    else
                        table.insert(out, { value = v, text = tostring(v) })
                    end
                end
            else
                for v, t in pairs(vals) do
                    table.insert(out, { value = v, text = tostring(t) })
                end
            end
        end
        return out
    end

    local options = normalizeValues(values or {})

    local function findTextForValue(val)
        for _, opt in ipairs(options) do
            if opt.value == val then return opt.text end
        end
    end

    local function setSelection(val, silent)
        local txt = findTextForValue(val) or tostring(val)
        UIDropDownMenu_SetSelectedValue(dropDown, val)
        UIDropDownMenu_SetText(dropDown, txt)
        if not silent then
            ns.db[key] = val
            ns.bus:TriggerEvent(name .. "_SETTINGS_CHANGED", key)
        end
    end

    UIDropDownMenu_SetWidth(dropDown, config.width or 140)

    UIDropDownMenu_Initialize(dropDown, function(self, level)
        for _, opt in ipairs(options) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = opt.text
            info.value = opt.value
            info.func = function()
                setSelection(opt.value)
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)

    dropDown.FetchFromDB = function(self)
        local v = ns.db[key]
        if v == nil then v = default end
        if v == nil and options[1] then
            v = options[1].value
        end
        if v ~= nil then
            setSelection(v, true)
        end
    end

    dropDown.SetOptions = function(self, newValues)
        options = normalizeValues(newValues or {})
        UIDropDownMenu_Initialize(dropDown, function(self, level)
            for _, opt in ipairs(options) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = opt.text
                info.value = opt.value
                info.func = function()
                    setSelection(opt.value)
                end
                UIDropDownMenu_AddButton(info, level)
            end
        end)
        local v = ns.db[key]
        if v ~= nil then
            setSelection(v, true)
        elseif options[1] then
            setSelection(options[1].value, true)
        end
    end

    dropDown.GetValue = function()
        return UIDropDownMenu_GetSelectedValue(dropDown)
    end

    dropDown.SetValue = function(self, v)
        setSelection(v)
    end

    section.anchor = label
    return dropDown
end
