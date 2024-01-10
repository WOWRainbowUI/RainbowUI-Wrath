local L = LibStub("AceLocale-3.0"):NewLocale("NovaInstanceTracker", "koKR");
if (not L) then
    return;
end
 
L["noTimer"] = "기록 없음"; --No timer
L["noCurrentTimer"] = "현재 기록 없음"; --No current timer
L["noActiveTimers"] = "활성화된 기록 없음"; --No active timers
L["second"] = "초"; --Second (singular).
L["seconds"] = "초"; --Seconds (plural).
L["minute"] = "분"; --Minute (singular).
L["minutes"] = "분"; --Minutes (plural).
L["hour"] = "시간"; --Hour (singular).
L["hours"] = "시간"; --Hours (plural).
L["day"] = "일"; --Day (singular).
L["days"] = "일"; --Days (plural).
L["secondMedium"] = "초"; --Second (singular).
L["secondsMedium"] = "초"; --Seconds (plural).
L["minuteMedium"] = "분"; --Minute (singular).
L["minutesMedium"] = "분"; --Minutes (plural).
L["hourMedium"] = "시간"; --Hour (singular).
L["hoursMedium"] = "시간"; --Hours (plural).
L["dayMedium"] = "일"; --Day (singular).
L["daysMedium"] = "일"; --Days (plural).
L["secondShort"] = "초"; --Used in short timers like 1m30s (single letter only, usually the first letter of seconds).
L["minuteShort"] = "분"; --Used in short timers like 1m30s (single letter only, usually the first letter of minutes).
L["hourShort"] = "시간"; --Used in short timers like 1h30m (single letter only, usually the first letter of hours).
L["dayShort"] = "일"; --Used in short timers like 1d8h (single letter only, usually the first letter of days).
L["startsIn"] = "%s 이후 개최"; --"Starts in 1hour".
L["endsIn"] = "%s 이후 종료"; --"Ends in 1hour".
L["versionOutOfDate"] = "Nova Instance Tracker 애드온을 트위치나 URL을 통해 업데이트 해주세요. https://www.curseforge.com/wow/addons/nova-instance-tracker";
L["Options"] = "설정";
L["Reset Data"] = "데이터 초기화"; --A button to Reset data.

L["Error"] = "에러";
L["delete"] = "삭제";
L["confirmInstanceDeletion"] = "인스턴스 삭제 확인";
L["confirmCharacterDeletion"] = "캐릭터 삭제 확인";

-------------
---Config---
-------------
--There are 2 types of strings here, the names end in Title or Desc L["exampleTitle"] and L["exampleDesc"].
--Title must not be any longer than 21 characters (maybe less for chinese characters because they are larger).
--Desc can be any length.

---General Options---
L["generalHeaderDesc"] = "일반 옵션";

L["chatColorTitle"] = "채팅 메세지 색상";
L["chatColorDesc"] = "채팅 메세지 색상을 설정합니다";

L["resetColorsTitle"] = "색상 초기화";
L["resetColorsDesc"] = "색상을 기본값으로 재설정 합니다.";

L["timeStampFormatTitle"] = "시간 포맷 형식";
L["timeStampFormatDesc"] = "12시간 (1:23pm) 또는 24시간 (13:23) 시간 포맷을 설정 합니다.";

L["timeStampZoneTitle"] = "로컬 시간 / 서버 시간";
L["timeStampZoneDesc"] = "로컬 시간(내 컴퓨터 시간) 또는 서버 시간을 표시할까요?";

L["minimapButtonTitle"] = "미니맵 버튼 표시";
L["minimapButtonDesc"] = "NIT 미니맵 버튼을 표시할까요?";

---Sounds---
L["soundsHeaderDesc"] = "소리";

L["soundsTextDesc"] = "비활성화하려면 소리를 \"없음\" 으로 설정하십시오.";

