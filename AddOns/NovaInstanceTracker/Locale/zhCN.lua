--Big thanks to VJ KOKUSHO for translating the TW version of this addon.
--There is no TW version of wowhead and NovaInstanceTracker wouldn't work in TW without him.

local L = LibStub("AceLocale-3.0"):NewLocale("NovaInstanceTracker", "zhTW");
if (not L) then
	return;
end

L["noTimer"] = "未取得"; --No timer (used only in map timer frames)
L["noCurrentTimer"] = "未取得"; --No current timer
L["noActiveTimers"] = "未启动";	--No active timers
L["second"] = "秒"; --Second (singular).
L["seconds"] = "秒"; --Seconds (plural).
L["minute"] = "分"; --Minute (singular).
L["minutes"] = "分"; --Minutes (plural).
L["hour"] = "小时"; --Hour (singular).
L["hours"] = "小时"; --Hours (plural).
L["day"] = "天"; --Day (singular).
L["days"] = "天"; --Days (plural).
L["secondMedium"] = "秒"; --Second (singular).
L["secondsMedium"] = "秒"; --Seconds (plural).
L["minuteMedium"] = "分"; --Minute (singular).
L["minutesMedium"] = "分"; --Minutes (plural).
L["hourMedium"] = "小时"; --Hour (singular).
L["hoursMedium"] = "小时"; --Hours (plural).
L["dayMedium"] = "天"; --Day (singular).
L["daysMedium"] = "天"; --Days (plural).
L["secondShort"] = "秒"; --Used in short timers like 1m30s (single letter only, usually the first letter of seconds).
L["minuteShort"] = "分"; --Used in short timers like 1m30s (single letter only, usually the first letter of minutes).
L["hourShort"] = "小时"; --Used in short timers like 1h30m (single letter only, usually the first letter of hours).
L["dayShort"] = "天"; --Used in short timers like 1d8h (single letter only, usually the first letter of days).
L["startsIn"] = "在 %s 后开始"; --"Starts in 1hour".
L["endsIn"] = "在 %s 后结束"; --"Ends in 1hour".
L["versionOutOfDate"] = "你的<Nova副本追踪>插件已经过期了，请上https://www.curseforge.com/wow/addons/nova-instance-tracker 更新，或通过twitch客户端更新。";
L["Options"] = " 选项";
L["Reset Data"] = "重置资料"; --A button to Reset buffs window data.

L["Error"] = "错误";
L["delete"] = "删除";
L["confirmInstanceDeletion"] = "确认删除纪录";
L["confirmCharacterDeletion"] = "确认删除角色";

-------------
---Config---
-------------
--There are 2 types of strings here, the names end in Title or Desc L["exampleTitle"] and L["exampleDesc"].
--Title must not be any longer than 21 characters (maybe less for chinese characters because they are larger).
--Desc can be any length.

---General Options---
L["generalHeaderDesc"] = "一般设定";

L["chatColorTitle"] = "聊天讯息颜色";
L["chatColorDesc"] = "在聊天讯息显示什麽颜色?";

L["resetColorsTitle"] = "重置颜色";
L["resetColorsDesc"] = "将颜色重置为预设。";

L["timeStampFormatTitle"] = "时间戳记格式";
L["timeStampFormatDesc"] = "设定使用的时间戳记格式，12小时或24小时。";

L["timeStampZoneTitle"] = "本地时间/伺服器时间";
L["timeStampZoneDesc"] = "使用本地时间或是伺服器时间";

L["minimapButtonTitle"] = "显示小地图按钮";
L["minimapButtonDesc"] = "在小地图显示NIT按钮?";

---Sounds---
L["soundsHeaderDesc"] = "音效";

L["soundsTextDesc"] = "设定音效为 \"None\" 以关闭。";

L["disableAllSoundsTitle"] = "关闭所有音效";
L["disableAllSoundsDesc"] = "关闭这个插件的所有声音";

L["extraSoundOptionsTitle"] = "额外音效选项";
L["extraSoundOptionsDesc"] = "Enable this to display all the sounds from all your addons at once in the dropdown lists here.";

L["notesHeaderDesc"] = "注意事项:";
L["notesDesc"] = "此插件尽最大的努力去计算你的暴本时间，但暴雪的锁定係统有时会出错，您可能会在达到暴本限制之前被锁定。有时您每小时只能进入副本4次，但有时您每小时可进入副本6次。";

L["logHeaderDesc"] = "纪录视窗";

L["openInstanceLogFrameTitle"] = "开启副本纪录";

