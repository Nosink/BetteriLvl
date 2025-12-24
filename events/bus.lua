local _, ns = ...

ns.handlers = ns.handlers or {}

MAX_PRIORITY = 0
MID_PRIORITY = 5
MIN_PRIORITY = 9

local frame = CreateFrame("Frame")

local handlers = {}
local DEFAULT_PRIORITY = MID_PRIORITY

local function dispatch(_, event, ...)
    local handlers = ns.handlers[event]
    if not handlers then
        return
    end

    for i = 1, #handlers do
        local entry = handlers[i]
        if entry and entry.fn then
            local ok, err = pcall(entry.fn, event, ...)
            if not ok then
                geterrorhandler()(err)
            end
        end
    end
end

local function clampPriority(priority)
    local prio = tonumber(priority) or DEFAULT_PRIORITY
    if prio < 0 then
        prio = 0
    elseif prio > 9 then
        prio = 9
    end
    return prio
end

local function registerEvents(eventName)
    if handlers then return end

    handlers = {}
    ns.handlers[eventName] = handlers
    frame:RegisterEvent(eventName)
end

local function setEventPriority(handler, priority)
    for i = 1, #handlers do
        if handlers[i].fn == handler then
            handlers[i].priority = priority
            return
        end
    end
end

local function getInsertIndex(priority)
    local insertIndex = #handlers + 1
    for i = 1, #handlers do
        if priority < handlers[i].priority then
            insertIndex = i
            break
        end
    end
    return insertIndex
end

function ns:RegisterEvent(eventName, handler, priority)
    if type(eventName) ~= "string" or type(handler) ~= "function" then return end

    handlers = ns.handlers[eventName]
    priority = clampPriority(priority)

    registerEvents(eventName)
    setEventPriority(handler, priority)

    local insertIndex = getInsertIndex(priority)
    local eventHandler = { fn = handler, priority = priority }

    table.insert(handlers, insertIndex, eventHandler)
end

local function clearHandler(handler)
    for i = #handlers, 1, -1 do
        if handlers[i].fn == handler then
            table.remove(handlers, i)
            break
        end
    end
end

local function unregisterEvents(eventName)
    if #handlers == 0 then
        ns.handlers[eventName] = nil
        frame:UnregisterEvent(eventName)
    end
end

function ns:UnregisterEvent(eventName, handler)
    handlers = ns.handlers[eventName]
    if not handlers or type(handler) ~= "function" then return end

    clearHandler(handler)
    unregisterEvents(eventName)
end

function ns:HookSecureFunc(frame, funcName, handler)
    if type(frame) ~= "table" or type(funcName) ~= "string" or type(handler) ~= "function" then return end

    hooksecurefunc(frame, funcName, function(...)
        local ok, err = pcall(handler, ...)
        if not ok then
            geterrorhandler()(err)
        end
    end)
end

frame:SetScript("OnEvent", dispatch)