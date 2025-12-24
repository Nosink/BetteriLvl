local name, ns = ...
local db

local function onAddonLoaded(_, addon)
    if addon ~= name then return end

    _G[name.."DB"] = setmetatable(_G[name.."DB"] or {}, {
        __index = ns.defaults,
    })
    db = _G[name.."DB"]
    ns.db = db

end

ns:RegisterEvent("ADDON_LOADED", onAddonLoaded, MAX_PRIORITY)