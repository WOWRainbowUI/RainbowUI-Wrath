local _, ADDONSELF = ...

local LibBG = ADDONSELF.LibBG
local L = ADDONSELF.L

local RR = ADDONSELF.RR
local NN = ADDONSELF.NN
local RN = ADDONSELF.RN
local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi
local HopeMaxn = ADDONSELF.HopeMaxn
local HopeMaxb = ADDONSELF.HopeMaxb
local HopeMaxi = ADDONSELF.HopeMaxi
local Width = ADDONSELF.Width
local Height = ADDONSELF.Height

local pt = print
local RealmId = GetRealmID()
local player = UnitName("player")

------------------函数：是否空表------------------
local function Size(t)
    local s = 0
    for k, v in pairs(t) do
        if v ~= nil then s = s + 1 end
    end
    return s
end
ADDONSELF.Size = Size
------------------函数：第几个BOSS------------------
local function BossNum(FB, b, t)
    local back = 0
    if FB == "ICC" then
        if t == 1 then
            t = 0
        elseif t == 2 then
            t = 8
        elseif t == 3 then
            t = 14
        end
    elseif FB == "TOC" then
        if t == 1 then
            t = 0
        elseif t == 2 then
            t = 5
        elseif t == 3 then
            t = 8
        end
    elseif FB == "ULD" then
        if t == 1 then
            t = 0
        elseif t == 2 then
            t = 7
        elseif t == 3 then
            t = 13
        elseif t == 4 then
            t = 18
        end
    elseif FB == "NAXX" then
        if t == 1 then
            t = 0
        elseif t == 2 then
            t = 6
        elseif t == 3 then
            t = 12
        elseif t == 4 then
            t = 16
        end
    end
    back = b + t
    return back
end
ADDONSELF.BossNum = BossNum

------------------函数：四舍五入------------------ 数字，小数点数
local function Round(number, decimal_places)
    local mult = 10 ^ (decimal_places or 0)
    return math.floor(number * mult + 0.5) / mult
end
ADDONSELF.Round = Round

------------------函数：把16进制颜色转换成0-1RGB------------------
local function RGB(hex, Alpha)
    local red = string.sub(hex, 1, 2)
    local green = string.sub(hex, 3, 4)
    local blue = string.sub(hex, 5, 6)

    red = tonumber(red, 16) / 255
    green = tonumber(green, 16) / 255
    blue = tonumber(blue, 16) / 255

    if Alpha then
        return red, green, blue, Alpha
    else
        return red, green, blue
    end
end
ADDONSELF.RGB = RGB

------------------函数：设置颜色（0-1代码变为16进制颜色）------------------
local function RGB_16(name, c1, c2, c3)
    local name = name
    local c1, c2, c3 = c1, c2, c3
    if not c1 then
        c1, c2, c3 = name:GetTextColor()
        name = name:GetText()
    end
    if tonumber(c1) and name then
        local r = string.format("%X", tonumber(c1) * 255)
        if r and strlen(r) == 1 then
            r = "0" .. r
        end
        local g = string.format("%X", tonumber(c2) * 255)
        if g and strlen(g) == 1 then
            g = "0" .. g
        end
        local b = string.format("%X", tonumber(c3) * 255)
        if b and strlen(b) == 1 then
            b = "0" .. b
        end
        local c = r .. g .. b
        c = "|cff" .. c .. name .. "|r"
        return c
    end
end
ADDONSELF.RGB_16 = RGB_16

------------------在文本里插入材质图标------------------
local function AddTexture(Texture, y)
    if not Texture then
        return ""
    end
    local x = 0
    if not y then
        y = "-0"
    end
    local tex = ""
    local coord = ""
    if Texture == "MAINTANK" then       -- 主坦克
        tex = "132064"
    elseif Texture == "MAINASSIST" then -- 主助理
        tex = "132063"
    elseif Texture == "HEALER" then     -- 治疗职责
        tex = "interface/lfgframe/ui-lfg-icon-roles"
        -- TexCoord_re = ":100:100:33:45:6:19"
        coord = ":100:100:24:50:0:25"
        x = "-2"
        y = "0"
    elseif Texture == 137000 or Texture == 136998 then -- 战场荣誉
        coord = ":100:100:10:60:0:55"
        local t = "|T" .. Texture .. ":0:0:0:0" .. coord .. "|t"
        return t
    else
        tex = Texture
    end
    local t = "|T" .. tex .. ":0:0:" .. x .. ":" .. y .. coord .. "|t"
    return t
end
ADDONSELF.AddTexture = AddTexture

------------------获取文字（删掉材质）------------------
local function GetText_T(bt)
    local text
    if type(bt) == "table" then
        text = bt:GetText()
    else
        text = bt
    end
    local t = string.gsub(text, "|T.-|t", "")
    return t
end
ADDONSELF.GetText_T = GetText_T

------------------函数：获取名字的职业颜色RGB------------------
local function GetClassRGB(name, player, Alpha)
    local _, class
    if player then
        _, class = UnitClass(player)
    else
        _, class = UnitClass(name)
    end
    local c1, c2, c3 = 1, 1, 1
    if class then
        c1, c2, c3 = GetClassColor(class)
    end
    return c1, c2, c3, Alpha
end
ADDONSELF.GetClassRGB = GetClassRGB

------------------函数：设置名字为职业颜色CFF代码（|cffFFFFFF名字|r）------------------
local function SetClassCFF(name, player)
    local _, class
    if player then
        _, class = UnitClass(player)
    else
        _, class = UnitClass(name)
    end
    local c4 = ""
    if class then
        c4 = select(4, GetClassColor(class))
        c4 = "|c" .. c4 .. name .. "|r"
        return c4
    else
        return name
    end
end
ADDONSELF.SetClassCFF = SetClassCFF

------------------函数：仅提取链接文本------------------
local function GetItemID(text)
    if not text then
        return ""
    end
    local h_item = "|Hitem:(%d-):"
    local item = strmatch(text, h_item)
    if not item then
        item = ""
    end
    return item
end
ADDONSELF.GetItemID = GetItemID

------------------清除输入框的焦点------------------
function BG.ClearFocus()
    local f = GetCurrentKeyBoardFocus()
    if f then
        f:ClearFocus()
    end
end

------------------事件监控------------------
function BG.RegisterEvent(Even, OnEvent)
    local frame = CreateFrame("Frame")
    frame:RegisterEvent(Even)
    frame:SetScript("OnEvent", OnEvent)
end

