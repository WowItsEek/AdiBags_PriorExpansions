local addonName, addon = ...	 
--	 
	
--<GLOBALS      	
local _G = _G      	
local GetLocale = _G.GetLocale      	
local pairs = _G.pairs      	
local rawset = _G.rawset      	
local setmetatable = _G.setmetatable      	
local tostring = _G.tostring      	
--GLOBALS>      	
      	
local L = setmetatable({}, {      	
  __index = function(self, key)    	
    if key ~= nil then  	
      --[===[@debug@	
	
      addon:Debug('Missing locale', tostring(key))	
      --@end-debug@]===]	
      rawset(self, key, tostring(key))	
    end  	
    return tostring(key)  	
  end,    	
})      	
addon.L = L      	
	
local locale = GetLocale()	
----enUS	 
	 
   L["BoP"] = true	 
   L["BoE"] = true	 
   L["BoA"] = true	 
   L["Open Me!"] = true	 
   L["Cosmetic"] = true	 
   L["Pet Battle"] = true	 
   L["Miscellaneous"] = true	 
   L["Enable prior expansion groups"] = true	 
   L["Check this if you want to group by prior expansion. Prior expansion group bag labels are light blue."] = true	 
   L["Equippable Item Sub-Groupings"] = true	 
   L["Select optional groupings for weapons and armor."] = true	 
   L["Bind on Equip Gear"] = true	 
   L["Check to group Bind on Equip armor and weapons from prior expansions."] = true	 
   L["Check to group Soulbound armor and weapons from prior expansions."] = true	 
   L["Check to group Legendaries from prior expansions."] = true	 
   L["Check to group Artifacts from prior expansions."] = true	 
   L["Check to group cosmetic items like tabards and costumes."] = true	 
   L["Optional miscellaneous item groupings"] = true	 
   L["Select groupings options for non-gear items."] = true	 
   L["Check to group Trade Goods by category (Herbs, Leather, etc.) from prior expansions."] = true	 
   L["Food, Drink & Potions"] = true	 
   L["Check to group Food, Drink, Potions, Elixirs and Flasks from prior expansions."] = true	 
   L["Battle Pet Items"] = true	 
   L["Check to group battle pet items."] = true	 
   L["Group Unopened Loot"] = true	 
   L["Check to group lockboxes, bonus caches and other loot containers. Yeah, it\'s not expansion related, but it\'s handy!"] = true	 
   L["Separate Mount Drops"] = true	 
   L["Check to group Mounts reins so you don't space if one dropped and keep grinding needlessly."] = true	 
   L["Prior Expansion Groups"] = true	 
   L["Other Settings"] = true	 
   L["Other Prior Expansion filter settings"] = true	 
   L["Colored labels"] = true	 
   L["Prior Expansion Groups"] = true	 
   L["Check to use colored labels for prior expansion tradegoods and consumables."] = true	 
	 
