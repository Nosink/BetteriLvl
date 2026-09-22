local _, ns = ...

function ns.builder.CreateText(section, text, options)
    options = options or {}

    local label = section.optionsPanel:CreateFontString(nil, "ARTWORK", options.template or "GameFontNormal")
    label:SetPoint("TOPLEFT", section.anchor, "BOTTOMLEFT", options.x or 0, options.y or -8)

    local font, _, flags = label:GetFont()
    label:SetFont(tostring(options.font or font), options.fontSize or 12, options.fontFlags or flags)
    local color = options.textColor or { 1, 1, 1, 1 }
    label:SetTextColor(unpack(color))
    label:SetJustifyH(options.justifyH or "LEFT")
    label:SetText(text)

    section.anchor = label
    return label
end
