local _, ADDONSELF = ...

local L = ADDONSELF.L

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
    for b = 1, 22 do
        BG.Boss[FB]["boss" .. b] = {}
    end
end

-- Boss名字
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
for b = 1, Size(BG.Boss[FB]), 1 do
    BG.Boss[FB]["boss" .. b].name = boss[b] and boss[b].name
    BG.Boss[FB]["boss" .. b].name2 = boss[b] and string.gsub(string.gsub(boss[b].name, "-\n", ""), "\n", "")
    BG.Boss[FB]["boss" .. b].color = boss[b] and boss[b].color
end


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
for b = 1, Size(BG.Boss[FB]), 1 do
    BG.Boss[FB]["boss" .. b].name = boss[b] and boss[b].name
    BG.Boss[FB]["boss" .. b].name2 = boss[b] and string.gsub(string.gsub(boss[b].name, "-\n", ""), "\n", "")
    BG.Boss[FB]["boss" .. b].color = boss[b] and boss[b].color
end


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
for b = 1, Size(BG.Boss[FB]), 1 do
    BG.Boss[FB]["boss" .. b].name = boss[b] and boss[b].name
    BG.Boss[FB]["boss" .. b].name2 = boss[b] and string.gsub(string.gsub(boss[b].name, "-\n", ""), "\n", "")
    BG.Boss[FB]["boss" .. b].color = boss[b] and boss[b].color
end


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
for b = 1, Size(BG.Boss[FB]), 1 do
    BG.Boss[FB]["boss" .. b].name = boss[b] and boss[b].name
    BG.Boss[FB]["boss" .. b].name2 = boss[b] and string.gsub(string.gsub(boss[b].name, "-\n", ""), "\n", "")
    BG.Boss[FB]["boss" .. b].color = boss[b] and boss[b].color
end
