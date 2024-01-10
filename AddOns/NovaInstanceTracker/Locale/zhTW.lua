--Big thanks to VJ KOKUSHO for translating the TW version of this addon.
--There is no TW version of wowhead and NovaInstanceTracker wouldn't work in TW without him.

local L = LibStub("AceLocale-3.0"):NewLocale("NovaInstanceTracker", "zhTW");
if (not L) then
	return;
end

L["noTimer"] = "未取得"; --No timer (used only in map timer frames)
L["noCurrentTimer"] = "未取得"; --No current timer
L["noActiveTimers"] = "未啟動";	--No active timers
L["second"] = "秒"; --Second (singular).
L["seconds"] = "秒"; --Seconds (plural).
L["minute"] = "分"; --Minute (singular).
L["minutes"] = "分"; --Minutes (plural).
L["hour"] = "小時"; --Hour (singular).
L["hours"] = "小時"; --Hours (plural).
L["day"] = "天"; --Day (singular).
L["days"] = "天"; --Days (plural).
L["secondMedium"] = "秒"; --Second (singular).
L["secondsMedium"] = "秒"; --Seconds (plural).
L["minuteMedium"] = "分"; --Minute (singular).
L["minutesMedium"] = "分"; --Minutes (plural).
L["hourMedium"] = "小時"; --Hour (singular).
L["hoursMedium"] = "小時"; --Hours (plural).
L["dayMedium"] = "天"; --Day (singular).
L["daysMedium"] = "天"; --Days (plural).
L["secondShort"] = "秒"; --Used in short timers like 1m30s (single letter only, usually the first letter of seconds).
L["minuteShort"] = "分"; --Used in short timers like 1m30s (single letter only, usually the first letter of minutes).
L["hourShort"] = "小時"; --Used in short timers like 1h30m (single letter only, usually the first letter of hours).
L["dayShort"] = "天"; --Used in short timers like 1d8h (single letter only, usually the first letter of days).
L["startsIn"] = "在 %s 後開始"; --"Starts in 1hour".
L["endsIn"] = "在 %s 後結束"; --"Ends in 1hour".
L["versionOutOfDate"] = "你的<Nova Instance Tracker>插件已經過期了，請上https://www.curseforge.com/wow/addons/nova-instance-tracker 更新，或通過twitch客戶端更新。";
L["Options"] = " 選項";
L["Reset Data"] = "重置資料"; --A button to Reset buffs window data.

L["Error"] = "錯誤";
L["delete"] = "刪除";
L["confirmInstanceDeletion"] = "確認刪除紀錄";
L["confirmCharacterDeletion"] = "確認刪除角色";

-------------
---Config---
-------------
--There are 2 types of strings here, the names end in Title or Desc L["exampleTitle"] and L["exampleDesc"].
--Title must not be any longer than 21 characters (maybe less for chinese characters because they are larger).
--Desc can be any length.

---General Options---
L["generalHeaderDesc"] = "一般設定";

L["chatColorTitle"] = "聊天訊息顏色";
L["chatColorDesc"] = "在聊天訊息顯示什麼顏色?";

L["resetColorsTitle"] = "重置顏色";
L["resetColorsDesc"] = "將顏色重置為預設。";

L["timeStampFormatTitle"] = "時間戳記格式";
L["timeStampFormatDesc"] = "設定使用的時間戳記格式，12小時或24小時。";

L["timeStampZoneTitle"] = "本地時間/伺服器時間";
L["timeStampZoneDesc"] = "使用本地時間或是伺服器時間";

L["minimapButtonTitle"] = "顯示小地圖按鈕";
L["minimapButtonDesc"] = "在小地圖顯示NIT按鈕?";

---Sounds---
L["soundsHeaderDesc"] = "音效";

L["soundsTextDesc"] = "設定音效為 \"None\" 以關閉。";

L["disableAllSoundsTitle"] = "關閉所有音效";
L["disableAllSoundsDesc"] = "關閉這個插件的所有聲音";

L["extraSoundOptionsTitle"] = "額外音效選項";
L["extraSoundOptionsDesc"] = "Enable this to display all the sounds from all your addons at once in the dropdown lists here.";

