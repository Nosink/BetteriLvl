local name, ns = ...

local utils = ns.utils

local function getPosition(alternatePosition)
    if alternatePosition then
        return 0, 42.5
    else
        return -115, -5
    end
end

local function createFrontString(slot)
    if slot.averageItemLevel then slot:HideAverageLabel() return end

    slot.averageItemLevel = slot:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    slot.averageItemLevel:SetShadowOffset(1, -1)
    slot.averageItemLevel:SetShadowColor(0, 0, 0, 1)

    slot.ShowAverageLabel = function(self, itemQuality, itemLevel, alternatePosition)
        if not self.averageItemLevel then return end
        local x, y = getPosition(alternatePosition)
        self.averageItemLevel:SetPoint("TOP", self, "CENTER", x, y)
        local r, g, b = utils.GetItemQualityColor(itemQuality)
        self.averageItemLevel:SetTextColor(r, g, b)
        self.averageItemLevel:SetText(string.format("iLvl: %.1f", itemLevel))
        self.averageItemLevel:Show()
    end

    slot.HideAverageLabel = function(self)
        if not self.averageItemLevel then return end

        self.averageItemLevel:SetText("")
        self.averageItemLevel:Hide()
    end

    slot.averageItemLevel:Hide()
end

local function createAverageItemLevelLabel(_, unit)
    local frameName = (unit == "player") and "Character" or "Inspect"
    local inventorySlot = _G[frameName .. ns.data.slotNames[INVSLOT_OFFHAND]]
    createFrontString(inventorySlot)
    ns[unit].itemLevel.slot = inventorySlot
    ns:TriggerEvent(name .. "_ITEMLEVEL_READY", unit)
end

local function validateAverageItemLevelLabel()
    createAverageItemLevelLabel(nil, "player")
end

ns:RegisterEvent(name .. "_ITEMLEVEL_CALCULATED", createAverageItemLevelLabel)
ns:RegisterEvent(name .. "_SETTINGS_CHANGED", validateAverageItemLevelLabel)