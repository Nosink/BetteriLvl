local name, ns = ...

ns.database = ns.database or {}

local function onVariablesLoaded(_, addon)
    if addon ~= name then return end

    _G[name.."DB"] = setmetatable(_G[name.."DB"] or {}, {
        __index = ns.defaults,
    })
    ns.database = _G[name.."DB"]

end

ns:RegisterEvent("VARIABLES_LOADED", onVariablesLoaded, MAX_PRIORITY)