L["notesHeaderDesc"] = "注意事項:";
L["notesDesc"] = "此插件盡最大的努力去計算你的暴本時間，但暴雪的鎖定係統有時會出錯，您可能會在達到暴本限制之前被鎖定。有時您每小時只能進入副本4次，但有時您每小時可進入副本6次。";

L["logHeaderDesc"] = "紀錄視窗";

L["openInstanceLogFrameTitle"] = "開啟副本紀錄";

L["logSizeTitle"] = "紀錄中顯示多少副本";
L["logSizeDesc"] = "你想要在紀錄中顯示多少紀錄? 最多300條，預設為100條 (你可以輸入 /NIT 顯示紀錄).";

L["enteredMsgTitle"] = "副本進入紀錄";
L["enteredMsgDesc"] = "這將會在你進入副本時在聊天室窗出現一個X，讓你如果想刪除此副本追蹤紀錄時使用";

L["instanceResetMsgTitle"] = "副本重置通報";
L["instanceResetMsgDesc"] = "當你是隊長的時候這個選項將會通報你的團員你已經成功重置副本。 例如: \"法力墓地已經重置。\"";

L["showMoneyTradedChatTitle"] = "在聊天中顯示金錢交易";
L["showMoneyTradedChatDesc"] = "當你與某人交易金錢時在聊天室窗通報。 (幫助你追蹤你跟誰交易了金錢).";

L["instanceStatsHeaderDesc"] = "結束副本追蹤回報";

L["instanceStatsTextDesc"] = "在這裡選擇當你離開副本要在團隊或是聊天視窗顯示副本追蹤訊息。";

L["instanceStatsOutputTitle"] = "顯示狀態";
L["instanceStatsOutputDesc"] = "在你離開地層時顯示狀態?";
			
L["instanceStatsOutputWhereTitle"] = "狀態顯示位置";
L["instanceStatsOutputWhereDesc"] = "你想要在哪邊顯示狀態?在你自己的聊天視窗或是群組聊天?";

L["instanceStatsOutputMobCountTitle"] = "顯示殺怪數量";
L["instanceStatsOutputMobCountDesc"] = "在地城中顯示殺了多少怪?";

L["instanceStatsOutputXPTitle"] = "顯示經驗值";
L["instanceStatsOutputXPDesc"] = "在地城中顯示得到了多少經驗值?";

L["instanceStatsOutputAverageXPTitle"] = "顯示平均經驗值";
L["instanceStatsOutputAverageXPDesc"] = "在地城中顯示每次擊殺的平均經驗值？";

L["instanceStatsOutputTimeTitle"] = "顯示時間";
L["instanceStatsOutputTimeDesc"] = "顯示你在地城裡花了多少時間?";

L["instanceStatsOutputGoldTitle"] = "顯示獲得金幣";
L["instanceStatsOutputGoldDesc"] = "在地城中顯示你從怪物身上獲得多少金幣?";

L["instanceStatsOutputAverageGroupLevelDesc"] = "顯示平均等級";
L["instanceStatsOutputAverageGroupLevelTitle"] = "在地城中顯示平均等級?";

L["showAltsLogTitle"] = "顯示分身";
L["showAltsLogDesc"] = "在副本紀錄顯示分身?";

L["timeStringTypeTitle"] = "時間格式";
L["timeStringTypeDesc"] = "What time string format to use in the instance log?\n|cFFFFFF00Long:|r 1 minute 30 seconds\n|cFFFFFF00Medium|r: 1 min 30 secs\n|cFFFFFF00Short|r 1m30s";

L["showLockoutTimeTitle"] = "顯示鎖定時間";
L["showLockoutTimeDesc"] = "This will show lockout time left in the instance log for instances within the past 24 hours, with this unticked it will show the time entered instead like in older versions.";

L["colorsHeaderDesc"] = "顏色"

L["mergeColorTitle"] = "合併追蹤顏色";
L["mergeColorDesc"] = "當同一個副本紀錄合併時要使用什麼顏色?";

