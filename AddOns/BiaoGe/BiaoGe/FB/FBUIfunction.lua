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
function BG.FBBiaoTiUI(FB, t, b, bb, i, ii)
    local fontsize = 15
    if b == 1 and i == 1 then
        local version = BG["Frame" .. FB]:CreateFontString()
        if t == 1 then
            version:SetPoint("TOPLEFT", BG.MainFrame, "TOPLEFT", 13, -60)
        else
            version:SetPoint("TOPLEFT", frameright, "TOPLEFT", 100, 0)
        end
        version:SetFont(BIAOGE_TEXT_FONT, fontsize, "OUTLINE")
        version:SetTextColor(RGB(BG.y2))
        version:SetText(L["  项目"])
        preWidget = version

        local version = BG["Frame" .. FB]:CreateFontString()
        version:SetPoint("TOPLEFT", preWidget, "TOPLEFT", 70, 0)
        version:SetFont(BIAOGE_TEXT_FONT, fontsize, "OUTLINE")
        version:SetTextColor(RGB(BG.y2))
        version:SetText(L["装备"])
        preWidget = version
        p.preWidget0 = version

        local version = BG["Frame" .. FB]:CreateFontString()
        version:SetPoint("TOPLEFT", preWidget, "TOPLEFT", 155, 0)
        version:SetFont(BIAOGE_TEXT_FONT, fontsize, "OUTLINE")
        version:SetTextColor(RGB(BG.y2))
        version:SetText(L["买家"])
        preWidget = version

        local version = BG["Frame" .. FB]:CreateFontString()
        version:SetPoint("TOPLEFT", preWidget, "TOPLEFT", 95, 0)
        version:SetFont(BIAOGE_TEXT_FONT, fontsize, "OUTLINE")
        version:SetTextColor(RGB(BG.y2))
        version:SetText(L["金额"])
        preWidget = version
        frameright = version
    end
end

