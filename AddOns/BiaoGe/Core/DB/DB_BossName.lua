local _, ADDONSELF = ...

local L = ADDONSELF.L

local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi

local RR = "|r"
ADDONSELF.RR = RR
local NN = "\n"
ADDONSELF.NN = NN
local RN = "|r\n"
ADDONSELF.RN = RN

local pt = print

local function Size(t)
    local s = 0
    for k, v in pairs(t) do
        if v ~= nil then s = s + 1 end
    end
    return s
end

BG.Boss = {}
for key, FB in pairs(BG.FBtable) do
    BG.Boss[FB] = {}
    for b = 1, Maxb[FB] + 2 do
        BG.Boss[FB]["boss" .. b] = {}
    end
end

local function AddDB(FB, boss)
    for b = 1, Maxb[FB] + 2 do
        BG.Boss[FB]["boss" .. b].name = boss[b].name
        BG.Boss[FB]["boss" .. b].name2 = string.gsub(string.gsub(boss[b].name, "-\n", ""), "\n", "")
        BG.Boss[FB]["boss" .. b].color = boss[b].color
    end
end

-- Boss名字
if BG.IsVanilla_Sod() then
    local boss = {
        { name = L["阿\n奎\n尼\n斯\n男\n爵"], color = "90EE90" },
        { name = L["加\n摩\n拉"], color = "C0C0C0" },
        { name = L["萨\n利\n维\n丝"], color = "FF69B4" },
        { name = L["格\n里\n哈\n斯\n特"], color = "7B68EE" },
        { name = L["洛\n古\n斯\n·\n杰\n特"], color = "FFFF00" },
        { name = L["梦\n游\n者\n克\n尔\n里\n斯"], color = "9932CC" },
        { name = L["阿\n库\n麦\n尔"], color = "00BFFF" },
        { name = L["杂\n\n项"], color = "ffffff" },
        { name = L["罚\n\n款"], color = "ffffff" },
        { name = L["支\n\n出"], color = "00FF00" },
        { name = L["总\n览"], color = "EE82EE" },
    }
    local FB = "BD"
    AddDB(FB, boss)
