--- Kaliel's Tracker
--- Copyright (c) 2012-2024, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
local M = KT:NewModule(addonName.."_Help")
KT.Help = M

local T = LibStub("MSA-Tutorials-1.0")
local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

local db, dbChar
local mediaPath = "Interface\\AddOns\\"..addonName.."\\Media\\"
local helpPath = mediaPath.."Help\\"
local helpName = "help"
local helpNumPages = 9
local supportersName = "supporters"
local supportersNumPages = 1
local cTitle = "|cffffd200"
local cBold = "|cff00ffe3"
local cWarning = "|cffff7f00"
local cDots = "|cff808080"
local offs = "\n|T:1:8|t"
local ebSpace = "|T:22:1|t"
local beta = "|cffff7fff[Beta]|r"
local new = "|cffff7fff[新功能]|r"

local KTF = KT.frame

--------------
-- Internal --
--------------

local function AddonInfo(name)
	local info = "插件 "..name
	if IsAddOnLoaded(name) then
		info = info.." |cff00ff00已安裝|r。"
	else
		info = info.." |cffff0000未安裝|r。"
	end
	info = info.." 可以在設定選項中啟用/停用支援插件。"
	return info
end

local function SetFormatedPatronName(tier, name, realm, note)
	if realm then
		realm = " @"..realm
	else
		realm = ""
	end
	if note then
		note = " ... "..note
	else
		note = ""
	end
	return format("- |cff%s%s|r|cff7f7f7f%s%s|r\n", KT.QUALITY_COLORS[tier], name, realm, note)
end

local function SetFormatedPlayerName(name, realm, note)
	if realm then
		realm = " @"..realm
	else
		realm = ""
	end
	if note then
		note = " ... "..note
	else
		note = ""
	end
	return format("- %s|cff7f7f7f%s%s|r\n", name, realm, note)
end