------------------装备------------------
function BG.FBZhuangBeiUI(FB, t, b, bb, i, ii)
    local button = CreateFrame("EditBox", nil, BG["Frame" .. FB], "InputBoxTemplate")
    button:SetSize(150, 20)
    button:SetFrameLevel(110)
    if b > 1 and i == 1 then
        button:SetPoint("TOPLEFT", framedown, "BOTTOMLEFT", 0, -20)
    else
        button:SetPoint("TOPLEFT", p["preWidget" .. i - 1], "BOTTOMLEFT", 0, -3)
    end
    button:SetAutoFocus(false)
    button:Show()
    local icon = button:CreateTexture(nil, 'ARTWORK')
    icon:SetPoint('LEFT', -22, 0)
    icon:SetSize(16, 16)
    if BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i] then
        if BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i] ~= "" then
            button:SetText(BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i])
        else
            BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i] = nil
        end
    end
    BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i] = button
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
        local name, link, quality, level, _, _, _, _, _, Texture, _, typeID = GetItemInfo(itemText)
        local hard
        if link then
            if FB == "ULD" then
                for index, value in ipairs(BG.Loot.ULD.Hard10) do
                    if itemID == value then
                        self:SetText(link .. "★")
                        hard = true
                    end
                end
                if not hard then
                    for index, value in ipairs(BG.Loot.ULD.Hard25) do
                        if itemID == value then
                            self:SetText(link .. "★")
                        end
                    end
                end
            end
        end
        if self:GetText() == "" then
            BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["guanzhu" .. i] = nil
            BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["guanzhu" .. i]:Hide()
        end

        local num = BiaoGe.filterClassNum[RealmId][player] -- 隐藏
        if num ~= 0 then
            BG.FilterClass(FB, BossNum(FB, b, t), i, button, class, num, BiaoGeFilterTooltip, "Frame")
        end

        if self ~= BG.Frame[FB]["boss" .. Maxb[FB]]["zhuangbei" .. i] and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 1]["zhuangbei" .. i] and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei" .. i] then
            BG.DuiZhangFrame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i]:SetText(self:GetText())
        end

        if button:GetText() ~= "" then
            BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i] = button:GetText() -- 储存文本
        else
            BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i] = nil
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
    -- 鼠标按下时
    button:SetScript("OnMouseDown", function(self, enter)
        if enter == "RightButton" and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei" .. i] then -- 右键清空格子
            self:SetEnabled(false)
            self:SetText("")
            if BG.lastfocus then
                BG.lastfocus:ClearFocus()
            end
            return
        end
        if IsAltKeyDown() and IsControlKeyDown() and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei" .. i] then
            self:SetEnabled(false)
            button:ClearFocus()
            if BG.lastfocus then
                BG.lastfocus:ClearFocus()
            end
            BG.JiaoHuan(button, FB, b, i, t)
            return
        end
        if IsShiftKeyDown() then
            self:SetEnabled(false)
            button:ClearFocus()
            if BG.lastfocus then
                BG.lastfocus:ClearFocus()
            end
            ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
            local text = self:GetText()
            ChatEdit_InsertLink(text)
            return
        end
        if IsAltKeyDown() and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 1]["zhuangbei" .. i] and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei" .. i] then
            if self:GetText() ~= "" then
                self:SetEnabled(false)
                button:ClearFocus()
                if BG.lastfocus then
                    BG.lastfocus:ClearFocus()
                end
                if BG.IsML then -- 拍卖倒数
                    local link = self:GetText()
                    BG.StartCountDown(link)
                else -- 关注装备
                    BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["guanzhu" .. i] = true
                    BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["guanzhu" .. i]:Show()
                end
            end
            return
        end
        if IsControlKeyDown() and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 1]["zhuangbei" .. i] and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei" .. i] then
            BG.TongBaoHis(button, BG.HistoryJineDB)
            return
        end
    end)
    button:SetScript("OnMouseUp", function(self, enter)
        if self:IsEnabled() then
            local infoType, itemID, itemLink = GetCursorInfo()
            if infoType == "item" then
                self:SetText(itemLink)
                -- self:HighlightText(0,0)
                self:ClearFocus()
                ClearCursor()
                return
            end
        end
        if self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei" .. i] then
            -- self:HighlightText(0,0)
            self:SetEnabled(true)
        end
        if enter == "RightButton" and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei" .. i] then -- 右键清空格子
            self:SetEnabled(true)
        end
    end)
    -- 鼠标悬停在装备时
    button:SetScript("OnEnter", function(self)
        BG.FrameDs[FB .. 1]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Show()
        if not tonumber(self:GetText()) then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -70, 0)
            GameTooltip:ClearLines()
            local itemLink = button:GetText()
            local itemID = select(1, GetItemInfoInstant(itemLink))
            if itemID then
                GameTooltip:SetItemByID(itemID)
                GameTooltip:Show()
                local h = { FB, itemID, true, BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i]:GetText() }
                BG.HistoryJine(unpack(h))
                BG.HistoryMOD = h
            end
            BG.HilightBag(itemLink)
        end
    end)
    button:SetScript("OnLeave", function(self)
        BG.FrameDs[FB .. 1]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Hide()
        GameTooltip:Hide()
        if BG["HistoryJineFrameDB1"] then
            for i = 1, BG.HistoryJineFrameDBMax do
                BG["HistoryJineFrameDB" .. i]:Hide()
            end
            BG.HistoryJineFrame:Hide()
        end
        BG.HideHilightBag()
    end)
    -- 获得光标时
    button:SetScript("OnEditFocusGained", function(self)
        FrameHide(1)
        self:HighlightText()
        BG.lastfocuszhuangbei = self
        BG.lastfocus = self
        Listzhuangbei(self, BossNum(FB, b, t), FB, BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["guanzhu" .. i],
            BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["guanzhu" .. i])
        if BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i + 1] then
            BG.lastfocuszhuangbei2 = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i + 1]
        else
            BG.lastfocuszhuangbei2 = nil
        end
        BG.FrameDs[FB .. 2]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Show()
    end)
    -- 失去光标时
    button:SetScript("OnEditFocusLost", function(self)
        self:HighlightText(0, 0)
        if BG.FrameZhuangbeiList then
            BG.FrameZhuangbeiList:Hide()
        end
        BG.FrameDs[FB .. 2]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Hide()
    end)
    -- 按TAB跳转右边
    button:SetScript("OnTabPressed", function(self)
        local b = BossNum(FB, b, t)
        BG.Frame[FB]["boss" .. b]["maijia" .. i]:SetFocus()
    end)
    -- 按ENTER跳转下边
    button:SetScript("OnEnterPressed", function(self)
        local b = BossNum(FB, b, t)
        if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i + 1] then
            BG.Frame[FB]["boss" .. b]["zhuangbei" .. i + 1]:SetFocus()
        elseif b + 1 ~= Maxb[FB] + 2 then
            BG.Frame[FB]["boss" .. b + 1]["zhuangbei" .. 1]:SetFocus()
        end
    end)
    -- 按箭头跳转
    button:SetScript("OnKeyDown", function(self, enter)
        local bb = b
        local tt = t
        local b = BossNum(FB, b, t)
        if not IsModifierKeyDown() then
            if enter == "UP" then -- 上↑
                if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i - 1] then
                    BG.Frame[FB]["boss" .. b]["zhuangbei" .. i - 1]:SetFocus()
                else
                    local b = b
                    if b == 1 then
                        b = Maxb[FB] + 2
                    end
                    local i
                    for ii = Maxi[FB], 1, -1 do
                        if BG.Frame[FB]["boss" .. b - 1]["zhuangbei" .. ii] then
                            i = ii
                            break
                        end
                    end
                    BG.Frame[FB]["boss" .. b - 1]["zhuangbei" .. i]:SetFocus()
                end
            elseif enter == "DOWN" then -- 下↓
                if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i + 1] then
                    BG.Frame[FB]["boss" .. b]["zhuangbei" .. i + 1]:SetFocus()
                else
                    local b = b
                    if b == Maxb[FB] + 1 then
                        b = 0
                    end
                    BG.Frame[FB]["boss" .. b + 1]["zhuangbei" .. 1]:SetFocus()
                end
            elseif enter == "LEFT" then  -- 左←
                BG.Frame[FB]["boss" .. b]["jine" .. i]:SetFocus()
            elseif enter == "RIGHT" then -- 右→
                BG.Frame[FB]["boss" .. b]["maijia" .. i]:SetFocus()
            end
        else
            if enter == "UP" then -- 上↑
                local b = b
                if b == 1 then
                    b = Maxb[FB] + 2
                end
                if BG.Frame[FB]["boss" .. b - 1]["zhuangbei" .. i] then
                    BG.Frame[FB]["boss" .. b - 1]["zhuangbei" .. i]:SetFocus()
                else
                    local i
                    for ii = Maxi[FB], 1, -1 do
                        if BG.Frame[FB]["boss" .. b - 1]["zhuangbei" .. ii] then
                            i = ii
                            break
                        end
                    end
                    BG.Frame[FB]["boss" .. b - 1]["zhuangbei" .. i]:SetFocus()
                end
            elseif enter == "DOWN" then -- 下↓
                local b = b
                if b == Maxb[FB] + 1 then
                    b = 0
                end
                if BG.Frame[FB]["boss" .. b + 1]["zhuangbei" .. i] then
                    BG.Frame[FB]["boss" .. b + 1]["zhuangbei" .. i]:SetFocus()
                else
                    local i
                    for ii = Maxi[FB], 1, -1 do
                        if BG.Frame[FB]["boss" .. b + 1]["zhuangbei" .. ii] then
                            i = ii
                            break
                        end
                    end
                    BG.Frame[FB]["boss" .. b + 1]["zhuangbei" .. i]:SetFocus()
                end
            end
        end
    end)