L["disableAllSoundsTitle"] = "모든 소리 비활성화";
L["disableAllSoundsDesc"] = "이 애드온의 모든 소리 비활성화합니다.";

L["extraSoundOptionsTitle"] = "추가 사운드 옵션";
L["extraSoundOptionsDesc"] = "여기의 목록에 모든 애드온의 모든 사운드를 한 번에 표시하려면 이 옵션을 활성화하세요.";

L["notesHeaderDesc"] = "알림 사항:";
L["notesDesc"] = "이 애드온은 더 많은 인스턴스를 입장할 수 있을 때 해치우는 것이 가장 좋지만 블리자드의 잠금 시스템은 때때로 버그가 있으며 올바른 인스 제한에 도달하기 전에 잠길 수 있습니다. 시간당 4개만 입장하는 경우도 있지만, 시간당 6개 입장하는 경우도 있습니다.";

L["logHeaderDesc"] = "로그 창";

L["openInstanceLogFrameTitle"] = "인스턴스 로그 열기";

L["logSizeTitle"] = "로그에 표시할 인스턴스 갯수";
L["logSizeDesc"] = "로그에 몇 개의 인스턴스를 표시하시겠습니까? 최대 300개까지 저장되며 100개가 기본으로 표시됩니다(/NIT로 로그를 열 수 있음).";

L["enteredMsgTitle"] = "던전 입장시 메시지";
L["enteredMsgDesc"] = "This will print a msg to your main chat window when you enter a 5 man dungeon with an X icon to delete the new instance from database if you want.";

L["raidEnteredMsgTitle"] = "공격대 입장시 메시지";
L["raidEnteredMsgDesc"] = "This will print a msg to your main chat window when you enter a raid with an X icon to delete the new instance from database if you want.";

L["pvpEnteredMsgTitle"] = "PvP 입장시 메시지";
L["pvpEnteredMsgDesc"] = "This will print a msg to your main chat window when you enter a pvp instance with an X icon to delete the new instance from database if you want.";

L["noRaidInstanceMergeMsgTitle"] = "병합된 공격대 숨기기";
L["noRaidInstanceMergeMsgDesc"] = "레이드 진입 시 인스턴스 병합 메시지 숨기기 및 동일한 아이디 감지.";
			
L["instanceResetMsgTitle"] = "그룹 인스턴스 초기화";
L["instanceResetMsgDesc"] = "당신이 그룹 리더인 경우 성공적으로 초기화 된 인스턴스를 파티 또는 공격대에 메시지를 표시합니다. 예: \"통곡의 동굴이 초기화되었습니다.\"";

L["showMoneyTradedChatTitle"] = "거래된 골드 기록 표시";
L["showMoneyTradedChatDesc"] = "누군가에게 골드를 주고받을 때 거래 기록에 표시하시겠습니까? (그룹에서 골드를 지불하거나 받은 사람을 파악하는 데 도움이 됩니다.).";

L["instanceStatsHeaderDesc"] = "던전 통계 출력";

L["instanceStatsTextDesc"] = "던전을 나갈 때 그룹 채팅이나 채팅 창에 표시할 통계를 선택하세요.";

L["instanceStatsOutputTitle"] = "상태 표시";
L["instanceStatsOutputDesc"] = "던전에서 나갈 때 채팅으로 통계를 표시할까요?";
			
L["instanceStatsOutputWhereTitle"] = "통계 표시 위치";
L["instanceStatsOutputWhereDesc"] = "통계를 표시할 채팅창의 위치를 설정해주세요.";

L["instanceStatsOutputMobCountTitle"] = "몹 수 표시";
L["instanceStatsOutputMobCountDesc"] = "던전 안에 있는 동안 잡은 몹 숫자를 표시할까요?";

L["instanceStatsOutputXPTitle"] = "경험치 표시";
L["instanceStatsOutputXPDesc"] = "던전에서 얻은 경험치를 표시할까요?";

