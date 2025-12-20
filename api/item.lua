
_G.BetteriLvl.API.Item = {}

BetteriLvl.API.Item.CreateItem = function (item)
    if not item then return end
    if type(item) == "string" then
        item = Item:CreateFromItemLink(item)
    end
    if item:IsItemEmpty() then
        return
    end
    return item
end

BetteriLvl.API.Item.GetItemLevel = function(item)
    item = BetteriLvl.API.Item.CreateItem(item)
    local details = BetteriLvl.API.Item.GetItemDetails(item)
    return details.level
end

BetteriLvl.API.Item.GetItemQuality = function(item)
    item = BetteriLvl.API.Item.CreateItem(item)
    local details = BetteriLvl.API.Item.GetItemDetails(item)
    return details.quality
end

BetteriLvl.API.Item.GetItemType = function(item)
    item = BetteriLvl.API.Item.CreateItem(item)
    local details = BetteriLvl.API.Item.GetItemDetails(item)
    return details.type
end

BetteriLvl.API.Item.GetItemDetails = function (item)
    if not item or item:IsItemEmpty() then return {} end

    return {
        level = item:GetCurrentItemLevel(),
        quality = item:GetItemQuality(),
        link = item:GetItemLink(),
    }

end


ItemHelper = {}


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