local TOCNAME,GBB=...

local function getSeasonalDungeons()
    local events = {}

    for eventName, eventData in pairs(GBB.Seasonal) do
		table.insert(events, eventName)
        if GBB.Tool.InDateRange(eventData.startDate, eventData.endDate) then
			GBB.SeasonalActiveEvents[eventName] = true
        end
    end
	return events
end

function GBB.GetDungeonNames()
	local DefaultEnGB={
		["RFC"] = 	"Ragefire Chasm",
		["DM"] = 	"The Deadmines",
		["WC"] = 	"Wailing Caverns",	
		["SFK"] = 	"Shadowfang Keep",
		["STK"] = 	"The Stockade",
		["BFD"] = 	"Blackfathom Deeps",
		["GNO"] = 	"Gnomeregan",
		["RFK"] = 	"Razorfen Kraul",
		["SM2"] =	"Scarlet Monastery",
		["SMG"] = 	"Scarlet Monastery: Graveyard",
		["SML"] = 	"Scarlet Monastery: Library",
		["SMA"] = 	"Scarlet Monastery: Armory",
		["SMC"] = 	"Scarlet Monastery: Cathedral",
		["RFD"] = 	"Razorfen Downs",
		["ULD"] = 	"Uldaman",
		["ZF"] = 	"Zul'Farrak",
		["MAR"] = 	"Maraudon",
		["ST"] = 	"The Sunken Temple",
		["BRD"] = 	"Blackrock Depths",
		["DM2"] = 	"Dire Maul",
		["DME"] = 	"Dire Maul: East",
		["DMN"] = 	"Dire Maul: North",
		["DMW"] = 	"Dire Maul: West",
		["STR"] = 	"Stratholme",
		["SCH"] = 	"Scholomance",
		["LBRS"] = 	"Lower Blackrock Spire",
		["UBRS"] = 	"Upper Blackrock Spire (10)",
		["RAMPS"] = "Hellfire Citadel: Ramparts",
		["BF"] = 	"Hellfire Citadel: Blood Furnace",
		["SP"] = 	"Coilfang Reservoir: Slave Pens",
		["UB"] = 	"Coilfang Reservoir: Underbog",
		["MT"] = 	"Auchindoun: Mana Tombs",
		["CRYPTS"] = "Auchindoun: Auchenai Crypts",
		["SETH"] = 	"Auchindoun: Sethekk Halls",
		["OHB"] = 	"Caverns of Time: Old Hillsbrad",
		["MECH"] = 	"Tempest Keep: The Mechanar",
		["BM"] = 	"Caverns of Time: Black Morass",
		["MGT"] = 	"Magisters' Terrace",
		["SH"] = 	"Hellfire Citadel: Shattered Halls",
		["BOT"] = 	"Tempest Keep: Botanica",
		["SL"] = 	"Auchindoun: Shadow Labyrinth",
		["SV"] = 	"Coilfang Reservoir: Steamvault",
		["ARC"] = 	"Tempest Keep: The Arcatraz",
		["KARA"] = 	"Karazhan",
		["GL"] = 	"Gruul's Lair",
		["MAG"] = 	"Hellfire Citadel: Magtheridon's Lair",
		["SSC"] = 	"Coilfang Reservoir: Serpentshrine Cavern",

		["UK"] = 	"Utgarde Keep",
		["NEX"] = 	"The Nexus",
		["AZN"] = 	"Azjol-Nerub",
		["ANK"] = 	"Ahn’kahet: The Old Kingdom",
		["DTK"] = 	"Drak’Tharon Keep",
		["VH"] = 	"Violet Hold",
		["GD"] = 	"Gundrak",
		["HOS"] = 	"Halls of Stone",
		["HOL"] = 	"Halls of Lightning",
		["COS"] = 	"The Culling of Stratholme",
		["OCC"] = 	"The Oculus",
		["UP"] = 	"Utgarde Pinnacle",
		["FOS"] = 	"Forge of Souls",
		["POS"] = 	"Pit of Saron",
		["HOR"] = 	"Halls of Reflection",
		["CHAMP"] = "Trial of the Champion",
		["NAXX"] = 	"Naxxramas",

		["OS"]   =  "Obsidian Sanctum",
		["VOA"] = 	"Vault of Archavon",
		["EOE"] = 	"Eye of Eternity",
		["ULDAR"] =   "Ulduar",
		["TOTC"] = 	"Trial of the Crusader",
		["RS"] = 	"Ruby Sanctum",
		["ICC"] = 	"Icecrown Citadel",

		["EYE"] = 	"Tempest Keep: The Eye",
		["ZA"] = 	"Zul-Aman",
		["HYJAL"] = "The Battle For Mount Hyjal",
		["BT"] = 	"Black Temple",
		["SWP"] = 	"Sunwell Plateau",
		["ONY"] = 	"Onyxia's Lair (40)",
		["MC"] = 	"Molten Core (40)",
		["ZG"] = 	"Zul'Gurub (20)",
		["AQ20"] = 	"Ruins of Ahn'Qiraj (20)",
		["BWL"] = 	"Blackwing Lair (40)",
		["AQ40"] = 	"Temple of Ahn'Qiraj (40)",
		["NAX"] = 	"Naxxramas (40)",
		["WSG"] = 	"Warsong Gulch (PvP)",
		["AB"] = 	"Arathi Basin (PvP)",
		["AV"] = 	"Alterac Valley (PvP)",
		["EOTS"] =  "Eye of the Storm (PvP)",
		["SOTA"] =   "Stand of the Ancients (PvP)",
		["WG"]  =   "Wintergrasp (PvP)",
		["ARENA"] = "Arena (PvP)",
		["MISC"] = 	"Miscellaneous",
		["TRADE"] =	"Trade",
		["DEBUG"] = "DEBUG INFO",
		["BAD"] =	"DEBUG BAD WORDS - REJECTED",
		["BREW"] =  "Brewfest - Coren Direbrew",
		["HOLLOW"] =  "Hallow's End - Headless Horseman",
		}
		
	local dungeonNamesLocales={ 
		zhTW ={
			["RFC"] = 	"怒焰裂谷",
			["DM"] = 	"死亡礦坑",
			["WC"] = 	"哀嚎洞穴",	
			["SFK"] = 	"影牙城堡",
			["STK"] = 	"監獄",
			["BFD"] = 	"黑暗深淵",
			["GNO"] = 	"諾姆瑞根",
			["RFK"] = 	"剃刀沼澤",
			["SM2"] =	"血色修道院",
			["SMG"] = 	"血色修道院: 墓地",
			["SML"] = 	"血色修道院: 圖書館",
			["SMA"] = 	"血色修道院: 軍械庫",
			["SMC"] = 	"血色修道院: 大教堂",
			["RFD"] = 	"剃刀高地",
			["ULD"] = 	"奧達曼",
			["ZF"] = 	"祖爾法拉克",
			["MAR"] = 	"瑪拉頓",
			["ST"] = 	"阿塔哈卡神廟",
			["BRD"] = 	"黑石深淵",
			["DM2"] = 	"厄運之槌",
			["DME"] = 	"厄運之槌: 東",
			["DMN"] = 	"厄運之槌: 北",
			["DMW"] = 	"厄運之槌: 西",
			["STR"] = 	"斯坦索姆",
			["SCH"] = 	"通靈學院",
			["LBRS"] = 	"黑石塔下層",
			["UBRS"] = 	"黑石塔上層 (10)",
			["RAMPS"] = 	"地獄火壁壘",
			["BF"] = 	"血熔爐",
			["SP"] = 	"奴隸監獄",
			["UB"] = 	"深幽泥沼",
			["MT"] = 	"法力墓地",
			["CRYPTS"] = 	"奧奇奈地穴",
			["SETH"] = 	"塞司克大廳",
			["OHB"] = 	"希爾斯布萊德丘陵舊址",
			["MECH"] = 	"麥克納爾",
			["BM"] = 	"黑色沼澤",
			["MGT"] = 	"博學者殿堂",
			["SH"] = 	"破碎大廳",
			["BOT"] = 	"波塔尼卡",
			["SL"] = 	"暗影迷宮",
			["SV"] = 	"蒸氣洞穴",
			["ARC"] = 	"亞克崔茲",
			--
			["ANK"] =	"安卡罕特：古王國",
			["AZN"] =	"阿茲歐-奈幽",
			["DTK"] =	"德拉克薩隆要塞",
			["GD"] =	"剛德拉克",
			["HOL"] =	"電光大廳",
			["HOS"] =	"石之大廳",
			["COS"] =	"斯坦索姆的抉擇",
			["NEX"] =	"奧核之心",
			["OCC"] =	"奧核之眼",
			["VH"] =	"紫羅蘭堡",
			["UK"] =	"俄特加德要塞",
			["UP"] =	"俄特加德之巔",
			["CHAMP"] =	"勇士試煉",
			["FOS"] =	"眾魂熔爐",
			["POS"] =	"薩倫之淵",
			["HOR"] =	"倒影大廳",
			["VOA"] =	"亞夏梵穹殿",
			["NAXX"] =	"納克薩瑪斯",
			["EOE"] =	"奧核之心: 永恆之眼",
			["OS"] =	"黑曜聖所",
			["ULDAR"] =	"奧杜亞",
			["TOTC"] =	"十字軍試煉",
			["ICC"] =	"冰冠城塞",
			["RS"] =	"晶紅聖所",
			["BREW"] =  "啤酒節 - 柯林．烈酒",
			["SOTA"] =  "遠古灘頭 (PvP)",
			["WG"]  =   "冬握湖 (PvP)",
			["KARA"] = 	"卡拉贊 (10)",
			["GL"] = 	"戈魯爾之巢 (25)",
			["MAG"] = 	"瑪瑟里頓的巢穴 (25)",
			["SSC"] = 	"毒蛇神殿洞穴 (25)",
			["EYE"] = 	"風暴要塞 (25)",
			["ZA"] = 	"祖阿曼 (10)",
			["HYJAL"] = 	"海加爾山 (25)",
			["BT"] = 	"黑暗神廟 (25)",
			["SWP"] = 	"太陽之井高地 (25)",
			["ONY"] = 	"奧妮克希亞的巢穴 (40)",
			["MC"] = 	"熔火之心 (40)",
			["ZG"] = 	"祖爾格拉布 (20)",
			["AQ20"] = 	"安其拉廢墟 (20)",
			["BWL"] = 	"黑翼之巢 (40)",
			["AQ40"] = 	"安其拉 (40)",
			["NAX"] = 	"納克薩瑪斯 (40)",
			["WSG"] = 	"戰歌峽谷 (PvP)",
			["AB"] = 	"阿拉希盆地 (PvP)",
			["AV"] = 	"奧特蘭克山谷 (PvP)",
			["EOTS"] = 	"暴風之眼 (PvP)",
			["ARENA"] = "競技場 (PvP)",
			["MISC"] = 	"未分類",
			["TRADE"] =	"交易",
		},
		zhCN ={
			["UK"] = 	"乌特加德城堡",
			["NEX"] = 	"魔枢",
			["AZN"] = 	"艾卓",
			["ANK"] = 	"安卡赫特：古代王国",
			["DTK"] = 	"达克萨隆要塞",
			["VH"] = 	"紫罗兰监狱",
			["GD"] = 	"古达克",
			["HOS"] = 	"岩石大厅",
			["HOL"] = 	"闪电大厅",
			["COS"] = 	"净化斯坦索姆",
			["OCC"] = 	"魔环",
			["UP"] = 	"乌特加德之巅",
			["FOS"] = 	"灵魂洪炉",
			["POS"] = 	"萨隆深渊",
			["HOR"] = 	"映像大厅",
			["CHAMP"] = "冠军的试炼",
			["NAXX"] = 	"纳克萨玛斯80",

			["OS"]   =  "黑曜石圣殿 红龙",
			["VOA"] = 	"阿尔卡冯的宝库",
			["EOE"] = 	"永恒之眼 蓝龙",
			["ULDAR"] = "奥杜尔",
			["TOTC"] = 	"十字军的试炼",
			["RS"] = 	"红玉圣殿",
			["ICC"] = 	"冰冠碉堡",

			["RFC"] = 	"怒焰峡谷",
			["DM"] = 	"死亡矿坑",
			["WC"] = 	"哀嚎洞穴",
			["SFK"] = 	"影牙城堡",
			["STK"] = 	"监狱",
			["BFD"] = 	"黑暗深渊",
			["GNO"] =  	"诺莫瑞根" ,
			["RFK"] = 	"剃刀沼泽",
			["SM2"] =	"血色修道院",
			["SMG"] = 	"血色修道院: 墓地",
			["SML"] = 	"血色修道院: 图书馆",
			["SMA"] = 	"血色修道院: 武器库",
			["SMC"] = 	"血色修道院: 教堂",
			["RFD"] = 	"剃刀高地",
			["ULD"] = 	"奥达曼",
			["ZF"] = 	"祖尔法拉克",
			["MAR"] = 	"玛拉顿",
			["ST"] = 	"沉默的神庙",
			["BRD"] = 	"黑石深渊",
			["DM2"] = 	"厄运之槌",
			["DME"] = 	"厄運之槌: 东",
			["DMN"] = 	"厄運之槌: 北",
			["DMW"] = 	"厄運之槌: 西",
			["STR"] = 	"斯坦索姆",
			["SCH"] = 	"通灵學院",
			["LBRS"] = 	"黑石塔下层",
			["UBRS"] = 	"黑石塔上层 (10)",
			["RAMPS"] = "地狱火城墙",
			["BF"] = 	"献血熔炉",
			["SP"] = 	"奴隶围栏",
			["UB"] = 	"幽暗沼泽",
			["MT"] = 	"法力陵墓",
			["CRYPTS"] = "奥金尼地穴",
			["SETH"] = 	"塞泰克大厅",
			["OHB"] = 	"旧希尔斯布莱德丘陵",
			["MECH"] = 	"能源舰",
			["BM"] = 	"黑色沼泽",
			["MGT"] = 	"魔导师平台",
			["SH"] = 	"破碎大厅",
			["BOT"] = 	"生态船",
			["SL"] = 	"暗影迷宮",
			["SV"] = 	"蒸汽地窖",
			["ARC"] = 	"禁魔监狱",
			["KARA"] = 	"卡拉赞 (10)",
			["GL"] = 	"格鲁尔之巢 (25)",
			["MAG"] = 	"玛瑟里顿的巢穴 (25)",
			["SSC"] = 	"毒蛇神殿 (25)",
			["EYE"] = 	"风暴要塞 (25)",
			["ZA"] = 	"祖阿曼 (10)",
			["HYJAL"] = "海加尔山 (25)",
			["BT"] = 	"黑暗神庙 (25)",
			["SWP"] = 	"太阳之井高地 (25)",
			["ONY"] = 	"奧妮克希亞的巢穴 (40)",
			["MC"] = 	"熔火之心 (40)",
			["ZG"] = 	"祖尔格拉布 (20)",
			["AQ20"] = 	"安其拉废墟 (20)",
			["BWL"] = 	"黑翼之巢 (40)",
			["AQ40"] = 	"安其拉 (40)",
			["NAX"] = 	"纳克萨玛斯 (40)",
			["WSG"] = 	"战歌峽谷 (PvP)",
			["AB"] = 	"阿拉希盆地 (PvP)",
			["AV"] = 	"奧特兰克山谷 (PvP)",
			["EOTS"] = 	"风暴之眼 (PvP)",
			["MISC"] = 	"未分類",
			["TRADE"] =	"交易",
		},
	}

	
	
	local dungeonNames = dungeonNamesLocales[GetLocale()] or {}
	
	if GroupBulletinBoardDB and GroupBulletinBoardDB.CustomLocalesDungeon and type(GroupBulletinBoardDB.CustomLocalesDungeon) == "table" then
		for key,value in pairs(GroupBulletinBoardDB.CustomLocalesDungeon) do
			if value~=nil and value ~="" then
				dungeonNames[key.."_org"]=dungeonNames[key] or DefaultEnGB[key]
				dungeonNames[key]=value				
			end
		end
	end
	
	
	setmetatable(dungeonNames, {__index = DefaultEnGB})
	
	dungeonNames["DEADMINES"]=dungeonNames["DM"]
	
	return dungeonNames