------------------计算工资------------------
do
    ------------------函数：总收入------------------
    local function Sumjine()
        local FB = BG.FB1
        local sum = 0
        for b = 1, Maxb[FB], 1 do
            for i = 1, Maxi[FB], 1 do
                if BG.Frame[FB]["boss" .. b]["jine" .. i] then
                    sum = sum + (tonumber(BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText()) or 0)
                end
            end
        end
        return sum
    end
    ADDONSELF.Sumjine = Sumjine

    ------------------函数：总支出------------------
    local function SumZC()
        local FB = BG.FB1
        local sum = 0
        for i = 1, Maxi[FB], 1 do
            if BG.Frame[FB]["boss" .. Maxb[FB] + 1]["jine" .. i] then
                sum = sum + (tonumber(BG.Frame[FB]["boss" .. Maxb[FB] + 1]["jine" .. i]:GetText()) or 0)
            end
        end
        return sum
    end
    ADDONSELF.SumZC = SumZC

    ------------------函数：净收入------------------
    local function SumJ()
        local FB = BG.FB1
        local n1 = tonumber(BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine1"]:GetText()) or 0
        local n2 = tonumber(BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine2"]:GetText()) or 0
        local jing = n1 - n2
        return jing
    end
    ADDONSELF.SumJ = SumJ

    ------------------函数：人均工资------------------
    local function SumGZ()
        local FB = BG.FB1
        local n1 = tonumber(BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine3"]:GetText()) or 0
        local n2 = tonumber(BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine4"]:GetText()) or 0
        local gz = math.modf(n1 / n2)
        return gz
    end
    ADDONSELF.SumGZ = SumGZ
end
------------------函数：按职业排序------------------
function BG.PaiXuRaidRosterInfo(guolv)
    local c = {
        "DEATHKNIGHT", --     "死亡骑士",
        "PALADIN",     --     "圣骑士",
        "WARRIOR",     --     "战士",
        "SHAMAN",      --     "萨满祭司",
        "HUNTER",      --     "猎人",
        "DRUID",       --     "德鲁伊",
        "ROGUE",       --     "潜行者",
        "MAGE",        --     "法师",
        "WARLOCK",     --     "术士",
        "PRIEST",      --     "牧师",
    }
    local c_guolv = {}
    if guolv and type(guolv) == "table" then
        for i, v in ipairs(guolv) do
            for index, value in ipairs(c) do
                if v == value then
                    table.insert(c_guolv, value)
                end
            end
        end
    else
        c_guolv = c
    end

    local re = {}
    if BG.raidRosterInfo and type(BG.raidRosterInfo) == "table" then
        for i, v in ipairs(c_guolv) do
            for index, value in ipairs(BG.raidRosterInfo) do
                if value.class == v then
                    table.insert(re, value)
                end
            end
        end
    end
    return re
end

------------------函数：买家下拉列表------------------    -- focus：0就是要清空光标,zhiye："jianshang"就是只显示骑士、德鲁伊、牧师
local function Listmaijia(maijia, focus, guolv)
    -- 背景框
    local frame = BG.MainFrame
    BG.FrameMaijiaList = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    BG.FrameMaijiaList:SetWidth(300)
    BG.FrameMaijiaList:SetHeight(230)
    BG.FrameMaijiaList:SetFrameLevel(120)
    BG.FrameMaijiaList:SetBackdrop({
        bgFile = "Interface/ChatFrame/ChatFrameBackground",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    BG.FrameMaijiaList:SetBackdropColor(0, 0, 0, 0.8)
    BG.FrameMaijiaList:SetPoint("TOPLEFT", maijia, "BOTTOMLEFT", -9, 2)
    BG.FrameMaijiaList:EnableMouse(true)

    -- 下拉列表
    local framedown
    local frameright = BG.FrameMaijiaList
    local raid = BG.PaiXuRaidRosterInfo(guolv)
    for t = 1, 3 do
        for i = 1, 10 do
            local button = CreateFrame("EditBox", nil, BG.FrameMaijiaList, "InputBoxTemplate")
            button:SetSize(90, 20)
            button:SetFrameLevel(125)
            button:SetAutoFocus(false)
            if t >= 2 and i == 1 then
                button:SetPoint("TOPLEFT", frameright, "TOPLEFT", 97, 0)
                frameright = button
            end
            if t == 1 and i == 1 then
                button:SetPoint("TOPLEFT", frameright, "TOPLEFT", 10, -5)
                frameright = button
            end
            if i > 1 then
                button:SetPoint("TOPLEFT", framedown, "BOTTOMLEFT", 0, -2)
            end
            if not guolv and not IsInRaid(1) and t == 1 and i == 1 then -- 单人时
                button:SetText(UnitName("player"))
                button:SetCursorPosition(0)
                button:SetTextColor(GetClassRGB(UnitName("player")))
            end
            local num = (t - 1) * 10 + i
            if raid[num] then
                if raid[num].name then
                    if raid[num].role then
                        button:SetText(AddTexture(raid[num].role) .. raid[num].name)
                    elseif raid[num].combatRole == "HEALER" then
                        button:SetText(AddTexture(raid[num].combatRole) .. raid[num].name)
                    else
                        button:SetText(raid[num].name)
                    end
                    button:SetCursorPosition(0)
                    button:SetTextColor(GetClassRGB(GetText_T(raid[num].name)))
                end
            end
            button:Show()
            framedown = button
            -- 点击名字时触发
            button:SetScript("OnMouseDown", function(self, enter)
                if enter == "RightButton" then -- 右键清空格子
                    if BG.lastfocus then
                        BG.lastfocus:ClearFocus()
                    end
                    return
                end
                maijia:SetText(GetText_T(button))
                maijia:SetCursorPosition(0)
                maijia:SetTextColor(button:GetTextColor())
                BG.FrameMaijiaList:Hide()
                if focus == 0 then
                    if BG.lastfocus then
                        BG.lastfocus:ClearFocus()
                    end
                end
            end)
        end
    end
end
ADDONSELF.Listmaijia = Listmaijia

------------------函数：装备下拉列表------------------
local function List(zhuangbei, FB, BGFrameguanzhu, lootlink, lootlevel, class)
    local frameright
    local framedown
    local MaxI = 11
    for t = 1, 2 do
        for i = 1, MaxI do
            local button = CreateFrame("EditBox", nil, BG.FrameZhuangbeiList, "InputBoxTemplate")
            button:SetSize(230, 20)
            button:SetFrameLevel(125)
            local icon = button:CreateTexture(nil, 'ARTWORK')
            icon:SetPoint('LEFT', -4, 0)
            icon:SetSize(16, 16)
            if t == 1 and i == 1 then
                button:SetPoint("TOPLEFT", BG.FrameZhuangbeiList, "TOPLEFT", 10, -5)
                frameright = button
            elseif t >= 2 and i == 1 then
                button:SetPoint("TOPLEFT", frameright, "TOPRIGHT", 5, 0)
                frameright = button
            elseif i > 1 then
                button:SetPoint("TOPLEFT", framedown, "BOTTOMLEFT", 0, -2)
            end
            if lootlink[(t - 1) * MaxI + i] then
                local link = lootlink[(t - 1) * MaxI + i]
                local level = lootlevel[(t - 1) * MaxI + i]
                button:SetText(link .. "|cff" .. "9370DB" .. "(" .. level .. ")")
                button:SetTextInsets(14, 0, 0, 0)
                local itemID = select(1, GetItemInfoInstant(lootlink[(t - 1) * MaxI + i]))
                local itemIcon = GetItemIcon(itemID)
                if itemIcon then
                    icon:SetTexture(itemIcon)
                else
                    icon:SetTexture(nil)
                end

                local num = BiaoGe.filterClassNum[RealmId][player] -- 隐藏
                if num ~= 0 then
                    BG.FilterClass(nil, nil, nil, button, class, num, BiaoGeFilterTooltip, "zhuangbei")
                end
            end
            BG.ZhuangbeiList["button" .. (t - 1) * MaxI + i] = button
            framedown = button
            -- 鼠标悬停在装备时
            button:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -100, 0)
                GameTooltip:ClearLines()
                local Link = button:GetText()
                local itemID = select(1, GetItemInfoInstant(Link))
                if itemID then
                    GameTooltip:SetItemByID(itemID)
                    GameTooltip:Show()
                    local h = { FB, itemID }
                    BG.HistoryJine(unpack(h))
                    BG.HistoryMOD = h
                end
            end)
            button:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
                if BG["HistoryJineFrameDB1"] then
                    for i = 1, BG.HistoryJineFrameDBMax do
                        BG["HistoryJineFrameDB" .. i]:Hide()
                    end
                    BG.HistoryJineFrame:Hide()
                end
            end)
            -- 点击时触发
            button:SetScript("OnMouseDown", function(self, enter)
                if enter == "RightButton" then -- 右键清空格子
                    if BG.lastfocus then
                        BG.lastfocus:ClearFocus()
                    end
                    return
                end
                if lootlink[(t - 1) * MaxI + i] then
                    if IsShiftKeyDown() then
                        ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
                        local text = lootlink[(t - 1) * 10 + i]
                        ChatEdit_InsertLink(text)
                        zhuangbei:ClearFocus()
                        return
                    end
                    if IsControlKeyDown() then
                        BG.TongBaoHis(button, BG.HistoryJineDB)
                        zhuangbei:ClearFocus()
                        return
                    end
                    zhuangbei:SetText(lootlink[(t - 1) * MaxI + i])
                    if IsAltKeyDown() then
                        BiaoGeguanzhu = true
                        BGFrameguanzhu:Show()
                    end
                end
                BG.FrameZhuangbeiList:Hide()
                zhuangbei:ClearFocus()
            end)
        end
    end
end
local function Listzhuangbei(zhuangbei, bossnum, FB, BiaoGeguanzhu, BGFrameguanzhu, hopenandu)
    local p = GetRaidDifficultyID()
    local nandu
    local lootlink = {}
    local lootlevel = {}
    if p == 3 or p == 175 then
        nandu = "P10"
    elseif p == 4 or p == 176 then
        nandu = "P25"
    elseif p == 5 or p == 193 then
        nandu = "H10"
    elseif p == 6 or p == 194 then
        nandu = "H25"
    end
    if hopenandu then
        if hopenandu == 1 then
            nandu = "P10"
        elseif hopenandu == 2 then
            nandu = "P25"
        elseif hopenandu == 3 then
            nandu = "H10"
        elseif hopenandu == 4 then
            nandu = "H25"
        end
    end
    if BG.Loot[FB][nandu] then
        if BG.Loot[FB][nandu]["boss" .. bossnum] then
            local sum = #BG.Loot[FB][nandu]["boss" .. bossnum]
            for index, value in ipairs(BG.Loot[FB][nandu]["boss" .. bossnum]) do
                local name, link, quality, level, _, _, _, _, _, Texture, _, typeID = GetItemInfo(value)
                table.insert(lootlink, link)
                table.insert(lootlevel, level)
            end
            -- 背景框
            BG.FrameZhuangbeiList = CreateFrame("Frame", nil, BG.MainFrame, "BackdropTemplate")
            BG.FrameZhuangbeiList:SetWidth(480)
            BG.FrameZhuangbeiList:SetHeight(250)
            BG.FrameZhuangbeiList:SetFrameLevel(120)
            BG.FrameZhuangbeiList:SetBackdrop({
                bgFile = "Interface/ChatFrame/ChatFrameBackground",
                edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                edgeSize = 16,
                insets = { left = 3, right = 3, top = 3, bottom = 3 }
            })
            BG.FrameZhuangbeiList:SetBackdropColor(0, 0, 0, 0.9)
            BG.FrameZhuangbeiList:SetPoint("TOPLEFT", zhuangbei, "BOTTOMLEFT", -9, 2)
            BG.FrameZhuangbeiList:EnableMouse(true)
            -- 提示文字
            local text = BG.FrameZhuangbeiList:CreateFontString()
            text:SetPoint("TOPLEFT", BG.FrameZhuangbeiList, "BOTTOMLEFT", 3, 0)
            text:SetFont(BIAOGE_TEXT_FONT, 14, "OUTLINE") -- 游戏主界面文字
            if hopenandu then
                text:SetText(BG.STC_b1(L["（ALT+点击可设置为已掉落，SHIFT+点击可发送装备，CTRL+点击可通报历史价格）"]))
            else
                text:SetText(BG.STC_b1(L["（ALT+点击可关注装备，SHIFT+点击可发送装备，CTRL+点击可通报历史价格）"]))
            end
            -- 下拉列表
            local _, class = UnitClass("player")
            BG.ZhuangbeiList = {}
            if #lootlink == sum then
                List(zhuangbei, FB, BGFrameguanzhu, lootlink, lootlevel, class)
            else
                C_Timer.After(0.01, function()
                    lootlink = {}
                    lootlevel = {}
                    for index, value in ipairs(BG.Loot[FB][nandu]["boss" .. bossnum]) do
                        local name, link, quality, level, _, _, _, _, _, _, _, typeID = GetItemInfo(value)
                        table.insert(lootlink, link)
                        table.insert(lootlevel, level)
                    end
                    List(zhuangbei, FB, BGFrameguanzhu, lootlink, lootlevel, class)
                end)
            end
        end
    end
end
ADDONSELF.Listzhuangbei = Listzhuangbei

------------------函数：金额下拉列表------------------
local function Listjine(jine, FB, b, i)
    -- 背景框
    BG.FrameJineList = CreateFrame("Frame", nil, BG.MainFrame, "BackdropTemplate")
    BG.FrameJineList:SetWidth(95)
    BG.FrameJineList:SetHeight(230)
    BG.FrameJineList:SetFrameLevel(120)
    BG.FrameJineList:SetBackdrop({
        bgFile = "Interface/ChatFrame/ChatFrameBackground",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    BG.FrameJineList:SetBackdropColor(0, 0, 0, 0.8)
    BG.FrameJineList:SetPoint("TOPLEFT", jine, "BOTTOMLEFT", -9, 2)
    BG.FrameJineList:EnableMouse(true)

    local text = BG.FrameJineList:CreateFontString()
    text:SetPoint("TOP", BG.FrameJineList, "TOP", 0, -10)
    text:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
    text:SetText(L["欠款金额"])
    text:SetTextColor(1, 0, 0)

    local edit = CreateFrame("EditBox", nil, BG.FrameJineList, "InputBoxTemplate")
    edit:SetSize(80, 20)
    edit:SetTextColor(1, 0, 0)
    edit:SetPoint("TOP", text, "BOTTOM", 2, -5)
    if BiaoGe[FB]["boss" .. b]["qiankuan" .. i] then
        edit:SetText(BiaoGe[FB]["boss" .. b]["qiankuan" .. i])
    end
    edit:SetNumeric(true)
    edit:SetAutoFocus(false)
    BG.FrameQianKuanEdit = edit
    edit:SetScript("OnTextChanged", function(self)
        local name = "autoAdd0"
        if BiaoGe.options[name] == 1 then
            local len = strlen(self:GetText())
            local lingling
            if len then
                lingling = strsub(self:GetText(), len - 1, len)
            end
            if lingling ~= "00" and lingling ~= "0" and tonumber(self:GetText()) and self:HasFocus() then
                self:Insert("00")
                self:SetCursorPosition(1)
            end
        end
        if self:GetText() ~= "" then
            BiaoGe[FB]["boss" .. b]["qiankuan" .. i] = self:GetText()
            BG.Frame[FB]["boss" .. b]["qiankuan" .. i]:Show()
        else
            BiaoGe[FB]["boss" .. b]["qiankuan" .. i] = nil
            BG.Frame[FB]["boss" .. b]["qiankuan" .. i]:Hide()
        end
    end)
    edit:SetScript("OnEscapePressed", function(self)
        BG.FrameJineList:Hide()
    end)
    -- 点击时
    edit:SetScript("OnMouseDown", function(self, enter)
        if enter == "RightButton" then -- 右键清空格子
            self:SetEnabled(false)
            self:SetText("")
        end
    end)
    edit:SetScript("OnMouseUp", function(self, enter)
        if enter == "RightButton" then -- 右键清空格子
            self:SetEnabled(true)
        end
    end)
end
ADDONSELF.Listjine = Listjine

------------------函数：窗口切换动画------------------
local function FrameDongHua(frame, h2, w2)
    local h1 = frame:GetHeight()
    local w1 = frame:GetWidth()
    local Time = 0.5
    local T = 50
    local t1 = Time / T
    local t2 = Time / T
    if w1 > w2 then
        for i = T, 1, -1 do
            C_Timer.After(t1, function()
                frame:SetWidth(w2 + (w1 - w2) * ((i - 1) / T)) -- 窗口变小
            end)
            t1 = t1 + Time / T
        end
    elseif w2 > w1 then
        for i = 1, T, 1 do
            C_Timer.After(t1, function()
                frame:SetWidth(w1 + (w2 - w1) * (i / T)) -- 窗口变大
            end)
            t1 = t1 + Time / T
        end
    end
    if h1 > h2 then
        for i = T, 1, -1 do
            C_Timer.After(t2, function()
                frame:SetHeight(h2 + (h1 - h2) * ((i - 1) / T)) -- 窗口变小
            end)
            t2 = t2 + Time / T
        end
    elseif h2 > h1 then
        for i = 1, T, 1 do
            C_Timer.After(t2, function()
                frame:SetHeight(h1 + (h2 - h1) * (i / T)) -- 窗口变大
            end)
            t2 = t2 + Time / T
        end
    end
end
ADDONSELF.FrameDongHua = FrameDongHua

------------------函数：隐藏窗口------------------   -- 0：隐藏焦点+全部框架，1：隐藏全部框架，2：隐藏除历史表格外的框架
local function FrameHide(num)
    if num == 0 then
        if BG.lastfocus then
            BG.lastfocus:ClearFocus()
        end
    end
    if BG.FrameZhuangbeiList then
        BG.FrameZhuangbeiList:Hide()
    end
    if BG.FrameMaijiaList then
        BG.FrameMaijiaList:Hide()
    end
    if BG.FrameJineList then
        BG.FrameJineList:Hide()
    end
    if BG.FrameSheZhi then
        BG.FrameSheZhi:Hide()
    end
    if BG.frameZhuFuList then
        BG.frameZhuFuList:Hide()
    end
    if num ~= 2 then -- num是0就取消焦点，其他数字就不取消焦点
        if BG.History then
            if BG.History.List then
                BG.History.List:Hide()
            end
        end
    end
end
ADDONSELF.FrameHide = FrameHide

------------------函数：清空表格------------------
function BG.Frame:QingKong(BiaoGeFB, FB, MaxbFB, MaxiFB, BiaoGeAFB)
    if BG["Frame" .. FB] and BG["Frame" .. FB]:IsVisible() or not BiaoGeAFB then
        for b = 1, MaxbFB do
            for i = 1, MaxiFB + 10 do
                if self[FB]["boss" .. b]["zhuangbei" .. i] then
                    self[FB]["boss" .. b]["zhuangbei" .. i]:SetText("")
                    self[FB]["boss" .. b]["maijia" .. i]:SetText("")
                    self[FB]["boss" .. b]["jine" .. i]:SetText("")
                    self[FB]["boss" .. b]["qiankuan" .. i]:Hide()
                    self[FB]["boss" .. b]["guanzhu" .. i]:Hide()
                end
                if BiaoGeFB["boss" .. b]["zhuangbei" .. i] then
                    BiaoGeFB["boss" .. b]["zhuangbei" .. i] = nil
                    BiaoGeFB["boss" .. b]["maijia" .. i] = nil
                    BiaoGeFB["boss" .. b]["jine" .. i] = nil
                    BiaoGeFB["boss" .. b]["qiankuan" .. i] = nil
                    BiaoGeFB["boss" .. b]["guanzhu" .. i] = nil
                end
            end
            if self[FB]["boss" .. b]["time"] then
                self[FB]["boss" .. b]["time"]:SetText("")
                BiaoGeFB["boss" .. b]["time"] = nil
            end
        end
        local name = "retainExpenses"
        for i = 1, MaxiFB + 10 do -- 清空支出
            if self[FB]["boss" .. MaxbFB + 1]["zhuangbei" .. i] then
                if BiaoGe.options[name] ~= 1 then
                    self[FB]["boss" .. MaxbFB + 1]["zhuangbei" .. i]:SetText("")
                end
                self[FB]["boss" .. MaxbFB + 1]["maijia" .. i]:SetText("")
                self[FB]["boss" .. MaxbFB + 1]["jine" .. i]:SetText("")
            end
            if BiaoGeFB["boss" .. MaxbFB + 1]["zhuangbei" .. i] then
                if BiaoGe.options[name] ~= 1 then
                    BiaoGeFB["boss" .. MaxbFB + 1]["zhuangbei" .. i] = nil
                    BiaoGeFB["boss" .. MaxbFB + 1]["maijia" .. i] = nil
                    BiaoGeFB["boss" .. MaxbFB + 1]["jine" .. i] = nil
                end
            end
        end

        if BiaoGeFB["ChengPian"] then
            BiaoGeFB["ChengPian"] = nil
        end
        if BiaoGeFB["BaoZhu"] then
            BiaoGeFB["BaoZhu"] = nil
        end

        local num = 25
        local nanduID = GetRaidDifficultyID()
        if nanduID == 3 or nanduID == 175 then
            num = BiaoGe.options["10MaxPlayers"] or 10
        elseif nanduID == 4 or nanduID == 176 then
            num = BiaoGe.options["25MaxPlayers"] or 25
        elseif nanduID == 5 or nanduID == 193 then
            num = BiaoGe.options["10MaxPlayers"] or 10
        elseif nanduID == 6 or nanduID == 194 then
            num = BiaoGe.options["25MaxPlayers"] or 25
        end
        local name = "autoQingKong"
        if BiaoGe.options[name] == 1 then
            self[FB]["boss" .. MaxbFB + 2]["jine4"]:SetText(num)
            BiaoGeFB["boss" .. MaxbFB + 2]["jine4"] = num
        end
        return num
    else
        for n = 1, 4 do
            for b = 1, MaxbFB - 1 do
                for i = 1, 2 do
                    if BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] then
                        BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:SetText("")
                        BiaoGeAFB["nandu" .. n]["boss" .. b]["zhuangbei" .. i] = nil
                        BiaoGeAFB["nandu" .. n]["boss" .. b]["yidiaoluo" .. i] = nil
                    end
                end
            end
        end
    end
end

------------------把副本英文转换为中文------------------
function BG.FBcn(FB)
    local r = ""
    local fb = { NAXX = GetRealZoneText(533), ULD = GetRealZoneText(603), TOC = GetRealZoneText(649), ICC = GetRealZoneText(631) }
    for index, value in pairs(fb) do
        if FB == index then
            r = value
            return r
        end
    end
end

------------------显示MainFrame底色------------------
function BG.SetMainFrameDS(frame, num)
    local FB = BG.FB1
    local r, g, b, a
    local f = BG.MainFrameDs
    if frame == "duizhang" then
        r, g, b, a = 0, 0, 0.3, 0.1
    elseif frame == "hope" then
        r, g, b, a = 0.2, 0, 0, 0.1
    elseif frame == "yy" then
        r, g, b, a = RGB("000000", 0.3)
    end
    if num == 0 then
        f:Hide()
    elseif num == 1 then
        f:Show()
        f:SetBackdropColor(r, g, b, a)
        f:SetSize(Width[FB] - 5, Height[FB] - 5)
    end
end

------------------当前表格是否空白------------------  -- true 是空白，false 不是空白
function BG.CheckKongBai(FB, MaxbFB, MaxiFB)
    for b = 1, MaxbFB do
        for i = 1, MaxiFB do
            if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i] then
                if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:GetText() ~= "" then
                    return false
                end
                if BG.Frame[FB]["boss" .. b]["maijia" .. i]:GetText() ~= "" then
                    return false
                end
                if BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText() ~= "" then
                    return false
                end
            end
        end
    end
    for i = 1, MaxiFB do
        if BG.Frame[FB]["boss" .. MaxbFB + 1]["zhuangbei" .. i] then
            if BG.Frame[FB]["boss" .. MaxbFB + 1]["maijia" .. i]:GetText() ~= "" then
                return false
            end
            if BG.Frame[FB]["boss" .. MaxbFB + 1]["jine" .. i]:GetText() ~= "" then
                return false
            end
        end
    end
    return true
end

------------------通报历史价格------------------
function BG.TongBaoHis(button, DB)
    button:ClearFocus()
    button:SetEnabled(false)
    if not IsInRaid(1) then
        SendSystemMessage(L["不在团队，无法通报"])
        PlaySound(BG.sound1, "Master")
        return
    end
    if DB.DB then
        local db = DB.DB
        local link = DB.Link
        if GetItemID(link) ~= GetItemID(button:GetText()) then return end
        local name, _, quality, level, _, _, _, _, _, _, _, typeID = GetItemInfo(link)
        local text = L["———通报历史价格———"]
        SendChatMessage(text, "RAID")
        text = format(L["装备：%s(%s)"], link, level)
        SendChatMessage(text, "RAID")
        for i = 1, #db do
            local a = strsub(db[i][1], 3, 4)
            local b = strsub(db[i][1], 5, 6)
            local t
            if db[i][1] == 0 then
                t = L["当前"]
            else
                t = a .. L["月"] .. b .. L["日"]
            end
            local m = db[i][3]
            local j = db[i][5]
            if m == "" then
                text = t .. L["，价格:"] .. j
            else
                text = t .. L["，价格:"] .. j .. L["，买家:"] .. m
            end
            SendChatMessage(text, "RAID")
        end
        -- text = L["——感谢使用金团表格——"]
        -- SendChatMessage(text,"RAID")
        PlaySoundFile(BG.sound2, "Master")
    end
end

------------------过滤装备------------------
function BG.SetFilterAlpha(FB, b, i, n, bt, Frame, alpha)
    if Frame == "Frame" then
        BG[Frame][FB]["boss" .. b]["zhuangbei" .. i]:SetAlpha(alpha)
    elseif Frame == "HopeFrame" then
        BG[Frame][FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:SetAlpha(alpha)
    elseif Frame == "HistoryFrame" then
        BG[Frame][FB]["boss" .. b]["zhuangbei" .. i]:SetAlpha(alpha)
    elseif Frame == "zhuangbei" then
        bt:SetAlpha(alpha)
    end
end

function BG.FilterClass(FB, b, i, bt, class, num, BiaoGeFilterTooltip, Frame, n)
    if not num then return end
    local text = bt:GetText()
    local itemID = GetItemInfoInstant(text)
    local yes
    local alpha1 = 0.4
    local alpha2 = 1

    if itemID then
        local name, link, quality, level, _, _, _, _, _, Texture, _, typeID, subclassID = GetItemInfo(itemID)

        BiaoGeFilterTooltip:SetOwner(UIParent, "ANCHOR_NONE")
        BiaoGeFilterTooltip:ClearLines()
        BiaoGeFilterTooltip:SetItemByID(itemID)
        local tab = {}
        for ii = 1, 30 do
            if _G["BiaoGeFilterTooltipTextLeft" .. ii] then
                local tx = _G["BiaoGeFilterTooltipTextLeft" .. ii]:GetText()
                if tx and tx ~= "" and (not tx:find(BG.DisXd)) then -- BG.DisXd小德的武器词缀：在猎豹、熊等等攻击强度提高%s点
                    table.insert(tab, tx)
                end
            end
            if _G["BiaoGeFilterTooltipTextRight" .. ii] then
                local tx = _G["BiaoGeFilterTooltipTextRight" .. ii]:GetText()
                if tx and tx ~= "" then
                    table.insert(tab, tx)
                end
            end
        end
        local TooltipText = table.concat(tab)


        local c = UnitClass("player")
        local zhiye = strfind(TooltipText, CLASS)
        if zhiye then
            if not strfind(TooltipText, c) then
                BG.SetFilterAlpha(FB, b, i, n, bt, Frame, alpha1)
                return
            end
        end

        if typeID == 4 then
            if BG.DisClassArmor[class .. num] then
                for key, value in pairs(BG.DisClassArmor[class .. num]) do
                    if subclassID == value then
                        BG.SetFilterAlpha(FB, b, i, n, bt, Frame, alpha1)
                        return
                    end
                end
            end
        elseif typeID == 2 then
            if BG.DisClassWeapon[class .. num] then
                for key, value in pairs(BG.DisClassWeapon[class .. num]) do
                    if subclassID == value then
                        BG.SetFilterAlpha(FB, b, i, n, bt, Frame, alpha1)
                        return
                    end
                end
            end
        end

        local LorR_Text = BG["DisClassTextLeft"][class .. num] -- BG.DisClassLeftText.DEATHKNIGHT1
        if LorR_Text then
            for key, value in pairs(LorR_Text) do              -- 历遍该职业的过滤关键词
                yes = strfind(TooltipText, value)
                if yes then
                    BG.SetFilterAlpha(FB, b, i, n, bt, Frame, alpha1)
                    return
                end
            end
        end
    end
    if not yes then
        BG.SetFilterAlpha(FB, b, i, n, bt, Frame, alpha2)
    end
end

function BG.FBfilter()
    local num = BiaoGe.filterClassNum[RealmId][player] -- 隐藏
    local FB = BG.FB1
    local _, class = UnitClass("player")
    if num ~= 0 then
        for b = 1, Maxb[FB] do
            for i = 1, Maxi[FB] do
                local bt = BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]
                if bt then
                    BG.FilterClass(FB, b, i, bt, class, num, BiaoGeFilterTooltip, "Frame")
                end
            end
        end
        for n = 1, HopeMaxn[FB] do -- 心愿清单
            for b = 1, HopeMaxb[FB] do
                for i = 1, 2 do
                    local bt = BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]
                    if bt then
                        BG.FilterClass(FB, b, i, bt, class, num, BiaoGeFilterTooltip, "HopeFrame", n)
                    end
                end
            end
        end
    else
        for b = 1, Maxb[FB] do
            for i = 1, Maxi[FB] do
                local bt = BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]
                if bt then
                    BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:SetAlpha(1)
                end
            end
        end
        for n = 1, HopeMaxn[FB] do
            for b = 1, HopeMaxb[FB] do
                for i = 1, 2 do
                    local bt = BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]
                    if bt then
                        BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:SetAlpha(1)
                    end
                end
            end
        end
    end
