--[[
AdiBags_PriorExpansions - Seperates items from current expansion from those from prior ones, an addition to Adirelle's fantastic bag addon AdiBags.
Copyright 2019 Ggreg Taylor
All rights reserved.
--]]
local addonName, addon = ...
local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")

local L = setmetatable({}, {__index = addon.L})
local setFilter = AdiBags:RegisterFilter("PriorExpansion", 93, 'ABEvent-1.0')
setFilter.uiName = L['Prior Expansion Groups']
setFilter.uiDesc = L['Group previous expansion items together.']

local currMinLevel = 201
local kCategory = L['Prior Expansion']
local kPfx = '|cff00ffff' 
local kPfxColor2 = '|cff4bf442' 
local kSfx = '|r'
local kPfxTradegoods = ''
local Ggbug = false
local debugBagSlot = {1,8}
local lookForId = 86143
local bagItemID
local PRIORITY_ITEM = L['Attention!']
AdiBags:SetCategoryOrder(PRIORITY_ITEM, 81)

local function Ggprint(...) 
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
  self.db = AdiBags.db:RegisterNamespace('PriorExpansion', {
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
  AdiBags:UpdateFilters()
end
function setFilter:OnDisable()
  AdiBags:UpdateFilters()
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
        enableHeirlooms = {
          name = ITEM_QUALITY7_DESC,
          desc = L['Check to group Heirloom items.'],
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
  }, AdiBags:GetOptionHandler(self, false, function() return self:Update() end)
end

local function isFromPriorExpansion(itemClassID, itemSubClassID, itemId)
  -- compare to addon.maxExpansionIDs array, if itemId less than expLegion # then return true, is prior
  for k, v in pairs(addon.maxExpansionIDs) do
    if v.classID == itemClassID and v.subClassID == itemSubClassID then
      if itemId < v.expLegion then
        return true
      else
        return false
      end
    end
  end
    -- else catch all for parts, elemental, other categories, subClassID -1 indicates check for all other subclasses
  for k, v in pairs(addon.maxExpansionIDs) do
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

------------------------------------------------------------------------------
function setFilter:checkItem(itemId, dataArray)
  -- returns zoneId if itemId finds a match in the array otherwise null
  --itemId, zoneId, qty-1, label
  for id, info in pairs(dataArray) do
    if tonumber(itemId) == tonumber(info.itemId) then
      --if qty is a number and matched by item quantity then mark as labeled  
      if GetItemCount(itemId, true) == tonumber(info.qty) then return true, kPfx .. info.label .. kSfx, PRIORITY_ITEM end
   
      local isCurrent, zoneGroup = setFilter:isCurrentZone(info.zoneId) 
      zoneGroup = L[zoneGroup]
      return true, kPfx .. zoneGroup .. kSfx, zoneGroup
    end
  end
  return false, false, false
end

----------------------------------------
function setFilter:isCurrentZone(zoneId)
  for id, info in pairs(addon.arrZoneCodes) do 
    if tonumber(id) == tonumber(zoneId) then 
      for x = 1, #info.zGroupIds do
        if tonumber(info.zGroupIds[x]) == currZoneId then return true, info.zGroup end
      end -- end for x
      return false, info.zGroup 
    end
  end 
end

function setFilter:Filter(slotData)
  if (self.db.profile.enable == false) or (slotData.itemId == false) then return end
  if self.db.profile.enableColoredLabels == true then kPfxTradegoods = kPfx else kPfxTradegoods = '' end
  
  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, _, _, _, _, itemClassID, itemSubClassID, bindType, expacID, _, isCraftingReagent = GetItemInfo(slotData.link)
  local isWeaponOrArmor = false
  local isAzeriteGear = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(slotData.link)
  local isEquipmentSetItem, equipmentSetName = GetContainerItemEquipmentSetInfo(slotData.bag, slotData.slot)
  --[[
  and isEquipmentSetItem == false 
---]]  
  if itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR then isWeaponOrArmor = true end
  bagItemID = slotData.itemId
  if not itemMinLevel then itemMinLevel = 0 end

  if self.db.profile.enableMounts and itemType == MISCELLANEOUS and itemSubType == MOUNT  then return  kPfxColor2 ..'EEK!'.. kSfx, PRIORITY_ITEM end
  -- if it's in an item set don't filter it

  if self.db.profile.enableHeirlooms and isEquipmentSetItem == false and itemRarity == LE_ITEM_QUALITY_HEIRLOOM  then  return  ITEM_QUALITY7_DESC, ITEM_QUALITY7_DESC end --Heirlooms
  if self.db.profile.enableLegendaries and isEquipmentSetItem == false and itemRarity == LE_ITEM_QUALITY_LEGENDARY  and isWeaponOrArmor then  return  ITEM_QUALITY5_DESC, ITEM_QUALITY5_DESC end --legendaries
  if self.db.profile.enableArtifacts and isEquipmentSetItem == false and itemRarity == LE_ITEM_QUALITY_ARTIFACT  and isWeaponOrArmor  then  return  ITEM_QUALITY6_DESC, ITEM_QUALITY6_DESC end --Artifacts
  if self.db.profile.enableMats and itemClassID == LE_ITEM_CLASS_TRADEGOODS and itemSubClassID ~= 16 then -- Don't group old inscription stuff
    if isFromPriorExpansion(itemClassID, itemSubClassID, bagItemID) then return kPfxTradegoods .. '#' .. itemSubType .. kSfx, '#' .. itemSubType end
  end
  if self.db.profile.enablePetGear then -- group Pet Battle items based on IDs from arrPetBattle
    local itemFound, groupLabel, retCategory = setFilter:checkItem(bagItemID, addon.arrPetBattle) 
    if itemFound == true  then return L[groupLabel], retCategory end
  end

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

  if self.db.profile.enableCosmetic then
    if C_Item.GetItemInventoryTypeByID(bagItemID) == 19 or (itemRarity == 1 and itemLevel ==1 and isWeaponOrArmor == true) then return L['Cosmetic'], L['Cosmetic'] end -- 19 is tabardItemType enum
    for x = 1, 6 do
      if tipData[x][2] == L['Cosmetic'] then return L['Cosmetic'], L['Cosmetic'] end
    end
  end  
  -- Filter consumables, put down here because it conflicts with pet items
  if self.db.profile.enableConsumables and (itemClassID==LE_ITEM_CLASS_CONSUMABLE or itemClassID ==LE_ITEM_CLASS_ITEM_ENHANCEMENT) then
    if  isFromPriorExpansion(itemClassID, itemSubClassID, bagItemID) then  return kPfxTradegoods .. '#' .. itemType ..kSfx, '#' .. itemType  end 
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
      return  kPfx ..L['Open Me!'].. kSfx, NEW
    end
  end

end
