local name, ns = ...

local utils = ns.utils
local debug = ns.debug
local enums = ns.enums
local durabilityType = enums.durabilityType

local function isDurabilityTypeBar()
    return ns.db.durabilityType == durabilityType.Bars
end

local function getDurabilityColor(durabilityPercent)
    if ns.db.durabilityColor then
        return utils.GetDurabilityColor(durabilityPercent)
    else
        return 1, 1, 1
    end
end

local function isDurabilityEnabled()
    return ns.db.durability
end

local function createDurabilityText(frame)
    frame.durability.text = frame:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    frame.durability.text:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 2)
    frame.durability.text:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 16)
    frame.durability.text:SetShadowOffset(1, -1)
    frame.durability.text:SetShadowColor(0, 0, 0, 1)
    local fontName, _, flags = frame.durability.text:GetFont()
    frame.durability.text:SetFont(tostring(fontName), 12, flags)
    frame.durability.text:Hide()

    frame.durability.text.ShowDurability = function(self, durabilityPercent)
        local r, g, b = getDurabilityColor(durabilityPercent)
        self:SetTextColor(r, g, b)
        self:SetText(durabilityPercent .. "%")
        self:SetJustifyH("CENTER")
        self:Show()
    end
end

local function createDurabilityBar(frame)
    frame.durability.bar = CreateFrame("StatusBar", nil, frame)
    frame.durability.bar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 2, 2)
    frame.durability.bar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 0)
    frame.durability.bar:SetHeight(4)
    frame.durability.bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    local bg = frame.durability.bar:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(frame.durability.bar)
    bg:SetColorTexture(0, 0, 0, 0.9)
    frame.durability.bar:SetMinMaxValues(0, 100)
    frame.durability.bar:Hide()

    frame.durability.bar.ShowDurability = function(self, durabilityPercent)
        local r, g, b = getDurabilityColor(durabilityPercent)
        self:SetStatusBarColor(r, g, b)
        self:SetValue(durabilityPercent)
        self:Show()
    end
end

local function createDurability(frame)
    if not frame or frame.durability then return end

    frame.durability = { bar = {}, text = {} }
    createDurabilityBar(frame)
    createDurabilityText(frame)

    frame.ShowDurability = function(self, durabilityPercent)
        if not self.durability then return end
        if isDurabilityTypeBar() then
            self.durability.bar:ShowDurability(durabilityPercent)
        else
            self.durability.text:ShowDurability(durabilityPercent)
        end
    end

    frame.HideDurability = function(self)
        if not self.durability then return end
        self.durability.bar:Hide()
        self.durability.text:Hide()
    end

    frame:HideDurability()
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

local function onItemsCached(_, unit)
    if unit ~= "player" then return end
    if not isDurabilityEnabled() then return end

    for slotId, slotName in debug.pairs(enums.slotNameType) do
        local frame = retrieveFrame(slotName)
        createDurability(frame)
        displayDurability(frame, slotId)
    end
end

ns.bus:RegisterEvent(name .. "_ITEMS_CACHED", onItemsCached)