end

------------------关注装备------------------
function BG.FBGuanZhuUI(FB, t, b, bb, i, ii)
    local frame = CreateFrame("Frame", nil, BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i]) -- 关注按钮
    frame:SetSize(50, 23)
    frame:SetPoint("RIGHT", preWidget, "RIGHT", 5, -1)
    frame:SetFrameLevel(112)
    local fontString = frame:CreateFontString()
    fontString:SetAllPoints()
    fontString:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
    fontString:SetTextColor(RGB(BG.y2))
    fontString:SetText(BG.STC_b1(L["关注"]))
    if BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["guanzhu" .. i] then
        frame:Show()
    else
        frame:Hide()
    end
    BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["guanzhu" .. i] = frame

    -- 鼠标悬停提示
    frame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
        GameTooltip:ClearLines()
        GameTooltip:SetText(BG.STC_b1(L["关注中，团长拍卖此装备会提醒"]) .. "\n" .. L["右键取消关注"])
    end)
    frame:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    -- 单击触发
    frame:SetScript("OnMouseDown", function(self, enter)
        if enter == "RightButton" then -- 右键清空格子
            FrameHide(0)
            BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["guanzhu" .. i] = nil
            self:Hide()
        end
    end)
end

------------------买家------------------
function BG.FBMaiJiaUI(FB, t, b, bb, i, ii)
    local button = CreateFrame("EditBox", nil, BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i],
        "InputBoxTemplate")
    button:SetSize(90, 20)
    button:SetPoint("TOPLEFT", preWidget, "TOPRIGHT", 5, 0)
    button:SetFrameLevel(110)
    -- button:SetMaxBytes(19) --限制字数
    button:SetAutoFocus(false)
    button:Show()
    if BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i] then
        if BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i] ~= "" then
            button:SetText(BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i])
            button:SetCursorPosition(0)
        else
            BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i] = nil
        end
    end
    if BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["color" .. i] then
        if BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["color" .. i][1] ~= 1
            and BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["color" .. i][2] ~= 1
            and BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["color" .. i][3] ~= 1 then
            button:SetTextColor(BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["color" .. i][1],
                BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["color" .. i][2], BiaoGe[FB]["boss" .. BossNum(FB, b, t)]
                ["color" .. i][3])
        else
            BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["color" .. i] = nil
        end
    end
    preWidget = button
    BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i] = button
    -- 当内容改变时
    button:SetScript("OnTextChanged", function(self)
        if button:GetText() ~= "" then
            BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i] = button:GetText()         -- 储存文本
            BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["color" .. i] = { button:GetTextColor() } -- 储存颜色
        else
            BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["maijia" .. i] = nil
            BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["color" .. i] = nil
            self:SetTextColor(1, 1, 1)
        end
    end)
    -- 点击时
    button:SetScript("OnMouseDown", function(self, enter)
        if enter == "RightButton" and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["maijia" .. i] then -- 右键清空格子
            self:SetEnabled(false)
            self:SetText("")
            if BG.lastfocus then
                BG.lastfocus:ClearFocus()
            end
            return
        end
        if IsAltKeyDown() and IsControlKeyDown() and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["maijia" .. i] then
            self:SetEnabled(false)
            button:ClearFocus()
            if BG.lastfocus then
                BG.lastfocus:ClearFocus()
            end
            BG.JiaoHuan(button, FB, b, i, t)
            return
        end
    end)
    button:SetScript("OnMouseUp", function(self, enter)
        if self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["maijia" .. i] then
            -- self:HighlightText(0,0)
            self:SetEnabled(true)
        end
        if enter == "RightButton" and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["maijia" .. i] then -- 右键清空格子
            self:SetEnabled(true)
        end
    end)
    -- 悬停鼠标时
    button:SetScript("OnEnter", function(self) -- 底色
        BG.FrameDs[FB .. 1]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Show()
    end)
    button:SetScript("OnLeave", function(self)
        BG.FrameDs[FB .. 1]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Hide()
    end)
    -- 获得光标时
    button:SetScript("OnEditFocusGained", function(self)
        FrameHide(1)
        button:HighlightText()
        BG.lastfocus = self
        Listmaijia(self)
        BG.FrameDs[FB .. 2]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Show() -- 底色
        local name = "auctionChat"
        if BG.FramePaiMaiMsg and BiaoGe.options[name] == 1 then
            BG.FramePaiMaiMsg:SetParent(BG.FrameMaijiaList)
            BG.FramePaiMaiMsg:ClearAllPoints()
            BG.FramePaiMaiMsg:SetPoint("TOPRIGHT", BG.FrameMaijiaList, "TOPLEFT", 0, 0)
            BG.FramePaiMaiMsg:Show()
            BG.FramePaiMaiMsg2:ScrollToBottom()
        end
    end)
    -- 失去光标时
    button:SetScript("OnEditFocusLost", function(self)
        button:HighlightText(0, 0)
        -- BG.FrameMaijiaList:Hide()
        BG.FrameDs[FB .. 2]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Hide()
    end)
    -- 按TAB跳转右边
    button:SetScript("OnTabPressed", function(self)
        local b = BossNum(FB, b, t)
        BG.Frame[FB]["boss" .. b]["jine" .. i]:SetFocus()
    end)
    -- 按ENTER跳转下边
    button:SetScript("OnEnterPressed", function(self)
        local b = BossNum(FB, b, t)
        if BG.Frame[FB]["boss" .. b]["maijia" .. i + 1] then
            BG.Frame[FB]["boss" .. b]["maijia" .. i + 1]:SetFocus()
        elseif b + 1 ~= Maxb[FB] + 2 then
            BG.Frame[FB]["boss" .. b + 1]["maijia" .. 1]:SetFocus()
        end
    end)
    -- 按ESC退出
    button:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
        BG.FrameMaijiaList:Hide()
    end)
    -- 按箭头跳转
    button:SetScript("OnKeyDown", function(self, enter)
        local b = BossNum(FB, b, t)
        if not IsModifierKeyDown() then
            if enter == "UP" then -- 上↑
                if BG.Frame[FB]["boss" .. b]["maijia" .. i - 1] then
                    BG.Frame[FB]["boss" .. b]["maijia" .. i - 1]:SetFocus()
                else
                    local b = b
                    if b == 1 then
                        b = Maxb[FB] + 2
                    end
                    local i
                    for ii = Maxi[FB], 1, -1 do
                        if BG.Frame[FB]["boss" .. b - 1]["maijia" .. ii] then
                            i = ii
                            break
                        end
                    end
                    BG.Frame[FB]["boss" .. b - 1]["maijia" .. i]:SetFocus()
                end
            elseif enter == "DOWN" then -- 下↓
                if BG.Frame[FB]["boss" .. b]["maijia" .. i + 1] then
                    BG.Frame[FB]["boss" .. b]["maijia" .. i + 1]:SetFocus()
                else
                    local b = b
                    if b == Maxb[FB] + 1 then
                        b = 0
                    end
                    BG.Frame[FB]["boss" .. b + 1]["maijia" .. 1]:SetFocus()
                end
            elseif enter == "LEFT" then  -- 左←
                BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:SetFocus()
            elseif enter == "RIGHT" then -- 右→
                BG.Frame[FB]["boss" .. b]["jine" .. i]:SetFocus()
            end
        else
            if enter == "UP" then -- 上↑
                local b = b
                if b == 1 then
                    b = Maxb[FB] + 2
                end
                if BG.Frame[FB]["boss" .. b - 1]["maijia" .. i] then
                    BG.Frame[FB]["boss" .. b - 1]["maijia" .. i]:SetFocus()
                else
                    local i
                    for ii = Maxi[FB], 1, -1 do
                        if BG.Frame[FB]["boss" .. b - 1]["maijia" .. ii] then
                            i = ii
                            break
                        end
                    end
                    BG.Frame[FB]["boss" .. b - 1]["maijia" .. i]:SetFocus()
                end
            elseif enter == "DOWN" then -- 下↓
                local b = b
                if b == Maxb[FB] + 1 then
                    b = 0
                end
                if BG.Frame[FB]["boss" .. b + 1]["maijia" .. i] then
                    BG.Frame[FB]["boss" .. b + 1]["maijia" .. i]:SetFocus()
                else
                    local i
                    for ii = Maxi[FB], 1, -1 do
                        if BG.Frame[FB]["boss" .. b + 1]["maijia" .. ii] then
                            i = ii
                            break
                        end
                    end
                    BG.Frame[FB]["boss" .. b + 1]["maijia" .. i]:SetFocus()
                end
            end
        end
    end)
