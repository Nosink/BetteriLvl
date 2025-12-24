local name, ns = ...
local db

function ns:ADDON_LOADED(_, addon)
    if ns.hooks[addon] then
        xpcall(ns.hooks[addon], geterrorhandler())
        ns.hooks[addon] = nil
    end
    if addon == name then
        _G[name.."DB"] = setmetatable(_G[name.."DB"] or {}, {
            __index = ns.defaults,
        })
        db = _G[name.."DB"]
        ns.db = db
    end
end
ns:RegisterEvent("ADDON_LOADED")