L["logSizeTitle"] = "纪录中显示多少副本";
L["logSizeDesc"] = "你想要在纪录中显示多少纪录? 最多300条，预设为100条 (你可以输入 /NIT 显示纪录)。";

L["enteredMsgTitle"] = "副本进入纪录";
L["enteredMsgDesc"] = "这将会在你进入副本时在聊天室窗出现一个X，让你如果想删除此副本追踪纪录时使用。";

L["raidEnteredMsgTitle"] = "团本进入通报";
L["raidEnteredMsgDesc"] = "这将会在你进入团本时在聊天室窗出现一个X，让你如果想删除此副本追踪纪录时使用。";

L["pvpEnteredMsgTitle"] = "PvP 进入通报";
L["pvpEnteredMsgDesc"] = "这将会在你进入PVP事件时在聊天室窗出现一个X，让你如果想删除此副本追踪纪录时使用";

L["noRaidInstanceMergeMsgTitle"] = "隐藏副本合併";
L["noRaidInstanceMergeMsgDesc"] = "当你进入同一个副本并合併ID时，隐藏通报讯息。";

L["instanceResetMsgTitle"] = "副本重置通报";
L["instanceResetMsgDesc"] = "当你是队长的时候这个选项将会通报你的团员你已经成功重置副本。 例如: \"法力墓地已经重置。\"";

L["showMoneyTradedChatTitle"] = "在聊天中显示金钱交易";
L["showMoneyTradedChatDesc"] = "当你与某人交易金钱时在聊天室窗通报。 (帮助你追踪你跟谁交易了金钱).";

L["instanceStatsHeaderDesc"] = "结束副本追踪回报";

L["instanceStatsTextDesc"] = "在这里选择当你离开副本要在团队或是聊天视窗显示副本追踪讯息。";

L["instanceStatsOutputTitle"] = "显示状态";
L["instanceStatsOutputDesc"] = "在你离开地层时显示状态?";
			
L["instanceStatsOutputWhereTitle"] = "状态显示位置";
L["instanceStatsOutputWhereDesc"] = "你想要在哪边显示状态?在你自己的聊天视窗或是群组聊天?";

L["instanceStatsOutputMobCountTitle"] = "显示杀怪数量";
L["instanceStatsOutputMobCountDesc"] = "在地城中显示杀了多少怪?";

L["instanceStatsOutputXPTitle"] = "显示经验值";
L["instanceStatsOutputXPDesc"] = "在地城中显示得到了多少经验值?";

L["instanceStatsOutputAverageXPTitle"] = "显示平均经验值";
L["instanceStatsOutputAverageXPDesc"] = "在地城中显示每次击杀的平均经验值？";

L["instanceStatsOutputTimeTitle"] = "显示时间";
L["instanceStatsOutputTimeDesc"] = "显示你在地城里花了多少时间?";

L["instanceStatsOutputGoldTitle"] = "显示获得金币";
L["instanceStatsOutputGoldDesc"] = "在地城中显示你从怪物身上获得多少金币?";

L["instanceStatsOutputAverageGroupLevelDesc"] = "显示平均等级";
L["instanceStatsOutputAverageGroupLevelTitle"] = "在地城中显示平均等级?";

L["showAltsLogTitle"] = "显示分身";
L["showAltsLogDesc"] = "在副本纪录显示分身?";

L["timeStringTypeTitle"] = "时间格式";
L["timeStringTypeDesc"] = "What time string format to use in the instance log?\n|cFFFFFF00Long:|r 1 minute 30 seconds\n|cFFFFFF00Medium|r: 1 min 30 secs\n|cFFFFFF00Short|r 1m30s";

L["showLockoutTimeTitle"] = "显示锁定时间";
L["showLockoutTimeDesc"] = "This will show lockout time left in the instance log for instances within the past 24 hours, with this unticked it will show the time entered instead like in older versions.";

L["colorsHeaderDesc"] = "颜色"

L["mergeColorTitle"] = "合併追踪颜色";
L["mergeColorDesc"] = "当同一个副本纪录合併时要使用什麽颜色?";

L["detectSameInstanceTitle"] = "删除重複的副本纪录";
L["detectSameInstanceDesc"] = "当你重进副本时，自动删除同一个副本产生的第二个纪录?";

L["showStatsInRaidTitle"] = "在团本显示追踪状态";
L["showStatsInRaidDesc"] = "在团本显示追踪?关掉这个选项，只有在五人副本显示追踪状态 (这个选项只有作用在当你选择在团队发送状态作用。).";

