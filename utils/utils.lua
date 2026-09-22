local _, ns = ...

local utils = {}

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
    local b = 0
    return r, g, b
end

ns.utils = utils
