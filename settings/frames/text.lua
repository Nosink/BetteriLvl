local _, ns = ...

local label = {}

local function createFontString(section, params)
    local fontString = params.fontString or
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

    local file, _, flags = label.Text:GetFont()
    label:SetFont(tostring(file), size, flags)
    label:SetTextColor(color.r, color.g, color.b, color.a)
    label:SetText(text)
end

function ns.builder.CreateText(section, text, params)
    createFontString(section, params)

    setText(text, params)

    section:SetAnchor(label)
    return label
end
