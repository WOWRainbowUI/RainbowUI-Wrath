--[[
	Chinese Traditional Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'zhTW')
if not L then return end

--keybindings
L.ToggleBags = '切換顯示背包'
L.ToggleBank = '切換顯示銀行'
L.ToggleGuild = '切換顯示公會銀行'
L.ToggleVault = '切換顯示虛空倉庫'

--terminal
L.Commands = '指令說明'
L.CmdShowInventory = '切換顯示背包'
L.CmdShowBank = '切換顯示銀行'
L.CmdShowGuild = '切換顯示公會銀行'
L.CmdShowVault = '切換顯示虛空倉庫'
L.CmdShowVersion = '顯示目前版本'
L.CmdShowOptions = '開啟設定選項'
L.Updated = '已更新到 v%s'

--frame titles
L.TitleBags = '%s的背包'
L.TitleBank = '%s的銀行'
L.TitleVault = '%s的虛空倉庫'

--dropdowns
L.TitleFrames = '%s框架'
L.SelectCharacter = '選擇角色'
L.ConfirmDelete = '是否確定要刪除 %s 的快取資料?'

--interactions
L.Click = '點一下'
L.Drag = '<拖曳>'
L.LeftClick = '<左鍵>'
L.RightClick = '<右鍵>'
L.DoubleClick = '<點兩下>'
L.ShiftClick = '<Shift+左鍵>'

--tooltips
L.Total = '總共'
L.GuildFunds = '公會基金'
L.TipGoldOnRealm = '總計 %s'
L.NumWithdraw = '提領 %d'
L.NumDeposit = '存入 %d'
L.NumRemainingWithdrawals = '提領額度剩餘 %d'

--action tooltips
L.TipChangePlayer = '%s 瀏覽另一個角色的物品。'
L.TipCleanItems = '%s 整理物品。'
L.TipConfigure = '%s 設定這個視窗。'
L.TipDepositReagents = '%s 存放所有材料到銀行。'
L.TipDeposit = '%s 存放材料。'
L.TipWithdraw = '%s 提領 (剩餘 %s)。'
L.TipFrameToggle = '%s 顯示其他視窗。'
L.TipHideBag = '%s隱藏這個背包。'
L.TipHideBags = '%s 隱藏背包。'
L.TipHideSearch = '%s 停止搜尋。'
L.TipMove = '%s 移動位置。'
L.TipPurchaseBag = '%s 購買這個銀行欄位。'
L.TipResetPlayer = '%s 返回目前角色。'
L.TipShowBag = '%s顯示這個背包。'
L.TipShowBags = '%s 顯示背包。'
L.TipShowBank = '%s 切換顯示你的銀行。'
L.TipShowInventory = '%s 切換顯示你的背包。'
L.TipShowOptions = '%s 打開設定選項。'
L.TipShowSearch = '%s 搜尋物品。'

--item tooltips
L.TipCountEquip = '已裝備: %d'
L.TipCountBags = '背包: %d'
L.TipCountBank = '銀行: %d'
L.TipCountVault = '虛空銀行: %d'
L.TipCountGuild = '公會: %d'
L.TipDelimiter = '|'

--dialogs
L.AskMafia = 'Ask Mafia'
L.ConfirmTransfer = '存放這些物品將會移除所有寶石和附魔，並且會變成無法交易、無法退回。|n|n是否確定要繼續?'
L.CannotPurchaseVault = '你沒有足夠的金錢來解鎖虛空倉庫的服務。|n|n|cffff2020費用為: %s|r'
L.PurchaseVault = '是否要解鎖虛空倉庫的服務?|n|n|cffffd200費用為:|r %s'

L.ADDON = '背包'
L.DisplaySettings = '自動顯示'