end

local function Union ( a, b )
    local result = {}
    for k,v in pairs ( a ) do
        result[k] = v
    end
    for k,v in pairs ( b ) do
		result[k] = v
    end
    return result
end

GBB.VanillaDungeonLevels ={
	["RFC"] = 	{13,18}, ["DM"] = 	{18,23}, ["WC"] = 	{15,25}, ["SFK"] = 	{22,30}, ["STK"] = 	{22,30}, ["BFD"] = 	{24,32},
	["GNO"] = 	{29,38}, ["RFK"] = 	{30,40}, ["SMG"] = 	{28,38}, ["SML"] = 	{29,39}, ["SMA"] = 	{32,42}, ["SMC"] = 	{35,45},
	["RFD"] = 	{40,50}, ["ULD"] = 	{42,52}, ["ZF"] = 	{44,54}, ["MAR"] = 	{46,55}, ["ST"] = 	{50,60}, ["BRD"] = 	{52,60},
	["LBRS"] = 	{55,60}, ["DME"] = 	{58,60}, ["DMN"] = 	{58,60}, ["DMW"] = 	{58,60}, ["STR"] = 	{58,60}, ["SCH"] = 	{58,60},
	["UBRS"] = 	{58,60}, ["MC"] = 	{60,60}, ["ZG"] = 	{60,60}, ["AQ20"]= 	{60,60}, ["BWL"] = {60,60},
	["AQ40"] = 	{60,60}, ["NAX"] = 	{60,60}, 
	["MISC"]= {0,100},  
	["DEBUG"] = {0,100}, ["BAD"] =	{0,100}, ["TRADE"]=	{0,100}, ["SM2"] =  {28,42}, ["DM2"] =	{58,60}, ["DEADMINES"]={18,23},
}

