local name, ns = ...

ns.db = ns.db or {}

local function onAddonLoaded(_, addon)
    if addon ~= name then return end

    _G[name.."DB"] = setmetatable(_G[name.."DB"] or {}, {
        __index = ns.defaults,
    })
    ns.db = _G[name.."DB"]

end

ns:RegisterEvent("ADDON_LOADED", onAddonLoaded, MAX_PRIORITY)