end

------------------金额------------------
function BG.FBJinEUI(FB, t, b, bb, i, ii)
    local button = CreateFrame("EditBox", nil, BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i],
        "InputBoxTemplate")
    button:SetSize(80, 20)
    button:SetPoint("TOPLEFT", preWidget, "TOPRIGHT", 5, 0)
    button:SetFrameLevel(110)
    -- button:SetNumeric(true)      -- 只能输入整数
    button:SetAutoFocus(false)
    button:Show()
    if BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i] then
        if BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i] ~= "" then
            button:SetText(BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i])
        else
            BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i] = nil
        end
    end
    preWidget = button
    BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i] = button
    -- 当内容改变时
    button:SetScript("OnTextChanged", function(self)
        local name = "autoAdd0"
        if BiaoGe.options[name] == 1 and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine" .. i] and not IsModifierKeyDown() then
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
        if self ~= BG.Frame[FB]["boss" .. Maxb[FB]]["jine" .. i] and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 1]["jine" .. i] and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine" .. i] then
            BG.DuiZhangFrame[FB]["boss" .. BossNum(FB, b, t)]["myjine" .. i]:SetText(self:GetText())
        end

        if button:GetText() ~= "" then
            BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i] = button:GetText() -- 储存文本
        else
            BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i] = nil
        end
        BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine1"]:SetText(Sumjine(BiaoGe[FB], Maxb[FB], Maxi[FB])) -- 计算总收入
        BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine2"]:SetText(SumZC(BiaoGe[FB], Maxb[FB], Maxi[FB]))   -- 计算总支出
        BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine3"]:SetText(SumJ(BiaoGe[FB], Maxb[FB], Maxi[FB]))    -- 计算净收入
        BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine5"]:SetText(SumGZ(BiaoGe[FB], Maxb[FB], Maxi[FB]))   -- 计算人均工资
    end)
    -- 点击时
    button:SetScript("OnMouseDown", function(self, enter)
        if enter == "RightButton" and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine" .. i] then -- 右键清空格子
            FrameHide(1)
            self:SetEnabled(false)
            self:SetText("")
            return
        end
        if IsAltKeyDown() and IsControlKeyDown() and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine" .. i] then
            self:SetEnabled(false)
            button:ClearFocus()
            if BG.lastfocus then
                BG.lastfocus:ClearFocus()
            end
            BG.JiaoHuan(button, FB, b, i, t)
            return
        end
    end)
    button:SetScript("OnMouseUp", function(self, enter)
        if self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine" .. i] then
            -- self:HighlightText(0,0)
            self:SetEnabled(true)
        end
        if enter == "RightButton" and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine" .. i] then -- 右键清空格子
            self:SetEnabled(true)
        end
    end)
    -- 悬停鼠标时
    button:SetScript("OnEnter", function(self) -- 底色
        BG.FrameDs[FB .. 1]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Show()
    end)
    button:SetScript("OnLeave", function(self)
        BG.FrameDs[FB .. 1]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Hide()
    end)
    -- 获得光标时
    button:SetScript("OnEditFocusGained", function(self)
        FrameHide(1)
        button:HighlightText()
        BG.lastfocus = self
        BG.FrameDs[FB .. 2]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Show() -- 底色
        if self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 1]["jine" .. i] and self ~= BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine" .. i] then
            Listjine(self, FB, BossNum(FB, b, t), i)
        end
        local name = "auctionChat"
        if BG.FramePaiMaiMsg then
            BG.FramePaiMaiMsg:SetParent(BG.FrameJineList)
            BG.FramePaiMaiMsg:ClearAllPoints()
            BG.FramePaiMaiMsg:SetPoint("TOPRIGHT", BG.FrameJineList, "TOPLEFT", 0, 0)
            BG.FramePaiMaiMsg2:ScrollToBottom()
            if BiaoGe.options[name] == 1 then
                BG.FramePaiMaiMsg:Show()
            else
                BG.FramePaiMaiMsg:Hide()
            end
        end
    end)
    -- 失去光标时
    button:SetScript("OnEditFocusLost", function(self)
        button:HighlightText(0, 0)
        BG.FrameDs[FB .. 2]["boss" .. BossNum(FB, b, t)]["ds" .. i]:Hide()
    end)
    -- 按TAB跳转下一行的装备
    button:SetScript("OnTabPressed", function(self)
        local b = BossNum(FB, b, t)
        if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i + 1] then
            BG.Frame[FB]["boss" .. b]["zhuangbei" .. i + 1]:SetFocus()
        elseif b + 1 ~= Maxb[FB] + 2 then
            BG.Frame[FB]["boss" .. b + 1]["zhuangbei" .. 1]:SetFocus()
        end
    end)
    -- 按ENTER跳转下边
    button:SetScript("OnEnterPressed", function(self)
        local b = BossNum(FB, b, t)
        if BG.Frame[FB]["boss" .. b]["jine" .. i + 1] then
            BG.Frame[FB]["boss" .. b]["jine" .. i + 1]:SetFocus()
        elseif b + 1 ~= Maxb[FB] + 2 then
            BG.Frame[FB]["boss" .. b + 1]["jine" .. 1]:SetFocus()
        end
    end)
    -- 按ESC退出
    button:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
        if BG.FrameJineList then
            BG.FrameJineList:Hide()
        end
        -- BG.FramePaiMaiMsg:Hide()
    end)
    -- 按箭头跳转
    button:SetScript("OnKeyDown", function(self, enter)
        local b = BossNum(FB, b, t)
        if not IsModifierKeyDown() then
            if enter == "UP" then -- 上↑
                if BG.Frame[FB]["boss" .. b]["jine" .. i - 1] then
                    BG.Frame[FB]["boss" .. b]["jine" .. i - 1]:SetFocus()
                else
                    local b = b
                    if b == 1 then
                        b = Maxb[FB] + 2
                    end
                    local i
                    for ii = Maxi[FB], 1, -1 do
                        if BG.Frame[FB]["boss" .. b - 1]["jine" .. ii] then
                            i = ii
                            break
                        end
                    end
                    BG.Frame[FB]["boss" .. b - 1]["jine" .. i]:SetFocus()
                end
            elseif enter == "DOWN" then -- 下↓
                if BG.Frame[FB]["boss" .. b]["jine" .. i + 1] then
                    BG.Frame[FB]["boss" .. b]["jine" .. i + 1]:SetFocus()
                else
                    local b = b
                    if b == Maxb[FB] + 1 then
                        b = 0
                    end
                    BG.Frame[FB]["boss" .. b + 1]["jine" .. 1]:SetFocus()
                end
            elseif enter == "LEFT" then  -- 左←
                BG.Frame[FB]["boss" .. b]["maijia" .. i]:SetFocus()
            elseif enter == "RIGHT" then -- 右→
                BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:SetFocus()
            end
        else
            if enter == "UP" then -- 上↑
                local b = b
                if b == 1 then
                    b = Maxb[FB] + 2
                end
                if BG.Frame[FB]["boss" .. b - 1]["jine" .. i] then
                    BG.Frame[FB]["boss" .. b - 1]["jine" .. i]:SetFocus()
                else
                    local i
                    for ii = Maxi[FB], 1, -1 do
                        if BG.Frame[FB]["boss" .. b - 1]["jine" .. ii] then
                            i = ii
                            break
                        end
                    end
                    BG.Frame[FB]["boss" .. b - 1]["jine" .. i]:SetFocus()
                end
            elseif enter == "DOWN" then -- 下↓
                local b = b
                if b == Maxb[FB] + 1 then
                    b = 0
                end
                if BG.Frame[FB]["boss" .. b + 1]["jine" .. i] then
                    BG.Frame[FB]["boss" .. b + 1]["jine" .. i]:SetFocus()
                else
                    local i
                    for ii = Maxi[FB], 1, -1 do
                        if BG.Frame[FB]["boss" .. b + 1]["jine" .. ii] then
                            i = ii
                            break
                        end
                    end
                    BG.Frame[FB]["boss" .. b + 1]["jine" .. i]:SetFocus()
                end
            end
        end
    end)