L["detectSameInstanceTitle"] = "刪除重複的副本紀錄";
L["detectSameInstanceDesc"] = "當你重進副本時，自動刪除同一個副本產生的第二個紀錄?";

L["showStatsInRaidTitle"] = "在團本顯示追蹤狀態";
L["showStatsInRaidDesc"] = "在團本顯示追蹤?關掉這個選項，只有在五人副本顯示追蹤狀態 (這個選項只有作用在當你選擇在團隊發送狀態作用。).";

L["printRaidInsteadTitle"] = "出團時顯示";
L["printRaidInsteadDesc"] = "您可以選擇禁用向團隊聊天發送追蹤數據，那麼這會將它們出現在你的聊天視窗，以便你仍然可以看到它們。";

L["statsOnlyWhenActivityTitle"] = "實際行動";
L["statsOnlyWhenActivityDesc"] = "只有在你實際得到經驗值或是金錢或是擊殺怪物才啟動。, got xp, looted some gold etc. This will make it not show empty stats.";

L["show24HourOnlyTitle"] = "只顯示最後24小時";
L["show24HourOnlyDesc"] = "只顯示最後24小時的副本紀錄?";

L["trimDataHeaderDesc"] = "清除資料";

L["trimDataBelowLevelTitle"] = "移除低於幾等的角色";
L["trimDataBelowLevelDesc"] = "設定移除低於幾級的角色紀錄，那所有低於幾級的角色紀錄將會被刪除。";

L["trimDataBelowLevelButtonTitle"] = "移除角色";
L["trimDataBelowLevelButtonDesc"] = "Click this button to remove all characters with the selected level and lower from this addon database.";

L["trimDataTextDesc"] = "從資料庫移除多個角色:";
L["trimDataText2Desc"] = "從資料庫移除一個角色:";

L["trimDataCharInputTitle"] = "移除一個角色的輸入";
L["trimDataCharInputDesc"] = "在此處鍵入要刪除的角色，格式為 姓名-伺服器 (名字區分大小寫). 注意: 這將永久刪除增益計數數據。";

L["trimDataBelowLevelButtonConfirm"] = "您確定要從資料庫中刪除等級 %s 以下的所有角色嗎？";
L["trimDataCharInputConfirm"] = "您確定要從資料庫中刪除 %s 這個角色嗎?";

L["trimDataMsg2"] = "刪除等級 %s 以下的所有角色。";
L["trimDataMsg3"] = "移除: %s.";
L["trimDataMsg4"] = "完成，找不到任何角色。";
L["trimDataMsg5"] = "完成，移除 %s 角色。";
L["trimDataMsg6"] = "請出入正確的角色名字刪除資料。";
L["trimDataMsg7"] = "這個角色名 %s 不存在這個伺服器, 請輸入 名字-伺服器。";
L["trimDataMsg8"] = "從資料庫刪除 %s 時發生錯誤，, 找不到角色 (名字區分大小寫).";
L["trimDataMsg9"] = "從資料庫移除 %s 。";

L["instanceFrameSelectAltMsg"] = "如果\“顯示所有分身\”未勾選，則選擇要顯示的分身。或如果\“顯示所有分身\”被勾選，則選擇哪個分身 要著色。";