GBB.PostTbcDungeonLevels = {
	["RFC"] = 	{13,20}, ["DM"] = 	{16,24}, ["WC"] = 	{16,24}, ["SFK"] = 	{17,25}, ["STK"] = 	{21,29}, ["BFD"] = 	{20,28},
	["GNO"] = 	{24,40}, ["RFK"] = 	{23,31}, ["SMG"] = 	{28,34}, ["SML"] = 	{30,38}, ["SMA"] = 	{32,42}, ["SMC"] = 	{35,44},
	["RFD"] = 	{33,41}, ["ULD"] = 	{36,44}, ["ZF"] = 	{42,50}, ["MAR"] = 	{40,52}, ["ST"] = 	{45,54}, ["BRD"] = 	{48,60},
	["LBRS"] = 	{54,60}, ["DME"] = 	{54,61}, ["DMN"] = 	{54,61}, ["DMW"] = 	{54,61}, ["STR"] = 	{56,61}, ["SCH"] = 	{56,61},
	["UBRS"] = 	{53,61}, ["MC"] = 	{60,60}, ["ZG"] = 	{60,60}, ["AQ20"]= 	{60,60}, ["BWL"] = {60,60},
	["AQ40"] = 	{60,60}, ["NAX"] = 	{60,60}, 
	["MISC"]= {0,100},  
	["DEBUG"] = {0,100}, ["BAD"] =	{0,100}, ["TRADE"]=	{0,100}, ["SM2"] =  {28,42}, ["DM2"] =	{58,60}, ["DEADMINES"]={16,24},
}