end

------------------欠款------------------
function BG.FBQianKuanUI(FB, t, b, bb, i, ii)
    local frame = CreateFrame("Frame", nil, BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i]) -- 欠款按钮
    frame:SetSize(23, 23)
    frame:SetPoint("LEFT", preWidget, "RIGHT", 0, 0)
    frame:SetFrameLevel(110)
    local fontString = frame:CreateFontString()
    fontString:SetAllPoints()
    fontString:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
    fontString:SetTextColor(RGB(BG.y2))
    fontString:SetText("|cffFF0000" .. L["欠"] .. "|r")
    if BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["qiankuan" .. i] == "" then
        BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["qiankuan" .. i] = nil
    end
    if not BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["qiankuan" .. i] then
        frame:Hide()
    else
        frame:Show()
    end
    preWidget = frame
    BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["qiankuan" .. i] = frame

    -- 鼠标悬停提示
    frame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
        GameTooltip:ClearLines()
        GameTooltip:SetText(format("|cffFF0000" .. L["欠款：%s|r\n右键清除欠款"],
            BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["qiankuan" .. i]))
    end)
    frame:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    -- 单击触发
    frame:SetScript("OnMouseDown", function(self, enter)
        if enter == "RightButton" then -- 右键清空格子
            FrameHide(0)
            BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["qiankuan" .. i] = nil
            self:Hide()
        end
    end)
