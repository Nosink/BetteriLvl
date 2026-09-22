local _, ns = ...

ns.enums = ns.enums or {}

function ns.Enum(t)
    return setmetatable({}, {
        __index = t,
        __newindex = function()
            error("enum is read-only")
        end,
        __pairs = function()
            return pairs(t)
        end,
    })
end

function ns.RegisterEnum(name, t)
    if ns.enums[name] then
        print(name .. ": enum " .. name .. " already exists")
    else
        ns.enums[name] = ns.Enum(t)
    end
end
