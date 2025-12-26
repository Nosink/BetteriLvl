local name, ns = ...

_G.BetteriLvl = {}

local function onAddonLoaded(_, addon)
    if addon ~= name then return end
    C_Timer.After(5, function()
        ns:TriggerEvent("BETTERILVL_ADDON_LOADED")
    end)
end

ns:RegisterEvent("ADDON_LOADED", onAddonLoaded)