
local name, ns = ...

_G.BetteriLvl.API = {}

BetteriLvl.API.GetQualityColor = function(quality)
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