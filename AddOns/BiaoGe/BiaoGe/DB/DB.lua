local AddonName, ADDONSELF = ...

local L = ADDONSELF.L

local pt = print

local RR = "|r"
ADDONSELF.RR = RR
local NN = "\n"
ADDONSELF.NN = NN
local RN = "|r\n"
ADDONSELF.RN = RN

local LibBG = LibStub:GetLibrary("LibUIDropDownMenu-4.0") -- 调用库菜单UI
ADDONSELF.LibBG = LibBG

C_ChatInfo.RegisterAddonMessagePrefix("BiaoGe")                                    -- 注册插件通信频道
C_ChatInfo.RegisterAddonMessagePrefix("BiaoGeYY")                                  -- 注册插件通信频道（用于YY评价）

CreateFrame("GameTooltip", "BiaoGeFilterTooltip", UIParent, "GameTooltipTemplate") -- 用于收集提示工具文字

local l = GetLocale()
if (l == "koKR") then
    BIAOGE_TEXT_FONT = "Fonts\\2002.TTF";
elseif (l == "zhCN") then
    BIAOGE_TEXT_FONT = "Fonts\\ARKai_T.ttf";
elseif (l == "zhTW") then
    BIAOGE_TEXT_FONT = "Fonts\\bHEI00M.ttf";
    -- BIAOGE_TEXT_FONT = "Fonts\\blei00d.TTF";
elseif (l == "ruRU") then
    BIAOGE_TEXT_FONT = "Fonts\\FRIZQT___CYR.TTF";
else
    BIAOGE_TEXT_FONT = "Fonts\\FRIZQT__.TTF";
end

local function Size(t)
    local s = 0;
    for k, v in pairs(t) do
        if v ~= nil then s = s + 1 end
    end
    return s;
end
local function RGB(hex)
    local red = string.sub(hex, 1, 2)
    local green = string.sub(hex, 3, 4)
    local blue = string.sub(hex, 5, 6)

    red = tonumber(red, 16) / 255
    green = tonumber(green, 16) / 255
    blue = tonumber(blue, 16) / 255
    return red, green, blue
end

local RealmId = GetRealmID()
local player = UnitName("player")
local FB = { "NAXX", "ULD", "TOC", "ICC" }