----deDE	 
if locale=="deDE" then 	 
   L["BoP"] = "BoP"	 
   L["BoE"] = "BoE"	 
   L["BoA"] = "BoA"	 
   L["Open Me!"] = "Öffne mich!"	 
   L["Cosmetic"] = "Kosmetisch"	 
   L["Pet Battle"] = "Haustierkämpfe"	 
   L["Miscellaneous"] = "Sonstiges"	 
   L["Enable prior expansion groups"] = "Aktiviere Gruppen für frühere Erweiterungen"	 
   L["Check this if you want to group by prior expansion. Prior expansion group bag labels are light blue."] = "Aktiviere diese Option, wenn du Gegenstände aus früheren Erweiterungen gruppieren möchtest. Die Gruppen aus früheren Erweiterungen werden in der Tasche hellblau angezeigt."	 
   L["Equippable Item Sub-Groupings"] = "Untergruppen für Ausrüstungsteile"	 
   L["Select optional groupings for weapons and armor."] = "Optionale Gruppen für Waffen und Rüstungsteile."	 
   L["Bind on Equip Gear"] = "Beim Anlegen gebundene Gegenstände"	 
   L["Check to group Bind on Equip armor and weapons from prior expansions."] = "Gruppiere beim Anlegen gebundene Rüstungsteile und Waffen aus früheren Erweiterungen."	 
   L["Check to group Soulbound armor and weapons from prior expansions."] = "Gruppiere seelengebundene Rüstungsteile und Waffen aus früheren Erweiterungen."	 
   L["Check to group Legendaries from prior expansions."] = "Gruppiere legendäre Gegenstände aus früheren Erweiterungen."	 
   L["Check to group Artifacts from prior expansions."] = "Gruppiere Artefakte aus früheren Erweiterungen."	 
   L["Check to group cosmetic items like tabards and costumes."] = "Gruppiere kosmetische Gegenstände, wie z.B. Wappenröcke oder Kostüme."	 
   L["Optional miscellaneous item groupings"] = "Optionale Gruppierung für sonstige Gegenstände"	 
   L["Select groupings options for non-gear items."] = "Gruppen für nicht-Ausrüstungsgegenstände."	 
   L["Check to group Trade Goods by category (Herbs, Leather, etc.) from prior expansions."] = "Gruppiere Handwerksmaterialien (Kräuter, Leder, usw.) nach ihrer Kategorie aus früheren Erweiterungen."	 
   L["Food, Drink & Potions"] = "Speis & Trank & Tränke"	 
   L["Check to group Food, Drink, Potions, Elixirs and Flasks from prior expansions."] = "Gruppiere Speis & Trank, Tränke, Elixiere und Fläschchen aus früheren Erweiterungen."	 
   L["Battle Pet Items"] = "Haustierkampfgegenstände"	 
   L["Check to group battle pet items."] = "Gruppiere Gegenstände für Haustierkämpfe."	 
   L["Group Unopened Loot"] = "Gruppiere ungeöffnete Beute"	 
   L["Check to group lockboxes, bonus caches and other loot containers. Yeah, it\'s not expansion related, but it\'s handy!"] = "Gruppiere Schließkassetten und andere Beutebehälter. Ja, es hat nichts mit Erweiterungen zu tun, aber es ist praktisch!"	 
   L["Separate Mount Drops"] = "Trenne Reittiere"	 
   L["Check to group Mounts reins so you don't space if one dropped and keep grinding needlessly."] = "Hebt Reittiere in den Taschen hervor, damit sie leichter gesehen werden."	 
   L["Prior Expansion Groups"] = "TBD"	 
   L["Other Settings"] = "Zusätzliche Einstellungen"	 
   L["Other Prior Expansion filter settings"] = "Zusätzliche Einstellungen für Filter"	 
   L["Colored labels"] = "Farbige Gruppen"	 
   L["Prior Expansion Groups"] = "Gruppen für frühere Erweiterungen"	 
   L["Check to use colored labels for prior expansion tradegoods and consumables."] = "Handwerksmaterialien und Verbrauchsgüter aus vergangenen Erweiterungen werden farbig angezeigt"	 
end	 
----esMX	 
if locale=="esMX" then 	 
   L["BoP"] = "BoP "	 
   L["BoE"] = "BoE "	 
   L["BoA"] = "BoA "	 
   L["Open Me!"] = "¡Ábreme!"	 
   L["Cosmetic"] = "Cosmético"	 
   L["Pet Battle"] = "Batalla de mascotas"	 
   L["Miscellaneous"] = "Diverso"	 
   L["Enable prior expansion groups"] = "Habilitar grupos de expansión anteriores"	 
   L["Check this if you want to group by prior expansion. Prior expansion group bag labels are light blue."] = "Marque esto si desea agrupar por expansión previa. Las etiquetas de bolsas del grupo de expansión anterior son de color azul claro."	 
   L["Equippable Item Sub-Groupings"] = "Subgrupos de artículos equipables"	 
   L["Select optional groupings for weapons and armor."] = "Seleccione agrupaciones opcionales para armas y armaduras."	 
   L["Bind on Equip Gear"] = "Ate en Equipar equipo"	 
   L["Check to group Bind on Equip armor and weapons from prior expansions."] = "Marque para agrupar Vincular en Equipar armaduras y armas de expansiones anteriores."	 
   L["Check to group Soulbound armor and weapons from prior expansions."] = "Marque para agrupar armaduras y armas ligadas al alma de expansiones anteriores."	 
   L["Check to group Legendaries from prior expansions."] = "Marque para agrupar legendarios de expansiones anteriores."	 
   L["Check to group Artifacts from prior expansions."] = "Marque para agrupar artefactos de expansiones anteriores."	 
   L["Check to group cosmetic items like tabards and costumes."] = "Marque para agrupar artículos cosméticos como tabardos y disfraces."	 
   L["Optional miscellaneous item groupings"] = "Grupos opcionales de artículos varios"	 
   L["Select groupings options for non-gear items."] = "Seleccione las opciones de agrupación para los artículos sin engranaje."	 
   L["Check to group Trade Goods by category (Herbs, Leather, etc.) from prior expansions."] = "Marque para agrupar mercancías comerciales por categoría (hierbas, cuero, etc.) de expansiones anteriores."	 
   L["Food, Drink & Potions"] = "Comida, bebida y pociones"	 
   L["Check to group Food, Drink, Potions, Elixirs and Flasks from prior expansions."] = "Marque para agrupar alimentos, bebidas, pociones, elixires y frascos de expansiones anteriores."	 
   L["Battle Pet Items"] = "Artículos de batalla de mascotas"	 
   L["Check to group battle pet items."] = "Marque para agrupar elementos de mascotas de batalla."	 
   L["Group Unopened Loot"] = "Grupo de botín sin abrir"	 
   L["Check to group lockboxes, bonus caches and other loot containers. Yeah, it\'s not expansion related, but it\'s handy!"] = "Marque para agrupar cajas de seguridad, cachés de bonificación y otros contenedores de botín. Sí, no está relacionado con la expansión, ¡pero es útil!"	 
   L["Separate Mount Drops"] = "Gotas de montaje separadas"	 
   L["Check to group Mounts reins so you don't space if one dropped and keep grinding needlessly."] = "Marque para resaltar Monturas para que sean más fáciles de ver en bolsas."	 
   L["Prior Expansion Groups"] = "Grupos de Axpansión anteriores"	 
   L["Prior Expansion Groups"] = "Grupos de Expansión Anteriores"	 
