--[[
AdiBags_PriorExpansions - Seperates items from current expansion from those from prior ones, an addition to Adirelle's fantastic bag addon AdiBags.
Copyright 2019 Ggreg Taylor
All rights reserved.
--]]

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
local L = setmetatable({}, {__index = addon.L})
local setFilter = addon:RegisterFilter("PriorExpansion", 93, 'ABEvent-1.0')
setFilter.uiName = L['Prior Expansion Groups']
setFilter.uiDesc = L['Group previous expansion items together.']

local currMinLevel = 201
local kCategory = 'Prior Expansion'
local kPfx = '|cff00ffff' 
local kPfxColor2 = '|cff4bf442' 
local kSfx = '|r'
local kPfxTradegoods = ''
local Ggbug = false
local debugBagSlot = {1,8}
local lookForId = 133576
local bagItemID
local PRIORITY_ITEM = 'Attention!'
addon:SetCategoryOrder(PRIORITY_ITEM, 81)

local maxExpansionIDs = {
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
  [14] = { classID=7, subClassID=-1, expLegion=153700, expBfA=0 },  -- Trade Goods, 
  [15] = { classID=8, subClassID=-1, expLegion=153700, expBfA=0 },  -- Item Enhancement, 
  }
function Ggprint(...) 
  if lookForId == bagItemID and Ggbug == true then print(...) end
end

local function create()
  local tip, leftTip, rightTip = CreateFrame("GameTooltip"), {}, {}
  for x = 1,6 do
    local L,R = tip:CreateFontString(), tip:CreateFontString()
    L:SetFontObject(GameFontNormal)
    R:SetFontObject(GameFontNormal)
    tip:AddFontStrings(L,R)
    leftTip[x] = L
    rightTip[x] = R
  end
  tip.leftTip = leftTip
  tip.rightTip = rightTip
  return tip
end
local tooltip = tooltip or create()




function setFilter:OnInitialize()
  self.db = addon.db:RegisterNamespace('PriorExpansion', {
    profile = { enable = true ,
    enableMats = true,
    enableBoE = true,
    enableBoP = true,
    enableLegendaries = true,
    enableArtifacts = true,
    enableMats = true,
    enableConsumables = true,
    enableToOpen = true,
    enableMounts = true,
    enableCosmetic = false,
    enablePetGear = false,
    enableColoredLabels = true,
  },
    char = {  },
  })
end
function setFilter:Update()
  self:SendMessage('AdiBags_FiltersChanged')
end
function setFilter:OnEnable()
  addon:UpdateFilters()
end
function setFilter:OnDisable()
  addon:UpdateFilters()
end


function setFilter:GetOptions()
  return {
    enable = {
      name = L['Enable prior expansion groups'],
      desc = L['Check this if you want to group by prior expansion. Prior expansion group bag labels are light blue.'],
      width = 'double',
      type = 'toggle',
      order = 25,
    },
    priorExpansionGear = {
      name = L['Equippable Item Sub-Groupings'],
      type = L['group'],
      inline = true,
      order = 65,
      args = {
        _desc = {
          name = L['Select optional groupings for weapons and armor.'],
          type = 'description',
          order = 10,
        },
        enableBoE = {
          name = L['Bind on Equip Gear'],
          desc = L['Check to group Bind on Equip armor and weapons from prior expansions.'],
          type = 'toggle',
          order = 20,
        },
        enableBoP = {
          name = ITEM_SOULBOUND,
          desc = L['Check to group Soulbound armor and weapons from prior expansions.'],
          type = 'toggle',
          order = 30,
        },
        enableLegendaries = {
          name = ITEM_QUALITY5_DESC,
          desc = L['Check to group Legendaries from prior expansions.'],
          type = 'toggle',
          order = 33,
        },
        enableArtifacts = {
          name = ITEM_QUALITY6_DESC,
          desc = L['Check to group Artifacts from prior expansions.'],
          type = 'toggle',
          order = 40,
        },
        enableCosmetic = {
          name = L['Cosmetic'],
          desc = L['Check to group cosmetic items like tabards and costumes.'],
          type = 'toggle',
          order = 40,
        },
      }
    },
    priorExpansionItems = {
      name = L['Optional miscellaneous item groupings'],
      type = L['group'],
      inline = true,
      order = 65,
      args = {
        _desc = {
          name = L['Select groupings options for non-gear items.'],
          type = 'description',
          order = 10,
        },
        enableMats = {
          name = BAG_FILTER_TRADE_GOODS,
          desc = L['Check to group Trade Goods by category (Herbs, Leather, etc.) from prior expansions.'],
          type = 'toggle',
          order = 33,
        },
        enableConsumables = {
          name = L['Food, Drink & Potions'],
          desc = L['Check to group Food, Drink, Potions, Elixirs and Flasks from prior expansions.'],
          type = 'toggle',
          order = 40,
          
        },
        enablePetGear = {
          name = L['Battle Pet Items'],
          desc = L['Check to group battle pet items.'],
          type = 'toggle',
          order = 45,
          
        },
        
        enableToOpen = {
          name = L['Group Unopened Loot'],
          desc = L['Check to group lockboxes, bonus caches and other loot containers. Yeah, it\'s not expansion related, but it\'s handy!'],
          type = 'toggle',
          order = 50,
        },
        enableMounts = {
          name = L['Separate Mount Drops'],
          desc = L['Check to group Mounts reins so you don\'t space if one dropped and keep grinding needlessly.'],
          type = 'toggle',
          order = 60,
        },
      }
    },
    priorExpansionOtherSettings = {
      name = L['Other Settings'],
      type = L['group'],
      inline = true,
      order = 70,
      args = {
        _desc = {
          name = L['Other Prior Expansion filter settings.'],
          type = 'description',
          order = 10,
        },
        enableColoredLabels = {
          name = kPfx .. L['Colored Labels'] .. kSfx,
          desc = L['Check to use colored labels for prior expansion tradegoods and consumables.'],
          type = 'toggle',
          order = 33,
        },
      }

    },
  }, addon:GetOptionHandler(self, false, function() return self:Update() end)
