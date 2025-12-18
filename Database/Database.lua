
local default = {
    playerAverage = true,
    playerAverageAlternatePosition = false,
    playerLevel = true,
    playerBorder = true,

    targetAverage = true,
    targetLevel = true,
    targetBorder = true,

    tooltipLevel = true,
    tooltipID = false,
}



local function InitializeDatabase()
    BetteriLvlDB = BetteriLvlDB or {}
end

local function LoadDefaultDatabaseSettings()
    for key, value in pairs(default) do
        if BetteriLvlDB[key] == nil then
            BetteriLvlDB[key] = value
        end
    end
end

local function HandleOnAddonLoaded(_, _, name)
    if name ~= ADDON_NAME then
        return
    end
    InitializeDatabase()
    LoadDefaultDatabaseSettings()
end

local BetteriLvlDatabase = CreateFrame("Frame")

BetteriLvlDatabase:RegisterEvent("ADDON_LOADED")
BetteriLvlDatabase:SetScript("OnEvent", HandleOnAddonLoaded)