GBB.TbcDungeonLevels = { 
	["RAMPS"] =  {60,62}, 	["BF"] = 	 {61,63},     ["SP"] = 	 {62,64},    ["UB"] = 	 {63,65},     ["MT"] = 	 {64,66},     ["CRYPTS"] = {65,67},
	["SETH"] =   {67,69},  	["OHB"] = 	 {66,68},     ["MECH"] =   {69,70},    ["BM"] =      {69,70},    ["MGT"] =	 {70,70},    ["SH"] =	 {70,70}, 
	["BOT"] =    {70,70},    ["SL"] = 	 {70,70},    ["SV"] =     {70,70},   ["ARC"] = 	 {70,70},    ["KARA"] = 	 {70,70},    ["GL"] = 	 {70,70}, 
	["MAG"] =    {70,70},    ["SSC"] =    {70,70}, 	["EYE"] =    {70,70},   ["ZA"] = 	 {70,70},    ["HYJAL"] =  {70,70}, 	["BT"] =     {70,70}, 
	["SWP"] =    {70,70},
}

GBB.PvpLevels = {
	["WSG"] = 	{10,70}, ["AB"] = 	{20,70}, ["AV"] = 	{51,70},   ["WG"] = {80,80}, ["SOTA"] = {80,80},  ["EOTS"] =   {15,70},   ["ARENA"] = {70,80},
}

