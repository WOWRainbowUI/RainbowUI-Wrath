if not BG.IsVanilla_Sod() then return end

local _, ADDONSELF = ...

local LibBG = ADDONSELF.LibBG
local L = ADDONSELF.L

local pt = print

-- 副本掉落
do
    -- BD黑暗深渊
    BG.Loot.BD.N.boss1 = { 209676, 209828, 209423, 204804, 211852, 209421, 209825, 209422, 209677, 204807, 209590, }
    BG.Loot.BD.N.boss2 = { 209678, 209824, 209418, 209675, 209524, 209432, 209523, 209436, 209424, 209830, }
    BG.Loot.BD.N.boss3 = { 211843, 211789, 211842, 209679, 209527, 209566, 209680, 209823, 209565, 209564, 209525, 209822, 209563, }
    BG.Loot.BD.N.boss4 = { 209572, 209568, 209569, 209670, 209820, 209821, 211505, 211510, 211507, 209683, 211504, 211512, 211509, 209671, 211506, 211508, 211511, 209669, 209573, 209559, 209567, 209570, 209571, 209681, 211491 }
    BG.Loot.BD.N.boss5 = { 209682, 209578, 209581, 211505, 211510, 211507, 209683, 211504, 211512, 211509, 209671, 211506, 211508, 211511, 209669, 209577, 209560, 209818, 209579, 209574, 209576, 209575 }
    BG.Loot.BD.N.boss6 = { 211455, 209672, 211457, 209667, 209668, 209673, 209686, 209817, 211505, 211507, 211510, 211504, 211512, 211506, 211511, 209694, 211458, 209674, 209816, 209561, 211492 }
    BG.Loot.BD.N.boss7 = { 209690, 209692, 209687, 209685, 209684, 209689, 211505, 211510, 209669, 211508, 211511, 209580, 211456, 209688, 209691, 209562, 209534 }
    BG.Loot.BD.N.boss8 = { 1486, 3416, 1491, 3414, 1454, 1481, 2567, 3413, 3417, 3415, 2271, }
    BG.Loot.BD.N.boss7other = { 211451, 211450, 211449 }

    if UnitFactionGroup("player") == "Horde" then -- BL
        tinsert(BG.Loot.BD.N.boss7, 1, 211452)
    else
        tinsert(BG.Loot.BD.N.boss7, 1, 209693)
    end

    -- 死亡矿井
    do
        BG.Loot.BD.Team[GetRealZoneText(36)] = {
            [L["矿工约翰森"]] = { 5443, },
            [L["斯尼德"]] = { 5194, },
            [L["基尔尼格"]] = { 1156, },
            [L["重锤先生"]] = { 7230, },
            [L["绿皮队长"]] = { 5201, },
            [L["艾德温·范克里夫"]] = { 5193, 5202, 10399, 5191, },
            [L["曲奇"]] = { 5198, },
        }
    end
    -- 哀嚎洞穴
    do
        BG.Loot.BD.Team[GetRealZoneText(43)] = {
            [L["考布莱恩"]] = { 6460, 10410, },
            [L["克雷什"]] = { 13245, },
            [L["皮萨斯"]] = { 6472, },
            [L["斯卡姆"]] = { 6449, },
            [L["瑟芬迪斯"]] = { 6469, },
            [L["永生者沃尔丹"]] = { 6630, 6631, },
            [L["吞噬者穆坦努斯"]] = { 6461, 6627, 6463, },
            [L["变异精灵龙"]] = { 5243, },
        }
    end
    -- 影牙城堡
    do
        BG.Loot.BD.Team[GetRealZoneText(33)] = {
            [L["屠夫拉佐克劳"]] = { 1292, },
            [L["席瓦莱恩男爵"]] = { 6321, },
            [L["指挥官"]] = { 6320, },
            [L["盲眼守卫奥杜"]] = { 6318, },
            [L["幻影之甲"]] = { 6642, },
            [L["狼王南杜斯"]] = { 3748, },
            [L["大法师阿鲁高"]] = { 6324, 6392, 6220, },
            [L["小怪"]] = { 2292, 1489, 1974, 2807, 1482, 1935, 1483, 1318, 3194, 2205, 1484, },
        }
    end
    -- 监狱
    do
        BG.Loot.BD.Team[GetRealZoneText(34)] = {
            [L["布鲁高·铁拳"]] = { 3228, 2941, 2942, },
        }
    end
    -- 剃刀沼泽
    do
        BG.Loot.BD.Team[GetRealZoneText(47)] = {
            [L["小怪"]] = { 2264, 4438, 1978, 2039, 1727, 1976, 1975, 2549, },
        }
    end
    -- 血色
    do
        BG.Loot.BD.Team[GetRealZoneText(189)] = {
            [L["小怪"]] = { 7754, 7786, },
        }
    end