L["printRaidInsteadTitle"] = "出团时显示";
L["printRaidInsteadDesc"] = "您可以选择禁用向团队聊天发送追踪数据，那麽这会将它们出现在你的聊天视窗，以便你仍然可以看到它们。";

L["statsOnlyWhenActivityTitle"] = "实际行动";
L["statsOnlyWhenActivityDesc"] = "只有在你实际得到经验值或是金钱或是击杀怪物才启动。, got xp, looted some gold etc. This will make it not show empty stats.";

L["show24HourOnlyTitle"] = "只显示最后24小时";
L["show24HourOnlyDesc"] = "只显示最后24小时的副本纪录?";

L["trimDataHeaderDesc"] = "清除资料";

L["trimDataBelowLevelTitle"] = "移除低于几等的角色";
L["trimDataBelowLevelDesc"] = "设定移除低于几级的角色纪录，那所有低于几级的角色纪录将会被删除。";

L["trimDataBelowLevelButtonTitle"] = "移除角色";
L["trimDataBelowLevelButtonDesc"] = "Click this button to remove all characters with the selected level and lower from this addon database.";

L["trimDataTextDesc"] = "从资料库移除多个角色:";
L["trimDataText2Desc"] = "从资料库移除一个角色:";

L["trimDataCharInputTitle"] = "移除一个角色的输入";
L["trimDataCharInputDesc"] = "在此处键入要删除的角色，格式为 姓名-伺服器 (名字区分大小写). 注意: 这将永久删除增益计数数据。";

L["trimDataBelowLevelButtonConfirm"] = "您确定要从资料库中删除等级 %s 以下的所有角色吗？";
L["trimDataCharInputConfirm"] = "您确定要从资料库中删除 %s 这个角色吗?";

L["trimDataMsg2"] = "删除等级 %s 以下的所有角色。";
L["trimDataMsg3"] = "移除: %s.";
L["trimDataMsg4"] = "完成，找不到任何角色。";
L["trimDataMsg5"] = "完成，移除 %s 角色。";
L["trimDataMsg6"] = "请出入正确的角色名字删除资料。";
L["trimDataMsg7"] = "这个角色名 %s 不存在这个伺服器, 请输入 名字-伺服器。";
L["trimDataMsg8"] = "从资料库删除 %s 时发生错误，, 找不到角色 (名字区分大小写).";
L["trimDataMsg9"] = "从资料库移除 %s 。";

L["instanceFrameSelectAltMsg"] = "如果\“显示所有分身\”未勾选，则选择要显示的分身。或如果\“显示所有分身\”被勾选，则选择哪个分身 要着色。";

L["enteredDungeon"] = "新的追踪 %s %s， 点击";
L["enteredDungeon2"] = "如果这不是一个新的副本纪录。";
L["enteredRaid"] = "新的追踪 %s，这个团本没有进本次数锁定。";
L["loggedInDungeon"] = "你已登入 %s %s，如果这不是一个新的纪录，点击";
L["loggedInDungeon2"] = "从资料库删除此纪录。";
L["reloadDungeon"] = "插件重载检测到 %s，读取最后副本资料非新建。";
L["thisHour"] = "这个小时";
L["statsError"] = "副本ID %s 搜寻错误。";
L["statsMobs"] = "怪物:";
L["statsXP"] = "经验值:";
L["statsAverageXP"] = "平均经验值/怪物:";
L["statsRunsPerLevel"] = "每一级的次数:";
L["statsRunsNextLevel"] = "到下一级的次数:";
L["statsTime"] = "时间:";
L["statsAverageGroupLevel"] = "团队平均等级:";
L["statsGold"] = "金钱";
L["sameInstance"] = "发现到与上次同样的副本ID %s， 正在合併纪录。";
L["deleteInstance"] = "从资料库删除进本纪录 [%s] %s (%s 之前) 。";
L["deleteInstanceError"] = "删除出错 %s。";
L["countString"] = "你在这小时已进入 %s 次副本，及在这24小时 %s 次。";
L["countStringColorized"] = "在过去一小时你已经进入 %s %s %s 次副本，%s %s %s 在过去24小时";
L["now"] = "现在";
L["in"] = "在";
L["active24"] = "24h lockout active";
L["nextInstanceAvailable"] = "可进入下个副本";
L["gave"] = "支出";
L["received"] = "收到";
L["to"] = "给";
L["from"] = "从";
L["playersStillInside"] = "副本已重置 (有玩家还在旧副本，离开可进入新副本)。";
L["Gold"] = "金钱";
L["gold"] = "金";
L["silver"] = "银";
L["copper"] = "铜";
L["newInstanceNow"] = "现在可以进入一个新的副本";
L["thisHour"] = "这个小时";
L["thisHour24"] = "这24小时";
L["openInstanceFrame"] = "打开事件视窗";
L["openYourChars"] = "打开角色清单";
L["openTradeLog"] = "打开交易纪录";
L["config"] = "设定";
L["thisChar"] = "这隻角色";
L["yourChars"] = "你的角色";
L["instancesPastHour"] = "在过去这个小时的纪录";
L["instancesPastHour24"] = "在过去24小时的纪录";
L["leftOnLockout"] = "解除爆本";
L["tradeLog"] = "交易纪录";
L["pastHour"] = "过去1小时";
L["pastHour24"] = "过去24小时";
L["older"] = "古老纪录";
L["raid"] = "团本";
L["alts"] = "分身";
L["deleteEntry"] = "删除进本纪录";
L["lastHour"] = "最近1小时";
L["lastHour24"] = "最近24小时";
L["entered"] = "进入于";
L["ago"] = "之前";
L["stillInDungeon"] = "目前正在副本中";
L["leftOnLockout"] = "后解除每小时进本锁定";
L["leftOnDailyLockout"] = "后解除每日进本锁定";
L["noLockout"] = "团本无爆本限制";
L["unknown"] = "未知";
L["instance"] = "副本";
L["timeEntered"] = "进入时间";
L["timeLeft"] = "离开时间";
L["timeInside"] = "在副本的时间";
L["mobCount"] = "怪物数量";
L["experience"] = "经验值";
							
