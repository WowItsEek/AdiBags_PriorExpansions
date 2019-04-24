--[[
AdiBags_ExpansionGroups - Adds grouping by Expansion ID to Adirelle's fantastic bag addon AdiBags.
Copyright 2019 Ggreg Taylor
All rights reserved.
--]]

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
local L = setmetatable({}, {__index = addon.L})

local kMinWeapon = 124525
local kMinArmor = 154177
local kCategory = 'Prior Expansion'
local kPfx = '#'
--array values are category/subcat,minitemid, and if 4th variable replace subcat
local arrItemType = {'Tradeskill:Cloth:152576','Tradeskill:Herb:152505', 'Tradeskill:Food:152592','Tradeskill:Metal & Stone:152512','Tradeskill:Leather:152541','Tradeskill:Enchanting:152875','Tradeskill:Jewelcrafting:153700','Consumable:Potion:151609:Potions etc.','Consumable:Elixir:151609:Potions etc.', 'Consumable:Flask:151609:Potions etc.', 'Consumable:Food & Drink:151609', 'Item Enhancement:Weapon:151609:Item Enhancement'}

local tooltip
local function create()
  local tip, leftside = CreateFrame("GameTooltip"), {}
  for i = 1,6 do
    local L,R = tip:CreateFontString(), tip:CreateFontString()
    L:SetFontObject(GameFontNormal)
    R:SetFontObject(GameFontNormal)
    tip:AddFontStrings(L,R)
    leftside[i] = L
  end
  tip.leftside = leftside
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
          name = L['Select optional groupings for equippable items.'],
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
        -- enableToOpen = {
        --   name = L['Group Unopened Loot.'],
        --   desc = L['Check to group lockboxes, bonus caches and other loot containers. Yeah, it\'s not expansion related, but it\'s handy!'],
        --   type = 'toggle',
        --   order = 50,
        -- },
      }
    },
  }, addon:GetOptionHandler(self, false, function() return self:Update() end)
end

function setFilter:Filter(slotData)
  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,  itemEquipLoc, itemIcon, itemSellPrice, _, _, bindType, expacID = GetItemInfo(slotData.itemId)

  if (self.db.profile.enable == false) or (slotData.itemId == false) then 
    return
  end
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
      if (itemType == currCategory) and (itemSubType == currSubCategory) and (slotData.itemId < tonumber(currMinItemID)) then
          return kPfx .. newSubCategory, kCategory
      end
    elseif (self.db.profile.enableConsumables) and ((currCategory=='Consumable') or (currCategory=='Item Enhancement')) then
      if (itemType == currCategory) and (itemSubType == currSubCategory) and (slotData.itemId < tonumber(currMinItemID)) then
          return kPfx .. newSubCategory, kCategory
      end
    end
  end
  -- End for Category/Subcategory loop from Array
  -- start gear checks
  if  ((itemType == 'Weapon') or (itemType == 'Armor')) then
    if (itemRarity == 5) and (self.db.profile.enableLegendaries) then --legendaries
      return  kPfx .. 'Legendary', kCategory
    elseif (itemRarity == 6) and (self.db.profile.enableArtifacts)  then --Artifacts
      return  kPfx .. 'Artifact', kCategory
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
      -- Loop through item tooltip to check if BoP or Boe
      for i = 1,6 do
        local t = tooltip.leftside[i]:GetText()

        if self.db.profile.enableBoE and t == ITEM_BIND_ON_EQUIP and slotData.itemId < 154177 then
          return  kPfx .. 'BoE', kCategory
        elseif self.db.profile.enableBoP and (t == ITEM_SOULBOUND) and slotData.itemId < 154177 then
          return  kPfx .. 'BoP', kCategory
        -- move outside of armor/weapon if statement
        -- elseif self.db.profile.enableToOpen and (t == ITEM_OPENABLE or t == LOCKED) then
        --   return  'Open Me\!', 'New'
       end
      end
      tooltip:Hide()

    end
  else  
  end
end