end

-- 声望装备
do
    local FB = "BD"

    if UnitFactionGroup("player") == "Alliance" then
        BG.Loot[FB].Faction = {
            ["890:2"] = { 21568, 21566, },
            ["890:3"] = { 20444, 20428, 20431, 20439, },
            ["890:4"] = { 212580, 212581, 212582, 212583, },
            -- 战歌
        }
    end

    if UnitFactionGroup("player") == "Horde" then
        BG.Loot[FB].Faction = {
            ["889:2"] = { 21568, 21566, },
            ["889:3"] = { 20442, 20427, 20426, 20429, },
            ["889:4"] = { 212584, 212585, 212586, 212587, },
            -- 战歌
        }
    end
end

-- PVP
do
    local FB = "BD"
    if UnitFactionGroup("player") == "Alliance" then
        BG.Loot[FB].Pvp = {
            ["Alliance:2"] = { 18854, 18856, 18857, 18858, 18862, 18863, 18864, 18859 }, -- 徽记
            ["Alliance:3"] = { 213087 },                                                 -- 中士的披风
        }
    end

    if UnitFactionGroup("player") == "Horde" then
        BG.Loot[FB].Pvp = {
            ["Horde:2"] = { 18834, 18846, 18849, 18852, 18851, 18853, 18845, 18850 }, -- 徽记
            ["Horde:3"] = { 213088 },                                                 -- 中士的披风
        }
    end
end

-- 专业制造
do
    local FB = "BD"
    BG.Loot[FB].Profession = {
        ["锻造"] = { 2870, 210794, 210773, },
        ["制皮"] = { 6468, 4253, 211423, 211502. },
        ["裁缝"] = { 4320, 210795, 210781 },
    }
end