L["instanceStatsOutputAverageXPTitle"] = "평균 경험치 표시";
L["instanceStatsOutputAverageXPDesc"] = "던전에서 킬당 평균 경험치를 표시할까요?";

L["instanceStatsOutputTimeTitle"] = "시간 표시";
L["instanceStatsOutputTimeDesc"] = "던전에서 보낸 시간을 표시할까요?";

L["instanceStatsOutputGoldTitle"] = "순수 골드 표시";
L["instanceStatsOutputGoldDesc"] = "던전에서 잡은 몹으로 부터 얻은 골드를 표시할까요?";

L["instanceStatsOutputAverageGroupLevelDesc"] = "평균 레벨 표시";
L["instanceStatsOutputAverageGroupLevelTitle"] = "던전 내 그룹 평균 레벨을 표시할까요?";

L["showAltsLogTitle"] = "Alts 표시";
L["showAltsLogDesc"] = "인스턴스 로그에 Alts를 표시할까요?";

L["timeStringTypeTitle"] = "시간 표기 형식";
L["timeStringTypeDesc"] = "What time string format to use in the instance log?\n|cFFFFFF00Long:|r 1 minute 30 seconds\n|cFFFFFF00Medium|r: 1 min 30 secs\n|cFFFFFF00Short|r 1m30s";

L["showLockoutTimeTitle"] = "잠금 시간 표시";
L["showLockoutTimeDesc"] = "This will show lockout time left in the instance log for instances within the past 24 hours, with this unticked it will show the time entered instead like in older versions.";

L["colorsHeaderDesc"] = "색상"

L["mergeColorTitle"] = "인스턴스 색상 합치기";
L["mergeColorDesc"] = "What color should the msg in chat be when the same instance as last is detected and the data is merged?";

L["detectSameInstanceTitle"] = "동일한 인스턴스 감지";
L["detectSameInstanceDesc"] = "Auto detect if you re-enter the same instance so the addon doesn't count it as 2 seperate instances?";

L["showStatsInRaidTitle"] = "공격대 통계 표시";
L["showStatsInRaidDesc"] = "Show stats when in a raid? Disable this to only show stats to group when you are in a 5 man party (This option only works when you have group chat as your stats output).";

L["printRaidInsteadTitle"] = "공격대 중 출력";
L["printRaidInsteadDesc"] = "If you have the option to disable sending stats to raid chat then this will print them to your chat window instead so you can still see them.";

L["statsOnlyWhenActivityTitle"] = "활동 시에만";
L["statsOnlyWhenActivityDesc"] = "Only show stats when some activity occured while inside the dungeon? This means only if you killed some mobs, got xp, looted some gold etc. This will make it not show empty stats.";

L["show24HourOnlyTitle"] = "지난 24시간만 표시";
L["show24HourOnlyDesc"] = "인스턴스 로그에 지난 24시간 동안의 인스턴스만 표시하시겠습니까?";

L["trimDataHeaderDesc"] = "데이터 청소하기";

L["trimDataBelowLevelTitle"] = "제거할 최대 레벨";
L["trimDataBelowLevelDesc"] = "데이터베이스에서 제거할 최대 캐릭터 레벨을 선택하십시오. 이 레벨 이하의 모든 캐릭터는 삭제됩니다.";

L["trimDataBelowLevelButtonTitle"] = "캐릭터 삭제";
L["trimDataBelowLevelButtonDesc"] = "이 애드온 데이터베이스에서 선택한 레벨 이하의 모든 캐릭터를 제거하려면 이 버튼을 클릭하세요.";

L["trimDataTextDesc"] = "데이터베이스에서 여러 캐릭터 제거:";
L["trimDataText2Desc"] = "데이터베이스에서 한 캐릭터 제거:";

L["trimDataCharInputTitle"] = "하나의 캐릭터 입력 제거";
L["trimDataCharInputDesc"] = "제거할 문자를 여기에 입력하고 이름 영역(대소문자 구분)으로 형식을 지정합니다. 참고: 버프 카운트 데이터를 영구적으로 제거합니다.";

