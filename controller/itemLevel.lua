local _, ns = ...

ns["player" .. "itemLevel"] = ns["player" .. "itemLevel"] or {}
ns["target" .. "itemLevel"] = ns["target" .. "itemLevel"] or {}

local function displayAverageItemLevel(_, unit)
    local slot = ns[unit .. "itemLevel"].slot
    local itemLevel = ns[unit .. "itemLevel"].average
    local itemQuality = ns[unit .. "itemLevel"].dominantQuality

    slot:ConfigureAverageLabel(itemQuality, itemLevel)
    slot:ShowAverageLabel()

end

ns:RegisterEvent("BETTERILVL_ITEMLEVEL_READY", displayAverageItemLevel, MID_PRIORITY)