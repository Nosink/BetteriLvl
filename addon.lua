local _, ns = ...

_G.BetteriLvl = {}

local function onPlayerEnteringWorld()
    ns:TriggerEvent("BETTERILVL_SAFE_ADDON_LOADED")
end

ns:RegisterEvent("PLAYER_ENTERING_WORLD", onPlayerEnteringWorld)