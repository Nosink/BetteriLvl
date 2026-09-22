local name, ns = ...

local _G = _G
local next = next
local rawget = rawget
local rawset = rawset
local setmetatable = setmetatable
local type = type

local proto = {}

function proto:__index(key)
    local s = rawget(self, "_state")

    local v = rawget(s.charDB, key)
    if v ~= nil then return v end

    v = rawget(s.accountDB, key)
    if v ~= nil then
        return v
    end

    v = s.defaultsPC and rawget(s.defaultsPC, key)
    if v ~= nil then
        return v
    end

    v = s.defaults and rawget(s.defaults, key)
    if v ~= nil then
        return v
    end
end

function proto:__newindex(key, value)
    local s = rawget(self, "_state")

    if s.defaultsPC and rawget(s.defaultsPC, key) ~= nil then
        rawset(s.charDB, key, value)
        return
    end

    if s.defaults and rawget(s.defaults, key) ~= nil then
        rawset(s.accountDB, key, value)
        return
    end

    if rawget(s.charDB, key) ~= nil then
        rawset(s.charDB, key, value)
        return
    end

    if rawget(s.accountDB, key) ~= nil then
        rawset(s.accountDB, key, value)
        return
    end

    rawset(s.charDB, key, value)
end

function proto:__pairs()
    local s = rawget(self, "_state")

    local layers = {}
    layers[#layers + 1] = s.charDB
    layers[#layers + 1] = s.accountDB
    if s.defaultsPC then layers[#layers + 1] = s.defaultsPC end
    if s.defaults then layers[#layers + 1] = s.defaults end

    local seen, i, key = {}, 1, nil

    local function iterator()
        while i <= #layers do
            local layer = layers[i]
            key = next(layer, key)
            while key ~= nil and seen[key] do
                key = next(layer, key)
            end
            if key ~= nil then
                seen[key] = true
                return key, self[key]
            end
            i, key = i + 1, nil
        end
    end

    return iterator, self, nil
end

local function ensureDB(globalName)
    local t = rawget(_G, globalName)
    if type(t) == "table" then return t end

    t = {}
    _G[globalName] = t
    return t
end

local function validateOnLoad(onLoad)
    assert(onLoad == nil or type(onLoad) == "function", "onLoad must be a function or nil")
end

ns.database = {}
ns.defaults = ns.defaults or {}
ns.defaultsPC = ns.defaultsPC or {}

function ns.database.Evaluate(key, value)
    if value ~= nil then
        error("Duplicate key " .. tostring(key) .. " found in defaults.")
    end
end

function ns.database.Register(target, source)
    if not source then return end
    for key, value in pairs(source) do
        ns.database.Evaluate(key, target[key])
        target[key] = value
    end
end

function ns.database.Load(defaults, defaultsPC, onLoad)
    validateOnLoad(onLoad)

    ns.db = setmetatable({
        _state = {
            charDB     = ensureDB(name .. "PCDB"),
            accountDB  = ensureDB(name .. "DB"),
            defaults   = defaults,
            defaultsPC = defaultsPC,
        }
    }, proto)

    if onLoad then onLoad() end
end