GBB.WotlkDungeonLevels = {
	["UK"] =    {68,80},    ["NEX"] =    {69,80},    ["AZN"] =    {70,80},    ["ANK"] =    {71,80},    ["DTK"] =    {72,80},    ["VH"] =    {73,80},    
	["GD"] =    {74,80},    ["HOS"] =    {75,80},    ["HOL"] =    {76,80},    ["COS"] =    {78,80},    ["OCC"] =    {77,80},    ["UP"] =    {77,80},    
	["FOS"] =    {80,80},   ["POS"] =    {80,80},    ["HOR"] =    {80,80},    ["CHAMP"] =  {78,80},    ["OS"] =    {80,80},    ["VOA"] =    {80,80},    
	["EOE"] =    {80,80},   ["ULDAR"] =  {80,80},    ["TOTC"] =     {80,80},    ["RS"] =     {80,80},    ["ICC"] =    {80,80},    ["ONY"] =    {80,80},    
	["NAXX"] =   {80,80},   ["BREW"] = {65,70},      ["HOLLOW"] = {65,70},
}

GBB.WotlkDungeonNames = {
	"UK", "NEX", "AZN", "ANK", "DTK", "VH", "GD", "HOS", "HOL", "COS", 
	"OCC", "UP", "FOS", "POS", "HOR", "CHAMP", "OS", "VOA", "EOE", "ULDAR", 
	"TOTC", "RS", "ICC", "ONY", "NAXX"
}

