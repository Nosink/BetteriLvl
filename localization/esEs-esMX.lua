local name, ns = ...
local L = ns.L

if ns.locale == "esES" or ns.locale == "esMX" then
	L["LKEY_OPTIONS_TITLE"] = name .. " " .. "Opciones"

	L["LKEY_OPTIONS_PLAYER_FRAME"] = "Panel de Personaje"
	L["LKEY_OPTIONS_PLAYER_ITEM_LEVEL"] = "Mostrar Nivel de Objeto"
	L["LKEY_OPTIONS_PLAYER_BORDER"] = "Mostrar Borde de Objeto"

	L["LKEY_OPTIONS_DURABILITY"] = "Durabilidad"
	L["LKEY_OPTIONS_DURABILITY_ENABLE"] = "Habilitar Visualización de Durabilidad"
	L["LKEY_OPTIONS_DURABILITY_TYPE"] = "Tipo de Visualización de Durabilidad"
	L["LKEY_OPTIONS_DURABILITY_TYPE_BAR"] = "Barra"
	L["LKEY_OPTIONS_DURABILITY_TYPE_TEXT"] = "Texto"
	L["LKEY_OPTIONS_DURABILITY_TYPE_ICON"] = "Icono"
	L["LKEY_OPTIONS_DURABILITY_COLOR"] = "Mostrar Durabilidad con Color"

	L["LKEY_OPTIONS_TARGET_FRAME"] = "Panel de Objetivo"
	L["LKEY_OPTIONS_TARGET_ITEM_LEVEL"] = "Mostrar Nivel de Objeto"
	L["LKEY_OPTIONS_TARGET_BORDER"] = "Mostrar Borde de Objeto"
end