L["trimDataBelowLevelButtonConfirm"] = "데이터베이스에서 레벨 %s 아래의 모든 캐릭터를 제거하시겠습니까?";
L["trimDataCharInputConfirm"] = "데이터베이스에서 이 캐릭터 %s을(를) 제거하시겠습니까?";

L["trimDataMsg2"] = "%s 레벨 아래의 모든 캐릭터 제거.";
L["trimDataMsg3"] = "제거됨: %s.";
L["trimDataMsg4"] = "완료, 캐릭터가 없습니다.";
L["trimDataMsg5"] = "완료, 제거된 %s 캐릭터.";
L["trimDataMsg6"] = "데이터베이스에서 삭제할 유효한 캐릭터 이름을 입력하십시오.";
L["trimDataMsg7"] = "이 캐릭터 이름 %s에는 영역에 포함되어 있지 않습니다, 이름-영역을 입력하세요.";
L["trimDataMsg8"] = "데이터베이스에서 %s을(를) 제거하는 동안 오류가 발생했습니다. 캐릭터를 찾을 수 없습니다(이름은 대소문자를 구분합니다.).";
L["trimDataMsg9"] = "데이터베이스에서 %s을(를) 제거했습니다.";

L["instanceFrameSelectAltMsg"] = "Select which alt to show if \"Show All Alts\" is unticked.\nOr which alt to colorize if \"Show All Alts\" is ticked.";

