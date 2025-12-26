local _, ns = ...

_G.BetteriLvl = {}

ns.player = {}

ns.player.slots =  {}
ns.player.items =  {}
ns.player.itemLevel = {}

ns.target = {}

ns.target.slots =  {}
ns.target.items =  {}
ns.target.itemLevel = {}

ns.tooltip = {}
ns.tooltip.item = nil

local function onPlayerEnteringWorld()
    ns:TriggerEvent("BETTERILVL_SAFE_ADDON_LOADED")
end

ns:RegisterEvent("PLAYER_ENTERING_WORLD", onPlayerEnteringWorld)