local function SetupTutorials()
	T.RegisterTutorial(helpName, {
		savedvariable = KT.db.global,
		key = "helpTutorial",
		title = KT.title.." |cffffffff"..KT.version.."|r",
		icon = helpPath.."KT_logo",
		font = "Fonts\\bLEI00D.ttf",
		width = 552,
		imageHeight = 256,
		{	-- 1
			image = helpPath.."help_kaliels-tracker",
			text = cTitle..KT.title.." (Classic)|r replaces default tracker and adds some features from WoW Retail to WoW Classic.\n\n"..
					"包含下面這些功能:\n"..
					"- 追蹤任務\n"..
					"- 追蹤成就 (經典時期不包含此功能)\n"..
					"- 更改追蹤清單位置\n"..
					"- 根據追蹤清單位置 (方向) 展開/收起追蹤清單\n"..
					"- 根據內容自動調整追蹤清單高度，可以限制最大高度\n"..
					"- 內容較多，超出最大高度時可以捲動\n"..
					"- 登出/結束遊戲時會記憶追蹤清單的收起狀態\n\n"..
					"... 還有更多其他增強功能 (請繼續看下一頁)。",
			shine = KTF,
			shineTop = 5,
			shineBottom = -5,
			shineLeft = -6,
			shineRight = 6,
		},
		{	-- 2
			image = helpPath.."help_header-buttons",
			imageHeight = 128,
			text = cTitle.."標題列按鈕|r\n\n"..
					"最小化按鈕:\n"..
					"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:-1:2:32:64:0:14:0:14:209:170:0|t "..cDots.."...|r 展開追蹤清單\n"..
					"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:-1:2:32:64:0:14:16:30:209:170:0|t "..cDots.."...|r 收起追蹤清單\n"..
					"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:-1:2:32:64:0:14:32:46:209:170:0|t "..cDots.."...|r 追蹤清單是空的時候\n\n"..
					"其他按鈕:\n"..
					"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:-1:2:32:64:16:30:0:14:209:170:0|t "..cDots.."...|r 開啟任務日誌\n"..
					"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:-1:2:32:64:16:30:16:30:209:170:0|t "..cDots.."...|r 開啟成就視窗 (經典時期不包含此功能)\n"..
					"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:-1:2:32:64:16:30:32:46:209:170:0|t "..cDots.."...|r 開啟過濾方式選單\n\n"..
					"按鈕 |T"..mediaPath.."UI-KT-HeaderButtons:14:14:0:2:32:64:16:30:0:14:209:170:0|t 和 "..
					"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:0:2:32:64:16:30:16:30:209:170:0|t 可以在設定選項中停用。\n\n"..
					"可以設定"..cBold.." [快速鍵]|r 來最小化追蹤清單。\n"..
					cBold.."Alt+左鍵|r 點擊最小化按鈕會開啟 "..KT.title.."的設定選項。",
			textY = 16,
			shine = KTF.MinimizeButton,
			shineTop = 13,
			shineBottom = -14,
			shineRight = 16,
		},
		{	-- 3
			image = helpPath.."help_quest-title-tags",
			imageHeight = 128,
			text = cTitle.."特殊文字標籤|r\n\n"..
					"任務等級 |cffff8000[42]|r 會顯示在任務標題的前方。\n"..
					"任務類型標籤會在任務標題的最後方。\n\n"..
					KT.CreateQuestTagIcon(nil, 7, 14, 2, 0, 0.34, 0.425, 0, 0.28125).." "..cDots.."........|r 每日任務|T:14:98|t"..
						KT.CreateQuestTagIcon(nil, 16, 16, 0, 0, unpack(QUEST_TAG_TCOORDS[Enum.QuestTag.Heroic])).." "..cDots.."......|r 英雄任務\n"..
					KT.CreateQuestTagIcon(nil, 7, 14, 2, 0, 0.34, 0.425, 0, 0.28125)..KT.CreateQuestTagIcon(nil, 7, 14, 0, 0, 0.34, 0.425, 0, 0.28125).." "..cDots.."......|r 每週任務|T:14:97|t"..
						KT.CreateQuestTagIcon(nil, 16, 16, 0, 0, unpack(QUEST_TAG_TCOORDS[Enum.QuestTag.PvP])).." "..cDots.."......|r PvP 任務\n"..
					KT.CreateQuestTagIcon(nil, 16, 16, 0, 0, unpack(QUEST_TAG_TCOORDS[Enum.QuestTag.Group])).." "..cDots.."......|r 組隊任務|T:14:98|t"..
						"|cffd900b8S|r "..cDots.."........|r 事件任務\n"..
					KT.CreateQuestTagIcon(nil, 16, 16, 0, 0, unpack(QUEST_TAG_TCOORDS[Enum.QuestTag.Dungeon])).." "..cDots.."......|r 地城任務|T:14:95|t"..
						KT.CreateQuestTagIcon(nil, 16, 16, 0, 0, unpack(QUEST_TAG_TCOORDS[Enum.QuestTag.Account])).." "..cDots.."......|r 帳號共通任務\n"..
					KT.CreateQuestTagIcon(nil, 17, 17, -1, 0, unpack(QUEST_TAG_TCOORDS[Enum.QuestTag.Raid])).." "..cDots.."......|r 團隊任務|T:14:99|t"..
						KT.CreateQuestTagIcon(nil, 7, 14, 2, 0, 0.055, 0.134, 0.28125, 0.5625).." "..cDots.."........|r 傳說任務\n\n"..
					cWarning.."備註:|r 經典版並沒有使用到全部的標籤。",
			shineTop = 10,
			shineBottom = -9,
			shineLeft = -12,
			shineRight = 10,
		},
		{	-- 4
			image = helpPath.."help_tracker-filters",
			text = cTitle.."任務過濾|r\n\n"..
					"要開啟過濾方式選單請"..cBold.."點一下|r這個按鈕 |T"..mediaPath.."UI-KT-HeaderButtons:14:14:-2:2:32:64:16:30:32:46:209:170:0|t.\n\n"..
					"過濾方式分為兩種類型:\n"..
					cTitle.."固定過濾|r - 依據規則 (例如 \"每日\") 將任務和成就加入到追蹤清單，然後便可以手動新增 / 移除項目。\n"..
					cTitle.."動態過濾|r - 自動新增任務/成就依據條件 (例如 \"|cff00ff00自動|r區域\") "..
					"會持續更新項目。這種類型不允許手動加入/移除項目。"..
					"啟用動態過濾時，標題按鈕是綠色 |T"..mediaPath.."UI-KT-HeaderButtons:14:14:-2:2:32:64:16:30:32:46:0:255:0|t.\n\n"..
					"更改成就的搜尋類別時，也會影響過濾的結果。\n\n"..
					"這個選單也會顯示影響追蹤清單內容的其他選項。",
			textY = 16,
			shine = KTF.FilterButton,
			shineTop = 10,
			shineBottom = -11,
			shineLeft = -10,
			shineRight = 11,
		},
		{	-- 5
			image = helpPath.."help_quest-item-buttons",
			text = cTitle.."任務物品按鈕|r\n\n"..
					"需要 Questie 插件才能支援任務按鈕 (請看第8頁)。 按鈕在追蹤清單的外部，因為暴雪不允許動作按鈕在插件內部。\n\n"..
					"|T"..helpPath.."help_quest-item-buttons_2:32:32:1:0:64:32:0:32:0:32|t "..cDots.."...|r  這個標籤代表任務中的任務物品。裡面的數字用來辨別\n"..
					"                移動後的任務物品按鈕。\n\n"..
					"|T"..helpPath.."help_quest-item-buttons_2:32:32:0:3:64:32:32:64:0:32|t "..cDots.."...|r  真正的任務物品按鈕已經移動到清單的左/右側\n"..
					"                (依據所選擇的對齊畫面位置)。標籤數字仍然相同。\n\n"..
					cWarning.."特別注意:|r\n"..
					"在某些戰鬥中，任務物品按鈕的動作會被暫停，直到戰鬥結束後才能使用。",
			shineTop = 3,
			shineBottom = -2,
			shineLeft = -4,
			shineRight = 3,
		},
		{	-- 6
			image = helpPath.."help_tracker-modules",
			text = cTitle.."模組順序|r\n\n"..
					"允許更改模組在追蹤清單中的順序。支援所有的模組，也包含外部插件 (例如：戰寵助手)。",
			shine = KTF,
			shineTop = 5,
			shineBottom = -5,
			shineLeft = -6,
			shineRight = 6,
		},
		{	-- 7
			image = helpPath.."help_quest-log",
			text = cTitle.."任務日誌|r\n\n"..
					cWarning.."注意:|r 在遊戲內建的任務日誌和支援的任務日誌插件，已停用點擊任務日誌"..
					"標題 (來收起 / 展開) 的功能。因為收起的部分會把任務追蹤清單增強所包含的任務也隱藏了。\n\n"..

					cTitle.."支援插件|r\n"..
					"- Classic Quest Log\n"..ebSpace.."\n"..
					"- QuestGuru\n"..ebSpace,
			editbox = {
				{
					text = "https://www.wowinterface.com/downloads/info24937-ClassicQuestLogforClassic.html",
					width = 485,
					left = 9,
					bottom = 37,
				},
				{
					text = "https://www.curseforge.com/wow/addons/questguru_classic",
					width = 485,
					left = 9,
					bottom = 3,
				}
			},
			shine = KTF,
			shineTop = 5,
			shineBottom = -5,
			shineLeft = -6,
			shineRight = 6,
		},
		{	-- 8
			image = helpPath.."help_addon-questie",
			text = cTitle.."支援插件: Questie|r\n\n"..
					"加入了一些功能，會使用到任務位置提示插件的任務資料庫。\n\n"..
					cTitle.."區域過濾增強|r\n"..
					"現在會顯示所有與任務有關的區域 (開始、進行中和結束位置) 中的相關任務。\n\n"..
					cTitle.."任務物品按鈕|r\n"..
					"需要使用任務道具的任務，會在任務追蹤清單旁顯示任務道具的按鈕 (請看第5頁)。\n\n"..
					cTitle.."任務右鍵選單項目|r\n"..
					"- "..cBold.."在地圖上顯示|r - 顯示最接近任務目標的地圖。\n"..
					"- "..cBold.."開始 TomTom 導航|r - 將 TomTom 導航箭頭指向最近的任務目標。"..
					offs.."有安裝並載入 TomTom 插件時會顯示這個選項。\n\n"..
					"如果沒有地圖資料，"..cBold.."在地圖上顯示|r 和 "..cBold.."開始 TomTom 導航|r 選項將會被停用。\n\n"..
					AddonInfo("Questie").."\n"..ebSpace,
			editbox = {
				{
					text = "https://www.curseforge.com/wow/addons/questie",
					width = 450,
					bottom = 3,
				}
			},
			shine = KTF,
			shineTop = 5,
			shineBottom = -5,
			shineLeft = -6,
			shineRight = 6,
		},
		{	-- 9
			text = cTitle.."         更新資訊|r\n\n"..
					cTitle.."版本 3.6.0|r\n"..
					"- 新增 - 支援 WoW 1.15.2\n"..
					"- 修改 - 支援插件 - ElvUI 13.61\n"..
					"- 修改 - 支援插件 - Questie 9.5.1\n"..
					"- 修正 (任務) - 任務等級的值為 nil\n"..
					"- 效能 (任務) - 過濾 - 和任務日誌的互動性更好 (會展開標題列)\n"..
					"- 效能 (成就) - 過濾 - 區域的選擇更佳\n"..
					"- 技術 (插件) - 合併經典版 (3.5.0) 和經典時期 (1.6.0) 的程式碼\n"..
					"\n"..

					cTitle.."WoW 3.4.3/1.15.2 - 尚無解決辦法的已知問題|r\n"..
					"- 戰鬥中點擊追蹤的任務或成就不會有反應。\n"..
					"- 戰鬥中標題列的 Q 和 A 按鈕無法運作。\n\n"..

					cTitle.."回報問題|r\n"..
					"請使用下方的"..cBold.."回報單網址|r而不是在 CurseForge 留言。\n"..ebSpace.."\n\n"..

					cWarning.."回報錯誤之前，請先停用所有其他的插件，以確保此錯誤"..
					"不是和其他插件相衝突造成的。|r",
			textY = -20,
			editbox = {
				{
					text = "https://www.curseforge.com/wow/addons/kaliels-tracker-classic/issues",
					width = 450,
					bottom = 20,
				}
			},
			shine = KTF,
			shineTop = 5,
			shineBottom = -5,
			shineLeft = -6,
			shineRight = 6,
		},
		onShow = function(self, i)
			if dbChar.collapsed then
				ObjectiveTracker_MinimizeButton_OnClick()
			end
			if i == 2 then
				local eraMod = WOW_PROJECT_ID > WOW_PROJECT_CLASSIC and 0 or 20
				if KTF.FilterButton then
					self[i].shineLeft = db.headerOtherButtons and -75 + eraMod or -35
				else
					self[i].shineLeft = db.headerOtherButtons and -55 + eraMod or -15
				end
			elseif i == 3 then
				local questInfo = KT_GetQuestListInfo(1)
				if questInfo then
					local block = QUEST_TRACKER_MODULE.usedBlocks[questInfo.id]
					if block then
						self[i].shine = block
					end
					KTF.Scroll.value = 0
					ObjectiveTracker_Update()
				end
			elseif i == 5 then
				self[i].shine = KTF.Buttons
			end
			end,
		onHide = function()
			T.TriggerTutorial("supporters", 1)
		end
	})

	T.RegisterTutorial("supporters", {
		savedvariable = KT.db.global,
		key = "supportersTutorial",
		title = KT.title.." |cffffffff"..KT.version.."|r",
		icon = helpPath.."KT_logo",
		font = "Fonts\\bLEI00D.ttf",
		width = 552,
		imageHeight = 256,
		{	-- 1
			text = cTitle.."         成為贊助者|r\n\n"..
					"如果你喜歡 "..KT.title.."，請在 |cfff34a54Patreon|r 贊助我。\n\n"..
					"在 CurseForge 的插件頁面點一下 |T"..helpPath.."help_patreon:20:154:1:0:256:32:0:156:0:20|t 按鈕。\n\n"..
					"經過了 10 年的插件工作後，我啟用了 Patreon，當作是開發插件所需時間的補償。\n\n"..
					"                                    非常感謝所有贊助者  |T"..helpPath.."help_patreon:16:16:0:0:256:32:157:173:0:16|t\n\n"..
					cTitle.."Active Patrons|r\n"..
					SetFormatedPatronName("Epic", "Haekwon", "Elune")..
					SetFormatedPatronName("Epic", "Liothen", "Emerald Dream")..
					SetFormatedPatronName("Uncommon", "Anaara", "Auchindoun")..
					SetFormatedPatronName("Uncommon", "Charles Howarth")..
					SetFormatedPatronName("Uncommon", "Flex (drantor)")..
					SetFormatedPatronName("Uncommon", "Jeffrey Hofer")..
					SetFormatedPatronName("Uncommon", "Mystekal")..
					SetFormatedPatronName("Uncommon", "Semy", "Ravencrest")..
					SetFormatedPatronName("Uncommon", "Sopleb")..
					SetFormatedPatronName("Common", "Darren Divecha")..
					"\n"..
					cTitle.."Testers|r\n"..
					SetFormatedPlayerName("Asimeria", "Drak'thul")..
					SetFormatedPlayerName("Torresman", "Drak'thul"),
			textY = -20,
		},
	})
end

--------------
-- External --
--------------

function M:OnInitialize()
	_DBG("|cffffff00初始化|r - "..self:GetName(), true)
	db = KT.db.profile
	dbChar = KT.db.char
end

function M:OnEnable()
	_DBG("|cff00ff00啟用|r - "..self:GetName(), true)
	SetupTutorials()
	local last = false
	if KT.version ~= KT.db.global.version then
		local data = T.GetTutorial(helpName)
		local index = data.savedvariable[data.key]
		if index then
			last = index < helpNumPages and index or true
			T.ResetTutorial(helpName)
		end
	end
	T.TriggerTutorial(helpName, helpNumPages, last)
end

function M:ShowHelp(index)
	HideUIPanel(SettingsPanel)
	T.ResetTutorial(helpName)
	T.TriggerTutorial(helpName, helpNumPages, index or false)
end

function M:ShowSupporters()
	HideUIPanel(SettingsPanel)
	T.ResetTutorial(supportersName)
	T.TriggerTutorial(supportersName, supportersNumPages)
end