GBB.TbcDungeonNames = { 
	"RAMPS", "BF", "SH", "MAG", "SP", "UB", "SV", "SSC", "MT", "CRYPTS",
	"SETH", "SL", "OHB", "BM", "MECH", "BOT", "ARC", "EYE", "MGT", "KARA",
	"GL", "ZA", "HYJAL", "BT", "SWP",
}

GBB.VanillDungeonNames  = { 
	"RFC", "WC" , "DM" , "SFK", "STK", "BFD", "GNO",
    "RFK", "SMG", "SML", "SMA", "SMC", "RFD", "ULD", 
    "ZF", "MAR", "ST" , "BRD", "LBRS", "DME", "DMN", 
    "DMW", "STR", "SCH", "UBRS", "MC", "ZG", 
    "AQ20", "BWL", "AQ40", "NAX",
}	


GBB.PvpNames = {
	"WSG", "AB", "AV", "EOTS", "WG", "SOTA", "ARENA",
}

GBB.Misc = {"MISC", "TRADE",}

GBB.DebugNames = {
	"DEBUG", "BAD", "NIL",
}

GBB.Raids = {
	"ONY", "MC", "ZG", "AQ20", "BWL", "AQ40", "NAX", 
	"KARA", "GL", "MAG", "SSC", "EYE", "ZA", "HYJAL", 
	"BT", "SWP", "ARENA", "WSG", "AV", "AB", "EOTS",
	"WG", "SOTA", "BREW", "HOLLOW", "OS", "VOA", "EOE", 
	"ULDAR", "TOTC", "RS", "ICC", "NAXX",
}