end

------------------BOSS名字------------------
function BG.FBBossNameUI(FB, t, b, bb, i, ii)
    local fontsize = 14
    if FB == "ICC" and BossNum(FB, b, t) <= 13 then
        local f = CreateFrame("Frame", nil, BG["Frame" .. FB])
        f:SetPoint("TOP", BG.Frame[FB]["boss" .. BossNum(FB, b, t)].zhuangbei1, "TOPLEFT", -45, -2)
        f:SetSize(20, 40)
        local version = f:CreateFontString()
        version:SetPoint("CENTER")
        version:SetFont(BIAOGE_TEXT_FONT, fontsize, "OUTLINE")
        version:SetTextColor(RGB(BG.Boss[FB]["boss" .. BossNum(FB, b, t)].color))
        version:SetText(BG.Boss[FB]["boss" .. BossNum(FB, b, t)].name)
        f:SetSize(version:GetStringWidth(), version:GetStringHeight())
        BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["name"] = version
        f:SetScript("OnMouseDown", function(self)
            local b = BossNum(FB, b, t)
            BG.ClickTabButton(BG.tabButtons, 5)

            for i, v in ipairs(BG["BossTabButtons" .. FB]) do
                v:Enable()
                v.spellScrollFrame:Hide()
                v.classScrollFrame:Hide()
            end
            BG["BossTabButtons" .. FB][b]:Disable()
            BG["BossTabButtons" .. FB][b].spellScrollFrame:Show()
            BG["BossTabButtons" .. FB][b].classScrollFrame:Show()
            BiaoGe.BossFrame[FB].lastFrame = b
            PlaySound(BG.sound1, "Master")
        end)
        f:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:SetText(L["查看该BOSS攻略"])
            version:SetTextColor(1, 1, 1)
        end)
        f:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
            version:SetTextColor(RGB(BG.Boss[FB]["boss" .. BossNum(FB, b, t)].color))
        end)
    else
        local version = BG["Frame" .. FB]:CreateFontString()
        version:SetPoint("TOP", BG.Frame[FB]["boss" .. BossNum(FB, b, t)].zhuangbei1, "TOPLEFT", -45, -2)
        version:SetFont(BIAOGE_TEXT_FONT, fontsize, "OUTLINE")
        version:SetTextColor(RGB(BG.Boss[FB]["boss" .. BossNum(FB, b, t)].color))
        version:SetText(BG.Boss[FB]["boss" .. BossNum(FB, b, t)].name)
        BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["name"] = version
    end
    if BG.Frame[FB]["boss" .. BossNum(FB, b, t)] == BG.Frame[FB]["boss" .. Maxb[FB] + 2] then
        local version = BG["Frame" .. FB]:CreateFontString()
        version:SetPoint("BOTTOM", BG.Frame[FB]["boss" .. Maxb[FB] + 2].zhuangbei5, "BOTTOMLEFT", -45, 7)
        version:SetFont(BIAOGE_TEXT_FONT, fontsize, "OUTLINE")
        version:SetTextColor(RGB("00BFFF"))
        version:SetText(L["工\n资"])
    end
    BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["bossname"] = nil
    BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["bossname2"] = nil
