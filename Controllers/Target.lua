
local _, ns = ...

local settings = ns.settings

local function UpdateTargetiLvl()
    if (settings.IsTargetiLvlEnabled() or settings.IsTargetBorderEnabled()) then
        ShowSlotiLvlOn(UnitHelper.Target)
    else
        HideSlotiLvlFrom(UnitHelper.Target)
    end
end

local function UpdateTargetAverageiLvl()
    if (BetteriLvlDB.targetAverage == false) then
        HideAverageiLvlFrom(UnitHelper.Target)
    else
        ShowAverageiLvlOf(UnitHelper.Target)
    end
end

local function HandleOnInspectTarget()
    UpdateTargetiLvl()
    UpdateTargetAverageiLvl()
end

local function OnNotifyInspectHandler(unit)
    if not UnitHelper.IsTarget(unit) then
        return
    end
    
    HideSlotiLvlFrom(unit)
    HideAverageiLvlFrom(unit)
end

local function HandlePlayerChangedTarget(event)
    if event ~= "PLAYER_TARGET_CHANGED" then
        return
    end
    HideSlotiLvlFrom(UnitHelper.Target)
    HideAverageiLvlFrom(UnitHelper.Target)
end

local function HandleInspectReady(event)
    if event ~= "INSPECT_READY" then
        return
    end
    C_Timer.After(0.05, HandleOnInspectTarget)
end

local function HandleEvents(_, event, _)
    HandlePlayerChangedTarget(event)
    HandleInspectReady(event)
end

hooksecurefunc("NotifyInspect", OnNotifyInspectHandler)

local BetteriLvlInspectFrame = CreateFrame("Frame")

BetteriLvlInspectFrame:RegisterEvent("INSPECT_READY")
BetteriLvlInspectFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
BetteriLvlInspectFrame:SetScript("OnEvent", HandleEvents)