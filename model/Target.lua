

-- local settings = ns.settings
-- 
-- local function UpdateTargetiLvl()
--     if (settings.IsTargetiLvlEnabled() or settings.IsTargetBorderEnabled()) then
    --         ShowSlotiLvlOn(UnitHelper.Target)
--     else
    --         HideSlotiLvlFrom(UnitHelper.Target)
    --     end
-- end
-- 
-- local function UpdateTargetAverageiLvl()
--     if (BetteriLvlDB.targetAverage == false) then
--         HideAverageiLvlFrom(UnitHelper.Target)
--     else
--         ShowAverageiLvlOf(UnitHelper.Target)
--     end
-- end
-- 
-- local function HandleOnInspectTarget()
    --     UpdateTargetiLvl()
--     UpdateTargetAverageiLvl()
-- end
-- 
-- local function OnNotifyInspectHandler(unit)
--     if not UnitHelper.IsTarget(unit) then
    --         return
--     end
--     
--     HideSlotiLvlFrom(unit)
--     HideAverageiLvlFrom(unit)
-- end
-- 
-- local function HandlePlayerChangedTarget(event)
--     if event ~= "PLAYER_TARGET_CHANGED" then
    --         return
--     end
--     HideSlotiLvlFrom(UnitHelper.Target)
--     HideAverageiLvlFrom(UnitHelper.Target)
-- end
-- 
-- local function HandleInspectReady(event)
--     if event ~= "INSPECT_READY" then
--         return
--     end
--     C_Timer.After(0.05, HandleOnInspectTarget)
-- end
-- 
-- local function HandleEvents(_, event, _)
--     HandlePlayerChangedTarget(event)
--     HandleInspectReady(event)
-- end
-- 
-- hooksecurefunc("NotifyInspect", OnNotifyInspectHandler)
-- 
-- local BetteriLvlInspectFrame = CreateFrame("Frame")
-- 
-- BetteriLvlInspectFrame:RegisterEvent("INSPECT_READY")
-- BetteriLvlInspectFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
-- BetteriLvlInspectFrame:SetScript("OnEvent", HandleEvents)
-- 
local name, ns = ...

ns["target" .. "items"] = ns["target" .. "items"] or {}

local function evaluateItemsCache()
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local itemData = ns["target" .. "items"][slot]
        if not itemData or not itemData.cached then return end
    end
    ns:TriggerEvent("BETTERILVL_TARGET_CACHED")
end

local function cacheItemSlot(slot)
    local itemSlot = ns["target" .. "items"][slot]

    itemSlot:Initialize()

    local itemID = GetInventoryItemID("target", slot)
    if not itemID then itemSlot:Clear() return end
    if itemSlot.itemID == itemID and itemSlot.cached then return end

    local item = Item:CreateFromItemID(itemID)
    if not item then itemSlot:Clear() return end

    item:ContinueOnItemLoad(function()
        itemSlot:SetItem(item)
    end)
end

local function cacheTargetItems()
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        cacheItemSlot(slot)
    end
end

local function onInspectReady(inspecteeGUID)
    cacheTargetItems()
end

local function createTargetItems()
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local item = {}
        item.Initialize = function(self)
            self.item = nil
            self.cached = false
        end
        item.SetItem = function (self, item)
            self.item = item
            self.cached = true
            evaluateItemsCache()
        end
        item.Clear = function(self)
            self.item = nil
            self.cached = true
            evaluateItemsCache()
        end
        item:Initialize()
        ns["target" .. "items"][slot] = item
    end
end

local function onAddonLoaded(_, addon)
    if addon ~= name then return end
    createTargetItems()
end

ns:RegisterEvent("ADDON_LOADED", onAddonLoaded, MID_PRIORITY)
ns:RegisterEvent("INSPECT_READY", onInspectReady)