L["rawGoldMobs"] = "从怪物获得金币";
L["enteredLevel"] = "进入等级";
L["leftLevel"] = "离开等级";
L["averageGroupLevel"] = "团队平均等级";
L["currentLockouts"] = "现有纪录";
L["repGains"] = "声望提升";
L["groupMembers"] = "团队成员";
L["tradesWhileInside"] = "副本内交易";
L["noDataInstance"] = "这个副本没有纪录。";
L["restedOnlyText"] = "只有休息角色";
L["restedOnlyTextTooltip"] = "只有显示有休息经验的角色? 取消勾选以显示所有角色，例如满等角色或是其他分身。";
L["deleteEntry"] = "删除进本纪录"; --Example: "Delete entry 5";
L["online"] = "在线";
L["maximum"] = "最高";
L["level"] = "等级";
L["rested"] = "休息经验值";
L["realmGold"] = "伺服器金币";
L["total"] = "总额";
L["guild"] = "公会";
L["resting"] = "休息中";
L["notResting"] = "没有休息";
L["rested"] = "休息经验值";
L["restedBubbles"] = "休息泡泡";
L["restedState"] = "休息状态";
L["bagSlots"] = "包包格数";
L["durability"] = "耐久度";
L["items"] = "物品";
L["ammunition"] = "弹药";
L["petStatus"] = "宠物状态";
L["name"] = "名字";
L["family"] = "家庭";
L["happiness"] = "快乐的";
L["loyaltyRate"] = "忠诚度";
L["petExperience"] = "宠物经验";
L["unspentTrainingPoints"] = "未使用的训练点数";
L["professions"] = "专业技能";
L["lastSeenPetDetails"] = "观看宠物详情";
L["currentPet"] = "目前宠物";
L["noPetSummoned"] = "未招唤宠物";
L["lastSeenPetDetails"] = "最后看到的宠物详情";
L["noProfessions"] = "没有找到专业技能。";
L["cooldowns"] = "冷却";
L["left"] = "剩馀"; -- This is left as in "time left";
L["ready"] = "准备好。";
L["pvp"] = "PvP";
L["rank"] = "军阶";
L["lastWeek"] = "上周";
L["attunements"] = "进本条件";
L["currentRaidLockouts"] = "正确的副本冷却";
L["none"] = "None.";

L["instanceStatsOutputRunsPerLevelTitle"] = "每一级的次数";
L["instanceStatsOutputRunsPerLevelDesc"] = "显示每升一级的次数?";

L["instanceStatsOutputRunsNextLevelTitle"] = "升级所需的次数";
L["instanceStatsOutputRunsNextLevelDesc"] = "显示还需要几次副本可以升级?";

L["instanceWindowWidthTitle"] = "事件视窗宽度";
L["instanceWindowWidthDesc"] = "副本追踪视窗要多宽。";

L["instanceWindowHeightTitle"] = "事件视窗高度";
L["instanceWindowHeghtDesc"] = "副本追踪视窗要多高。";

L["charsWindowWidthTitle"] = "角色视窗宽度";
L["charsWindowWidthDesc"] = "角色资讯视窗要多宽。";

