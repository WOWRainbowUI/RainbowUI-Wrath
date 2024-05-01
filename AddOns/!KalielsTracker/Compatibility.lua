--- Kaliel's Tracker
--- Copyright (c) 2012-2024, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

if WOW_PROJECT_ID > WOW_PROJECT_CLASSIC then
    -- Classic (WotLK)
    GetSuperTrackedQuestID = function()  -- R ... TODO: Test after every WoW update
        local questID = 0
        if WorldMapFrame and WorldMapFrame:IsShown() then
            questID = QuestMapFrame_GetFocusedQuestID()
        end
        return questID
    end

    if not OpenAchievementFrameToAchievement then
        function OpenAchievementFrameToAchievement(achievementID)
            WatchFrame_OpenAchievementFrame(_, achievementID)
        end
    end
elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
    -- Classic Era
    WatchFrame = QuestWatchFrame
    WatchFrame_Update = QuestWatch_Update

    if not GetQuestLogSpecialItemInfo then
        GetQuestLogSpecialItemInfo = function()
            return nil
        end
    end

    if not IsQuestLogSpecialItemInRange then
        IsQuestLogSpecialItemInRange = function()
            return nil
        end
    end

    if not GetQuestLogSpecialItemCooldown then
        GetQuestLogSpecialItemCooldown = GetActionCooldown
    end

    if not QuestPOI_Initialize then
        QuestPOI_Initialize = function() end
    end

    if not QuestPOI_ResetUsage then
        QuestPOI_ResetUsage = function() end
    end

    if not QuestPOI_SelectButtonByQuestID then
        QuestPOI_SelectButtonByQuestID = function() end
    end

    if not QuestPOI_HideUnusedButtons then
        QuestPOI_HideUnusedButtons = function() end
    end

    if not GetNumAutoQuestPopUps then
        GetNumAutoQuestPopUps = function()
            return 0
        end
    end

    if not GetNumTrackedAchievements() then
        GetNumTrackedAchievements = function()
            return 0
        end
    end
end

-- Classic + Classic Era
if not QuestMapQuestOptions_AbandonQuest then
    QuestMapQuestOptions_AbandonQuest = function(questID)
        local bckQuestLogSelection = GetQuestLogSelection()  -- backup Quest Log selection
        local questLogIndex = GetQuestLogIndexByID(questID)
        SelectQuestLogEntry(questLogIndex)
        SetAbandonQuest()

        local items = GetAbandonQuestItems()
        local title = GetAbandonQuestName()
        if items then
            StaticPopup_Hide("ABANDON_QUEST")
            StaticPopup_Show("ABANDON_QUEST_WITH_ITEMS", title, items)
        else
            StaticPopup_Hide("ABANDON_QUEST_WITH_ITEMS")
            StaticPopup_Show("ABANDON_QUEST", title)
        end

        SelectQuestLogEntry(bckQuestLogSelection)  -- restore Quest Log selection
    end
end

if not IsQuestBounty then
    IsQuestBounty = function()
        return false
    end
end

if not IsQuestTask then
    IsQuestTask = function()
        return false
    end
end