end

local function isFromPriorExpansion(itemClassID, itemSubClassID, itemId)
  -- compare to maxExpansionIDs array, if itemId less than expLegion # then return true, is prior
  for k, v in pairs(maxExpansionIDs) do
    if v.classID == itemClassID and v.subClassID == itemSubClassID then
      if itemId < v.expLegion then
        return true
      else
        return false
      end
    end
  end
    -- else catch all for parts, elemental, other categories, subClassID -1 indicates check for all other subclasses
  for k, v in pairs(maxExpansionIDs) do
    if v.classID == itemClassID and v.subClassID == -1 then
      if itemId < v.expLegion then
        return true
      else
        return false
      end
    end
  end
  return false
end

function setFilter:Filter(slotData)
  if (self.db.profile.enable == false) or (slotData.itemId == false) then return end
  if self.db.profile.enableColoredLabels == true then kPfxTradegoods = kPfx else kPfxTradegoods = '' end

  local itemLink = GetContainerItemLink(slotData.bag, slotData.slot)
  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, _, _, _, _, itemClassID, itemSubClassID, bindType, expacID, _, isCraftingReagent = GetItemInfo(itemLink)
  local isWeaponOrArmor = false
  if itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR then isWeaponOrArmor = true end
  bagItemID = slotData.itemId
  if not itemMinLevel then itemMinLevel = 0 end

  if self.db.profile.enableMounts and itemType == MISCELLANEOUS and itemSubType == MOUNT  then return  kPfxColor2 ..'EEK!'.. kSfx, PRIORITY_ITEM end
  if self.db.profile.enableLegendaries and itemRarity == 5 and isWeaponOrArmor then  return  kPfx .. ITEM_QUALITY5_DESC.. kSfx, kCategory end --legendaries
  if self.db.profile.enableArtifacts and itemRarity == 6 and isWeaponOrArmor  then  return  kPfx .. ITEM_QUALITY6_DESC.. kSfx, kCategory end --Artifacts
  if self.db.profile.enableMats and itemClassID == LE_ITEM_CLASS_TRADEGOODS and itemSubClassID ~= 16 then -- Don't group old inscription stuff
    if isFromPriorExpansion(itemClassID, itemSubClassID, bagItemID) then return kPfxTradegoods .. '#' .. itemSubType .. kSfx, kCategory end
  end
  if self.db.profile.enableCosmetic and isWeaponOrArmor == true and itemSubClassID == LE_ITEM_ARMOR_COSMETIC then return  'Cosmetic', 'Equipment' end

  --- Groups that require scanning tooltip
  tooltip:SetOwner(UIParent,"ANCHOR_NONE")
  tooltip:ClearLines()
  if slotData.bag == BANK_CONTAINER then
    tooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slotData.slot, nil))
  else
    tooltip:SetBagItem(slotData.bag, slotData.slot)
  end
  tipData = {}
  for x = 1,6 do tipData[x] = {tooltip.leftTip[x]:GetText(), tooltip.rightTip[x]:GetText()} end
  tooltip:Hide()
  tooltip:SetParent(nil)
  -- Pet battle items
  if self.db.profile.enablePetGear and (tipData[2][1] == ITEM_ACCOUNTBOUND or tipData[2][1] == ITEM_BNETACCOUNTBOUND) then
    for x = 1, 6 do
      local bPet = string.find(strupper(tipData[x][1]), 'PET BATTLE') or -1
      local pBattle = string.find(strupper(tipData[x][1]), 'BATTLE PET')  or -1
      if (bpet and bPet > 0) or (pBattle and pBattle > 0) then return  'Pet Battle', MISCELLANEOUS end  
    end
  end  
  -- Filter consumables, put down here because it conflicts with pet items
  if self.db.profile.enableConsumables and (itemClassID==LE_ITEM_CLASS_CONSUMABLE or itemClassID ==LE_ITEM_CLASS_ITEM_ENHANCEMENT) then
    if  isFromPriorExpansion(itemClassID, itemSubClassID, bagItemID) then  return kPfxTradegoods .. '#' .. itemType ..kSfx, kCategory  end 
  end

  for x = 1,6 do
    -- Filter Old BoE Gear
    if self.db.profile.enableBoE and tipData[x][1] == ITEM_BIND_ON_EQUIP and itemLevel < currMinLevel  and isWeaponOrArmor == true then
      return  kPfx .. '#' .. ITEM_BIND_ON_EQUIP .. kSfx, 'Old BoE Gear'
    end
    -- Filter Old BoP Gear
    if self.db.profile.enableBoP and tipData[x][1] == ITEM_SOULBOUND and  isWeaponOrArmor == true and itemLevel < currMinLevel then
      return  kPfx .. '#'.. ITEM_SOULBOUND.. kSfx, 'Old BoP Gear'
    end
    -- Filter Lockboxes
    if self.db.profile.enableToOpen and (tipData[x][1] == ITEM_OPENABLE or tipData[x][1] == LOCKED) then
      return  kPfx ..'Open Me!'.. kSfx, NEW
    end
  end

end
