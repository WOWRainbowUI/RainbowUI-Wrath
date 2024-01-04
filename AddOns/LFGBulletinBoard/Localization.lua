local TOCNAME,GBB=...

GBB.locales = {
	enGB = {
		["lfg_channel"]="LookingForGroup", -- must be the default chat-name!
		["world_channel"]="World", -- must be the default chat-name!
		["GuildChannel"]="Guild Channel",
				
		["msgNbRequest"]="%d request(s) - click to whisper - shift+click to 'who' - ctrl+click to 'invite' - alt+click to 'send role message'",
		["msgLfgRequest"] = "Time since last update %s --- %d requests(s) - click to invite/apply to group",
		["msgRequestHere"] = "Enter here your lfg message.",
		["msgStartWho"]="request who on %s...",
		["msgNewRequest"]="New request by %s for dungeon %s.",
		["msgInit"]="GroupBulletinBoard %s is loaded. Type '/gbb help' to get started.",
		["msgTimeFormat"]="%dm %02ds",
		["msgLevelRange"]="(Level %d - %d)",
		["msgLevelRangeShort"]="(%d-%d)",
		["msgTotalTime"]="Total time %s",
		["msgLastTime"]="Last update %s",
		["msgLocalRestart"]="The setting is not transferred until after a restart (/reload)",
		["msgCustomList"]="Enter your own unique search patterns here. If there is nothing, the English patterns are displayed as a grayed out example.",
		["msgAddNote"]="%s note",
		["msgLastSeen"]="Last Seen:",
		["heroicAbr"]="H",
		["normalAbr"]="N",
		["raidAbr"]="R",
		["msgFontSize"] = "Font Size (Requires /reload)",
		["msgLeaderOutbound"]="Please invite for %s, I am a %s.",
		
		-- option panel
		
		["HeaderSettings"]="Settings",
		["PanelFilter"]="Vanilla Filter",
		["TBCPanelFilter"]="TBC Filter",
		["WotlkPanelFilter"]="Filter",
		["HeaderTags"]="Search patterns",	
		["HeaderTagsCustom"]="Custom search patterns",
		["PanelTags"]="Search patterns",
		["PanelLocales"]="Localization",
		["HeaderChannel"]="Channel",
		["PanelAbout"]="About",
		["HeaderSlashCommand"]="Slash Commands",
		["HeaderCredits"]="Credits",
		["HeaderInfo"]="Information",
		["HeaderUsage"]="Usage",
		["HeaderDungeon"]="Dungeon",
		
		["Cboxshowminimapbutton"]="Show minimap button",	
		["CboxLockMinimapButton"]="Lock minimap button position",		
		["CboxLockMinimapButtonDistance"]="Minimize minimap button distance",
		["CboxShowTotalTime"]="Show total time instead last update",
		["CboxOnDebug"]="Show debug information",
		["CboxNotifyChat"]="On new request make a chat notification",
		["CboxNotifySound"]="On new request make a sound notification",
		["CboxCharFilterLevel"]="Filter on recommended level ranges",
		["CboxColorOnLevel"]="Highlight dungeons on recommended level ranges",
		["CboxTagsEnglish"]="English",
		["CboxTagsGerman"]="German",
		["CboxTagsRussian"]="Russian",
		["CboxTagsFrench"]="French",
		["CboxTagsZhtw"]="Chinese (zh-tw)",
		["CboxTagsZhcn"]="Chinese (zh-cn)",
		["CboxTagsCustom"]="Custom",
		["CboxRemoveRaidSymbols"]="Remove raid symbols like {rt1}",
		["CboxOrderNewTop"]="Sort new requests above",
		["CboxColorByClass"]="Colorize name by class",
		["CboxShowClassIcon"]="and show icon",
		["CboxUseAllInLFG"]="Show all messages from lfg-channel",
		["CboxEscapeQuit"]="ESC close main window (Restart needed)",
		["CboxEnableShowOnly"]="Show a fixed number of requests per dungeon",
		["CboxDisplayLFG"] = "Display LFG Bar (requires /reload)",
		["CboxChatStyle"]="Use more chat style design",
		["CboxCharDontFilterOwn"]="Don't filter own request",		 
		["CboxCharHeroicOnly"]="Heroic only filter",	
		["CboxCharNormalOnly"]="Normal only filter",  
		["CboxDontTrunicate"]="Don't truncate message",
		["CboxOneLineNotification"]="Small one line chat notification",
		["CboxCompactStyle"]="Use two line design",
		["CboxEnableGroup"]="Remember past group members",
		["CboxEnableGuild"]="Add guild in player tooltip",
		["CboxCombineSubDungeons"]="Combine sub-dungeons like Dire Maul (only new request)",
		["CboxAdditionalInfo"]="Add more info to chat on /who and when somebody comes online",
		
		["CboxNotfiyInnone"]="Enable on overworld",
		["CboxNotfiyInpvp"]="Enable in battleground",
		["CboxNotfiyInparty"]="Enable in dungeon",
		["CboxNotfiyInraid"]="Enable in raid dungeon",
		
		["EditShowOnlyNb"]="Number of requests:",
		["EditTimeOut"]="Time before removing (sec):",	
		["EditCustom_Search"]="Search words (lfg, lfm,...)",
		["EditCustom_Bad"]="Blacklist words",
		["EditCustom_Suffix"]="Suffixes",
		["EditCustom_Heroic"] = "Heroic",
		
		["BtnUnselectAll"]="Unselect all",
		["BtnSelectAll"]="Select all",
		
		["BtnWhisper"]="Whisper %s",
		["BtnInvite"]="Invite %s",
		["BtnWho"]="Who %s",
		["BtnIgnore"]="Ignore %s",
		["BtnFold"]="Fold",
		["BtnFoldAll"]="Fold all",
		["BtnUnFoldAll"]="Unfold all",
		["BtnCancel"]="Cancel",
		["BtnEntryColor"]="Color of the message",
		["BtnHeroicDungeonColor"]="Color of heroic dungeon tooltip",
		["BtnNormalDungeonColor"]="Color of normal dungeon tooltip",
		["BtnTimeColor"]="Color of the time",
		["BtnNotifyColor"]="Color of the notification message",
		["BtnPlayerNoteColor"]="Color of the player note",
		["BtnColorGuild"]="Colour of the guild text",
		["BtnPostMsg"] = "Post",
		
		["SlashReset"]="Reset main window position",
		["SlashConfig"]="Open configuration",
		["SlashDefault"]="open main window",
		["SlashAbout"]="open about",
		["SlashChatOrganizer"]="Creates a new chat tab if one doesn't already exist, named \"LFG\" with all channels subscribed. Removes LFG heavy spam channels from default chat tab",
		
		["TabRequest"]="Requests",
		["TabGroup"]="Members",
		["TabLfg"]="Tool Requests",
		
		["AboutUsage"]="GBB searches the chat messages for dungeon requests in the background. To whisper a person, simply click on the entry with the left mouse button. For a '/who' a shift + left click is enough. The dungeon list can be filtered in the settings. You can also fold this by left-clicking on the dungeon name.|nOld entries are filtered out after 150 seconds.",
			
		["AboutSlashCommand"]="<value> can be true, 1, enable, false, 0, disable. If <value> is omitted, the current status switches.",
		
		
		["AboutInfo"]="GBB provides an overview of the endless requests in the chat channels. It detects all requests to the classic dungeons, sorts them and presents them clearly way. Numerous filtering options reduce the gigantic number to exactly the dungeons that interest you. And if that's not enough, GBB will let you know about any new request via a sound or chat notification. And finally, GBB can post your request repeatedly.",
		["AboutCredits"]="Original by GPI / Erytheia-Razorfen",
		
		-- 自行加入
		["Title"]="LFGBulletinBoard",
		["CfgTitle"]="LFGBulletinBoard",
		["ToggleUI"] = "Open/Close LFGBulletinBoard",
		
	},
	zhTW = {
		["lfg_channel"]="尋求組隊", -- must be the default chat-name!
		["world_channel"]="綜合", -- must be the default chat-name!
		["GuildChannel"]="公會",
		
		["msgNbRequest"]="%d 個尋求組隊 - 左鍵:密語 - Shift+左鍵:查詢who - Ctrl+左鍵:邀請進組 - Alt+左鍵:傳送角色職責訊息",
		["msgLfgRequest"] = "上次更新 %s前 --- %d 個隊伍登錄 - 左鍵:密語 - Shift+左鍵:查詢who - Ctrl+左鍵:邀請/加入隊伍",
		["msgStartWho"]="查詢 who 於 %s...",
		["msgNewRequest"]="新的尋求組隊 %s 尋找地城 %s.",
		["msgInit"]="組隊佈告欄 %s 已載入，輸入 '/gbb help' 開始使用。",
		["msgTimeFormat"]="%d分 %02d秒",
		["msgLevelRange"]="(等級 %d - %d)",
		["msgLevelRangeShort"]="(%d-%d)",
		["msgTotalTime"]="總時長 %s",
		["msgLastTime"]="最後更新 %s",
		["msgLocalRestart"]="新的設定需要重新載入(/reload)才會被啟用",
		["msgCustomList"]="在此輸入你自己的搜尋關鍵字，如果未輸入， 將以灰字顯示英文關鍵字範例。",
		["msgAddNote"]="%s 註記",
		["msgLastSeen"]="最後可見:",
		["heroic"]="英雄", 
		["heroicAbr"]="H",
		["normalAbr"]="N",
		["raidAbr"]="R",
		["msgFontSize"] = "字體大小 (需要重新載入)",
		["msgLeaderOutbound"]="請邀請 %s，我是 %s。",
		
		-- option panel
		
		["HeaderSettings"]="設定",
		["PanelFilter"]="經典時代過濾",
		["TBCPanelFilter"]="燃燒遠征過濾",
		["WotlkPanelFilter"]="巫妖王過濾",
		["HeaderTags"]="搜尋關鍵字",	
		["HeaderTagsCustom"]="自訂搜尋關鍵字",
		["PanelTags"]="搜尋關鍵字",
		["PanelLocales"]="中文化",
		["HeaderChannel"]="頻道",
		["PanelAbout"]="關於",
		["HeaderSlashCommand"]="斜線指令",
		["HeaderCredits"]="製作群",
		["HeaderInfo"]="資訊",
		["HeaderUsage"]="使用方式",
		["HeaderDungeon"]="地城",
		
		["Cboxshowminimapbutton"]="顯示小地圖按鈕",	
		["CboxLockMinimapButton"]="鎖定小地圖按鈕位置",		
		["CboxLockMinimapButtonDistance"]="固定在小地圖上",
		["CboxShowTotalTime"]="顯示總時間而不是最後更新",
		["CboxOnDebug"]="顯示除錯資訊",
		["CboxNotifyChat"]="有新尋求組隊時顯示聊天通知",
		["CboxNotifySound"]="有新尋求組隊時顯示聲音通知",
		["CboxCharFilterLevel"]="過濾建議的等級區間",
		["CboxColorOnLevel"]="強調地城建議等級區間",
		["CboxTagsEnglish"]="英文",
		["CboxTagsGerman"]="德文",
		["CboxTagsRussian"]="俄文",
		["CboxTagsFrench"]="法文",
		["CboxTagsZhtw"]="中文 (繁體)",
		["CboxTagsZhcn"]="中文 (簡體)",
		["CboxTagsCustom"]="自訂",
		["CboxRemoveRaidSymbols"]="移除團隊圖示 如 {rt1}",
		["CboxOrderNewTop"]="排序愈新的顯示在愈上面",
		["CboxColorByClass"]="根據職業著色名字",
		["CboxShowClassIcon"]="並顯示圖示",
		["CboxUseAllInLFG"]="顯示來自組隊頻道的所有訊息",
		["CboxEscapeQuit"]="ESC 關閉主視窗 (需要重啟)",
		["CboxEnableShowOnly"]="在每個地城顯示尋求組隊的數量",
		["CboxDisplayLFG"] = "顯示文字輸入欄位 (需要 /reload)",
		["CboxChatStyle"]="使用聊天樣式設計",
		["CboxCharDontFilterOwn"]="不要過濾自己的請求",		 
		["CboxCharHeroicOnly"]="只顯示英雄",	 
		["CboxCharNormalOnly"]="只顯示普通",  
		["CboxDontTrunicate"]="不要斷行訊息",
		["CboxOneLineNotification"]="小的單行聊天通知",
		["CboxCompactStyle"]="使用雙行樣式",
		["CboxEnableGroup"]="記得過去的團隊成員",
		["CboxEnableGuild"]="新增公會於玩家提示",
		["CboxCombineSubDungeons"]="合併次副本如 厄運之槌 (僅新尋求組隊生效)",
		["CboxAdditionalInfo"]="當某人回到線上時新增更多資訊於聊天室窗於 /who",
		
		["CboxNotfiyInnone"]="於 overworld 時啟用",
		["CboxNotfiyInpvp"]="於戰場時啟用",
		["CboxNotfiyInparty"]="於地城時啟用",
		["CboxNotfiyInraid"]="於團隊副本時啟用",
		
		["EditShowOnlyNb"]="尋求組隊數量:",
		["EditTimeOut"]="移除時間 (秒):",	
		["EditCustom_Search"]="搜尋關鍵字 (lfg, lfm,...)",
		["EditCustom_Bad"]="黑名單關鍵字",
		["EditCustom_Suffix"]="後置詞",
		["EditCustom_Heroic"] = "英雄",
		
		["BtnUnselectAll"]="取消全選",
		["BtnSelectAll"]="全選",
		
		["BtnWhisper"]="密語 %s",
		["BtnInvite"]="邀請 %s",
		["BtnWho"]="Who %s",
		["BtnIgnore"]="忽略 %s",
		["BtnFold"]="摺疊",
		["BtnFoldAll"]="摺疊全部",
		["BtnUnFoldAll"]="反摺疊全部",
		["BtnCancel"]="取消",
		["BtnEntryColor"]="訊息顏色",
		["BtnHeroicDungeonColor"]="英雄地城提示顏色",
		["BtnNormalDungeonColor"]="普通地城提示顏色",
		["BtnTimeColor"]="時間提示顏色",
		["BtnNotifyColor"]="通知訊息顏色",
		["BtnPlayerNoteColor"]="玩家註記顏色",
		["BtnColorGuild"]="公會文字顏色",
		["BtnPostMsg"] = "張貼",
		
		["SlashReset"]="重設主視窗位置",
		["SlashConfig"]="開啟設定",
		["SlashDefault"]="開啟主視窗",
		["SlashAbout"]="開啟關於",
		["SlashChatOrganizer"]="如果尚未建立, 建立一個新的名為\"LFG\"的視窗,|n包含所有訂閱的頻道. 以避免大量垃圾訊息於預設的聊天視窗",
		
		["TabRequest"]="尋求組隊",
		["TabGroup"]="成員",
		["TabLfg"]="隊伍瀏覽器",
		
		["AboutUsage"]="組隊佈告欄於背景搜尋尋求組隊的聊天訊息。欲密語， 單點左鍵即可。欲查詢 '/who' shift + 左鍵即可. 地城列表可以在設定中被過濾。 你也可以對地城名稱單點左鍵折疊。|n舊的尋求組隊會在150秒後被過濾掉。",
		
		["AboutSlashCommand"]="<value> 可以是 true, 1, enable, false, 0, disable. 如 <value> 未提供, 則會改變目前狀態.",
		
		
		["AboutInfo"]="組隊佈告欄為你分類各種聊天頻道的要求。他會分類各類訊息，然後以清晰的方式顯示給你。各種過濾選項可以讓你找到你想要找的隊伍。還可以通過聲音或聊天通知讓您知道新請求。",
		["AboutCredits"]="作者: GPI / Erytheia-Razorfen，此為彩虹ui 優化翻譯的版本",
		
		-- 自行加入
		["Title"]="組隊佈告欄",
		["CfgTitle"]="副本-佈告欄",
		["ToggleUI"] = "顯示組隊佈告欄",

	},
	zhCN = {
		["lfg_channel"]="寻求组队", -- must be the default chat-name!
		["world_channel"]="综合", -- must be the default chat-name!
		["GuildChannel"]="公会",

		["msgNbRequest"]="%d 个寻求组队 - 左键:密语 - shift+左键:查询who - ctrl+左键:邀请进组 - 繁中化:帕尔缇娜@伊弗斯|n",
		["msgStartWho"]="查询 who 于 %s...",
		["msgNewRequest"]="新的寻求组队 %s 寻找地下城 %s.",
		["msgInit"]="GroupBulletinBoard %s 已载入. 输入 '/gbb help' 开始使用.",
		["msgTimeFormat"]="%d分 %02d秒",
		["msgLevelRange"]="(等级 %d - %d)",
		["msgLevelRangeShort"]="(%d-%d)",
		["msgTotalTime"]="总时长 %s",
		["msgLastTime"]="最后更新 %s",
		["msgLocalRestart"]="这些设置直到重新启动(/reload)前不会被载入",
		["msgCustomList"]="在此输入你自己的独特寻找 patterns. 如果未输入, 英文 patterns 会以灰字显示范例.",
		["msgAddNote"]="%s 标注",
		["msgLastSeen"]="最后可见:",
		["heroic"]="英雄",
		["heroicAbr"]="H",
		["normalAbr"]="N",
		["raidAbr"]="R",
		["msgFontSize"] = "字体大小 (需要 /reload)",

		-- option panel

		["HeaderSettings"]="设置",
		["PanelFilter"]="经典时代过滤",
		["TBCPanelFilter"]="燃烧远征过滤",
		["HeaderTags"]="搜寻 patterns",
		["HeaderTagsCustom"]="自订搜寻 patterns",
		["PanelTags"]="搜寻 patterns",
		["PanelLocales"]="本地化",
		["HeaderChannel"]="频道",
		["PanelAbout"]="关于",
		["HeaderSlashCommand"]="斜线令",
		["HeaderCredits"]="制作群",
		["HeaderInfo"]="咨询",
		["HeaderUsage"]="使用方式",
		["HeaderDungeon"]="地下城",

		["Cboxshowminimapbutton"]="显示小地图按钮",
		["CboxLockMinimapButton"]="锁定小地图按钮位置",
		["CboxLockMinimapButtonDistance"]="固定在小地图上",
		["CboxShowTotalTime"]="显示总时间而不是最后更新",
		["CboxOnDebug"]="显示除錯咨询",
		["CboxNotifyChat"]="有新寻求组队时显示聊天通知",
		["CboxNotifySound"]="有新寻求组队时进行声音提示",
		["CboxCharFilterLevel"]="过滤建议的等级区间",
		["CboxColorOnLevel"]="强调地下城建议等级区间",
		["CboxTagsEnglish"]="英文",
		["CboxTagsGerman"]="德文",
		["CboxTagsRussian"]="俄文",
		["CboxTagsFrench"]="法文",
		["CboxTagsZhtw"]="中文 (台灣)",
		["CboxTagsZhcn"]="中文 (简体)",
		["CboxTagsCustom"]="自订",
		["CboxRemoveRaidSymbols"]="移除团队图标 如 {rt1}",
		["CboxOrderNewTop"]="排序越新的显示越上面",
		["CboxColorByClass"]="名字依职业著色",
		["CboxShowClassIcon"]="並显示图标",
		["CboxUseAllInLFG"]="显示來自组队频道的所有讯息",
		["CboxEscapeQuit"]="ESC 关闭主窗口 (需要重启)",
		["CboxEnableShowOnly"]="在每个地下城显示寻求组队的數量",
		["CboxDisplayLFG"] = "显示组队条 (需要 /reload)",
		["CboxChatStyle"]="使用聊天样式设计",
		["CboxCharDontFilterOwn"]="不要过滤自 己的请求",
		["CboxCharHeroicOnly"]="只显示英雄",
		["CboxCharNormalOnly"]="只显示普通",
		["CboxDontTrunicate"]="讯息文字是否全部展示",
		["CboxOneLineNotification"]="小的单行聊天通知",
		["CboxCompactStyle"]="使用双行样式",
		["CboxEnableGroup"]="记得过去的团队成员",
		["CboxEnableGuild"]="新增公会于玩家提示",
		["CboxCombineSubDungeons"]="合并次副本如 厄运之槌 (仅新寻求组队生效)",
		["CboxAdditionalInfo"]="当某人回到线上时新增更多资讯于聊天室窗于 /who",

		["CboxNotfiyInnone"]="在 overworld 时启用",
		["CboxNotfiyInpvp"]="在战场时启用",
		["CboxNotfiyInparty"]="再地下城时启用",
		["CboxNotfiyInraid"]="在团队副本时启用",

		["EditShowOnlyNb"]="寻求组队数量:",
		["EditTimeOut"]="移除时间 (秒):",
		["EditCustom_Search"]="搜寻关键字 (lfg, lfm,...)",
		["EditCustom_Bad"]="黑名单关键字",
		["EditCustom_Suffix"]="后置词",
		["EditCustom_Heroic"] = "英雄",

		["BtnUnselectAll"]="取消全选",
		["BtnSelectAll"]="全选",

		["BtnWhisper"]="密语 %s",
		["BtnInvite"]="邀请 %s",
		["BtnWho"]="Who %s",
		["BtnIgnore"]="忽略 %s",
		["BtnFold"]="折叠",
		["BtnFoldAll"]="折叠全部",
		["BtnUnFoldAll"]="反折叠全部",
		["BtnCancel"]="取消",
		["BtnEntryColor"]="资讯颜色色",
		["BtnHeroicDungeonColor"]="英雄地下城提示颜色",
		["BtnNormalDungeonColor"]="普通地下城提示颜色",
		["BtnTimeColor"]="时间提示颜色",
		["BtnNotifyColor"]="通知讯息颜色",
		["BtnPlayerNoteColor"]="玩家姓名颜色",
		["BtnColorGuild"]="公会文字颜色",
		["BtnPostMsg"] = "发布",

		["SlashReset"]="重设主窗口位置",
		["SlashConfig"]="开启设置",
		["SlashDefault"]="开启主窗口",
		["SlashAbout"]="开启关于",
		["SlashChatOrganizer"]="如果尚未建立, 建立一個新的名为\"LFG\"的窗口,|n包含所有订阅的频道. 以避免大量垃圾讯息于预设的聊天窗口",

		["TabRequest"]="寻求组队",
		["TabGroup"]="成员",

		["AboutUsage"]="GBB 在背景搜寻寻求组队的聊天讯息. 密語：单击左键. 查詢：'/who' shift + 左键. 地下城列表可以在设置中被过滤. 你也可以对地下城名称单击左键折叠.|n旧的寻求组队会在150秒后被过滤掉.",

		["AboutSlashCommand"]="<value> 可以是 true, 1, enable, false, 0, disable. 如 <value> 未提供, 则会改变目标状态。",


		["AboutInfo"]="GBB provides an overview of the endless requests in the chat channels. It detects all requests to the classic dungeons, sorts them and presents them clearly way. Numerous filtering options reduce the gigantic number to exactly the dungeons that interest you. And if that's not enough, GBB will let you know about any new request via a sound or chat notification. And finally, GBB can post your request repeatedly.",
		["AboutCredits"]="Original by GPI / Erytheia-Razorfen",
	},

}
		
GBB.locales.esES=GBB.locales.esMX
GBB.locales.enUS=GBB.locales.enGB

function GBB.LocalizationInit()
	local locale = GetLocale()
	local l = GBB.locales[locale] or {}

	if GroupBulletinBoardDB and GroupBulletinBoardDB.CustomLocales and type(GroupBulletinBoardDB.CustomLocales) == "table" then
		for key,value in pairs(GroupBulletinBoardDB.CustomLocales) do
			if value~=nil and value ~="" then
				l[key.."_org"]=l[key] or GBB.locales.enGB[key]
				l[key]=value
			end
		end
	end
	
	-- 加入按鍵設定的翻譯
	BINDING_HEADER_GBB = l["Title"]
	BINDING_NAME_GBB_TOGGLE_UI = l["ToggleUI"]

	-- Needed to not cause overflow when using english
	if (locale ~= "enGB" and locale ~= "enUS") then
		setmetatable(l, {__index = function (t, k)  
			if GBB.l and GBB.l[k] then 
				return GBB.l[k]
			elseif GBB.locales.enGB and GBB.locales.enGB[k] then
				return GBB.locales.enGB[k]
			else
				return "["..k.."]"
			end	
		end})
	end
	return l
end