-- 全局变量
BG = {}
do
    BG.FBtable = FB

    BG.FB1 = "TOC"
    if select(4, GetBuildInfo()) >= 30403 then
        BG.FB1 = "ICC"
    end

    BG.NAXXname = GetRealZoneText(533)
    BG.ULDname = GetRealZoneText(603)
    BG.TOCname = GetRealZoneText(649)
    BG.ICCname = GetRealZoneText(631)

    BG.Movetable = {}
    BG.options = {}

    -- 表格
    do
        -- 表格UI
        BG.Frame = {}
        for index, value in ipairs(FB) do
            BG.Frame[value] = {}
            for b = 1, 22 do
                BG.Frame[value]["boss" .. b] = {}
            end
        end

        -- 底色
        BG.FrameDs = {}
        for index, value in ipairs(FB) do
            for i = 1, 3, 1 do
                BG.FrameDs[value .. i] = {}
                for b = 1, 22 do
                    BG.FrameDs[value .. i]["boss" .. b] = {}
                end
            end
        end

        -- 心愿UI
        BG.HopeFrame = {}
        for index, value in ipairs(FB) do
            BG.HopeFrame[value] = {}
            for n = 1, 4 do
                BG.HopeFrame[value]["nandu" .. n] = {}
                for b = 1, 22 do
                    BG.HopeFrame[value]["nandu" .. n]["boss" .. b] = {}
                end
            end
        end

        -- 心愿底色
        BG.HopeFrameDs = {}
        for index, value in ipairs(FB) do
            for t = 1, 3, 1 do
                BG.HopeFrameDs[value .. t] = {}
                for n = 1, 4 do
                    BG.HopeFrameDs[value .. t]["nandu" .. n] = {}
                    for b = 1, 22 do
                        BG.HopeFrameDs[value .. t]["nandu" .. n]["boss" .. b] = {}
                    end
                end
            end
        end

        -- 历史UI
        BG.HistoryFrame = {}
        for index, value in ipairs(FB) do
            BG.HistoryFrame[value] = {}
            for b = 1, 22 do
                BG.HistoryFrame[value]["boss" .. b] = {}
            end
        end

        -- 历史底色
        BG.HistoryFrameDs = {}
        for index, value in ipairs(FB) do
            for i = 1, 3, 1 do
                BG.HistoryFrameDs[value .. i] = {}
                for b = 1, 22 do
                    BG.HistoryFrameDs[value .. i]["boss" .. b] = {}
                end
            end
        end

        -- 接收UI
        BG.ReceiveFrame = {}
        for index, value in ipairs(FB) do
            BG.ReceiveFrame[value] = {}
            for b = 1, 22 do
                BG.ReceiveFrame[value]["boss" .. b] = {}
            end
        end

        -- 接收底色
        BG.ReceiveFrameDs = {}
        for index, value in ipairs(FB) do
            for i = 1, 3, 1 do
                BG.ReceiveFrameDs[value .. i] = {}
                for b = 1, 22 do
                    BG.ReceiveFrameDs[value .. i]["boss" .. b] = {}
                end
            end
        end

        -- 对账UI
        BG.DuiZhangFrame = {}
        for index, value in ipairs(FB) do
            BG.DuiZhangFrame[value] = {}
            for b = 1, 22 do
                BG.DuiZhangFrame[value]["boss" .. b] = {}
            end
        end

        -- 对账底色
        BG.DuiZhangFrameDs = {}
        for index, value in ipairs(FB) do
            for i = 1, 3, 1 do
                BG.DuiZhangFrameDs[value .. i] = {}
                for b = 1, 22 do
                    BG.DuiZhangFrameDs[value .. i]["boss" .. b] = {}
                end
            end
        end
    end

    -- 字体
    do
        BG.FontBlue1 = CreateFont("BG.FontBlue1")
        BG.FontBlue1:SetTextColor(RGB("00BFFF"))
        BG.FontBlue1:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")

        BG.FontBlue1Left = CreateFont("BG.FontBlue1Left")
        BG.FontBlue1Left:SetTextColor(RGB("00BFFF"))
        BG.FontBlue1Left:SetJustifyH("LEFT")
        BG.FontBlue1Left:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")

        BG.FontGold1 = CreateFont("BG.FontGold1")
        BG.FontGold1:SetTextColor(RGB("FFD100"))
        BG.FontGold1:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")

        local color = "Green1" -- BG.FontGreen1
        BG["Font" .. color] = CreateFont("BG.Font" .. color)
        BG["Font" .. color]:SetTextColor(RGB("00FF00"))
        BG["Font" .. color]:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")

        BG.FontRed1 = CreateFont("BG.FontRed1")
        BG.FontRed1:SetTextColor(RGB("FF0000"))
        BG.FontRed1:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")

        BG.FontRed2 = CreateFont("BG.FontRed2")
        BG.FontRed2:SetTextColor(RGB("DC143C"))
        BG.FontRed2:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")

        BG.FontFen1 = CreateFont("BG.FontFen1")
        BG.FontFen1:SetTextColor(RGB("FF69B4"))
        BG.FontFen1:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")

        local color = "While1" -- BG.FontWhile1
        BG["Font" .. color] = CreateFont("BG.Font" .. color)
        BG["Font" .. color]:SetTextColor(RGB("FFFFFF"))
        BG["Font" .. color]:SetFont(BIAOGE_TEXT_FONT, 18, "OUTLINE")

        local color = "While2" -- BG.FontWhile2
        BG["Font" .. color] = CreateFont("BG.Font" .. color)
        BG["Font" .. color]:SetTextColor(RGB("FFFFFF"))
        BG["Font" .. color]:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")

        BG.FontHilight = CreateFont("BG.FontHilight")
        BG.FontHilight:SetTextColor(RGB("FFFFFF"))
        BG.FontHilight:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")

        BG.FontHilightLeft = CreateFont("BG.FontHilightLeft")
        BG.FontHilightLeft:SetTextColor(RGB("FFFFFF"))
        BG.FontHilightLeft:SetJustifyH("LEFT")
        BG.FontHilightLeft:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")

        BG.FontDisabled = CreateFont("BG.FontDisabled")
        BG.FontDisabled:SetTextColor(RGB("808080"))
        BG.FontDisabled:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
    end

    -- 函数：给文本上颜色
    do
        BG.b1 = "00BFFF"
        function BG.STC_b1(text)
            if text then
                local t
                t = "|cff" .. "00BFFF" .. text .. "|r"
                return t
            end
        end

        BG.r1 = "FF0000"
        function BG.STC_r1(text)
            if text then
                local t
                t = "|cff" .. "FF0000" .. text .. "|r"
                return t
            end
        end

        function BG.STC_r2(text)
            if text then
                local t
                t = "|cff" .. "FF1493" .. text .. "|r"
                return t
            end
        end

        function BG.STC_r3(text)
            if text then
                local t
                t = "|cff" .. "FF69B4" .. text .. "|r"
                return t
            end
        end

        BG.g1 = "00FF00"
        function BG.STC_g1(text)
            if text then
                local t
                t = "|cff" .. "00FF00" .. text .. "|r"
                return t
            end
        end

        BG.g2 = "90EE90"
        function BG.STC_g2(text)
            if text then
                local t
                t = "|cff" .. "90EE90" .. text .. "|r"
                return t
            end
        end

        BG.y1 = "FFFF00"
        function BG.STC_y1(text) -- yellow
            if text then
                local t
                t = "|cff" .. "FFFF00" .. text .. "|r"
                return t
            end
        end

        BG.y2 = "FFD100"
        function BG.STC_y2(text) -- gold
            if text then
                local t
                t = "|cff" .. "FFD100" .. text .. "|r"
                return t
            end
        end

        BG.w1 = "FFFFFF"
        function BG.STC_w1(text) -- 白色
            if text then
                local t
                t = "|cff" .. "FFFFFF" .. text .. "|r"
                return t
            end
        end

        BG.dis = "808080"
        function BG.STC_dis(text) -- 灰色
            if text then
                local t
                t = "|cff" .. "808080" .. text .. "|r"
                return t
            end
        end
    end

    -- 声音
    do
        BG.sound1 = SOUNDKIT.GS_TITLE_OPTION_OK
        BG.sound2 = 569593
        BG.sound_paimai = "Interface\\AddOns\\BiaoGe\\Media\\sound\\paimai.mp3"
        BG.sound_hope = "Interface\\AddOns\\BiaoGe\\Media\\sound\\hope.mp3"
        BG.sound_qingkong = "Interface\\AddOns\\BiaoGe\\Media\\sound\\qingkong.mp3"
    end

    -- 高亮天赋装备
    do
        BG.Icon = {
            ["DEATHKNIGHT" .. "1"] = "Interface/Icons/spell_deathknight_bloodpresence", -- 血脸T
            ["DEATHKNIGHT" .. "2"] = "Interface/Icons/inv_sword_122",                   -- 杀戮机器DPS
            ["WARRIOR" .. "1"] = "Interface/Icons/ability_warrior_defensivestance",     -- 防御姿势T
            ["WARRIOR" .. "2"] = "Interface/Icons/INV_Sword_48",                        -- 斩杀DPS
            ["PALADIN" .. "1"] = "Interface/Icons/spell_holy_holybolt",                 -- 圣光N
            ["PALADIN" .. "2"] = "Interface/Icons/spell_holy_devotionaura",             -- 虔诚T
            ["PALADIN" .. "3"] = "Interface/Icons/spell_holy_auraoflight",              -- 惩戒DPS
            ["HUNTER" .. "1"] = "Interface/Icons/classicon_hunter",                     -- LR
            ["SHAMAN" .. "1"] = "Interface/Icons/spell_nature_lightning",               -- 闪电箭FXDPS
            ["SHAMAN" .. "2"] = "Interface/Icons/spell_nature_lightningshield",         -- 闪电之盾DPS
            ["SHAMAN" .. "3"] = "Interface/Icons/spell_nature_magicimmunity",           -- 治疗波N
            ["DRUID" .. "1"] = "Interface/Icons/spell_nature_starfall",                 -- 月火FXDPS
            ["DRUID" .. "2"] = "Interface/Icons/ability_racial_bearform",               -- 熊T
            ["DRUID" .. "3"] = "Interface/Icons/ability_druid_catform",                 -- 猎豹形态DPS
            ["DRUID" .. "4"] = "Interface/Icons/spell_nature_healingtouch",             -- 治疗之触N
            ["ROGUE" .. "1"] = "Interface/Icons/classicon_rogue",                       -- DZ
            ["WARLOCK" .. "1"] = "Interface/Icons/classicon_warlock",                   -- SS
            ["MAGE" .. "1"] = "Interface/Icons/classicon_mage",                         -- FS
            ["PRIEST" .. "1"] = "Interface/Icons/spell_holy_wordfortitude",             -- 真言术：韧N
            ["PRIEST" .. "2"] = "Interface/Icons/spell_shadow_shadowwordpain",          -- 暗言术：痛AM
        }

        local G = {
            ["法术强度"] = ITEM_MOD_SPELL_POWER_SHORT,
            ["法力值"] = ITEM_MOD_MANA_SHORT,
            ["招架"] = ITEM_MOD_PARRY_RATING_SHORT,
            ["防御"] = ITEM_MOD_DEFENSE_SKILL_RATING_SHORT,
            ["躲闪"] = ITEM_MOD_DODGE_RATING_SHORT,
            ["格挡"] = ITEM_MOD_BLOCK_RATING_SHORT,
            ["力量"] = ITEM_MOD_STRENGTH_SHORT,
            ["精准"] = STAT_EXPERTISE,
            ["敏捷"] = SPEC_FRAME_PRIMARY_STAT_AGILITY,
            ["攻击强度"] = ITEM_MOD_ATTACK_POWER_SHORT,
            ["护甲穿透"] = ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT,
            ["命中"] = ITEM_MOD_HIT_RATING_SHORT,
        }

        local t1 = { G["法术强度"], G["法力值"], } -- FZ, FQ
        local t2 = { G["法术强度"], G["法力值"], G["格挡"], } -- DKT
        local t3 = { G["法术强度"], G["法力值"], G["格挡"], G["招架"], } -- 熊T
        local wl1 = { G["法术强度"], G["法力值"], G["防御"], G["格挡"], G["躲闪"], G["招架"], } -- 物理DPS
        local wl2 = { G["防御"], G["格挡"], G["躲闪"], G["招架"] } -- ZQS
        local wl3 = { G["力量"], G["精准"], G["法术强度"], G["法力值"], G["防御"], G["格挡"], G["躲闪"], G["招架"], } -- LR
        local fx1 = { G["力量"], G["敏捷"], G["攻击强度"], G["护甲穿透"], G["精准"], G["防御"], G["格挡"], G["躲闪"], G["招架"] } -- 法系DPS
        local n1 = { G["力量"], G["敏捷"], G["攻击强度"], G["护甲穿透"], G["精准"], G["防御"], G["格挡"], G["躲闪"], G["招架"], G["命中"] } -- 奶

        BG.DisXd = string.gsub(ITEM_MOD_FERAL_ATTACK_POWER, "%%s", "(.+)") -- 小德的武器词缀：在猎豹、熊等等攻击强度提高%s点

        BG.DisClassTextLeft = { -- 装备属性
            ["DEATHKNIGHT" .. "1"] = t2, -- 血DK
            ["DEATHKNIGHT" .. "2"] = wl1, -- DPS
            ["WARRIOR" .. "1"] = t1, -- FZ
            ["WARRIOR" .. "2"] = wl1, -- DPS
            ["PALADIN" .. "1"] = n1, -- NQ
            ["PALADIN" .. "2"] = t1, -- FQ
            ["PALADIN" .. "3"] = wl1, -- CJQ
            ["HUNTER" .. "1"] = wl3, -- LR
            ["SHAMAN" .. "1"] = fx1, -- 元素
            ["SHAMAN" .. "2"] = wl2, -- ZQS
            ["SHAMAN" .. "3"] = n1, -- NS
            ["DRUID" .. "1"] = fx1, -- 咕咕
            ["DRUID" .. "2"] = t3, -- 熊T
            ["DRUID" .. "3"] = wl1, -- 猫D
            ["DRUID" .. "4"] = n1, -- ND
            ["ROGUE" .. "1"] = wl1, -- DZ
            ["WARLOCK" .. "1"] = fx1, -- SS
            ["MAGE" .. "1"] = fx1, -- FS
            ["PRIEST" .. "1"] = n1, -- MS
            ["PRIEST" .. "2"] = fx1, -- AM
        }

        BG.DisClassWeapon = {                                                      -- 武器
            ["DEATHKNIGHT" .. "1"] = { 2, 3, 10, 13, 15, 16, 18, 19 },             -- 血DK
            ["DEATHKNIGHT" .. "2"] = { 2, 3, 10, 13, 15, 16, 18, 19 },             -- DPSdk
            ["WARRIOR" .. "1"]     = { 1, 5, 6, 8, 10, 19 },                       -- FZ
            ["WARRIOR" .. "2"]     = { 0, 4, 7, 13, 15, 19 },                      -- DPSzs
            ["PALADIN" .. "1"]     = { 2, 3, 10, 13, 15, 16, 18, 19 },             -- NQ
            ["PALADIN" .. "2"]     = { 1, 2, 3, 5, 6, 8, 10, 13, 15, 16, 18, 19 }, -- FQ
            ["PALADIN" .. "3"]     = { 2, 3, 10, 13, 15, 16, 18, 19 },             -- CJQ
            ["HUNTER" .. "1"]      = { 4, 5, 19 },                                 -- LR
            ["SHAMAN" .. "1"]      = { 2, 3, 6, 7, 8, 16, 18, 19 },                -- 元素
            ["SHAMAN" .. "2"]      = { 2, 3, 6, 7, 8, 16, 18, 19 },                -- ZQS
            ["SHAMAN" .. "3"]      = { 2, 3, 6, 7, 8, 16, 18, 19 },                -- NS
            ["DRUID" .. "1"]       = { 0, 1, 2, 3, 7, 8, 16, 18, 19 },             -- 咕咕
            ["DRUID" .. "2"]       = { 0, 1, 2, 3, 7, 8, 16, 18, 19 },             -- 熊T
            ["DRUID" .. "3"]       = { 0, 1, 2, 3, 7, 8, 16, 18, 19 },             -- 猫D
            ["DRUID" .. "4"]       = { 0, 1, 2, 3, 7, 8, 16, 18, 19 },             -- ND
            ["ROGUE" .. "1"]       = { 1, 5, 6, 8, 10, 19, },                      -- DZ
            ["WARLOCK" .. "1"]     = { 0, 1, 2, 3, 4, 5, 6, 8, 13, 16, 18 },       -- SS
            ["MAGE" .. "1"]        = { 0, 1, 2, 3, 4, 5, 6, 8, 13, 16, 18 },       -- FS
            ["PRIEST" .. "1"]      = { 0, 1, 2, 3, 5, 6, 7, 8, 13, 16, 18 },       -- MS
            ["PRIEST" .. "2"]      = { 0, 1, 2, 3, 5, 6, 7, 8, 13, 16, 18 },       -- AM

            -- 0 单手斧
            -- 1 双手斧
            -- 2 弓	
            -- 3 枪
            -- 4 单手锤	
            -- 5 双手锤	
            -- 6 长柄武器
            -- 7 单手剑	
            -- 8 双手剑	
            -- 10 法杖	
            -- 13 拳套
            -- 15 匕首
            -- 16 投掷武器
            -- 18 弩
            -- 19 魔杖
            -- 20 钓鱼竿
        }

        BG.DisClassArmor = {                                      -- 盔甲
            ["DEATHKNIGHT" .. "1"] = { 2, 3, 6, 7, 8, 9 },        -- 血DK
            ["DEATHKNIGHT" .. "2"] = { 6, 7, 8, 9 },              -- DPS
            ["WARRIOR" .. "1"]     = { 2, 3, 7, 8, 9, 10 },       -- FZ
            ["WARRIOR" .. "2"]     = { 6, 7, 8, 9, 10 },          -- DPS
            ["PALADIN" .. "1"]     = { 8, 9, 10 },                -- NQ
            ["PALADIN" .. "2"]     = { 2, 3, 8, 9, 10 },          -- FQ
            ["PALADIN" .. "3"]     = { 6, 8, 9, 10 },             -- CJQ
            ["HUNTER" .. "1"]      = { 4, 6, 7, 8, 9, 10 },       -- LR
            ["SHAMAN" .. "1"]      = { 4, 7, 8, 10 },             -- 元素
            ["SHAMAN" .. "2"]      = { 4, 6, 7, 8, 10 },          -- ZQS
            ["SHAMAN" .. "3"]      = { 4, 7, 8, 10 },             -- NS
            ["DRUID" .. "1"]       = { 3, 4, 6, 7, 9, 10 },       -- 咕咕
            ["DRUID" .. "2"]       = { 3, 4, 6, 7, 9, 10 },       -- 熊T
            ["DRUID" .. "3"]       = { 3, 4, 6, 7, 9, 10 },       -- 猫D
            ["DRUID" .. "4"]       = { 3, 4, 6, 7, 9, 10 },       -- ND
            ["ROGUE" .. "1"]       = { 3, 4, 6, 7, 8, 9, 10 },    -- DZ
            ["WARLOCK" .. "1"]     = { 2, 3, 4, 6, 7, 8, 9, 10 }, -- SS
            ["MAGE" .. "1"]        = { 2, 3, 4, 6, 7, 8, 9, 10 }, -- FS
            ["PRIEST" .. "1"]      = { 2, 3, 4, 6, 7, 8, 9, 10 }, -- MS
            ["PRIEST" .. "2"]      = { 2, 3, 4, 6, 7, 8, 9, 10 }, -- AM

            -- 1 布甲	
            -- 2 皮甲
            -- 3 锁甲
            -- 4 板甲	
            -- 6 盾牌
            -- 7 圣契
            -- 8 神像	
            -- 9 图腾	
            -- 10 魔印	
        }
    end
