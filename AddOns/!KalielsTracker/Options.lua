--- Kaliel's Tracker
--- Copyright (c) 2012-2024, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
KT.forcedUpdate = false

local ACD = LibStub("MSA-AceConfigDialog-3.0")
local ACR = LibStub("AceConfigRegistry-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local WidgetLists = AceGUIWidgetLSMlists
local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

-- Lua API
local floor = math.floor
local fmod = math.fmod
local format = string.format
local gsub = string.gsub
local ipairs = ipairs
local pairs = pairs
local strlen = string.len
local strsplit = string.split
local strsub = string.sub

local db, dbChar
local mediaPath = "Interface\\AddOns\\"..addonName.."\\Media\\"
local anchors = { "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT" }
local strata = { "LOW", "MEDIUM", "HIGH" }
local flags = { [""] = "無", ["OUTLINE"] = "外框", ["OUTLINE, MONOCHROME"] = "無消除鋸齒外框" }
local textures = { "無", "預設 (暴雪)", "單線", "雙線" }
local modifiers = { [""] = "無", ["ALT"] = "Alt", ["CTRL"] = "Ctrl", ["ALT-CTRL"] = "Alt + Ctrl" }

local cTitle = " "..NORMAL_FONT_COLOR_CODE
local cBold = "|cff00ffe3"
local cWarning = "|cffff7f00"
local beta = "|cffff7fff[Beta]|r"
local warning = cWarning.."注意:|r 將會重新載入介面!"

local KTF = KT.frame
local OTF = ObjectiveTrackerFrame

local overlay
local overlayShown = false

local _, numQuests = GetNumQuestLogEntries()

local OverlayFrameUpdate, OverlayFrameHide, GetModulesOptionsTable, MoveModule, SetSharedColor, IsSpecialLocale	-- functions

local defaults = {
	profile = {
		anchorPoint = "TOPRIGHT",
		xOffset = 0,
		yOffset = -210,
		maxHeight = 600,
		frameScrollbar = true,
		frameStrata = "LOW",
		
		bgr = "Solid",
		bgrColor = { r = 0, g = 0, b = 0, a = 0 },
		border = "None",
		borderColor = { r = 1, g = 0.82, b = 0 },
		classBorder = false,
		borderAlpha = 1,
		borderThickness = 16,
		bgrInset = 4,
		progressBar = "Blizzard",

		font = LSM:GetDefault("font"),
		fontSize = 16,
		fontFlag = "",
		fontShadow = 1,
		colorDifficulty = false,
		textWordWrap = false,

		headerBgr = 2,
		headerBgrColor = { r = 1, g = 0.82, b = 0 },
		headerBgrColorShare = false,
		headerTxtColor = { r = 1, g = 0.82, b = 0 },
		headerTxtColorShare = false,
		headerBtnColor = { r = 1, g = 0.82, b = 0 },
		headerBtnColorShare = false,
		headerCollapsedTxt = 3,
		headerOtherButtons = true,
		keyBindMinimize = "",
		
		qiBgrBorder = false,
		qiXOffset = -5,

		hideEmptyTracker = false,
		collapseInInstance = false,
		expandTrackerAfterTrack = true,
		menuWowheadURL = true,
        menuWowheadURLModifier = "ALT",

		messageQuest = true,
		messageAchievement = true,
		sink20OutputSink = "RaidWarning",
		sink20Sticky = false,
		soundQuest = false,
		soundQuestComplete = "KT - Default",

		questsHeaderTitleAppend = true,
		questsShowLevels = true,
		questsShowTags = true,
		questsShowZones = true,
		questsObjectiveNumSwitch = true,

		achievementsHeaderTitleAppend = true,

		tooltipShow = true,
		tooltipShowRewards = true,
		tooltipShowID = true,

		modulesOrder = KT.BLIZZARD_MODULES,

		addonQuestie = true,
	},
	char = {
		collapsed = false,
		trackedQuests = {},
	}
}

local options = {
	name = "|T"..mediaPath.."KT_logo:22:22:-1:7|t任務追蹤清單增強",
	type = "group",
	get = function(info) return db[info[#info]] end,
	args = {
		general = {
			name = "選項",
			type = "group",
			args = {
				sec0 = {
					name = "資訊",
					type = "group",
					inline = true,
					order = 0,
					args = {
						version = {
							name = "  |cffffd100版本:|r  "..KT.version,
							type = "description",
							width = "normal",
							fontSize = "medium",
							order = 0.11,
						},
						build = {
							name = " |cffffd100Build:|r  WotLK Classic",
							type = "description",
							width = "normal",
							fontSize = "medium",
							order = 0.12,
						},
						slashCmd = {
							name = cBold.." /kt|r  |cff808080...............|r  切換 (展開/收起) 任務追蹤清單\n"..
									cBold.." /kt config|r  |cff808080...|r  顯示設定選項視窗\n",
							type = "description",
							width = "double",
							order = 0.3,
						},
						news = {
							name = "更新資訊",
							type = "execute",
							disabled = function()
								return not KT.Help:IsEnabled()
							end,
							func = function()
								KT.Help:ShowHelp(true)
							end,
							order = 0.2,
						},
						help = {
							name = "使用說明",
							type = "execute",
							disabled = function()
								return not KT.Help:IsEnabled()
							end,
							func = function()
								KT.Help:ShowHelp()
							end,
							order = 0.4,
						},
						supportersSpacer = {
							name = " ",
							type = "description",
							width = "normal",
							order = 0.51,
						},
						supportersLabel = {
							name = "                |cff00ff00成為贊助者",
							type = "description",
							width = "normal",
							fontSize = "medium",
							order = 0.52,
						},
						supporters = {
							name = "支持贊助",
							type = "execute",
							disabled = function()
								return not KT.Help:IsEnabled()
							end,
							func = function()
								KT.Help:ShowSupporters()
							end,
							order = 0.53,
						},
					},
				},
				sec1 = {
					name = "位置/大小",
					type = "group",
					inline = true,
					order = 1,
					args = {
						anchorPoint = {
							name = "對齊畫面",
							desc = "- 預設: "..defaults.profile.anchorPoint,
							type = "select",
							values = anchors,
							get = function()
								for k, v in ipairs(anchors) do
									if db.anchorPoint == v then
										return k
									end
								end
							end,
							set = function(_, value)
								db.anchorPoint = anchors[value]
								db.xOffset = 0
								db.yOffset = 0
								KT:MoveTracker()
								OverlayFrameUpdate()
							end,
							order = 1.1,
						},
						xOffset = {
							name = "水平位置",
							desc = "- 預設: "..defaults.profile.xOffset.."\n- 單位: 1",
							type = "range",
							min = 0,
							max = 0,
							step = 1,
							set = function(_, value)
								db.xOffset = value
								KT:MoveTracker()
							end,
							order = 1.2,
						},
						yOffset = {
							name = "垂直位置",
							desc = "- 預設: "..defaults.profile.yOffset.."\n- 單位: 2",
							type = "range",
							min = 0,
							max = 0,
							step = 2,
							set = function(_, value)
								db.yOffset = value
								KT:MoveTracker()
								KT:SetSize()
								OverlayFrameUpdate()
							end,
							order = 1.3,
						},
						maxHeight = {
							name = "最大高度",
							desc = "- 預設: "..defaults.profile.maxHeight.."\n- 單位: 2",
							type = "range",
							min = 100,
							max = 100,
							step = 2,
							set = function(_, value)
								db.maxHeight = value
								KT:SetSize()
								OverlayFrameUpdate()
							end,
							order = 1.4,
						},
						maxHeightShowOverlay = {
							name = "顯示最大高度範圍",
							desc = "顯示區域範圍，更容易看出最大高度的值。",
							type = "toggle",
							width = 1.3,
							get = function()
								return overlayShown
							end,
							set = function()
								overlayShown = not overlayShown
								if overlayShown and not overlay then
									overlay = CreateFrame("Frame", KTF:GetName().."Overlay", KTF)
									overlay:SetFrameLevel(KTF:GetFrameLevel() + 11)
									overlay.texture = overlay:CreateTexture(nil, "BACKGROUND")
									overlay.texture:SetAllPoints()
									overlay.texture:SetColorTexture(0, 1, 0, 0.3)
									OverlayFrameUpdate()
								end
								overlay:SetShown(overlayShown)
							end,
							order = 1.5,
						},
						maxHeightNote = {
							name = cBold.."\n 最大高度會隨著垂直位置而變動。\n"..
								" 內容較少 ... 任務追蹤清單高度會自動縮小。\n"..
								" 內容較多 ... 任務追蹤清單會啟用捲動功能。",
							type = "description",
							order = 1.6,
						},
						frameScrollbar = {
							name = "顯示捲動指示軸",
							desc = "啟用捲動功能時顯示捲動指示軸，使用與邊框相同顏色。",
							type = "toggle",
							set = function()
								db.frameScrollbar = not db.frameScrollbar
								KTF.Bar:SetShown(db.frameScrollbar)
								KT:SetSize()
							end,
							order = 1.7,
						},
						frameStrata = {
							name = "框架層級",
							desc = "- 預設: "..defaults.profile.frameStrata,
							type = "select",
							values = strata,
							get = function()
								for k, v in ipairs(strata) do
									if db.frameStrata == v then
										return k
									end
								end
							end,
							set = function(_, value)
								db.frameStrata = strata[value]
								KTF:SetFrameStrata(strata[value])
								KTF.Buttons:SetFrameStrata(strata[value])
							end,
							order = 1.8,
						},
					},
				},
				sec2 = {
					name = "背景/邊框",
					type = "group",
					inline = true,
					order = 2,
					args = {
						bgr = {
							name = "背景材質",
							type = "select",
							dialogControl = "LSM30_Background",
							values = WidgetLists.background,
							set = function(_, value)
								db.bgr = value
								KT:SetBackground()
							end,
							order = 2.1,
						},
						bgrColor = {
							name = "背景顏色",
							type = "color",
							hasAlpha = true,
							get = function()
								return db.bgrColor.r, db.bgrColor.g, db.bgrColor.b, db.bgrColor.a
							end,
							set = function(_, r, g, b, a)
								db.bgrColor.r = r
								db.bgrColor.g = g
								db.bgrColor.b = b
								db.bgrColor.a = a
								KT:SetBackground()
							end,
							order = 2.2,
						},
						bgrNote = {
							name = cBold.." 使用自訂背景時\n 材質設為白色。",
							type = "description",
							width = "normal",
							order = 2.21,
						},
						border = {
							name = "邊框材質",
							type = "select",
							dialogControl = "LSM30_Border",
							values = WidgetLists.border,
							set = function(_, value)
								db.border = value
								KT:SetBackground()
								KT:MoveButtons()
							end,
							order = 2.3,
						},
						borderColor = {
							name = "邊框顏色",
							type = "color",
							disabled = function()
								return db.classBorder
							end,
							get = function()
								if not db.classBorder then
									SetSharedColor(db.borderColor)
								end
								return db.borderColor.r, db.borderColor.g, db.borderColor.b
							end,
							set = function(_, r, g, b)
								db.borderColor.r = r
								db.borderColor.g = g
								db.borderColor.b = b
								KT:SetBackground()
								KT:SetText()
								SetSharedColor(db.borderColor)
							end,
							order = 2.4,
						},
						classBorder = {
							name = "邊框使用 |cff%s職業顏色|r",
							type = "toggle",
							get = function(info)
								if db[info[#info]] then
									SetSharedColor(KT.classColor)
								end
								return db[info[#info]]
							end,
							set = function()
								db.classBorder = not db.classBorder
								KT:SetBackground()
								KT:SetText()
							end,
							order = 2.5,
						},
						borderAlpha = {
							name = "邊框透明度",
							desc = "- 預設: "..defaults.profile.borderAlpha.."\n- 單位: 0.05",
							type = "range",
							min = 0.1,
							max = 1,
							step = 0.05,
							set = function(_, value)
								db.borderAlpha = value
								KT:SetBackground()
							end,
							order = 2.6,
						},
						borderThickness = {
							name = "邊框粗細",
							desc = "- 預設: "..defaults.profile.borderThickness.."\n- 單位: 0.5",
							type = "range",
							min = 1,
							max = 24,
							step = 0.5,
							set = function(_, value)
								db.borderThickness = value
								KT:SetBackground()
							end,
							order = 2.7,
						},
						bgrInset = {
							name = "背景內縮",
							desc = "- 預設: "..defaults.profile.bgrInset.."\n- 單位: 0.5",
							type = "range",
							min = 0,
							max = 10,
							step = 0.5,
							set = function(_, value)
								db.bgrInset = value
								KT:SetBackground()
								KT:MoveButtons()
							end,
							order = 2.8,
						},
						progressBar = {
							name = "進度條材質",
							type = "select",
							dialogControl = "LSM30_Statusbar",
							values = WidgetLists.statusbar,
							set = function(_, value)
								db.progressBar = value
								KT.forcedUpdate = true
								ObjectiveTracker_Update()
								KT.forcedUpdate = false
							end,
							order = 2.9,
						},
					},
				},
				sec3 = {
					name = "文字",
					type = "group",
					inline = true,
					order = 3,
					args = {
						font = {
							name = "字體",
							type = "select",
							dialogControl = "LSM30_Font",
							values = WidgetLists.font,
							set = function(_, value)
								db.font = value
								KT.forcedUpdate = true
								KT:SetText()
								ObjectiveTracker_Update()
								KT.forcedUpdate = false
							end,
							order = 3.1,
						},
						fontSize = {
							name = "文字大小",
							type = "range",
							min = 8,
							max = 24,
							step = 1,
							set = function(_, value)
								db.fontSize = value
								KT.forcedUpdate = true
								KT:SetText()
								ObjectiveTracker_Update()
								KT.forcedUpdate = false
							end,
							order = 3.2,
						},
						fontFlag = {
							name = "文字樣式",
							type = "select",
							values = flags,
							get = function()
								for k, v in pairs(flags) do
									if db.fontFlag == k then
										return k
									end
								end
							end,
							set = function(_, value)
								db.fontFlag = value
								KT.forcedUpdate = true
								KT:SetText()
								ObjectiveTracker_Update()
								KT.forcedUpdate = false
							end,
							order = 3.3,
						},
						fontShadow = {
							name = "文字陰影",
							desc = warning,
							type = "toggle",
							confirm = true,
							confirmText = warning,
							get = function()
								return (db.fontShadow == 1)
							end,
							set = function(_, value)
								db.fontShadow = value and 1 or 0
								ReloadUI()	-- WTF
							end,
							order = 3.4,
						},
						colorDifficulty = {
							name = "使用難度顏色",
							desc = "任務標題的顏色代表難度。",
							type = "toggle",
							set = function()
								db.colorDifficulty = not db.colorDifficulty
								ObjectiveTracker_Update()
							end,
							order = 3.5,
						},
						textWordWrap = {
							name = "文字自動換行",
							desc = "單行或兩行過長的文字使用 ... 來省略。 ",
							type = "toggle",
							set = function()
								db.textWordWrap = not db.textWordWrap
								KT.forcedUpdate = true
								ObjectiveTracker_Update()
								ObjectiveTracker_Update()
								KT.forcedUpdate = false
							end,
							order = 3.6,
						},
					},
				},
				sec4 = {
					name = "標題列",
					type = "group",
					inline = true,
					order = 4,
					args = {
						headerBgrLabel = {
							name = " 材質",
							type = "description",
							width = "half",
							fontSize = "medium",
							order = 4.1,
						},
						headerBgr = {
							name = "",
							type = "select",
							values = textures,
							get = function()
								for k, v in ipairs(textures) do
									if db.headerBgr == k then
										return k
									end
								end
							end,
							set = function(_, value)
								db.headerBgr = value
								KT:SetBackground()
							end,
							order = 4.11,
						},
						headerBgrColor = {
							name = "顏色",
							desc = "設定標題列材質的顏色。",
							type = "color",
							width = "half",
							disabled = function()
								return (db.headerBgr < 3 or db.headerBgrColorShare)
							end,
							get = function()
								return db.headerBgrColor.r, db.headerBgrColor.g, db.headerBgrColor.b
							end,
							set = function(_, r, g, b)
								db.headerBgrColor.r = r
								db.headerBgrColor.g = g
								db.headerBgrColor.b = b
								KT:SetBackground()
							end,
							order = 4.12,
						},
						headerBgrColorShare = {
							name = "使用邊框顏色",
							desc = "材質使用與邊框相同的顏色。",
							type = "toggle",
							disabled = function()
								return (db.headerBgr < 3)
							end,
							set = function()
								db.headerBgrColorShare = not db.headerBgrColorShare
								KT:SetBackground()
							end,
							order = 4.13,
						},
						headerTxtLabel = {
							name = " 文字",
							type = "description",
							width = "half",
							fontSize = "medium",
							order = 4.2,
						},
						headerTxtColor = {
							name = "顏色",
							desc = "設定標題列文字的顏色。",
							type = "color",
							width = "half",
							disabled = function()
								KT:SetText()
								return (db.headerBgr == 2 or db.headerTxtColorShare)
							end,
							get = function()
								return db.headerTxtColor.r, db.headerTxtColor.g, db.headerTxtColor.b
							end,
							set = function(_, r, g, b)
								db.headerTxtColor.r = r
								db.headerTxtColor.g = g
								db.headerTxtColor.b = b
								KT:SetText()
							end,
							order = 4.21,
						},
						headerTxtColorShare = {
							name = "使用邊框顏色",
							desc = "標題列文字使用與邊框相同的顏色。",
							type = "toggle",
							disabled = function()
								return (db.headerBgr == 2)
							end,
							set = function()
								db.headerTxtColorShare = not db.headerTxtColorShare
								KT:SetText()
							end,
							order = 4.22,
						},
						headerTxtSpacer = {
							name = " ",
							type = "description",
							width = "normal",
							order = 4.23,
						},
						headerBtnLabel = {
							name = " 按鈕",
							type = "description",
							width = "half",
							fontSize = "medium",
							order = 4.3,
						},
						headerBtnColor = {
							name = "顏色",
							desc = "設定所有標題列按鈕的顏色。",
							type = "color",
							width = "half",
							disabled = function()
								return db.headerBtnColorShare
							end,
							get = function()
								return db.headerBtnColor.r, db.headerBtnColor.g, db.headerBtnColor.b
							end,
							set = function(_, r, g, b)
								db.headerBtnColor.r = r
								db.headerBtnColor.g = g
								db.headerBtnColor.b = b
								KT:SetBackground()
							end,
							order = 4.31,
						},
						headerBtnColorShare = {
							name = "使用邊框顏色",
							desc = "所有標題列按鈕都使用與邊框相同的顏色。",
							type = "toggle",
							set = function()
								db.headerBtnColorShare = not db.headerBtnColorShare
								KT:SetBackground()
							end,
							order = 4.32,
						},
						headerBtnSpacer = {
							name = " ",
							type = "description",
							width = "normal",
							order = 4.33,
						},
						sec4SpacerMid1 = {
							name = " ",
							type = "description",
							order = 4.34,
						},
						headerCollapsedTxtLabel = {
							name = "      最小化時的摘要文字",
							type = "description",
							width = "normal",
							fontSize = "medium",
							order = 4.4,
						},
						headerCollapsedTxt1 = {
							name = "無",
							desc = "最小化時縮短追蹤清單的寬度。",
							type = "toggle",
							width = "half",
							get = function()
								return (db.headerCollapsedTxt == 1)
							end,
							set = function()
								db.headerCollapsedTxt = 1
								ObjectiveTracker_Update()
							end,
							order = 4.41,
						},
						headerCollapsedTxt2 = {
							name = ("%d/%d"):format(numQuests, MAX_QUESTLOG_QUESTS),
							type = "toggle",
							width = "half",
							get = function()
								return (db.headerCollapsedTxt == 2)
							end,
							set = function()
								db.headerCollapsedTxt = 2
								ObjectiveTracker_Update()
							end,
							order = 4.42,
						},
						headerCollapsedTxt3 = {
							name = ("%d/%d 任務"):format(numQuests, MAX_QUESTLOG_QUESTS),
							type = "toggle",
							get = function()
								return (db.headerCollapsedTxt == 3)
							end,
							set = function()
								db.headerCollapsedTxt = 3
								ObjectiveTracker_Update()
							end,
							order = 4.43,
						},
						headerOtherButtons = {
							name = "顯示任務日誌和成就按鈕",
							type = "toggle",
							width = "double",
							set = function()
								db.headerOtherButtons = not db.headerOtherButtons
								KT:ToggleOtherButtons()
								KT:SetBackground()
								ObjectiveTracker_Update()
							end,
							order = 4.5,
						},
						keyBindMinimize = {
							name = "按鍵 - 最小化按鈕",
							type = "keybinding",
							set = function(_, value)
								SetOverrideBinding(KTF, false, db.keyBindMinimize, nil)
								if value ~= "" then
									local key = GetBindingKey("EXTRAACTIONBUTTON1")
									if key == value then
										SetBinding(key)
										SaveBindings(GetCurrentBindingSet())
									end
									SetOverrideBindingClick(KTF, false, value, KTF.MinimizeButton:GetName())
								end
								db.keyBindMinimize = value
							end,
							order = 4.6,
						},
					},
				},
				sec5 = {
					name = "任務物品按鈕",
					type = "group",
					inline = true,
					order = 5,
					args = {
						qiBgrBorder = {
							name = "顯示按鈕區塊的背景和邊框",
							type = "toggle",
							width = "double",
							set = function()
								db.qiBgrBorder = not db.qiBgrBorder
								KT:SetBackground()
								KT:MoveButtons()
							end,
							order = 5.1,
						},
						qiXOffset = {
							name = "水平位置",
							type = "range",
							min = -10,
							max = 10,
							step = 1,
							set = function(_, value)
								db.qiXOffset = value
								KT:MoveButtons()
							end,
							order = 5.2,
						},
						--[[addonMasqueLabel = {
							name = " 外觀選項 - 用於任務物品按鈕和大型任務物品按鈕",
							type = "description",
							width = "double",
							fontSize = "medium",
							order = 5.3,
						},
						addonMasqueOptions = {
							name = "按鈕外觀 Masque",
							type = "execute",
							disabled = function()
								return (not IsAddOnLoaded("Masque") or not db.addonMasque or not KT.AddonOthers:IsEnabled())
							end,
							func = function()
								SlashCmdList["MASQUE"]()
							end,
							order = 5.31,
						},]]
					},
				},
				sec6 = {
					name = "其他選項",
					type = "group",
					inline = true,
					order = 6,
					args = {
						trackerTitle = {
							name = cTitle.."追蹤清單",
							type = "description",
							fontSize = "medium",
							order = 6.1,
						},
						hideEmptyTracker = {
							name = "隱藏空的清單",
							type = "toggle",
							set = function()
								db.hideEmptyTracker = not db.hideEmptyTracker
								KT:ToggleEmptyTracker()
							end,
							order = 6.11,
						},
						collapseInInstance = {
							name = "副本中最小化",
							desc = "進入副本時將追蹤清單收合起來。注意: 啟用自動過濾時會展開清單。",
							type = "toggle",
							set = function()
								db.collapseInInstance = not db.collapseInInstance
							end,
							order = 6.12,
						},
						expandTrackerAfterTrack = {
							name = "追蹤新任務後自動展開",
							desc = "開始追蹤新的 (任務、成就...) 時展開清單。",
							type = "toggle",
							set = function()
								db.expandTrackerAfterTrack = not db.expandTrackerAfterTrack
							end,
							order = 6.13,
						},
						menuTitle = {
							name = "\n"..cTitle.."選單項目",
							type = "description",
							fontSize = "medium",
							order = 6.3,
						},
                        menuWowheadURL = {
							name = "Wowhead URL",
							desc = "在追蹤清單內顯示 Wowhead 網址選單項目。",
							type = "toggle",
							set = function()
								db.menuWowheadURL = not db.menuWowheadURL
							end,
							order = 6.31,
						},
                        menuWowheadURLModifier = {
							name = "Wowhead URL 輔助鍵",
							type = "select",
							values = modifiers,
							get = function()
								for k, v in pairs(modifiers) do
									if db.menuWowheadURLModifier == k then
										return k
									end
								end
							end,
							set = function(_, value)
								db.menuWowheadURLModifier = value
							end,
							order = 6.32,
						},
					},
				},
				sec7 = {
					name = "通知訊息",
					type = "group",
					inline = true,
					order = 7,
					args = {
						messageQuest = {
							name = "任務訊息",
							type = "toggle",
							set = function()
								db.messageQuest = not db.messageQuest
							end,
							order = 7.1,
						},
						messageAchievement = {
							name = "成就訊息",
							width = 1.1,
							type = "toggle",
							set = function()
								db.messageAchievement = not db.messageAchievement
							end,
							order = 7.2,
						},
						-- LibSink
					},
				},
				sec8 = {
					name = "通知音效",
					type = "group",
					inline = true,
					order = 8,
					args = {
						soundQuest = {
							name = "任務音效",
							type = "toggle",
							set = function()
								db.soundQuest = not db.soundQuest
							end,
							order = 8.1,
						},
						soundQuestComplete = {
							name = "完成音效",
							desc = "插件音效的開頭為 \"KT - \"。",
							type = "select",
							width = 1.2,
							disabled = function()
								return not db.soundQuest
							end,
							dialogControl = "LSM30_Sound",
							values = WidgetLists.sound,
							set = function(_, value)
								db.soundQuestComplete = value
							end,
							order = 8.11,
						},
					},
				},
			},
		},
		content = {
			name = "內容",
			type = "group",
			args = {
				sec1 = {
					name = "任務",
					type = "group",
					inline = true,
					order = 1,
					args = {
						questsHeaderTitleAppend = {
							name = "顯示任務數量",
							desc = "在任務模組的標題中顯示任務數量。",
							type = "toggle",
							width = "normal+half",
							set = function()
								db.questsHeaderTitleAppend = not db.questsHeaderTitleAppend
								KT:SetQuestsHeaderText(true)
							end,
							order = 1.1,
						},
						questsAutoTrack = {
							name = "自動追蹤新任務",
							desc = "接受任務時自動追蹤任務，使用遊戲內建的 \"autoQuestWatch\" 參數值。",
							type = "toggle",
							get = function()
								return (GetCVar("autoQuestWatch") == "1")
							end,
							set = function(_, value)
								InterfaceOptionsDisplayPanelAutoQuestWatch:SetChecked(value)
								InterfaceOptionsDisplayPanelAutoQuestWatch:SetValue(value)
							end,
							order = 1.2,
						},
						questsShowLevels = {
							name = "顯示任務等級",
							desc = "在任務追蹤清單中顯示/隱藏任務等級。",
							type = "toggle",
							set = function()
								db.questsShowLevels = not db.questsShowLevels
								ObjectiveTracker_Update()
							end,
							order = 1.3,
						},
						questsShowTags = {
							name = "顯示任務標籤",
							desc = "在任務追蹤清單中顯示/隱藏任務標籤 (類型、週期)。",
							type = "toggle",
							set = function()
								db.questsShowTags = not db.questsShowTags
								ObjectiveTracker_Update()
							end,
							order = 1.4,
						},
						questsShowZones = {
							name = "顯示任務區域",
							desc = "在任務追蹤清單中顯示/隱藏任務區域。",
							type = "toggle",
							set = function()
								db.questsShowZones = not db.questsShowZones
								ObjectiveTracker_Update()
							end,
							order = 1.5,
						},
						questsObjectiveNumSwitch = {
							name = "目標數字在前面",
							desc = "切換目標數字的位置，在任務目標那行的最前面 / 最後面。\n\n"..
									cBold.."- 0/10 被殺死的血色狂熱者\n"..
									"- 被殺死的血色狂熱者: 0/10 ... 暴雪預設\n",
							descStyle = "inline",
							type = "toggle",
							width = "full",
							set = function()
								db.questsObjectiveNumSwitch = not db.questsObjectiveNumSwitch
								ObjectiveTracker_Update()
							end,
							order = 1.6,
						},
					},
				},
				sec2 = {
					name = "成就",
					type = "group",
					inline = true,
					order = 2,
					args = {
						achievementsHeaderTitleAppend = {
							name = "顯示成就點數",
							desc = "在成就模組的標題內顯示成就點數。",
							type = "toggle",
							width = "normal+half",
							set = function()
								db.achievementsHeaderTitleAppend = not db.achievementsHeaderTitleAppend
								KT:SetAchievementsHeaderText(true)
							end,
							order = 2.1,
						},
					},
				},
				sec3 = {
					name = "滑鼠提示",
					type = "group",
					inline = true,
					order = 3,
					args = {
						tooltipShow = {
							name = "顯示滑鼠提示",
							desc = "顯示任務 / 成就滑鼠提示。",
							type = "toggle",
							set = function()
								db.tooltipShow = not db.tooltipShow
							end,
							order = 3.1,
						},
						tooltipShowRewards = {
							name = "顯示獎勵",
							desc = "在滑鼠提示內顯示任務獎勵 - 神兵之力、職業大廳資源、金錢、裝備...等。",
							type = "toggle",
							disabled = function()
								return not db.tooltipShow
							end,
							set = function()
								db.tooltipShowRewards = not db.tooltipShowRewards
							end,
							order = 3.2,
						},
						tooltipShowID = {
							name = "顯示 ID",
							desc = "在滑鼠提示內顯示任務 / 成就的 ID。",
							type = "toggle",
							disabled = function()
								return not db.tooltipShow
							end,
							set = function()
								db.tooltipShowID = not db.tooltipShowID
							end,
							order = 3.3,
						},
					},
				},
			},
		},
		modules = {
			name = "模組",
			type = "group",
			args = {
				sec1 = {
					name = "模組順序",
					type = "group",
					inline = true,
					order = 1,
				},
			},
		},
		addons = {
			name = "支援插件",
			type = "group",
			args = {
				desc = {
					name = "|cff00d200綠色|r - 相容版本 - 這個版本經過測試並且已經支援。\n"..
							"|cffff0000紅色|r - 不相容版本 - 這個版本尚未經過測試，可能需要修改程式碼。\n"..
							"請回報任何問題。",
					type = "description",
					order = 0,
				},
				sec1 = {
					name = "插件",
					type = "group",
					inline = true,
					order = 1,
					args = {
						addonQuestie = {
							name = "任務位置提示 Questie",
							desc = "版本: %s",
							descStyle = "inline",
							type = "toggle",
							width = 1.05,
							confirm = true,
							confirmText = warning,
							disabled = function()
								return not IsAddOnLoaded("Questie")
							end,
							set = function()
								db.addonQuestie = not db.addonQuestie
								ReloadUI()
							end,
							order = 1.11,
						},
						addonQuestieDesc = {
							name = "任務位置提示支援性會加入:\n"..
									"- 右鍵選單項目"..cBold.."在地圖上顯示|r 和 "..cBold.."開始 TomTom 導航|r，\n"..
									"- "..cBold.."任務物品按鈕|r 給有使用物品的任務。",
							type = "description",
							width = "double",
							order = 1.12,
						},
					},
				},
				sec2 = {
					name = "介面套裝插件",
					type = "group",
					inline = true,
					order = 2,
					args = {
						elvui = {
							name = "ElvUI",
							type = "toggle",
							disabled = true,
							order = 2.1,
						},
						tukui = {
							name = "Tukui",
							type = "toggle",
							disabled = true,
							order = 2.2,
						},
					},
				},
			},
		},
	},
}

local general = options.args.general.args
local content = options.args.content.args
local modules = options.args.modules.args
local addons = options.args.addons.args

function KT:CheckAddOn(addon, version, isUI)
	local name = strsplit("_", addon)
	local ver = isUI and "" or "---"
	local result = false
	local path
	if IsAddOnLoaded(addon) then
		local actualVersion = C_AddOns.GetAddOnMetadata(addon, "Version") or "unknown"
		actualVersion = gsub(actualVersion, "(.*%S)%s+", "%1")
		ver = isUI and "  -  " or ""
		ver = (ver.."|cff%s"..actualVersion.."|r"):format(actualVersion == version and "00d200" or "ff0000")
		result = true
	end
	if not isUI then
		path =  addons.sec1.args["addon"..name]
		path.desc = path.desc:format(ver)
	else
		local path =  addons.sec2.args[strlower(name)]
		path.name = path.name..ver
		path.disabled = not result
		path.get = function() return result end
	end
	return result
end

function KT:OpenOptions()
	Settings.OpenToCategory(self.optionsFrame.general.name, true)
end

function KT:InitProfile(event, database, profile)
	ReloadUI()
end

function KT:SetupOptions()
	self.db = LibStub("AceDB-3.0"):New(strsub(addonName, 2).."DB", defaults, true)
	self.options = options
	db = self.db.profile
	dbChar = self.db.char

	general.sec2.args.classBorder.name = general.sec2.args.classBorder.name:format(self.RgbToHex(self.classColor))

	general.sec7.args.messageOutput = self:GetSinkAce3OptionsDataTable()
	general.sec7.args.messageOutput.inline = true
	general.sec7.args.messageOutput.disabled = function() return not (db.messageQuest or db.messageAchievement) end
	self:SetSinkStorage(db)

	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	options.args.profiles.confirm = true
	options.args.profiles.args.reset.confirmText = warning
	options.args.profiles.args.new.confirmText = warning
	options.args.profiles.args.choose.confirmText = warning
	options.args.profiles.args.copyfrom.confirmText = warning
	if not options.args.profiles.plugins then
		options.args.profiles.plugins = {}
	end
	options.args.profiles.plugins[addonName] = {
		clearTrackerDataDesc1 = {
			name = "清空當前角色已追蹤的任務內容資料 (不包含設定)。",
			type = "description",
			order = 0.1,
		},
		clearTrackerData = {
			name = "清空清單資料",
			desc = "清空已追蹤內容的資料。",
			type = "execute",
			confirm = true,
			confirmText = "清空清單資料 - "..cBold..self.playerName,
			func = function()
				self.stopUpdate = true
				dbChar.trackedQuests = {}
				local trackedAchievements = { GetTrackedAchievements() }
				for i = 1, #trackedAchievements do
					RemoveTrackedAchievement(trackedAchievements[i])
				end
				for i = 1, #db.filterAuto do
					db.filterAuto[i] = nil
				end
				self.stopUpdate = false
				ReloadUI()
			end,
			order = 0.2,
		},
		clearTrackerDataDesc2 = {
			name = "當前角色: "..cBold..self.playerName,
			type = "description",
			width = "double",
			order = 0.3,
		},
		clearTrackerDataDesc4 = {
			name = "",
			type = "description",
			order = 0.4,
		}
	}

	ACR:RegisterOptionsTable(addonName, options, nil)
	
	self.optionsFrame = {}
	self.optionsFrame.general = ACD:AddToBlizOptions(addonName, "任務-追蹤清單", nil, "general")
	self.optionsFrame.content = ACD:AddToBlizOptions(addonName, options.args.content.name, "任務-追蹤清單", "content")
	self.optionsFrame.modules = ACD:AddToBlizOptions(addonName, options.args.modules.name, "任務-追蹤清單", "modules")
	self.optionsFrame.addons = ACD:AddToBlizOptions(addonName, options.args.addons.name, "任務-追蹤清單", "addons")
	self.optionsFrame.profiles = ACD:AddToBlizOptions(addonName, options.args.profiles.name, "任務-追蹤清單", "profiles")

	self.db.RegisterCallback(self, "OnProfileChanged", "InitProfile")
	self.db.RegisterCallback(self, "OnProfileCopied", "InitProfile")
	self.db.RegisterCallback(self, "OnProfileReset", "InitProfile")
end

SettingsPanel:HookScript("OnHide", function(self)
	OverlayFrameHide()
end)

function OverlayFrameUpdate()
	if overlay then
		overlay:SetSize(280, db.maxHeight)
		overlay:ClearAllPoints()
		overlay:SetPoint(db.anchorPoint, 0, 0)
	end
end

function OverlayFrameHide()
	if overlayShown then
		overlay:Hide()
		overlayShown = false
	end
end

function GetModulesOptionsTable()
	local numModules = #db.modulesOrder
	local text
	local defaultModule, defaultText
	local args = {
		descCurOrder = {
			name = cTitle.."目前順序",
			type = "description",
			width = "double",
			fontSize = "medium",
			order = 0.1,
		},
		descDefOrder = {
			name = "|T:1:42|t"..cTitle.."預設順序",
			type = "description",
			width = "normal",
			fontSize = "medium",
			order = 0.2,
		},
	}

	for i, module in ipairs(db.modulesOrder) do
		text = _G[module].Header.Text:GetText()

		defaultModule = OTF.MODULES_UI_ORDER[i]
		defaultText = defaultModule.Header.Text:GetText()

		args["pos"..i] = {
			name = " "..text,
			type = "description",
			width = "normal",
			fontSize = "medium",
			order = i,
		}
		args["pos"..i.."up"] = {
			name = (i > 1) and "上移" or " ",
			desc = text,
			type = (i > 1) and "execute" or "description",
			width = "half",
			func = function()
				MoveModule(i, "up")
			end,
			order = i + 0.1,
		}
		args["pos"..i.."down"] = {
			name = (i < numModules) and "下移" or " ",
			desc = text,
			type = (i < numModules) and "execute" or "description",
			width = "half",
			func = function()
				MoveModule(i)
			end,
			order = i + 0.2,
		}
		args["pos"..i.."default"] = {
			name = "|T:1:55|t|cff808080"..defaultText,
			type = "description",
			width = "normal",
			order = i + 0.3,
		}
	end
	return args
end

function MoveModule(idx, direction)
	local text = strsub(modules.sec1.args["pos"..idx].name, 2)
	local tmpIdx = (direction == "up") and idx-1 or idx+1
	local tmpText = strsub(modules.sec1.args["pos"..tmpIdx].name, 2)
	modules.sec1.args["pos"..tmpIdx].name = " "..text
	modules.sec1.args["pos"..tmpIdx.."up"].desc = text
	modules.sec1.args["pos"..tmpIdx.."down"].desc = text
	modules.sec1.args["pos"..idx].name = " "..tmpText
	modules.sec1.args["pos"..idx.."up"].desc = tmpText
	modules.sec1.args["pos"..idx.."down"].desc = tmpText

	local module = tremove(db.modulesOrder, idx)
	tinsert(db.modulesOrder, tmpIdx, module)

	module = tremove(OTF.MODULES_UI_ORDER, idx)
	tinsert(OTF.MODULES_UI_ORDER, tmpIdx, module)
	ObjectiveTracker_Update()
end

function SetSharedColor(color)
	local name = "使用邊框|cff"..KT.RgbToHex(color).."顏色|r"
	local sec4 = general.sec4.args
	sec4.headerBgrColorShare.name = name
	sec4.headerTxtColorShare.name = name
	sec4.headerBtnColorShare.name = name
end

function IsSpecialLocale()
	return (KT.locale == "deDE" or
			KT.locale == "esES" or
			KT.locale == "frFR" or
			KT.locale == "ruRU")
end

-- Init
OTF:HookScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" and not KT.initialized then
		modules.sec1.args = GetModulesOptionsTable()
	end
end)