end

------------------获取玩家所在的团队框体位置（例如5-2）------------------
function BG.GetRaidWeiZhi()
    local team = {}
    local num = GetNumGroupMembers()
    if not num then return end
    for i = 1, num do
        local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i)
        name = strsplit("-", name)
        if not team[subgroup] then
            team[subgroup] = {}
        end
        table.insert(team[subgroup], name)
    end

    local weizhi = {}
    for i, v in pairs(team) do
        if type(team[i]) == "table" then
            for ii, vv in ipairs(team[i]) do
                weizhi[vv] = i .. "-" .. ii
            end
        end
    end
    return weizhi
end

------------------单元格内容交换------------------
function BG.JiaoHuan(button, FB, b, i, t)
    if not BG.copy1 then
        BG.copy1 = {
            fb = FB,
            b = BossNum(FB, b, t),
            i = i,
            btzhuangbei = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i],
            btmaijia = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i],
            btjine = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i],
            btqiankuan = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["qiankuan" .. i],
            btguanzhu = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["guanzhu" .. i],

            zhuangbei = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i]:GetText(),
            maijia = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i]:GetText(),
            color = { BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i]:GetTextColor() },
            jine = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i]:GetText(),
            qiankuan = BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["qiankuan" .. i],
            guanzhu = BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["guanzhu" .. i],
        }
        PlaySound(BG.sound1, "Master")

        local bt = CreateFrame("Button", nil, BG["Frame" .. FB], "UIPanelButtonTemplate")
        bt:SetSize(80, 20)
        bt:SetPoint("RIGHT", BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i], "LEFT", -5, 0)
        bt:SetFrameLevel(BG.MainFrame:GetFrameLevel() + 15)
        bt:SetText(L["取消交换"])
        BG.copyButton = bt
        bt:SetScript("OnClick", function()
            if BG.copy1 then
                BG.copy1 = nil
            end
            BG.copyButton:Hide()
            PlaySound(BG.sound1, "Master")
        end)
        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:SetText(BG.STC_b1(L["你正在交换该行全部内容"]) .. L["\n点击取消交换"])
        end)
        BG.GameTooltip_Hide(bt)

        local f = BG.Create_BlinkHilight(bt)
        f:SetPoint("TOPLEFT", bt, "TOPLEFT", -10, 5)
        f:SetPoint("BOTTOMRIGHT", bt, "BOTTOMRIGHT", 10, -5)

        local f = BG.Create_BlinkHilight(bt, BG.MainFrame:GetFrameLevel() + 1)
        f:SetPoint("TOPLEFT", BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i], "TOPLEFT", -80, 5)
        f:SetPoint("BOTTOMRIGHT", BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i], "BOTTOMRIGHT", 90, -5)
    else
        BG.copy2 = {
            fb = FB,
            b = BossNum(FB, b, t),
            i = i,
            btzhuangbei = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i],
            btmaijia = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i],
            btjine = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i],
            btqiankuan = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["qiankuan" .. i],
            btguanzhu = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["guanzhu" .. i],

            zhuangbei = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i]:GetText(),
            maijia = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i]:GetText(),
            color = { BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i]:GetTextColor() },
            jine = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i]:GetText(),
            qiankuan = BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["qiankuan" .. i],
            guanzhu = BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["guanzhu" .. i],
        }

        if BG.copy1.fb == BG.copy2.fb then -- 是同一个副本
            BG.copy1.btzhuangbei:SetText(BG.copy2.zhuangbei)
            BG.copy1.btmaijia:SetText(BG.copy2.maijia)
            BG.copy1.btmaijia:SetTextColor(BG.copy2.color[1], BG.copy2.color[2], BG.copy2.color[3])
            BG.copy1.btjine:SetText(BG.copy2.jine)

            BG.copy2.btzhuangbei:SetText(BG.copy1.zhuangbei)
            BG.copy2.btmaijia:SetText(BG.copy1.maijia)
            BG.copy2.btmaijia:SetTextColor(BG.copy1.color[1], BG.copy1.color[2], BG.copy1.color[3])
            BG.copy2.btjine:SetText(BG.copy1.jine)


            local FB = BG.copy1.fb
            local b1, i1 = BG.copy1.b, BG.copy1.i
            local b2, i2 = BG.copy2.b, BG.copy2.i

            BiaoGe[FB]["boss" .. b1]["guanzhu" .. i1], BiaoGe[FB]["boss" .. b2]["guanzhu" .. i2] = BiaoGe[FB]["boss" .. b2]["guanzhu" .. i2], BiaoGe[FB]["boss" .. b1]["guanzhu" .. i1]
            if BiaoGe[FB]["boss" .. b1]["guanzhu" .. i1] then
                BG.Frame[FB]["boss" .. b1]["guanzhu" .. i1]:Show()
            else
                BG.Frame[FB]["boss" .. b1]["guanzhu" .. i1]:Hide()
            end
            if BiaoGe[FB]["boss" .. b2]["guanzhu" .. i2] then
                BG.Frame[FB]["boss" .. b2]["guanzhu" .. i2]:Show()
            else
                BG.Frame[FB]["boss" .. b2]["guanzhu" .. i2]:Hide()
            end

            BiaoGe[FB]["boss" .. b1]["qiankuan" .. i1], BiaoGe[FB]["boss" .. b2]["qiankuan" .. i2] = BiaoGe[FB]["boss" .. b2]["qiankuan" .. i2], BiaoGe[FB]["boss" .. b1]["qiankuan" .. i1]
            if BiaoGe[FB]["boss" .. b1]["qiankuan" .. i1] ~= "" and BiaoGe[FB]["boss" .. b1]["qiankuan" .. i1] ~= "0" then
                BG.Frame[FB]["boss" .. b1]["qiankuan" .. i1]:Show()
            else
                BG.Frame[FB]["boss" .. b1]["qiankuan" .. i1]:Hide()
            end
            if BiaoGe[FB]["boss" .. b2]["qiankuan" .. i2] ~= "" and BiaoGe[FB]["boss" .. b2]["qiankuan" .. i2] ~= "0" then
                BG.Frame[FB]["boss" .. b2]["qiankuan" .. i2]:Show()
            else
                BG.Frame[FB]["boss" .. b2]["qiankuan" .. i2]:Hide()
            end

            local text = BG.copy2.btzhuangbei:CreateFontString()
            text:SetPoint("RIGHT", BG.copy2.btzhuangbei, "LEFT", -5, 0)
            text:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
            text:SetText(BG.STC_b1(L["交换成功"]))
            C_Timer.After(1, function()
                BG.DongHuaAlpha(text)
            end)

            BG.copy1 = nil
            BG.copy2 = nil
            BG.copyButton:Hide()
        else -- 不是同一个副本
            BG.copy1 = nil
            BG.copy2 = nil
            BG.copyButton:Hide()

            BG.copy1 = {
                fb = FB,
                b = BossNum(FB, b, t),
                i = i,
                btzhuangbei = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i],
                btmaijia = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i],
                btjine = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i],
                btqiankuan = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["qiankuan" .. i],
                btguanzhu = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["guanzhu" .. i],

                zhuangbei = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i]:GetText(),
                maijia = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i]:GetText(),
                color = { BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i]:GetTextColor() },
                jine = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i]:GetText(),
                qiankuan = BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["qiankuan" .. i],
                guanzhu = BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["guanzhu" .. i],
            }
            PlaySound(BG.sound1, "Master")

            local bt = CreateFrame("Button", nil, BG["Frame" .. FB], "UIPanelButtonTemplate")
            bt:SetSize(80, 20)
            bt:SetPoint("RIGHT", BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i], "LEFT", -5, 0)
            bt:SetFrameLevel(BG.MainFrame:GetFrameLevel() + 15)
            bt:SetText(L["取消交换"])
            BG.copyButton = bt
            bt:SetScript("OnClick", function()
                if BG.copy1 then
                    BG.copy1 = nil
                end
                BG.copyButton:Hide()
                PlaySound(BG.sound1, "Master")
            end)
            bt:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
                GameTooltip:ClearLines()
                GameTooltip:SetText(BG.STC_b1(L["你正在交换该行全部内容"]) .. L["\n点击取消交换"])
            end)
            BG.GameTooltip_Hide(bt)

            local f = BG.Create_BlinkHilight(bt)
            f:SetPoint("TOPLEFT", bt, "TOPLEFT", -10, 5)
            f:SetPoint("BOTTOMRIGHT", bt, "BOTTOMRIGHT", 10, -5)

            local f = BG.Create_BlinkHilight(bt, BG.MainFrame:GetFrameLevel() + 1)
            f:SetPoint("TOPLEFT", BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i], "TOPLEFT", -80, 5)
            f:SetPoint("BOTTOMRIGHT", BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i], "BOTTOMRIGHT", 90, -5)
        end

        PlaySound(BG.sound1, "Master")
    end
