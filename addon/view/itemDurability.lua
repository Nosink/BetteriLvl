local name, ns = ...

local enums = ns.enums
local durabilityType = enums.durabilityType

local function isDurabilityTypeBar()
    return ns.db.durabilityType == durabilityType.Bars
end

local function getDurabilityColor(durabilityPercent)
    if ns.db.durabilityColor then
        local percent = tonumber(durabilityPercent) or 0
        local r = math.min(1, (100 - percent) / 50)
        local g = math.min(1, percent / 50)
        local b = 0
        return r, g, b
    else
        return 1, 1, 1
    end
end

local function isDurabilityEnabled()
    return ns.db.durability
end

local function createDurabilityText(frame)
    frame.Durability.Text = frame:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    frame.Durability.Text:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 2)
    frame.Durability.Text:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 16)
    frame.Durability.Text:SetShadowOffset(1, -1)
    frame.Durability.Text:SetShadowColor(0, 0, 0, 1)
    local fontName, _, flags = frame.Durability.Text:GetFont()
    frame.Durability.Text:SetFont(tostring(fontName), 12, flags)
    frame.Durability.Text:Hide()

    frame.Durability.Text.ShowDurability = function(self, durabilityPercent)
        local r, g, b = getDurabilityColor(durabilityPercent)
        self:SetTextColor(r, g, b)
        self:SetText(durabilityPercent .. "%")
        self:SetJustifyH("CENTER")
        self:Show()
    end
end

local function createDurabilityBar(frame)
    frame.Durability.Bar = CreateFrame("StatusBar", nil, frame)
    frame.Durability.Bar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 2, 2)
    frame.Durability.Bar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 0)
    frame.Durability.Bar:SetHeight(4)
    frame.Durability.Bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    local bg = frame.Durability.Bar:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(frame.Durability.Bar)
    bg:SetColorTexture(0, 0, 0, 0.9)
    frame.Durability.Bar:SetMinMaxValues(0, 100)
    frame.Durability.Bar:Hide()

    frame.Durability.Bar.ShowDurability = function(self, durabilityPercent)
        local r, g, b = getDurabilityColor(durabilityPercent)
        self:SetStatusBarColor(r, g, b)
        self:SetValue(durabilityPercent)
        self:Show()
    end
end

local function createDurability(frame)
    if not frame or frame.Durability and frame.Durability.isInitialized then return end

    frame.Durability = { Bar = {}, text = {} }
    createDurabilityBar(frame)
    createDurabilityText(frame)

    frame.ShowDurability = function(self, durabilityPercent)
        if not self.Durability then return end
        self.Durability.Bar:Hide()
        self.Durability.Text:Hide()
        if isDurabilityTypeBar() then
            self.Durability.Bar:ShowDurability(durabilityPercent)
        else
            self.Durability.Text:ShowDurability(durabilityPercent)
        end
    end

    frame.HideDurability = function(self)
        if not self.Durability then return end
        self.Durability.Bar:Hide()
        self.Durability.Text:Hide()
    end

    frame:HideDurability()
    frame.Durability.isInitialized = true
end

local function retrieveFrame(slotName)
    return _G["Character" .. slotName]
end

local function displayDurability(frame, slotId)
    if not frame then return end
    local invSlotId = enums.slotIdType[slotId]
    local current, maximum = GetInventoryItemDurability(invSlotId)
    local durabilityPercent = (current and maximum and maximum > 0) and math.floor((current / maximum) * 100)
    if durabilityPercent then
        frame:ShowDurability(durabilityPercent)
    else
        frame:HideDurability()
    end
end

local function hideDurability()
    for _, slotName in pairs(enums.slotNameType) do
        local frame = retrieveFrame(slotName)
        if frame and frame.Durability then
            frame:HideDurability()
        end
    end
end

local function refreshDurability()
    if not isDurabilityEnabled() then
        hideDurability()
        return
    end

    for slotId, slotName in pairs(enums.slotNameType) do
        local frame = retrieveFrame(slotName)
        createDurability(frame)
        displayDurability(frame, slotId)
    end
end

local function onItemsCached(_, unit)
    if unit ~= "player" then return end
    refreshDurability()
end

ns.bus:RegisterEvent(name .. "_ITEMS_CACHED", onItemsCached)

local function onSettingsChanged(_, key)
    if key == "durability" then
        refreshDurability()
    elseif key == "durabilityType" then
        refreshDurability()
    elseif key == "durabilityColor" then
        refreshDurability()
    end
end

ns.bus:RegisterEvent(name .. "_SETTINGS_CHANGED", onSettingsChanged)
