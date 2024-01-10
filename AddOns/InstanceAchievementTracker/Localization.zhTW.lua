﻿if(GetLocale() ~= 'zhTW') then return end

local _, core = ...
local baseLocale = {
	["- Announce to chat players who are missing achievements for certain bosses"] = "- 在聊天視窗通報哪個玩家缺少哪個首領的成就",
	["- Announce to chat tactics for a certain boss"] = "- 在聊天視窗通報某些首領的成就解法",
	["- Keeps track of achievements which require you to kill so many mobs within a certain time period. It will announce to chat when enough mobs have spawned and whether they were killed in the time period."] = "- 持續追蹤成就要求你在指定時間內擊殺多少怪物。會在聊天視窗通報已經擊殺足夠數量的怪物以及是否在時間內完成。",
	["- Scans all players in the group to see which achievements each player is missing for the current instance"] = "- 掃描隊伍中的所有玩家，檢查每個玩家缺少當前副本的哪個成就。",
	["- Tracks when the criteria of instance achievements has been failed and outputs this to chat"] = "- 追蹤成就的要求失敗時輸出到聊天視窗",
	["- Tracks when the criteria of instance achievements have been met and output this to chat"] = "- 追蹤達到成就的要求時輸出到聊天視窗",
	["(Enter instance to start scanning)"] = "(進入副本開始掃描)",
	["AzsharasEternalPalace_Applause"] = "喝彩",
	["AzsharasEternalPalace_Curtsey"] = "屈膝",
	["AzsharasEternalPalace_Grovel"] = "卑微",
	["AzsharasEternalPalace_Kneel"] = "下跪",
	["AzsharasEternalPalace_Salute"] = "敬禮",
	["Core_AchievementScanFinished"] = "成就掃描完成",
	["Core_AchievementTrackingEnabledFor"] = "已啟用追蹤成就",
	["Core_CommandEnableTracking"] = "啟用/停用 IAT 成就追蹤",
	["Core_Commands"] = "指令清單",
	["Core_CompletedAllAchievements"] = "你已經完成這個副本的所有成就",
	["Core_Counter"] = "數量",
	["Core_CriteriaMet"] = "條件已達成，現在可以擊殺首領!",
	["Core_Enable"] = "啟用",
	["Core_EnableAchievementTracking"] = "是否要啟用追蹤成就",
	["Core_Failed"] = "已失敗!",
	["Core_GameFreezeWarning"] = "遊戲將會停頓幾秒",
	["Core_help"] = "說明",
	["Core_IncompletedAchievements"] = "這個副本尚未完成的成就",
	["Core_ListCommands"] = "顯示可用的指令",
	["Core_No"] = "否",
	["Core_NoTrackingForInstance"] = "副本成就追蹤: 無法追蹤這個首領戰的任何成就。",
	["Core_PersonalAchievement"] = "個人成就",
	["Core_Reason"] = "原因",
	["Core_StartingAchievementScan"] = "開始掃描成就",
	["Core_TrackAchievements"] = "追蹤成就",
	["Core_Yes"] = "是",
	["Features"] = "功能",
	["GUI_Achievement"] = "成就",
	["GUI_Achievements"] = "成就",
	["GUI_AchievementsCompletedForInstance"] = "所有成就都已經完成",
	["GUI_AchievementsDiscordDescription"] = "戰術是由 Achievements Discord 伺服器慷慨大方的提供，在這個社群中可以遇到相同的成就控，相約一起組隊解各式各樣的成就。",
	["GUI_AchievementsDiscordTitle"] = "Achievements Discord",
	["GUI_AnnounceAchievementsToGroupDescription"] = "開王時 IAT 會通報到聊天視窗，不論這場戰鬥是否有任何成就可以追蹤",
	["GUI_AnnounceMessagesToRaidWarning"] = "通報到團隊警告 (可用時)",
	["GUI_AnnounceMessagesToRaidWarningDescription"] = "IAT 會嘗試將訊息輸出到團隊警告，如果有權限這麼做的話",
	["GUI_AnnounceTracking"] = "通報隊伍開始追蹤成就",
	["GUI_Author"] = "作者",
	["GUI_BattleForAzeroth"] = "決戰艾澤拉斯",
	["GUI_Cataclysm"] = "浩劫與重生",
	["GUI_ChangeMinimapIcon"] = "依據插件狀態更改小地圖圖示",
	["GUI_ChangeMinimapIconDescription"] = "依據 IAT 是否啟用/停用，或目前正在追蹤的成就改變小地圖圖示的顏色",
	["GUI_DifficultyWarning"] = "有些成就在傳奇難度下無法獲得，建議切換成英雄難度",
	["GUI_Disabled"] = "已停用",
	["GUI_DisplayInfoFrame"] = "啟用資訊框架",
	["GUI_EnableAddon"] = "啟用插件",
	["GUI_EnableAddonDescription"] = "啟用或停用副本成就追蹤插件",
	["GUI_EnableAutomaticCombatLogging"] = "啟用自動戰鬥記錄",
	["GUI_EnableCombatLogDescription"] = "啟用追蹤副本後，自動開始遊戲內的戰鬥記錄。如果可以的話，也會記錄每個首領。",
	["GUI_Enabled"] = "已啟用",
	["GUI_EnableInfoFrameDescription"] = "啟用/停用資訊框架。警告: 建議讓此選項保持啟用，否則 IAT 可能無法如預期的運作。",
	["GUI_EnterInstanceToStartScanning"] = "進入副本開始掃描",
	["GUI_GreyOutCompletedAchievements"] = "用灰色顯示已完成的成就",
	["GUI_GreyOutCompletedAchievementsDescription"] = "隊伍中所有玩家都已完成的成就在 IAT 中顯示為灰色",
	["GUI_HideCompletedAchievements"] = "隱藏已完成的成就",
	["GUI_HideCompletedAchievementsDescription"] = "隊伍中所有玩家都已完成的成就不會顯示在 IAT 中",
	["GUI_Legion"] = "軍臨天下",
	["GUI_MinimapDisabled"] = "小地圖按鈕已停用",
	["GUI_MinimapEnabled"] = "小地圖按鈕已啟用",
	["GUI_MistsOfPandaria"] = "潘達利亞之謎",
	["GUI_NoPlayersNeedAchievement"] = "隊伍中沒有玩家需要做這個成就",
	["GUI_OnlyDisplayMissingAchievements"] = "只顯示缺少的成就",
	["GUI_OnlyTrackMissingAchievements"] = "只追蹤缺少的成就",
	["GUI_OnlyTrackMissingAchievementsDescription"] = "IAT 只會追蹤隊伍內有一個或多個玩家需要的成就",
	["GUI_Options"] = "選項",
	["GUI_OutputPlayers"] = "輸出玩家",
	["GUI_OutputTactics"] = "輸出戰術",
	["GUI_Players"] = "玩家",
	["GUI_PlayersWhoNeedAchievement"] = "需要做成就的玩家",
	["GUI_PlaySoundOnCompletionDescription"] = "達到成就的所需條件時播放音效",
	["GUI_PlaySoundOnFailDescription"] = "成就所需的條件失敗時播放音效",
	["GUI_PlaySoundOnFailed"] = "成就失敗時播放音效",
	["GUI_PlaySoundOnSuccess"] = "成就完成時播放音效",
	["GUI_ScanInProgress"] = "掃描仍在進行中",
	["GUI_SelectSound"] = "選擇音效",
	["GUI_Shadowlands"] = "暗影之境",
	["GUI_ShowMimapButtonDescription"] = "在小地圖上顯示 IAT 的圖示",
	["GUI_Tactic"] = "戰術",
	["GUI_Tactics"] = "戰術",
	["GUI_ToggleInfoFrameTestFrame"] = "顯示/隱藏資訊框架",
	["GUI_ToggleInfoFrameTestFrameDescription"] = "顯示或隱藏資訊框架以方便設定位置和縮放大小",
	["GUI_ToggleMinimap"] = "顯示小地圖按鈕",
	["GUI_Track"] = "追蹤",
	["GUI_TrackAchievementsAutomatically"] = "自動追蹤成就",
	["GUI_TrackAchievementsAutomaticallyDescription"] = "進入副本後自動開始追蹤成就，不詢問是否要追蹤",
	["GUI_TrackAchievementsInBlizzardUI"] = "追蹤成就介面中的成就",
	["GUI_TrackAchievementsInUIDescription"] = "IAT 會將此副本內你尚未完成的成就加入到任務追蹤清單",
	["GUI_TrackCharacterAchievements"] = "追蹤角色成就 (預設: 帳號)",
	["GUI_TrackChararcterAchievementsDescription"] = "追蹤當前角色所有缺少的成就，而不是整個帳號。注意: 隊伍中的其他玩家仍會追蹤帳號成就。",
	["GUI_Tracking"] = "正在追蹤",
	["GUI_TrackingDisabled"] = "(成就追蹤已停用)",
	["GUI_TrackingNumber"] = "目前追蹤",
	["Gui_TranslatorNames"] = "彩虹ui",
	["GUI_Translators"] = "翻譯",
	["GUI_WarlordsOfDraenor"] = "德拉諾之霸",
	["GUI_WrathOfTheLichKing"] = "巫妖王之怒",
	["Instance Achievement Tracker"] = "副本成就追蹤",
	["Instances_Other"] = "其他",
	["Instances_TrashAfterThirdBoss"] = "第三個首領之後的小怪",
	["Main"] = "一般",
	["Shared_AddKillCounter"] = "%s 擊殺數量",
	["Shared_CompletedBossKill"] = "擊殺首領後即可完成",
	["Shared_CriteriaHasBeenMet"] = "已達成條件",
	["Shared_CriteriaHasNotBeenMet"] = "尚未達成條件",
	["Shared_DamageFromAbility"] = "% 傷害",
	["Shared_DirectHitFromAbility"] = "%s 直接擊中",
	["Shared_DoesNotMeetCritera"] = "尚未達成條件",
	["Shared_Eight"] = "8",
	["Shared_Eighteen"] = "18",
	["Shared_Eleven"] = "11",
	["Shared_FailedPersonalAchievement"] = "%s 的 %s 已經失敗 (原因: %s) (個人成就)",
	["Shared_Fifteen"] = "15",
	["Shared_Five"] = "5",
	["Shared_Found"] = "已發現",
	["Shared_Four"] = "4",
	["Shared_Fourteen"] = "14",
	["Shared_GotHit"] = "擊中",
	["Shared_HasBeenHitWith"] = "已擊中",
	["Shared_HasBeenInfectedWith"] = "已受影響",
	["Shared_HasCompleted"] = "已完成",
	["Shared_HasFailed"] = "已失敗",
	["Shared_HasGained"] = "已獲得",
	["Shared_HasLost"] = "已失去",
	["Shared_HeCanNowBeKileld"] = "現在可以擊殺他",
	["Shared_JustKillBoss"] = "滿等時，只需要直接擊殺首領即可得到這個成就。",
	["Shared_JustKillBossesTogether"] = "滿等時，只要同時擊殺首領就可獲得這個成就。",
	["Shared_JustKillBossSingleTarget"] = "滿等時，只需要直接使用單體技能擊殺首領即可得到這個成就。",
	["Shared_Killed"] = "已擊殺",
	["Shared_KillTheAddNow"] = "現在擊殺 %s",
	["Shared_MeetsCritera"] = "達成條件",
	["Shared_Nine"] = "9",
	["Shared_Nineteen"] = "19",
	["Shared_Notes"] = "備註",
	["Shared_NotHit"] = "沒有擊中",
	["Shared_One"] = "1",
	["Shared_PlayersHit"] = "玩家擊中:",
	["Shared_PlayersRunningAddon2"] = "要讓副本成就追蹤能夠精確的追蹤這個成就，收集物品的玩家必須執行這個插件。",
	["Shared_PlayersWhoNeedAchievement"] = "需要成就的玩家",
	["Shared_PlayersWhoStillNeedToGetHit"] = "仍需要擊中的玩家:",
	["Shared_PlayersWhoStillNeedToGetResurrected"] = "這些玩家需要被復活才能獲得成就:",
	["Shared_ReportString"] = "請將下列的文字訊息回報給副本成就追蹤插件的作者",
	["Shared_Seven"] = "7",
	["Shared_Seventeen"] = "17",
	["Shared_SheCanNowBeKilled"] = "現在可以擊殺她",
	["Shared_Six"] = "6",
	["Shared_Sixteen"] = "16",
	["Shared_Ten"] = "10",
	["Shared_Thirteen"] = "13",
	["Shared_Three"] = "3",
	["Shared_TrackingStatus"] = "有使用插件的玩家",
	["Shared_Twelve"] = "12",
	["Shared_Twenty"] = "20",
	["Shared_Two"] = "2",
	["Shared_WasKilled"] = "已擊殺"
}

core:RegisterLocale('zhTW', baseLocale)

-- core:RegisterLocale('enUS', baseLocale)
