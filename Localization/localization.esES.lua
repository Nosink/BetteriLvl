local ADDON_NAME, namespace = ...
local L = namespace.L

if namespace.locale == "esES" or namespace.locale == "esMX" then
	L["LKEY_OPTIONS_TITLE"] = ADDON_NAME .. " " .. "Opciones"

	L["LKEY_OPTIONS_PLAYER_FRAME"] = "Panel de Personaje"
	L["LKEY_OPTIONS_PLAYER_AVERAGE"] = "Mostrar Nivel de Objeto Promedio"
	L["LKEY_OPTIONS_PLAYER_AVERAGE_ALTERNATE_POSITION"] = "Nivel de Objeto Promedio debajo del Personaje"
	L["LKEY_OPTIONS_PLAYER_ITEM_LEVEL"] = "Mostrar Nivel de Objeto"
	L["LKEY_OPTIONS_PLAYER_BORDER"] = "Mostrar Borde de Objeto"

	L["LKEY_OPTIONS_TARGET_FRAME"] = "Panel de Objetivo"
	L["LKEY_OPTIONS_TARGET_AVERAGE"] = "Mostrar Nivel de Objeto Promedio"
	L["LKEY_OPTIONS_TARGET_ITEM_LEVEL"] = "Mostrar Nivel de Objeto"
	L["LKEY_OPTIONS_TARGET_BORDER"] = "Mostrar Borde de Objeto"

	L["LKEY_OPTIONS_TOOLTIP"] = "ToolTip"
	L["LKEY_OPTIONS_TOOLTIP_ITEM_LEVEL"] = "Mostrar Nivel de Objeto"
	L["LKEY_OPTIONS_TOOLTIP_ITEM_ID"] = "Mostrar ID de Objeto"

	L["LKEY_TOOLTIP_ITEM_LEVEL"] = "Nivel de Objeto"
	L["LKEY_TOOLTIP_ITEM_ID"] = "ID de Objeto"

end
