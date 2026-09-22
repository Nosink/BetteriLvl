local _, ns = ...

ns.enums = ns.enums or {}

function ns.Enum(t)
    local enum = {}
    for key, value in pairs(t) do
        enum[key] = value
    end

    return setmetatable(enum, {
        __newindex = function()
            error("enum is read-only")
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
