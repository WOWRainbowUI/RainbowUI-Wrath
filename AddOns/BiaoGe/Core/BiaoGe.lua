local AddonName, ADDONSELF = ...

local LibBG = ADDONSELF.LibBG
local L = ADDONSELF.L

local RR = ADDONSELF.RR
local NN = ADDONSELF.NN
local RN = ADDONSELF.RN
local Size = ADDONSELF.Size
local RGB = ADDONSELF.RGB
local RGB_16 = ADDONSELF.RGB_16
local GetClassRGB = ADDONSELF.GetClassRGB
local SetClassCFF = ADDONSELF.SetClassCFF
local GetText_T = ADDONSELF.GetText_T
local FrameDongHua = ADDONSELF.FrameDongHua
local FrameHide = ADDONSELF.FrameHide
local AddTexture = ADDONSELF.AddTexture
local GetItemID = ADDONSELF.GetItemID

local Width = ADDONSELF.Width
local Height = ADDONSELF.Height
local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi
local HopeMaxn = ADDONSELF.HopeMaxn
local HopeMaxb = ADDONSELF.HopeMaxb
local HopeMaxi = ADDONSELF.HopeMaxi

local pt = print
local RealmId = GetRealmID()
local player = UnitName("player")

local function BiaoGeUI()
    ------------------主界面------------------
    do
        BG.MainFrame = CreateFrame("Frame", "BG.MainFrame", UIParent, "BasicFrameTemplate")
        BG.MainFrame:SetPoint("CENTER")
        BG.MainFrame:SetFrameLevel(100)
        BG.MainFrame:SetMovable(true)
        BG.MainFrame:SetToplevel(true)
        BG.MainFrame:SetScript("OnMouseUp", function(self)
            self:StopMovingOrSizing()
        end)
        BG.MainFrame:SetScript("OnMouseDown", function(self)
            FrameHide(0)
            LibBG:CloseDropDownMenus()
            BG.ClearFocus()
            self:StartMoving()
        end)
        BG.MainFrame:SetScript("OnHide", function(self)
            FrameHide(0)
            BG.copy1 = nil
            BG.copy2 = nil
            BG.FilterClassItemMainFrame:Hide()
            if BG.copyButton then
                BG.copyButton:Hide()
            end
        end)
        BG.MainFrame:SetScript("OnShow", function(self)
            if not BiaoGe.options.SearchHistory.firstOpenMainFrame then
                local name = "scale"
                local ui = UIParent:GetScale()
                if tonumber(ui) >= 0.85 then
                    BG.options[name .. "reset"] = 0.7
                elseif tonumber(ui) >= 0.75 then
                    BG.options[name .. "reset"] = 0.8
                elseif tonumber(ui) >= 0.65 then
                    BG.options[name .. "reset"] = 0.9
                else
                    BG.options[name .. "reset"] = 1
                end

                if BiaoGe.Scale then
                    BiaoGe.options[name] = BiaoGe.Scale
                else
                    BiaoGe.options[name] = BG.options[name .. "reset"]
                end
                BG.MainFrame:SetScale(BiaoGe.options[name])
                BG.ReceiveMainFrame:SetScale(tonumber(BiaoGe.options[name]) * 0.95)
                if BG.FBCDFrame then
                    BG.FBCDFrame:SetScale(BiaoGe.options[name])
                end

                if BG.options["buttonscale"] then
                    BG.options["buttonscale"].edit:SetText(BiaoGe.options[name])
                    BG.options["buttonscale"]:SetValue(BiaoGe.options[name])
                end

                BiaoGe.options.SearchHistory.firstOpenMainFrame = true
            end
        end)
        tinsert(UISpecialFrames, "BG.MainFrame") -- 按ESC可关闭插件

        local f = CreateFrame("Frame", nil, BG.MainFrame)
        f:SetPoint("TOP", BG.MainFrame, "TOP", 0, 4)
        f:SetSize(200, 30)
        f:SetFrameLevel(105)
        local TitleText = f:CreateFontString()
        TitleText:SetAllPoints()
        TitleText:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
        TitleText:SetText("|cff" .. "00BFFF" .. L["< BiaoGe > 金 团 表 格"])
        BG.Title = TitleText

        -- 说明书
        local frame = CreateFrame("Frame", nil, BG.MainFrame)
        frame:SetPoint("TOPLEFT", BG.MainFrame, "TOPLEFT", 5, 4)
        frame:SetHitRectInsets(0, 0, 0, 0)
        local fontString = frame:CreateFontString()
        fontString:SetPoint("CENTER")
        fontString:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
        fontString:SetJustifyH("LEFT")
        fontString:SetText(L["<说明书与更新记录> "] .. BG.STC_g1(BG.ver))
        frame:SetSize(fontString:GetStringWidth(), 30)
        BG.ShuoMingShu = frame
        BG.ShuoMingShuText = fontString

        local function OnEnter(self)
            self.OnEnter = true
            GameTooltip:SetOwner(self, "ANCHOR_NONE")
            GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
            GameTooltip:ClearLines()
            if IsAltKeyDown() then
                GameTooltip:SetText(BG.updateText)
            else
                GameTooltip:SetText(BG.instructionsText)
            end
        end
        frame:SetScript("OnEnter", OnEnter)
        frame:SetScript("OnLeave", function(self)
            self.OnEnter = false
            GameTooltip:Hide()
        end)
        local f = CreateFrame("Frame")
        f:RegisterEvent("MODIFIER_STATE_CHANGED")
        f:SetScript("OnEvent", function(self, event, enter)
            if (enter == "LALT" or enter == "RALT") and frame.OnEnter then
                OnEnter(frame)
            end
        end)

        -- 副本选择初始化
        -- FB1 是UI当前选择的副本
        -- FB2 是玩家当前所处的副本
        if BiaoGe.FB then
            local yes
            for k, FB in pairs(BG.FBtable) do
                if BiaoGe.FB == FB then
                    BG.FB1 = BiaoGe.FB
                    yes = true
                    break
                end
            end
            if not yes then
                BiaoGe.FB = BG.FB1
            end
        else
            BiaoGe.FB = BG.FB1
        end
        BG.MainFrame:SetHeight(Height[BG.FB1])
        BG.MainFrame:SetWidth(Width[BG.FB1])
    end
    ------------------接收表格主界面------------------
    do
        BG.ReceiveMainFrame = CreateFrame("Frame", "BG.ReceiveFrame", UIParent, "BackdropTemplate")
        BG.ReceiveMainFrame:SetBackdrop({
            bgFile = "Interface/ChatFrame/ChatFrameBackground",
            edgeFile = "Interface/ChatFrame/ChatFrameBackground",
            edgeSize = 2
        })
        BG.ReceiveMainFrame:SetBackdropColor(0, 0, 0, 0.9)
        BG.ReceiveMainFrame:SetBackdropBorderColor(RGB("00BFFF"))
        BG.ReceiveMainFrame:SetPoint("CENTER")
        BG.ReceiveMainFrame:SetFrameLevel(100)
        BG.ReceiveMainFrame:SetMovable(true)
        BG.ReceiveMainFrame:SetToplevel(true)
        BG.ReceiveMainFrame:SetScript("OnMouseUp", function(self)
            self:StopMovingOrSizing()
        end)
        BG.ReceiveMainFrame:SetScript("OnMouseDown", function(self)
            FrameHide(0)
            self:StartMoving()
        end)
        tinsert(UISpecialFrames, "BG.ReceiveFrame") -- 按ESC可关闭插件

        BG.ReceiveMainFrame.CloseButton = CreateFrame("Button", nil, BG.ReceiveMainFrame, "UIPanelCloseButton")
        BG.ReceiveMainFrame.CloseButton:SetPoint("TOPRIGHT", BG.ReceiveMainFrame, "TOPRIGHT", 0, 0)
        BG.ReceiveMainFrame.CloseButton:SetSize(40, 40)

        local TitleText = BG.ReceiveMainFrame:CreateFontString()
        TitleText:SetPoint("TOP", BG.ReceiveMainFrame, "TOP", 0, -15)
        TitleText:SetFont(BIAOGE_TEXT_FONT, 16, "OUTLINE")
        BG.ReceiveMainFrameTitle = TitleText

        local bt = CreateFrame("Button", nil, BG.ReceiveMainFrame, "UIPanelButtonTemplate")
        bt:SetSize(120, 30)
        bt:SetPoint("BOTTOM", BG.ReceiveMainFrame, "BOTTOM", 0, 30)
        bt:SetText(L["保存至历史表格"])
        -- 单击触发
        bt:SetScript("OnClick", function(self)
            local FB = BG.ReceiveBiaoGe.FB
            local DT = BG.ReceiveBiaoGe.DT
            local BiaoTi = BG.ReceiveBiaoGe.BiaoTi
            for key, value in pairs(BiaoGe.History[FB]) do
                if tonumber(DT) == key then
                    BG.ReceiveMainFrametext:SetText(BG.STC_r1(L["该表格已在你历史表格里"]))
                    return
                end
            end

            BiaoGe.History[FB][DT] = {}
            for b = 1, Maxb[FB] + 2 do
                BiaoGe.History[FB][DT]["boss" .. b] = {}
                for i = 1, Maxi[FB] do
                    if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i] then
                        BiaoGe.History[FB][DT]["boss" .. b]["zhuangbei" .. i] = BG.ReceiveBiaoGe["boss" .. b]
                            ["zhuangbei" .. i]
                        BiaoGe.History[FB][DT]["boss" .. b]["maijia" .. i] = BG.ReceiveBiaoGe["boss" .. b]["maijia" .. i]
                        BiaoGe.History[FB][DT]["boss" .. b]["color" .. i] = { BG.ReceiveBiaoGe["boss" .. b]["color" .. i]
                            [1], BG.ReceiveBiaoGe["boss" .. b]["color" .. i][2],
                            BG.ReceiveBiaoGe["boss" .. b]["color" .. i][3] }
                        BiaoGe.History[FB][DT]["boss" .. b]["jine" .. i] = BG.ReceiveBiaoGe["boss" .. b]["jine" .. i]
                    end
                end
                if BG.Frame[FB]["boss" .. b]["time"] then
                    BiaoGe.History[FB][DT]["boss" .. b]["time"] = BG.ReceiveBiaoGe["boss" .. b]["time"]
                end
            end
            local d = { DT, BiaoTi }
            table.insert(BiaoGe.HistoryList[FB], 1, d)
            BG.History.HistoryButton:SetFormattedText(L["历史表格（共%d个）"], #BiaoGe.HistoryList[FB])
            BG.CreatHistoryListButton(FB)
            BG.ReceiveMainFrametext:SetText(BG.STC_b1(L["已保存至历史表格1"]))

            PlaySoundFile(BG.sound2, "Master")
        end)

        local text = BG.ReceiveMainFrame:CreateFontString()
        text:SetPoint("LEFT", bt, "RIGHT", 10, 0)
        text:SetFont(BIAOGE_TEXT_FONT, 16, "OUTLINE")
        BG.ReceiveMainFrametext = text

        -- 二级
        for i, FB in ipairs(BG.FBtable) do
            BG["ReceiveFrame" .. FB] = CreateFrame("Frame", "BG.ReceiveFrame" .. FB, BG.ReceiveMainFrame)
            BG["ReceiveFrame" .. FB]:Hide()
        end
    end
    ------------------二级Frame------------------
    do
        BG.FBMainFrame = CreateFrame("Frame", "BG.FBMainFrame", BG.MainFrame) -- 当前表格
        do
            BG.FBMainFrame:Hide()
            for i, FB in ipairs(BG.FBtable) do
                BG["Frame" .. FB] = CreateFrame("Frame", "BG.Frame" .. FB, BG.FBMainFrame)
                BG["Frame" .. FB]:Hide()
            end
            BG.FBMainFrame:SetScript("OnShow", function(self)
                local FB = BG.FB1
                for i, FB in ipairs(BG.FBtable) do
                    BG["Frame" .. FB]:Hide()
                end
                BG["Frame" .. FB]:Show()
                BiaoGe.lastFrame = "FB"

                BG.HistoryMainFrame:Hide()
                BG.Title:Show()
                BG.History.List:Hide()

                BG.History.HistoryButton:SetParent(self)
                BG.History.SaveButton:SetParent(self)
                BG.History.SendButton:SetParent(self)
                BG.History.DaoChuButton:SetParent(self)
                BG.History.HistoryButton:SetEnabled(true)
                BG.History.SaveButton:SetEnabled(true)
                BG.History.SendButton:SetEnabled(true)
                BG.History.DaoChuButton:SetEnabled(true)

                BG.ButtonZhangDan:SetParent(self)
                BG.ButtonLiuPai:SetParent(self)
                BG.ButtonXiaoFei:SetParent(self)
                BG.ButtonYongShi:SetParent(self)
                BG.ButtonWCL:SetParent(self)
                BG.ButtonQianKuan:SetParent(self)

                BG.ButtonZhangDan:SetEnabled(true)
                BG.ButtonLiuPai:SetEnabled(true)
                BG.ButtonXiaoFei:SetEnabled(true)
                BG.ButtonYongShi:SetEnabled(true)
                BG.ButtonWCL:SetEnabled(true)
                BG.ButtonQianKuan:SetEnabled(true)

                BG.TabButtonsFB:Show()
                for i, FB in ipairs(BG.FBtable) do
                    BG["Button" .. FB]:SetEnabled(true)
                end
                BG["Button" .. BG.FB1]:SetEnabled(false)

                BG.ButtonQingKong:SetParent(self)
                BG.ButtonQingKong:SetEnabled(true)
                if not BG.IsVanilla() then
                    BG.NanDuDropDown.DropDown:Show()
                    LibBG:UIDropDownMenu_EnableDropDown(BG.NanDuDropDown.DropDown)
                end

                BG.FilterClassItemMainFrame.Buttons2:SetParent(self)
                BG.FilterClassItemMainFrame:Hide()
                BG.FilterClassItemMainFrame.Buttons2:ClearAllPoints()
                BG.FilterClassItemMainFrame.Buttons2:SetPoint("BOTTOMLEFT", BG.MainFrame, "BOTTOMLEFT", 410, 35)
            end)
        end

        BG.HopeMainFrame = CreateFrame("Frame", "BG.HopeMainFrame", BG.MainFrame) -- 心愿清单
        do
            BG.HopeMainFrame:Hide()
            for i, FB in ipairs(BG.FBtable) do
                BG["HopeFrame" .. FB] = CreateFrame("Frame", "BG.HopeFrame" .. FB, BG.HopeMainFrame)
                BG["HopeFrame" .. FB]:Hide()
            end
            BG.BackBiaoGe(BG.HopeMainFrame)
            BG.HopeMainFrame:SetScript("OnShow", function(self)
                local FB = BG.FB1
                FrameHide(0)
                for i, FB in ipairs(BG.FBtable) do
                    BG["HopeFrame" .. FB]:Hide()
                end
                BG["HopeFrame" .. FB]:Show()
                BiaoGe.lastFrame = "Hope"

                BG.HistoryMainFrame:Hide()
                BG.Title:Show()
                BG.History.List:Hide()

                BG.TabButtonsFB:Show()
                for i, FB in ipairs(BG.FBtable) do
                    BG["Button" .. FB]:SetEnabled(true)
                end
                BG["Button" .. BG.FB1]:SetEnabled(false)

                if not BG.IsVanilla() then
                    BG.NanDuDropDown.DropDown:Show()
                    LibBG:UIDropDownMenu_EnableDropDown(BG.NanDuDropDown.DropDown)
                end

                BG.FilterClassItemMainFrame.Buttons2:SetParent(self)
                BG.FilterClassItemMainFrame:Hide()
                BG.FilterClassItemMainFrame.Buttons2:ClearAllPoints()
                BG.FilterClassItemMainFrame.Buttons2:SetPoint("BOTTOMLEFT", BG.MainFrame, "BOTTOMLEFT", 410, 35)
            end)
            -- 左下角文字介绍
            do
                local t = BG.HopeMainFrame:CreateFontString()
                t:SetPoint("BOTTOMLEFT", BG.MainFrame, "BOTTOMLEFT", 35, 75)
                t:SetFont(BIAOGE_TEXT_FONT, 20, "OUTLINE")
                t:SetTextColor(RGB(BG.g1))
                t:SetText(L["心愿清单："])
                local tt = t
                local t = BG.HopeMainFrame:CreateFontString()
                t:SetPoint("LEFT", tt, "RIGHT", 0, 0)
                t:SetFont(BIAOGE_TEXT_FONT, 14, "OUTLINE")
                t:SetTextColor(RGB(BG.g2))
                t:SetText(L["你可以设置一些装备，这些装备只要掉落就会提醒，并且自动关注团长拍卖"])
            end
        end

        BG.ItemLibMainFrame = CreateFrame("Frame", "BG.ItemLibMainFrame", BG.MainFrame) -- 装备库
        do
            BG.ItemLibMainFrame:Hide()
            BG.BackBiaoGe(BG.ItemLibMainFrame)
            BG.ItemLibMainFrame:SetScript("OnShow", function(self)
                local FB = BG.FB1
                FrameHide(0)
                BiaoGe.lastFrame = "ItemLib"

                BG.HistoryMainFrame:Hide()
                BG.Title:Show()
                BG.History.List:Hide()

                BG.TabButtonsFB:Show()
                for i, FB in ipairs(BG.FBtable) do
                    BG["Button" .. FB]:SetEnabled(true)
                end
                BG["Button" .. BG.FB1]:SetEnabled(false)

                if not BG.IsVanilla() then
                    BG.NanDuDropDown.DropDown:Hide()
                end

                BG.FilterClassItemMainFrame.Buttons2:SetParent(self)
                BG.FilterClassItemMainFrame:Hide()
                BG.FilterClassItemMainFrame.Buttons2:ClearAllPoints()
                BG.FilterClassItemMainFrame.Buttons2:SetPoint("TOP", BG.ItemLibMainFrame[1]["invtypeFrame"], "BOTTOM", 0, -10)
            end)

            -- 左下角文字介绍
            do
                local t = BG.ItemLibMainFrame:CreateFontString()
                t:SetPoint("BOTTOMLEFT", BG.MainFrame, "BOTTOMLEFT", 35, 45)
                t:SetFont(BIAOGE_TEXT_FONT, 20, "OUTLINE")
                t:SetTextColor(RGB(BG.g1))
                t:SetText(L["装备库："])
                local tt = t
                local t = BG.ItemLibMainFrame:CreateFontString()
                t:SetPoint("LEFT", tt, "RIGHT", 0, 0)
                t:SetFont(BIAOGE_TEXT_FONT, 14, "OUTLINE")
                t:SetTextColor(RGB(BG.g2))
                t:SetText(L["查看所有适合你的装备"])
                local tt = t
                local t = BG.ItemLibMainFrame:CreateFontString()
                t:SetPoint("LEFT", tt, "RIGHT", 0, 0)
                t:SetFont(BIAOGE_TEXT_FONT, 13, "OUTLINE")
                -- t:SetTextColor(RGB(BG.dis))
                t:SetText(L["（SHIFT+左键发送装备，ALT+左键设为心愿装备。部位按钮支持使用滚轮切换）"])
            end
        end

        BG.DuiZhangMainFrame = CreateFrame("Frame", "BG.DuiZhangMainFrame", BG.MainFrame) -- 对账
        do
            BG.DuiZhangMainFrame:Hide()
            for i, FB in ipairs(BG.FBtable) do
                BG["DuiZhangFrame" .. FB] = CreateFrame("Frame", "BG.DuiZhangFrame" .. FB, BG.DuiZhangMainFrame)
                BG["DuiZhangFrame" .. FB]:Hide()
            end
            BG.BackBiaoGe(BG.DuiZhangMainFrame)
            BG.DuiZhangMainFrame:SetScript("OnShow", function(self)
                local FB = BG.FB1
                FrameHide(0)
                for i, FB in ipairs(BG.FBtable) do
                    BG["DuiZhangFrame" .. FB]:Hide()
                end
                BG["DuiZhangFrame" .. FB]:Show()
                if BG.lastduizhangNum then
                    BG.DuiZhangSet(BG.lastduizhangNum)
                end
                BiaoGe.lastFrame = "DuiZhang"

                BG.HistoryMainFrame:Hide()
                BG.Title:Show()
                BG.History.List:Hide()

                BG.TabButtonsFB:Show()
                for i, FB in ipairs(BG.FBtable) do
                    BG["Button" .. FB]:SetEnabled(true)
                end
                BG["Button" .. BG.FB1]:SetEnabled(false)

                if not BG.IsVanilla() then
                    BG.NanDuDropDown.DropDown:Hide()
                end
            end)
            -- 左下角文字介绍
            do
                local t = BG.DuiZhangMainFrame:CreateFontString()
                t:SetPoint("BOTTOMLEFT", BG.MainFrame, "BOTTOMLEFT", 35, 45)
                t:SetFont(BIAOGE_TEXT_FONT, 20, "OUTLINE")
                t:SetTextColor(RGB(BG.g1))
                t:SetText(L["对账"])
            end
        end

        BG.YYMainFrame = CreateFrame("Frame", "BG.YYMainFrame", BG.MainFrame) -- YY评价
        do
            BG.YYMainFrame:Hide()
            BG.BackBiaoGe(BG.YYMainFrame)
            BG.YYMainFrame:SetScript("OnShow", function(self)
                local FB = BG.FB1
                FrameHide(0)
                BiaoGe.lastFrame = "YY"

                BG.HistoryMainFrame:Hide()
                BG.Title:Show()
                BG.History.List:Hide()

                BG.TabButtonsFB:Hide()

                if not BG.IsVanilla() then
                    BG.NanDuDropDown.DropDown:Hide()
                end
            end)
            -- 左下角文字介绍
            do
                local t = BG.YYMainFrame:CreateFontString()
                t:SetPoint("BOTTOMLEFT", BG.MainFrame, "BOTTOMLEFT", 35, 45)
                t:SetFont(BIAOGE_TEXT_FONT, 20, "OUTLINE")
                t:SetTextColor(RGB(BG.g1))
                t:SetText(L["YY评价"])
            end
        end

        if not BG.IsVanilla() then
            BG.BossMainFrame = CreateFrame("Frame", "BG.HopeMainFrame", BG.MainFrame) -- 团本攻略
            do
                BG.BossMainFrame:Hide()
                for i, FB in ipairs(BG.FBtable) do
                    BG["BossFrame" .. FB] = CreateFrame("Frame", "BG.BossFrame" .. FB, BG.BossMainFrame)
                    BG["BossFrame" .. FB]:Hide()
                end
                BG.BackBiaoGe(BG.BossMainFrame)
                BG.BossMainFrame:SetScript("OnShow", function(self)
                    local FB = BG.FB1
                    FrameHide(0)
                    for i, FB in ipairs(BG.FBtable) do
                        BG["BossFrame" .. FB]:Hide()
                    end
                    BG["BossFrame" .. FB]:Show()
                    BiaoGe.lastFrame = "BOSS"

                    BG.HistoryMainFrame:Hide()
                    BG.Title:Show()
                    BG.History.List:Hide()

                    BG.TabButtonsFB:Show()
                    for i, FB in ipairs(BG.FBtable) do
                        BG["Button" .. FB]:SetEnabled(true)
                    end
                    BG["Button" .. BG.FB1]:SetEnabled(false)

                    if not BG.IsVanilla() then
                        BG.NanDuDropDown.DropDown:Hide()
                    end
                end)
                -- 左下角文字介绍
                do
                    local t = BG.BossMainFrame:CreateFontString()
                    t:SetPoint("BOTTOMLEFT", BG.MainFrame, "BOTTOMLEFT", 35, 45)
                    t:SetFont(BIAOGE_TEXT_FONT, 20, "OUTLINE")
                    t:SetTextColor(RGB(BG.g1))
                    t:SetText(L["团本攻略"])
                end
            end
        end

        BG.HistoryMainFrame = CreateFrame("Frame", "BG.HistoryMainFrame", BG.MainFrame) -- 历史表格
        do
            BG.HistoryMainFrame:Hide()
            for i, FB in ipairs(BG.FBtable) do
                BG["HistoryFrame" .. FB] = CreateFrame("Frame", "BG.HistoryFrame" .. FB, BG.HistoryMainFrame)
                BG["HistoryFrame" .. FB]:Hide()
            end
            BG.HistoryMainFrame:SetScript("OnShow", function(self)
                local FB = BG.FB1
                for i, FB in ipairs(BG.FBtable) do
                    BG["HistoryFrame" .. FB]:Hide()
                end
                BG["HistoryFrame" .. FB]:Show()
                BG.FBMainFrame:Hide()

                BG.Title:Hide()
                BG.History.SaveButton:SetEnabled(false)

                BG.History.HistoryButton:SetParent(self)
                BG.History.SaveButton:SetParent(self)
                BG.History.SendButton:SetParent(self)
                BG.History.DaoChuButton:SetParent(self)

                BG.ButtonZhangDan:SetParent(self)
                BG.ButtonLiuPai:SetParent(self)
                BG.ButtonXiaoFei:SetParent(self)
                BG.ButtonYongShi:SetParent(self)
                BG.ButtonWCL:SetParent(self)
                BG.ButtonQianKuan:SetParent(self)

                BG.ButtonZhangDan:SetEnabled(false)
                BG.ButtonLiuPai:SetEnabled(false)
                BG.ButtonXiaoFei:SetEnabled(false)
                BG.ButtonYongShi:SetEnabled(false)
                BG.ButtonWCL:SetEnabled(false)
                BG.ButtonQianKuan:SetEnabled(false)

                for i, FB in ipairs(BG.FBtable) do
                    BG["Button" .. FB]:SetEnabled(false)
                end

                BG.ButtonQingKong:SetParent(self)
                BG.ButtonQingKong:SetEnabled(false)
                if not BG.IsVanilla() then
                    LibBG:UIDropDownMenu_DisableDropDown(BG.NanDuDropDown.DropDown)
                end

                BG.FilterClassItemMainFrame.Buttons2:SetParent(self)
                BG.FilterClassItemMainFrame:Hide()
            end)
        end
    end
    ------------------生成各副本UI------------------
    do
        for k, FB in pairs(BG.FBtable) do
            BG.CreateFBUI(FB)
            BG.HopeUI(FB)
        end
        BG.CreateBossModel()

        --通报UI
        BG.ZhangDanUI()
        BG.LiuPaiUI()
        BG.QianKuanUI()
        BG.WCLUI()
        BG.XiaoFeiUI()
        BG.YongShiUI()

        BG.HistoryUI()
        BG.ReceiveUI()
        BG.DuiZhangUI()
        BG.RoleOverviewUI()
        BG.FilterClassItemUI()
        BG.ItemLibUI()
    end
    ------------------设置------------------
    do
        -- 设置
        do
            local bt = CreateFrame("Button", nil, BG.MainFrame)
            bt:SetPoint("TOPLEFT", BG.ShuoMingShu, "TOPRIGHT", 15, 0)
            bt:SetNormalFontObject(BG.FontGreen15)
            bt:SetDisabledFontObject(BG.FontDisabled)
            bt:SetHighlightFontObject(BG.FontHilight)
            bt:SetText(L["设置"])
            bt:SetSize(bt:GetFontString():GetWidth(), 30)
            BG.ButtonSheZhi = bt

            bt:SetScript("OnClick", function(self)
                InterfaceOptionsFrame_OpenToCategory("|cff00BFFFBiaoGe|r")
                BG.MainFrame:Hide()
                PlaySound(BG.sound1, "Master")
            end)
            bt:SetScript("OnEnter", function(self)
                local text = L["快捷命令：/BGO"]
                GameTooltip:SetOwner(self, "ANCHOR_NONE")
                GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
                GameTooltip:ClearLines()
                GameTooltip:SetText(text)
            end)
            BG.GameTooltip_Hide(bt)
        end

        -- 通知移动
        do
            -- 屏幕中央的退出按钮
            do
                local bt = CreateFrame("Button", nil, UIParent, "BackdropTemplate")
                bt:SetBackdrop({
                    bgFile = "Interface/ChatFrame/ChatFrameBackground",
                    edgeFile = "Interface/ChatFrame/ChatFrameBackground",
                    edgeSize = 1,
                })
                bt:SetBackdropColor(0, 0, 0, 0.5)
                bt:SetBackdropBorderColor(RGB("00FF00", 1))
                bt:SetPoint("CENTER")
                bt:SetFrameStrata("FULLSCREEN_DIALOG")
                bt:SetFrameLevel(200)
                local font = bt:CreateFontString()
                font:SetTextColor(RGB("00FF00"))
                font:SetFont(BIAOGE_TEXT_FONT, 20, "OUTLINE")
                bt:SetFontString(font)
                bt:SetText(L["通知锁定"])
                bt:SetSize(font:GetWidth() + 30, font:GetHeight() + 10)
                bt:Hide()
                BG.ButtonMoveLock = bt

                local text = bt:CreateFontString()
                text:SetFont(BIAOGE_TEXT_FONT, 12, "OUTLINE")
                text:SetAlpha(0.8)
                text:SetPoint("BOTTOMLEFT", bt, "BOTTOMRIGHT", 5, 0)
                text:SetText(L["右键通知框体可还原位置"])

                bt:SetScript("OnEnter", function(self)
                    font:SetTextColor(RGB("FFFFFF"))
                    bt:SetBackdropBorderColor(1, 1, 1, 1)
                end)
                bt:SetScript("OnLeave", function(self)
                    font:SetTextColor(RGB("00FF00"))
                    bt:SetBackdropBorderColor(RGB("00FF00", 1))
                end)
                bt:SetScript("OnClick", function()
                    BG.HideMove()
                end)
            end
            local itemID
            if BG.IsVanilla() then
                itemID = 209562
            else
                itemID = 49623
            end

            function BG.HideMove()
                for k, f in pairs(BG.Movetable) do
                    f:SetBackdropColor(0, 0, 0, 0)
                    f:SetBackdropBorderColor(0, 0, 0, 0)
                    f:SetMovable(false)
                    f:EnableMouse(false)
                    f:SetScript("OnUpdate", nil)
                    f.name:Hide()
                    f:Clear()
                end
                BG.ButtonMoveLock:Hide()
                BG.ButtonMove:SetText(L["通知移动"])
            end

            function BG.Move()
                if BG.FrameLootMsg:IsMovable() then
                    BG.HideMove()
                else
                    for k, f in pairs(BG.Movetable) do
                        f:SetBackdrop({
                            bgFile = "Interface/ChatFrame/ChatFrameBackground",
                            edgeFile = "Interface/ChatFrame/ChatFrameBackground",
                            edgeSize = 2,
                        })
                        f:SetBackdropColor(0, 0, 0, 0.5)
                        f:SetBackdropBorderColor(0, 0, 0, 1)
                        f:SetMovable(true)
                        f:SetScript("OnMouseUp", function(self, enter)
                            self:StopMovingOrSizing()
                            if enter == "RightButton" then
                                f:ClearAllPoints()
                                f:SetPoint(unpack(f.homepoin))
                            end
                            BiaoGe.point[f:GetName()] = { f:GetPoint(1) }
                        end)
                        f:SetScript("OnMouseDown", function(self)
                            self:StartMoving()
                        end)
                        f.name:Show()

                        local time1 = 0
                        local time_update = 1.5
                        if f == BG.FrameTradeMsg then
                            time_update = 4
                        end
                        local name, link, quality, level, _, _, _, _, _, Texture, _, typeID = GetItemInfo(itemID)
                        local FB
                        local num
                        if BG.IsVanilla() then
                            FB = "BD"
                            num = 7
                        else
                            FB = "ICC"
                            num = 12
                        end
                        f:SetScript("OnUpdate", function()
                            local time2 = GetTime()
                            if time2 - time1 >= time_update then
                                if link then
                                    if f == BG.FrameLootMsg then
                                        f:AddMessage("|cff00BFFF" ..
                                            format(L["已自动记入表格：%s%s(%s) => %s< %s >%s"], RR, (AddTexture(Texture) .. link), level, "|cffFF1493", BG.Boss[FB]["boss" .. num]["name2"], RR) .. BG.STC_r1(L[" （测试） "]))
                                    else
                                        f:AddMessage(format("|cff00BFFF" .. L["< 交易记账成功 >|r\n装备：%s\n买家：%s\n金额：%s%d|rg%s\nBOSS：%s< %s >|r"],
                                            (AddTexture(Texture) .. link), SetClassCFF(UnitName("player"), "Player"), "|cffFFD700", 10000, L["|cffFF0000（欠款2000）|r"], "|cffFF1493", BG.Boss[FB]["boss" .. num]["name2"]) .. BG.STC_r1(L[" （测试） "]))
                                    end
                                else
                                    name, link, quality, level, _, _, _, _, _, Texture, _, typeID = GetItemInfo(itemID)
                                end
                                time1 = time2
                            end
                        end)
                    end
                    BG.ButtonMoveLock:Show()
                    BG.MainFrame:Hide()
                    BG.ButtonMove:SetText(L["通知锁定"])
                end
                PlaySound(BG.sound1, "Master")
            end

            local bt = CreateFrame("Button", nil, BG.MainFrame)
            bt:SetPoint("TOPLEFT", BG.ButtonSheZhi, "TOPRIGHT", 15, 0)
            bt:SetNormalFontObject(BG.FontGreen15)
            bt:SetDisabledFontObject(BG.FontDisabled)
            bt:SetHighlightFontObject(BG.FontHilight)
            bt:SetText(L["通知移动"])
            bt:SetSize(bt:GetFontString():GetWidth(), 30)
            BG.ButtonMove = bt
            bt:SetScript("OnClick", BG.Move)
            bt:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_NONE")
                GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
                GameTooltip:ClearLines()
                GameTooltip:SetText(L["调整装备记录通知和交易通知的位置\n快捷命令：/BGM"])
            end)
            bt:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
            end)
            GetItemInfo(itemID) -- 提前缓存
        end

        -- 工资抹零
        do
            local name = "moLing"

            local FB = BG.FB1

            local function OnClick(self)
                if self:GetChecked() then
                    BiaoGe.options[self.name] = 1
                else
                    BiaoGe.options[self.name] = 0
                end
                for i, FB in ipairs(BG.FBtable) do
                    BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine5"]:SetText(BG.SumGZ())
                    BG.Frame[FB]["boss" .. Maxb[FB] + 2]["jine5"]:SetCursorPosition(0)
                end
                PlaySound(BG.sound1, "Master")
            end
            local function OnEnter(self)
                GameTooltip:SetOwner(self.Text, "ANCHOR_TOPLEFT", 0, 0)
                GameTooltip:ClearLines()
                GameTooltip:AddLine(self.Text:GetText(), 1, 1, 1, true)
                GameTooltip:AddLine(L["抹去工资小数点"], 1, 0.82, 0, true)
                GameTooltip:Show()
            end
            local function OnLeave(self)
                GameTooltip:Hide()
            end

            local bt = CreateFrame("CheckButton", nil, BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei5"], "ChatConfigCheckButtonTemplate")
            bt:SetSize(25, 25)
            bt.Text:SetText(L["工资抹零"])
            bt.Text:SetTextColor(RGB(BG.b1))
            bt.Text:ClearAllPoints()
            bt.Text:SetPoint("TOPLEFT", bt:GetParent(), "BOTTOMLEFT", 0, -5)
            bt:SetPoint("LEFT", bt.Text, "RIGHT", 0, -1)
            bt:SetHitRectInsets(-bt.Text:GetWidth(), 0, 0, 0)
            bt.name = name
            if BiaoGe.options[name] == 1 then
                bt:SetChecked(true)
            else
                bt:SetChecked(false)
            end
            bt:SetScript("OnClick", OnClick)
            bt:SetScript("OnEnter", OnEnter)
            bt:SetScript("OnLeave", OnLeave)

            function BG.UpdateMoLingButton()
                local FB = BG.FB1
                bt:SetParent(BG.Frame[FB]["boss" .. Maxb[FB] + 2]["zhuangbei5"])
                bt.Text:ClearAllPoints()
                bt.Text:SetPoint("TOPLEFT", bt:GetParent(), "BOTTOMLEFT", 0, -7)
            end
        end
    end
    ------------------难度选择菜单------------------
    do
        if not BG.IsVanilla() then
            local fbid, sound
            local function RaidDifficultyID()
                local nanduID
                nanduID = GetRaidDifficultyID()
                if nanduID == 3 or nanduID == 175 then
                    return 3
                elseif nanduID == 4 or nanduID == 176 then
                    return 4
                elseif nanduID == 5 or nanduID == 193 then
                    return 5
                elseif nanduID == 6 or nanduID == 194 then
                    return 6
                end
            end
            local function AddButton(nanduID, text, soundID) -- 3，L["10人|cff00BFFF普通|r"]，12880
                local info = LibBG:UIDropDownMenu_CreateInfo()
                info.text, info.func = text, function()
                    local yes, type = IsInInstance()
                    if not yes then
                        SetRaidDifficultyID(nanduID)
                        PlaySound(soundID, "Master")
                    else
                        fbid = nanduID
                        sound = soundID
                        StaticPopup_Show("QIEHUANFUBEN", text)
                    end
                    FrameHide(0)
                end
                if RaidDifficultyID() == nanduID then
                    info.checked = true
                end
                LibBG:UIDropDownMenu_AddButton(info)
            end
            StaticPopupDialogs["QIEHUANFUBEN"] = {
                text = L["确认切换难度为< %s >？"],
                button1 = L["是"],
                button2 = L["否"],
                OnAccept = function()
                    SetRaidDifficultyID(fbid)
                    PlaySound(sound, "Master")
                end,
                OnCancel = function()
                end,
                timeout = 10,
                whileDead = true,
                hideOnEscape = true,
            }

            BG.NanDuDropDown = {}
            local dropDown = LibBG:Create_UIDropDownMenu("BG.NanDuDropDown.dropDown", BG.MainFrame)
            dropDown:SetPoint("BOTTOMLEFT", BG.MainFrame, "BOTTOMLEFT", 250, 30)
            LibBG:UIDropDownMenu_SetWidth(dropDown, 95)
            LibBG:UIDropDownMenu_SetAnchor(dropDown, 0, 0, "BOTTOM", dropDown, "TOP")
            BG.dropDownToggle(dropDown)
            BG.NanDuDropDown.DropDown = dropDown
            local text = dropDown:CreateFontString()
            text:SetPoint("RIGHT", dropDown, "LEFT", 10, 3)
            text:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
            text:SetTextColor(RGB(BG.y2))
            text:SetText(L["当前难度:"])
            BG.NanDuDropDown.BiaoTi = text

            LibBG:UIDropDownMenu_Initialize(dropDown, function(self, level)
                FrameHide(0)
                PlaySound(BG.sound1, "Master")
                local info = LibBG:UIDropDownMenu_CreateInfo()
                info.text = L["切换副本难度"]
                info.isTitle = true
                info.notCheckable = true
                LibBG:UIDropDownMenu_AddButton(info)

                AddButton(3, L["10人|cff00BFFF普通|r"], 12880)
                AddButton(5, L["10人|cffFF0000英雄|r"], 12873)
                AddButton(4, L["25人|cff00BFFF普通|r"], 12880)
                AddButton(6, L["25人|cffFF0000英雄|r"], 12873)
            end)

            local f = CreateFrame("Frame")
            f:RegisterEvent("PLAYER_ENTERING_WORLD")
            f:RegisterEvent("GROUP_ROSTER_UPDATE")
            f:SetScript("OnEvent", function(self, even, ...)
                C_Timer.After(1, function()
                    local nandu
                    local nanduID
                    nanduID = GetRaidDifficultyID()
                    if nanduID == 3 or nanduID == 175 then
                        nandu = L["10人|cff00BFFF普通|r"]
                    elseif nanduID == 4 or nanduID == 176 then
                        nandu = L["25人|cff00BFFF普通|r"]
                    elseif nanduID == 5 or nanduID == 193 then
                        nandu = L["10人|cffFF0000英雄|r"]
                    elseif nanduID == 6 or nanduID == 194 then
                        nandu = L["25人|cffFF0000英雄|r"]
                    end
                    LibBG:UIDropDownMenu_SetText(dropDown, nandu)
                end)
            end)

            local changeRaidDifficulty = ERR_RAID_DIFFICULTY_CHANGED_S:gsub("%%s", "(.+)")
            local f = CreateFrame("Frame")
            f:RegisterEvent("CHAT_MSG_SYSTEM")
            f:SetScript("OnEvent", function(self, even, text, ...)
                if string.find(text, changeRaidDifficulty) then
                    local nandu
                    local nanduID = GetRaidDifficultyID()
                    if nanduID == 3 or nanduID == 175 then
                        nandu = L["10人|cff00BFFF普通|r"]
                    elseif nanduID == 4 or nanduID == 176 then
                        nandu = L["25人|cff00BFFF普通|r"]
                    elseif nanduID == 5 or nanduID == 193 then
                        nandu = L["10人|cffFF0000英雄|r"]
                    elseif nanduID == 6 or nanduID == 194 then
                        nandu = L["25人|cffFF0000英雄|r"]
                    end
                    LibBG:UIDropDownMenu_SetText(dropDown, nandu)
                end
            end)
        end
    end
    ------------------副本切换按钮------------------
    do
        local buttonsWidth = 0
        local last
        local itemLibCaches = {}
        itemLibCaches[BG.FB1] = true

        function BG.ClickFBbutton(FB)
            if FB == BG.FB1 then return end
            FrameHide(0)
            if BG.FBMainFrame:IsVisible() then
                for i, FB in ipairs(BG.FBtable) do
                    BG["Frame" .. FB]:Hide()
                end
                BG["Frame" .. FB]:Show()
            elseif BG.HopeMainFrame:IsVisible() then
                for i, FB in ipairs(BG.FBtable) do
                    BG["HopeFrame" .. FB]:Hide()
                end
                BG["HopeFrame" .. FB]:Show()
            elseif BG.DuiZhangMainFrame:IsVisible() then
                for i, FB in ipairs(BG.FBtable) do
                    BG["DuiZhangFrame" .. FB]:Hide()
                end
                BG["DuiZhangFrame" .. FB]:Show()
            elseif BG.BossMainFrame and BG.BossMainFrame:IsVisible() then
                for i, FB in ipairs(BG.FBtable) do
                    BG["BossFrame" .. FB]:Hide()
                end
                BG["BossFrame" .. FB]:Show()
            end

            for i, FB in ipairs(BG.FBtable) do
                BG["Button" .. FB]:SetEnabled(false)
            end
            C_Timer.After(0.5, function()
                for i, FB in ipairs(BG.FBtable) do
                    BG["Button" .. FB]:SetEnabled(true)
                end
                BG["Button" .. FB]:SetEnabled(false)
            end)
            BG.FB1 = FB
            BiaoGe.FB = FB
            BG.History.HistoryButton:SetFormattedText(L["历史表格（共%d个）"], #BiaoGe.HistoryList[FB])
            BG.CreatHistoryListButton(FB)
            FrameDongHua(BG.MainFrame, Height[FB], Width[FB])

            BG.UpdateAllFilter()
            BG.UpdateHopeFrame_IsLooted_All()

            -- 装备库
            if not BG.IsVanilla_60() then
                BG.After(0.6, function()
                    if not itemLibCaches[FB] then
                        BG.CheckItemCache() -- 向服务器申请缓存全部装备
                        itemLibCaches[FB] = true
                        BG.After(0.2, function()
                            BG.UpdateAllItemLib()
                            BG.UpdateItemLib_RightHope_Default("defaultHope")
                            BG.UpdateItemLib_RightHope_IsHaved_All()
                            BG.UpdateItemLib_RightHope_IsLooted_All()
                        end)
                    else
                        BG.UpdateAllItemLib()
                        BG.UpdateItemLib_RightHope_Default("defaultHope")
                        BG.UpdateItemLib_RightHope_IsHaved_All()
                        BG.UpdateItemLib_RightHope_IsLooted_All()
                    end
                end)
            else
                BG.UpdateItemLib_RightHope_Default("defaultHope")
                BG.UpdateItemLib_RightHope_IsHaved_All()
                BG.UpdateItemLib_RightHope_IsLooted_All()
            end

            if BG.lastduizhangNum then
                BG.DuiZhangSet(BG.lastduizhangNum)
            end

            if BG.HopeSenddropDown and BG.HopeSenddropDown[FB] then
                LibBG:UIDropDownMenu_SetText(BG.HopeSenddropDown[FB], BG.HopeSendTable[BiaoGe["HopeSendChannel"]])
            end

            BG.UpdateMoLingButton()
        end

        local function Create_FBButton(FB, fbID)
            local bt = CreateFrame("Button", nil, BG.TabButtonsFB)
            bt:SetHeight(bt:GetParent():GetHeight())
            bt:SetNormalFontObject(BG.FontBlue1)
            bt:SetDisabledFontObject(BG.FontWhile15)
            bt:SetHighlightFontObject(BG.FontHilight)
            if not last then
                bt:SetPoint("LEFT")
            else
                bt:SetPoint("LEFT", last, "RIGHT", 0, 0)
            end
            bt:SetText(GetRealZoneText(fbID))
            local t = bt:GetFontString()
            bt:SetWidth(t:GetStringWidth() + 20)
            buttonsWidth = buttonsWidth + bt:GetWidth()
            bt:GetParent():SetWidth(buttonsWidth)
            local tex = bt:CreateTexture(nil, "ARTWORK") -- 高亮材质
            tex:SetTexture("interface/paperdollinfoframe/ui-character-tab-highlight")
            bt:SetHighlightTexture(tex)
            last = bt

            bt:SetScript("OnClick", function(self)
                BG.ClickFBbutton(FB)
                PlaySound(BG.sound1, "Master")
            end)

            return bt
        end

        BG.TabButtonsFB = CreateFrame("Frame", nil, BG.MainFrame)
        BG.TabButtonsFB:SetPoint("TOP", BG.MainFrame, "TOP", 0, -28)
        BG.TabButtonsFB:SetHeight(20)

        local first, last
        for i, v in ipairs(BG.FBtable2) do
            BG["Button" .. v.FB] = Create_FBButton(v.FB, v.ID)
            if i == 1 then
                first = BG["Button" .. v.FB]
            end
            last = BG["Button" .. v.FB]
        end

        BG["Button" .. BG.FB1]:SetEnabled(false)

        local l = first:CreateLine()
        l:SetColorTexture(RGB("D3D3D3", 0.8))
        l:SetStartPoint("BOTTOMLEFT", first, -30, -3)
        l:SetEndPoint("BOTTOMRIGHT", last, 30, -3)
        l:SetThickness(1.5)
        BG.LineFB = l
    end
    ------------------模块切换按钮------------------
    do
        BG.tabButtons = {}

        BG.FBMainFrameTabNum = 1
        BG.HopeMainFrameTabNum = 3
        BG.ItemLibMainFrameTabNum = 2
        BG.DuiZhangMainFrameTabNum = 4
        BG.YYMainFrameTabNum = 5
        BG.BossMainFrameTabNum = 6

        function BG.ClickTabButton(tabButtons, num)
            for i, v in pairs(tabButtons) do
                if i == num then
                    PanelTemplates_SelectTab(v.button)
                    _G[v.button:GetName() .. "Text"]:SetTextColor(RGB(BG.w1))
                    v.frame:Show()
                    -- BG.tabButtonsHilight:SetParent(v.button)
                    -- BG.tabButtonsHilight:ClearAllPoints()
                    -- BG.tabButtonsHilight:SetPoint("TOPLEFT", 14, 0)
                    -- BG.tabButtonsHilight:SetPoint("BOTTOMRIGHT", -14, 10)
                    -- BG.tabButtonsHilight:Show()
                else
                    PanelTemplates_DeselectTab(v.button)
                    _G[v.button:GetName() .. "Text"]:SetTextColor(RGB(BG.g1))
                    v.frame:Hide()
                end
            end
        end

        local function Create_TabButton(num, text, frame, width) -- 1,L["当前表格 "],BG["Frame" .. BG.FB1],150
            local bt = CreateFrame("Button", "BiaoGeTab" .. num, BG.MainFrame, "CharacterFrameTabButtonTemplate")
            bt:SetText(text)
            _G[bt:GetName() .. "Text"]:SetTextColor(RGB(BG.g1))
            PanelTemplates_TabResize(bt, nil, width or 120)
            if num == 1 then
                bt:SetPoint("TOPLEFT", BG.MainFrame, "BOTTOM", -330, 0)
            else
                bt:SetPoint("LEFT", BG.tabButtons[num - 1].button, "RIGHT", -10, 0)
            end
            BG.tabButtons[num] = {
                button = bt,
                frame = frame
            }
            bt:SetScript("OnEvent", nil)
            bt:SetScript("OnShow", nil)
            bt:SetScript("OnClick", function(self)
                BG.ClickTabButton(BG.tabButtons, num)
                PlaySound(BG.sound1, "Master")
            end)

            -- if not BG.tabButtonsHilight then
            --     local texture = bt:CreateTexture(nil, "ARTWORK") -- 高亮材质
            --     texture:SetTexture("interface/paperdollinfoframe/ui-character-tab-highlight")
            --     texture:SetTexCoord(0, 1, 0.1, 0.9)
            --     texture:Hide()
            --     BG.tabButtonsHilight = texture
            -- end

            return bt
        end

        local bt = Create_TabButton(BG.FBMainFrameTabNum, L["当前表格"], BG.FBMainFrame)
        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:AddLine(L["< 当前表格 >"], 1, 1, 1, true)
            GameTooltip:AddLine(L["表格的核心功能都在这里"], 1, 0.82, 0, true)
            GameTooltip:Show()
        end)

        local bt = Create_TabButton(BG.ItemLibMainFrameTabNum, L["装备库"], BG.ItemLibMainFrame)
        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:AddLine(L["< 装备库 >"], 1, 1, 1, true)
            GameTooltip:AddLine(L["查看所有适合你的装备"], 1, 0.82, 0, true)
            GameTooltip:Show()
        end)

        local bt = Create_TabButton(BG.HopeMainFrameTabNum, L["心愿清单"], BG.HopeMainFrame)
        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:AddLine(L["< 心愿清单 >"], 1, 1, 1, true)
            GameTooltip:AddLine(L["你可以设置一些装备，这些装备只要掉落就会提醒，并且自动关注团长拍卖"], 1, 0.82, 0, true)
            GameTooltip:Show()
        end)

        local bt = Create_TabButton(BG.DuiZhangMainFrameTabNum, L["对账"], BG.DuiZhangMainFrame)
        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:AddLine(L["< 对账 >"], 1, 1, 1, true)
            GameTooltip:AddLine(L["当团队有人通报BiaoGe/RaidLedger/大脚的账单，你可以选择该账单，来对账"], 1, 0.82, 0, true)
            GameTooltip:AddLine(L["只对比装备收入，不对比罚款收入，也不对比支出"], 1, 0.82, 0, true)
            GameTooltip:AddLine(L["别人账单会自动保存1天，过后自动删除"], 1, 0.82, 0, true)
            GameTooltip:Show()
        end)

        local bt = Create_TabButton(BG.YYMainFrameTabNum, L["YY评价"], BG.YYMainFrame)
        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:AddLine(L["< YY评价 >"], 1, 1, 1, true)
            GameTooltip:AddLine(L["|cff808080（右键：开启/关闭该模块）|r"], 1, 0.82, 0, true)
            GameTooltip:AddLine(L["你可以给YY频道做评价，帮助别人辨别该团好与坏"], 1, 0.82, 0, true)
            GameTooltip:AddLine(L["你可以查询YY频道的大众评价"], 1, 0.82, 0, true)
            GameTooltip:AddLine(L["聊天频道的YY号变为超链接，方便你复制该号码或查询大众评价"], 1, 0.82, 0, true)
            GameTooltip:AddLine(L["替换集结号的评价框，击杀当前版本团本尾王后弹出"], 1, 0.82, 0, true)
            GameTooltip:Show()
        end)
        local dropDown = LibBG:Create_UIDropDownMenu(nil, bt)
        LibBG:UIDropDownMenu_SetAnchor(dropDown, -5, 0, "BOTTOM", bt, "TOP")
        bt:SetScript("OnMouseDown", function(self, enter)
            if enter == "RightButton" then
                GameTooltip:Hide()
                if _G.L_DropDownList1 and _G.L_DropDownList1:IsVisible() then
                    _G.L_DropDownList1:Hide()
                else
                    local YY = "BiaoGeYY"
                    local channelTypeMenu = {
                        {
                            isTitle = true,
                            text = L["模块开关"],
                            notCheckable = true,
                        },
                        {
                            text = L["开启"],
                            notCheckable = true,
                            func = function()
                                BiaoGe.YYdb.share = 1
                                BG.YYShowHide(BiaoGe.YYdb.share)
                                JoinPermanentChannel(YY, nil, 1)
                            end,
                        },
                        {
                            text = L["关闭"],
                            notCheckable = true,
                            func = function()
                                BiaoGe.YYdb.share = 0
                                BG.YYShowHide(BiaoGe.YYdb.share)
                                LeaveChannelByName(YY)
                            end,
                        },
                        {
                            text = CANCEL,
                            notCheckable = true,
                            func = function(self)
                                LibBG:CloseDropDownMenus()
                            end,
                        }
                    }
                    LibBG:EasyMenu(channelTypeMenu, dropDown, bt, 0, 0, "MENU", 3)
                    PlaySound(BG.sound1, "Master")
                end
            end
        end)

        if not BG.IsVanilla() then
            local bt = Create_TabButton(BG.BossMainFrameTabNum, L["团本攻略"], BG.BossMainFrame)
            bt:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
                GameTooltip:ClearLines()
                GameTooltip:AddLine(L["< 团本攻略 >"], 1, 1, 1, true)
                GameTooltip:AddLine(L["了解BOSS技能和应对策略、职业职责"], 1, 0.82, 0, true)
                GameTooltip:Show()
            end)
        end

        --[[     if not BiaoGe.options.SearchHistory.tutorial231013 then
            local f = CreateFrame("Frame", nil, BG.MainFrame, "BackdropTemplate")
            f:SetBackdrop({
                bgFile = "Interface/ChatFrame/ChatFrameBackground",
            })
            f:SetBackdropColor(0, 0, 0, 0.9)
            f:SetPoint("TOPLEFT", -3, 3)
            f:SetPoint("BOTTOMRIGHT", 0, 0)
            f:SetFrameLevel(500)
            f:EnableMouse(true)
            f:SetScript("OnMouseUp", function(self)
                BG.MainFrame:GetScript("OnMouseUp")(BG.MainFrame)
            end)
            f:SetScript("OnMouseDown", function(self)
                BG.MainFrame:GetScript("OnMouseDown")(BG.MainFrame)
            end)

            f.red = CreateFrame("Frame", nil, f, "BackdropTemplate")
            f.red:SetBackdrop({
                edgeFile = "Interface/ChatFrame/ChatFrameBackground",
                edgeSize = 4,
            })
            f.red:SetBackdropBorderColor(1, 0, 0, 1)
            f.red:SetPoint("TOPLEFT", BG.tabButtons[1].button, "TOPLEFT", -3, 12)
            f.red:SetPoint("BOTTOMRIGHT", BG.tabButtons[#BG.tabButtons].button, "BOTTOMRIGHT", 3, -4)

            f.title = f:CreateFontString()
            f.title:SetPoint("CENTER", 0, 100)
            f.title:SetFont(BIAOGE_TEXT_FONT, 25, "OUTLINE")
            f.title:SetTextColor(1, 1, 1)
            f.title:SetText(L["< 我是教程 >"])

            f.t = f:CreateFontString()
            f.t:SetPoint("TOP", f.title, "BOTTOM", 0, -20)
            f.t:SetFont(BIAOGE_TEXT_FONT, 20, "OUTLINE")
            f.t:SetTextColor(1, 1, 1)
            f.t:SetSpacing(5)
            f.t:SetText(L["鉴于部分玩家找不到|cff00BFFF切换模块|r的按钮，特做此教程：\n按钮就在底下|cffFF0000红色框框|r里"])

            f.bt = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
            f.bt:SetSize(150, 40)
            f.bt:SetPoint("BOTTOM", BG.MainFrame, "BOTTOM", 0, 50)
            f.bt:SetText(L["@_@ 我知道了。。"])
            f.bt:SetScript("OnClick", function(self)
                BiaoGe.options.SearchHistory.tutorial231013 = true
                f:Hide()
            end)
        end ]]
    end
    ------------------定时获取当前副本和提示清空表格------------------
    do
        -- 获取当前副本
        local lastzoneId
        C_Timer.NewTicker(5, function()               -- 每5秒执行一次
            local fbId = select(8, GetInstanceInfo()) -- 获取副本ID
            for id, value in pairs(BG.FBIDtable) do   -- 把副本ID转换为副本英文简写
                if fbId == id then
                    BG.FB2 = value
                    break
                else
                    BG.FB2 = nil
                end
            end
            if lastzoneId ~= fbId then
                if BG.FB2 then
                    BG.ClickFBbutton(BG.FB2)
                end
            end
            lastzoneId = fbId
        end)
    end
    ------------------高亮团长发出的装备------------------
    do
        local f = CreateFrame("Frame")
        f:RegisterEvent("CHAT_MSG_RAID_LEADER")
        f:RegisterEvent("CHAT_MSG_RAID_WARNING")
        f:RegisterEvent("CHAT_MSG_RAID")
        f:RegisterEvent("CHAT_MSG_SAY")
        f:SetScript("OnEvent", function(self, even, msg, playerName, ...)
            if even == "CHAT_MSG_SAY" and not BG.DeBug then return end
            if even == "CHAT_MSG_RAID" then
                local a = string.find(playerName, "-")
                if a then
                    playerName = strsub(playerName, 1, a - 1)
                end
                if playerName ~= BG.MasterLooter then
                    return
                end
            end
            -- 收集全部物品ID
            local itemIDs = ""
            for itemID in string.gmatch(msg, "|Hitem:(%d-):") do
                itemIDs = itemIDs .. itemID .. " "
            end
            -- 开始
            local name1 = "auctionHigh"
            if BiaoGe.options[name1] ~= 1 then return end
            local name2 = "auctionHighTime"
            local yes
            local sound_yes = ""
            for _, FB in pairs(BG.FBtable) do
                for b = 1, Maxb[FB], 1 do
                    for i = 1, Maxi[FB], 1 do
                        if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i] then
                            if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:GetText() ~= "" then
                                local itemID = GetItemID(BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:GetText())
                                if itemID then
                                    local name, link, quality, level, _, _, _, _, _, Texture, _, typeID = GetItemInfo(itemID)
                                    yes = string.find(itemIDs, tostring(itemID))
                                    if yes then
                                        BG.FrameDs[FB .. 3]["boss" .. b]["ds" .. i]:Show()
                                        BG.OnUpdateTime(function(self, elapsed)
                                            self.timeElapsed = self.timeElapsed + elapsed
                                            if BiaoGe.options[name1] ~= 1 or self.timeElapsed >= BiaoGe.options[name2] then
                                                BG.FrameDs[FB .. 3]["boss" .. b]["ds" .. i]:Hide()
                                                self:SetScript("OnUpdate", nil)
                                                self:Hide()
                                            end
                                        end)

                                        if BiaoGe[FB]["boss" .. b]["guanzhu" .. i] then
                                            if not string.find(sound_yes, tostring(itemID)) then
                                                BG.FrameLootMsg:AddMessage(BG.STC_g1(format(L["你关注的装备开始拍卖了：%s（右键取消关注）"],
                                                    AddTexture(Texture) .. BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:GetText())))
                                                PlaySoundFile(BG.sound_paimai, "Master")
                                                sound_yes = sound_yes .. itemID .. " "
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            local yes
            for _, FB in pairs(BG.FBtable) do
                for n = 1, HopeMaxn[FB] do
                    for b = 1, HopeMaxb[FB] do
                        for i = 1, HopeMaxi do
                            if BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] then
                                local itemID = GetItemID(BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:GetText())
                                if itemID then
                                    local name, link, quality, level, _, _, _, _, _, Texture, _, typeID = GetItemInfo(itemID)
                                    yes = string.find(itemIDs, tostring(itemID))
                                    if yes then
                                        BG.HopeFrameDs[FB .. 3]["nandu" .. n]["boss" .. b]["ds" .. i]:Show()
                                        BG.OnUpdateTime(function(self, elapsed)
                                            self.timeElapsed = self.timeElapsed + elapsed
                                            if BiaoGe.options[name1] ~= 1 or self.timeElapsed >= BiaoGe.options[name2] then
                                                BG.HopeFrameDs[FB .. 3]["nandu" .. n]["boss" .. b]["ds" .. i]:Hide()
                                                self:SetScript("OnUpdate", nil)
                                                self:Hide()
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    ------------------点击聊天添加装备------------------
    do
        hooksecurefunc("SetItemRef", function(link)
            local item, link, quality, level, _, _, _, _, _, Texture, _, typeID = GetItemInfo(link)
            if not link then return end
            if BG.MainFrame:IsShown() and BG.lastfocuszhuangbei and BG.lastfocuszhuangbei:HasFocus() then
                if BG.FrameZhuangbeiList then
                    BG.FrameZhuangbeiList:Hide()
                end
                BG.lastfocuszhuangbei:SetText(link)
                PlaySound(BG.sound1, "Master")
                if BG.lastfocuszhuangbei2 then
                    BG.lastfocuszhuangbei2:SetFocus()
                    if BG.FrameZhuangbeiList then
                        BG.FrameZhuangbeiList:Hide()
                    end
                end
            end
            if IsAltKeyDown() then
                if BG.IsLeader then -- 开始拍卖
                    BG.StartAuction(link)
                else                -- 关注装备
                    for b = 1, Maxb[BG.FB1], 1 do
                        for i = 1, Maxi[BG.FB1], 1 do
                            if BG.Frame[BG.FB1]["boss" .. b]["zhuangbei" .. i] then
                                if GetItemID(link) == GetItemID(BG.Frame[BG.FB1]["boss" .. b]["zhuangbei" .. i]:GetText()) then
                                    BiaoGe[BG.FB1]["boss" .. b]["guanzhu" .. i] = true
                                    BG.Frame[BG.FB1]["boss" .. b]["guanzhu" .. i]:Show()
                                    BG.FrameLootMsg:AddMessage(BG.STC_g2(format(L["已成功关注装备：%s。团长拍卖此装备时会提醒"],
                                        AddTexture(Texture) .. link)))
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    ------------------时光徽章价格------------------
    do
        local t = BG.MainFrame:CreateFontString()
        t:SetFont(BIAOGE_TEXT_FONT, 13, "OUTLINE")
        t:SetPoint("BOTTOMLEFT", 10, 7)
        BG.ButtonToken = t

        local function OnTokenMarketPriceUpdated(event, result)
            if C_WowTokenPublic.GetCurrentMarketPrice() then
                local currentPrice = GetMoneyString(C_WowTokenPublic.GetCurrentMarketPrice(), false)
                t:SetText(BG.STC_y1(L["当前时光徽章："]) .. currentPrice)
            else
                t:SetText(BG.STC_y1(L["当前时光徽章不可用"]))
            end
        end
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("TOKEN_MARKET_PRICE_UPDATED")
        frame:SetScript("OnEvent", OnTokenMarketPriceUpdated)

        local f = CreateFrame("Frame")
        f:RegisterEvent("PLAYER_ENTERING_WORLD")
        f:SetScript("OnEvent", function(self, even, ...)
            C_Timer.After(2, function()
                C_WowTokenPublic.UpdateMarketPrice()
                OnTokenMarketPriceUpdated()
            end)
        end)
        C_Timer.NewTicker(60, function()
            C_WowTokenPublic.UpdateMarketPrice()
        end)
    end
    ------------------离队入队染上职业颜色------------------
    do
        local last
        local lastraidjoinname
        local lastpartyjoinname
        local function MsgClassColor(self, even, msg, player, l, cs, t, flag, channelId, ...)
            if BiaoGe.options["joinorleavePlayercolor"] ~= 1 then return end
            if msg:match("%s$") then return end

            local raidleavename = strmatch(msg, ERR_RAID_MEMBER_REMOVED_S:gsub("%%s", "(.+)"))
            local raidjoinname = strmatch(msg, ERR_RAID_MEMBER_ADDED_S:gsub("%%s", "(.+)"))
            local partyleavename = strmatch(msg, ERR_LEFT_GROUP_S:gsub("%%s", "(.+)"))
            local partyjoinname = strmatch(msg, ERR_JOINED_GROUP_S:gsub("%%s", "(.+)"))
            -- 离开了团队
            if raidleavename then
                if BG.raidRosterInfo and type(BG.raidRosterInfo) == "table" then
                    for k, v in pairs(BG.raidRosterInfo) do
                        if raidleavename == v.name then
                            local raidleavenamelink = "|Hplayer:" .. raidleavename .. "|h[" .. raidleavename .. "]|h"
                            local c = select(4, GetClassColor(v.class))
                            local colorname = "|c" .. c .. raidleavenamelink .. "|r"
                            msg = format(ERR_RAID_MEMBER_REMOVED_S, colorname)
                            lastraidjoinname = nil
                            return false, msg, player, l, cs, t, flag, channelId, ...
                        end
                    end
                end
                -- 加入了团队
            elseif raidjoinname then
                C_Timer.After(0.5, function()
                    if not IsInRaid(1) then return end
                    if lastraidjoinname == raidjoinname then return end
                    local raidjoinnamelink = "|Hplayer:" .. raidjoinname .. "|h[" .. raidjoinname .. "]|h"
                    local _, color = SetClassCFF(raidjoinname)
                    local colorname = "|c" .. color .. raidjoinnamelink .. "|r"
                    SendSystemMessage(format(ERR_RAID_MEMBER_ADDED_S .. " ", colorname))
                    lastraidjoinname = raidjoinname
                end)
                return true

                -- 离开了队伍
            elseif partyleavename then
                if BG.groupRosterInfo and type(BG.groupRosterInfo) == "table" then
                    for k, v in pairs(BG.groupRosterInfo) do
                        if partyleavename == v.name then
                            local partyleavenamelink = "|Hplayer:" .. partyleavename .. "|h[" .. partyleavename .. "]|h"
                            local c = select(4, GetClassColor(v.class))
                            local colorname = "|c" .. c .. partyleavenamelink .. "|r"
                            msg = format(ERR_LEFT_GROUP_S, colorname)
                            lastpartyjoinname = nil
                            return false, msg, player, l, cs, t, flag, channelId, ...
                        end
                    end
                end
                -- 加入了队伍
            elseif partyjoinname then
                C_Timer.After(0.5, function()
                    if not IsInGroup(1) then return end
                    if lastpartyjoinname == partyjoinname then return end
                    local partyjoinnamelink = "|Hplayer:" .. partyjoinname .. "|h[" .. partyjoinname .. "]|h"
                    local _, color = SetClassCFF(partyjoinname)
                    local colorname = "|c" .. color .. partyjoinnamelink .. "|r"
                    SendSystemMessage(format(ERR_JOINED_GROUP_S .. " ", colorname))
                    lastpartyjoinname = partyjoinname
                end)
                return true
            end
        end
        ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", MsgClassColor)

        BG.RegisterEvent("GROUP_ROSTER_UPDATE", function()
            if not IsInRaid(1) then
                lastraidjoinname = nil
            end
            if not IsInGroup(1) then
                lastpartyjoinname = nil
            end
        end)
    end
    ------------------表格/背包高亮对应装备------------------
    do
        BG.LastBagItemFrame = {}
        BG.BagAddon = ""

        local function SetOnEnter(link)
            if BiaoGe.options["HighOnterItem"] ~= 1 then return end
            if not BG.FBMainFrame:IsVisible() then return end
            if not link then return end
            local FB = BG.FB1
            for b = 1, Maxb[FB], 1 do
                for i = 1, Maxi[FB], 1 do
                    local zb = BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]
                    local jine = BG.Frame[FB]["boss" .. b]["jine" .. i]
                    if zb then
                        if GetItemID(link) == GetItemID(zb:GetText()) then
                            local f = CreateFrame("Frame", nil, zb, "BackdropTemplate")
                            f:SetBackdrop({
                                edgeFile = "Interface/ChatFrame/ChatFrameBackground",
                                edgeSize = 2,
                            })
                            f:SetBackdropBorderColor(1, 0, 0, 1)
                            f:SetPoint("TOPLEFT", zb, "TOPLEFT", -4, -2)
                            f:SetPoint("BOTTOMRIGHT", jine, "BOTTOMRIGHT", -2, 0)
                            f:SetFrameLevel(112)
                            tinsert(BG.LastBagItemFrame, f)
                        end
                    end
                end
            end
        end

        local function NDuiOnEnter(self)
            local link = C_Container.GetContainerItemLink(self.bagId, self.slotId)
            SetOnEnter(link)
        end

        local function EUIOnEnter(self)
            local link = C_Container.GetContainerItemLink(self.BagID, self.SlotID)
            SetOnEnter(link)
        end

        local function OnEnter(self)
            local link = C_Container.GetContainerItemLink(self:GetParent():GetID(), self:GetID())
            SetOnEnter(link)
        end
        local function OnLeave(self)
            for key, value in pairs(BG.LastBagItemFrame) do
                value:Hide()
            end
            BG.LastBagItemFrame = {}
        end

        local function OnHyperlinkEnter(self, link)
            if BiaoGe.options["HighOnterItem"] ~= 1 then return end
            local _, link = GetItemInfo(link)
            -- pt(link, GetItemID(link))
            if BG.FBMainFrame:IsVisible() then
                SetOnEnter(link)
            end
            BG.HilightBag(link)
        end
        local function OnHyperlinkLeave(self, link)
            OnLeave()
            BG.HideHilightBag()
        end
        local function ChatFrameOnHyperlink()
            local i = 1
            while _G["ChatFrame" .. i] do
                _G["ChatFrame" .. i]:HookScript("OnHyperlinkEnter", OnHyperlinkEnter)
                _G["ChatFrame" .. i]:HookScript("OnHyperlinkLeave", OnHyperlinkLeave)
                i = i + 1
            end
        end

        BG.RegisterEvent("PLAYER_ENTERING_WORLD", function(self, even, isLogin, isReload)
            if not (isLogin or isReload) then return end
            ChatFrameOnHyperlink()

            if _G["NDui_BackpackSlot1"] then
                --NDUI背包
                local i = 1
                while _G["NDui_BackpackSlot" .. i] do
                    _G["NDui_BackpackSlot" .. i]:HookScript("OnEnter", NDuiOnEnter)
                    _G["NDui_BackpackSlot" .. i]:HookScript("OnLeave", OnLeave)
                    i = i + 1
                end
                BG.BagAddon = "NDUI"
            elseif _G["ElvUI_ContainerFrameBag-1Slot1"] then
                --EUI背包
                local b = -1
                local i = 1
                while _G["ElvUI_ContainerFrameBag" .. b .. "Slot" .. i] do
                    while _G["ElvUI_ContainerFrameBag" .. b .. "Slot" .. i] do
                        _G["ElvUI_ContainerFrameBag" .. b .. "Slot" .. i]:HookScript("OnEnter", EUIOnEnter)
                        _G["ElvUI_ContainerFrameBag" .. b .. "Slot" .. i]:HookScript("OnLeave", OnLeave)
                        i = i + 1
                    end
                    b = b + 1
                    i = 1
                end
                BG.BagAddon = "EUI"
            elseif _G["CombuctorFrame1"] then
                --大脚背包
                local yes
                _G["CombuctorFrame1"]:HookScript("OnShow", function()
                    if not yes then
                        local i = 1
                        while _G["CombuctorItem" .. i] do
                            _G["CombuctorItem" .. i]:HookScript("OnEnter", OnEnter)
                            _G["CombuctorItem" .. i]:HookScript("OnLeave", OnLeave)
                            i = i + 1
                        end
                        yes = true
                    end
                end)
                BG.BagAddon = "BIGFOOT"
            else
                -- 原生背包
                local b = 1
                local i = 1
                while _G["ContainerFrame" .. b .. "Item" .. i] do
                    while _G["ContainerFrame" .. b .. "Item" .. i] do
                        _G["ContainerFrame" .. b .. "Item" .. i]:HookScript("OnEnter", OnEnter)
                        _G["ContainerFrame" .. b .. "Item" .. i]:HookScript("OnLeave", OnLeave)
                        i = i + 1
                    end
                    b = b + 1
                    i = 1
                end
            end
        end)
    end
    ------------------一键分配装备给自己------------------
    do
        BG.RegisterEvent("PLAYER_ENTERING_WORLD", function(self, even, isLogin, isReload)
            if not (isLogin or isReload) then return end

            local function OnClick(self)
                BG.PlaySound(1)
                for ci = 1, GetNumGroupMembers() do
                    for li = 1, GetNumLootItems() do
                        if LootSlotHasItem(li) and GetMasterLootCandidate(li, ci) == UnitName("player") then
                            local itemLink = GetLootSlotLink(li)
                            if itemLink then
                                local name, link, quality, level, _, _, _, _, _, Texture, _, typeID, _, bindType = GetItemInfo(itemLink)
                                local itemID = GetItemInfoInstant(itemLink)

                                if (BG.IsVanilla() and (quality == 3 or quality == 4) or (BG.DeBug or quality == 4)) and (typeID == 2 or typeID == 4) then -- 紫色装备
                                    GiveMasterLoot(li, ci)
                                elseif itemID == 45087 or itemID == 47556 or itemID == 49908 then                                                          -- 蓝色宝珠
                                    GiveMasterLoot(li, ci)
                                else                                                                                                                       -- 套装兑换物
                                    local yes
                                    for _, FB in pairs(BG.FBtable) do
                                        if BG.Loot[FB].T then
                                            for k, _itemID in pairs(BG.Loot[FB].T) do
                                                if itemID == _itemID then
                                                    GiveMasterLoot(li, ci)
                                                    yes = true
                                                    break
                                                end
                                            end
                                            if yes then
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            local function OnEnter(self)
                local bt = self.bt or self
                if bt:IsEnabled() then
                    bt:SetBackdropBorderColor(1, 1, 1, 1)
                end
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
                GameTooltip:ClearLines()
                GameTooltip:AddLine(L["一键分配"], 1, 1, 1, true)
                if self.dis then
                    GameTooltip:AddLine(L["你不是物品分配者，不能使用"], 1, 0, 0, true)
                end
                if BG.IsVanilla() then
                    GameTooltip:AddLine(L["把全部掉落分配给自己，只对精良/史诗装备生效，其他类型的物品不会生效"], 1, 0.82, 0, true)
                else
                    GameTooltip:AddLine(L["把全部掉落分配给自己，只对史诗装备或套装兑换物生效，其他类型的物品不会生效（例如橙片、任务物品不会自动分配）"], 1, 0.82, 0, true)
                end
                GameTooltip:AddLine(BG.STC_dis(L["你可在插件设置-BiaoGe-其他功能里关闭这个功能"]), 1, 1, 1, true)

                local items = {}
                for li = 1, GetNumLootItems() do
                    if LootSlotHasItem(li) then
                        local itemLink = GetLootSlotLink(li)
                        if itemLink then
                            local name, link, quality, level, _, _, _, _, _, Texture, _, typeID, _, bindType = GetItemInfo(itemLink)
                            local itemID = GetItemInfoInstant(itemLink)

                            if (BG.IsVanilla() and (quality == 3 or quality == 4) or (BG.DeBug or quality == 4)) and (typeID == 2 or typeID == 4) then -- 紫色装备
                                tinsert(items, AddTexture(Texture, -3) .. link .. "|cffFFFFFF(" .. level .. ")|r")
                            elseif itemID == 45087 or itemID == 47556 or itemID == 49908 then                                                          -- 蓝色宝珠
                                tinsert(items, AddTexture(Texture, -3) .. link .. "|cffFFFFFF(" .. level .. ")|r")
                            else                                                                                                                       -- 套装兑换物
                                local yes
                                for _, FB in pairs(BG.FBtable) do
                                    if BG.Loot[FB].T then
                                        for k, _itemID in pairs(BG.Loot[FB].T) do
                                            if itemID == _itemID then
                                                tinsert(items, AddTexture(Texture, -3) .. link .. "|cffFFFFFF(" .. level .. ")|r")
                                                yes = true
                                                break
                                            end
                                        end
                                        if yes then
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                GameTooltip:AddLine(" ", 1, 1, 0, true)
                GameTooltip:AddLine(L["点击后会把这些物品分配给你："], 1, 1, 0, true)
                if #items ~= 0 then
                    for i, item in ipairs(items) do
                        GameTooltip:AddLine(i .. ". " .. item, 1, 1, 0)
                    end
                else
                    GameTooltip:AddLine(BG.STC_dis(L["没有符合条件的物品"]), 1, 1, 0, true)
                end
                GameTooltip:Show()
            end

            local function OnLeave(self)
                local bt = self.bt or self
                if bt:IsEnabled() then
                    bt:SetBackdropBorderColor(0, 1, 0, 1)
                end
                GameTooltip:Hide()
            end

            local parent = IsAddOnLoaded("ElvUI") and ElvLootFrame or LootFrame
            local bt = CreateFrame("Button", nil, parent, "BackdropTemplate")
            bt:SetBackdrop({
                edgeFile = "Interface/ChatFrame/ChatFrameBackground",
                edgeSize = 1,
            })
            bt:SetBackdropBorderColor(0, 1, 0, 1)
            bt:SetNormalFontObject(BG.FontGreen15)
            bt:SetDisabledFontObject(BG.FontDisabled)
            bt:SetHighlightFontObject(BG.FontHilight)
            bt:SetPoint("BOTTOM", parent, "TOP", 0, 0)
            bt:SetText(L["一键分配"])
            bt:SetSize(bt:GetFontString():GetWidth() + 10, 25)
            bt:Hide()
            bt:SetScript("OnClick", OnClick)
            bt:SetScript("OnEnter", OnEnter)
            bt:SetScript("OnLeave", OnLeave)

            local f = CreateFrame("Frame", nil, bt)
            f:SetAllPoints()
            f.dis = true
            f.bt = bt
            f:SetScript("OnEnter", OnEnter)
            f:SetScript("OnLeave", OnLeave)
            local disframe = f

            local function OnShow()
                if BiaoGe.options["allLootToMe"] ~= 1 then
                    bt:Hide()
                    disframe:Hide()
                    return
                end

                local yes, type = IsInInstance()
                if (BG.DeBug or yes) and GetLootMethod() == "master" then
                    bt:Show()
                    if BG.MasterLooter == UnitName("player") then
                        disframe:Hide()
                        bt:Enable()
                        bt:SetBackdropBorderColor(0, 1, 0, 1)
                    else
                        disframe:Show()
                        bt:Disable()
                        bt:SetBackdropBorderColor(RGB("808080"))
                    end
                else
                    bt:Hide()
                end
            end
            hooksecurefunc("LootFrame_Show", OnShow)
            if ElvLootFrame then
                ElvLootFrame:HookScript("OnShow", OnShow)
            end
        end)
    end
    ------------------一键举报脚本------------------
    do
        local yes
        local chattype
        local targetName, targetGUID
        local ChatPlayerGUIDs = {}
        local CLICKBUTTONTIME = 0.01
        -- local record = {
        --     type = "",
        --     liyou = "",
        --     xiangmu = "",
        --     edit = "",
        -- }

        -- 重置
        local function ReSet()
            yes = false
            chattype = nil
            targetName = nil
            targetGUID = nil
        end
        -- 举报
        local function SetReport(ReportType, unitorname, leader, playerLocation)
            if ReportType == Enum.ReportType.InWorld then
                if unitorname and UnitGUID(unitorname) then
                    local reportInfo = ReportInfo:CreateReportInfoFromType(ReportType)
                    ReportFrame:InitiateReport(reportInfo, UnitName(unitorname), PlayerLocation:CreateFromGUID(UnitGUID(unitorname)))
                end
            elseif ReportType == Enum.ReportType.Chat then
                if leader and playerLocation then
                    local reportInfo = ReportInfo:CreateReportInfoFromType(ReportType)
                    ReportFrame:InitiateReport(reportInfo, leader, playerLocation)
                else
                    local guid = ChatPlayerGUIDs[unitorname]
                    if guid then
                        local reportInfo = ReportInfo:CreateReportInfoFromType(ReportType)
                        ReportFrame:InitiateReport(reportInfo, unitorname, PlayerLocation:CreateFromGUID(guid))
                    end
                end
            end
        end
        -- 勾选举报项目
        local function SetCategoryButtonChecked(self, minorCategory)
            if self.minorCategory == minorCategory then
                self:SetChecked(true)
                self:GetParent():SetMinorCategoryFlag(self.minorCategory, self:GetChecked());
                return true
            end
        end
        -- 点击最后的举报按钮
        local function ReportButton_OnClick(self)
            local parent = self:GetParent();
            parent.ReportButton:UpdateButtonState()
            BG.After(CLICKBUTTONTIME, function()
                if parent.ReportButton:IsVisible() and parent.ReportButton:IsEnabled() then
                    parent.ReportButton:OnClick()
                end
            end)
        end

        hooksecurefunc(ReportFrame, "InitiateReport", function(self, reportInfo, name, playerLocation)
            -- wipe(record)
            -- record.type = reportInfo.reportType
            if not (yes and BiaoGe.options["report"] == 1) then return end
            if reportInfo.reportType == 1 then
                ToggleDropDownMenu(nil, nil, ReportFrameButton:GetParent())
                -- record.liyou = DropDownList1Button2:GetText()
                -- pt(DropDownList1Button2:GetText())
                UIDropDownMenuButton_OnClick(DropDownList1Button2)
                if ReportFrame.Comment.EditBox then
                    ReportFrame.Comment.EditBox:SetText("自动脚本\n自動腳本\nAutomatic Scripting")
                end
            elseif reportInfo.reportType == 0 then
                ToggleDropDownMenu(nil, nil, ReportFrameButton:GetParent())
                -- record.liyou = DropDownList1Button1:GetText()
                -- pt(DropDownList1Button1:GetText())
                UIDropDownMenuButton_OnClick(DropDownList1Button1)
                if chattype == "saorao" then
                    if ReportFrame.Comment.EditBox then
                        ReportFrame.Comment.EditBox:SetText("恶意骚扰\n惡意騷擾\nMalicious harassment")
                    end
                elseif chattype == "RMT" then
                    if ReportFrame.Comment.EditBox then
                        ReportFrame.Comment.EditBox:SetText("RMT")
                    end
                end
            end
            targetName = name
            if playerLocation then
                targetGUID = playerLocation:GetGUID()
            end
        end)

        hooksecurefunc(ReportingFrameMinorCategoryButtonMixin, "SetupButton", function(self)
            if not (yes and BiaoGe.options["report"] == 1) then return end
            if SetCategoryButtonChecked(self, 64) then
                -- pt(self:GetText())
                ReportButton_OnClick(self)
                return
            end
            if chattype == "saorao" then
                SetCategoryButtonChecked(self, 1)
                -- pt(self.Text:GetText())
                SetCategoryButtonChecked(self, 4)
                SetCategoryButtonChecked(self, 256)
                ReportButton_OnClick(self)
                return
            elseif chattype == "RMT" then
                SetCategoryButtonChecked(self, 1)
                -- pt(self.Text:GetText())
                SetCategoryButtonChecked(self, 4)
                SetCategoryButtonChecked(self, 256)
                SetCategoryButtonChecked(self, 2)
                ReportButton_OnClick(self)
                return
            end
        end)

        BG.RegisterEvent("REPORT_PLAYER_RESULT", function(self, even)
            if not (yes and BiaoGe.options["report"] == 1) then return end
            if targetGUID then
                local _type
                if chattype == "saorao" then
                    _type = L["恶意骚扰"]
                elseif chattype == "RMT" then
                    _type = "RMT"
                else
                    _type = L["自动脚本"]
                end

                local _, class = GetPlayerInfoByGUID(targetGUID)
                local _, _, _, color = GetClassColor(class)
                SendSystemMessage(format(L["已举报<%s>为%s。"], "|c" .. color .. targetName .. RR, _type))
                HideUIPanel(ReportFrame)
            end
        end)
        ReportFrame:HookScript("OnHide", function(self)
            ReSet()
        end)


        local function FindDropdownItem(dropdown, text)
            local name = dropdown:GetName()
            for i = 1, UIDROPDOWNMENU_MAXBUTTONS do
                local dropdownItem = _G[name .. 'Button' .. i]
                if dropdownItem:IsShown() and dropdownItem:GetText() == text then
                    return i, dropdownItem
                end
            end
        end
        local function UpdateButtons(mybuttontext, targetbuttontext, targetbuttontext2)
            local dropdownName = 'DropDownList' .. 1
            local dropdown = _G[dropdownName]
            local myindex1, mybutton1 = FindDropdownItem(dropdown, mybuttontext)
            local index, targetbutton = FindDropdownItem(dropdown, targetbuttontext)
            if not targetbutton then
                index, targetbutton = FindDropdownItem(dropdown, targetbuttontext2)
            end
            local x, y = select(4, targetbutton:GetPoint())
            y = y - UIDROPDOWNMENU_BUTTON_HEIGHT
            mybutton1:ClearAllPoints()
            mybutton1:SetPoint("TOPLEFT", x, y)

            for i = index + 1, UIDROPDOWNMENU_MAXBUTTONS do
                if i ~= myindex1 then
                    local dropdownItem = _G[dropdownName .. 'Button' .. i]
                    if dropdownItem:IsShown() then
                        local p, r, rp, x, y = dropdownItem:GetPoint(1)
                        dropdownItem:SetPoint(p, r, rp, x, y - UIDROPDOWNMENU_BUTTON_HEIGHT)
                    else
                        break
                    end
                end
            end
        end
        hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData)
            -- pt(which, unit, name, userData)
            if (BiaoGe.options["report"] ~= 1) then return end
            if (UIDROPDOWNMENU_MENU_LEVEL > 1) then return end
            if which ~= "SELF" and which ~= "FRIEND" and unit and UnitIsPlayer(unit) then -- 脚本
                local mybuttontext = L["一键举报脚本"]
                local info = UIDropDownMenu_CreateInfo()
                info.text = mybuttontext
                info.notCheckable = true
                info.tooltipTitle = L["自动帮你选择并填写举报内容"]
                info.tooltipText = format(L["选择举报理由：%s\n选择举报项目：%s\n填写举报细节：%s\n\n快捷命令：/BGReport\n\n|cff808080你可在插件设置-BiaoGe-其他功能里关闭这个功能。|r"],
                    REPORTING_MAJOR_CATEGORY_CHEATING, REPORTING_MINOR_CATEGORY_HACKING, "自动脚本 自動腳本 Automatic Scripting")
                info.func = function()
                    yes = true
                    BG.After(0.5, function()
                        ReSet()
                    end)
                    SetReport(Enum.ReportType.InWorld, unit)
                end
                UIDropDownMenu_AddButton(info)
                UpdateButtons(mybuttontext, REPORT_PLAYER)
            elseif which == "FRIEND" and not UnitIsUnit('player', Ambiguate(name, 'none')) then -- 骚扰
                local guid = ChatPlayerGUIDs[name]
                if guid then
                    local mybuttontext = L["一键举报RMT"]
                    local info = UIDropDownMenu_CreateInfo()
                    info.text = mybuttontext
                    info.notCheckable = true
                    info.tooltipTitle = L["自动帮你选择并填写举报内容"]
                    info.tooltipText = format(L["选择举报理由：%s\n选择举报项目：%s\n填写举报细节：%s\n\n|cff808080你可在插件设置-BiaoGe-其他功能里关闭这个功能。|r"],
                        REPORTING_MAJOR_CATEGORY_INAPPROPRIATE_COMMUNICATION,
                        REPORTING_MINOR_CATEGORY_TEXT_CHAT .. " " ..
                        REPORTING_MINOR_CATEGORY_SPAM .. " " ..
                        REPORTING_MINOR_CATEGORY_ADVERTISEMENT .. " " ..
                        REPORTING_MINOR_CATEGORY_BOOSTING,
                        "RMT")
                    info.func = function()
                        yes = true
                        chattype = "RMT"
                        BG.After(CLICKBUTTONTIME + 0.3, function()
                            ReSet()
                        end)
                        SetReport(Enum.ReportType.Chat, name)
                    end
                    UIDropDownMenu_AddButton(info)
                    UpdateButtons(mybuttontext, REPORT_PLAYER, IGNORE)

                    local mybuttontext = L["一键举报骚扰"]
                    local info = UIDropDownMenu_CreateInfo()
                    info.text = mybuttontext
                    info.notCheckable = true
                    info.tooltipTitle = L["自动帮你选择并填写举报内容"]
                    info.tooltipText = format(L["选择举报理由：%s\n选择举报项目：%s\n填写举报细节：%s\n\n|cff808080你可在插件设置-BiaoGe-其他功能里关闭这个功能。|r"],
                        REPORTING_MAJOR_CATEGORY_INAPPROPRIATE_COMMUNICATION,
                        REPORTING_MINOR_CATEGORY_TEXT_CHAT .. " " ..
                        REPORTING_MINOR_CATEGORY_SPAM .. " " ..
                        REPORTING_MINOR_CATEGORY_ADVERTISEMENT,
                        "恶意骚扰 惡意騷擾 Malicious harassment")
                    info.func = function()
                        yes = true
                        chattype = "saorao"
                        BG.After(CLICKBUTTONTIME + 0.3, function()
                            ReSet()
                        end)
                        SetReport(Enum.ReportType.Chat, name)
                    end
                    UIDropDownMenu_AddButton(info)
                    UpdateButtons(mybuttontext, REPORT_PLAYER, IGNORE)
                end
            end
        end)

        function BG.AddReportButton(ReportType, _chattype, leader, playerLocation, mybuttontext, tooltipText, func)
            local info = {}
            info.text = mybuttontext
            info.notCheckable = true
            info.tooltipTitle = L["自动帮你选择并填写举报内容"]
            info.tooltipText = tooltipText
            info.func = function()
                yes = true
                chattype = _chattype
                BG.After(CLICKBUTTONTIME + 0.3, function()
                    ReSet()
                end)
                SetReport(ReportType, nil, leader, playerLocation)
            end

            return info
        end

        -- 举报脚本快捷命令
        SlashCmdList["BIAOGEREPORT"] = function()
            if (BiaoGe.options["report"] ~= 1) then return end
            if UnitExists("target") then
                if UnitIsPlayer("target") then
                    yes = true
                    BG.After(CLICKBUTTONTIME + 0.3, function()
                        ReSet()
                    end)
                    local unit = "target"
                    SetReport(Enum.ReportType.InWorld, unit)
                else
                    UIErrorsFrame:AddMessage(L["该目标类型不是玩家。"], 1, 0, 0)
                end
            else
                UIErrorsFrame:AddMessage(L["你没有目标。"], 1, 0, 0)
            end
        end
        SLASH_BIAOGEREPORT1 = "/bgreport"

        -- 监听全部聊天频道，收集GUID
        do
            local f = CreateFrame("Frame")
            f:RegisterEvent("CHAT_MSG_CHANNEL")
            f:RegisterEvent("CHAT_MSG_YELL")
            f:RegisterEvent("CHAT_MSG_GUILD")
            f:RegisterEvent("CHAT_MSG_OFFICER")
            f:RegisterEvent("CHAT_MSG_PARTY")
            f:RegisterEvent("CHAT_MSG_PARTY_LEADER")
            f:RegisterEvent("CHAT_MSG_RAID")
            f:RegisterEvent("CHAT_MSG_RAID_LEADER")
            f:RegisterEvent("CHAT_MSG_RAID_WARNING")
            f:RegisterEvent("CHAT_MSG_SAY")
            f:RegisterEvent("CHAT_MSG_WHISPER")
            f:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
            f:RegisterEvent("CHAT_MSG_BN_WHISPER")
            f:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
            f:RegisterEvent("CHAT_MSG_INSTANCE_CHAT")
            f:RegisterEvent("CHAT_MSG_INSTANCE_CHAT_LEADER")
            f:SetScript("OnEvent", function(self, even, ...)
                local _, name = ...
                local guid = select(12, ...)
                if name and guid then
                    ChatPlayerGUIDs[name] = guid
                end
            end)
        end
    end
    ------------------清空表格------------------
    do
        -- 清空按钮
        do
            local bt = CreateFrame("Button", nil, BG.FBMainFrame, "UIPanelButtonTemplate")
            bt:SetSize(120, BG.ButtonZhangDan:GetHeight())
            bt:SetPoint("BOTTOMLEFT", BG.MainFrame, "BOTTOMLEFT", 30, select(5, BG.ButtonZhangDan:GetPoint()))
            bt:SetText(L["清空表格"])
            BG.ButtonQingKong = bt
            -- 按钮触发
            bt:SetScript("OnClick", function()
                local num = BG.QingKong("biaoge", BG.FB1)
                local name = "autoQingKong"
                if BiaoGe.options[name] == 1 then
                    SendSystemMessage(BG.STC_b1(format(L["已清空表格< %s >，分钱人数已改为%s人"], BG.GetFBlocalName(BG.FB1), num)))
                else
                    SendSystemMessage(BG.STC_b1(format(L["已清空表格< %s >"], BG.GetFBlocalName(BG.FB1))))
                end
                FrameHide(0)
                PlaySound(BG.sound1, "Master")
            end)
            bt:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
                GameTooltip:ClearLines()
                GameTooltip:AddLine(L["清空表格"], 1, 1, 1, true)
                GameTooltip:AddLine(L["一键清空全部装备、买家、金额，同时还清空关注和欠款"], 1, 0.82, 0, true)
                GameTooltip:Show()
            end)
            BG.GameTooltip_Hide(bt)
        end

        -- 自动清空表格
        do
            BG.RegisterEvent("ZONE_CHANGED_NEW_AREA", function()
                if BiaoGe.options["autoQingKong"] ~= 1 then return end

                BG.After(2, function()
                    local _, _, _, _, maxPlayers, _, _, instanceID = GetInstanceInfo()

                    local FB = BG.FBIDtable[instanceID]
                    if not FB then return end

                    local havedCD

                    for i = 1, GetNumSavedInstances() do
                        local _, _, _, _, locked, _, _, _, _maxPlayers, _, _, _, _, _instanceID = GetSavedInstanceInfo(i)
                        if locked and (instanceID == _instanceID) and (maxPlayers == _maxPlayers) then
                            havedCD = true
                            break
                        end
                    end
                    if not havedCD and not BG.BiaoGeIsEmpty(FB, "onlyboss") then
                        BG.ClickFBbutton(FB)
                        BG.SaveBiaoGe(FB)
                        local num = BG.QingKong("biaoge", FB)
                        local link = "|cffFFFF00|Hgarrmission:" .. "BiaoGe:" .. L["撤回清空"] .. ":" .. FB .. ":" .. time() ..
                            "|h[" .. L["撤回清空"] .. "]|h|r"
                        SendSystemMessage(BG.STC_b1(format(L["<BiaoGe> 已自动清空表格< %s >，分钱人数已改为%s人。原表格数据已保存至历史表格1。"], BG.GetFBinfo(FB, "localName"), num)) .. link)
                        PlaySoundFile(BG.sound_qingkong, "Master")
                    end
                end)
            end)

            local clicked = {}
            hooksecurefunc("SetItemRef", function(link)
                local _, BiaoGe, cehui, FB, time = strsplit(":", link)
                if not (BiaoGe == "BiaoGe" and cehui == L["撤回清空"] and FB) then return end
                if not clicked[time] then
                    clicked[time] = true
                    BG.SetBiaoGeFormHistory(FB, 1)
                    BG.DeleteHistory(FB, 1)
                    SendSystemMessage(BG.STC_b1(L["<BiaoGe> 已撤回清空，还原了表格数据，并删除了历史表格1。"]))
                    PlaySoundFile(BG.sound_cehuiqingkong, "Master")
                    BG.PlaySound(1)
                else
                    SendSystemMessage(BG.STC_b1(L["<BiaoGe>"]) .. " " .. BG.STC_r1(L["只能撤回一次。"]))
                end
            end)
        end
        -- 清空心愿
        do
            local bt = CreateFrame("Button", nil, BG.HopeMainFrame, "UIPanelButtonTemplate")
            bt:SetSize(120, BG.ButtonZhangDan:GetHeight())
            bt:SetPoint("BOTTOMLEFT", BG.MainFrame, "BOTTOMLEFT", 30, select(5, BG.ButtonZhangDan:GetPoint()))
            bt:SetText(L["清空心愿"])
            BG.ButtonHopeQingKong = bt
            -- 按钮触发
            bt:SetScript("OnClick", function()
                BG.QingKong("hope", BG.FB1)
                SendSystemMessage(BG.STC_g1(format(L["已清空心愿< %s >"], BG.GetFBlocalName(BG.FB1))))
                FrameHide(0)
                PlaySound(BG.sound1, "Master")
            end)
            bt:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
                GameTooltip:ClearLines()
                GameTooltip:AddLine(L["清空心愿"], 1, 1, 1, true)
                GameTooltip:AddLine(L["一键清空全部心愿装备"], 1, 0.82, 0, true)
                GameTooltip:Show()
            end)
            BG.GameTooltip_Hide(bt)
        end
    end

    ------------------初始显示------------------
    do
        if BiaoGe.lastFrame == "DuiZhang" then
            BG.ClickTabButton(BG.tabButtons, BG.DuiZhangMainFrameTabNum)
        elseif BiaoGe.lastFrame == "Hope" then
            BG.ClickTabButton(BG.tabButtons, BG.HopeMainFrameTabNum)
        elseif BiaoGe.lastFrame == "ItemLib" then
            BG.ClickTabButton(BG.tabButtons, BG.ItemLibMainFrameTabNum)
        elseif BiaoGe.lastFrame == "YY" then
            BG.ClickTabButton(BG.tabButtons, BG.YYMainFrameTabNum)
        elseif BiaoGe.lastFrame == "BOSS" then
            BG.ClickTabButton(BG.tabButtons, BG.BossMainFrameTabNum)
        else
            BG.ClickTabButton(BG.tabButtons, BG.FBMainFrameTabNum)
        end
    end
    ------------------检查版本过期------------------
    do
        -- 把版本号转换为纯数字
        local function Verabc(ver)
            local lastString = tonumber(strsub(ver, strlen(ver), strlen(ver)))
            if lastString then
                ver = ver .. "0"
            end
            ver = ver:gsub("a", 1)
            ver = ver:gsub("b", 2)
            ver = ver:gsub("c", 3)
            ver = ver:gsub("d", 4)
            ver = ver:gsub("e", 5)
            ver = ver:gsub("f", 6)
            ver = ver:gsub("g", 7)
            ver = ver:gsub("h", 8)
            ver = ver:gsub("i", 9)
            ver = ver:gsub("j", 10)
            ver = ver:gsub("k", 11)
            ver = ver:gsub("l", 12)
            ver = ver:gsub("m", 13)
            ver = ver:gsub("n", 14)
            ver = ver:gsub("o", 15)
            ver = ver:gsub("%D", "")
            ver = tonumber(ver)
            return ver
        end
        -- 比较版本
        local function VerGuoQi(BGVer, ver)
            if Verabc(ver) > Verabc(BGVer) then
                return true
            end
        end

        local function IsBetaVer()
            if strfind(strlower(BG.ver), "beta") then
                return true
            end
        end

        local yes
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("CHAT_MSG_ADDON")
        frame:SetScript("OnEvent", function(self, even, prefix, msg, channel, sender)
            if not (prefix == "BiaoGe" and channel == "GUILD") then return end
            local sendername = strsplit("-", sender)
            local playername = UnitName("player")
            if sendername == playername then return end
            if msg == "VersionCheck" and not IsBetaVer() then
                C_ChatInfo.SendAddonMessage("BiaoGe", "MyVer-" .. BG.ver, channel)
            elseif strfind(msg, "MyVer") and not IsBetaVer() then
                if yes then return end
                local _, version = strsplit("-", msg)
                if VerGuoQi(BG.ver, version) then
                    SendSystemMessage("|cff00BFFF" .. format(L["< BiaoGe > 你的当前版本%s已过期，请更新插件"] .. RR, BG.STC_r1(BG.ver)))
                    BG.ShuoMingShuText:SetText(L["<说明书与更新记录> "] .. BG.STC_r1(BG.ver))
                    yes = true
                end
            end
        end)

        local f = CreateFrame("Frame")
        f:RegisterEvent("PLAYER_ENTERING_WORLD")
        f:SetScript("OnEvent", function(self, even, isLogin, isReload)
            if not (isLogin or isReload) then return end
            -- 开始发送版本请求
            C_Timer.After(5, function()
                if IsInGuild() and not IsBetaVer() then
                    C_ChatInfo.SendAddonMessage("BiaoGe", "VersionCheck", "GUILD")
                end
            end)
            -- 10秒后关闭这个功能
            C_Timer.After(10, function()
                yes = true
            end)
        end)
    end