-- 任务
do
    local FB = "BD"

    -- 黑暗深渊
    do
        BG.Loot[FB].Quest.N = {
            FBname = BG.GetFBinfo(FB, "localName"),
            color = "00BFFF",
            players = 10,
        }
        if UnitFactionGroup("player") == "Horde" then -- BL
            BG.Loot[FB].Quest.N.faction = 2
            BG.Loot[FB].Quest.N.itemID = { 211467, 211468, 16886, 16887 }
        else
            BG.Loot[FB].Quest.N.faction = 1
            BG.Loot[FB].Quest.N.itemID = { 211462, 211465, 211466, 211463, 211464 }
        end

        -- 全阵营任务
        BG.Loot[FB].Quest.All = {
            FBname = BG.GetFBinfo(FB, "localName"),
            color = "00BFFF",
            players = 10,
        }
        BG.Loot[FB].Quest.All.itemID = { 211461, 211460, }
    end

    -- 死亡矿井
    do
        if UnitFactionGroup("player") == "Alliance" then
            local FB_5 = GetRealZoneText(36)
            BG.Loot[FB].Quest[FB_5] = {
                FBname = FB_5,
                color = "99CCFF",
                players = 9,
                faction = 1,
            }
            BG.Loot[FB].Quest[FB_5].itemID = { 6087, 2041, 2042 }
        end
    end

    -- 监狱
    do
        local FB_5 = GetRealZoneText(34)
        if UnitFactionGroup("player") == "Alliance" then
            BG.Loot[FB].Quest[FB_5] = {
                FBname = FB_5,
                color = "99CCFF",
                players = 9,
                faction = 1,
            }
            BG.Loot[FB].Quest[FB_5].itemID = { 2933 }
        end
    end

    -- 哀嚎洞穴
    do
        local FB_5 = GetRealZoneText(43)
        if UnitFactionGroup("player") == "Horde" then
            BG.Loot[FB].Quest[FB_5] = {
                FBname = FB_5,
                color = "99CCFF",
                players = 9,
                faction = 2,
            }
            BG.Loot[FB].Quest[FB_5].itemID = { 6506, 6504 }
        end
    end

    -- 影牙城堡
    do
        local FB_5 = GetRealZoneText(33)
        if UnitFactionGroup("player") == "Alliance" then
            local FB_5 = GetRealZoneText(33)
            BG.Loot[FB].Quest[FB_5] = {
                FBname = FB_5,
                color = "99CCFF",
                players = 9,
                classID = 2,
                faction = 1,
            }
            BG.Loot[FB].Quest[FB_5].itemID = { 6953 }
        end
        if UnitFactionGroup("player") == "Horde" then
            BG.Loot[FB].Quest[FB_5] = {
                FBname = FB_5,
                color = "99CCFF",
                players = 9,
                faction = 2,
            }
            BG.Loot[FB].Quest[FB_5].itemID = { 6414 }
        end
    end

    -- 剃刀沼泽
    do
        local FB_5 = GetRealZoneText(47)
        if UnitFactionGroup("player") == "Alliance" then
            BG.Loot[FB].Quest[FB_5] = {
                FBname = FB_5,
                color = "99CCFF",
                players = 9,
                classID = 1,
                faction = 1,
            }
            BG.Loot[FB].Quest[FB_5].itemID = { 6972 }
        end
        if UnitFactionGroup("player") == "Horde" then
            BG.Loot[FB].Quest[FB_5] = {
                FBname = FB_5,
                color = "99CCFF",
                players = 9,
                classID = 1,
                faction = 2,
            }
            BG.Loot[FB].Quest[FB_5].itemID = { 7133 }
        end
    end

    -- 专业
    BG.Loot[FB].Quest.Profession1 = {
        FBname = L["锻造/制皮/裁缝"],
        color = BG.y1,
        players = 9,
    }
    BG.Loot[FB].Quest.Profession1.itemID = { 211420 }
end

-- 世界掉落
do
    local FB = "BD"
    BG.Loot[FB].World = { 12978, 12977, 5183, 12982, 12979, 12988, 12987, 12985, 6332, 2879, 12996, 12994, 2911, 12997,
        2059, 1121, 12999, 12998, 13010, 2800, 13012, 13011, 13031, 13005, 720, 13131, 13099, 13097, 13114, 13094, 13079, 1717,
        12976, 12975, 5423, 935, 13136, 12984, 12983, 12989, 12992, 12990, 2256, 890, 3021, 2236, 2194, 13041, 13016, 4454, 4446, 2011, 13062,
        13032, 2098, 1493, 13057, 3203, 13024, 2878 }
end

-- 黑名单
BG.Loot.blacklist = {
    19708, 19713, 19715, 19711, 19710, 19712, 19707, 19714, 19709, -- ZUG蓝色宝石
    20873, 20869, 20866, 20870, 20868, 20871, 20867, 20872,        -- TAQ蓝色雕像
    22682,                                                         -- NAXX冰冻符文
    19017, 22734, 22733,                                           -- 风剑精华、橙杖末端、橙杖顶部
}
-- 白名单
BG.Loot.whitelist = {
    17962, 17963, 17964, 17965, 17969, --[一袋宝石]
    17966,                             --[奥妮克希亚皮袋]
    11382,                             --[山脉之血]
    17012,                             --[熔火犬皮]
    19939, 19942, 19940, 19941,        --ZUG隐藏boss掉落的职业物品
    -- , --[]
    -- , --[]
    -- , --[]
}

-- BOSS战ID
do
    BG.Loot.encounterID = {
        ["BD"] = {
            ["2694"] = 1,
            ["2697"] = 2,
            ["2699"] = 3,
            ["2704"] = 4,
            ["2710"] = 5,
            ["2825"] = 6,
            ["2891"] = 7,
        }
    }
end