L["enteredDungeon"] = "새로운 인스턴스 %s %s, 클릭";
L["enteredDungeon2"] = "새로운 인스턴스가 아닌 경우.";
L["enteredRaid"] = "새로운 인스턴스 %s, 이 공격대는 묶인 횟수에 포함되지 않습니다.";
L["loggedInDungeon"] = "You have logged in inside %s %s, if this is not a new instance click";
L["loggedInDungeon2"] = "to delete this instance from the database.";
L["reloadDungeon"] = "UI Reload detected %s, loading last instance data instead of creating new.";
L["thisHour"] = "지금 시간";
L["statsError"] = "인스턴스 ID %s 에 대한 통계를 찾는 동안 오류가 발생했습니다.";
L["statsMobs"] = "몹:";
L["statsXP"] = "XP:";
L["statsAverageXP"] = "평균 XP/몹:";
L["statsRunsPerLevel"] = "Runs per level:";
L["statsRunsNextLevel"] = "Runs until next level:";
L["statsTime"] = "시간:";
L["statsAverageGroupLevel"] = "평균 그룹 레벨:";
L["statsGold"] = "골드";
L["sameInstance"] = "Same instance ID as last detected %s, merging database entries.";
L["deleteInstance"] = "Deleted instance [%s] %s (%s ago) from the database.";
L["deleteInstanceError"] = "Error deleting %s.";
L["countString"] = "You have entered %s instances in the past hour and %s in the past 24h";
L["countStringColorized"] = "You have entered %s %s %s instances in the past hour and %s %s %s in the past 24h";
L["now"] = "현재";
L["in"] = "in";
L["active24"] = "24시간 잠김 활성화";
L["nextInstanceAvailable"] = "다음 인스턴스 사용 가능";
L["gave"] = "보냄";
L["received"] = "받음";
L["to"] = "to";
L["from"] = "from";
L["playersStillInside"] = "리셋 됨 (오래된 인스턴스 안에 있는 플레이어는 영역을 벗어나 새롭게 들어갈 수 있음).";
L["Gold"] = "골드";
L["gold"] = "골드";
L["silver"] = "실버";
L["copper"] = "코퍼";
L["newInstanceNow"] = "지금 새로운 인스턴스에 입장할 수 있습니다";
L["thisHour"] = "현재 1시간";
L["thisHour24"] = "현재 24시간";
L["openInstanceFrame"] = "인스턴스 프레임 열기";
L["openYourChars"] = "내 캐릭터 열기";
L["openTradeLog"] = "거래 기록 열기";
L["config"] = "설정";
L["thisChar"] = "이 캐릭터";
L["yourChars"] = "나의 캐릭터";
L["instancesPastHour"] = "지난 1시간 내 인스턴스.";
L["instancesPastHour24"] = "지난 24시간 내 인스턴스.";
L["leftOnLockout"] = "잠김중";
L["tradeLog"] = "거래 기록";
L["pastHour"] = "지난 1시간";
L["pastHour24"] = "지난 24시간";
L["older"] = "오래됨";
L["raid"] = "공격대";
L["alts"] = "Alts";
L["deleteEntry"] = "항목 삭제";
L["lastHour"] = "1시간 이내";
L["lastHour24"] = "24시간 이내";
L["entered"] = "입장";
L["ago"] = "이전";
L["stillInDungeon"] = "아직 던전 내부";
L["leftOnLockout"] = "잠김중";
L["leftOnDailyLockout"] = "일일 잠금 상태로 남아 있음";
L["noLockout"] = "이 공격대의 잠금 없음";
L["unknown"] = "알 수 없음";
L["instance"] = "인스턴스";
L["timeEntered"] = "입장 시간";
L["timeLeft"] = "퇴장 시간";
L["timeInside"] = "머무른 시간";
L["mobCount"] = "몹 수";
L["experience"] = "경험치";
L["experienceShort"] = "XP";
L["rawGoldMobs"] = "순수 몹 골드";
L["enteredLevel"] = "입장 레벨";
L["leftLevel"] = "퇴장 레벨";
L["averageGroupLevel"] = "그룹 평균 레벨";
L["currentLockouts"] = "현재 잠김";
L["repGains"] = "획득 평판";
L["groupMembers"] = "그룹 구성원";
L["tradesWhileInside"] = "안에 있는 동안 거래";
L["noDataInstance"] = "이 인스턴스에 데이터가 없습니다.";
L["restedOnlyText"] = "휴식중만 표시";
L["restedOnlyTextTooltip"] = "Only show chars that have rested XP? Untick this to show all alts, even max level and alts with no rested.";
L["deleteEntry"] = "항목 삭제"; --Example: "Delete entry 5";
L["online"] = "온라인";
L["maximum"] = "최대";
L["level"] = "레벨";
L["rested"] = "휴식";
L["realmGold"] = "Realm gold for";
L["total"] = "총";
L["guild"] = "길드";
L["resting"] = "휴식중";
L["notResting"] = "휴식 없음";
L["rested"] = "휴식";
L["restedBubbles"] = "휴식 거품";
L["restedState"] = "휴식 상태";
L["bagSlots"] = "가방 슬롯";
L["durability"] = "내구도";
L["items"] = "아이템";
L["ammunition"] = "탄약";
L["petStatus"] = "펫 상태";
L["name"] = "이름";
L["family"] = "Family";
L["happiness"] = "행복도";
L["loyaltyRate"] = "충성도";
L["petExperience"] = "펫 XP";
L["unspentTrainingPoints"] = "사용하지 않은 훈련 포인트";
L["professions"] = "직업";
L["lastSeenPetDetails"] = "마지막으로 본 펫 정보";
L["currentPet"] = "현재 펫";
L["noPetSummoned"] = "소환된 펫 없음";
L["lastSeenPetDetails"] = "마지막으로 본 펫 정보";
L["noProfessions"] = "직업을 찾을 수 없습니다.";
L["cooldowns"] = "재사용 대기시간";
L["left"] = "남은"; -- This is left as in "time left";
L["ready"] = "준비.";
L["pvp"] = "PvP";
L["rank"] = "랭크";
L["lastWeek"] = "지난 주";
L["attunements"] = "Attunements";
L["currentRaidLockouts"] = "현재 공격대 잠김";
L["none"] = "없음.";