end

------------------击杀用时------------------
function BG.FBJiShaUI(FB, t, b, bb, i, ii)
    if not BG.Loot.encounterID[FB] then return end
    for id, num in pairs(BG.Loot.encounterID[FB]) do
        if tonumber(num) == tonumber(BossNum(FB, b, t)) then
            local text = BG["Frame" .. FB]:CreateFontString()
            local num
            for i = 1, Maxi[FB] do
                if not BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i + 1] then
                    num = i
                    break
                end
            end
            text:SetPoint("TOPLEFT", BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. num], "BOTTOMLEFT", -0, -3)
            text:SetFont(BIAOGE_TEXT_FONT, 10, "OUTLINE,THICK")
            text:SetAlpha(0)
            BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["time"] = text

            if BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["time"] then
                text:SetText(BiaoGe[FB]["boss" .. BossNum(FB, b, t)]["time"])
            end
        end
    end
end

------------------底色材质------------------
function BG.FBDiSeUI(FB, t, b, bb, i, ii)
    -- 先做底色材质1（鼠标悬停的）
    local textrue = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i]:CreateTexture()
    textrue:SetPoint("TOPLEFT", BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i], "TOPLEFT", -4, -2)
    textrue:SetPoint("BOTTOMRIGHT", BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i], "BOTTOMRIGHT", -2, 0)
    textrue:SetColorTexture(red, greed, blue, touming1)
    textrue:Hide()
    BG.FrameDs[FB .. 1]["boss" .. BossNum(FB, b, t)]["ds" .. i] = textrue

    -- 底色材质2（点击框体后）
    local textrue = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i]:CreateTexture()
    textrue:SetPoint("TOPLEFT", BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i], "TOPLEFT", -4, -2)
    textrue:SetPoint("BOTTOMRIGHT", BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i], "BOTTOMRIGHT", -2, 0)
    textrue:SetColorTexture(red, greed, blue, touming2)
    textrue:Hide()
    BG.FrameDs[FB .. 2]["boss" .. BossNum(FB, b, t)]["ds" .. i] = textrue

    -- 底色材质3（团长发的装备高亮）
    local textrue = BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i]:CreateTexture()
    textrue:SetPoint("TOPLEFT", BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["zhuangbei" .. i], "TOPLEFT", -4, -2)
    textrue:SetPoint("BOTTOMRIGHT", BG.Frame[FB]["boss" .. BossNum(FB, b, t)]["jine" .. i], "BOTTOMRIGHT", -2, 0)
    textrue:SetColorTexture(1, 1, 0, touming2)
    textrue:Hide()
    BG.FrameDs[FB .. 3]["boss" .. BossNum(FB, b, t)]["ds" .. i] = textrue
