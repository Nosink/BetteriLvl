local name, ns = ...

ns["player" .. "slots"] = ns["player" .. "slots"] or {}
ns["player" .. "items"] = ns["player" .. "items"] or {}

local slotsNameAss = {
    [INVSLOT_AMMO]     = "AmmoSlot",
    [INVSLOT_HEAD]     = "HeadSlot",
    [INVSLOT_NECK]     = "NeckSlot",
    [INVSLOT_SHOULDER] = "ShoulderSlot",
    [INVSLOT_BACK]     = "BackSlot",
    [INVSLOT_CHEST]    = "ChestSlot",
    [INVSLOT_BODY]     = "ShirtSlot",
    [INVSLOT_TABARD]   = "TabardSlot",
    [INVSLOT_WRIST]    = "WristSlot",
    [INVSLOT_HAND]     = "HandsSlot",
    [INVSLOT_WAIST]    = "WaistSlot",
    [INVSLOT_LEGS]     = "LegsSlot",
    [INVSLOT_FEET]     = "FeetSlot",
    [INVSLOT_FINGER1]  = "Finger0Slot",
    [INVSLOT_FINGER2]  = "Finger1Slot",
    [INVSLOT_TRINKET1] = "Trinket0Slot",
    [INVSLOT_TRINKET2] = "Trinket1Slot",
    [INVSLOT_MAINHAND] = "MainHandSlot",
    [INVSLOT_OFFHAND]  = "SecondaryHandSlot",
    [INVSLOT_RANGED]   = "RangedSlot",
}

local borderData = {
    texture = "Interface/Buttons/UI-ActionButton-Border",
    alpha = 0.5,
    blendMode = "ADD",
    origin = { anchor = "TOPLEFT", relative = "TOPLEFT", offset = { x = -15, y = 15}},
    destination = { anchor = "BOTTOMRIGHT", relative = "BOTTOMRIGHT", offset = { x = 15, y = -15}},
    offset = { x = 15, y = 15},
}

local function displayCharacterBorders()
    local slots = ns["player" .. "slots"]
    local items = ns["player" .. "items"]
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local equipSlot = slots and slots[slot]
        if not equipSlot then
            local slotName = slotsNameAss[slot]
            equipSlot = _G["Character" .. slotName]
            if equipSlot then
                if not equipSlot.border then
                    equipSlot.border = equipSlot:CreateTexture(nil, "OVERLAY")
                    equipSlot.Configure = function (self, itemQuality)
                        local r, g, b = _G.BetteriLvl.API.GetItemQualityColor(itemQuality)
                        self.border:SetPoint(borderData.origin.anchor, self, borderData.origin.relative, borderData.origin.offset.x, borderData.origin.offset.y)
                        self.border:SetPoint(borderData.destination.anchor, self, borderData.destination.relative, borderData.destination.offset.x, borderData.destination.offset.y)
                        self.border:SetAlpha(borderData.alpha)
                        self.border:SetBlendMode(borderData.blendMode)
                        self.border:SetTexture(borderData.texture)
                        self.border:SetVertexColor(r, g, b)
                    end
                    equipSlot.Show = function(self)
                        self.border:Show()
                    end
                    equipSlot.Hide = function(self)
                        self.border:Hide()
                    end
                end
                slots[slot] = equipSlot
            end
        end
        local itemData = items and items[slot]
        if equipSlot and itemData and itemData.cached and itemData.item then
            local itemQuality = itemData.item:GetItemQuality()
            equipSlot:Configure(itemQuality)
            equipSlot:Show()
        elseif equipSlot then
            equipSlot:Hide()
        end
    end
end

ns:RegisterEvent("BETTERILVL_ALL_ITEMS_CACHED", displayCharacterBorders)
