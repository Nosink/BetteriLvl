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

local boor = {}

boor.data = {
    texture = "Interface/Buttons/UI-ActionButton-Border",
    alpha = 0.5,
    blendMode = "ADD",
    origin = { anchor = "TOPLEFT", relative = "TOPLEFT", offset = { x = -13, y = 13}},
    destination = { anchor = "BOTTOMRIGHT", relative = "BOTTOMRIGHT", offset = { x = 13, y = -13}},
    offset = { x = 13, y = 13},
}


local function createCharacterBorders()
    ns["player" .. "slots"] = ns["player" .. "slots"] or {}
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local slotName = slotsNameAss[slot]
        local equipSlot = _G["Character" .. slotName]
        if equipSlot then
            equipSlot.border = equipSlot:CreateTexture(nil, "OVERLAY")
            equipSlot.Configure = function (self, itemQuality)
                local r, g, b = _G.BetteriLvl.API.GetItemQualityColor(itemQuality)
                self.border:SetPoint(boor.data.origin.anchor, self, boor.data.origin.relative, boor.data.origin.offset.x, boor.data.origin.offset.y)
                self.border:SetPoint(boor.data.destination.anchor, self, boor.data.destination.relative, boor.data.destination.offset.x, boor.data.destination.offset.y)
                self.border:SetAlpha(boor.data.alpha)
                self.border:SetBlendMode(boor.data.blendMode)
                self.border:SetTexture(boor.data.texture)
                self.border:SetVertexColor(r, g, b)
            end
            equipSlot.Show = function(self)
                self.border:Show()
            end
            equipSlot.Hide = function(self)
                self.border:Hide()
            end

            ns["player" .. "slots"][slot] = equipSlot
        end
    end
end

local function onAddonLoaded(_, addon)
    if addon ~= "Blizzard_CharacterUI" then return end
    createCharacterBorders()
end

ns:RegisterEvent("ADDON_LOADED", onAddonLoaded, MID_PRIORITY)

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
                        self.border:SetPoint(boor.data.origin.anchor, self, boor.data.origin.relative, boor.data.origin.offset.x, boor.data.origin.offset.y)
                        self.border:SetPoint(boor.data.destination.anchor, self, boor.data.destination.relative, boor.data.destination.offset.x, boor.data.destination.offset.y)
                        self.border:SetAlpha(boor.data.alpha)
                        self.border:SetBlendMode(boor.data.blendMode)
                        self.border:SetTexture(boor.data.texture)
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