elseif BG.IsVanilla_60() then
    local boss = {
        { name = L["鲁\n西\n弗\n隆"], color = "90EE90" },
        { name = L["玛\n格\n曼\n达"], color = "90EE90" },
        { name = L["基\n赫\n纳\n斯"], color = "CC9966" },
        { name = L["加\n尔"], color = "CC9966" },
        { name = L["沙\n斯\n拉\n尔"], color = "99FFFF" },
        { name = L["迦\n顿\n男\n爵"], color = "99FFFF" },
        { name = L["古\n雷\n曼\n格"], color = "FFFF00" },
        { name = L["萨\n弗\n隆\n先\n驱\n者"], color = "FFFF00" },
        { name = L["埃\n克\n索\n图\n斯"], color = "FF6699" },
        { name = L["拉\n格\n纳\n罗\n斯"], color = "FF6699" },
        { name = L["奥\n妮\n克\n希\n亚"], color = "CC6600" },
        { name = L["杂\n\n项"], color = "ffffff" },
        { name = L["罚\n\n款"], color = "ffffff" },
        { name = L["支\n\n出"], color = "00FF00" },
        { name = L["总\n览"], color = "EE82EE" },
    }
    AddDB("MC", boss)


    local boss = {
        { name = L["狂\n野\n的\n拉\n佐\n格\n尔"], color = "DA70D6" },
        { name = L["堕\n落\n的\n瓦\n拉\n斯\n塔\n兹"], color = "DA70D6" },
        { name = L["勒\n什\n雷\n尔"], color = "D2B48C" },
        { name = L["费\n尔\n默"], color = "D2B48C" },
        { name = L["埃\n博\n诺\n克"], color = "FFFF00" },
        { name = L["弗\n莱\n格\n尔"], color = "FFFF00" },
        { name = L["克\n洛\n玛\n古\n斯"], color = "9370DB" },
        { name = L["奈\n法\n利\n安"], color = "D2691E" },
        { name = L["杂\n\n项"], color = "ffffff" },
        { name = L["罚\n\n款"], color = "ffffff" },
        { name = L["支\n\n出"], color = "00FF00" },
        { name = L["总\n览"], color = "EE82EE" },
    }
    AddDB("BWL", boss)


    local boss = {
        { name = L["耶\n克\n里\n克"], color = "98FB98" },
        { name = L["温\n诺\n希\n斯"], color = "98FB98" },
        { name = L["玛\n尔\n里"], color = "EE82EE" },
        { name = L["血\n领\n主\n曼\n多\n基\n尔"], color = "EE82EE" },
        { name = L["疯\n狂\n之\n缘"], color = "00BFFF" },
        { name = L["加\n兹\n兰\n卡"], color = "00BFFF" },
        { name = L["塞\n卡\n尔"], color = "00FF00" },
        { name = L["娅\n尔\n罗"], color = "00FF00" },
        { name = L["妖\n术\n师\n金\n度"], color = "FFFF00" },
        { name = L["哈\n卡"], color = "FF4500" },
        { name = L["杂\n\n项"], color = "ffffff" },
        { name = L["罚\n\n款"], color = "ffffff" },
        { name = L["支\n\n出"], color = "00FF00" },
        { name = L["总\n览"], color = "EE82EE" },
    }
    AddDB("ZUG", boss)


    local boss = {
        { name = L["库\n林\n纳\n克\n斯"], color = "CC9966" },
        { name = L["拉\n贾\n克\n斯\n将\n军"], color = "CC9966" },
        { name = L["莫\n阿\n姆"], color = "CC9966" },
        { name = L["吞\n咽\n者\n布\n鲁"], color = "BA55D3" },
        { name = L["狩\n猎\n者\n阿\n亚\n米\n斯"], color = "BA55D3" },
        { name = L["无\n疤\n者\n奥\n斯\n里\n安"], color = "00BFFF" },
        { name = L["杂\n\n项"], color = "ffffff" },
        { name = L["罚\n\n款"], color = "ffffff" },
        { name = L["支\n\n出"], color = "00FF00" },
        { name = L["总\n览"], color = "EE82EE" },
    }
    AddDB("AQL", boss)


    local boss = {
        { name = L["预\n言\n者\n斯\n克\n拉\n姆"], color = "FFB6C1" },
        { name = L["安\n其\n拉\n三\n宝"], color = "FFB6C1" },
        { name = L["沙\n尔\n图\n拉"], color = "FF8C00" },
        { name = L["顽\n强\n的\n范\n克\n瑞\n斯"], color = "FF8C00" },
        { name = L["维\n希\n度\n斯"], color = "90EE90" },
        { name = L["哈\n霍\n兰\n公\n主"], color = "90EE90" },
        { name = L["双\n子\n皇\n帝"], color = "BA55D3" },
        { name = L["奥\n罗"], color = "BA55D3" },
        { name = L["克\n苏\n恩"], color = "C0C0C0" },
        { name = L["杂\n\n项"], color = "ffffff" },
        { name = L["罚\n\n款"], color = "ffffff" },
        { name = L["支\n\n出"], color = "00FF00" },
        { name = L["总\n览"], color = "EE82EE" },
    }
    AddDB("TAQ", boss)


    local boss = {
        { name = L["阿\n努\n布\n雷\n坎"], color = "7B68EE", },
        { name = L["黑\n女\n巫\n法\n琳\n娜"], color = "7B68EE", },
        { name = L["迈\n克\n斯\n纳"], color = "7B68EE", },
        { name = L["瘟\n疫\n使\n者\n诺\n斯"], color = "9932CC", },
        { name = L["肮\n脏\n的\n希\n尔\n盖"], color = "9932CC", },
        { name = L["洛\n欧\n塞\n布"], color = "9932CC", },
        { name = L["教\n官"], color = "FF69B4", },
        { name = L["收\n割\n者\n戈\n提\n克"], color = "FF69B4", },
        { name = L["天\n启\n四\n骑\n士"], color = "FF69B4", },
        { name = L["帕\n奇\n维\n克"], color = "FFD100", },
        { name = L["格\n罗\n布\n鲁\n斯"], color = "FFD100", },
        { name = L["格\n拉\n斯"], color = "FFD100", },
        { name = L["塔\n迪\n乌\n斯"], color = "FFD100", },
        { name = L["萨\n菲\n隆"], color = "90EE90", },
        { name = L["克\n尔\n苏\n加\n德"], color = "90EE90", },
        { name = L["杂\n\n项"], color = "ffffff", },
        { name = L["罚\n\n款"], color = "ffffff", },
        { name = L["支\n\n出"], color = "00FF00", },
        { name = L["总\n览"], color = "EE82EE", },
    }
    AddDB("NAXX", boss)