end

------------------隐藏提示工具------------------
local function GameTooltip_Hide()
    GameTooltip:Hide()
end
function BG.GameTooltip_Hide(frame)
    frame:SetScript("OnLeave", GameTooltip_Hide)
end

------------------模板：创建蓝底高光材质------------------
function BG.Create_BlinkHilight(Parent, level)
    local f = CreateFrame("Frame", nil, Parent)
    f:SetFrameLevel(level or Parent:GetFrameLevel() - 1)
    local texture = f:CreateTexture(nil, "BACKGROUND") -- 高亮材质
    texture:SetAllPoints()
    texture:SetTexture("Interface/ChatFrame/UI-ChatIcon-BlinkHilight")
    return f
end

------------------动画：慢慢透明然后隐藏------------------
function BG.DongHuaAlpha(bt, time)
    if not time then
        time = 2
    end
    local T = 50 * time
    local t = time / T
    for i = T, 1, -1 do
        C_Timer.After(t, function()
            bt:SetAlpha(1 * ((i - 1) / T))
        end)
        t = t + time / T
    end
    C_Timer.After(time, function()
        bt:Hide()
    end)
end

------------------查找或匹配table里的字符------------------
do
    function BG.FindTableString(text, table)
        local num
        for key, value in pairs(table) do
            num = strfind(text, value)
            if num then
                return num
            end
        end
    end

    function BG.MatchTableString(text, table)
        local str
        for key, value in pairs(table) do
            str = strmatch(text, value)
            if str then
                return str
            end
        end
    end
