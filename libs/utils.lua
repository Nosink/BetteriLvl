local _, ns = ...

local utils = {}

function utils.GetUnitName()
    return UnitName("player")
end

function utils.GetSignSymbol(amount)
    if type(amount) ~= "number" then return "" end

    return amount < 0 and "-" or amount > 0 and "+" or ""
end

function utils.FadeIn(frame, duration, targetAlpha)
    if not frame then return end

    local fadeInfo = {
        mode = "IN",
        timeToFade = duration or 0.5,
        startAlpha = frame:GetAlpha() or 0,
        endAlpha = targetAlpha or 1
    }
    UIFrameFade(frame, fadeInfo)
end

function utils.FadeOut(frame, duration, targetAlpha)
    if not frame then return end

    local fadeInfo = {
        mode = "OUT",
        timeToFade = duration or 0.5,
        startAlpha = frame:GetAlpha() or 1,
        endAlpha = targetAlpha or 0
    }
    UIFrameFade(frame, fadeInfo)
end

function utils.ColoredText(color, text)
    return string.format("|c%s%s|r", color, text)
end

function utils.GetItemQualityColor(quality)
    local q = tonumber(quality) or 0

    if C_Item and C_Item.GetItemQualityColor then
        local r, g, b = C_Item.GetItemQualityColor(q)
        if type(r) == "table" then
            return r.r, r.g, r.b
        end
        if type(r) == "number" then
            return r, g, b
        end
    end

    return 1, 1, 1
end

function utils.GetDurabilityColor(durabilityPercent)
    local percent = tonumber(durabilityPercent) or 0
    local r = math.min(1, (100 - percent) / 50)
    local g = math.min(1, percent / 50)
    return r, g
end

ns.utils = utils