end

------------------刷新团队成员信息------------------
do
    BG.raidRosterInfo = {}
    BG.groupRosterInfo = {}

    function BG.UpdateRaidRosterInfo()
        wipe(BG.raidRosterInfo)
        wipe(BG.groupRosterInfo)

        BG.MasterLooter = nil
        BG.IsML = nil
        BG.IsLeader = nil

        if IsInRaid(1) then
            for i = 1, GetNumGroupMembers() do
                local name, rank, subgroup, level, class2, class, zone, online, isDead, role, isML, combatRole =
                    GetRaidRosterInfo(i)
                if name then
                    name = strsplit("-", name)
                    local a = {
                        name = name,
                        rank = rank,
                        subgroup = subgroup,
                        level = level,
                        class2 = class2,
                        class = class,
                        zone = zone,
                        online = online,
                        isDead = isDead,
                        role = role,
                        isML = isML,
                        combatRole = combatRole
                    }
                    table.insert(BG.raidRosterInfo, a)
                    if isML then
                        BG.MasterLooter = name
                    end
                    if name == UnitName("player") and (rank == 2 or isML) then
                        BG.IsML = true
                    end
                    if name == UnitName("player") and (rank == 2) then
                        BG.IsLeader = true
                    end
                end
            end
        elseif IsInGroup(1) then
            for i = 1, GetNumGroupMembers() do
                local name = UnitName("party" .. i)
                local _, class = UnitClass("party" .. i)
                local a = { name = name, class = class }
                table.insert(BG.groupRosterInfo, a)
            end
        end
    end

    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", function(self, even, ...)
        C_Timer.After(1, function()
            BG.UpdateRaidRosterInfo()
        end)
    end)
    local f = CreateFrame("Frame")
    f:RegisterEvent("GROUP_ROSTER_UPDATE")
    f:SetScript("OnEvent", function(self, even, ...)
        C_Timer.After(0.5, function()
            BG.UpdateRaidRosterInfo()
        end)
    end)

    C_Timer.NewTicker(3, function() -- 每3秒执行一次
        if not BG.raidRosterInfo or not BG.groupRosterInfo then return end
        local num = GetNumGroupMembers(1)
        local max
        if IsInRaid(1) then
            max = #BG.raidRosterInfo
        elseif IsInGroup(1) then
            max = #BG.groupRosterInfo
        end
        if tonumber(num) and tonumber(max) and tonumber(num) ~= tonumber(max) then
            BG.UpdateRaidRosterInfo()
        end
    end)