L["instanceStatsOutputRunsPerLevelTitle"] = "레벨당 횟수";
L["instanceStatsOutputRunsPerLevelDesc"] = "레벨당 몇 번 돌아야되는지 표시할까요?";

L["instanceStatsOutputRunsNextLevelTitle"] = "다음 레벨까지 횟수";
L["instanceStatsOutputRunsNextLevelDesc"] = "다음 레벨까지 몇 번 더 돌아야되는지 표시할까요?";

L["instanceWindowWidthTitle"] = "인스턴스 창 너비";
L["instanceWindowWidthDesc"] = "인스턴스 창 너비 설정.";

L["instanceWindowHeightTitle"] = "인스턴스 창 높이";
L["instanceWindowHeghtDesc"] = "인스턴스 창 높이 설정.";

L["charsWindowWidthTitle"] = "캐릭터 창 너비";
L["charsWindowWidthDesc"] = "캐릭터 창 너비 설정.";

L["charsWindowHeightTitle"] = "캐릭터 창 높이";
L["charsWindowHeghtDesc"] = "캐릭터 창 높이 설정.";

L["tradeWindowWidthTitle"] = "거래 기록 창 너비";
L["tradeWindowWidthDesc"] = "거래 기록 창 너비 설정.";

L["tradeWindowHeightTitle"] = "거래 기록 창 높이";
L["tradeWindowHeghtDesc"] = "거래 기록 창 높이 설정.";

L["resetFramesTitle"] = "창 초기화";
L["resetFramesDesc"] = "모든 창을 화면 중앙으로 재설정하고 크기를 기본값으로 되돌립니다.";

L["resetFramesMsg"] = "모든 창 위치 및 크기 재설정.";

L["statsRep"] = "평판:";

L["instanceStatsOutputRepTitle"] = "평판 획득";
L["instanceStatsOutputRepDesc"] = "던전 안에서 얻은 평판을 표시할까요?";

L["experiencePerHour"] = "XP/시간당";

L["instanceStatsOutputXpPerHourTitle"] = "XP/시간당 표시";
L["instanceStatsOutputXpPerHourDesc"] = "던전 안에서 얻은 시간당 경험치를 표시할까요?";

L["autoDialogueDesc"] = "자동 NPC 대화";

L["autoSlavePensTitle"] = "Auto Slave Pens";
L["autoSlavePensDesc"] = "Auto dialogue with the NPC at the end of slave pens in the cage?";

L["autoCavernsFlightTitle"] = "Auto CoT Flight";
L["autoCavernsFlightDesc"] = "Auto dialogue with the dragon near the summoning stone at caverns of time to fly down? (Only if \"To The Master's Lair\" quest is complete)";

L["autoBlackMorassTitle"] = "Auto Black Morass";
L["autoBlackMorassDesc"] = "Auto dialogue with the NPC at the start of black morass to get your beacon? (Only if \"Hero of the Brood\" quest is complete)";

L["autoSfkDoorTitle"] = "Auto Sfk Door";
L["autoSfkDoorDesc"] = "Auto dialogue with the NPC in shadowfang keep that opens the door?";

L["honorGains"] = "명예 획득";
L["Honor"] = "명예";
L["Won"] = "승리";
L["Lost"] = "패배";
L["Arena"] = "투기장";
L["Arena Points"] = "투기장 포인트";

L["stillInArena"] = "아직 진행중";
L["stillInBattleground"] = "아직 진행중";

L["resetAllInstancesConfirm"] = "로그에서 모든 인스턴스 데이터를 삭제하시겠습니까?";
L["All Instance log data has been deleted."] = "모든 인스턴스 로그 데이터가 삭제되었습니다.";

L["resetAllInstancesTitle"] = "인스턴스 데이터 초기화";
L["resetAllInstancesDesc"] = "모든 인스턴스 데이터가 초기화되고 로그에서 모든 것이 제거됩니다. 거래 기록을 초기화하지 않습니다.";