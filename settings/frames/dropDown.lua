local name, ns = ...

local label = {}

local function createLabel(section, params)
    params = params or {}
    local fontString = params.fontString or
        ns.builder.fontString(nil, "ARTWORK", "GameFontNormal")
    local point = params.textPoint or
        ns.builder.point("TOPLEFT", section.anchor, "BOTTOMLEFT", 0, -8)

    label = section.anchor:CreateFontString(fontString.name, fontString.layer, fontString.template)
    label:SetPoint(point.point, point.relativeTo, point.relativePoint, point.x, point.y)
end

local function setText(text, params)
    params = params or {}
    local color = params.textColor or ns.builder.color()
    local size = params.size or 12

    local file, _, flags = label:GetFont()
    label:SetFont(tostring(file), size, flags)
    label:SetTextColor(color.r, color.g, color.b, color.a)
    label:SetText(text)
end

local function createDropDown(section, key, params)
    params = params or {}
    local point = params.controlPoint or
        ns.builder.point("LEFT", label, "RIGHT", params.controlOffset or 10)

    local dropDown = CreateFrame("Frame", name .. "Options" .. key .. "DD", section.optionsPanel,
        "UIDropDownMenuTemplate")
    dropDown:SetPoint(point.point, point.relativeTo, point.relativePoint, point.x, point.y)
    UIDropDownMenu_SetWidth(dropDown, params.width or 140)
    return dropDown
end

function ns.builder.CreateDropDown(section, text, key, values, default, params)
    createLabel(section, params)
    setText(" " .. text, params)

    local dropDown = createDropDown(section, key, params)

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

    local function initializeMenu(_, level)
        for _, opt in ipairs(options) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = opt.text
            info.value = opt.value
            info.func = function()
                setSelection(opt.value)
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end

    UIDropDownMenu_Initialize(dropDown, initializeMenu)

    dropDown.Fetch = function(self)
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
        UIDropDownMenu_Initialize(dropDown, initializeMenu)
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

    section:SetAnchor(label)
    return dropDown
end
