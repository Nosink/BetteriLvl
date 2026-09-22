local _, ns = ...

function ns.builder.CreateText(section, text, options)
    options = options or {}

    local label = section.optionsPanel:CreateFontString(nil, "ARTWORK", options.template or "GameFontNormal")
    label:SetPoint("TOPLEFT", section.anchor, "BOTTOMLEFT", options.x or 0, options.y or -8)

    ns.builder.StyleText(label, options)
    label:SetJustifyH(options.justifyH or "LEFT")
    label:SetText(text)

    section:SetAnchor(label)
    return label
end