end

------------------支出、总览、工资------------------
function BG.FBZhiChuZongLanGongZiUI(FB)
    -- 初始化支出内容
    if BiaoGe[FB]["boss" .. Maxb[FB] + 1]["zhuangbei1"] == "" then
        BG.Frame[FB]["boss" .. Maxb[FB] + 1]["zhuangbei1"]:SetText(L["坦克补贴"])
    end
    if BiaoGe[FB]["boss" .. Maxb[FB] + 1]["zhuangbei2"] == "" then
        BG.Frame[FB]["boss" .. Maxb[FB] + 1]["zhuangbei2"]:SetText(L["治疗补贴"])
    end
    if BiaoGe[FB]["boss" .. Maxb[FB] + 1]["zhuangbei3"] == "" then
        BG.Frame[FB]["boss" .. Maxb[FB] + 1]["zhuangbei3"]:SetText(L["输出补贴"])
    end
    if BiaoGe[FB]["boss" .. Maxb[FB] + 1]["zhuangbei4"] == "" then
        BG.Frame[FB]["boss" .. Maxb[FB] + 1]["zhuangbei4"]:SetText(L["放鱼补贴"])
    end
    -- if BiaoGe[FB]["boss"..Maxb[FB]+1]["zhuangbei5"] == "" then
    --     BG.Frame[FB]["boss"..Maxb[FB]+1]["zhuangbei5"]:SetText("其他补贴")
    -- end
    -- 设置支出颜色：绿
    for i = 1, Maxi[FB], 1 do
        if BG.Frame[FB]["boss" .. Maxb[FB] + 1]["zhuangbei" .. i] then
            BG.Frame[FB]["boss" .. Maxb[FB] + 1]["zhuangbei" .. i]:SetTextColor(RGB("00FF00"))
            BG.Frame[FB]["boss" .. Maxb[FB] + 1]["jine" .. i]:SetTextColor(RGB("00FF00"))
        end
    end

    -- 总览和工资
    BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei1"]:SetText(L["总收入"])
    BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei2"]:SetText(L["总支出"])
    BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei3"]:SetText(L["净收入"])
    BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei4"]:SetText(L["分钱人数"])
    BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei5"]:SetText(L["人均工资"])
    if BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine4"]:GetText() == "" then
        BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine4"]:SetText("25")
    end
    for i = 1, 5, 1 do
        BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei" .. i]:SetEnabled(false)
        BG.Frame[FB]["boss" .. Maxb[FB] + 2]["maijia" .. i]:SetEnabled(false)
        BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine" .. i]:SetEnabled(false)
        -- BG.Frame[FB]["boss"..Maxb[FB]]["maijia"..i]:SetEnabled(false)       -- 关掉罚款的买家按键
    end
    BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine4"]:SetEnabled(true)
    -- 设置总览颜色：粉
    for i = 1, 3, 1 do
        BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei" .. i]:SetTextColor(RGB("EE82EE"))
        BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine" .. i]:SetTextColor(RGB("EE82EE"))
    end
    -- 设置工资颜色：蓝
    for i = 4, 5, 1 do
        BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei" .. i]:SetTextColor(RGB("00BFFF"))
        BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine" .. i]:SetTextColor(RGB("00BFFF"))
    end
    -- 设置工资人数的鼠标提示
    BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei4"]:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
        GameTooltip:ClearLines()
        GameTooltip:SetText(L["人数可自行修改"])
    end)
    BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine4"]:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
        GameTooltip:ClearLines()
        GameTooltip:SetText(L["人数可自行修改"])
    end)
    BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine4"]:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
end
