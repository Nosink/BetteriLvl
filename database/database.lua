local name, ns = ...

local _G = _G
local next = next
local rawget = rawget
local rawset = rawset
local setmetatable = setmetatable
local type = type

local nestedProto = {}

function nestedProto:__index(key)
    local s = rawget(self, "_state")

    local sub = rawget(s.charDB, s.mod)
    if sub then
        local v = rawget(sub, key)
        if v ~= nil then return v end
    end

    sub = rawget(s.accountDB, s.mod)
    if sub then
        local v = rawget(sub, key)
        if v ~= nil then return v end
    end

    local dPC = s.defaultsPC and s.defaultsPC[s.mod]
    if dPC then
        local v = rawget(dPC, key)
        if v ~= nil then return v end
    end

    local d = s.defaults and s.defaults[s.mod]
    if d then
        local v = rawget(d, key)
        if v ~= nil then return v end
    end
end

local function ensureSub(db, mod)
    local sub = rawget(db, mod)
    if sub == nil then
        sub = {}
        rawset(db, mod, sub)
    end
    return sub
end

function nestedProto:__newindex(key, value)
    local s = rawget(self, "_state")

    local dPC = s.defaultsPC and s.defaultsPC[s.mod]
    if dPC and rawget(dPC, key) ~= nil then
        ensureSub(s.charDB, s.mod)[key] = value
        return
    end

    local d = s.defaults and s.defaults[s.mod]
    if d and rawget(d, key) ~= nil then
        ensureSub(s.accountDB, s.mod)[key] = value
        return
    end

    local cSub = rawget(s.charDB, s.mod)
    if cSub and rawget(cSub, key) ~= nil then
        cSub[key] = value
        return
    end

    ensureSub(s.charDB, s.mod)[key] = value
end

function nestedProto:__pairs()
    local s = rawget(self, "_state")

    local layers = {}
    local cSub = rawget(s.charDB, s.mod)
    if cSub then layers[#layers + 1] = cSub end
    local aSub = rawget(s.accountDB, s.mod)
    if aSub then layers[#layers + 1] = aSub end
    local dPC = s.defaultsPC and s.defaultsPC[s.mod]
    if dPC then layers[#layers + 1] = dPC end
    local d = s.defaults and s.defaults[s.mod]
    if d then layers[#layers + 1] = d end

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
            end
            i = i + 1
        end
    end

    return iterator, self, nil
end

local proto = {}

function proto:__index(mod)
    local state = rawget(self, "_state")

    local cache = state.proxyCache
    local proxy = cache[mod]
    if proxy then return proxy end

    proxy = setmetatable({
        _state = {
            mod        = mod,
            charDB     = state.charDB,
            accountDB  = state.accountDB,
            defaultsPC = state.defaultsPC,
            defaults   = state.defaults,
        }
    }, nestedProto)
    cache[mod] = proxy
    return proxy
end

function proto:__newindex()
    error("Assign fields, not whole modules: use ns.database[mod].field = value")
end

local function ensureDB(table)
    local t = rawget(_G, table)
    if type(t) == "table" then return t end

    t = {}
    _G[table] = t
    return t
end

local function validateOnLoad(onLoad)
    assert(onLoad == nil or type(onLoad) == "function", "onLoad must be a function or nil")
end

ns.db = {}

function ns.db:Load(defaults, defaultsPC, onLoad)
    validateOnLoad(onLoad)

    ns.database = setmetatable({
        _state = {
            charDB     = ensureDB(name .. "PCDB"),
            accountDB  = ensureDB(name .. "DB"),
            defaults   = defaults,
            defaultsPC = defaultsPC,
            proxyCache = {},
        }
    }, proto)

    if onLoad then onLoad() end
end