L["enteredDungeon"] = "新的追蹤 %s %s， 點擊";
L["enteredDungeon2"] = "如果這不是一個新的副本紀錄。";
L["enteredRaid"] = "新的追蹤 %s，這個團本沒有進本次數鎖定。";
L["loggedInDungeon"] = "你已登入 %s %s，如果這不是一個新的紀錄，點擊";
L["loggedInDungeon2"] = "從資料庫刪除此紀錄。";
L["reloadDungeon"] = "插件重載檢測到 %s，讀取最後副本資料非新建。";
L["thisHour"] = "這個小時";
L["statsError"] = "副本ID %s 搜尋錯誤。";
L["statsMobs"] = "怪物:";
L["statsXP"] = "經驗值:";
L["statsAverageXP"] = "平均經驗值/怪物:";
L["statsRunsPerLevel"] = "每一級的次數:";
L["statsRunsNextLevel"] = "到下一級的次數:";
L["statsTime"] = "時間:";
L["statsAverageGroupLevel"] = "團隊平均等級:";
L["statsGold"] = "金錢";
L["sameInstance"] = "發現到與上次同樣的副本ID %s， 正在合併紀錄。";
L["deleteInstance"] = "從資料庫刪除進本紀錄 [%s] %s (%s 之前) 。";
L["deleteInstanceError"] = "刪除出錯 %s。";
L["countString"] = "你在這小時已進入 %s 次副本，及在這24小時 %s 次。";
L["countStringColorized"] = "在過去一小時你已經進入 %s %s %s 次副本，%s %s %s 在過去24小時";
L["now"] = "現在";
L["in"] = "在";
L["active24"] = "24h lockout active";
L["nextInstanceAvailable"] = "可進入下個副本";
L["gave"] = "支出";
L["received"] = "收到";
L["to"] = "給";
L["from"] = "從";
L["playersStillInside"] = "副本已重置 (有玩家還在舊副本，離開可進入新副本)。";
L["Gold"] = "金錢";
L["gold"] = "金";
L["silver"] = "銀";
L["copper"] = "銅";
L["newInstanceNow"] = "現在可以進入一個新的副本";
L["thisHour"] = "這個小時";
L["thisHour24"] = "這24小時";
L["openInstanceFrame"] = "打開事件視窗";
L["openYourChars"] = "打開角色清單";
L["openTradeLog"] = "打開交易紀錄";
L["config"] = "設定";
L["thisChar"] = "這隻角色";
L["yourChars"] = "你的角色";
L["instancesPastHour"] = "在過去這個小時的紀錄";
L["instancesPastHour24"] = "在過去24小時的紀錄";
L["leftOnLockout"] = "解除爆本";
L["tradeLog"] = "交易紀錄";
L["pastHour"] = "過去1小時";
L["pastHour24"] = "過去24小時";
L["older"] = "古老紀錄";
L["raid"] = "團本";
L["alts"] = "分身";
L["deleteEntry"] = "刪除進本紀錄";
L["lastHour"] = "最近1小時";
L["lastHour24"] = "最近24小時";
L["entered"] = "進入於";
L["ago"] = "之前";
L["stillInDungeon"] = "目前正在副本中";
L["leftOnLockout"] = "後解除每小時進本鎖定";
L["leftOnDailyLockout"] = "後解除每日進本鎖定";
L["noLockout"] = "團本無爆本限制";
L["unknown"] = "未知";
L["instance"] = "副本";
L["timeEntered"] = "進入時間";
L["timeLeft"] = "離開時間";
L["timeInside"] = "在副本的時間";
L["mobCount"] = "怪物數量";
L["experience"] = "經驗值";
							
L["rawGoldMobs"] = "從怪物獲得金幣";
L["enteredLevel"] = "進入等級";
L["leftLevel"] = "離開等級";
L["averageGroupLevel"] = "團隊平均等級";
L["currentLockouts"] = "現有紀錄";
L["repGains"] = "聲望提升";
L["groupMembers"] = "團隊成員";
L["tradesWhileInside"] = "副本內交易";
L["noDataInstance"] = "這個副本沒有紀錄。";
L["restedOnlyText"] = "只有休息角色";
L["restedOnlyTextTooltip"] = "只有顯示有休息經驗的角色? 取消勾選以顯示所有角色，例如滿等角色或是其他分身。";
L["deleteEntry"] = "刪除進本紀錄"; --Example: "Delete entry 5";
L["online"] = "在線";
L["maximum"] = "最高";
L["level"] = "等級";
L["rested"] = "休息經驗值";
L["realmGold"] = "伺服器金幣";
L["total"] = "總額";
L["guild"] = "公會";
L["resting"] = "休息中";
L["notResting"] = "沒有休息";
L["rested"] = "休息經驗值";
L["restedBubbles"] = "休息泡泡";
L["restedState"] = "休息狀態";
L["bagSlots"] = "包包格數";
L["durability"] = "耐久度";
L["items"] = "物品";
L["ammunition"] = "彈藥";
L["petStatus"] = "寵物狀態";
L["name"] = "名字";
L["family"] = "家庭";
L["happiness"] = "快樂的";
L["loyaltyRate"] = "忠誠度";
L["petExperience"] = "寵物經驗";
L["unspentTrainingPoints"] = "未使用的訓練點數";
L["professions"] = "專業技能";
L["lastSeenPetDetails"] = "觀看寵物詳情";
L["currentPet"] = "目前寵物";
L["noPetSummoned"] = "未招喚寵物";
L["lastSeenPetDetails"] = "最後看到的寵物詳情";
L["noProfessions"] = "沒有找到專業技能。";
L["cooldowns"] = "冷卻";
L["left"] = "剩餘"; -- This is left as in "time left";
L["ready"] = "準備好。";
L["pvp"] = "PvP";
L["rank"] = "軍階";
L["lastWeek"] = "上周";
L["attunements"] = "進本條件";
L["currentRaidLockouts"] = "正確的副本冷卻";
L["none"] = "None.";

