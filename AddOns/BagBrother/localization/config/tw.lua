--[[
  Chinese Traditional Localization
		***
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'zhTW')
if not L then return end

-- global


-- general
L.GeneralOptionsDesc = '依據你的喜好設定這些一般功能。'
L.Locked = '鎖定視窗'
L.Fading = '淡出效果'
L.TipCount = '滑鼠提示中顯示物品數量追蹤'
L.CountGuild = '包含公會銀行'
L.FlashFind = '閃爍找到的物品'
L.DisplayBlizzard = '用遊戲內建視窗來顯示隱藏背包'
L.DisplayBlizzardTip = '啟用時，隱藏的背包和銀行欄位會使用遊戲預設的暴雪背包介面來顯示。\n\n|cffff1919需要重新載入介面。|r'
L.ConfirmGlobals = '是否確定要停用這個角色的專用設定?\n將會失去全部的專用設定。'
L.CharacterSpecific = '角色專用設定'

-- frame
L.FrameOptions = '視窗設定'
L.FrameOptionsDesc = '分類整合背包視窗的相關設定選項。'
L.Frame = '視窗'
L.Enabled = '啟用視窗'
L.EnabledTip = '停用時，這個視窗會用遊戲預設的暴雪介面來顯示。\n\n|cffff1919需要重新載入介面。|r'
L.ActPanel = '標準面板模式'
L.ActPanelTip = '啟用時，這個面板會自動排列位置就像遊戲內建的版面一樣，例如|cffffffff法術書|r或|cffffffff地城搜尋器|r，並且不能移動。'

L.BagToggle = '更換背包'
L.Money = '金錢'
L.Broker = 'Broker 資訊列外掛'
L.Sort = '排序按鈕'
L.Search = '搜尋切換'
L.Options = '設定選項按鈕'
L.ExclusiveReagent = '材料銀行分開顯示'
L.LeftTabs = '分類標籤頁在左側'
L.LeftTabsTip = '啟用時，側邊的標籤頁會顯示在面板的左側。'

L.Appearance = '外觀'
L.Layer = '圖層'
L.BagBreak = '背包換行顯示'
L.ReverseBags = '背包反向排序'
L.ReverseSlots = '欄位反向排序'

L.Color = '背景顏色'
L.BorderColor = '邊框顏色'

L.Strata = '框架層級'
L.Columns = '直欄'
L.Scale = '縮放大小'
L.ItemScale = '物品縮放大小'
L.Spacing = '間距'
L.Alpha = '透明度'

-- auto display
L.DisplayOptions = '自動顯示'
L.DisplayOptionsDesc = '設定是否要根據遊戲事件自動打開或關閉背包。'
L.DisplayInventory = '顯示背包'
L.CloseInventory = '關閉背包'

L.Auctioneer = '打開拍賣場'
L.Banker = '打開銀行'
L.Combat = '進入戰鬥'
L.Crafting = '製作專業物品'
L.GuildBanker = '打開公會銀行'
L.VoidStorageBanker = '打開虛空倉庫'
L.MailInfo = '打開郵箱'
L.MapFrame = '打開世界地圖'
L.Merchant = '和商人對話'
L.PlayerFrame = '打開角色資訊'
L.ScrappingMachine = '拆掉裝備'
L.Socketing = '鑲嵌裝備'
L.TradePartner = '交易物品'
L.Vehicle = '坐上載具'

-- colors
L.ColorOptions = '顏色設定'
L.ColorOptionsDesc = '更改分類整合背包視窗中的物品欄位如何顯示，以便更容易辨識。'
L.GlowQuality = '顯示物品品質顏色'
L.GlowQuest = '顯示任務物品顏色'
L.GlowUnusable = '顯示無用物品顏色'
L.GlowSets = '顯示裝備設定顏色'
L.GlowNew = '閃爍新的物品'
L.GlowPoor = '標示垃圾物品'
L.GlowAlpha = '顏色發光亮度'

L.EmptySlots = '空欄位顯示背景'
L.SlotBackground = '美術圖案'
L.ColorSlots = '依據背包類型著色空欄位'
L.NormalColor = '一般顏色'
L.QuiverColor = '箭袋顏色'
L.KeyColor = '鑰匙顏色'
L.SoulColor = '靈魂袋顏色'
L.ReagentColor = '材料銀行顏色'
L.LeatherColor = '製皮顏色'
L.InscribeColor = '銘文學顏色'
L.HerbColor = '採草顏色'
L.EnchantColor = '附魔顏色'
L.EngineerColor = '工程學顏色'
L.GemColor = '珠寶顏色'
L.MineColor = '採礦顏色'
L.TackleColor = '工具盒顏色'
L.FridgeColor = '冰箱顏色'

-- rulesets
L.RuleOptions = '物品分類'
L.RuleOptionsDesc = '設定要顯示哪些物品分類和子分類，以及顯示順序 (先勾選的排在前面)。'

L.ADDON = '背包'