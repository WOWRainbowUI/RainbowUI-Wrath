--- Kaliel's Tracker - Mock Data

-- Scenario data -------------------------------------------------------------------------------------------------------

if false then
    C_Scenario.GetInfo = function()
        return
            "The MOTHERLODE!!",  -- scenarioName
            1,          -- currentStage
            1,          -- numStages
            18,         -- flags
            false,      -- hasBonusStep
            false,      -- isBonusStepComplete
            false,      -- completed
            0,          -- xp
            0,          -- money
            3,          -- scenarioType
            "UNKNOWN",  -- areaName
            nil         -- textureKit
    end

    C_Scenario.GetStepInfo = function()
        return
            "The MOTHERLODE!!",  -- stageName
            "Claim control of The MOTHERLODE!! from the Venture Company.",  -- stageDescription
            4,      -- numCriteria
            false,  -- stepFailed
            false,  -- isBonusStep
            false,  -- isForCurrentStepOnly
            false,  -- shouldShowBonusObjective
            0,      -- numSpells
            {},     -- spellInfo
            nil,    -- weightedProgress
            53623,  -- rewardQuestID
            nil     -- widgetSetID
    end

    C_Scenario.GetCriteriaInfo = function()
        return
            "Coin-Operated Crowd Pummeler defeated",  -- criteriaString
            165,    -- criteriaType
            false,  -- completed
            0,      -- quantity
            1,      -- totalQuantity
            0,      -- flags
            2105,   -- assetID
            0,      -- quantityString
            38193,  -- criteriaID
            0,      -- duration
            0,      -- elapsed
            false,
            false   -- isWeightedProgress
    end
end

-- Auto Quest PopUp data -----------------------------------------------------------------------------------------------

if false then
    KT_TEST_AUTO_QUEST_POPUP = {
        --{ 34469, "OFFER" },
        { 12486, "COMPLETE" },
        --{ 11888, "COMPLETE" },
        --{ 58582, "OFFER" },
    }

    GetNumAutoQuestPopUps = function()
        return #KT_TEST_AUTO_QUEST_POPUP
    end

    GetAutoQuestPopUp = function(i)
        return unpack(KT_TEST_AUTO_QUEST_POPUP[i])
    end
end

-- Zone data -----------------------------------------------------------------------------------------------------------

if false then
    do
        local instance = {
            mapID = 115,
            name = "Naxxramas",  -- instanceName
            id = 533,        -- instanceID
            type = "raid",   -- instanceType
                             -- "none" - when outside an instance
                             -- "party" - when in a 5-man instance
                             -- "raid" - when in a raid instance
                             -- "scenario" - when in a scenario
                             -- "pvp" - when in a battleground
                             -- "arena" - when in an arena
            difficulty = 3   -- difficultyID
                             -- 0 - not in an instance
                             -- 1 - Normal - party
                             -- 2 - Heroic - party (isHeroic)
                             -- 3 - 10 Player - raid - toggleDifficultyID: 5
                             -- 4 - 25 Player - raid - toggleDifficultyID: 6
                             -- 5 - 10 Player (Heroic) - raid - isHeroic, toggleDifficultyID: 3
                             -- 6 - 25 Player (Heroic) - raid - isHeroic, toggleDifficultyID: 4
                             -- 7 - Looking For Raid - raid - Legacy LFRs prior to SoO
                             -- 9 - 40 Player - raid
                             -- 148 - 20 Player - raid - ZG, AQ20
        }
        --[[instance = {
            mapID = 1428,
            name = "Molten Core",
            id = 409,
            type = "raid",
            difficulty = 9
        }]]
        --[[instance = {
            mapID = 120,
            name = "Ulduar",
            id = 603,
            type = "raid",
            difficulty = 3
        }]]
        --[[instance = {
            mapID = 118,
            name = "Trial of the Crusader",
            id = 649,
            type = "raid",
            difficulty = 6
        }]]
        --[[instance = {
            mapID = 118,
            name = "Icecrown Citadel",
            id = 631,
            type = "raid",
            difficulty = 4
        }]]
        --[[instance = {
            mapID = 1952,
            name = "Sethekk Halls",
            id = 556,
            type = "party",
            difficulty = 2
        }]]
        --[[instance = {
            mapID = 118,
            name = "Pit of Saron",
            id = 658,
            type = "party",
            difficulty = 1
        }]]

        local size = 0       -- instanceGroupSize / maxPlayers
        if instance.difficulty == 1 or instance.difficulty == 2 then
            size = 5
        elseif instance.difficulty == 3 or instance.difficulty == 5 then
            size = 10
        elseif instance.difficulty == 4 or instance.difficulty == 6 then
            size = 25
        elseif instance.difficulty == 9 then
            size = 40
        elseif instance.difficulty == 148 then
            size = 20
        end

        local bck_C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
        C_Map.GetBestMapForUnit = function(unitToken)
            if unitToken == "player" then
                return instance.mapID  -- uiMapID [number, nil]
            else
                return bck_C_Map_GetBestMapForUnit(unitToken)
            end
        end

        IsInInstance = function()
            return
                true,          -- inInstance [true, nil]
                instance.type  -- instanceType
        end

        GetRealZoneText = function()
            return instance.name  -- the map instance name
        end

        GetInstanceInfo = function()
            return
                instance.name,        -- instanceName
                instance.type,        -- instanceType
                instance.difficulty,  -- difficultyID
                select(1, GetDifficultyInfo(instance.difficulty)),  -- difficultyName ["10 Player", "25 Player (Heroic)", etc.]
                size,                 -- maxPlayers
                0,                    -- dynamicDifficulty
                false,                -- isDynamic
                instance.id,          -- instanceID ... https://warcraft.wiki.gg/wiki/InstanceID
                size,                 -- instanceGroupSize
                nil                   -- LfgDungeonID [nil or id] ... https://warcraft.wiki.gg/wiki/LfgDungeonID
        end
    end
end