end


-- 数据库（保存至本地）
local function DataBase()
    ------------------BiaoGe账号数据------------------
    do
        if BiaoGe then
            if type(BiaoGe) ~= "table" then
                BiaoGe = {}
            end
        else
            BiaoGe = {}
        end
        if not BiaoGe.point then
            BiaoGe.point = {}
        end
        if not BiaoGe.duizhang then
            BiaoGe.duizhang = {}
        end
        if not BiaoGe.BossFrame then
            BiaoGe.BossFrame = {}
        end
        for index, value in ipairs(FB) do
            if not BiaoGe[value] then
                BiaoGe[value] = {}
            end
            for b = 1, 22 do
                if not BiaoGe[value]["boss" .. b] then
                    BiaoGe[value]["boss" .. b] = {}
                end
            end
        end

        if not BiaoGe.HistoryList then
            BiaoGe.HistoryList = {}
        end
        for index, value in ipairs(FB) do
            if not BiaoGe.HistoryList[value] then
                BiaoGe.HistoryList[value] = {}
            end
        end

        if not BiaoGe.History then
            BiaoGe.History = {}
        end
        for index, value in ipairs(FB) do
            if not BiaoGe.History[value] then
                BiaoGe.History[value] = {}
            end
        end

        for index, value in ipairs(FB) do
            if not BiaoGe.BossFrame[value] then
                BiaoGe.BossFrame[value] = {}
            end
        end

        if not BiaoGe.options then
            BiaoGe.options = {}
        end
        if not BiaoGe.options.SearchHistory then
            BiaoGe.options.SearchHistory = {}
        end

        -- 高亮天赋装备
        if not BiaoGe.filterClassNum then
            BiaoGe.filterClassNum = {}
        end
        if not BiaoGe.filterClassNum[RealmId] then
            BiaoGe.filterClassNum[RealmId] = {}
        end
        if not BiaoGe.filterClassNum[RealmId][player] then
            BiaoGe.filterClassNum[RealmId][player] = 0
        end
        if BiaoGeA and BiaoGeA.filterClassNum then
            BiaoGe.filterClassNum[RealmId][player] = BiaoGeA.filterClassNum
            BiaoGeA.filterClassNum = nil
        end

        -- 心愿清单
        if not BiaoGe.Hope then
            BiaoGe.Hope = {}
        end

        if not BiaoGe.Hope[RealmId] then
            BiaoGe.Hope[RealmId] = {}
        end
        if not BiaoGe.Hope[RealmId][player] then
            BiaoGe.Hope[RealmId][player] = {}
        end
        for index, fb in ipairs(FB) do
            if not BiaoGe.Hope[RealmId][player][fb] then
                BiaoGe.Hope[RealmId][player][fb] = {}
            end

            for n = 1, 4 do
                if not BiaoGe.Hope[RealmId][player][fb]["nandu" .. n] then
                    BiaoGe.Hope[RealmId][player][fb]["nandu" .. n] = {}
                    for b = 1, 22 do
                        if not BiaoGe.Hope[RealmId][player][fb]["nandu" .. n]["boss" .. b] then
                            BiaoGe.Hope[RealmId][player][fb]["nandu" .. n]["boss" .. b] = {}
                        end
                    end
                end
            end
        end
        if BiaoGeA and BiaoGeA.Hope then
            for k, v in pairs(BiaoGeA.Hope) do
                BiaoGe.Hope[RealmId][player][k] = v
            end
            BiaoGeA.Hope = nil
        end
    end