else
    local boss = {
        { name = L["玛\n洛\n加\n尔"], color = "D3D3D3" },
        { name = L["亡\n语\n者\n女\n士"], color = "D3D3D3" },
        { name = L["炮\n舰\n战"], color = "FFD700" },
        { name = L["萨\n鲁\n法\n尔"], color = "FFD700" },
        { name = L["烂\n肠"], color = "FF7F50" },
        { name = L["腐\n面"], color = "FF7F50" },
        { name = L["普\n崔\n塞\n德\n教\n授"], color = "FF7F50" },
        { name = L["鲜\n血\n议\n会"], color = "FF69B4" },
        { name = L["鲜\n血\n女\n王"], color = "FF69B4" },
        { name = L["踏\n梦\n者"], color = "90EE90" },
        { name = L["辛\n达\n苟\n萨"], color = "90EE90" },
        { name = L["巫\n妖\n王"], color = "00BFFF" },
        { name = L["海\n里\n昂"], color = "993300" },
        { name = L["杂\n\n项"], color = "ffffff" },
        { name = L["罚\n\n款"], color = "ffffff" },
        { name = L["支\n\n出"], color = "00FF00" },
        { name = L["总\n览"], color = "EE82EE" },
    }
    local FB = "ICC"
    AddDB(FB, boss)


    local boss = {
        { name = L["诺\n森\n德\n猛\n兽"], color = "32CD32" },
        { name = L["加\n拉\n克\n苏\n斯"], color = "CD5C5C" },
        { name = L["阵\n营\n冠\n军"], color = "FFD700" },
        { name = L["瓦\n克\n里\n双\n子"], color = "7B68EE" },
        { name = L["阿\n努\n巴\n拉\n克"], color = "00BFFF" },
        { name = L["嘉\n奖\n宝\n箱"], color = "FFFF00" },
        { name = L["奥\n妮\n克\n希\n亚"], color = "CC6600" },
        { name = L["杂\n\n项"], color = "ffffff" },
        { name = L["罚\n\n款"], color = "ffffff" },
        { name = L["支\n\n出"], color = "00FF00" },
        { name = L["总\n览"], color = "EE82EE" },
    }
    local FB = "TOC"
    AddDB(FB, boss)


    local boss = {
        { name = L["烈\n焰\n巨\n兽"], color = "90EE90", },
        { name = L["锋\n鳞"], color = "90EE90", },
        { name = L["掌\n炉\n者"], color = "90EE90", },
        { name = L["拆\n解\n者"], color = "90EE90", },
        { name = L["钢\n铁\n议\n会"], color = "7B68EE", },
        { name = L["科\n隆\n加\n恩"], color = "7B68EE", },
        { name = L["欧\n尔\n利\n亚"], color = "7B68EE", },
        { name = L["霍\n迪\n尔"], color = "FFD100", },
        { name = L["托\n里\n姆"], color = "FFD100", },
        { name = L["弗\n蕾\n亚"], color = "FFD100", },
        { name = L["米\n米\n尔\n隆"], color = "FFD100", },
        { name = L["维\n扎\n克\n斯\n将\n军"], color = "9932CC", },
        { name = L["尤\n格\n萨\n隆"], color = "9932CC", },
        { name = L["奥\n尔\n加\n隆"], color = "00BFFF", },
        { name = L["杂\n\n项"], color = "ffffff", },
        { name = L["罚\n\n款"], color = "ffffff", },
        { name = L["支\n\n出"], color = "00FF00", },
        { name = L["总\n览"], color = "EE82EE", },
    }
    local FB = "ULD"
    AddDB(FB, boss)


    local boss = {
        { name = L["阿\n努\n布\n雷\n坎"], color = "7B68EE", },
        { name = L["黑\n女\n巫\n法\n琳\n娜"], color = "7B68EE", },
        { name = L["迈\n克\n斯\n纳"], color = "7B68EE", },
        { name = L["瘟\n疫\n使\n者\n诺\n斯"], color = "9932CC", },
        { name = L["肮\n脏\n的\n希\n尔\n盖"], color = "9932CC", },
        { name = L["洛\n欧\n塞\n布"], color = "9932CC", },
        { name = L["教\n官"], color = "FF69B4", },
        { name = L["收\n割\n者\n戈\n提\n克"], color = "FF69B4", },
        { name = L["天\n启\n四\n骑\n士"], color = "FF69B4", },
        { name = L["帕\n奇\n维\n克"], color = "FFD100", },
        { name = L["格\n罗\n布\n鲁\n斯"], color = "FFD100", },
        { name = L["格\n拉\n斯"], color = "FFD100", },
        { name = L["塔\n迪\n乌\n斯"], color = "FFD100", },
        { name = L["萨\n菲\n隆"], color = "90EE90", },
        { name = L["克\n尔\n苏\n加\n德"], color = "90EE90", },
        { name = L["萨\n塔\n里\n奥"], color = "87CEFA", },
        { name = L["玛\n里\n苟\n斯"], color = "87CEFA", },
        { name = L["杂\n\n项"], color = "ffffff", },
        { name = L["罚\n\n款"], color = "ffffff", },
        { name = L["支\n\n出"], color = "00FF00", },
        { name = L["总\n览"], color = "EE82EE", },
    }
    local FB = "NAXX"
    AddDB(FB, boss)
end