end

------------------插件载入------------------
do
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("ADDON_LOADED")
    frame:SetScript("OnEvent", function(self, event, addonName)
        if addonName == AddonName then
            BiaoGeUI()
            C_Timer.After(1, function()
                SendSystemMessage("|cff00BFFF" .. format(L["< BiaoGe > 金团表格载入成功。插件命令：%s或%s，小地图图标：%s"] .. RR, "/BiaoGe", "/GBG", L["星星"]))
            end)
        end
    end)

    -- 游戏按键设置
    BINDING_HEADER_BIAOGE = L["BiaoGe金团表格"]
    BINDING_NAME_BIAOGE = L["显示/关闭表格"]

    ------------------插件命令------------------
    SlashCmdList["BIAOGE"] = function()
        if BG.MainFrame and not BG.MainFrame:IsVisible() then
            BG.MainFrame:Show()
        else
            BG.MainFrame:Hide()
        end
    end
    SLASH_BIAOGE1 = "/biaoge"
    SLASH_BIAOGE2 = "/gbg"

    -- 解锁位置
    SlashCmdList["BIAOGEMOVE"] = function()
        BG.Move()
    end
    SLASH_BIAOGEMOVE1 = "/bgm"

    -- 设置
    SlashCmdList["BIAOGEOPTIONS"] = function()
        InterfaceOptionsFrame_OpenToCategory("|cff00BFFFBiaoGe|r")
        BG.MainFrame:Hide()
    end
    SLASH_BIAOGEOPTIONS1 = "/bgo"