end

-- 其他
do
    local Width = {}
    local Height = {}
    local Maxb = {}
    local Maxi = {}

    Width["BG.MainFrame"] = 1710
    Width["ICC"] = 1290
    Width["TOC"] = 1290
    Width["ULD"] = 1290
    Width["NAXX"] = 1710
    ADDONSELF.Width = Width

    Height["BG.MainFrame"] = 945
    Height["ICC"] = 875
    Height["TOC"] = 835
    Height["ULD"] = 875
    Height["NAXX"] = 945
    ADDONSELF.Height = Height

    Maxb["ICC"] = 15
    Maxb["TOC"] = 9
    Maxb["ULD"] = 16
    Maxb["NAXX"] = 19
    ADDONSELF.Maxb = Maxb

    Maxi["ICC"] = 16
    Maxi["TOC"] = 14
    Maxi["ULD"] = 8
    Maxi["NAXX"] = 11
    BG.Maxi = 30
    ADDONSELF.Maxi = Maxi

    local HopeMaxi = 2
    local HopeMaxb = {}
    local HopeMaxn = {}

    ADDONSELF.HopeMaxi = HopeMaxi

    HopeMaxb["ICC"] = Maxb["ICC"] - 1
    HopeMaxb["TOC"] = Maxb["TOC"] - 1
    HopeMaxb["ULD"] = Maxb["ULD"] - 1
    HopeMaxb["NAXX"] = Maxb["NAXX"] - 1
    ADDONSELF.HopeMaxb = HopeMaxb

    HopeMaxn["ICC"] = 4
    HopeMaxn["TOC"] = 4
    HopeMaxn["ULD"] = 2
    HopeMaxn["NAXX"] = 2
    ADDONSELF.HopeMaxn = HopeMaxn
end



local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == AddonName then
        DataBase()
    end
end)
