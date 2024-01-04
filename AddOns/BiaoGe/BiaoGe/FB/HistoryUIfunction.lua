local _, ADDONSELF = ...

local LibBG = ADDONSELF.LibBG
local L = ADDONSELF.L

local RR = ADDONSELF.RR
local NN = ADDONSELF.NN
local RN = ADDONSELF.RN
local Listmaijia = ADDONSELF.Listmaijia
local Size = ADDONSELF.Size
local RGB = ADDONSELF.RGB
local GetClassRGB = ADDONSELF.GetClassRGB
local SetClassCFF = ADDONSELF.SetClassCFF
local Sumjine = ADDONSELF.Sumjine
local SumZC = ADDONSELF.SumZC
local SumJ = ADDONSELF.SumJ
local SumGZ = ADDONSELF.SumGZ
local Listzhuangbei = ADDONSELF.Listzhuangbei
local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi
local Listjine = ADDONSELF.Listjine
local BossNum = ADDONSELF.BossNum
local FrameHide = ADDONSELF.FrameHide
local AddTexture = ADDONSELF.AddTexture

local pt = print

local p = {}
local preWidget
local framedown
local frameright
local red, greed, blue = 1, 1, 1
local touming1, touming2 = 0.1, 0.15

------------------标题------------------
function BG.HistoryBiaoTiUI(FB, t, b, bb, i, ii)
    local fontsize = 15

    if b == 1 and i == 1 then
        local version = BG["HistoryFrame" .. FB]:CreateFontString()
        if t == 1 then
            version:SetPoint("TOPLEFT", BG.MainFrame, "TOPLEFT", 13, -60)
        else
            version:SetPoint("TOPLEFT", frameright, "TOPLEFT", 100, 0)
        end
        version:SetFont(BIAOGE_TEXT_FONT, fontsize, "OUTLINE")
        version:SetTextColor(RGB(BG.y2))
        version:SetText(L["  项目"])
        version:Show()
        preWidget = version

        local version = BG["HistoryFrame" .. FB]:CreateFontString()
        version:SetPoint("TOPLEFT", preWidget, "TOPLEFT", 70, 0);
        version:SetFont(BIAOGE_TEXT_FONT, fontsize, "OUTLINE")
        version:SetTextColor(RGB(BG.y2))
        version:SetText(L["装备"])
        version:Show()
        preWidget = version
        p.preWidget0 = version

        local version = BG["HistoryFrame" .. FB]:CreateFontString()
        version:SetPoint("TOPLEFT", preWidget, "TOPLEFT", 155, 0);
        version:SetFont(BIAOGE_TEXT_FONT, fontsize, "OUTLINE")
        version:SetTextColor(RGB(BG.y2))
        version:SetText(L["买家"])
        version:Show()
        preWidget = version

        local version = BG["HistoryFrame" .. FB]:CreateFontString()
        version:SetPoint("TOPLEFT", preWidget, "TOPLEFT", 95, 0);
        version:SetFont(BIAOGE_TEXT_FONT, fontsize, "OUTLINE")
        version:SetTextColor(RGB(BG.y2))
        version:SetText(L["金额"])
        version:Show()
        preWidget = version
        frameright = version
    end
end