L["instanceStatsOutputRunsPerLevelTitle"] = "每一級的次數";
L["instanceStatsOutputRunsPerLevelDesc"] = "顯示每升一級的次數?";

L["instanceStatsOutputRunsNextLevelTitle"] = "升級所需的次數";
L["instanceStatsOutputRunsNextLevelDesc"] = "顯示還需要幾次副本可以升級?";

L["instanceWindowWidthTitle"] = "事件視窗寬度";
L["instanceWindowWidthDesc"] = "副本追蹤視窗要多寬。";

L["instanceWindowHeightTitle"] = "事件視窗高度";
L["instanceWindowHeghtDesc"] = "副本追蹤視窗要多高。";

L["charsWindowWidthTitle"] = "角色視窗寬度";
L["charsWindowWidthDesc"] = "角色資訊視窗要多寬。";

L["charsWindowHeightTitle"] = "角色視窗高度";
L["charsWindowHeghtDesc"] = "角色資訊視窗要多高。";

L["tradeWindowWidthTitle"] = "交易視窗寬度";
L["tradeWindowWidthDesc"] = "交易視窗的寬度。";

L["tradeWindowHeightTitle"] = "交易視窗高度";
L["tradeWindowHeghtDesc"] = "交易視窗的寬度。";

L["resetFramesTitle"] = "視窗預設值";
L["resetFramesDesc"] = "重置所有視窗及大小回到預設值。";

L["resetFramesMsg"] = "重置所有視窗大小位置。";														
																																 

L["statsRep"] = "聲望:";

L["instanceStatsOutputRepTitle"] = "聲望提升";
L["instanceStatsOutputRepDesc"] = "顯示在副本裡提升了多少聲望。";

L["experiencePerHour"] = "經驗/小時";

L["instanceStatsOutputXpPerHourTitle"] = "顯示經驗/小時";
L["instanceStatsOutputXpPerHourDesc"] = "顯示在副本每小時多少經驗值?";

L["autoDialogueDesc"] = "與NPC自動對話";

L["autoSlavePensTitle"] = "奴隸監獄自動對話";
L["autoSlavePensDesc"] = "自動跟奴隸監獄尾王前NPC對話?";

L["autoCavernsFlightTitle"] = "時光之穴自動飛行";
L["autoCavernsFlightDesc"] = "自動跟時光之穴集合時旁邊洞口的龍對話飛下去? (只在 \"主宰之巢\" 任務完成過有效)";

L["autoBlackMorassTitle"] = "黑色沼澤自動拿燈";
L["autoBlackMorassDesc"] = "在進入黑色沼澤時自動跟NPC對話拿燈 (只在 \"龍族的英雄\" 任務完成過有效)";

L["autoSfkDoorTitle"] = "自動影牙開門";
L["autoSfkDoorDesc"] = "自動跟NPC對話開啟影牙城堡的門?";

L["honorGains"] = "獲得榮譽";
L["Honor"] = "榮譽";
L["Won"] = "贏";
L["Lost"] = "輸";
L["Arena"] = "競技場";
L["Arena Points"] = "競技場點數";

L["stillInArena"] = "正在競技場中";
L["stillInBattleground"] = "正在戰場中";