end	 
	
for k,v in pairs(L) do if v == true then L[k] = k end end	
	
addon.arrPetBattle = {	[1] = { itemId=122457, zoneId=14, qty=-1, label="" },--PetBattle: Ultimate Battle-Training Stone
	[2] = { itemId=98715, zoneId=14, qty=-1, label="" },--PetBattle: Marked Flawless Battle-Stone
	[3] = { itemId=116429, zoneId=14, qty=-1, label="" },--PetBattle: Flawless Battle-Training Stone
	[4] = { itemId=127755, zoneId=14, qty=-1, label="" },--PetBattle: Fel-Touched Battle-Training Stone
	[5] = { itemId=92675, zoneId=14, qty=-1, label="" },--PetBattle: Flawless Beast Battle-Stone
	[6] = { itemId=92681, zoneId=14, qty=-1, label="" },--PetBattle: Flawless Undead Battle-Stone
	[7] = { itemId=92677, zoneId=14, qty=-1, label="" },--PetBattle: Flawless Flying Battle-Stone
	[8] = { itemId=92678, zoneId=14, qty=-1, label="" },--PetBattle: Flawless Magic Battle-Stone
	[9] = { itemId=92679, zoneId=14, qty=-1, label="" },--PetBattle: Flawless Aquatic Battle-Stone
	[10] = { itemId=92683, zoneId=14, qty=-1, label="" },--PetBattle: Flawless Dragonkin Battle-Stone
	[11] = { itemId=92680, zoneId=14, qty=-1, label="" },--PetBattle: Flawless Mechanical Battle-Stone
	[12] = { itemId=92676, zoneId=14, qty=-1, label="" },--PetBattle: Flawless Critter Battle-Stone
	[13] = { itemId=116374, zoneId=14, qty=-1, label="" },--PetBattle: Beast Battle-Training Stone
	[14] = { itemId=116424, zoneId=14, qty=-1, label="" },--PetBattle: Aquatic Battle-Training Stone
	[15] = { itemId=92682, zoneId=14, qty=-1, label="" },--PetBattle: Flawless Humanoid Battle-Stone
	[16] = { itemId=116416, zoneId=14, qty=-1, label="" },--PetBattle: Humanoid Battle-Training Stone
	[17] = { itemId=116423, zoneId=14, qty=-1, label="" },--PetBattle: Undead Battle-Training Stone
	[18] = { itemId=116418, zoneId=14, qty=-1, label="" },--PetBattle: Critter Battle-Training Stone
	[19] = { itemId=116419, zoneId=14, qty=-1, label="" },--PetBattle: Dragonkin Battle-Training Stone
	[20] = { itemId=116420, zoneId=14, qty=-1, label="" },--PetBattle: Elemental Battle-Training Stone
	[21] = { itemId=92665, zoneId=14, qty=-1, label="" },--PetBattle: Flawless Elemental Battle-Stone
	[22] = { itemId=137391, zoneId=14, qty=-1, label="" },--PetBattle: Immaculate Aquatic Battle-Stone
	[23] = { itemId=116417, zoneId=14, qty=-1, label="" },--PetBattle: Mechanical Battle-Training Stone
	[24] = { itemId=116421, zoneId=14, qty=-1, label="" },--PetBattle: Flying Battle-Training Stone
	[25] = { itemId=137393, zoneId=14, qty=-1, label="" },--PetBattle: Immaculate Critter Battle-Stone
	[26] = { itemId=116422, zoneId=14, qty=-1, label="" },--PetBattle: Magic Battle-Training Stone
	[27] = { itemId=137387, zoneId=14, qty=-1, label="" },--PetBattle: Immaculate Dragonkin Battle-Stone
	[28] = { itemId=137388, zoneId=14, qty=-1, label="" },--PetBattle: Immaculate Humanoid Battle-Stone
	[29] = { itemId=137390, zoneId=14, qty=-1, label="" },--PetBattle: Immaculate Mechanical Battle-Stone
	[30] = { itemId=137389, zoneId=14, qty=-1, label="" },--PetBattle: Immaculate Undead Battle-Stone
	[31] = { itemId=137392, zoneId=14, qty=-1, label="" },--PetBattle: Immaculate Magic Battle-Stone
	[32] = { itemId=137394, zoneId=14, qty=-1, label="" },--PetBattle: Immaculate Beast Battle-Stone
	[33] = { itemId=137395, zoneId=14, qty=-1, label="" },--PetBattle: Immaculate Elemental Battle-Stone
	[34] = { itemId=137396, zoneId=14, qty=-1, label="" },--PetBattle: Immaculate Flying Battle-Stone
	[35] = { itemId=86143, zoneId=14, qty=-1, label="" },--PetBattle: Pet Battle Bandage
	[36] = { itemId=163036, zoneId=14, qty=-1, label="" }, } --PetBattle: Polished Pet Charm