------------------装备------------------
function BG.HistoryZhuangBeiUI(FB, t, b, bb, i, ii)
    local button = CreateFrame("EditBox", nil, BG["HistoryFrame" .. FB], "InputBoxTemplate");
    button:SetSize(150, 20)
    button:SetFrameLevel(110)
    if b > 1 and i == 1 then
        button:SetPoint("TOPLEFT", framedown, "BOTTOMLEFT", 0, -20);
    else
        button:SetPoint("TOPLEFT", p["preWidget" .. i - 1], "BOTTOMLEFT", 0, -3);
    end
    button:SetAutoFocus(false)
    button:Show()
    button:SetEnabled(false)
    local icon = button:CreateTexture(nil, 'ARTWORK')
    icon:SetPoint('LEFT', -22, 0)
    icon:SetSize(16, 16)
    BG.HistoryFrame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i] = button
    preWidget = button
    p["preWidget" .. i] = button
    framedown = p["preWidget" .. ii]
    -- 内容改变时
    local _, class = UnitClass("player")
    local RealmId = GetRealmID()
    local player = UnitName("player")
    button:SetScript("OnTextChanged", function(self)
        local itemText = button:GetText()
        local itemID = select(1, GetItemInfoInstant(itemText))

        local num = BiaoGe.filterClassNum[RealmId][player] -- 隐藏
        if num ~= 0 then
            BG.FilterClass(FB, BossNum(FB, b, t), i, button, class, num, BiaoGeFilterTooltip, "HistoryFrame")
        end

        -- 装备的图标
        if not tonumber(self:GetText()) then
            local itemIcon = GetItemIcon(itemID)
            if itemIcon then
                icon:SetTexture(itemIcon)
            else
                icon:SetTexture(nil)
            end
        end
    end)
    -- 发送装备到聊天输入框
    button:SetScript("OnMouseDown", function(self, enter)
        if IsShiftKeyDown() then
            ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
            local text = self:GetText()
            ChatEdit_InsertLink(text)
            return
        end
        if IsControlKeyDown() then
            BG.TongBaoHis(button, BG.HistoryJineDB)
            return
        end
    end)
    -- 鼠标悬停在装备时
    button:SetScript("OnEnter", function(self)
        BG.HistoryFrameDs[FB .. 1]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Show()
        if not tonumber(self:GetText()) then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -70, 0);
            GameTooltip:ClearLines();
            local itemLink = button:GetText()
            local itemID = select(1, GetItemInfoInstant(itemLink))
            if itemID then
                GameTooltip:SetItemByID(itemID);
                GameTooltip:Show()
                local h = { FB, itemID }
                -- BG.HistoryJine(FB, itemID, true, BG.HistoryFrame[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i]:GetText())
                BG.HistoryJine(unpack(h))
                BG.HistoryMOD = h
            end
        end
    end)
    button:SetScript("OnLeave", function(self)
        BG.HistoryFrameDs[FB .. 1]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Hide()
        GameTooltip:Hide()
        if BG["HistoryJineFrameDB1"] then
            for i = 1, BG.HistoryJineFrameDBMax do
                BG["HistoryJineFrameDB" .. i]:Hide()
            end
            BG.HistoryJineFrame:Hide()
        end
    end)
end

------------------买家------------------
function BG.HistoryMaiJiaUI(FB, t, b, bb, i, ii)
    local button = CreateFrame("EditBox", nil, BG.HistoryFrame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i], "InputBoxTemplate");
    button:SetSize(90, 20)
    button:SetPoint("TOPLEFT", preWidget, "TOPRIGHT", 5, 0);
    button:SetFrameLevel(110)
    button:SetMaxBytes(19) --限制字数
    button:SetAutoFocus(false)
    button:Show()
    button:SetEnabled(false)
    preWidget = button
    BG.HistoryFrame[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i] = button

    -- 鼠标悬停在装备时
    button:SetScript("OnEnter", function(self)
        BG.HistoryFrameDs[FB .. 1]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Show()
    end)
    button:SetScript("OnLeave", function(self)
        BG.HistoryFrameDs[FB .. 1]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Hide()
        GameTooltip:Hide()
    end)
end

------------------金额------------------
function BG.HistoryJinEUI(FB, t, b, bb, i, ii)
    local button = CreateFrame("EditBox", nil, BG.HistoryFrame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i], "InputBoxTemplate");
    button:SetSize(80, 20)
    button:SetPoint("TOPLEFT", preWidget, "TOPRIGHT", 5, 0);
    button:SetFrameLevel(110)
    button:SetNumeric(true)
    button:SetAutoFocus(false)
    button:Show()
    button:SetEnabled(false)
    preWidget = button
    BG.HistoryFrame[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i] = button

    -- 鼠标悬停在装备时
    button:SetScript("OnEnter", function(self)
        BG.HistoryFrameDs[FB .. 1]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Show()
    end)
    button:SetScript("OnLeave", function(self)
        BG.HistoryFrameDs[FB .. 1]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Hide()
        GameTooltip:Hide()
    end)
end

