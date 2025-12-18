
ItemHelper = {}

function ItemHelper.GetQualityColor(quality)
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

    if C_Item and C_Item.GetItemQualityColor then
        return C_Item.GetItemQualityColor(q)
    end

    return 1, 1, 1
end

function ItemHelper.GetIsEquipmentType(itemType)
    if not itemType then
        return false
    end

    local itemTypes = {
        ["Armor"] = true,
        ["Weapon"] = true,
        ["Projectile"] = true,
    }

    return itemTypes[itemType] == true
end