L["charsWindowHeightTitle"] = "角色视窗高度";
L["charsWindowHeghtDesc"] = "角色资讯视窗要多高。";

L["tradeWindowWidthTitle"] = "交易视窗宽度";
L["tradeWindowWidthDesc"] = "交易视窗的宽度。";

L["tradeWindowHeightTitle"] = "交易视窗高度";
L["tradeWindowHeghtDesc"] = "交易视窗的宽度。";

L["resetFramesTitle"] = "视窗预设值";
L["resetFramesDesc"] = "重置所有视窗及大小回到预设值。";

L["resetFramesMsg"] = "重置所有视窗大小位置。";														
																																 

L["statsRep"] = "声望:";

L["instanceStatsOutputRepTitle"] = "声望提升";
L["instanceStatsOutputRepDesc"] = "显示在副本里提升了多少声望。";

L["instanceStatsOutputHKTitle"] = "荣誉击杀";
L["instanceStatsOutputHKDesc"] = "显示在战场得到多少点数。";

L["experiencePerHour"] = "经验/小时";

L["instanceStatsOutputXpPerHourTitle"] = "显示经验/小时";
L["instanceStatsOutputXpPerHourDesc"] = "显示在副本每小时多少经验值?";

L["autoDialogueDesc"] = "与NPC自动对话";

L["autoSlavePensTitle"] = "奴隶监狱自动对话";
L["autoSlavePensDesc"] = "自动跟奴隶监狱尾王前NPC对话?";

L["autoCavernsFlightTitle"] = "时光之穴自动飞行";
L["autoCavernsFlightDesc"] = "自动跟时光之穴集合时旁边洞口的龙对话飞下去? (只在 \"主宰之巢\" 任务完成过有效)";

L["autoBlackMorassTitle"] = "黑色沼泽自动拿灯";
L["autoBlackMorassDesc"] = "在进入黑色沼泽时自动跟NPC对话拿灯 (只在 \"龙族的英雄\" 任务完成过有效)";

L["autoSfkDoorTitle"] = "自动影牙开门";
L["autoSfkDoorDesc"] = "自动跟NPC对话开启影牙城堡的门?";

L["honorGains"] = "获得荣誉";
L["Honor"] = "荣誉";
L["Won"] = "赢";
L["Lost"] = "输";
L["Arena"] = "竞技场";
L["Arena Points"] = "竞技场点数";

L["stillInArena"] = "正在竞技场中";
L["stillInBattleground"] = "正在战场中";


L["resetAllInstancesConfirm"] = "是否确定想要删除所有副本纪录?";
L["All Instance log data has been deleted."] = "所有副本纪录已经被删除。";

L["resetAllInstancesTitle"] = "重置纪录资料";
L["resetAllInstancesDesc"] = "这将会重置所有纪录资料并移除所以纪录。这不会重置交易。";

--增加
L["Nova Instance Tracker"] = "Nova 副本进度追踪";
L["NovaInstanceTracker"] = "副本-进度";
L["Nova InstanceTracker"] = "Nova 副本进度追踪";
L["|cFF9CD6DELeft-Click|r "] = "|cFF9CD6DE左键|r ";
L["|cFF9CD6DERight-Click|r "] = "|cFF9CD6DE右键|r ";
L["|cFF9CD6DEShift Left-Click|r "] = "|cFF9CD6DEShift+左键|r ";
L["|cFF9CD6DEShift Right-Click|r "] = "|cFF9CD6DEShift+右键|r ";								 
L["Hold to drag"] = "按住以拖曳";
L["Show All Alts"] = "分身";
L["Show all alts in the instance log? (Lockouts are per character)"] = "显示所有分身的副本追踪纪录?";
L["|cffffff00 (Mouseover names for info)"] = "|cffffff00 (将滑鼠移到姓名处以显示详细内容)";
L["|cffffff00Trade Log"] = "交易纪录";
L["Min Level"] = "对低等级";
L["Copy/Paste"] = "複製/贴上";
L["Chat Window"] = "聊天视窗";
L["Group Chat (Party/Raid)"] = "在队伍回报 (队伍/团队)";
L["Local Time"] = "本地时间";
L["Server Time"] = "伺服器时间";
L["Long"] = "长";
L["Medium"] = "中";
L["Short"] = "短";
L["Lockouts"] = "副本纪录";
L["weeklyQuests"] = "每周任务";
L["openLockouts"] = "打开副本进度"; 
L["Raid Lockouts (Including Alts)"] = "副本进度 (包括分身}";