--[[
AdiBags_ExpansionGroups - Adds filters by Expansion ID to AdiBags.
Copyright 2019 Ggreg Taylor
All rights reserved.
--]]

local _, ns = ...

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
local L = setmetatable({}, {__index = addon.L})

local currExpansionMinID = 154177
local currExpansionName = 'Battle for Azeroth'
local currExpansionID = 7
local priorMaxLevel = 110
local kMinCloth = 152576
local kMinHerb = 152505
local kMinFood = 152592
local kMinOre = 152512
local kMinLeather = 152541
local kMinEnchanting = 152875
local kMinGems = 153700
local kMinItemEnhancement = 153430
local kMinWeapon = 124525
local kMinArmor = 154177
local kMinPotion = 151609


local kWoW = 1
local kTBC = 2
local kWrath = 3
local kCata = 4
local kMoP = 5
local kLegion = 6
local kBfA = 7

local setKey = {'Expansion ID', 'Expansion Name', 'Tradeskill:Cloth','Tradeskill:Herb', 'Tradeskill:Food','Tradeskill:Metal & Stone','Tradeskill:Leather','Tradeskill:Enchanting','Tradeskill:Jewelcrafting'}
local setWoW = {}


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

-- The filter itself

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
      desc = L['Check this if you want to group by prior expansion.'],
      width = 'double',
      type = 'toggle',
      order = 55,
    },
    priorExpansionGear = {
      name = L['Equippable item sub-groupings'],
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
          desc = L['Check to group Trade Goods from prior expansions.'],
          type = 'toggle',
          order = 33,
        },
        enableConsumables = {
          name = L['Food, Drink & Potions'],
          desc = L['Check to group Food, Drink, and Potions from prior expansions.'],
          type = 'toggle',
          order = 40,
        },
      }
    },
  }, addon:GetOptionHandler(self, false, function() return self:Update() end)
end

function setFilter:Filter(slotData)
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,  itemEquipLoc, itemIcon, itemSellPrice, _, _, bindType, expacID = GetItemInfo(slotData.itemId)

    if (self.db.profile.enable) and (slotData.itemId) then
        if (self.db.profile.enableMats) and (itemType == 'Tradeskill') then
          if (itemSubType == 'Enchanting') and (slotData.itemId < kMinEnchanting) then
              return 'Old Enchanting', 'Prior Expansion'
          elseif itemSubType == 'Herb'  and (slotData.itemId < kMinHerb)then
            return 'Old Herb', 'Prior Expansion'
          elseif (itemSubType == 'Cloth') and (slotData.itemId < kMinCloth) then
            return 'Old Cloth', 'Prior Expansion'
          elseif (itemSubType == 'Leather') and (slotData.itemId < kMinLeather) then 
            return 'Old Leather', 'Prior Expansion'
          elseif (itemSubType == 'Metal & Stone') and (slotData.itemId < kMinOre) then
            return 'Old Metal & Stone', 'Prior Expansion'
          elseif (itemSubType == 'Cooking') and (slotData.itemId < kMinFood) then
            return 'Old Cooking', 'Prior Expansion' 
          elseif (itemSubType == 'Enchanting') and (slotData.itemId < kMinEnchanting) then
            return 'Old Enchanting', 'Prior Expansion'
          elseif (itemSubType == 'Jewelcrafting') and (slotData.itemId < kMinGems) then
            return 'Old Jewelcrafting', 'Prior Expansion'
          elseif (itemSubType == 'Item Enhancement') and (slotData.itemId < kMinItemEnhancement) then
            return 'Old Item Enhancement', 'Prior Expansion'
          end
        elseif  (self.db.profile.enableConsumables)  and (itemType == 'Consumable')  then
            if (itemSubType == 'Food & Drink') and (slotData.itemId < kMinFood)   then
              return 'Old Food & Drink', 'Prior Expansion'
            elseif ((itemSubType == 'Potion') or (itemSubType == 'Flask') or (itemSubType == 'Elixir')) and (slotData.itemId < kMinPotion) then
              return 'Old Potions etc.', 'Prior Expansion'
            end
        elseif (itemType == 'Item Enhancement') and (slotData.itemId < kMinItemEnhancement) then
              return 'Old Item Enhancement', 'Prior Expansion'
        elseif  ((itemType == 'Weapon') or (itemType == 'Armor')) and (bindType) then
            if (itemRarity == 5) and (self.db.profile.enableLegendaries) then --legendaries
              return 'Legendary', 'Prior Expansion'
            elseif (itemRarity == 6) and (self.db.profile.enableArtifacts)  then --Artifacts
              return 'Artifact', 'Prior Expansion'
            -- elseif (self.db.profile.enableBoE) or (self.db.profile.enableBoP) then 
            --   --BOE -- check ilevel, item number, min level
            --   return '^BoE or BoP'
              -------------------
              -------------------
              -------------------
              --- TEMPORARY

            elseif (itemType == 'Weapon') and (slotData.itemId < kMinWeapon) then
              return 'Old Weapon', 'Prior Expansion'
            elseif (itemType == 'Armor') and (slotData.itemId < kMinArmor) then
              return 'Old Armor', 'Prior Expansion'
              -------------------
              -------------------
              -------------------
            end
        end
    end
end

