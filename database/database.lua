local name, ns = ...

ns.db = ns.db or {}

local function onVariablesLoaded(_, addon)
    if addon ~= name then return end

    _G[name.."DB"] = setmetatable(_G[name.."DB"] or {}, {
        __index = ns.defaults,
    })
    ns.db = _G[name.."DB"]

end

ns:RegisterEvent("VARIABLES_LOADED", onVariablesLoaded, MAX_PRIORITY)