--	 
addon.maxExpansionIDs = {	 
  [1] = { classID=2, subClassID=-1, expLegion=163873, expBfA=0 },  -- Weapons, 	 
  [2] = { classID=4, subClassID=-1, expLegion=152118, expBfA=0 },  -- Armor, 	 
  [3] = { classID=0, subClassID=1, expLegion=152494, expBfA=0 },  -- Consumables, Potion	 
  [4] = { classID=0, subClassID=2, expLegion=151609, expBfA=0 },  -- Consumables, Elixir	 
  [5] = { classID=0, subClassID=3, expLegion=152638, expBfA=0 },  -- Consumables, Flask	 
  [6] = { classID=0, subClassID=5, expLegion=152592, expBfA=0 },  -- Consumables, Food	 
  [7] = { classID=7, subClassID=9, expLegion=152505, expBfA=0 },  -- Trade Goods, Herb	 
  [8] = { classID=7, subClassID=7, expLegion=152512, expBfA=0 },  -- Trade Goods, Metal & Stone	 
  [9] = { classID=7, subClassID=8, expLegion=152543, expBfA=0 },  -- Trade Goods, Cooking	 
  [10] = { classID=7, subClassID=5, expLegion=152576, expBfA=0 },  -- Trade Goods, Cloth	 
  [11] = { classID=7, subClassID=6, expLegion=152541, expBfA=0 },  -- Trade Goods, Leather	 
  [12] = { classID=7, subClassID=12, expLegion=152875, expBfA=0 },  -- Trade Goods, Enchanting	 
  [13] = { classID=7, subClassID=4, expLegion=153700, expBfA=0 },  -- Trade Goods, Jewelcrafting	 
  [14] = { classID=7, subClassID=-1, expLegion=152668, expBfA=0 },  -- Trade Goods, 	 
  [15] = { classID=8, subClassID=-1, expLegion=153700, expBfA=0 },  -- Item Enhancement, 	 
}	 
-- ZoneID Data	 
addon.arrZoneCodes = {	 
  [1]= { zGroup="Vale", zGroupIds={1530,1570,380,390} },	 
  [2]= { zGroup="Uldum", zGroupIds={1571,249,1527} },	 
  [3]= { zGroup="Vale/Uldum", zGroupIds={1571,249,1527,1530,1570,380} },	 
  [4]= { zGroup="Timeless Isle", zGroupIds={554} },	 
  [5]= { zGroup="Mechagon", zGroupIds={1462} },	 
  [6]= { zGroup="Nazjatar", zGroupIds={1355} },	 
  [7]= { zGroup="BfA Zones", zGroupIds={2161,2162,2160,2156,2103,2158,1504,1462} },	 
  [8]= { zGroup="Horrific Visions", zGroupIds={1469,1470, 1473} },	 
  [9]= { zGroup="Legion Missions", zGroupIds={647,648,626,717,734,735,24,702,695,747,719,831,883,887,726,739} },	 
  [10]= { zGroup="Heart Essence", zGroupIds={1473} },	 
  [11]= { zGroup="Garrison", zGroupIds={582,590,525} },	 
  [12]= { zGroup="REP: Nazjatar", zGroupIds={1355} },	 
  [13]= { zGroup="Reputation", zGroupIds={-1} },	 
  [14]= { zGroup="Pet Battle", zGroupIds={-1} } ,}	 
	
	
	