end

--DEBUG
do
    SlashCmdList["BIAOGETEST"] = function()
        BG.DeBug = true
    end
    SLASH_BIAOGETEST1 = "/bgdebug"

    SlashCmdList["BIAOGETEST2"] = function()
    end
    SLASH_BIAOGETEST21 = "/bgdebug2"
end

--[[
BG.RegisterEvent("PLAYER_TARGET_CHANGED", function()
    if not UnitGUID("target") then return end
    local guidtype, _, _, instanceID, zoneID = string.split("-", UnitGUID("target"))
    if guidtype ~= "Creature" then return end
   -- print(zoneID)
    return zoneID
end)
 ]]

-- hooksecurefunc("SendChatMessage", function(arg1, arg2, arg3, arg4, arg5)
--     pt("Chat", arg1, arg2, arg3, arg4, arg5)
-- end)
-- hooksecurefunc(C_ChatInfo, "SendAddonMessage", function(arg1, arg2, arg3, arg4, arg5)
--     pt("Addon", arg1, arg2, arg3, arg4, arg5)
-- end)
--[[
/run SendChatMessage("1","RAID")
/run  C_ChatInfo.SendAddonMessage("BiaoGeAuction","GetAuctioning","RAID")
 ]]



--[[
-- 快速更换符文
local IsHooks = {}
local IsOnClick

local function GetHearderNum(skillLineAbilityID)
    local categories = C_Engraving.GetRuneCategories(true, true);
    for i, category in ipairs(categories) do
        local runes = C_Engraving.GetRunesForCategory(category, true);
        for _, rune in ipairs(runes) do
            if rune.skillLineAbilityID == skillLineAbilityID then
                return category
            end
        end
    end
end

local function HookRuneClick()
    local i = 1
    while _G["EngravingFrameScrollFrameButton" .. i] do
        if not IsHooks[i] then
            local bt = _G["EngravingFrameScrollFrameButton" .. i]
            bt:HookScript("OnClick", function(self)
                if InCombatLockdown() then return end
                if IsAltKeyDown() then
                    pt(self.skillLineAbilityID)
                    IsOnClick = true
                    UseInventoryItem(GetHearderNum(self.skillLineAbilityID))
                    C_Timer.After(1, function()
                        IsOnClick = false
                    end)
                end
            end)
            IsHooks[i] = true
        end
        i = i + 1
    end
end

hooksecurefunc("StaticPopup_Show", function(...)
    if not IsOnClick then return end
    local frameName = ...
    if frameName == "REPLACE_ENCHANT" then
        local text = REPLACE_ENCHANT:gsub("%%s", "(.+)"):gsub("%%s", "(.+)")
        for i = 1, 10 do
            if _G["StaticPopup" .. i .. "Text"] and _G["StaticPopup" .. i .. "Text"]:GetText() and
                strmatch(_G["StaticPopup" .. i .. "Text"]:GetText(), text) then
                StaticPopup_OnClick(_G["StaticPopup" .. i], 1)
            end
        end
    end
end)

BG.RegisterEvent("ENGRAVING_MODE_CHANGED", function()
    if EngravingFrameScrollFrame:IsVisible() then
        HookRuneClick()
    end
end)
 ]]

-- BG.RegisterEvent("PLAYER_ENTERING_WORLD", function()
--     C_Engraving.RefreshRunesList()
--     C_Engraving.SetSearchFilter("")

--     local categories = C_Engraving.GetRuneCategories(true, true);
--     for i, category in ipairs(categories) do
--         local runes = C_Engraving.GetRunesForCategory(category, true);
--         for _, rune in ipairs(runes) do
--             pt(rune.skillLineAbilityID)
--         end
--     end
-- end)

-- local f = CreateFrame("Frame", nil, UIParent, "InsetFrameTemplate3")
-- f:SetSize(500, 300)
-- f:SetPoint("CENTER", nil, "CENTER", 0, 0)
-- local tex = UIParent:CreateTexture()
-- tex:SetPoint("CENTER")
-- tex:SetTexture(131089)
-- tex:SetTexCoord(0, 0.5, 0.5, 1)

-- hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData)
-- end)
