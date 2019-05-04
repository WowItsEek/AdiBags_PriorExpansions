--[[
AdiBags_PriorExpansions - Seperates items from current expansion from those from prior ones, an addition to Adirelle's fantastic bag addon AdiBags.
Copyright 2019 Ggreg Taylor
All rights reserved.
--]]

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
local L = setmetatable({}, {__index = addon.L})

local currMinLevel = 201
local kCategory = 'Prior Expansion'
local kPfx = '#'
--array values are category/subcat,minitemid, and if 4th variable replace subcat
local arrItemType = {'Tradeskill:Cloth:152576','Tradeskill:Herb:152505', 'Tradeskill:Food:152592','Tradeskill:Metal & Stone:152512','Tradeskill:Leather:152541','Tradeskill:Enchanting:152875','Tradeskill:Jewelcrafting:153700','Gem:Gem:153635','Consumable:Potion:151609:Potions etc.','Consumable:Elixir:151609:Potions etc.', 'Consumable:Flask:151609:Potions etc.', 'Consumable:Food & Drink:151609', 'Item Enhancement:Weapon:151609:Item Enhancement'}

local tooltip
local function create()
  local tip, leftTip = CreateFrame("GameTooltip"), {}
  for x = 1,6 do
    local L,R = tip:CreateFontString(), tip:CreateFontString()
    L:SetFontObject(GameFontNormal)
    R:SetFontObject(GameFontNormal)
    tip:AddFontStrings(L,R)
    leftTip[x] = L
  end
  tip.leftTip = leftTip
  return tip
end

local setFilter = addon:RegisterFilter("PriorExpansion", 47, 'ABEvent-1.0')
setFilter.uiName = L['Prior Expansion Groups']
setFilter.uiDesc = L['Group previous expansion items together.']

function setFilter:OnInitialize()
  self.db = addon.db:RegisterNamespace('PriorExpansion', {
    profile = { enable = true },
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

local setNames = {}

function setFilter:GetOptions()
  return {
    enable = {
      name = L['Enable prior expansion groups'],
      desc = L['Check this if you want to group by prior expansion. Prior expansion group bag labels are prefixed with #.'],
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
          name = L['Soulbound Gear'],
          desc = L['Check to group Soulbound armor and weapons from prior expansions.'],
          type = 'toggle',
          order = 30,
        },
        enableLegendaries = {
          name = L['Group Legendaries'],
          desc = L['Check to group Legendaries from prior expansions.'],
          type = 'toggle',
          order = 33,
        },
        enableArtifacts = {
          name = L['Group Artifacts'],
          desc = L['Check to group Artifacts from prior expansions.'],
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
          name = L['Trade Goods'],
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
        enableToOpen = {
          name = L['Group Unopened Loot.'],
          desc = L['Check to group lockboxes, bonus caches and other loot containers. Yeah, it\'s not expansion related, but it\'s handy!'],
          type = 'toggle',
          order = 50,
        },
      }
    },
  }, addon:GetOptionHandler(self, false, function() return self:Update() end)
end


function setFilter:Filter(slotData)
  if (self.db.profile.enable == false) or (slotData.itemId == false) then 
    return
  end
  
  local item = Item:CreateFromBagAndSlot(slotData.bag, slotData.slot)
  local level = item and item:GetCurrentItemLevel() or 0
  local itemName, itemLink, itemRarity, _,_, itemType, itemSubType, _,_,_,_,_,_, bindType, expacID = GetItemInfo(slotData.itemId)

  -- load array category/subcat values
  for x = 1, #arrItemType do
    local currSubset = {}
    local currItemType = arrItemType[x] .. ':'
    local index = 1
    for w in currItemType:gmatch('([^:]+)') do 
      currSubset[index]  = w 
      index = index +1
    end
    currCategory = currSubset[1]
    currSubCategory = currSubset[2]
    currMinItemID = currSubset[3]
    if (currSubset[4]) then
      newSubCategory = currSubset[4]
    else
      newSubCategory = currSubCategory
    end
    if ((self.db.profile.enableMats) and (currCategory=='Tradeskill')) then
      if (itemType == currCategory) 
          and (itemSubType == currSubCategory) 
          and (slotData.itemId < tonumber(currMinItemID)) 
      then
          return kPfx .. newSubCategory, currCategory
      end
    elseif  ((self.db.profile.enableMats) and (currCategory=='Gem')) then
      if (itemType == currCategory) 
          and (slotData.itemId < tonumber(currMinItemID)) 
      then
          return kPfx .. newSubCategory, currCategory
      end
    elseif (self.db.profile.enableConsumables) and ((currCategory=='Consumable') or (currCategory=='Item Enhancement')) then
      if (itemType == currCategory) 
          and (itemSubType == currSubCategory) 
          and (slotData.itemId < tonumber(currMinItemID))
      then
          return kPfx .. newSubCategory, currCategory
      end
    end
  end
  -- End for Category/Subcategory loop from Array
  -- start gear checks
  local isWeaponOrArmor = false
  if (itemType == 'Weapon') or (itemType == 'Armor') then isWeaponOrArmor = true end

  if (self.db.profile.enableLegendaries) and (itemRarity == 5) and (isWeaponOrArmor == true ) then --legendaries
    return  kPfx .. 'Legendary', currCategory
  elseif (self.db.profile.enableArtifacts) and (itemRarity == 6) and (isWeaponOrArmor == true )  then --Artifacts
    return  kPfx .. 'Artifact', currCategory
  -- Blizz's values for soulbound are funky, so have to force scan tooltip
  else      
    tooltip = tooltip or create()
    tooltip:SetOwner(UIParent,"ANCHOR_NONE")
    tooltip:ClearLines()
  
    if slotData.bag == BANK_CONTAINER then
      tooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slotData.slot, nil))
    else
      tooltip:SetBagItem(slotData.bag, slotData.slot)
    end
    -- Loop through item tooltip to check if BoP, Boe, or Unopened
    -- TO ADD: item level difference check
    for x = 1,6 do
      local t = tooltip.leftTip[x]:GetText()
      if self.db.profile.enableBoE and t == ITEM_BIND_ON_EQUIP and level < currMinLevel  and (isWeaponOrArmor == true )then
        return  kPfx .. 'BoE', currCategory
      elseif self.db.profile.enableBoP and (t == ITEM_SOULBOUND) and level < currMinLevel  and (isWeaponOrArmor == true )then
        return  kPfx .. 'BoP', currCategory
      elseif self.db.profile.enableToOpen and (t == ITEM_OPENABLE or t == LOCKED or t == '<Right Click to Open>') 
      then
        return  'Open Me!', 'New'
      end
    end
    tooltip:Hide()
  end
end


