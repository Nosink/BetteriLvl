local _, ns = ...

local labelData = {
    font = "GameFontNormalLarge",
    anchor = "TOP",
    relative = "CENTER",
    position = { x = -112, y = -5},
    alternatePosition = { x = 0, y = 40},
    text = "iLvl: ",
    shadow = {offset = { x = 1 , y = -1}, color = { r = 0, g = 0, b = 0, a = 1} }
}

local function createFrontString(slot)
    if slot.averageItemLevel then
        slot:HideAverageLabel()
        return
    end
    slot.averageItemLevel = slot:CreateFontString(nil, "OVERLAY", labelData.font)
    slot.ConfigureAverageLabel = function (self, itemQuality, itemLevel, alternatePosition)
        local anchor, relative = labelData.anchor, labelData.relative
        local x, y = unpack(alternatePosition and labelData.alternatePosition or labelData.position)
        self.averageItemLevel:SetPoint(anchor, self, relative, x, y)
        local sx, sy = unpack(labelData.shadow.offset)
        self.averageItemLevel:SetShadowOffset(sx, sy)
        local sr, sg, sb, sa = unpack(labelData.shadow.color)
        self.averageItemLevel:SetShadowColor(sr, sg, sb, sa)
        local r, g, b = ns.utils.GetItemQualityColor(itemQuality)
        self.averageItemLevel:SetTextColor(r, g, b)
        self.averageItemLevel:SetText(string.format("%s%.1f", labelData.text, itemLevel))
    end

    slot.ShowAverageLabel = function(self)
        self.averageItemLevel:Show()
    end

    slot.HideAverageLabel = function(self)
        if not self.averageItemLevel then
            return
        end
        self.averageItemLevel:SetText("")
        self.averageItemLevel:Hide()
    end
    slot:HideAverageLabel()
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