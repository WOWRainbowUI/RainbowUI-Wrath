local _, ADDONSELF = ...

local LibBG = ADDONSELF.LibBG
local L = ADDONSELF.L

local RR = ADDONSELF.RR
local NN = ADDONSELF.NN
local RN = ADDONSELF.RN
local Size = ADDONSELF.Size
local RGB = ADDONSELF.RGB
local GetClassRGB = ADDONSELF.GetClassRGB
local SetClassCFF = ADDONSELF.SetClassCFF
local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi
local HopeMaxn = ADDONSELF.HopeMaxn
local HopeMaxb = ADDONSELF.HopeMaxb
local HopeMaxi = ADDONSELF.HopeMaxi
local FrameHide = ADDONSELF.FrameHide
local AddTexture = ADDONSELF.AddTexture
local RGB_16 = ADDONSELF.RGB_16

local pt = print

function BG.HistoryUI()
    BG.History = {}

    ------------------下拉框架------------------
    do
        local f = CreateFrame("Frame", nil, BG.MainFrame, "BackdropTemplate")
        f:SetBackdrop({
            bgFile = "Interface/ChatFrame/ChatFrameBackground",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 16,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        f:SetBackdropColor(0, 0, 0, 0.9)
        f:SetSize(270, 380)
        f:SetPoint("TOPRIGHT", BG.MainFrame, "TOPRIGHT", -20, -20)
        f:SetFrameLevel(130)
        f:Hide()
        BG.History.List = f
        f:SetScript("OnMouseUp", function(self)
        end)
        f:SetScript("OnHide", function(self)
            BG.History.GaiMingFrame:Hide()
        end)

        local edit = CreateFrame("EditBox", nil, BG.History.List) -- 输入框
        edit:SetWidth(BG.History.List:GetWidth() - 20)
        edit:SetHeight(BG.History.List:GetHeight())
        edit:SetFontObject(GameTooltipText)
        edit:SetAutoFocus(false)
        edit:SetEnabled(false)
        edit:SetMultiLine(true)
        BG.History.Edit = edit

        local f = CreateFrame("ScrollFrame", nil, BG.History.List, "UIPanelScrollFrameTemplate") -- 滚动
        f:SetWidth(BG.History.List:GetWidth() - 27)
        f:SetHeight(BG.History.List:GetHeight() - 10)
        f:SetPoint("TOPLEFT", BG.History.List, "TOPLEFT", 0, -5)
        f:SetScrollChild(edit)

        local TitleText = BG["HistoryFrame" .. BG.FB1]:CreateFontString() -- 标题
        TitleText:SetPoint("TOP", BG.MainFrame, "TOP", 0, -4);
        TitleText:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
        TitleText:SetTextColor(RGB("00FF00"))
        BG.History.Title = TitleText

        local text = BG.History.List:CreateFontString() -- 提示文字
        text:SetPoint("TOP", BG.History.List, "BOTTOM", 0, 0)
        text:SetFont(BIAOGE_TEXT_FONT, 14, "OUTLINE")
        text:SetText(BG.STC_b1(L["（ALT+左键改名，ALT+右键删除表格）"]))
    end
    ------------------历史表格按键------------------
    do
        local bt = CreateFrame("Button", nil, BG.MainFrame)
        bt:SetSize(140, 30)
        bt:SetPoint("TOPRIGHT", BG.MainFrame, "TOPRIGHT", -30, 4)
        bt:SetNormalFontObject(BG.FontGreen1)
        bt:SetDisabledFontObject(BG.FontDisabled)
        bt:SetHighlightFontObject(BG.FontHilight)
        -- bt:SetText("历史表格（共"..#BiaoGe.HistoryList[BG.FB1].."个）")
        bt:SetFormattedText(L["历史表格（共%d个）"], #BiaoGe.HistoryList[BG.FB1])
        bt:Show()
        BG.History.HistoryButton = bt
        -- 单击触发
        bt:SetScript("OnClick", function(self)
            FrameHide(2)
            if BG.History.SaveButton:GetButtonState() ~= "DISABLED" then
                BG.CreatHistoryListButton(BG.FB1)
            end
            if BG.History.List and BG.History.List:IsVisible() then
                BG.History.List:Hide()
            else
                BG.History.List:Show()
            end
            PlaySound(BG.sound1, "Master")
        end)
    end
    ------------------保存当前表格按键------------------
    do
        local bt = CreateFrame("Button", nil, BG.MainFrame)
        bt:SetSize(70, 30)
        bt:SetPoint("TOPRIGHT", BG.History.HistoryButton, "TOPLEFT", 0, 0)
        bt:SetNormalFontObject(BG.FontGreen1)
        bt:SetDisabledFontObject(BG.FontDisabled)
        bt:SetHighlightFontObject(BG.FontHilight)
        bt:SetText(L["保存表格"])
        bt:Show()
        BG.History.SaveButton = bt

        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -80 * BiaoGe.options.scale, 0)
            GameTooltip:ClearLines()
            GameTooltip:SetText(L["把当前表格保存至历史表格\n但不会保存欠款和关注"])
        end)
        bt:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        -- 单击触发
        bt:SetScript("OnClick", function(self)
            FrameHide(2)
            local DT = tonumber(date("%y%m%d%H%M%S"))
            local DTcn = date(L["%m月%d日%H:%M:%S\n"])
            if not DT then return end
            self:SetEnabled(false) -- 点击后按钮变灰2秒
            C_Timer.After(0.5, function()
                bt:SetEnabled(true)
            end)
            BiaoGe.History[BG.FB1][DT] = {}
            for b = 1, Maxb[BG.FB1] + 2 do
                BiaoGe.History[BG.FB1][DT]["boss" .. b] = {}
                for i = 1, Maxi[BG.FB1] do
                    if BG.Frame[BG.FB1]["boss" .. b]["zhuangbei" .. i] then
                        if BG.Frame[BG.FB1]["boss" .. b]["zhuangbei" .. i]:GetText() ~= "" then
                            BiaoGe.History[BG.FB1][DT]["boss" .. b]["zhuangbei" .. i] = BG.Frame[BG.FB1]["boss" .. b]["zhuangbei" .. i]:GetText()
                        end
                        if BG.Frame[BG.FB1]["boss" .. b]["maijia" .. i]:GetText() ~= "" then
                            BiaoGe.History[BG.FB1][DT]["boss" .. b]["maijia" .. i] = BG.Frame[BG.FB1]["boss" .. b]["maijia" .. i]:GetText()
                            BiaoGe.History[BG.FB1][DT]["boss" .. b]["color" .. i] = { BG.Frame[BG.FB1]["boss" .. b]["maijia" .. i]:GetTextColor() }
                        end
                        if BG.Frame[BG.FB1]["boss" .. b]["jine" .. i]:GetText() ~= "" then
                            BiaoGe.History[BG.FB1][DT]["boss" .. b]["jine" .. i] = BG.Frame[BG.FB1]["boss" .. b]["jine" .. i]:GetText()
                        end
                    end
                end
                if BG.Frame[BG.FB1]["boss" .. b]["time"] then
                    if BG.Frame[BG.FB1]["boss" .. b]["time"]:GetText() ~= "" then
                        BiaoGe.History[BG.FB1][DT]["boss" .. b]["time"] = BG.Frame[BG.FB1]["boss" .. b]["time"]:GetText()
                    end
                end
            end
            local d = { DT, format(L["%s %s %s人 工资:%s"], DTcn, BG.FBcn(BG.FB1), BG.Frame[BG.FB1]["boss" .. Maxb[BG.FB1] + 2]["jine" .. 4]:GetText(), BG.Frame[BG.FB1]["boss" .. Maxb[BG.FB1] + 2]["jine" .. 5]:GetText()) }
            -- local d = {DT, DTcn.." "..BG.FBcn(BG.FB1).." "..BG.Frame[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine"..4]:GetText().."人 工资:"..BG.Frame[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine"..5]:GetText()}
            table.insert(BiaoGe.HistoryList[BG.FB1], 1, d)
            -- BG.History.HistoryButton:SetText("历史表格（共"..#BiaoGe.HistoryList[BG.FB1].."个）")
            BG.History.HistoryButton:SetFormattedText(L["历史表格（共%d个）"], #BiaoGe.HistoryList[BG.FB1])
            BG.CreatHistoryListButton(BG.FB1)

            PlaySoundFile(BG.sound2, "Master")
        end)
    end
    ------------------分享表格按键------------------
    do
        local bt = CreateFrame("Button", nil, BG.MainFrame)
        bt:SetSize(70, 30)
        bt:SetPoint("TOPRIGHT", BG.History.SaveButton, "TOPLEFT", 0, 0)
        bt:SetNormalFontObject(BG.FontGreen1)
        bt:SetDisabledFontObject(BG.FontDisabled)
        bt:SetHighlightFontObject(BG.FontHilight)
        bt:SetText(L["分享表格"])
        bt:Show()
        BG.History.SendButton = bt

        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -80 * BiaoGe.options.scale, 0)
            GameTooltip:ClearLines()
            GameTooltip:SetText(L["把当前表格发给别人，类似发WA那样"])
        end)
        bt:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        bt:SetScript("OnClick", function(self)
            FrameHide(2)

            local text = ""
            local playername, servername = UnitFullName("player")
            playername = playername .. "-" .. servername
            text = "[BiaoGe:" .. playername .. "-"
            if not BG.History.EscButton:IsVisible() then
                text = text .. L["当前表格-"] .. BG.FB1 .. "]" -- [BiaoGe:风行-阿拉希盆地-当前表格-ULD]
            else
                local t = BiaoGe.HistoryList[BG.FB1][BG.History.GaiMingNum][2]
                t = string.gsub(t, "\n", "")
                text = text .. L["历史表格-"] .. BG.FB1 .. "-" .. t .. "]" -- [BiaoGe:风行-阿拉希盆地-历史表格-ULD-04月20日18:20:23 奥杜尔 25人 工资:15000]
            end
            ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
            ChatEdit_InsertLink(text)

            PlaySound(BG.sound1, "Master")
        end)
    end
    ------------------导出表格按键------------------
    do
        BG.frameWenBen = {}
        local f = CreateFrame("Frame", nil, BG.MainFrame, "BasicFrameTemplate")
        f:SetWidth(350)
        f:SetHeight(650)
        f.TitleText:SetText(L["导出表格"])
        f:SetFrameLevel(300)
        f:SetPoint("CENTER")
        f:EnableMouse(true)
        f:SetMovable(true)
        f:SetToplevel(true)
        f:Hide()
        f:SetScript("OnMouseUp", function(self)
            self:StopMovingOrSizing()
        end)
        f:SetScript("OnMouseDown", function(self)
            self:StartMoving()
        end)
        BG.frameWenBen.frame = f

        local edit = CreateFrame("EditBox", nil, BG.frameWenBen.frame)
        edit:SetWidth(BG.frameWenBen.frame:GetWidth() - 27)
        -- edit:SetHeight(BG.frameWenBen.frame:GetHeight())
        edit:SetHeight(1)
        edit:SetAutoFocus(true)
        edit:EnableMouse(true)
        edit:SetTextInsets(10, 10, 10, 10)
        edit:SetMultiLine(true)
        edit:SetFontObject(GameFontNormal)
        edit:HookScript("OnEscapePressed", function()
            BG.frameWenBen.frame:Hide()
        end)
        BG.frameWenBen.edit = edit

        local f = CreateFrame("ScrollFrame", nil, BG.frameWenBen.frame, "UIPanelScrollFrameTemplate")
        f:SetWidth(BG.frameWenBen.frame:GetWidth() - 27)
        f:SetHeight(BG.frameWenBen.frame:GetHeight() - 29)
        f:SetPoint("BOTTOMLEFT", BG.frameWenBen.frame, "BOTTOMLEFT", 0, 2)
        f:SetScrollChild(edit)
        BG.frameWenBen.scroll = f
        -- 创建按键
        local bt = CreateFrame("Button", nil, BG.MainFrame)
        bt:SetSize(70, 30)
        bt:SetPoint("TOPRIGHT", BG.History.SendButton, "TOPLEFT", -5, 0)
        bt:SetNormalFontObject(BG.FontGreen1)
        bt:SetDisabledFontObject(BG.FontDisabled)
        bt:SetHighlightFontObject(BG.FontHilight)
        bt:SetText(L["导出表格"])
        BG.History.DaoChuButton = bt

        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -80 * BiaoGe.options.scale, 0)
            GameTooltip:ClearLines()
            GameTooltip:SetText(L["把表格导出为文本"])
        end)
        bt:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)
        bt:SetScript("OnClick", function(self)
            local FB = BG.FB1
            local Frame
            local text
            if BG["Frame" .. FB]:IsVisible() then
                Frame = BG.Frame
            elseif BG["HistoryFrame" .. FB]:IsVisible() then
                Frame = BG.HistoryFrame
            end
            BG.frameWenBen.frame:Show()
            BG.frameWenBen.edit:SetText("")
            for b = 1, Maxb[FB] + 2 do
                local bossname2 = BG.Boss[FB]["boss" .. b].name2
                local bosscolor = BG.Boss[FB]["boss" .. b].color
                text = "|cff" .. bosscolor .. bossname2 .. RN
                BG.frameWenBen.edit:Insert(text) -- BOSS名字
                for i = 1, Maxi[FB] do
                    if Frame[FB]["boss" .. b]["zhuangbei" .. i] then
                        if Frame[FB]["boss" .. b]["zhuangbei" .. i]:GetText() ~= "" or Frame[FB]["boss" .. b]["maijia" .. i]:GetText() ~= "" or Frame[FB]["boss" .. b]["jine" .. i]:GetText() ~= "" then
                            text = Frame[FB]["boss" .. b]["zhuangbei" .. i]:GetText() .. " " .. RGB_16(Frame[FB]["boss" .. b]["maijia" .. i]) .. " " .. Frame[FB]["boss" .. b]["jine" .. i]:GetText() .. "\n"
                            BG.frameWenBen.edit:Insert(text)
                        end
                    end
                end
                BG.frameWenBen.edit:Insert("\n")
            end
            -- 删掉末尾的两个回车
            local text = BG.frameWenBen.edit:GetText()
            local len = strlen(text)
            text = strsub(text, 1, len - 2)
            BG.frameWenBen.edit:SetText(text)
            BG.frameWenBen.edit:HighlightText()
            -- 设置滚动条到末尾
            C_Timer.After(0.01, function()
                BG.frameWenBen.scroll:SetVerticalScroll(BG.frameWenBen.edit:GetHeight() - BG.frameWenBen.scroll:GetHeight())
            end)
        end)
    end
    ------------------应用表格按键------------------
    do
        local bt = CreateFrame("Button", nil, BG.MainFrame)
        bt:SetSize(70, 30)
        bt:SetPoint("TOPRIGHT", BG.History.DaoChuButton, "TOPLEFT", 0, 0)
        bt:SetNormalFontObject(BG.FontGreen1)
        bt:SetDisabledFontObject(BG.FontDisabled)
        bt:SetHighlightFontObject(BG.FontHilight)
        bt:SetText(L["应用表格"])
        bt:Hide()
        BG.History.YongButton = bt

        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -80 * BiaoGe.options.scale, 0)
            -- GameTooltip:SetOwner(self,"ANCHOR_TOPLEFT",0,-5)
            GameTooltip:ClearLines()
            GameTooltip:SetText(L["把该历史表格复制粘贴到当前表格，这样你可以编辑内容"])
        end)
        bt:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)
        bt:SetScript("OnClick", function(self)
            local FB = BG.FB1
            if not BG.CheckKongBai(FB, Maxb[FB], Maxi[FB]) then
                StaticPopup_Show("YINGYONGBIAOGE")
                return
            end
            for key, value in pairs(BiaoGe.History[FB]) do
                if tonumber(BiaoGe.HistoryList[FB][BG.History.XianShiNum][1]) == tonumber(key) then
                    local DT = BiaoGe.HistoryList[FB][BG.History.XianShiNum][1]
                    local FB = BG.FB1
                    for b = 1, Maxb[FB] + 2 do
                        for i = 1, Maxi[FB] do
                            if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i] then
                                BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:SetText(BiaoGe.History[FB][DT]["boss" .. b]["zhuangbei" .. i] or "")
                                BG.Frame[FB]["boss" .. b]["maijia" .. i]:SetText(BiaoGe.History[FB][DT]["boss" .. b]["maijia" .. i] or "")
                                BG.Frame[FB]["boss" .. b]["maijia" .. i]:SetCursorPosition(0)
                                if BiaoGe.History[FB][DT]["boss" .. b]["color" .. i] then
                                    BG.Frame[FB]["boss" .. b]["maijia" .. i]:SetTextColor(BiaoGe.History[FB][DT]["boss" .. b]["color" .. i][1], BiaoGe.History[FB][DT]["boss" .. b]["color" .. i][2], BiaoGe.History[FB][DT]["boss" .. b]["color" .. i][3])
                                end
                                BG.Frame[FB]["boss" .. b]["jine" .. i]:SetText(BiaoGe.History[FB][DT]["boss" .. b]["jine" .. i] or "")
                                BG.Frame[FB]["boss" .. b]["qiankuan" .. i]:Hide()
                                BG.Frame[FB]["boss" .. b]["guanzhu" .. i]:Hide()
                                BiaoGe[FB]["boss" .. b]["qiankuan" .. i] = nil
                                BiaoGe[FB]["boss" .. b]["guanzhu" .. i] = nil
                            end
                        end
                        if BG.Frame[FB]["boss" .. b]["time"] then
                            BG.Frame[FB]["boss" .. b]["time"]:SetText(BiaoGe.History[FB][DT]["boss" .. b]["time"] or "")
                            BiaoGe[FB]["boss" .. b]["time"] = BiaoGe.History[FB][DT]["boss" .. b]["time"]
                        end
                    end
                end
            end
            BG.FBMainFrame:Show()
            PlaySoundFile(BG.sound2, "Master")
        end)

        StaticPopupDialogs["YINGYONGBIAOGE"] = {
            text = L["确定应用表格？\n你当前的表格将被"] .. BG.STC_r1(L[" 替换 "]),
            button1 = L["是"],
            button2 = L["否"],
            OnCancel = function()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            showAlert = true,
        }
        StaticPopupDialogs["YINGYONGBIAOGE"].OnAccept = function()
            local FB = BG.FB1
            for key, value in pairs(BiaoGe.History[FB]) do
                if tonumber(BiaoGe.HistoryList[FB][BG.History.XianShiNum][1]) == tonumber(key) then
                    local DT = BiaoGe.HistoryList[FB][BG.History.XianShiNum][1]
                    local FB = BG.FB1
                    for b = 1, Maxb[FB] + 2 do
                        for i = 1, Maxi[FB] do
                            if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i] then
                                BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:SetText(BiaoGe.History[FB][DT]["boss" .. b]["zhuangbei" .. i] or "")
                                BG.Frame[FB]["boss" .. b]["maijia" .. i]:SetText(BiaoGe.History[FB][DT]["boss" .. b]["maijia" .. i] or "")
                                BG.Frame[FB]["boss" .. b]["maijia" .. i]:SetCursorPosition(0)
                                if BiaoGe.History[FB][DT]["boss" .. b]["color" .. i] then
                                    BG.Frame[FB]["boss" .. b]["maijia" .. i]:SetTextColor(BiaoGe.History[FB][DT]["boss" .. b]["color" .. i][1], BiaoGe.History[FB][DT]["boss" .. b]["color" .. i][2], BiaoGe.History[FB][DT]["boss" .. b]["color" .. i][3])
                                end
                                BG.Frame[FB]["boss" .. b]["jine" .. i]:SetText(BiaoGe.History[FB][DT]["boss" .. b]["jine" .. i] or "")
                                BG.Frame[FB]["boss" .. b]["qiankuan" .. i]:Hide()
                                BG.Frame[FB]["boss" .. b]["guanzhu" .. i]:Hide()
                                BiaoGe[FB]["boss" .. b]["qiankuan" .. i] = nil
                                BiaoGe[FB]["boss" .. b]["guanzhu" .. i] = nil
                            end
                        end
                        if BG.Frame[FB]["boss" .. b]["time"] then
                            BG.Frame[FB]["boss" .. b]["time"]:SetText(BiaoGe.History[FB][DT]["boss" .. b]["time"] or "")
                            BiaoGe[FB]["boss" .. b]["time"] = BiaoGe.History[FB][DT]["boss" .. b]["time"]
                        end
                    end
                end
            end
            BG.FBMainFrame:Show()
            PlaySoundFile(BG.sound2, "Master")
        end
    end
    ------------------退出历史表格按键------------------
    do
        local bt = CreateFrame("Button", nil, BG.MainFrame)
        bt:SetSize(70, 30)
        bt:SetPoint("TOPRIGHT", BG.History.YongButton, "TOPLEFT", -5, 0)
        bt:SetNormalFontObject(BG.FontFen1)
        bt:SetDisabledFontObject(BG.FontDisabled)
        bt:SetHighlightFontObject(BG.FontHilight)
        bt:SetText(L["返回表格"])
        bt:Hide()
        BG.History.EscButton = bt

        bt:SetScript("OnClick", function(self)
            FrameHide(2)

            if BG.HistoryLastListDs3 then
                BG.HistoryLastListDs3:SetColorTexture(0, 0, 0, 0)
            end

            BG.FBMainFrame:Show()

            PlaySound(BG.sound1, "Master")
        end)
    end

    ------------------改名------------------
    do
        local f = CreateFrame("Frame", nil, BG.History.List, "BackdropTemplate")
        f:SetBackdrop({
            bgFile = "Interface/ChatFrame/ChatFrameBackground",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 16,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        f:SetBackdropColor(0, 0, 0, 0.9)
        f:SetSize(300, 160)
        f:SetPoint("TOPRIGHT", BG.History.List, "TOPLEFT", -2, 0)
        f:SetFrameLevel(130)
        f:Hide()
        BG.History.GaiMingFrame = f
        f:SetScript("OnMouseDown", function(self)
        end)

        local text = f:CreateFontString() -- 标题
        text:SetPoint("TOP", BG.History.GaiMingFrame, "TOP", 0, -20)
        text:SetFontObject(GameFontNormal)
        text:SetTextColor(RGB("00BFFF"))
        BG.History.GaiMingBiaoTi = text

        local edit = CreateFrame("EditBox", nil, BG.History.GaiMingFrame, "InputBoxTemplate") -- 当前名字
        edit:SetSize(170, 20)
        edit:SetPoint("TOPRIGHT", BG.History.GaiMingFrame, "TOPRIGHT", -30, -45)
        edit:SetAutoFocus(false)
        BG.History.GaiMingEdit1 = edit

        local text = f:CreateFontString()
        text:SetPoint("RIGHT", edit, "LEFT", -10, 0)
        text:SetFontObject(GameFontNormal)
        text:SetText(L["当前名字："])

        local edit = CreateFrame("EditBox", nil, BG.History.GaiMingFrame, "InputBoxTemplate") -- 名字改为
        edit:SetSize(170, 20)
        edit:SetPoint("TOPLEFT", BG.History.GaiMingEdit1, "BOTTOMLEFT", 0, -10)
        edit:SetAutoFocus(false)
        BG.History.GaiMingEdit2 = edit

        local text = f:CreateFontString()
        text:SetPoint("RIGHT", edit, "LEFT", -10, 0)
        text:SetFontObject(GameFontNormal) -- 普通设置方法
        text:SetText(L["名字改为："])

        local bt = CreateFrame("Button", nil, BG.History.GaiMingFrame, "UIPanelButtonTemplate")
        bt:SetSize(90, 30)
        bt:SetPoint("BOTTOMLEFT", BG.History.GaiMingFrame, "BOTTOMLEFT", 40, 20)
        bt:SetText(L["确定"])
        bt:SetScript("OnClick", function(self)
            local text = BG.History.GaiMingEdit2:GetText()
            if text ~= "" then
                BiaoGe.HistoryList[BG.FB1][BG.History.GaiMingNum][2] = text
                BG.History.GaiMingFrame:Hide()
                BG.CreatHistoryListButton(BG.FB1)

                PlaySound(BG.sound1, "Master")
            end
        end)

        local bt = CreateFrame("Button", nil, BG.History.GaiMingFrame, "UIPanelButtonTemplate")
        bt:SetSize(90, 30)
        bt:SetPoint("BOTTOMRIGHT", BG.History.GaiMingFrame, "BOTTOMRIGHT", -40, 20)
        bt:SetText(L["取消"])
        bt:SetScript("OnClick", function(self)
            BG.History.GaiMingFrame:Hide()

            PlaySound(BG.sound1, "Master")
        end)
    end
    ------------------装备历史价格框架------------------
    do
        BG.HistoryJineDB = {}

        local f = CreateFrame("Frame", nil, BG.MainFrame, "BackdropTemplate")
        -- f:SetBackdrop({
        -- --     bgFile = "Interface/ChatFrame/ChatFrameBackground",
        --     edgeFile = "Interface/ChatFrame/ChatFrameBackground",
        --     edgeSize = 1
        -- })
        -- -- f:SetBackdropColor(0,0,0,0.5)
        -- f:SetBackdropBorderColor(0,0,0,0.8)
        f:SetSize(300, 330)
        f:SetPoint("BOTTOMRIGHT", BG.MainFrame, "BOTTOMRIGHT", -3, 80)
        f:SetFrameLevel(118)
        f:Hide()
        BG.HistoryJineFrame = f

        f.tex = f:CreateTexture()
        f.tex:SetSize(300, 410)
        f.tex:SetPoint("TOP")
        f.tex:SetTexture("Interface\\Buttons\\WHITE8x8")
        f.tex:SetGradient("VERTICAL", CreateColor(0, 0, 0, 0), CreateColor(0, 0, 0, 1))

        --标题（装备）
        local text = BG.HistoryJineFrame:CreateFontString()
        text:SetPoint("TOP", BG.HistoryJineFrame, "TOP", 3, -10)
        text:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
        BG.HistoryJineFrameBiaoTi = text

        --底下提示文字
        local text = BG.HistoryJineFrame:CreateFontString()
        text:SetPoint("TOP", BG.HistoryJineFrame, "BOTTOM", 0, -2)
        text:SetFont(BIAOGE_TEXT_FONT, 13, "OUTLINE")
        text:SetText(BG.STC_b1(L["（CTRL+点击可通报历史价格）"]))
    end
end

------------------下拉框架的内容------------------
do
    function BG.CreatHistoryListButton(FB)
        -- 先隐藏列表内容
        local fb = { "NAXX", "ULD", "TOC", "ICC" }
        local max
        for key, value in pairs(fb) do
            if max == nil then
                max = #BiaoGe.HistoryList[value]
            end
            if max < #BiaoGe.HistoryList[value] then
                max = #BiaoGe.HistoryList[value]
            end
        end

        for k = 1, max + 1 do
            if BG.History["ListButton" .. k] then
                BG.History["ListButton" .. k]:Hide()
            end
        end

        -- 再重新创建新的列表内容
        local down
        for i = 1, #BiaoGe.HistoryList[FB] do
            local edit = CreateFrame("EditBox", nil, BG.History.Edit)
            local bt = CreateFrame("Button", nil, edit)
            local bt3 = CreateFrame("Button", nil, edit)
            edit:SetSize(230, 40)
            bt:SetSize(230, 40)
            bt3:SetSize(230, 40)
            edit:SetFrameLevel(130)
            bt:SetFrameLevel(128)
            bt3:SetFrameLevel(127)
            if i == 1 then
                bt:SetPoint("TOPLEFT", BG.History.Edit, "TOPLEFT", 10, -10)
                bt3:SetPoint("TOPLEFT", bt, "TOPLEFT", 0, 0)
                edit:SetPoint("TOPLEFT", bt, "TOPLEFT", 0, 0)
            else
                bt:SetPoint("TOPLEFT", down, "BOTTOMLEFT", 0, -10)
                bt3:SetPoint("TOPLEFT", down, "BOTTOMLEFT", 0, -10)
                edit:SetPoint("TOPLEFT", bt, "TOPLEFT", 0, 0)
            end
            edit:SetTextInsets(0, 0, 5, 2)
            edit:SetMultiLine(true)
            edit:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
            edit:SetTextColor(RGB("00BFFF"))
            edit:SetAutoFocus(false)
            edit:SetEnabled(false)
            edit:SetText(" " .. i .. "、" .. BiaoGe.HistoryList[FB][i][2])
            edit:Show()
            bt:Show()
            bt3:Show()
            BG.History["ListButton" .. i] = edit

            local ds = bt:CreateTexture()
            ds:SetAllPoints(bt)
            ds:SetColorTexture(1, 1, 1, 0.1)
            bt:SetNormalTexture(ds)

            local ds3 = bt3:CreateTexture()
            ds3:SetAllPoints(bt)
            bt3:SetNormalTexture(ds3)

            down = bt

            -- 高亮底色和文字
            edit:SetScript("OnEnter", function(self, enter)
                edit:SetTextColor(1, 1, 1, 1)
                ds:SetColorTexture(RGB("00BFFF", 0.5))
            end)
            edit:SetScript("OnLeave", function(self, enter)
                edit:SetTextColor(RGB("00BFFF"))
                ds:SetColorTexture(1, 1, 1, 0.1)
            end)

            -- 单击触发
            edit:SetScript("OnMouseUp", function(self, enter)
                FrameHide(2)
                BG.History.GaiMingNum = i

                if enter == "RightButton" then -- 删除
                    if IsAltKeyDown() then
                        for key, value in pairs(BiaoGe.History[BG.FB1]) do
                            if tonumber(BiaoGe.HistoryList[FB][i][1]) == tonumber(key) then
                                BiaoGe.History[BG.FB1][key] = nil
                            end
                        end
                        table.remove(BiaoGe.HistoryList[FB], i)
                        BG.History.GaiMingFrame:Hide()
                        BG.History.HistoryButton:SetFormattedText(L["历史表格（共%d个）"], #BiaoGe.HistoryList[BG.FB1])
                        BG.CreatHistoryListButton(FB)

                        for b = 1, Maxb[FB] + 2 do
                            for i = 1, Maxi[FB] do
                                if BG.HistoryFrame[FB]["boss" .. b]["zhuangbei" .. i] then
                                    BG.HistoryFrame[FB]["boss" .. b]["zhuangbei" .. i]:SetText("")
                                    BG.HistoryFrame[FB]["boss" .. b]["maijia" .. i]:SetText("")
                                    BG.HistoryFrame[FB]["boss" .. b]["maijia" .. i]:SetTextColor(1, 1, 1)
                                    BG.HistoryFrame[FB]["boss" .. b]["jine" .. i]:SetText("")
                                end
                            end
                            if BG.HistoryFrame[FB]["boss" .. b]["time"] then
                                BG.HistoryFrame[FB]["boss" .. b]["time"]:SetText("")
                            end
                        end
                        BG.History.Title:SetText(L["< 历史表格 > "])

                        PlaySound(BG.sound1, "Master")
                        return
                    end
                end

                if IsAltKeyDown() then -- 改名
                    local t = string.gsub(BiaoGe.HistoryList[FB][i][2], "\n", "")
                    BG.History.GaiMingFrame:Show()
                    BG.History.GaiMingBiaoTi:SetText(format(L["你正在改名第 %s 个表格"], i))
                    BG.History.GaiMingEdit1:SetText(t)
                    BG.History.GaiMingEdit2:SetText("")
                    BG.History.GaiMingEdit2:SetFocus()
                    return
                end

                for key, value in pairs(BiaoGe.History[BG.FB1]) do -- 显示历史表格具体数据
                    if BG.HistoryLastListDs3 then
                        BG.HistoryLastListDs3:SetColorTexture(0, 0, 0, 0)
                    end
                    ds3:SetColorTexture(RGB("FFFF00", 0.5))
                    BG.HistoryLastListDs3 = ds3

                    if tonumber(BiaoGe.HistoryList[FB][i][1]) == tonumber(key) then
                        local DT = BiaoGe.HistoryList[FB][i][1]
                        local FB = BG.FB1
                        for b = 1, Maxb[FB] + 2 do
                            for i = 1, Maxi[FB] do
                                if BG.HistoryFrame[FB]["boss" .. b]["zhuangbei" .. i] then
                                    BG.HistoryFrame[FB]["boss" .. b]["zhuangbei" .. i]:SetText(BiaoGe.History[FB][DT]["boss" .. b]["zhuangbei" .. i] or "")
                                    BG.HistoryFrame[FB]["boss" .. b]["maijia" .. i]:SetText(BiaoGe.History[FB][DT]["boss" .. b]["maijia" .. i] or "")
                                    BG.HistoryFrame[FB]["boss" .. b]["maijia" .. i]:SetCursorPosition(0)
                                    if BiaoGe.History[FB][DT]["boss" .. b]["color" .. i] then
                                        BG.HistoryFrame[FB]["boss" .. b]["maijia" .. i]:SetTextColor(BiaoGe.History[FB][DT]["boss" .. b]["color" .. i][1], BiaoGe.History[FB][DT]["boss" .. b]["color" .. i][2], BiaoGe.History[FB][DT]["boss" .. b]["color" .. i][3])
                                    end
                                    BG.HistoryFrame[FB]["boss" .. b]["jine" .. i]:SetText(BiaoGe.History[FB][DT]["boss" .. b]["jine" .. i] or "")
                                end
                            end
                            if BG.HistoryFrame[FB]["boss" .. b]["time"] then
                                BG.HistoryFrame[FB]["boss" .. b]["time"]:SetText(BiaoGe.History[FB][DT]["boss" .. b]["time"] or "")
                            end
                        end
                    end
                end
                BG.HistoryMainFrame:Show()

                BG.History.Title:SetParent(BG["HistoryFrame" .. FB])
                BG.History.Title:SetText(L["< 历史表格 > "] .. " " .. i)
                BG.History.XianShiNum = i

                PlaySound(BG.sound1, "Master")
            end)
        end
    end
end

------------------装备历史价格------------------
do
    function BG.HistoryJine(FB, itemID, dangqian, jine) -- dangqian：用来确定是否显示当前鼠标悬停的装备价格
        BG.HistoryJineFrame:Hide()
        if BG["HistoryJineFrameDB1"] then
            for i = 1, BG.HistoryJineFrameDBMax do
                BG["HistoryJineFrameDB" .. i]:Hide()
            end
            BG.HistoryJineFrame:Hide()
        end

        if itemID == 47242 then return end
        local maxCount
        if dangqian then
            maxCount = 13
        else
            maxCount = 14
        end
        local db1 = {}
        for key, value in pairs(BiaoGe.History[FB]) do
            for b = 1, Maxb[FB] do
                for i = 1, Maxi[FB] do
                    local zhuangbei = BiaoGe.History[FB][key]["boss" .. b]["zhuangbei" .. i]
                    if zhuangbei then
                        local HitemID = GetItemInfoInstant(zhuangbei)
                        if HitemID then
                            if HitemID == itemID and tonumber(BiaoGe.History[FB][key]["boss" .. b]["jine" .. i]) then
                                local m = BiaoGe.History[FB][key]["boss" .. b]["maijia" .. i] or ""
                                local c = BiaoGe.History[FB][key]["boss" .. b]["color" .. i] or { 1, 1, 1 }
                                local j = BiaoGe.History[FB][key]["boss" .. b]["jine" .. i]
                                local a = { tonumber(key), zhuangbei, m, c, tonumber(j) }
                                table.insert(db1, a)
                            end
                        end
                    end
                end
            end
        end
        if Size(db1) == 0 then
            BG.HistoryJineDB = {}
            return
        end

        local db = {}      -- 1日期、2装备、3买家、4买家颜色、5金额

        for t = 1, #db1 do -- 把表格按日期近远排序
            local maxDay
            local num
            for i = 1, #db1 do
                if maxDay == nil then
                    maxDay = db1[i][1]
                    num = i
                end
                if maxDay < db1[i][1] then
                    maxDay = db1[i][1]
                    num = i
                end
            end
            table.insert(db, db1[num])
            table.remove(db1, num)
            if Size(db) >= maxCount then --限定最大数量
                break
            end
        end
        if dangqian then
            if not tonumber(jine) or tonumber(jine) == 0 then
                jine = 0
            end
            local a = { 0, "", "", { 1, 1, 1 }, tonumber(jine) }
            table.insert(db, 1, a)
        end
        local maxJine -- 找到表格里最大的金额
        for i = 1, #db do
            if maxJine == nil then
                maxJine = db[i][5]
            end
            if maxJine < db[i][5] then
                maxJine = db[i][5]
            end
        end
        BG.HistoryJineFrame:Show()
        local name, link, quality, level, _, _, _, _, _, Texture, _, typeID = GetItemInfo(itemID)
        if not link then return end
        BG.HistoryJineFrameBiaoTi:SetText(format(L["历史价格：%s%s(%s)"], (AddTexture(Texture) .. link), "|cff" .. "9370DB", level or ""))

        local down
        -- local color = {"00FFFF","00FFCC","00FF99","00FF66","00FF33","00FF00","00FF33","00FF66","00FF99","00FFCC"}   -- 绿色渐变
        -- local color = {"6600FF","3300FF","6633FF","3300CC","0033CC","3366FF","0033FF","0066FF","0099FF","00CCFF"}   -- 蓝色渐变
        local color = { (dangqian and "00BFFF" or "33FFCC"), "00FFCC", "00FF99", "00FF66", "00FF33", "33FF66", "00CC33", "33CC00", "66FF33", "33FF00", "66FF00", "99FF00", "CCFF00", "CCFF33", "99CC00" } -- 蓝绿渐变
        for i = 1, #db do
            local f = CreateFrame("Frame", nil, BG.HistoryJineFrame, "BackdropTemplate")
            f:SetBackdrop({
                bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            })
            f:SetBackdropColor(RGB(color[i], 1))
            if i == 1 then
                f:SetPoint("TOPRIGHT", BG.HistoryJineFrame, "TOPRIGHT", -80, -40)
            else
                f:SetPoint("TOPRIGHT", down, "BOTTOMRIGHT", 0, -8)
            end
            local widthPercent = db[i][5] / maxJine
            local width
            if widthPercent == 0 then
                width = 1
            else
                width = (BG.HistoryJineFrame:GetWidth() - 160) * widthPercent
            end
            f:SetSize(width, 14)
            down = f
            BG["HistoryJineFrameDB" .. i] = f
            BG.HistoryJineFrameDBMax = i

            local text = f:CreateFontString() -- 日期
            text:SetPoint("LEFT", f, "RIGHT", 3, 0)
            text:SetFont(BIAOGE_TEXT_FONT, 12, "OUTLINE")
            text:SetTextColor(RGB(color[i]))
            if dangqian and i == 1 then
                text:SetText(L["当前"])
            else
                local a = strsub(db[i][1], 3, 4)
                local b = strsub(db[i][1], 5, 6)
                local t = a .. L["月"] .. b .. L["日"]
                text:SetText(t)
            end

            local text = f:CreateFontString() -- 金额
            text:SetPoint("RIGHT", f, "LEFT", -3, 0)
            text:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
            text:SetTextColor(RGB(color[i]))
            local t = db[i][5]
            text:SetText(t)
            local textjine = text

            local text = f:CreateFontString() -- 买家
            text:SetPoint("CENTER", f, "CENTER", 0, 1)
            text:SetFont(BIAOGE_TEXT_FONT, 14, "OUTLINE")
            text:SetTextColor(db[i][4][1], db[i][4][2], db[i][4][3])
            local t = db[i][3]
            text:SetText(t)
            if IsControlKeyDown() then
                text:Show()
            else
                text:Hide()
            end
        end
        BG.HistoryJineDB.DB = db
        BG.HistoryJineDB.Link = link
    end
end

-- 按住CTRL时显示买家
local frame = CreateFrame("Frame")
frame:RegisterEvent("MODIFIER_STATE_CHANGED")
frame:SetScript("OnEvent", function(self, event, enter)
    if (enter == "LCTRL" or enter == "RCTRL") and BG.HistoryJineFrame:IsVisible() then
        BG.HistoryJine(unpack(BG.HistoryMOD))
    end
end)
