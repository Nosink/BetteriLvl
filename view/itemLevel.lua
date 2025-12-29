local _, ns = ...

local function getPositoin(alternatePosition)
    print("Alternate Position:", alternatePosition)
    if alternatePosition then
        return 0, 45
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
        local x, y = getPositoin(alternatePosition)
        self.averageItemLevel:SetPoint("TOP", self, "CENTER", x, y)
        local r, g, b = ns.utils.GetItemQualityColor(itemQuality)
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
    local frameName = (unit == "target") and "Inspect" or "Character"
    local inventorySlot = _G[frameName .. ns.data.slotNames[INVSLOT_OFFHAND]]
    createFrontString(inventorySlot)
    ns[unit].itemLevel.slot = inventorySlot
    ns:TriggerEvent("BETTERILVL_ITEMLEVEL_READY", unit)
end

local function validateAverageItemLevelLabel()
    createAverageItemLevelLabel(nil, "player")
end

ns:RegisterEvent("BETTERILVL_SETTINGS_CHANGED", validateAverageItemLevelLabel)
ns:RegisterEvent("BETTERILVL_ITEMLEVEL_CALCULATED", createAverageItemLevelLabel)