GBB.Seasonal = {
    ["BREW"] = { startDate = "09/20", endDate = "10/06"},
	["HOLLOW"] = { startDate = "10/18", endDate = "11/01"}
}

GBB.SeasonalActiveEvents = {}
GBB.Events = getSeasonalDungeons()

function GBB.GetRaids()
	local arr = {}
	for _, v in pairs (GBB.Raids) do
		arr[v] = 1
	end
	return arr
end

-- Needed because Lua sucks, Blizzard switch to Python please
-- Takes in a list of dungeon lists, it will then concatenate the lists into a single list
-- it will put the dungeons in an order and give them a value incremental value that can be used for sorting later 
-- ie one list "Foo" which contains "Bar" and "FooBar" and a second list "BarFoo" which contains "BarBar"
-- the output would be single list with "Bar" = 1, "FooBar" = 2, "BarFoo" = 3, "BarBar" = 4
local function ConcatenateLists(Names) 
	local result = {}
	local index = 1
	for k, nameLists in pairs (Names) do 
		for _, v in pairs(nameLists) do 
			result[v] = index
			index = index + 1
		end
	end
	return result, index
end

function GBB.GetDungeonSort()
	for eventName, eventData in pairs(GBB.Seasonal) do
        if GBB.Tool.InDateRange(eventData.startDate, eventData.endDate) then
			table.insert(GBB.WotlkDungeonNames, 1, eventName)
		else
			table.insert(GBB.DebugNames, 1, eventName)
		end
    end
	
	local dungeonOrder = { GBB.VanillDungeonNames, GBB.TbcDungeonNames, GBB.WotlkDungeonNames, GBB.PvpNames, GBB.Misc, GBB.DebugNames}

	-- Why does Lua not having a fucking size function
	 local vanillaDungeonSize = 0
	 for _, _ in pairs(GBB.VanillDungeonNames) do
		vanillaDungeonSize = vanillaDungeonSize + 1
	 end

	 local tbcDungeonSize = 0
	 for _, _ in pairs(GBB.TbcDungeonNames) do
		tbcDungeonSize = tbcDungeonSize + 1
	 end

	local debugSize = 0
	for _, _ in pairs(GBB.DebugNames) do
		debugSize = debugSize+1
	end
	

	local tmp_dsort, concatenatedSize = ConcatenateLists(dungeonOrder)
	local dungeonSort = {}
	
	GBB.TBCDUNGEONSTART = vanillaDungeonSize + 1
	GBB.MAXDUNGEON = vanillaDungeonSize
	GBB.TBCMAXDUNGEON = vanillaDungeonSize  + tbcDungeonSize
	GBB.WOTLKDUNGEONSTART = GBB.TBCMAXDUNGEON + 1
	GBB.WOTLKMAXDUNGEON = concatenatedSize - debugSize - 1
	
	for dungeon,nb in pairs(tmp_dsort) do
		dungeonSort[nb]=dungeon
		dungeonSort[dungeon]=nb
	end

	-- Need to do this because I don't know I am too lazy to debug the use of SM2, DM2, and DEADMINES
	dungeonSort["SM2"] = 10.5
	dungeonSort["DM2"] = 19.5
	dungeonSort["DEADMINES"] = 99 
	
	return dungeonSort
end
	
local function DetermineVanillDungeonRange() 

	return GBB.PostTbcDungeonLevels

end

GBB.dungeonLevel = Union(Union(Union(DetermineVanillDungeonRange(), GBB.TbcDungeonLevels), GBB.WotlkDungeonLevels), GBB.PvpLevels)