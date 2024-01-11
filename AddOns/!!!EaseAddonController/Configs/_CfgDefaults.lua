local _, U1 = ...

local D = {}
U1.CfgDefaults = D
D["!!!gmFonts"] = {
	defaultEnable = 1,
	tags = { "MISC" }, 
	title = "遊戲字體",
	desc = "載入時會自動將遊戲預設的系統、聊天、提示說明和傷害數字，更改為字體材質包中的字體。``可以在設定選項中調整視窗介面文字的字體和大小，其他地方的文字則是在每個插件中分別設定。例如聊天文字在 '聊天視窗美化' 插件設定、玩家和怪頭上的名字在 '威力血條' 設定...等等。``要使用自己的字體，請看問與答`https://addons.miliui.com/wow/rainbowui#q157 ``關閉此插件便可以換回遊戲原本的字體。`",
	modifier = "彩虹ui",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) 
			Settings.OpenToCategory("字體")
		end,
    },
	{
		type = "text",
		text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",
	},
	{
		type = "text",
		text = "|cffFF2D2D特別注意：請不要選擇英文字體，會無法顯示中文字。|r",
	},
};
D["!BugGrabber"] = { 
	defaultEnable = 1,
	optdeps = { "BugSack", },
	protected = true, 
	title = "錯誤收集器",
	desc = "收集錯誤訊息，防止遊戲中斷，訊息會顯示在錯誤訊息袋中。`",
	modifier = "Rabbit, Whyv, zhTW",
	img = true,
};
D["!KalielsTracker"] = {
	defaultEnable = 0,
	title = "任務追蹤清單增強",
	desc = "增強畫面右方任務追蹤清單的功能。在設定選項中可以調整位置和文字大小。`",
	modifier = "BNS, 彩虹ui",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["KALIELSTRACKER"]("config") end,
    },
	{
		type = "text",
		text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",
	},
};
D["D4KiR Healer Protection"] = {
	defaultEnable = 0,
	tags = { "CLASSALL" },
	title = "救救奶媽",
	desc = "法力過低或被怪打時自動在隊伍頻道發話讓隊友知道，推薦補師使用，可以少打很多字哦!``在設定選項中可以自訂何時要發話，以及要顯示哪些文字。`",
	modifier = "彩虹ui",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame_OpenToCategory("救救奶媽")
			InterfaceOptionsFrame_OpenToCategory("救救奶媽")
		end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
};
D["Accountant_Classic"] = {
	defaultEnable = 1,
	title = "個人會計",
	desc = "追蹤每個角色的所有收入與支出狀況，並可顯示當日小計、當週小計、以及自有記錄起的總計。並可顯示所有角色的總金額。`",
	modifier = "arith, 彩虹ui",
	img = true,
	{
        text = "顯示/隱藏個人會計",
        callback = function(cfg, v, loading) AccountantClassic_ButtonOnClick() end,
    },
    {
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame_OpenToCategory("個人會計")
			InterfaceOptionsFrame_OpenToCategory("個人會計")
		end,
    },
	{
		type = "text",
		text = "點小地圖按鈕的 '個人會計' 按鈕也可以開啟主視窗。",
	}
};
D["ActionCam"] = {
	defaultEnable = 1,
	tags = { "MISC" },
	title = "微動感鏡頭",
	desc = "登入時自動啟用遊戲內建的動作鏡頭功能，角色稍微偏下、加大前方的視野、畫面不會晃動。``要恢復讓角色置中，取消載入這個插件，重新載入介面後在詢問實驗性功能的對話框按 '關閉' 即可。`",
	modifier = "彩虹ui",
};
D["ActionCamPlus"] = {
	defaultEnable = 0,
	tags = { "MISC" },
	title = "動感鏡頭 Plus",
	desc = "啟用遊戲內建的動作鏡頭功能，有多種不同的鏡頭效果可供調整。``像是會記憶騎乘坐騎的鏡頭距離，下坐騎後便會自動恢復。或是記憶戰鬥中的鏡頭距離，戰鬥結束後便會自動恢復。``如果想要更像家機般的遊玩感受，請在設定選項中啟用 '動感鏡頭' 和 '上下調整鏡頭'`",
	modifier = "彩虹ui",
	icon = "Interface\\Icons\\ability_racial_soar",
    {
        text = "開/關動感鏡頭",
        callback = function(cfg, v, loading) SlashCmdList["ACTIONCAMPLUS"]("") end,
    },
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ACTIONCAMPLUS"]("h") end,
    },
};
D["AdiBags"] = {
	defaultEnable = 1,
	tags = { "ITEM" },
	title = "Adi 背包",
	desc = "會自動分類物品的整合背包，預設有多種分類，可以自訂分類，也可以安裝外掛套件增加新的分類。``如果你喜歡一個不分類的大背包，打開背包 > 在背包視窗內的空白處點右鍵 > 過濾方式 > 把每一個分類的 '啟用' 都分別取消打勾即可。`",
	modifier = "arithmandar, BNS, mccma, sheahoi, yunrong81, 彩虹ui",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_ADIBAGS"]("") end,
    },
	{
		type = "text",
        text = "在背包視窗內的空白處點一下滑鼠右鍵也可以打開設定選項。\n",       
	},
};
D["AdvancedInterfaceOptions"] = {
	defaultEnable = 0,
	tags = { "MISC" },
	title = "進階介面選項",
	desc = "軍臨天下版本移除了一些遊戲內建的介面選項，這個插件除了讓你可以使用這些被移除的介面選項，還可以瀏覽和設定 CVar 遊戲參數，以及更多遊戲設定。`",
	modifier = "BNS, 彩虹ui",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["AIO"]("") end,
    },
	{
		type = "text",
        text = "自己的戰鬥文字捲動：請改在 Esc > 選項 > 戰鬥 > 允許浮動戰鬥文字，勾選/取消勾選。\n\n鏡頭最遠距離：調整前請先關閉功能百寶箱裡面的 '最大鏡頭縮放'。\n",       
	},
};
D["alaCalendar"] = {
	defaultEnable = 0,
	tags = { "BOSSRAID" },
	title = "行事曆和副本進度",
	desc = "在經典版中提供行事曆的功能，顯示副本重置和節日活動的時間。``也能夠顯示同帳號中所有角色的副本進度，方便查看每個角色是否打過哪個副本。`",
	author = "ALA @ 网易有爱",
	modifier = "ALA, 彩虹ui",
	{
        text = "顯示行事曆",
        callback = function(cfg, v, loading) SlashCmdList["ALACALENDAR"]("calendar") end,
    },
	{
        text = "顯示副本進度",
        callback = function(cfg, v, loading) SlashCmdList["ALACALENDAR"]("board") end,
    },	
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ALACALENDAR"]("") end,
    },
	{
		type = "text",
        text = "以下這幾種方式都可以打開行事曆和副本進度:\n\n1.點畫面最下方中間的時間。\n(需要載入 '功能資訊列' 插件)\n\n2.點小地圖按鈕的 '行事曆' 按鈕。\n\n3.點小地圖旁的白天/夜晚按鈕。\n(需要在性感小地圖的設定 > 按鈕 > 顯示白天/夜晚指示 > 滑鼠指向時，打勾。)\n",       
	},
};
D["Align"] = {
	defaultEnable = 0,
	tags = { "MISC" },
	title = "對齊網格",
	desc = "顯示調整UI時方便用來對齊位置的網格線。`",
	--icon = "Interface\\Icons\\inv_misc_net_01",
	img = true,
    {
        text = "32x32 網格",
        callback = function(cfg, v, loading) SlashCmdList["TOGGLEGRID"]("32") end,
    },
	{
        text = "64x64 網格",
        callback = function(cfg, v, loading) SlashCmdList["TOGGLEGRID"]("64") end,
    },
	{
        text = "128x128 網格",
        callback = function(cfg, v, loading) SlashCmdList["TOGGLEGRID"]("128") end,
    },
	{
        text = "256x256 網格",
        callback = function(cfg, v, loading) SlashCmdList["TOGGLEGRID"]("256") end,
    },
	{
		type = "text",
        text = "按一下顯示，再按一下隱藏網格。\n",       
	},
};
D["Atlas"] = {
	defaultEnable = 0,
	title = "副本地圖",
	desc = "瀏覽觀看副本內的地圖。`",
    {
        text = "顯示主視窗",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_ATLAS"]("") end,
    },
	{
        text = "設定選項",
        callback = function(cfg, v, loading) Atlas:OpenOptions() end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
		type = "text",
        text = "點小地圖按鈕的 'Atlas 副本地圖' 按鈕也可以開啟主視窗。\n\n",       
	},
};
D["AtlasLootClassic"] = {
	defaultEnable = 0,
	tags = { "ITEM" },
	title = "副本戰利品查詢",
	desc = "顯示首領與小怪可能掉落的物品，並可查詢各陣營與戰場的獎勵物品、套裝物品等資訊。`",
	modifier = "arith, BNS, Daviesh, jerry99spkk, Proteyer, scars377, sheahoi, soso15, Whyv, ytzyt, zhTW, 彩虹ui",
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ATLASLOOT"]("options") end,
    },
	{
        text = "顯示戰利品查詢",
        callback = function(cfg, v, loading) SlashCmdList["ATLASLOOT"]("") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
		type = "text",
        text = "點小地圖按鈕的 '副本戰利品查詢' 按鈕也可以開啟主視窗。\n\n",       
	},
};
D["ArenaScreenshot"] = {
	defaultEnable = 0,
	tags = { "PVP" },
	title = "敵方目標警報",
	desc = "競技場被集火提示。",
	modifier = "彩虹ui",
    {
		type = "text",
        text = "此UI不需要設定\n由麻也魔改版本。",
    },
};
D["Auctionator"] = {
	defaultEnable = 1,
	title = "拍賣小幫手",
	desc = "一個輕量級的插件，增強拍賣場的功能，方便快速的購買、銷售和管理拍賣。`",
	modifier = "BNS, borjamacare, 彩虹ui",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame_OpenToCategory("拍賣")
			InterfaceOptionsFrame_OpenToCategory("拍賣")
			InterfaceOptionsFrame_OpenToCategory("基本設定")
		end,
    },
	{
		type = "text",
		text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",
	},
};
D["AutoBarWrath"] = {
	defaultEnable = 0,
	tags = { "ACTIONBAR" },
	title = "自動快捷列",
	desc = "自動產生各種分門別類的快捷列以方便使用，例如消耗品、飾品、圖騰、各類技能的快捷列。``|cffFF2D2D為了避免自動產生出太多按鈕讓畫面很亂，請務必在設定選項中自行勾選要顯示哪些快捷列和按鈕。|r`",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_AUTOBAR"]("config") end,
    },
};
D["AutoCrop"] = {
	defaultEnable = 1,
	tags = { "ITEM" },
	title = "自動馬鞭",
	desc = "上坐騎時自動裝備騎乘馬鞭，下坐騎時自動恢復原飾品。`",
	{
		type = "text",
		text = "移動圖示：按住 Alt 鍵拖曳移動圖示。",
	},
};
D["BattleGroundEnemies"] = {
	defaultEnable = 0,
	tags = { "PVP" },
	title = "戰場目標框架",
	desc = "戰場專用的敵方單位框架，可以監控敵人的血量、減益效果、控場遞減...等等多種狀態。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\achievement_pvp_h_08",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["BattleGroundEnemies"]("") end,
    },
	{
		type = "text",
		text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",
	},
};
D["BattleInfo"] = {
	defaultEnable = 0,
	tags = { "PVP" },
	title = "戰場資訊增強",
	desc = "提供更多實用的戰場資訊和功能。`",
	modifier = "彩虹ui",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["BATTLEINFO"]("") end,
    },
};
D["BagSync"] = {
	defaultEnable = 1,
	title = "物品數量統計",
	desc = "在物品的滑鼠提示中顯示所有角色擁有相同物品的數量。``|cffFF2D2D需要將其他角色登入一次才會計算該角色的物品數量。|r`",
	modifier = "BNS, 彩虹ui",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_BAGSYNC"]("config") end,
    },
	{
        text = "搜尋",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_BAGSYNC"]("search") end,
    },
	{
        text = "金錢",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_BAGSYNC"]("gold") end,
    },
	{
        text = "黑名單",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_BAGSYNC"]("blacklist") end,
    },
	{
        text = "優化資料庫",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_BAGSYNC"]("fixdb") end,
    },
	{
        text = "重置資料庫",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_BAGSYNC"]("resetdb") end,
    },
	{
        text = "刪除角色資料",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_BAGSYNC"]("profiles") end,
    },
};
D["BiaoGe"] = {
    defaultEnable = 0,
	tags = { "BOSSRAID" },
	title = "金團表格",
	desc = "好用的金團記錄表單，可與金團帳本等金團拍賣插件一起使用，可設定心願清單，可以通報帳單流拍或消費及欠款，加入團隊時還可連通 WCL 插件回報加入者的分數裝等。``還有冰冠城塞的攻略可以看!`",
    {
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
        text = "顯示主視窗",
        callback = function(cfg, v, loading) SlashCmdList["BIAOGE"]("") end,
    },
	{
        text = "調整通知位置",
        callback = function(cfg, v, loading) SlashCmdList["BIAOGEMOVE"]("") end,
    },
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["BIAOGEOPTIONS"]("") end,
    },
};
D["BigDebuffs"] = {
    defaultEnable = 0,
	title = "大型控場圖示",
	desc = "放大控制技能的減益圖示，更容易看到。`",
	modifier = "Kokusho",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame_OpenToCategory("PvP 控場圖示")
			InterfaceOptionsFrame_OpenToCategory("PvP 控場圖示")
		end,
    },
};
D["BlockMessageTeamGuard"] = {
    defaultEnable = 1,
	tags = { "SOCIAL" },
	title = "廣告守衛",
	desc = "過濾掉聊天訊息中的廣告、自動拒絕陌生人的組隊邀請，讓你有個乾淨舒服的遊戲環境。``可以自訂關鍵字，還有更多功能。",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["BlockMessageTeamGuard"]("") end,
    },
};
D["Breakables"] = {
    defaultEnable = 0,
	title = "快速分解物品",
	desc = "提供快速拆裝分解、研磨草藥、勘探寶石和開鎖的功能!``有你的專業可以分解的物品時，畫面上會自動出現可供分解物品的分解快捷列，點一下物品圖示即可分解，不用到背包中去尋找物品。`",
	modifier = "alec65, BNS, HouMuYi, 彩虹ui",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame_OpenToCategory("專業-分解")
			InterfaceOptionsFrame_OpenToCategory("專業-分解")
		end,
    },
	{
		type = "text",
        text = "分解物品：左鍵點一下分解快捷列上的物品圖示。\n\n加入忽略清單：右鍵點一下分解快捷列上的物品圖示。\n\n在設定選項中可以管理忽略清單。\n\n移動快捷列：Shift+左鍵 拖曳移動。\n",
	},
};
D["BugSack"] = {
	defaultEnable = 1,
	parent = "!BugGrabber",
	protected = true,
	{
        text = "查看錯誤訊息",
        callback = function(cfg, v, loading) SlashCmdList["BugSack"]("show") end,
    },
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["BugSack"]("") end,
    },
	{
		type = "text",
		text = "點小地圖按鈕的 '紅色小袋子' 也可以查看錯誤訊息。"
	}
};
D["ButtonForge"] = {
	defaultEnable = 0,
	title = "更多快捷列",
	desc = "快捷列不夠用嗎?``讓你可以打造出更多的快捷列和按鈕。要幾個、要擺哪裡都可以隨意搭配。``還可以使用巨集指令來控制何時要顯示/隱藏快捷列。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\inv_misc_food_dimsum",
	img = true,
	{
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame_OpenToCategory("快捷列-更多")
			InterfaceOptionsFrame_OpenToCategory("快捷列-更多")
		end,
    },
	{
		type = "text",
        text = "建立快捷列：在設定選項中開啟更多快捷列工具來建立。\n\n也可以在 Esc > 選項 > 按鍵綁定 > 插件 > 更多快捷列，綁定一個快速鍵來切換顯示更多快捷列工具。\n",
	},
	{
        text = "按鈕間距",
		type = "spin",
		range = {0, 20, 1},
		default	= 6,
        callback = function(cfg, v, loading) SlashCmdList["BUTTONFORGE"]("-gap "..v) end,
    },
};
D["BuyEmAllClassic"] = {
	defaultEnable = 1,
	tags = { "AUCTION" },
	title = "大量購買",
	desc = "在商人視窗按 Shift+左鍵 點一下物品可一次購買一組或最大數量。`",
	--icon = "Interface\\Icons\\inv_misc_coin_02",
	img = true,
};
D["CastCursor"] = {
	defaultEnable = 0,
	tags = { "MISC" },
	title = "滑鼠游標施法條",
	desc = "在滑鼠游標的周圍顯示圓形的施法條，還可以顯示 GCD。方便在戰鬥中觀看施法條、找到滑鼠的位置。`",
	modifier = "彩虹ui",
	-- --icon = "Interface\\Icons\\achievement_halloween_smiley_01",
	-- img = true,
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["CASTCURSOR"]("") end,
    },
};
D["ccc"] = {
	defaultEnable = 0,
	tags = { "COMBAT" },
	title = "控場監控",
	desc = "控場監控計時條。",
	modifier = "由麻也, 彩虹ui",
	{
        text = "解鎖移動",
        callback = function(cfg, v, loading) SlashCmdList["CCC"]("unlock") end,
    },
	{
        text = "鎖定位置",
        callback = function(cfg, v, loading) SlashCmdList["CCC"]("lock") end,
    },
	{
        text = "反向顯示",
        callback = function(cfg, v, loading) SlashCmdList["CCC"]("invert") end,
    },
	{
        type = "radio",
		text = "延伸方向",
		options = {
			"往上","up",
			"往下","down",
		},
        callback = function(cfg, v, loading) SlashCmdList["CCC"]("growth "..v) end,
    },
	{
        type = "spin",
		text = "縮放大小",
		range = {0.5, 3, 0.1},
		default = 1,
        callback = function(cfg, v, loading) SlashCmdList["CCC"]("scale "..v) end,
    },
	{
        type = "spin",
		text = "透明度",
		range = {0, 1, 0.1},
		default = 1,
        callback = function(cfg, v, loading) SlashCmdList["CCC"]("alpha "..v) end,
    },
	{
        type = "radio",
		text = "監控對象",
		options = {
			"當前目標","target",
			"全部","all",
		},
        callback = function(cfg, v, loading) SlashCmdList["CCC"]("aoe "..v) end,
    },
	{
		type = "text",
        text = "輸入 /ccc ignore 名字\n來忽略指定的名字，再輸入一次可取消忽略。|r",
	},
	{
        text = "顯示忽略名單",
        callback = function(cfg, v, loading) SlashCmdList["CCC"]("ignore") end,
    },
};
D["CharacterStatsTBC"] = {
	defaultEnable = 0,
	tags = { "ENHANCEMENT" },
	title = "角色視窗詳細屬性",
	desc = "在角色視窗的屬性欄顯示更多、更詳細的屬性。``可使用下拉選單來切換近戰、遠程、法術、防禦...等不同類型的屬性。",
	{
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame:Show()
			InterfaceOptionsFrame_OpenToCategory("角色屬性")
			InterfaceOptionsFrame_OpenToCategory("角色屬性")
		end,
    },
};
D["Cell"] = {
	defaultEnable = 0,
	tags = { "BOSSRAID" },
	title = "團隊框架 (Cell)",
	desc = "簡單好用又美觀的團隊框架，載入即可使用，幾乎不用設定。``有提供自訂外觀、增益/減益圖示和其他功能。對於補師，還有滑鼠點一下快速施法的功能。`",
	modifier = "BSN, 彩虹ui",
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["CELL"]("options") end,
    },
	{
        text = "重置位置",
        callback = function(cfg, v, loading) SlashCmdList["CELL"]("resetposition") end,
    },
	{
        text = "恢復為預設值",
        callback = function(cfg, v, loading) SlashCmdList["CELL"]("resetall") end,
    },
};
D["ChatBar Classic"] = {
	defaultEnable = 0,
	tags = { "SOCIAL" },
	title = "聊天頻道按鈕",
	desc = "在聊天視窗上方顯示一排能夠快速切換聊天頻道的按鈕列。`",
	{
        text = "重置位置",
        callback = function() ChatBar_Reset() end,
    },
	{
		type = "text",
		text = "移動位置：在按鈕列的最左端或最右端用滑鼠左鍵拖曳。\n\n設定選項：在按鈕列的最左端或最右端點滑鼠右鍵，開啟設定選單。\n",
	},
};
D["ChatWheel"] = {
	defaultEnable = 0,
	tags = { "SOCIAL" },
	title = "快速發話環",
	desc = "按下設定好的快速鍵後，會顯示一圈定型語，點一下即可快速發話，節省打字的時間，打副本特別好用。`",
	modifier = "BNS, 彩虹ui",
	--icon = "Interface\\Icons\\spell_holy_circleofrenewal",
	-- img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame_OpenToCategory("聊天-快速發話")
			InterfaceOptionsFrame_OpenToCategory("聊天-快速發話")
		end,
    },
	{
		type = "text",
		text = "開始使用：先在設定選項中設定好快速鍵。\n\n快速發話：按一下快速鍵，用滑鼠點預先設定好的定型語。\n\n取消發話：點滑鼠右鍵。\n\n更改發話內容：在設定選項中修改目前設定檔的內容 (定型語)。\n\n定型語格式為：\n環形選單文字-聊天發話的內容\n\n每組選單文字和發話內容單獨一行，最多 8 組。也可以儲存成多個不同的設定檔，方便不同的場合切換使用。\n",
	},
};
D["ClassicAuraDurations"] = {
	defaultEnable = 0,
	tags = { "UNITFRAME" },
	title = "頭像光環時間",
	desc = "計算光環的持續時間，並且讓目標頭像下方和團隊框架上面的增益/減益效果圖示可以顯示倒數時間的轉圈動畫效果。``|cffFF2D2D要顯示倒數時間數字，需要同時載入 '冷卻時間' 插件。|r`",
	modifier = "彩虹ui",
	{
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame:Show()
			InterfaceOptionsFrame:Show()
			InterfaceOptionsFrame_OpenToCategory("頭像-光環時間")
			InterfaceOptionsFrame_OpenToCategory("頭像-光環時間")
		end,
    },
};
D["ClassicCastbars"] = {
	defaultEnable = 0,
	tags = { "COMBAT" },
	title = "目標/隊友施法條",
	desc = "在目標頭像框架下方顯示目標的施法條，也有提供隊友的施法條。``|cffFF2D2D注意：在經典版中暴雪沒有提供這個功能，所以目標唱法時間是用估計的，不是非常精準，但已足夠讓你知道目標唱什麼法術，是否該斷法或爐石。`|r",
	modifier = "Asukachikaru, 彩虹ui",
	-- --icon = "Interface\\Icons\\ability_paladin_beaconoflight",
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["CLASSICCASTBARS"]("") end,
    },
};
D["ClassicSpellActivations"] = {
	defaultEnable = 1,
	tags = { "ACTIONBAR" },
	title = "技能發光 (快捷列)",
	desc = "技能觸發時快捷列上的技能圖示會發光。``目前支援戰士、聖騎士、盜賊、獵人和術士的特定幾個技能。`|r",
};
D["ColorPickerPlus"] = {
	defaultEnable = 1,
	tags = { "ENHANCEMENT" },
	title = "顏色選擇器 Plus",
	desc = "提供更方便的方式來選擇顏色，可以輸入顏色數值、直接選擇職業顏色，或是將自訂顏色儲存成色票供日後使用。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\achievement_doublerainbow",
	img = true,
	{
        type = "text",
		text = "選擇顏色時會自動出現。",
    },
};
D["Combuctor"] = {
	defaultEnable = 0,
	tags = { "ITEM" },
	title = "分類整合背包",
	desc = "將所有背包顯示在同一個視窗中，並且提供分類標籤頁面的功能，方便尋找物品。``還有離線銀行，能夠隨時查看其他角色的背包和銀行。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\inv_tailoring_hexweavebag",
	img = true,
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["Combuctor"]("options") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。\n\nDJ 智能分類背包和分類整合背包選擇其中一種使用即可，請勿同時載入。|r\n",
	},
	{
		type = "text",
        text = "整理背包: 點背包視窗右上角的圖示。\n\n調整背包視窗大小: 拖曳背包視窗最右下角。\n\n切換成其他角色的背包: 點背包視窗左上角的人物頭像圖案。",
	},
	{
		type = "text",
        text = " ",
	},
};
D["CopyAnything"] = {
    defaultEnable = 1,
	tags = { "SOCIAL" },
	title = "快速複製文字",
	desc = "快速複製任何框架上面的文字!``聊天視窗中的文字、隊伍框架上面的隊友名字、選取目標框架上面的怪物名字，甚至是設定選項、插件名稱都能複製。``|cffFF2D2D將滑鼠指向要複製的文字，然後連按兩次 Ctrl+C 就複製好了! ``特別注意：使用前必須先將快速鍵設為 Ctrl+C，詳細請點上方的齒輪圖示標籤頁看用法說明。|r`",
	modifier = "彩虹ui",
	{
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame_OpenToCategory("複製文字")
			InterfaceOptionsFrame_OpenToCategory("複製文字")
		end,
    },
	{
		type = "text",
		text = "使用方法：\n\n1.先在 Esc > 選項 > 按鍵綁定 > 插件 > 顯示複製文字，設定快速鍵 (建議設為 Ctrl+C)。\n\n2.將滑鼠指向要複製的文字，按下快速鍵 (例如 Ctrl+C)。\n\n3.在彈出的視窗中拖曳滑鼠選取要複製的文字，按下 Ctrl+C 來複製文字。複製成功視窗會自動關閉。\n\n4.在要貼上文字的地方，例如聊天視窗的輸入框，按下 Ctrl+V 貼上文字。\n",
	},
	{
		type = "text",
		text = "|cffFF2D2D小技巧：滑鼠指向文字後，連按兩次 Ctrl+C 會直接快速複製整段文字。|r\n",
	},
};
D["DBM-StatusBarTimers"] = {
    defaultEnable = 1,
	title = "<DBM> 首領技能警報",
	desc = "提供地城/團隊副本首領的技能提醒、倒數計時條和警報功能。``小女孩快跑! 是打團必備的插件。`",
	--icon = [[Interface\Icons\INV_Helmet_06]],
	img = true,
    tags = { "BOSSRAID" },
    {
        text = "測試計時條",
        callback = function(cfg, v, loading) DBM:DemoMode() end,
    },
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["DEADLYBOSSMODS"]("") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
		type = "text",
		text = "中文語音：輸入 /dbm > 選項 > 語音警告，右邊第五個下拉選單\n'設置語音警告的語音包' 選擇 '安格斯'。\n\n移動計時條：輸入 /dbm > 選項 > 計時條樣式 > 移動。\n\n開啟/關閉大型計時條：輸入 /dbm > 選項 > 計時條樣式 > (內容往下捲) 開啟大型計時條。",
	},
	{
		type = "text",
		text = " ",
	},
};
D["DBM-CountPack-Overwatch"] = {defaultEnable = 1,};
D["DBM-VPSaha"] = {defaultEnable = 1,};
D["DBM-VPSahaJh"] = {defaultEnable = 1,};
D["Decursive"] = {
	defaultEnable = 0,
	tags = { "CLASSALL" },
	title = "一鍵驅散",
	desc = "每個隊友會顯示成一個小方格，當隊友獲得 Debuff (負面狀態效果) 時，小方格會亮起來。``點一下亮起來的小方格，立即驅散。``設定選項中還可以設定進階過濾和優先權。`",
	modifier = "Adavak, Archarodim, BNS, deleted_1214024, laincat, sheahoi, titanium0107, YuiFAN, zhTW, 彩虹ui",
	--icon = "Interface\\Icons\\spell_nature_purge",
	img = true,
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_DECURSIVE"]("") end,
    },
	{
        type = "text",
		text = "驅散 Debuff：點一下亮起來的小方格。\n\n移動格子：滑鼠指向第一個小方格的上方 (不是上面)，出現小亮點時按住 Alt 來拖曳移動。\n\n中 Debuff 的玩家清單：在設定選項中開啟或關閉 '即時清單'。",
    },
};
D["Details"] = {
	defaultEnable = 0,
	title = "Details! 戰鬥統計/仇恨值",
	desc = "可以看自己和隊友的DPS、HPS...等模組化的傷害統計資訊，還有仇恨值表和各種好用的戰鬥分析工具和外掛套件。`",
	modifier = "BNS, Fang2hou, kxd0116 , lohipp, sheahoi, Whyv, 彩虹ui",
	-- --icon = "Interface\\Icons\\spell_nature_purge",
	{
        text = "顯示/隱藏主視窗",
        callback = function(cfg, v, loading) SlashCmdList["DETAILS"]("toggle") end,
    },
	{
        text = "開啟/關閉同步資料",
        callback = function(cfg, v, loading) SlashCmdList["DETAILS"]("sync") end,
    },
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["DETAILS"]("config") end,
    },
	{
        text = "重置設定/重新安裝",
        callback = function(cfg, v, loading) SlashCmdList["DETAILS"]("reinstall") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D第一次打勾載入插件不需要重新載入介面，之後若有取消再載入插件都需要重新載入介面。|r",       
	},
	{
        type = "text",
		text = "切換顯示傷害/治療或其他統計：右鍵點戰鬥統計視窗標題。\n\n切換顯示整體/單次傷害：滑鼠指向戰鬥統計視窗右上方的文件圖示。\n\n切換顯示書籤：右鍵點戰鬥統計視窗內容。\n\n開新視窗：滑鼠指向戰鬥統計視窗右上方的小齒輪 > 視窗控制 > 建立視窗。\n\n顯示仇恨值：滑鼠指向戰鬥統計視窗右上方的小齒輪 (不要點它) > 外掛套件：團隊 > Tiny Threat。建議開一個新視窗來專門顯示仇恨表。\n\n|cffFF2D2D要顯示其他人的仇恨值，對方也需要安裝並更新到最新版本的 Details! 戰鬥統計插件。|r\n\n修正距離太遠 (超過50碼) 看不到 DPS 的問題：按下上方的 '開啟/關閉同步資料' 按鈕，或是輸入\n /details sync\n",
    },
};
D["djbags"] = {
	defaultEnable = 0,
	title = "DJ 智能分類背包",
	desc = "精簡小巧、時尚又美觀的背包。會自動分類物品，也能自訂分類的整合背包。",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\inv_misc_bag_25_mooncloth",
	img = true,
	{
		type = "text",
        text = "|cffFF2D2DDJ智能分類背包和整合背包選擇其中一種使用即可，請勿同時載入。|r\n",
	},
	{
        type = "text",
		text = "自訂分類：按住 Alt 鍵點背包中的物品。\n\n重新堆疊物品：點背包視窗下方的清理背包小圖示。\n\n顯示兌換通貨：滑鼠指向背包視窗下方的金額。\n\n更換背包：點背包視窗最右下角的小圓圈。\n\n設定選項/更改背包寬度：點背包視窗最右下角的小圖示。\n",
    },
};
D["Dominos"] = {
	defaultEnable = 1,
	title = "達美樂快捷列",
	desc = "用來取代遊戲內建的主要快捷列，提供方便的快捷列配置、快速鍵設定，讓你可以自由安排快捷列的位置和大小，以及多種自訂功能。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\ability_ensnare",
	img = true,
	{
        text = "設定快捷列",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_DOMINOS"]("config") end,
    },
	{
        text = "設定快速鍵",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_DOMINOS"]("bind") end,
    },
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_DOMINOS"]("") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
		type = "text",
		text = "點小地圖按鈕的 '達美樂快捷列' 按鈕也可以開啟設定。\n\n經驗/榮譽/聲望/艾澤萊晶岩條：滑鼠點幾下經驗條來切換顯示。\n\n額外快捷鍵：如果遇到無法移動的額外快捷鍵，請試試將圖示拖曳到快捷列上擺放，或是載入 '版面配置' 插件來移動它。\n\n增益和減益效果：已改為使用 '我的增益/減益效果' 插件來調整。\n\n更多詳細用法和說明請看：\nhttp://wp.me/p7DTni-e1",
	},
	{
		type = "text",
		text = " ",
	}
};
D["Dominos_Cast"] = { defaultEnable = 0, };
D["Dominos_Roll"] = { defaultEnable = 0, };
D["Drift"] = {
	defaultEnable = 1,
	tags = { "ENHANCEMENT" }, 
	title = "移動和縮放視窗",
	desc = "允許自由拖曳移動和縮放遊戲內建的各種視窗，並且會保存位置，就算登出登入後位置也不會跑掉。``如果怕不小心移動到，可以在設定選項中勾選鎖定移動和鎖定縮放，並且設定需要按住的按鍵，才能拖曳/縮放。`",
	modifier = "彩虹ui",
	{
        text = "設定選項",
		callback = function(cfg, v, loading)
			InterfaceOptionsFrame_OpenToCategory("移動視窗")
			InterfaceOptionsFrame_OpenToCategory("移動視窗")
			InterfaceOptionsFrame_OpenToCategory("選項")
		end,
    },
	{
		type = "text",
		text = "移動視窗: 按住左鍵拖曳視窗標題，或拖曳視窗內沒有功能的地方來移動位置。\n\n縮放視窗: 按住右鍵往上或往下拖曳來縮放視窗大小。\n",
	},
};
D["DruidBarClassic"] = {
	defaultEnable = 0,
	tags = { "CLASSALL" }, 
	title = "德魯伊法力條",
	desc = "顯示一個額外的法力條，在熊和貓形態時也能看到法力。`",
	author = "Tek",
	modifier = "彩虹ui",
	{
        text = "設定選項",
        callback = function(cfg, v, loading)
			if SlashCmdList["DRUIDBARSLASH"] then
				SlashCmdList["DRUIDBARSLASH"]("")
			else
				local _, className = UnitClass("player");
				if className and className ~= "DRUID" then
					print("你不是德魯伊!")
				end
			end 
		end,
    },
};
D["EasyConversion"] = {
	defaultEnable = 0,
	tags = { "SOCIAL" }, 
	title = "聊天文字簡轉繁",
	desc = "將聊天視窗中的簡體字轉換成繁體，看起來更輕鬆，溝通無障礙!``如果你不太習慣看簡體字，可以使用這個插件。``|cffFF2D2D特別注意：只會轉換聊天視窗中的文字，其他任何地方的文字都不會轉換，玩家名字也不會轉換。|r`",
	icon = "Interface\\Icons\\ability_evoker_innatemagic5",
};
D["EasyFrames"] = {
	defaultEnable = 1,
	title = "暴雪頭像 (美化調整)",
	desc = "喜愛遊戲內建的頭像推薦使用這個插件，讓內建頭像變得更漂亮，還額外提供了許多自訂化的選項。``建議搭配 '暴雪頭像 (增強功能)' 插件一起使用。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\achievement_leader_tyrande_whisperwind",
	img = true,
    {
        text = "設定選項",
		callback = function(cfg, v, loading) 
			SlashCmdList["ACECONSOLE_EASYFRAMES"]("")
			InterfaceOptionsFrame_OpenToCategory("隊伍")
			InterfaceOptionsFrame_OpenToCategory("頭像-美化")
		end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
		type = "text",
        text = "|cffFF2D2D使用 '暴雪頭像' 插件時，請千萬不要啟用 '功能百寶箱 > 框架相關' 裡面的管理框架面版、框架職業染色、職業圖示頭像和顯示玩家邊框...等功能，以避免發生衝突，導致頭像框架不正常。|r",
	},
	{
		type = "text",
        text = "|cffFF2D2D和 '暴雪頭像 (增強功能)' 插件一起使用時，有些設定是在 '暴雪頭像 (增強功能)' 調整，例如 3D 頭像、目標的目標、隊友血量/法力文字和隊友/寵物的目標等。|r",
	},
	{
		type = "text",
        text = "顯示血量數字和百分比：按 Esc > 介面 > 顯示 > 狀態文字 > 選擇 '數值'，然後便可以在暴雪頭像 (美化調整) 的設定選項中調整血量條文字格式。\n\n分兩邊顯示血量數字和百分比：按 Esc > 介面 > 顯示 > 狀態文字 > 選擇 '兩者'，此方式無法在暴雪頭像 (美化調整) 的設定選項中調整文字格式。\n",
	},
};
D["EnableEquipmentSelect"] = {
	defaultEnable = 1,
	tags = { "ITEM" },
	title = "快速選裝",
	desc = "打開角色視窗時，按住 Alt 鍵，便可以點裝備欄位旁的箭頭，快速選擇不同的裝備換上。`",
};
D["EnhBloodlust"] = {
	defaultEnable = 1,
	tags = { "COMBAT" },
	title = "嗜血音樂",
	desc = "為嗜血和英勇效果添加超棒的音樂。`",
	--icon = "Interface\\Icons\\spell_nature_bloodlust",
	img = true,
	{
        text = "測試音樂",
        callback = function(cfg, v, loading) SlashCmdList["ENHBLOODLUST"]("") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D需要進入戰鬥中再開嗜血才有音樂，非戰鬥中開嗜血沒有音樂。|r\n\n測試音樂則不需要進入戰鬥，任何職業都可以測試音樂。\n\n音樂中斷的解決方法請看\nhttp://bit.ly/wowsoundfix",       
	},
	{
		type = "text",
		text = "調整音量：從 Esc > 系統 > 音效，調整遊戲的主音量。\n\n自訂音樂：將長度為40秒的 MP3 或 OGG 音樂檔案放到 AddOns\\EnhBloodlust 資料夾內。然後用記事本或 Notepad++ 開啟 hawayconfig.lua，依照裡面的說明來修改。\n\n更詳細的說明請看\nhttp://wp.me/p7DTni-Fp \n",
	}
};
D["ExtendedVendorLite"] = {
	defaultEnable = 0,
	tags = { "AUCTION" },
	title = "(請刪除) 商人介面加大",
	desc = "已改用 '商人介面增強' 插件，請刪除 AddOns 裡面的 ExtendedVendorLite 資料夾。`",
};
D["ExRT"] = {
	defaultEnable = 0,
	title = "MRT 合併 ExRT 舊資料",
	desc = "ExRT 團隊工具包已經改名為 MRT 團隊工具包，這個插件現在只是用來將 ExRT 的舊資料合併到 MRT 裡面，如果沒有需要合併舊的記錄，可以不用載入。`",
	--icon = "Interface\\AddOns\\MRT\\media\\OptionLogom4",
};
D["ExtVendorUI_Classic"] = {
	defaultEnable = 1,
	tags = { "AUCTION" },
	title = "商人介面增強",
	desc = "和 NPC 交易時會加大商人的購物視窗，可以用滑鼠滾輪來換頁。提供多種過濾方式，過濾已經學會、已經購買過、不能使用的物品、裝備部位、塑形外觀...等等。``也有快速賣垃圾和不要的物品功能，並且可以自訂要賣出和不要賣出的物品清單。``|cffFF2D2D這個插件不會自動賣垃圾，需要手動按一下快速賣出按鈕。要使用自動賣垃圾請在 '功能百寶箱' 的設定選項中開啟/關閉。|r`",
	modifier = "BNS, 彩虹ui",
	--icon = "Interface\\Icons\\inv_misc_coin_16",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["EXTVENDOR"]("") end,
    },
	{
		type = "text",
		text = "快速賣出垃圾: 在商人視窗中點左上角的按鈕。\n\n管理垃圾清單: 在商人視窗中選擇 過濾方式 > 快速賣出設定，管理要賣出和不要賣出的物品清單。\n\n自動修裝、自動賣垃圾: 在功能百寶箱裡面設定。\n",
	}
};
D["Favorites"] = {
	defaultEnable = 0,
	tags = { "SOCIAL" },
	title = "最愛好友名單",
	desc = "在遊戲內建的好友名單中新增 '加入最愛' 和 '搜尋好友' 的功能。還可以自訂多個不同的群組，幫好友名單分類。``|cffFF2D2D注意：加入最愛和分組的功能只支援 BattleTag 好友，不支援伺服器內的角色好友。|r`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\achievement_guildperk_everybodysfriend",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_FAVORITES"]("") end,
    },
	{
		type = "text",
		text = "加入/移除最愛：按 O 開啟好友名單，在好友的名字上點右鍵 > 加入最愛。\n\n新增/移除群組：在設定選項中設定。",
	}
};
D["FishingBuddy"] = {
	defaultEnable = 0,
	title = "釣魚夥伴",
	desc = "幫忙處理釣魚的相關工作、漁具、魚類資訊...等等。也會增強釣魚音效和支援滑鼠點擊甩竿。`",
	modifier = "alec65, Andyca, icearea, machihchung, smartdavislin, Sutorix, titanium0107, zhTW, 彩虹ui",
	--icon = "Interface\\Icons\\inv_misc_fish_74",
    {
        text = "顯示主視窗",
        callback = function(cfg, v, loading) SlashCmdList["fishingbuddy"]("") end,
    },
	{
		type = "text",
		text = "點小地圖按鈕的 '釣魚夥伴' 按鈕也可以開啟主視窗。",
	}
};
D["FriendListColors"] = {
	defaultEnable = 1,
	tags = { "SOCIAL" },
	title = "彩色好友名單",
	desc = "有好友的人生是彩色的!``好友名單顯示職業顏色，還可以自訂要顯示哪些內容。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\achievement_doublerainbow",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame_OpenToCategory("好友名單")
			InterfaceOptionsFrame_OpenToCategory("好友名單")
		end,
    },
	{
		type = "text",
        text = "使用方法：按 O 開啟好友名單。",       
	},
};
D["FocusInterruptSounds"] = {
	defaultEnable = 0,
	tags = { "CLASSALL" },
	title = "斷法提醒和通報",
	desc = "你的敵對目標開始施放可以中斷的法術時，會有語音提醒快打斷。``成功打斷時會在聊天視窗顯示訊息告知你的隊友，可以自行設定其他要提醒打斷和不要提醒的法術。``PvE 和 PvP 都適用哦！`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\spell_arcane_arcane04",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame_OpenToCategory("斷法")
			InterfaceOptionsFrame_OpenToCategory("斷法")
		end,
    },
	{
		type = "text",
        text = "開始使用：在設定選項 > 玩家斷法技能，加入自己職業的斷法技能名稱，刪除其他的。",       
	},
};
D["GatherMate2"] = {
	defaultEnable = 0,
	tags = { "PROFESSION" },
	title = "採集助手",
	desc = "採草、挖礦、釣魚的好幫手。``收集草、礦、考古學、寶藏和釣魚的位置，在世界地圖和小地圖上顯示採集點的位置。`",
	modifier = "alpha2009, arith, BNS, chenyuli, ibmibmibm, icearea, jerry99spkk, kagaro, laxgenius, machihchung, morphlings, scars377, sheahoi, soso15, titanium0107, wxx011, zhTW",
	--icon = "Interface\\Icons\\inv_herbalism_70_starlightrosepetals",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["GatherMate2"]("") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
};
D["Gladdy"] = {
	defaultEnable = 0,
	tags = { "PVP" },
	title = "競技場目標框架",
	desc = "競技場專用目標框架，提供友方和敵方框架以及更多功能。",
	--icon = "Interface\\Icons\\achievement_pvp_h_15",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["GLADDY"]("ui") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
};
D["GladiatorlosSA2"] = {
	defaultEnable = 0,
	tags = { "PVP" },
	title = "敵方技能監控 (語音)",
	desc = "用語音報出敵方玩家正在施放的技能。`",
	--icon = "Interface\\Icons\\achievement_pvp_h_15",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_GLADIATORLOSSA"]("gui") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
};
D["GroupCalendar"] = {
	defaultEnable = 0,
	tags = { "BOSSRAID" },
	title = "公會行事曆",
	desc = "公會活動專用的行事曆，公會會長或授權的人員可以用來建立和管理活動，公會成員則能瀏覽和主動報名公會的活動。``可以和 '行事曆和副本進度' 插件同時使用。``|cffFF2D2D注意：必須是同一個公會，並且都有載入這個插件，才能瀏覽和報名活動。|r`",
	author = "LantisNT, saruman2340",
    {
        text = "顯示公會行事曆",
        callback = function(cfg, v, loading) SlashCmdList["CALENDAR"]("") end,
    },
	{
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame_OpenToCategory("公會行事曆")
			InterfaceOptionsFrame_OpenToCategory("公會行事曆")
		end,
    },
	{
		type = "text",
		text = "點小地圖按鈕的 '公會行事曆' 按鈕也可以開啟主視窗。\n",
	},
};
D["GladiusEx"] = {
	defaultEnable = 0,
	title = "競技場頭像Ex",
	desc = "加強版的競技場專用單位框架，提供友方和敵方框架以及更多功能。`",
	author = "slaren, vendethiel64928",
	modifier = "HouMuYi, jyzjl, 彩虹ui",
	icon = "Interface\\Icons\\achievement_pvp_h_12",
	img = true,
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["GLADIUSEX"]("ui") end,
    },
	{
        text = "顯示測試框架",
        callback = function(cfg, v, loading) SlashCmdList["GLADIUSEX"]("test 3") end,
    },
	{
        text = "隱藏測試框架",
        callback = function(cfg, v, loading) SlashCmdList["GLADIUSEX"]("hide") end,
    },    
	{
        text = "恢復為預設值",
        callback = function(cfg, v, loading) SlashCmdList["GLADIUSEX"]("reset") end,
    },
	{
		type = "text",
        text = "滑鼠點擊框架設為目標/專注目標的功能，可以在設定選項 > 競技場 (或隊伍) > 滑鼠點擊 > 啟用組件，開啟。\n\n|cffFF2D2D特別注意：如果開啟後遇到無法旋轉畫面的問題，將滑鼠點擊功能關閉即可。|r\n",       
	},
};
D["Glass"] = {
	defaultEnable = 1,
	tags = { "SOCIAL" }, 
	title = "聊天視窗美化",
	desc = "極簡風格的聊天視窗，會自動淡出聊天文字，讓你更能沉浸在遊戲中，並且提供更多的選項來自訂聊天視窗。``|cffFF2D2D特別注意：使用此插件時請關閉 '功能百寶箱' 插件裡面的 '聊天功能 > 聊天視窗' 底下的相關選項，以避免功能衝突而發生錯誤。|r`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\inv_gizmo_adamantiteframe",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_GLASS"]("") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
		type = "text",
        text = "右鍵點一下聊天視窗上方的 '綜合' 標籤頁 > 設定視窗外觀，也可以打開聊天視窗美化的設定選項。|r",       
	},
	{
		type = "text",
		text = "移動聊天視窗：右鍵點一下 '綜合' 標籤頁 > 解鎖視窗。\n\n聊天視窗大小：在設定選項中更改寬度和高度的數值。\n\n聊天文字大小：在設定選項 > 聊天內容，更改文字大小。\n\n複製聊天內容：按住 Ctrl 鍵點一下要複製的聊天視窗標籤頁，便可在新開的小視窗中拖曳滑鼠來選取文字，按 Ctrl+C 複製，然後按 Ctrl+V 貼上文字。\n\n複製聊天內容需要啟用 '功能百寶箱' 插件裡面的 '聊天功能 > 聊天視窗 > 最近聊天視窗' 選項。\n",
	},
};
D["GTFO"] = {
	defaultEnable = 1,
	tags = { "COMBAT" }, 
	title = "地板傷害警報",
	desc = "你快死了! 麻煩神走位!``踩在會受到傷害的區域上面時會發出警報聲，趕快離開吧!``受到傷害愈嚴重警報聲音愈大，設定選項中可以調整音量。`",
	modifier = "Andyca, BNS, wowuicn, Zensunim",
	--icon = "Interface\\Icons\\spell_fire_volcano",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["GTFO"]("options") end,
    },
};
D["GW2_UI"] = {
	defaultEnable = 0,
	tags = { "ENHANCEMENT" },
	title = "GW2 UI (激戰2)",
	desc = "一個經過精心設計，用來替換魔獸世界原本的遊戲介面。讓你可以聚焦在需要專注的地方，心無旁騖地盡情遊戲。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\pet_type_dragon",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["GWSLASH"]("") end,
    },
};
D["HandyNotes"] = {
	defaultEnable = 1,
	title = "地圖標記",
	desc = "在地圖上提供方便的標註功能。``搭配相關模組一起使用時，可以在地圖上顯示寶箱、稀有怪...的位置。`",
	modifier = "Sprider @巴哈姆特, BNS, Charlie, 彩虹ui",
	--icon = "Interface\\Icons\\inv_misc_map_01",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_HANDYNOTES"]("gui") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
		type = "text",
        text = "如果覺得地圖上的圖示太多太亂，可以在設定選項中關閉不想看到的特定圖示。\n",       
	},
};
D["HealBot"] = {
    defaultEnable = 0,
	tags = { "CLASSALL" },
	title = "智能治療",
	desc = "用來取代隊伍/團隊框架，滑鼠點一下就能快速施放法術/補血，是補師的好朋友!`` 可以自訂框架的外觀，提供治療、驅散、施放增益效果、使用飾品、距離檢查和仇恨提示的功能。`",
	--icon = "Interface\\Icons\\petbattle_health",
	img = true,
	{
        text = "啟用/停用",
        callback = function(cfg, v, loading) SlashCmdList["HEALBOT"]("t") end,
    },
	{
        text = "小隊樣式",
        callback = function(cfg, v, loading) SlashCmdList["HEALBOT"]("skin Group") end,
    },
	{
        text = "團隊樣式",
        callback = function(cfg, v, loading) SlashCmdList["HEALBOT"]("skin Raid") end,
    },
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["HEALBOT"]("") end,
    },
};
D["HidingBar"] = {
	defaultEnable = 1,
	tags = { "MAP" },
	title = "小地圖按鈕選單",
	desc = "將小地圖周圍的按鈕，整合成一個彈出式按鈕選單!``可以自訂按鈕選單的位置、樣式，選擇要收入哪些按鈕、啟用/停用按鈕、重新排列按鈕，還可以建立多個選單將按鈕分組。自訂性很高!`",
	modifier = "BNS, sfmict, terry1314, 彩虹ui",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["HIDDINGBAR"]("") end,
    },
};
D["Immersion"] = {
    defaultEnable = 0,
	title = "任務對話 (說話的頭)",
	desc = "與NPC對話、接受/交回任務時，會使用遊戲內建 '說話的頭' 風格的對話方式，取代傳統的任務說明。``讓你更能享受並融入任務內容的對話劇情。``|cffFF2D2D任務對話 (FF XIV)、任務對話 (說話的頭) 和任務對話 (電影風格) 選擇其中一種使用即可，請勿同時載入使用。|r`",
	author = "MunkDev",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\achievement_leader_sylvanas",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["IMMERSION"]("") end,
    },
	{
		type = "text",
        text = "鍵盤操作方式：\n\n繼續下一步、接受/交回任務：\n滑鼠或空白鍵。\n\n選擇對話項目：1~9 數字鍵。\n\n回上一步：倒退鍵。\n\n取消對話：Esc 鍵。\n",
	},
	{
		type = "text",
        text = "移動位置：從設定選項 > 綜合 > 鎖定框架位置 > 將 '模型/文字' 取消打勾，即可用滑鼠拖曳移動 NPC 的對話視窗。\n\n移動對話選項：直接使用滑鼠拖曳移動。\n\n移動遊戲內建說話的頭：從設定選項 > 綜合 > 整合說話的頭框架 > 將 '已啟用' 打勾。說話的頭便會和插件的位置一起移動。",
	},
};
D["InstanceAchievementTracker"] = {
    defaultEnable = 0,
	tags = { "COLLECTION" },
	title = "副本成就追蹤",
	desc = "副本中的成就條件達成或失敗時，會在聊天視窗顯示提醒。``也有提供相關的戰術、成就解法。`",
	icon = "Interface\\Icons\\ACHIEVEMENT_GUILDPERK_MRPOPULARITY",
	img = true,
    {
        text = "顯示主視窗",
        callback = function(cfg, v, loading) SlashCmdList["IAT"]("") end,
    },
	{
		type = "text",
        text = "點小地圖按鈕的 '副本成就追蹤' 按鈕也可以打開主視窗。",
    },
};
D["InterruptedIn"] = {
	defaultEnable = 0,
	tags = { "MISC" },
	title = "巨集指令 /iin",
	desc = "讓你可以使用 /iin 指令製作具有時間性的發話巨集，具備中斷發話的功能。``例如開怪倒數巨集：`/iin stop`/stopmacro [btn:2]`/pull 5`/iin 0 大家注意要開怪啦 >>%T<<`/iin 1 4...`/iin 2 3...`/iin 3 2...偷爆發`/iin 4 1...`/iin 5 上!!!`/iin start``中斷倒數巨集：`/iin stop`/pull 0`/iin 0 >>>已中斷!!!<<<`/iin start``分裝倒數巨集：`/iin stop`/stopmacro [btn:2]`/iin 0.1 %L 倒數開始囉，要的骰！`/iin 5 5...`/iin 6 4...`/iin 7 3...`/iin 8 2...`/iin 9 1...`/iin 10 0!!!`/iin start``詳細說明和更多範例請看`https://goo.gl/yN2S5n`",
	author = "永恆滿月",
	--icon = "Interface\\Icons\\spell_holy_borrowedtime",
	img = true,
};
D["Leatrix_Maps"] = {
    defaultEnable = 1,
	tags = { "MAP" },
	title = "世界地圖增強",
	desc = "讓大地圖視窗化，可自由移動位置和調整大小。還有顯示未探索區域、副本入口、區域等級和坐標...等功能。`",
	modifier = "BNS, 彩虹ui",
	-- --icon = "Interface\\Icons\\inv_gizmo_hardenedadamantitetube",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["Leatrix_Maps"]("") end,
    },
	{
		type = "text",
        text = "移動地圖位置：拖曳地圖四周的邊框。\n\n縮放地圖內容大小：在地圖上捲動滑鼠滾輪。\n\n調整地圖視窗大小：拖曳地圖視窗最右下角。\n\n顯示選擇地區的下拉選單：在設定選項中取消勾選 '移除地圖邊框'，然後重新載入介面。\n",
    },
};
D["Leatrix_Plus"] = {
    defaultEnable = 1,
	tags = { "ENHANCEMENT" },
	title = "功能百寶箱",
	desc = "讓生活更美好的插件，提供多種各式各樣的遊戲功能設定。``包括自動修裝、自動賣垃圾、加大鏡頭最遠距離...還有更多功能!",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\inv_gizmo_hardenedadamantitetube",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["Leatrix_Plus"]("") end,
    },
	{
		type = "text",
        text = "點小地圖按鈕的 '功能百寶箱' 按鈕，也可以開啟主視窗。\n\n自動修裝和自動賣垃圾：在功能百寶箱的設定選項中啟用。\n",
    },
};
D["LFGBulletinBoard"] = {
    defaultEnable = 1,
	tags = { "BOSSRAID" },
	title = "組隊佈告欄",
	desc = "將尋求組隊訊息依據副本，難度…等規則分類，就像勇者接受委託的佈告欄一樣!``特別注意：預設只會顯示燃燒的遠征副本，如果需要顯示60級以下的經典版副本，需要在設定選項中勾選。`",
	modifier = "由麻也, 彩虹ui",
    {
        text = "顯示佈告欄",
        callback = function(cfg, v, loading) SlashCmdList["LFGBulletinBoard"]("") end,
    },
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["LFGBulletinBoard"]("config") end,
    },
	{
        text = "重置視窗",
        callback = function(cfg, v, loading) SlashCmdList["LFGBulletinBoard"]("reset") end,
    },
	{
		type = "text",
        text = "點小地圖按鈕的 '組隊佈告欄' 按鈕，或是點聊天頻道按鈕的 '佈' 按鈕，也可以打開組隊佈告欄。\n",       
	},
};
D["LiteButtonAuras"] = {
    defaultEnable = 1,
	tags = { "ACTIONBAR" },
	title = "光環時間 (快捷列)",
	desc = "直接在快捷列的技能圖示上面顯示增益和減益效果的時間，方便監控。``對敵方目標施放的 DOT 會顯示紅色邊框，自己身上的 HOT/BUFF 會顯示綠色邊框。`",
	modifier = "彩虹ui",
	{
        text = "時間數字大小",
		type = "spin",
		range = {6, 60, 1},
		default	= 16,
        callback = function(cfg, v, loading) SlashCmdList["LiteButtonAuras"]("font default "..v.." THICKOUTLINE") end,
    },
	{
        text = "/lba 指令說明",
        callback = function(cfg, v, loading) SlashCmdList["LiteButtonAuras"]("help") end,
    },
	{
        text = "光環設定說明",
        callback = function(cfg, v, loading) SlashCmdList["LiteButtonAuras"]("aura help") end,
    },
	{
        text = "不顯示時間設定說明",
        callback = function(cfg, v, loading) SlashCmdList["LiteButtonAuras"]("deny help") end,
    },
};
D["LootMonitor"] = {
    defaultEnable = 0,
	tags = { "BOSSRAID" },
	title = "進本/摸屍體/拾取監控",
	desc = "可以看到誰先進本、誰第一個摸屍體，也會記錄誰拿了什麼裝備。``團隊和5人副本都可以使用。",
	modifier = "彩虹ui",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["LMC"]("") end,
    },
	{
        text = "顯示拾取記錄",
        callback = function(cfg, v, loading) SlashCmdList["LMC"]("lootlog") end,
    },
};
D["ls_Toasts"] = {
    defaultEnable = 1,
	tags = { "ENHANCEMENT" },
	title = "通知面板增強",
	desc = "可以完全自訂彈出式通知面板，移動位置、調整大小、選擇要顯示哪些通知，還有更多自訂選項。``選擇自己想看的通知，讓彈出的通知不會再擋住快捷列或重要的畫面。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\inv_misc_food_100",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["LSTOASTS"]("") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
};
D["MailLogger"] = {
    defaultEnable = 1,
	tags = { "AUCTION" },
	title = "交易通知/記錄",
	desc = "自動記錄與玩家交易，以及郵件的物品內容。方便查看交易歷史記錄。`",
	modifier = "Aoikaze, 彩虹ui",
	--icon = "Interface\\Icons\\inv_misc_food_36",
	-- img = true,
	{
        text = "顯示交易記錄",
        callback = function(cfg, v, loading) SlashCmdList["MLC"]("all") end,
    },
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["MLC"]("gui") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
};
D["Masque"] = {
    defaultEnable = 0,
	tags = { "ACTIONBAR" },
	title = "按鈕外觀",
	desc = "讓你可以變換快捷列按鈕和多種插件的按鈕外觀樣式，讓遊戲介面更具風格!``有許多外觀主題可供選擇。`",
	modifier = "a9012456, Adavak, BNS, chenyuli, StormFX, yunrong, zhTW, 彩虹ui",
	--icon = "Interface\\Icons\\inv_misc_food_36",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["MASQUE"]("") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
};
D["MBB"] = {
    defaultEnable = 0,
	title = "小地圖按鈕選單 (舊版)",
	desc = "將小地圖周圍的按鈕，整合成一個彈出式按鈕選單!`",
    {
        text = "重置按鈕位置",
        callback = function(cfg, v, loading) SlashCmdList["MBB"]("reset position") end,
    },
	{
        text = "恢復為預設值",
        callback = function(cfg, v, loading) SlashCmdList["MBB"]("reset all") end,
    },
	{
		type = "text",
        text = "無法重置的話請重新載入後再試",
    },
	{
		type = "text",
        text = "左鍵：展開按鈕選單。\n\n拖曳：移動位置。\n\n右鍵：設定選項。\n\nCtrl+右鍵：與小地圖分離或結合。",
    },
	
};
D["MeepMerp"] = {
	defaultEnable = 1,
	tags = { "COMBAT" },
	title = "超出法術範圍音效",
	desc = "距離過遠、超出法術可以施放的範圍時會發出「咕嚕嚕嚕～」的音效來提醒。`",
	--icon = "Interface\\Icons\\highmaulraid_range_far",
	img = true,
	{
		type = "text",
        text = "自訂音效：將聲音檔案 (MP3 或 OGG) 複製到 AddOns\\MeepMerp 資料夾裡面，然後用記事本編輯 MeepMerp.lua，將音效檔案位置和檔名那一行裡面的 Bonk.ogg 修改為新的聲音檔案名稱，要記得加上副檔名 .mp3 或 .ogg。\n\n更改完成後要重新啟動遊戲才會生效，重新載入無效。\n",
    },
};
D["MissingRaidBuffs"] = {
    defaultEnable = 0,
	tags = { "BOSSRAID" },
	title = "增益缺失監看",
	desc = "增益缺失監看，智力、耐力、精神、爪子，讓你非常直覺快速的看到缺少增益的人，讓你可以快速地幫死掉的人補上增益。",
	--icon = "Interface\\Icons\\ability_warrior_challange",
	img = true,
    {
        text = "設定選項",
		callback = function(cfg, v, loading) 
			InterfaceOptionsFrame_OpenToCategory("增益缺失監看")
			InterfaceOptionsFrame_OpenToCategory("增益缺失監看")
		end,
	},
};
D["MikScrollingBattleText"] = {
    defaultEnable = 0,
	tags = { "COMBAT" },
	title = "MSBT捲動戰鬥文字",
	desc = "讓打怪的傷害數字和系統訊息，整齊的在角色周圍捲動。``可以自訂顯示的位置、大小和要顯示哪些戰鬥文字。`",
	--icon = "Interface\\Icons\\ability_warrior_challange",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["MSBT"]("") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D注意：載入這個插件時會無法在戰鬥中打開背包。|r",       
	},
};
D["Molinari"] = {
    defaultEnable = 0,
	title = "一鍵分解物品",
	desc = "提供快速拆裝分解、研磨草藥、勘探寶石和開鎖的功能!``只要按下 Ctrl+Alt 鍵再點一下背包中物品，立馬分解!``設定選項中可以將要避免不小心被處理掉的物品加入忽略清單。`",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["MolinariSlash"]("") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
		type = "text",
        text = "分解物品：滑鼠指向背包內要分解或處理的物品，按住 Ctrl+Alt 鍵不放，再用滑鼠左鍵點一下物品，即可執行專業技能的處理動作。\n\n只能分解或處理背包和交易視窗內的物品，銀行中的不行。\n\n|cffFF2D2D使用 'DJ智能分類背包' 時，請勿將一鍵分解物品的輔助鍵設為只有 Alt 鍵，以避免和自訂物品分類的快速鍵相衝突。|r",
    },
};
D["MRT"] = {
	defaultEnable = 0,
	tags = { "BOSSRAID" },
	title = "MRT 團隊工具包",
	desc = "提供出團時會用到的許多方便功能。像是團隊分析觀察、準備確認、檢查食物精煉、上光柱標記助手、團隊技能CD監控、團隊輔助工具和一些首領的戰鬥模組...等。`",
	modifier = "永霜, BNS",
	icon = "Interface\\AddOns\\MRT\\media\\OptionLogo2",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["mrtSlash"]("set") end,
    },
	{
		type = "text",
		text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",
	},
	{
		type = "text",
		text = "點小地圖按鈕的 'MRT 團隊工具包' 按鈕也可以開啟設定選項。",
	}
};
D["Myslot"] = {
	defaultEnable = 0,
	tags = { "ACTIONBAR" },
	title = "快速切換（快捷列）",
	desc = "記錄切換快捷列及熱鍵設定，幫助你在帳號之間共享配置，快速切換所有設定。`",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["MYSLOT"]("clear") end,
    },
	{
		type = "text",
		text = "點小地圖按鈕的 '快速切換' 按鈕也可以開啟設定選項。",
	}
};
D["NameplateCooldowns"] = {
    defaultEnable = 0,
	title = "敵方技能監控 (血條)",
	desc = "在血條上方顯示敵人的技能冷卻時間。`",
	author = "StoleWaterTotem",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\achievement_pvp_a_01",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["NAMEPLATECOOLDOWNS"]("") end,
    },
	{
		type = "text",
		text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",
	},
};
D["NameplateSCT"] = {
    defaultEnable = 1,
	tags = { "COMBAT" },
	title = "血條浮動戰鬥文字",
	desc = "『我輸出超高的！』``喜歡高爽度的爆擊數字，想要看清楚每一發打出的傷害有多少嗎?`` 讓打怪的傷害數字在血條周圍跳動，完全可以自訂字體、大小、顏色和動畫效果。也可以在傷害數字旁顯示法術圖示、依據傷害類型顯示文字顏色，更容易分辨是哪個技能打出的傷害。``不擋畫面，清楚就是爽！``|cffFF2D2D只會套用到打怪的傷害數字，不會影響其它浮動戰鬥文字。|r`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\boss_odunrunes_yellow",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_NSCT"]("") end,
    },
	{
		type = "text",
		text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",
	},
	{
		type = "text",
        text = "|cffFF2D2D需要開啟血條才能看到傷害數字。|r\n\n傷害數字重複了? 要關閉遊戲內建的傷害數字在 Esc > 介面設定 > 戰鬥 > 顯示目標傷害，取消打勾。\n\n選擇要顯示哪些類型的傷害和治療數字：到 Esc > 介面設定 > 戰鬥 > 允許浮動戰鬥文字，在這裡勾選。",
	},
};
D["NovaInstanceTracker"] = {
    defaultEnable = 0,
	tags = { "BOSSRAID" },
	title = "Nova 副本進度追蹤",
	desc = "記錄打了哪些副本、打了幾次，以及怪物數量、經驗值、金錢和戰利品拾取記錄。",
	modifier = "由麻也 (VJ Kokusho)",
	{
        text = "顯示主視窗",
        callback = function(cfg, v, loading) SlashCmdList["NITCMD"]("") end,
    },
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["NITCMD"]("options") end,
    },
	{
		type = "text",
        text = "點小地圖按鈕的 'Nova 副本進度追蹤' 也可以打開主視窗。",
	},
};
D["NovaWorldBuffs"] = {
    defaultEnable = 0,
	tags = { "BOSSRAID" },
	title = "Nova 世界增益監控",
	desc = "自動取得黑妹、奈法及酋長的祝福的時間，並且倒數計時下一次可以插龍頭的時間，以及輕歌花下一次的時間。``|cffFF2D2D特別注意：目前尚未支援沒有公會的玩家，查看時間可能會發生錯誤。|r`",
	modifier = "由麻也 (VJ Kokusho)",
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["NWBCMD"]("options") end,
    },
	{
        text = "顯示已有的增益",
        callback = function(cfg, v, loading) SlashCmdList["NWBCMD"]("show") end,
    },
	{
        text = "顯示倒數計時",
        callback = function(cfg, v, loading) SlashCmdList["NWBCMD"]("") end,
    },
	{
		type = "text",
        text = "打開世界地圖、切換到主城或其他相關地圖，也可以看到世界增益的倒數計時。",
	},
};
D["NovaRaidCompanion"] = {
	defaultEnable = 0,
	tags = { "BOSSRAID" },
	title = "NRC 團隊夥伴",
	desc = "提供出團時會用到的許多方便功能。像是團隊技能監控、項鍊監控、檢查食物精煉油抗性天賦、增益快照、拾取記錄、交易紀錄...等。",
	modifier = "彩虹UI",
	icon = "Interface\\AddOns\\MRT\\media\\OptionLogo2",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["NRCCMD"]("config") end,
    },
	{
		type = "text",
		text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",
	},
	{
		type = "text",
		text = "點小地圖按鈕的 'NRC 團隊夥伴' 按鈕也可以開啟設定選項。",
	},	{
		type = "text",
		text = "此UI為Nova系列新作，雖處於早期開發階段，但以功能強大精美漂亮。\n\n若發現BUG或建議回報\n請與'由麻也-伊弗斯'聯絡。\n\n感恩。",
	},

};
D["NugComboBar"] = {
    defaultEnable = 0,
	tags = { "CLASSALL" },
	title = "連擊點數-3D圓",
	desc = "使用精美的3D圓形來顯示連擊點數。``支援盜賊和德魯伊的連擊點數、術士靈魂裂片、法師祕法充能和聖騎士聖能。`",
	--icon = "Interface\\Icons\\ability_mage_greaterpyroblast",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["NCBSLASH"]("gui") end,
    },
};
D["NugEnergy"] = {
    defaultEnable = 0,
	tags = { "CLASSALL" },
	title = "能量條增強",
	desc = "可以自訂位置和大小的能量條，方便在戰鬥中監控法力/能量變化。``支援多種職業，也包含 5秒回魔規則的監控。`",
	modifier = "彩虹ui",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["NUGENERGY"]("gui") end,
    },
	{
        text = "解鎖移動",
        callback = function(cfg, v, loading) SlashCmdList["NUGENERGY"]("unlock") end,
    },
	{
        text = "鎖定位置",
        callback = function(cfg, v, loading) SlashCmdList["NUGENERGY"]("lock") end,
    },
};
D["OmniBar"] = {
    defaultEnable = 0,
	title = "敵方技能監控 (條列)",
	desc = "監控敵人的技能冷卻時間。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\achievement_pvp_a_11",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["OmniBar"]("") end,
    },
};
D["OmniCC"] = {
    defaultEnable = 1,
	tags = { "ACTIONBAR" },
	title = "冷卻時間",
	desc = "所有東西的冷卻倒數計時，冷卻完畢會顯示動畫效果提醒。``遊戲本身已有內建的冷卻時間，從 Esc > 介面 > 快捷列 > 冷卻時間，可以開啟/關閉。若要使用插件的功能，請關閉遊戲內建的冷卻時間，避免兩種冷卻時間數字重疊。``|cffFF2D2D特別注意：這個插件的CPU使用量較大。電腦較慢，或不需要使用時請勿載入，也可以改用遊戲內建的冷卻時間。|r`",
	--icon = "Interface\\Icons\\spell_nature_timestop",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["OmniCC"]("") end,
    },
};
D["OmniCD"] = {
    defaultEnable = 0,
	tags = { "BOSSRAID" },
	title = "隊友技能冷卻監控",
	desc = "在隊伍框架旁顯示隊友的技能、斷法冷卻時間，監控起來簡單又方便。可以在設定選項中自行選擇要監控哪些法術技能，PvP/PvE 都適用!``|cffFF2D2D要監控團隊的技能建議改用 'MRT團隊工具包' 裡面的 '團隊技能冷卻' 功能。``競技場建議改用 '競技場頭像Ex' 插件，功能更完整。|r`",
	modifier = "彩虹ui",
	icon = "Interface\\Icons\\spell_mage_altertime_active",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["OmniCD"]("") end,
    },
	{
		type = "text",
        text = "選擇要對齊到哪種隊伍框架：在設定選項 > 地城 (或其他區域) > 位置。\n\n使用遊戲內建的隊伍框架：必須在 Esc > 介面 > 團隊檔案 > 勾選 '使用團隊風格的隊伍框架'，才會顯示隊友技能監控。\n\n手動調整位置：在設定選項 > 地城 (或其他區域) > 位置 > (最下方的) 手動調整模式 > 開啟，打勾。\n\n在隨機隊伍使用：預設只會在非隨機5人副本內啟用 (例如 M+)，要在隨機隊伍中使用前，需要先在設定選項 > 顯示 > 隊伍搜尋器 > 開啟，打勾。\n",
	},
};
D["OPie"] = {
    defaultEnable = 0,
	title = "環形快捷列",
	desc = "按下快速鍵時顯示圓環形的技能群組，可以做為輔助的快捷列使用，十分方便!``要更改環形快捷列的按鈕外觀，需要和按鈕外觀插件以及外觀主題同時載入使用。`",
	modifier = "foxlit, moseciqing, zhTW, 彩虹ui",
	--icon = "Interface\\Icons\\ability_mage_conjurefoodrank9",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["OPIE"]("") end,
    },
	{
		type = "text",
        text = "開始使用：在設定選項的 '快速鍵' 中幫環形快捷列設定按鍵。",
	},
	{
		type = "text",
        text = " ",
	},
};
D["PallyPower"] = {
    defaultEnable = 0,
	tags = { "CLASSALL" },
	title = "聖騎威能",
	desc = "能快速施放祝福的快捷列，並且可以分配團隊祝福工作，顯示祝福、光環、正義之怒及聖印的時間跟提醒。`",
};
D["Pawn"] = {
    defaultEnable = 1,
	title = "裝備屬性比較",
	desc = "計算屬性 EP 值並給予裝備提升百分比的建議。``此建議適用於大部分的情況，但因為天賦、配裝和手法流派不同，所需求的屬性可能不太一樣，這時可以自訂屬性權重分數，以便完全符合個人需求。`",
	author = "VgerAN",
	modifier = "BNS, scars377, 彩虹ui",
	--icon = "Interface\\Icons\\achievement_garrisonfollower_levelup",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["PAWN"]("") end,
    },
	{
		type = "text",
        text = "遊戲有內建裝備比較的功能，只要滑指向裝備物品時，按住 Shift 鍵不放，便能和自己身上的裝備做比較。\n\n如果想要不用按 Shift 鍵，總是會自動比較裝備，請輸入: \n\n/console set alwaysCompareItems 1\n\n(必須輸入在同一行，不要換行)",       
	},
};
D["Personal Resource Display"] = {
    defaultEnable = 0,
	tags = { "UNITFRAME" },
	title = "個人資源條",
	desc = "在角色下方顯示血量條和法力條，類似魔獸世界正式版的顯示個人資源。``可以在設定選項中自訂位置、大小、非戰鬥中隱藏和透明度。`",
	modifier = "彩虹ui",
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["PERSONALRESOURCEDISPLAY"]("") end,
    },
};
D["Postal"] = {
	defaultEnable = 1,
	title = "超強信箱",
	desc = "強化信箱功能。``收件人可以快速地選擇分身，避免寄錯；一次收取所有信件，還有更多功能。`",
	modifier = "a9012456, Adavak, andy52005, BNS, NightOw1, smartdavislin, titanium0107, whocare, Whyv",
	--icon = "Interface\\Icons\\achievement_guildperk_gmail",
	img = true,
};
D["PowerRaid"] = {
	defaultEnable = 0,
	tags = { "BOSSRAID" },
	title = "團隊增益檢查",
	desc = "檢查團隊的各種增益效果、消耗品和天賦是否都齊全。`",
	modifier = "由麻也 (VJ Kokusho), 彩虹ui",
	{
        text = "顯示主視窗",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_PR"]("window") end,
    },
	{
		type = "text",
		text = "點小地圖按鈕的 '團隊增益檢查' 按鈕也可以開啟主視窗。\n",
	},
};
D["Quartz"] = {
	defaultEnable = 1,
	tags = { "ENHANCEMENT" },
	title = "施法條增強",
	desc = "功能增強、模組化、可自訂外觀的施法條。``包括玩家、寵物的施法條，還有 GCD、揮擊、增益/減益效果和環境對應的計時條，都可以自訂調整。`",
	modifier = "a9012456, Adavak, alpha2009, Adavak, Ananhaid, nevcairiel, Seelerv, Whyv, YuiFAN, 半熟魷魚, 彩虹ui",
	--icon = "Interface\\Icons\\spell_holy_renew",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame_OpenToCategory("施法條")
			InterfaceOptionsFrame_OpenToCategory("施法條")
			InterfaceOptionsFrame_OpenToCategory("揮擊")
			InterfaceOptionsFrame_OpenToCategory("施法條")
		end,
    },
};
D["QuestC"] = {
    defaultEnable = 0,
	tags = { "QUEST" },
	title = "任務對話 (電影風格)",
	desc = "像看電影般的享受任務對話和劇情，讓每個任務都像是過場動畫。``用滑鼠點或按空白鍵接受任務和繼續下一段對話，按 Esc 取消對話。``|cffFF2D2D任務對話 (FF XIV)、任務對話 (說話的頭) 和任務對話 (電影風格) 選擇其中一種使用即可，請勿同時載入使用。|r`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\achievement_leader_king_varian_wrynn",
	img = true,
};
D["Questie"] = {
    defaultEnable = 1,
	tags = { "QUEST" },
	title = "任務位置提示",
	desc = "在地圖上標示出任務位置，包含任務 NPC 和任務怪的位置。``還有個人冒險日記的功能，讓你可以隨時撰寫冒險筆記以及查看已完成/未完成的任務。`",
	modifier = "彩虹ui",
	-- --icon = "Interface\\Icons\\achievement_leader_king_varian_wrynn",
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_QUESTIE"]("") end,
    },
	{
		type = "text",
		text = "|cffFF2D2D啟用插件後需要重新載入介面。|r\n",
	},
	{
		type = "text",
		text = "左鍵點小地圖按鈕的問號按鈕也可以開啟設定選項。\n\n右鍵點小地圖按鈕開啟冒險日記。\n",
	}
};
D["QuickTargets"] = {
    defaultEnable = 0,
	tags = { "BOSSRAID" },
	title = "快速上標",
	desc = "快速幫目標加上骷髏、叉叉、星星、月亮...等標記圖示，只要按一下快速鍵!``|cffFF2D2D第一次使用前請先在 Esc > 選項 > 按鍵綁定 > 插件 > 快速上標，設定好快速鍵。|r`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\ability_creature_cursed_02",
	-- img = true,
	{
		type = "text",
        text = "先在 Esc > 選項 > 按鍵綁定 > 插件 > 快速上標，設定好快速鍵 (預設為 Shift+F，如果曾經有調整過按鍵設定就需要重新設定)。\n\n把滑鼠指向要上標的對象，按下快速鍵直接上標，不用選取為目標。\n\n上標時多按幾下快速鍵可以循環切換成不同的標記圖示。\n",       
	},
};
D["RaidLedger"] = {
    defaultEnable = 0,
	tags = { "BOSSRAID" },
	title = "金團賬本",
	desc = "記錄掉落物品並且可以記上金額，輸入人數可自動計算出一個人分多少錢。``金團必備。`",
	author = "Boshi Lian",
	modifier = "BNS, Boshi Lian",
	{
        text = "顯示主視窗",
        callback = function(cfg, v, loading) SlashCmdList["RAIDLEDGER"]("") end,
    },
	{
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame_OpenToCategory("金團賬本")
			InterfaceOptionsFrame_OpenToCategory("金團賬本")
		end,
    },
    {
		type = "text",
        text = "按 O > 團隊 > 點視窗最上方的 '金團賬本' 按鈕也可以打開主視窗。",       
	},
};
D["RangeDisplay"] = {
    defaultEnable = 1,
	tags = { "UNITFRAME" },
	title = "顯示距離",
	desc = "顯示你和目標之間的距離，包括當前目標、專注目標、寵物、滑鼠指向對象以及競技場對象。還可以依據距離遠近來設定警告音效。``|cffFF2D2D特別注意：Stuf 頭像已有顯示距離的功能，如無特別需求可以不用載入這個插件。|r``使用暴雪頭像 (美化調整) 或遊戲內建的頭像時，可以搭配此插件一起使用。`",
	modifier = "alpha2009, lcncg, 彩虹ui",
	--icon = "Interface\\Icons\\ability_hunter_pathfinding",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["RANGEDISPLAY"]("") end,
    },
	{
		type = "text",
        text = "移動位置：在設定選項中取消勾選 '鎖定' 來解鎖移動，調整完畢再將 '鎖定' 打勾。\n\n",       
	},
};
D["Reload"] = {
    defaultEnable = 0,
	tags = { "MISC" },
	title = "重新載入快速鍵",
	desc = "讓你可以綁定一個快速鍵來重新載入介面，需要常常 /reload 或調整UI時非常好用。`",
	modifier = "彩虹ui",
	{
		type = "text",
        text = "從 Esc > 選項 > 按鍵綁定 > 插件 > 重新載入介面，設定快速鍵。\n\n",       
	},
};
D["RollTrackerClassicZ"] = {
    defaultEnable = 0,
	tags = { "BOSSRAID" },
	title = "骰子記錄",
	desc = "記錄並統計擲骰子 /roll 的點數，自動計算出骰最大的贏家，還可以將結果發佈到聊天頻道。``特別適合分裝使用。`",
	modifier = "彩虹ui",
	{
        text = "顯示主視窗",
        callback = function(cfg, v, loading) SlashCmdList["RollTrackerClassicZ"]("") end,
    },
	{
        text = "開始新的擲骰",
        callback = function(cfg, v, loading) SlashCmdList["RollTrackerClassicZ"]("start") end,
    },
	{
        text = "還原記錄",
        callback = function(cfg, v, loading) SlashCmdList["RollTrackerClassicZ"]("undo rolls") end,
    },
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["RollTrackerClassicZ"]("config") end,
    },
	{
		type = "text",
		text = "點小地圖按鈕的 '骰子記錄' 按鈕也可以開啟主視窗。\n\n調整視窗大小：拖曳視窗邊框。\n",
	},
	{
		type = "text",
		text = "輸入 /rt [物品連結] \n可以通知大家開始骰這件物品。\n",
	}
};
D["SexyMap"] = {
    defaultEnable = 1,
	title = "性感小地圖",
	desc = "讓你的小地圖更具特色和樂趣，並增添一些性感的選項設定。``|cffFF2D2D注意：在經典版中因為暴雪移除了一些材質圖案，導致某些預設外觀會顯示出綠色方塊，仍待修正。|r`",
	--icon = "Interface\\Icons\\inv_misc_celestialmap",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["SexyMap"]("") end,
    },
	{
		type = "text",
		text = "小地圖坐標：在設定選項中啟用。\n\n在 '任務位置提示' 插件的設定選項中也可以啟用/停用小地圖坐標。\n",
	},
};
D["SharedMedia"] = {
    defaultEnable = 1,
	title = "(請刪除) 共享媒體庫",
	desc = "這個插件已改名為 '彩虹字體材質包'，資料夾名稱也不同。``請刪除舊的資料夾 (AddOns 裡面的 SharedMedia) 以避免發生衝突。`",
};
D["SharedMedia_Rainbow"] = {
    defaultEnable = 1,
	tags = { "MISC" },
	title = "彩虹字體材質包",
	desc = "讓不同的插件能夠共享材質、背景、邊框、字體和音效，也提供了多種中英文字體和材質可供設定插件時使用。``|cffFF2D2D特別注意：在插件的設定中選擇字體時，英文字體只能顯示英文、無法顯示中文 (遇到中文字會變成問號)。如有需要顯示中文，請選擇中文字體。|r`",
};
D["SharedMedia_BNS"] = {
    defaultEnable = 1,
	tags = { "MISC" },
	title = "BNS 音效材質包",
	desc = "讓不同的插件能夠共享材質、背景、邊框、音效和字體，也提供了多種音效、材質和字體可供 WA 和其他插件使用。`",
};
D["ShinyBuffs"] = {
	defaultEnable = 1,
	tags = { "ENHANCEMENT" },
	title = "我的增益/減益效果",
	desc = "美化畫面右上角自己的增益、減益效果圖示，可以調整位置、自訂圖示和文字大小。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\ability_bossdarkvindicator_auraofcontempt",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["SHINYBUFFS"]("") end,
    },
	{
		type = "text",
		text = "注意：會一起移動增益和減益圖示。",
	},
};
D["Shooter"] = {
	defaultEnable = 1,
	title = "成就自動截圖",
	desc = "獲得成就時會自動擷取螢幕畫面，為你的魔獸生活捕捉難忘的回憶。``畫面截圖都存放在`World of Warcraft > _classic_ > Screenshots 資料夾內。`",
	--icon = "Interface\\Icons\\inv_misc_toy_07",
	img = true,
};
D["SilverDragon"] = {
    defaultEnable = 0,
	tags = { "MAP" },
	title = "稀有怪獸與牠們的產地",
	desc = "功能強大的稀有怪通知插件，記錄稀有怪的位置和時間，發現時會通知你。支援舊地圖的稀有怪!``發現稀有怪獸時預設的通知效果會顯示通知面板、螢幕閃紅光和發出音效，還可以和隊友、公會同步通知發現的稀有怪，都可以在設定選項中調整。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\inv_misc_head_dragon_black_nightmare",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_SILVERDRAGON"]("") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
};
D["SilverPlateTweaks"] = {
	defaultEnable = 1,
	tags = { "ENHANCEMENT" },
	title = "血條距離微調",
	desc = "自動調整血條的視野距離 (可以看見距離多遠範圍內的血條)、堆疊時的間距和螢幕邊緣的距離 (不要超出畫面範圍)。``|cffFF2D2D特別注意：可以在威力血條的設定選項 > 暴雪設定，手動調整血條距離等相關數值，但是請先關閉這個插件。|r`",
	img = true,
};
D["SimpleItemLevel"] = {
	defaultEnable = 1,
	tags = { "ITEM" },
	title = "顯示物品等級",
	desc = "在角色視窗的裝備欄位、背包和浮動提示資訊中顯示物品等級數字。`",
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["SIMPLEITEMLEVEL"]("") end,
    },
};
D["Skada"] = {
    defaultEnable = 0,
	title = "Skada 戰鬥統計",
	desc = "可以看自己和隊友的 DPS、HPS...等模組化的戰鬥統計資訊。`",
	modifier = "a9012456, Adavak, andy52005, BNS, chenyuli, haidaodou, oscarucb, twkaixa, Whyv, Zarnivoop",
	--icon = "Interface\\Icons\\ability_rogue_slicedice",
	img = true,
    {
        text = "顯示/隱藏戰鬥統計",
        callback = function(cfg, v, loading) SlashCmdList["SKADA"]("toggle") end,
    },
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["SKADA"]("config") end,
    },
	{
		type = "text",
        text = "單位顯示為萬: 載入 '傷害統計-中文單位'，並且在設定選項 > 一般選項 > 數字格式 > 選擇 '精簡的'。但如果傷害沒有達到萬時，會顯示為 0 萬哦~",
    },
};
D["Skillet-Classic"] = {
    defaultEnable = 0,
	tags = { "PROFESSION" },
	title = "專業助手",
	desc = "取代遊戲內建的專業視窗，提供更清楚的資訊、更容易瀏覽的畫面、還有排程的功能。`",
	modifier = "BNS, bsmorgan , 彩虹ui",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) 
			Skillet:ShowOptions()
		end,
    },
};
D["SmartQuest"] = {
    defaultEnable = 1,
	title = "智能任務通報",
	desc = "追蹤和通報隊伍成員的任務進度，會在聊天視窗顯示文字和播放音效。一起組隊解任務時粉方便!``|cffFF2D2D注意：需要隊友和你都有載入這個插件才會互相通報。|r`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\achievement_garrisonquests_0010",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["SMARTQUEST"]("OPTIONS") end,
    },
};
D["SpellActivationOverlay"] = {
    defaultEnable = 1,
	tags = { "COMBAT" },
	title = "法術警告",
	desc = "顯示和正式服一樣的法術警告效果，技能觸發時在角色周圍顯示材質圖案，以及快捷列的按鈕發光。``可以自訂大小、位置，還可以選擇哪些法術技能觸發時要顯示提醒效果。`",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["SAO"]("") end,
    },
};
D["SpellbookAbridged"] = {
    defaultEnable = 1,
	tags = { "ACTIONBAR" },
	title = "自動升級法術",
	desc = "在法術書上方新增選項可以自動升級快捷列上面的法術，學習到較高等級的法術時，會自動將快捷列上的法術按鈕提升為新學會的最高等級法術，以避免忘記替換技能。``例如：當你學會火球術 (等級 5) 的時候，快捷列上所有的火球術 (等級 4) 都會自動變成等級 5，但是等級 1, 2, 3 的不會變，巨集也不會受到任何影響。`",
	modifier = "彩虹ui",
	{
        text = "恢復為預設值",
        callback = function(cfg, v, loading) SlashCmdList["SBA"]("") end,
    },
};
D["Spy"] = {
    defaultEnable = 0,
	title = "偵測敵方玩家",
	desc = "PvP 的野外求生的利器，偵測並列出附近所有的敵對陣營玩家。將玩家加入 KOS 即殺清單，出現在你附近時便會播放警告音效，或是通報到聊天頻道。``還能夠和公會、隊伍、團隊成員分享即殺玩家的資料，自保圍剿兩相宜。也會記錄最近遇到的敵方玩家和勝敗次數統計。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\achievement_pvp_a_h",
	img = true,
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
        text = "顯示主視窗",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_SPY"]("show") end,
    },
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_SPY"]("config") end,
    },
	{
        text = "調整警告位置",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_SPY"]("test") end,
    },
	{
        text = "恢復為預設值",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_SPY"]("reset") end,
    },
	{
		type = "text",
        text = "選取為目標：點一下主視窗中的玩家名字，非戰鬥中才可以使用。\n\n加入即殺/忽略清單：右鍵點擊主視窗中的玩家名字，或是按住 Ctrl 點玩家名字直接加入忽略清單、按住 Shift 點玩家名字直接加入即殺清單。\n\n調整警告位置：需先在設定選項 > 警告 > 選擇警告訊息的位置 > 選擇 '可移動的'，按下上方的調整警告位置按鈕時，才能拖曳移動位置\n。",
    },
};
D["SpellWhisper"] = {
    defaultEnable = 0,
	tags = { "COMBAT" },
	title = "技能通報",
	desc = "強大的技能通報軟體，施法、打斷、控場、破控、OT...等等想得到的都可以通報，也可自訂技能及法術通報。``只要你想得到沒有報不到`",
	modifier = "由麻也, 彩虹ui",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["SWC"]("gui") end,
    },
};
D["Stuf"] = {
    defaultEnable = 0,
	title = "Stuf 頭像",
	desc = "玩家、目標、小隊等頭像和血條框架，簡單好用自訂性高!``也有傳統頭像樣式和其他外觀樣式可供選擇，詳細用法說明請看：`http://wp.me/p7DTni-142`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\inv_kingrastakhanshead",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["STUF"]("") SlashCmdList["STUF"]("") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。\n\n關閉 Stuf 頭像插件後遊戲內建的頭像不見時，請開啟功能百寶箱裡面的 '管理框架面板' 功能，等頭像恢復了再將這個功能關閉。|r",       
	},
	{
		type = "text",
        text = "看不到設定選項時，請先按 Esc 或 '取消' 關閉設定視窗，然後再按一次 '設定選項' 按鈕。\n\n點選自己/隊友：要點在血量條上 (有顏色的地方)，點其他地方無法選取。\n\n施法條：從設定選項 > 玩家 > 施法條，調整和移動自己的施法條。\n\n同時出現兩個施法條時，請關閉 '達美樂-施法條' 模組，或是 Stuf 頭像的玩家施法條其中一個。\n\n更換頭像外觀風格，或不使用 Stuf 頭像的玩家施法條時，可以載入 '達美樂-施法條' 模組。\n\n詳細用法說明請看：\nhttp://wp.me/p7DTni-142\n",       
	},
	{
		type = "text",
        text = " ",       
	},
};
D["TankMD"] = {
	defaultEnable = 0,
	tags = { "CLASSALL" },
	title = "一鍵誤導/偷天/啟動",
	desc = "只要一個按鈕或快速鍵便會自動偷天/誤導坦克，德魯伊則會啟動補師，不用切換選取目標!``無須將坦克/補師選為目標或設為專注目標，隊伍順序重新排列也沒問題。``可以設定兩個按鈕或快速鍵，分別給兩個不同的坦克/補師。``沒有隊伍或隊伍中沒有坦克/補師時，獵人會自動誤導給寵物，德魯伊會啟動自己。`",
	modifier = "彩虹ui",
	icon = "Interface\\Icons\\ability_hunter_misdirection",
	img = true,
	{
		type = "text",
		text = "快速鍵：從 Esc > 選項 > 按鍵綁定 > 插件 > 一鍵誤導/偷天/啟動，設定按鍵。\n\n快捷列按鈕：新增巨集拉到快捷列上。\n\n誤導給第一個坦克的巨集內容為：\n\n#showtooltip 誤導\n/click TankMDButton1 LeftButton 1\n/click TankMDButton1 LeftButton 0\n\n誤導給第二個坦克的巨集內容為：\n\n#showtooltip 誤導\n/click TankMDButton2 LeftButton 1\n/click TankMDButton2 LeftButton 0\n\n盜賊和德魯伊請自行將誤導改為偷天換日或啟動\n\n這是插件所提供的巨集指令，需要載入插件才能使用。",
	}
};
D["TargetNameplateIndicator"] = {
	defaultEnable = 1,
	tags = { "ENHANCEMENT" },
	title = "目標指示箭頭",
	desc = "當前目標血條上方顯示箭頭，讓目標更明顯。``|cffFF2D2D特別注意：一定要開啟敵方和友方的名條/血條，才能顯示出箭頭。|r`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\ability_warrior_charge",
	img = true,
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_TNI"]("") end,
    },
};
D["ThreatClassic2"] = {
	defaultEnable = 0,
	tags = { "COMBAT" },
	title = "仇恨監控",
	desc = "顯示隊友的仇恨值，有 OT 提醒、許多校正和顏色設定。`",
	modifier = "由麻也, 秋月, 彩虹ui",
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["TC2_SLASHCMD"]("") end,
    },
	{
		type = "text",
        text = "在仇恨值視窗標題列上面點右鍵，也可以打開設定選項。\n",       
	},
};
D["TalentEmu"] = {
	defaultEnable = 0,
	tags = { "CLASSALL" },
	title = "天賦模擬器",
	desc = "包括了天賦模擬器和範本的功能，能夠從暴雪或 Wowhead 網站的天賦模擬器匯入天賦，或是將點好的天賦分享給其他玩家。`",
	author = "ALA @ 网易有爱",
	modifier = "ALA, 彩虹ui",
	-- --icon = "Interface\\Icons\\inv_misc_book_01",
	-- img = true,
	{
        text = "打開模擬器",
        callback = function(cfg, v, loading) SlashCmdList["ALATALENTEMU"]("") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
		type = "text",
        text = "設定選項：點天賦模擬器視窗左上角的小圖示。\n\n儲存範本：左鍵點視窗右下角的儲存圖示後，一定記得要再點一下 (範本名稱前面的) 黃色打勾圖示。\n\n載入範本：右鍵點視窗右下角的儲存圖示，再點一下範本名稱。\n\n套用天賦：點視窗右下角的綠色打勾圖示。\n\n特別注意：點其他職業前請記得先儲存當前的天賦，否則天賦樹會切換成其他職業並且重置。",       
	},
};
D["TidyPlates_ThreatPlates"] = {
    defaultEnable = 1,
	tags = { "ENHANCEMENT" },
	title = "威力血條",
	desc = "威力強大、能夠根據仇恨值變化血條、提供更多自訂選項的血條。還可以幫指定的怪自訂血條樣式，讓血條更清楚明顯。``威力血條現在已經是獨立運作的插件，不再需要和 Tidy 血條一起載入使用，也請不要同時載入。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\ability_warrior_innerrage",
	img = true,
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_TPTP"]("") end,
    },
	{
        text = "切換血條重疊/堆疊",
        callback = function(cfg, v, loading) SlashCmdList["TPTPOVERLAP"]("") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
		type = "text",
        text = "|cffFF2D2D請勿和 Neat 血條或其他血條插件同時載入使用。|r"
	},
	{
		type = "text",
        text = "|cffFF2D2D注意：經典版限制最遠只能顯示 20 碼距離範圍內的血條，無法再調更遠。|r"
	},
	{
		type = "text",
        text = "自動切換血條/名字：威力血條有血條檢視 (同時顯示血條和名字) 和 名字檢視 (只顯示名字) 兩種模式，預設為離開戰鬥會自動切換成名字檢視，讓非戰鬥時能夠充分享受遊戲內容畫面，不受血條干擾。|n|n要啟用/停用自動切換血條的檢視模式，請到設定選項 > 一般設定 > 自動 > 非戰鬥中使用名字檢視。\n\nEsc > 介面 > 名稱 > 總是顯示名條，也要記得打勾。\n\n顯示血量：設定選項 > 狀態文字 > 血量文字 > 數值，打勾。",
	},
};
D["TinyChat"] = {
	defaultEnable = 1,
	tags = { "SOCIAL" },
	title = "聊天按鈕和功能增強",
	desc = "一個超輕量級的聊天功能增強插件。``提供快速切換頻道按鈕、表情圖案、開怪倒數、擲骰子、顯示物品圖示...還有更多功能。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\spell_holy_divineprovidence",
    img = true,
	{
        text = "重置聊天按鈕位置",
        callback = function(cfg, v, loading) resetTinyChat() end,
    },
	{
		type = "text",
		text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",
	},
	{
		type = "text",
		text = "|cffFF2D2D啟用或停用 '聊天視窗美化' 插件後，建議重置聊天按鈕位置。|r",
	},
	{
		type = "text",
        text = "聊天增強設定選項：右鍵點頻道按鈕最左側的小圖示。\n\n移動頻道按鈕：按住 Alt 鍵拖曳頻道按鈕最左側的小圖示。\n\n顯示/隱藏社群頻道按鈕：設定選項 > 顯示頻道按鈕 > 社群頻道。\n\n切換頻道：左鍵點聊天視窗上方的頻道名稱。\n\n開啟/關閉頻道：右鍵點聊天視窗上方的頻道名稱。\n\n快速切換頻道：輸入文字時按 Tab 鍵。\n\n快速輸入之前的內容：輸入文字時按上下鍵。\n\n快速捲動到最上/下面：按住 Ctrl 滾動滑鼠滾輪。\n\n輸入表情符號：打字時輸入 { 會顯示表情符號選單。\n\n開怪倒數：左鍵點 '開' 會開始倒數，右鍵點 '開' 會取消倒數。\n\n開怪倒數時間和喊話：右鍵點頻道按鈕最左側的小圖示 > 開怪倒數。\n",
	},
};
D["MerInspect"] = {
    defaultEnable = 0,
	tags = { "ITEM" },
	title = "(請刪除) 裝備觀察",
	desc = "這個插件的資料夾已更改名稱。``請刪除舊的資料夾 (AddOns 裡面的 MerInspect) 以避免發生衝突。`",
	modifier = "彩虹ui",
};
D["MerInspect-classic-era"] = {
    defaultEnable = 1,
	tags = { "ITEM" },
	title = "裝備觀察",
	desc = "觀察其他玩家和自己時會在角色資訊視窗右方列出已裝備的物品清單，方便查看裝備和物品等級。`",
	modifier = "彩虹ui",
	-- icon = "Interface\\Icons\\inv_helmet_leather_raiddruid_q_01",
	img = true,
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["MerInspect"]("") end,
    },
};
D["TinyInspect"] = {
    defaultEnable = 0,
	tags = { "ITEM" },
	title = "(請刪除) 裝備觀察",
	desc = "這是正式服用的插件，經典服無法使用。`",
};
D["TinyInspect-Reforged"] = {
    defaultEnable = 0,
	tags = { "ITEM" },
	title = "(請刪除) 裝備觀察",
	desc = "這是舊的插件，已改用另一個裝備觀察插件。``請刪除 AddOns 裡面的 TinyInspect-Reforged 資料夾。",
};
D["TinyTooltip"] = {
    defaultEnable = 0,
	tags = { "ENHANCEMENT" },
	title = "浮動提示資訊增強",
	desc = "提供更多的選項讓你可以自訂滑鼠指向時所顯示的提示說明。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\inv_wand_02",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["TinyTooltip"]("") end,
    },
	{
        text = "恢復為預設值",
        callback = function(cfg, v, loading) SlashCmdList["TinyTooltip"]("reset") end,
		reload = true,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
		type = "text",
		text = "查看法術ID：滑鼠指向時按住 Alt 鍵。\n\n戰鬥中顯示浮動提示資訊：在設定選項中取消勾選 '戰鬥中隱藏'，玩家和NPC的戰鬥中隱藏也要分別取消勾選。\n\nDIY 模式：在設定選項中按下 DIY，可以分別拖曳每種資訊文字，自行安排呈現的位置。\n\n|cffFF2D2D請勿同時開啟 功能百寶箱 > 界面設置 > 增強工具提示 的功能，以免發生衝突。|r\n",
	},
};
D["TinyTooltip-Reforged"] = {
    defaultEnable = 1,
	tags = { "ENHANCEMENT" },
	title = "浮動提示資訊增強",
	desc = "提供更多的選項讓你可以自訂滑鼠指向時所顯示的提示說明。`",
	modifier = "彩虹ui",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["TinyTooltipReforged"]("") end,
    },
	{
        text = "恢復為預設值",
        callback = function(cfg, v, loading) SlashCmdList["TinyTooltipReforged"]("reset") end,
		reload = true,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
		type = "text",
		text = "移動位置：在設定選項中按 '移動' 按鈕來調整。\n\n查看法術ID：滑鼠指向時按住 Alt 鍵。\n\n戰鬥中顯示浮動提示資訊：在設定選項中取消勾選 '戰鬥中隱藏'，玩家和NPC的戰鬥中隱藏也要分別取消勾選。\n\nDIY 模式：在設定選項中按下 DIY，可以分別拖曳每種資訊文字，自行安排呈現的位置。\n\n|cffFF2D2D請勿同時開啟 功能百寶箱 > 界面設置 > 增強工具提示 的功能，以免發生衝突。|r\n",
	},
};
D["Tofu"] = {
    defaultEnable = 1,
	tags = { "QUEST" },
	title = "任務對話 (FF XIV)",
	desc = "與NPC對話、接受/交回任務時，會使用 FINAL FANTASY XIV 風格的對話方式，取代傳統的任務說明。``用滑鼠點或按空白鍵接受任務和繼續下一段對話，按 Esc 取消對話。``|cffFF2D2D任務對話 (FF XIV)、任務對話 (說話的頭) 和任務對話 (電影風格) 選擇其中一種使用即可，請勿同時載入使用。|r`",
};
D["TomTom"] = {
    defaultEnable = 1,
	title = "TomTom 導航箭頭",
	desc = "一個簡單的導航助手。自行在世界地圖上設定好目的地導航點，或是輸入坐標後，會在畫面中間出現指示方向的導航箭頭，跟著跑就對了!``直接點一下聊天視窗中別人貼的坐標也可以開始導航哦!``和任務高手插件不同，TomTom 不會自動幫任務導航，需要自己手動設定目的地。`",
	-- modifier = "彩虹ui",
	-- --icon = "Interface\\Icons\\inv_wand_02",
	-- img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["TOMTOM"]("") end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
		type = "text",
		text = "自訂導航：按住 Alt+右鍵點擊世界地圖上的位置。\n\n坐標導航：輸入 /way x y\n其中的 x 和 y 為坐標數值。\n\n移動箭頭：滑鼠直接拖曳導航箭頭來移動位置。\n\n取消導航：右鍵點導航箭頭或世界地圖上的導航目的地。\n",
	},
};
D["TotemTimers"] = {
    defaultEnable = 0,
	title = "薩滿圖騰快捷列",
	desc = "能快速施放圖騰的快捷列，並且會顯示圖騰、復生、閃電盾和武器增益效果的時間和提醒。`",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["TOTEMTIMERS"]("") end,
    },
};
D["tullaRange"] = {
    defaultEnable = 1,
	title = "射程著色",
	desc = "超出射程時，快捷列圖示會顯示紅色，能量不足時顯示藍色，技能無法使用時顯示灰色。`",
	--icon = "Interface\\Icons\\inv_misc_food_28",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame:Show()
			InterfaceOptionsFrame_OpenToCategory("快捷列-著色")
			InterfaceOptionsFrame_OpenToCategory("快捷列-著色")
		end,
    },
};
D["UnitFramesPlus"] = {
    defaultEnable = 1,
	tags = { "UNITFRAME" },
	title = "暴雪頭像 (增強功能)",
	desc = "加強遊戲內建頭像的功能，提供更多自訂選項。像是 3D 動態頭像、在框架外側顯示額外的血量/法力值、頭像上的戰鬥文字、隊友和寵物的目標、較穩定的目標的目標，以及目標的目標的目標框架...等等。``建議搭配 '暴雪頭像 (美化調整)' 插件一起使用，也可以單獨使用。`",
	modifier = "彩虹ui",
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["UnitFramesPlus"]("") end,
		reload = true,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
		type = "text",
        text = "|cffFF2D2D和 '暴雪頭像 (美化調整)' 插件一起使用時，有些設定是在 '暴雪頭像 (美化調整)' 調整，例如自己/目標/寵物的血量和法力文字格式、縮放大小等。|r",
	},
	{
		type = "text",
        text = "點小地圖按鈕的 '暴雪頭像' 按鈕也可以開啟設定選項。",
	},
	{
		type = "text",
        text = "移動位置：按住 Shift 鍵拖曳移動，不用解鎖框架。\n\n目標的目標：建議關閉遊戲內建的目標的目標框架，插件有自己的。按 Esc > 介面設定 > 戰鬥 > 顯示目標的目標，取消打勾。\n",
	},
};
D["VuhDo"] = {
    defaultEnable = 0,
	tags = { "BOSSRAID" },
	title = "團隊框架 (巫毒)",
	desc = "用來取代隊伍/團隊框架，滑鼠點一下就能快速施放法術/補血，是補師的好朋友! DD 和坦克也適用。``可以自訂框架的外觀、順序，提供治療、驅散、施放增益效果、使用飾品、距離檢查和仇恨提示和更多功能。``還有精美且清楚的 HOT 和動畫效果提醒驅散的 DEBUFF 圖示。`",
	--icon = "Interface\\Icons\\inv_belt_mail_raidshaman_k_01",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["VUHDO"]("opt") end,
    },
	{
		type = "text",
        text = "使用低等級的法術：法術名稱請輸入例如：治療之觸(等級 1)。\n\n等級和數字之間要有一個空格，其他地方都不要空格。\n",
	},
	{
		type = "text",
        text = "設定檔懶人包匯入教學請看\nhttps://addons.miliui.com/show/49/4\n\n更多設定檔下載\nhttps://wago.io/vuhdo\n",
	},
};
D["Wardrobe"] = {
    defaultEnable = 0,
	title = "裝備管理員",
	desc = "遊戲已經有內建裝備管理員，從 Esc > 介面 > 功能 > 啟用裝備管理員，打勾即可使用。``這個插件和遊戲內建的裝備管理員功能類似，只是提供懷舊的玩家使用。如果要使用這個插件，請關閉遊戲內建的裝備管理員。`",
	{
		type = "text",
        text = "開啟裝備管理員：點角色視窗右上角的按鈕。\n\n建立新套裝後要記得按下儲存，才會保存套裝。\n\n一鍵換裝巨集：\n/wardrobe equipset-套裝名稱\n",
	},
};
D["WeakAuras"] = {
    defaultEnable = 0,
	tags = { "MISC" },
	title = "WA技能提醒",
	desc = "輕量級，但功能強大實用、全面性的技能提醒工具，會依據增益/減益和各種觸發效果顯示圖形和資訊，以便做醒目的提醒。``在經典版中還沒有範本的功能，需要手動設定來建立提醒效果，或是匯入別人寫好的提醒效果字串使用，詳細請看教學。``基礎用法教學：`http://bit.ly/learn-wa``各種WA提醒效果字串下載：`https://wago.io`",
	modifier = "a9012456, scars377, Stanzilla, Wowords, 彩虹ui",
	--icon = "Interface\\Icons\\spell_holy_aspiration",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["WEAKAURAS"]("") end,
    },
	{
		type = "text",
        text = "輸入 /wa 也可以開啟設定選項。\n\n分享給隊友：在 WA技能提醒的設定視窗中，按住 Shift 鍵點視窗左側的提醒效果名稱，可以將連結貼到隊伍聊天頻道，隊友點一下連結即可直接匯入。\n",
	},
	{
		type = "text",
        text = " ",       
	},
};
D["WIM"] = {
    defaultEnable = 1,
	title = "魔獸世界即時通",
	desc = "密語會彈出小視窗，就像使用即時通訊軟體般的方便。``隨時可以查看密語，不會干擾戰鬥，也有密語歷史記錄的功能。`",
	modifier = "wuchiwa, zhTW",
	--icon = "Interface\\Icons\\ui_chat",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) WIM.ShowOptions() end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
		type = "text",
        text = "點小地圖按鈕的 '即時通' 按鈕顯示密語視窗。",
	},
};
D["WorldMapTrackingEnhanced"] = {
	defaultEnable = 1,
	tags = { "MAP" },
	title = "世界地圖追蹤增強",
	desc = "加強世界地圖右上角放大鏡的追蹤功能，提供更多的項目，隨時選擇地圖上要顯示、不顯示哪些圖示。``支援地圖標記相關模組、採集助手、戰寵助手和世界任務追蹤插件，讓你可以快速開關地圖上的圖示，不需要分別停用每個插件。`",
	--icon = "Interface\\Icons\\inv_misc_spyglass_03",
	img = true,
	{
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame_OpenToCategory("地圖-追蹤")
			InterfaceOptionsFrame_OpenToCategory("地圖-追蹤")
		end,
    },
	{
		type = "text",
        text = "|cffFF2D2D啟用插件後需要重新載入介面。|r",       
	},
	{
		type = "text",
        text = "點世界地圖右上角的放大鏡，選擇要顯示/隱藏哪些圖示。",
	},
};
D["xanSoundAlerts"] = {
	defaultEnable = 1,
	tags = { "COMBAT" },
	title = "血量/法力過低音效",
	desc = "血量或法力/能量太低時，會發出音效來提醒。``支援多種能量類型，可在設定選項中勾選。",
	--icon = "Interface\\Icons\\spell_brokenheart",
	{
        text = "設定選項",
        callback = function(cfg, v, loading) SlashCmdList["XANSOUNDALERTS"]("") end,
    },
	{
		type = "text",
        text = "更改要提醒的血量/法力百分比：請用記事本或 Notepad++ 編輯 AddOns\\xanSoundAlerts\\　xanSoundAlerts.lua\n\n自訂音效：將聲音檔案 (MP3 或 OGG) 複製到 AddOns\\ xanSoundAlerts\\sounds 資料夾裡面，然後用記事本編輯 xanSoundAlerts.lua，分別搜尋 LowHealth.ogg (低血量音效) 和 LowMana.ogg (低法力音效) 這兩個英文檔名文字，修改為自己的聲音檔案名稱，要記得加上副檔名 .mp3 或 .ogg。\n\n更改完成後要重新啟動遊戲才會生效，重新載入無效。\n",
	},
};
D["XIV_Databar"] = {
    defaultEnable = 0,
	tags = { "ENHANCEMENT" },
	title = "功能資訊列 (舊版)",
	desc = "在畫面最下方顯示一排遊戲功能小圖示，取代原本的微型選單和背包按鈕。還會顯示時間、耐久度、天賦、專業、兌換通貨、金錢、傳送和系統資訊等等。``在設定選項中可以自行選擇要顯示哪些資訊、調整位置和顏色。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\ability_hunter_beasttraining",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) 
			-- InterfaceOptionsFrame:Show()
			InterfaceOptionsFrame_OpenToCategory("資訊列")
			InterfaceOptionsFrame_OpenToCategory("功能模組")
			InterfaceOptionsFrame_OpenToCategory("資訊列")
		end,
    },
	{
		type = "text",
        text = "設定功能模組：打開設定選項視窗後，在視窗左側點 '資訊列' 旁的加號將它展開，再選擇 '功能模組'。\n",
	},
	{
		type = "text",
        text = "開啟/關閉功能模組後如果沒有正常顯示，請重新載入。",
	},
};
D["XIV_Databar_Continued"] = {
    defaultEnable = 1,
	tags = { "ENHANCEMENT" },
	title = "功能資訊列",
	desc = "在畫面最下方顯示一排遊戲功能小圖示，取代原本的微型選單和背包按鈕。還會顯示時間、耐久度、天賦、專業、兌換通貨、金錢、傳送和系統資訊等等。``在設定選項中可以自行選擇要顯示哪些資訊、調整位置和顏色。`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\ability_hunter_beasttraining",
	img = true,
    {
        text = "設定選項",
        callback = function(cfg, v, loading) 
			Settings.OpenToCategory("資訊列")
		end,
    },
	{
		type = "text",
        text = "設定功能模組：打開設定選項視窗後，在視窗左側點 '資訊列' 旁的加號將它展開，再選擇 '功能模組'。\n",
	},
	{
		type = "text",
        text = "開啟/關閉功能模組後如果沒有正常顯示，請重新載入。",
	},
};
D["YouGotMail"] = {
	defaultEnable = 1,
	tags = { "ITEM" },
	title = "新郵件通知音效",
	desc = "收到新的郵件時會播放 You got mail 經典音效。`",
};
D["zz_itemsdb"] = {
	defaultEnable = 0,
	tags = { "ITEM" },
	title = "物品數量追蹤 (舊版)",
	desc = "在物品的浮動提示資訊中顯示其他角色擁有相同物品的數量。``請在設定選項中勾選要追蹤背包、銀行、公會銀行、兌換通貨... 等等哪些地方的物品數量，以及刪除不再需要追蹤的角色資料。``|cffFF2D2D需要將其他角色登入一次才會計算該角色的物品數量。|r`",
	modifier = "彩虹ui",
	--icon = "Interface\\Icons\\achievement_guild_otherworldlydiscounts",
	img = true,
	{
        text = "設定選項",
        callback = function(cfg, v, loading) 
			InterfaceOptionsFrame_OpenToCategory("背包-物品數量")
			InterfaceOptionsFrame_OpenToCategory("背包-物品數量")
		end,
    },
};