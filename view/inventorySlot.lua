local name, ns = ...

ns["player" .. "slots"] = ns["player" .. "slots"] or {}
ns["target" .. "slots"] = ns["target" .. "slots"] or {}

local slotNames = {
    [INVSLOT_AMMO] = "AmmoSlot",
    [INVSLOT_HEAD] = "HeadSlot",
    [INVSLOT_NECK] = "NeckSlot",
    [INVSLOT_SHOULDER] = "ShoulderSlot",
    [INVSLOT_BACK] = "BackSlot",
    [INVSLOT_CHEST] = "ChestSlot",
    [INVSLOT_BODY] = "ShirtSlot",
    [INVSLOT_TABARD] = "TabardSlot",
    [INVSLOT_WRIST] = "WristSlot",
    [INVSLOT_HAND] = "HandsSlot",
    [INVSLOT_WAIST] = "WaistSlot",
    [INVSLOT_LEGS] = "LegsSlot",
    [INVSLOT_FEET] = "FeetSlot",
    [INVSLOT_FINGER1] = "Finger0Slot",
    [INVSLOT_FINGER2] = "Finger1Slot",
    [INVSLOT_TRINKET1] = "Trinket0Slot",
    [INVSLOT_TRINKET2] = "Trinket1Slot",
    [INVSLOT_MAINHAND] = "MainHandSlot",
    [INVSLOT_OFFHAND] = "SecondaryHandSlot",
    [INVSLOT_RANGED] = "RangedSlot",
}

local borderData = {
    texture = "Interface/Buttons/UI-ActionButton-Border",
    alpha = 0.5,
    blendMode = "ADD",
    origin = { anchor = "TOPLEFT", relative = "TOPLEFT", offset = { x = -15, y = 15}},
    destination = { anchor = "BOTTOMRIGHT", relative = "BOTTOMRIGHT", offset = { x = 15, y = -15}},
    offset = { x = 15, y = 15},
}

local function createBorder(slot)
    if not slot.border then
        slot.border = slot:CreateTexture(nil, "OVERLAY")
        slot.Configure = function (self, itemQuality)
            local r, g, b = _G.BetteriLvl.API.GetItemQualityColor(itemQuality)
            self.border:SetPoint(borderData.origin.anchor, self, borderData.origin.relative, borderData.origin.offset.x, borderData.origin.offset.y)
            self.border:SetPoint(borderData.destination.anchor, self, borderData.destination.relative, borderData.destination.offset.x, borderData.destination.offset.y)
            self.border:SetAlpha(borderData.alpha)
            self.border:SetBlendMode(borderData.blendMode)
            self.border:SetTexture(borderData.texture)
            self.border:SetVertexColor(r, g, b)
        end
        slot.Show = function(self)
            self.border:Show()
        end
        slot.Hide = function(self)
            self.border:Hide()
        end
    end
end

local function createCharacterInventorySlots()
    local slots = ns["player" .. "slots"] or {}
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local inventorySlot = _G["Character" .. slotNames[slot]]
        createBorder(inventorySlot)
        slots[slot] = inventorySlot
    end
    ns["player" .. "slots"] = slots
end

local function createTargetInventorySlots()
    local slots = ns["target" .. "slots"] or {}
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local inventorySlot = _G["Inspect" .. slotNames[slot]]
        createBorder(inventorySlot)
        slots[slot] = inventorySlot
    end
    ns["target" .. "slots"] = slots
end

local function onAddonLoaded(_, addon)
    if addon ~= name then return end
    createCharacterInventorySlots()

end

ns:RegisterEvent("ADDON_LOADED", onAddonLoaded, MAX_PRIORITY)
ns:RegisterEvent("BETTERILVL_TARGET_CACHED", createTargetInventorySlots, MAX_PRIORITY)