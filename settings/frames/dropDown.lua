local name, ns = ...

local label = {}
local dropDown = {}

local function createLabel(section, params)
    local fontString = params and params.fontString or
        ns.builder.fontString(nil, "ARTWORK", "GameFontNormal")
    local point = params and params.textPoint or
        ns.builder.point("TOPLEFT", section.anchor, "BOTTOMLEFT", 0, -8)

    label = section.anchor:CreateFontString(fontString.name, fontString.layer, fontString.template)
    label:SetPoint(point.point, point.relativeTo, point.relativePoint, point.x, point.y)
end

local function setText(text, params)
    local color = params and params.textColor or
        ns.builder.color(1, 1, 1, 1)
    local size = params and params.size or
        12

    local file, _, flags = label:GetFont()
    label:SetFont(tostring(file), size, flags)
    label:SetTextColor(color.r, color.g, color.b, color.a)
    label:SetText(text)
end

local function createDropDown(section, key, params)
    local point = params and params.controlPoint or
        ns.builder.point("LEFT", label, "RIGHT", 6)

    dropDown = CreateFrame("Frame", nil, section.anchor, "UIDropDownMenuTemplate")
    dropDown:SetPoint(point.point, point.relativeTo, point.relativePoint, point.x, point.y)
end

local function setWidth(params)
    local width = params and params.width or
        50
    UIDropDownMenu_SetWidth(dropDown, width)
end

local function setOptions(options)
    local function normalizeValues(vals)
        local out = {}
        for _, option in ipairs(vals or {}) do
            if type(option) == "table" then
                out[#out + 1] = {
                    value = option.value,
                    text = option.text or tostring(option.value),
                }
            else
                out[#out + 1] = {
                    value = option,
                    text = tostring(option),
                }
            end
        end
        return out
    end

    dropDown.options = normalizeValues(options or {})
end

local function initializeDropDown(key)
    local function findTextForValue(val)
        for _, opt in ipairs(dropDown.options) do
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
        for _, opt in ipairs(dropDown.options) do
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
        if v == nil and self.options[1] then
            v = self.options[1].value
        end
        if v ~= nil then
            setSelection(v, true)
        end
    end
end

function ns.builder.CreateDropDown(section, text, key, options, params)
    createLabel(section, params)
    setText(text, params)

    createDropDown(section, key, params)
    setWidth(params)
    setOptions(options)

    initializeDropDown(key)

    section:SetAnchor(label)
    return dropDown
end