end
------------------返回字符串里每个字符的位置------------------
function BG.getCharacterPositions(str)
    local positions = {}
    local position = 1

    while position <= #str do
        local byte = string.byte(str, position)

        if byte >= 0xC0 and byte <= 0xDF then
            -- 处理两个字节的UTF-8字符
            positions[string.sub(str, position, position + 1)] = position
            position = position + 2
        elseif byte >= 0xE0 and byte <= 0xEF then
            -- 处理三个字节的UTF-8字符
            positions[string.sub(str, position, position + 2)] = position
            position = position + 3
        elseif byte >= 0xF0 and byte <= 0xF7 then
            -- 处理四个字节的UTF-8字符
            positions[string.sub(str, position, position + 3)] = position
            position = position + 4
        else
            -- 处理单字节字符和非法字节
            positions[string.sub(str, position, position)] = position
            position = position + 1
        end
    end

    return positions
end

------------------表格/背包高亮对应装备------------------
do
    local function SetHlightBag(bag)
        local f = CreateFrame("Frame", nil, bag, "BackdropTemplate")
        f:SetBackdrop({
            edgeFile = "Interface/ChatFrame/ChatFrameBackground",
            edgeSize = 3,
        })
        f:SetBackdropBorderColor(1, 0, 0, 1)
        f:SetPoint("TOPLEFT", bag, 0, 0)
        f:SetPoint("BOTTOMRIGHT", bag, 0, 0)
        tinsert(BG.LastBagItemFrame, f)
    end

    function BG.HilightBag(biaogelink)
        if GetItemID(biaogelink) == "" then return end
        if BG.BagAddon == "NDUI" then
            local i = 1
            while _G["NDui_BackpackSlot" .. i] do
                local bag = _G["NDui_BackpackSlot" .. i]
                local link = C_Container.GetContainerItemLink(bag.bagId, bag.slotId)
                if GetItemID(link) == GetItemID(biaogelink) then
                    SetHlightBag(bag)
                end
                i = i + 1
            end
        elseif BG.BagAddon == "EUI" then
            local b = -1
            local i = 1
            while _G["ElvUI_ContainerFrameBag" .. b .. "Slot" .. i] do
                while _G["ElvUI_ContainerFrameBag" .. b .. "Slot" .. i] do
                    local bag = _G["ElvUI_ContainerFrameBag" .. b .. "Slot" .. i]
                    local link = C_Container.GetContainerItemLink(bag.BagID, bag.SlotID)
                    if GetItemID(link) == GetItemID(biaogelink) then
                        SetHlightBag(bag)
                    end
                    i = i + 1
                end
                b = b + 1
                i = 1
            end
        elseif BG.BagAddon == "BIGFOOT" then
            local i = 1
            while _G["CombuctorItem" .. i] do
                local bag = _G["CombuctorItem" .. i]
                local link = C_Container.GetContainerItemLink(bag:GetParent():GetID(), bag:GetID())
                if GetItemID(link) == GetItemID(biaogelink) then
                    SetHlightBag(bag)
                end
                i = i + 1
            end
        else
            local b = 1
            local i = 1
            while _G["ContainerFrame" .. b .. "Item" .. i] do
                while _G["ContainerFrame" .. b .. "Item" .. i] do
                    local bag = _G["ContainerFrame" .. b .. "Item" .. i]
                    local link = C_Container.GetContainerItemLink(bag:GetParent():GetID(), bag:GetID())
                    if GetItemID(link) == GetItemID(biaogelink) then
                        SetHlightBag(bag)
                    end
                    i = i + 1
                end
                b = b + 1
                i = 1
            end
        end
    end

    function BG.HideHilightBag()
        for key, value in pairs(BG.LastBagItemFrame) do
            value:Hide()
        end
        BG.LastBagItemFrame = {}
    end