------------------BOSS名字------------------
function BG.HistoryBossNameUI(FB, t, b, bb, i, ii)
    local fontsize = 14
    local version = BG["HistoryFrame" .. FB]:CreateFontString();
    version:SetPoint("TOP", BG.HistoryFrame[FB]["boss" .. BossNum(FB, b, t)].zhuangbei1, "TOPLEFT", -45, -2)
    version:SetFont(BIAOGE_TEXT_FONT, fontsize, "OUTLINE")
    version:SetTextColor(RGB(BG.Boss[FB]["boss" .. BossNum(FB, b, t)].color))
    version:SetText(BG.Boss[FB]["boss" .. BossNum(FB, b, t)].name)
    BG.HistoryFrame[FB]["boss" .. BossNum(FB, b, t)]["name"] = version
    if BG.HistoryFrame[FB]["boss" .. BossNum(FB, b, t)] == BG.HistoryFrame[FB]["boss" .. Maxb[FB] + 2] then
        local version = BG["HistoryFrame" .. FB]:CreateFontString()
        version:SetPoint("BOTTOM", BG.HistoryFrame[FB]["boss" .. Maxb[FB] + 2].zhuangbei5, "BOTTOMLEFT", -45, 7)
        version:SetFont(BIAOGE_TEXT_FONT, fontsize, "OUTLINE")
        version:SetTextColor(RGB("00BFFF"))
        version:SetText(L["工\n资"])
    end
end

------------------击杀用时------------------
function BG.HistoryJiShaUI(FB, t, b, bb, i, ii)
    local text = BG["HistoryFrame" .. FB]:CreateFontString();
    local num
    local color
    for i = 1, Maxi[FB] do
        if not BG.HistoryFrame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i + 1] then
            num = i
            break
        end
    end
    text:SetPoint("TOPLEFT", BG.HistoryFrame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. num], "BOTTOMLEFT", -0, -3)
    text:SetFont(BIAOGE_TEXT_FONT, 10, "OUTLINE,THICK")
    text:SetAlpha(0.8)
    BG.HistoryFrame[FB]["boss" .. BossNum(FB, b, t)]["time"] = text
end

------------------底色材质------------------
function BG.HistoryDiSeUI(FB, t, b, bb, i, ii)
    local textrue = BG.HistoryFrame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i]:CreateTexture()
    textrue:SetPoint("TOPLEFT", BG.HistoryFrame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i], "TOPLEFT", -4, -2)
    textrue:SetPoint("BOTTOMRIGHT", BG.HistoryFrame[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i], "BOTTOMRIGHT", -2, 0)
    textrue:SetColorTexture(red, greed, blue, touming1)
    textrue:Hide()
    BG.HistoryFrameDs[FB .. 1]["boss" .. BossNum(FB, b, t)]["ds" .. i] = textrue
end

------------------支出、总览、工资------------------
function BG.HistoryZhiChuZongLanGongZiUI(FB)
    -- 设置支出颜色：绿
    for i = 1, Maxi[FB], 1 do
        if BG.HistoryFrame[FB]["boss" .. Maxb[FB] + 1]["zhuangbei" .. i] then
            BG.HistoryFrame[FB]["boss" .. Maxb[FB] + 1]["zhuangbei" .. i]:SetTextColor(RGB("00FF00"))
            BG.HistoryFrame[FB]["boss" .. Maxb[FB] + 1]["jine" .. i]:SetTextColor(RGB("00FF00"))
        end
    end
    -- 设置总览颜色：粉
    for i = 1, 3, 1 do
        BG.HistoryFrame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei" .. i]:SetTextColor(RGB("EE82EE"))
        BG.HistoryFrame[FB]["boss" .. Maxb[FB] + 2]["jine" .. i]:SetTextColor(RGB("EE82EE"))
    end
    -- 设置工资颜色：蓝
    for i = 4, 5, 1 do
        BG.HistoryFrame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei" .. i]:SetTextColor(RGB("00BFFF"))
        BG.HistoryFrame[FB]["boss" .. Maxb[FB] + 2]["jine" .. i]:SetTextColor(RGB("00BFFF"))
    end
end