end

------------------创建按钮模板1------------------
function BG.Create_Button1(parent)
    local bt = CreateFrame("Button", nil, parent)
    bt:SetNormalFontObject(BG.FontBlue1)
    bt:SetDisabledFontObject(BG.FontBlue1)
    bt:SetHighlightFontObject(BG.FontBlue1)

    local texture2 = bt:CreateTexture(nil, "OVERLAY")
    texture2:SetBlendMode("ALPHAKEY")
    texture2:SetAllPoints()
    texture2:SetColorTexture(RGB("FFA500", 0.2))
    local texture3 = bt:CreateTexture(nil, "BACKGROUND")
    texture3:SetAllPoints()
    texture3:SetColorTexture(RGB("DCDCDC", 0.2))
    bt:SetDisabledTexture(texture2)
    bt:SetNormalTexture(texture3)

    bt:HookScript("OnEnter", function(self)
        texture3:SetColorTexture(RGB("FFA500", 0.5))
    end)
    bt:HookScript("OnLeave", function(self)
        texture3:SetColorTexture(RGB("DCDCDC", 0.2))
    end)
    -- bt:HookScript("OnClick", function(self)
    -- end)
    return bt
end

------------------隐藏全部Tab按钮------------------
function BG.HideTab(Buttons, Show)
    for i, v in ipairs(Buttons) do
        v:Hide()
        v:GetParent():SetEnabled(true)
    end
    Show:Show()
    Show:GetParent():SetEnabled(false)
end

------------------计时器------------------
function BG.OnUpdateTime(func)
    local UpdateFrame = CreateFrame("Frame")
    UpdateFrame.timeElapsed = 0
    UpdateFrame:SetScript("OnUpdate", func)
end

------------------是否经典旧世版本------------------
function BG.Vanilla()
    if select(4, GetBuildInfo()) <= 20000 then
        return true
    end
end

------------------设置按钮文本的宽度------------------
function BG.SetButtonStringWidth(bt)
    local t = bt:GetFontString()
    t:SetWidth(bt:GetWidth())
    t:SetWordWrap(false)
end
