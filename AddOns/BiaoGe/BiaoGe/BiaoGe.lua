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

BG.ver = "v1.5.8"
BG.instructionsText = ADDONSELF.instructionsText
BG.upDateText = ADDONSELF.upDateText

local function BiaoGeUI()
    ------------------主界面------------------
    do
        BG.MainFrame = CreateFrame("Frame", "BG.MainFrame", UIParent, "BasicFrameTemplate")
        BG.MainFrame:SetWidth(Width["BG.MainFrame"])
        BG.MainFrame:SetHeight(Height["BG.MainFrame"])
        BG.MainFrame:SetPoint("CENTER")
        BG.MainFrame:SetFrameLevel(100)
        BG.MainFrame:SetMovable(true)
        BG.MainFrame:SetToplevel(true)
        BG.MainFrame:SetScript("OnMouseUp", function(self)
            self:StopMovingOrSizing()
        end)
        BG.MainFrame:SetScript("OnMouseDown", function(self)
            FrameHide(0)
            BG.ClearFocus()
            self:StartMoving()
        end)
        BG.MainFrame:SetScript("OnHide", function(self)
            FrameHide(0)
            BG.copy1 = nil
            BG.copy2 = nil
            if BG.copyButton then
                BG.copyButton:Hide()
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
        frame:SetSize(0, 30)
        frame:SetPoint("TOPLEFT", BG.MainFrame, "TOPLEFT", 5, 4)
        frame:SetHitRectInsets(0, 0, 0, 0)
        local fontString = frame:CreateFontString()
        fontString:SetPoint("CENTER")
        fontString:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
        fontString:SetJustifyH("LEFT")
        fontString:SetText(L["<说明书与更新记录> "] .. BG.STC_g1(BG.ver))
        frame:SetWidth(fontString:GetStringWidth())
        BG.ShuoMingShu = frame
        BG.ShuoMingShuText = fontString

        local function OnEnter(self)
            self.OnEnter = true
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -(frame:GetWidth() + 5) * BiaoGe.options.scale, 0)
            GameTooltip:ClearLines()
            if IsAltKeyDown() then
                GameTooltip:SetText(BG.upDateText)
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
            BG.FB1 = BiaoGe.FB
        else
            BG.FB1 = "TOC"
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
        BG.ReceiveMainFrame:SetWidth(Width["BG.MainFrame"])
        BG.ReceiveMainFrame:SetHeight(Height["BG.MainFrame"])
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
    end
    ------------------二级Frame------------------
    do
        BG.FBMainFrame = CreateFrame("Frame", "BG.FBMainFrame", BG.MainFrame) -- 当前表格
        BG.FBMainFrame:Hide()
        BG.FrameNAXX = CreateFrame("Frame", "BG.FrameNAXX", BG.FBMainFrame)
        BG.FrameULD = CreateFrame("Frame", "BG.FrameULD", BG.FBMainFrame)
        BG.FrameTOC = CreateFrame("Frame", "BG.FrameTOC", BG.FBMainFrame)
        BG.FrameICC = CreateFrame("Frame", "BG.FrameICC", BG.FBMainFrame)
        BG.FrameNAXX:Hide()
        BG.FrameULD:Hide()
        BG.FrameTOC:Hide()
        BG.FrameICC:Hide()
        BG.FBMainFrame:SetScript("OnShow", function(self)
            local FB = BG.FB1
            BG.FrameNAXX:Hide()
            BG.FrameULD:Hide()
            BG.FrameTOC:Hide()
            BG.FrameICC:Hide()
            BG["Frame" .. FB]:Show()
            BG.SetMainFrameDS(nil, 0)
            BiaoGe.lastFrame = "FB"

            BG.HistoryMainFrame:Hide()
            BG.Title:Show()
            BG.History.YongButton:Hide()
            BG.History.EscButton:Hide()
            BG.History.List:Hide()

            BG.History.HistoryButton:Show()
            BG.History.SaveButton:Show()
            BG.History.SendButton:Show()
            BG.History.DaoChuButton:Show()
            BG.History.HistoryButton:SetEnabled(true)
            BG.History.SaveButton:SetEnabled(true)
            BG.History.SendButton:SetEnabled(true)
            BG.History.DaoChuButton:SetEnabled(true)

            BG.ButtonZhangDan:Show()
            BG.ButtonLiuPai:Show()
            BG.ButtonXiaoFei:Show()
            BG.ButtonYongShi:Show()
            BG.ButtonWCL:Show()
            BG.ButtonQianKuan:Show()

            BG.ButtonZhangDan:SetEnabled(true)
            BG.ButtonLiuPai:SetEnabled(true)
            BG.ButtonXiaoFei:SetEnabled(true)
            BG.ButtonYongShi:SetEnabled(true)
            BG.ButtonWCL:SetEnabled(true)
            BG.ButtonQianKuan:SetEnabled(true)

            BG.TabButtonsFB:Show()
            BG.ButtonICC:SetEnabled(true)
            BG.ButtonTOC:SetEnabled(true)
            BG.ButtonULD:SetEnabled(true)
            BG.ButtonNAXX:SetEnabled(true)
            BG["Button" .. BG.FB1]:SetEnabled(false)

            BG.ButtonQingKong:Show()
            BG.ButtonQingKong:SetEnabled(true)
            BG.ButtonQingKong:SetText(L["清空当前表格"])
            BG.NanDuDropDown.DropDown:Show()
            LibBG:UIDropDownMenu_EnableDropDown(BG.NanDuDropDown.DropDown)
            BG.frameFilterIcon:Show()
        end)


        BG.DuiZhangMainFrame = CreateFrame("Frame", "BG.DuiZhangMainFrame", BG.MainFrame) -- 对账
        BG.DuiZhangMainFrame:Hide()
        BG.DuiZhangFrameNAXX = CreateFrame("Frame", "BG.DuiZhangFrameNAXX", BG.DuiZhangMainFrame)
        BG.DuiZhangFrameULD = CreateFrame("Frame", "BG.DuiZhangFrameULD", BG.DuiZhangMainFrame)
        BG.DuiZhangFrameTOC = CreateFrame("Frame", "BG.DuiZhangFrameTOC", BG.DuiZhangMainFrame)
        BG.DuiZhangFrameICC = CreateFrame("Frame", "BG.DuiZhangFrameICC", BG.DuiZhangMainFrame)
        BG.DuiZhangFrameNAXX:Hide()
        BG.DuiZhangFrameULD:Hide()
        BG.DuiZhangFrameTOC:Hide()
        BG.DuiZhangFrameICC:Hide()
        BG.DuiZhangMainFrame:SetScript("OnShow", function(self)
            local FB = BG.FB1
            BG.DuiZhangFrameNAXX:Hide()
            BG.DuiZhangFrameULD:Hide()
            BG.DuiZhangFrameTOC:Hide()
            BG.DuiZhangFrameICC:Hide()
            BG["DuiZhangFrame" .. FB]:Show()
            BG.SetMainFrameDS("duizhang", 1)
            if BG.duizhangNum then
                BG.DuiZhangSet(BG.duizhangNum)
            end
            BiaoGe.lastFrame = "DuiZhang"

            BG.HistoryMainFrame:Hide()
            BG.Title:Show()
            BG.History.YongButton:Hide()
            BG.History.EscButton:Hide()
            BG.History.List:Hide()

            BG.History.HistoryButton:Hide()
            BG.History.SaveButton:Hide()
            BG.History.SendButton:Hide()
            BG.History.DaoChuButton:Hide()

            BG.ButtonZhangDan:Show()
            BG.ButtonLiuPai:Show()
            BG.ButtonXiaoFei:Show()
            BG.ButtonYongShi:Show()
            BG.ButtonWCL:Show()
            BG.ButtonQianKuan:Show()

            BG.ButtonZhangDan:SetEnabled(true)
            BG.ButtonLiuPai:SetEnabled(true)
            BG.ButtonXiaoFei:SetEnabled(true)
            BG.ButtonYongShi:SetEnabled(true)
            BG.ButtonWCL:SetEnabled(true)
            BG.ButtonQianKuan:SetEnabled(true)

            BG.TabButtonsFB:Hide()

            BG.ButtonQingKong:Hide()
            BG.NanDuDropDown.DropDown:Hide()
            BG.frameFilterIcon:Hide()
        end)


        BG.HopeMainFrame = CreateFrame("Frame", "BG.HopeMainFrame", BG.MainFrame) -- 心愿清单
        BG.HopeMainFrame:Hide()
        BG.HopeFrameNAXX = CreateFrame("Frame", "BG.HopeFrameNAXX", BG.HopeMainFrame)
        BG.HopeFrameULD = CreateFrame("Frame", "BG.HopeFrameULD", BG.HopeMainFrame)
        BG.HopeFrameTOC = CreateFrame("Frame", "BG.HopeFrameTOC", BG.HopeMainFrame)
        BG.HopeFrameICC = CreateFrame("Frame", "BG.HopeFrameICC", BG.HopeMainFrame)
        BG.HopeFrameNAXX:Hide()
        BG.HopeFrameULD:Hide()
        BG.HopeFrameTOC:Hide()
        BG.HopeFrameICC:Hide()
        BG.HopeMainFrame:SetScript("OnShow", function(self)
            local FB = BG.FB1
            BG.HopeFrameNAXX:Hide()
            BG.HopeFrameULD:Hide()
            BG.HopeFrameTOC:Hide()
            BG.HopeFrameICC:Hide()
            BG["HopeFrame" .. FB]:Show()
            BG.SetMainFrameDS("hope", 1)
            BiaoGe.lastFrame = "Hope"

            BG.HistoryMainFrame:Hide()
            BG.Title:Show()
            BG.History.YongButton:Hide()
            BG.History.EscButton:Hide()
            BG.History.List:Hide()

            BG.History.HistoryButton:Hide()
            BG.History.SaveButton:Hide()
            BG.History.SendButton:Hide()
            BG.History.DaoChuButton:Hide()

            BG.ButtonZhangDan:Hide()
            BG.ButtonLiuPai:Hide()
            BG.ButtonXiaoFei:Hide()
            BG.ButtonYongShi:Hide()
            BG.ButtonWCL:Hide()
            BG.ButtonQianKuan:Hide()

            BG.TabButtonsFB:Show()
            BG.ButtonICC:SetEnabled(true)
            BG.ButtonTOC:SetEnabled(true)
            BG.ButtonULD:SetEnabled(true)
            BG.ButtonNAXX:SetEnabled(true)
            BG["Button" .. BG.FB1]:SetEnabled(false)

            BG.ButtonQingKong:Show()
            BG.ButtonQingKong:SetText(L["清空当前心愿"])
            BG.NanDuDropDown.DropDown:Show()
            BG.frameFilterIcon:Show()
        end)


        BG.YYMainFrame = CreateFrame("Frame", "BG.YYMainFrame", BG.MainFrame) -- YY评价
        BG.YYMainFrame:Hide()
        BG.YYMainFrame:SetScript("OnShow", function(self)
            local FB = BG.FB1
            BG.SetMainFrameDS("yy", 1)
            BiaoGe.lastFrame = "YY"

            BG.HistoryMainFrame:Hide()
            BG.Title:Show()
            BG.History.YongButton:Hide()
            BG.History.EscButton:Hide()
            BG.History.List:Hide()

            BG.History.HistoryButton:Hide()
            BG.History.SaveButton:Hide()
            BG.History.SendButton:Hide()
            BG.History.DaoChuButton:Hide()

            BG.ButtonZhangDan:Hide()
            BG.ButtonLiuPai:Hide()
            BG.ButtonXiaoFei:Hide()
            BG.ButtonYongShi:Hide()
            BG.ButtonWCL:Hide()
            BG.ButtonQianKuan:Hide()

            BG.TabButtonsFB:Hide()

            BG.ButtonQingKong:Hide()
            BG.NanDuDropDown.DropDown:Hide()
            BG.frameFilterIcon:Hide()
        end)


        BG.BossMainFrame = CreateFrame("Frame", "BG.HopeMainFrame", BG.MainFrame) -- 团本攻略
        BG.BossMainFrame:Hide()
        BG.BossFrameNAXX = CreateFrame("Frame", "BG.BossFrameNAXX", BG.BossMainFrame)
        BG.BossFrameULD = CreateFrame("Frame", "BG.BossFrameULD", BG.BossMainFrame)
        BG.BossFrameTOC = CreateFrame("Frame", "BG.BossFrameTOC", BG.BossMainFrame)
        BG.BossFrameICC = CreateFrame("Frame", "BG.BossFrameICC", BG.BossMainFrame)
        BG.BossFrameNAXX:Hide()
        BG.BossFrameULD:Hide()
        BG.BossFrameTOC:Hide()
        BG.BossFrameICC:Hide()
        BG.BossMainFrame:SetScript("OnShow", function(self)
            local FB = BG.FB1
            BG.BossFrameNAXX:Hide()
            BG.BossFrameULD:Hide()
            BG.BossFrameTOC:Hide()
            BG.BossFrameICC:Hide()
            BG["BossFrame" .. FB]:Show()
            BG.SetMainFrameDS(nil, 0)
            BiaoGe.lastFrame = "BOSS"

            BG.HistoryMainFrame:Hide()
            BG.Title:Show()
            BG.History.YongButton:Hide()
            BG.History.EscButton:Hide()
            BG.History.List:Hide()

            BG.History.HistoryButton:Hide()
            BG.History.SaveButton:Hide()
            BG.History.SendButton:Hide()
            BG.History.DaoChuButton:Hide()

            BG.ButtonZhangDan:Hide()
            BG.ButtonLiuPai:Hide()
            BG.ButtonXiaoFei:Hide()
            BG.ButtonYongShi:Hide()
            BG.ButtonWCL:Hide()
            BG.ButtonQianKuan:Hide()

            BG.TabButtonsFB:Show()
            BG.ButtonICC:SetEnabled(true)
            BG.ButtonTOC:SetEnabled(true)
            BG.ButtonULD:SetEnabled(true)
            BG.ButtonNAXX:SetEnabled(true)
            BG["Button" .. BG.FB1]:SetEnabled(false)

            BG.ButtonQingKong:Hide()
            BG.NanDuDropDown.DropDown:Hide()
            BG.frameFilterIcon:Hide()
        end)


        BG.HistoryMainFrame = CreateFrame("Frame", "BG.HistoryMainFrame", BG.MainFrame) -- 历史表格
        BG.HistoryMainFrame:Hide()
        BG.HistoryFrameNAXX = CreateFrame("Frame", "BG.HistoryFrameNAXX", BG.HistoryMainFrame)
        BG.HistoryFrameULD = CreateFrame("Frame", "BG.HistoryFrameULD", BG.HistoryMainFrame)
        BG.HistoryFrameTOC = CreateFrame("Frame", "BG.HistoryFrameTOC", BG.HistoryMainFrame)
        BG.HistoryFrameICC = CreateFrame("Frame", "BG.HistoryFrameICC", BG.HistoryMainFrame)
        BG.HistoryFrameNAXX:Hide()
        BG.HistoryFrameULD:Hide()
        BG.HistoryFrameTOC:Hide()
        BG.HistoryFrameICC:Hide()
        BG.HistoryMainFrame:SetScript("OnShow", function(self)
            local FB = BG.FB1
            BG.HistoryFrameNAXX:Hide()
            BG.HistoryFrameULD:Hide()
            BG.HistoryFrameTOC:Hide()
            BG.HistoryFrameICC:Hide()
            BG["HistoryFrame" .. FB]:Show()
            BG.FBMainFrame:Hide()

            BG.Title:Hide()
            BG.History.SaveButton:SetEnabled(false)
            BG.History.YongButton:Show()
            BG.History.EscButton:Show()

            BG.ButtonZhangDan:SetEnabled(false)
            BG.ButtonLiuPai:SetEnabled(false)
            BG.ButtonXiaoFei:SetEnabled(false)
            BG.ButtonYongShi:SetEnabled(false)
            BG.ButtonWCL:SetEnabled(false)
            BG.ButtonQianKuan:SetEnabled(false)

            BG.ButtonICC:SetEnabled(false)
            BG.ButtonTOC:SetEnabled(false)
            BG.ButtonULD:SetEnabled(false)
            BG.ButtonNAXX:SetEnabled(false)

            BG.ButtonQingKong:SetEnabled(false)
            LibBG:UIDropDownMenu_DisableDropDown(BG.NanDuDropDown.DropDown)
        end)


        BG.ReceiveFrameNAXX = CreateFrame("Frame", "BG.ReceiveFrameNAXX", BG.ReceiveMainFrame) -- 接收表格
        BG.ReceiveFrameULD = CreateFrame("Frame", "BG.ReceiveFrameULD", BG.ReceiveMainFrame)
        BG.ReceiveFrameTOC = CreateFrame("Frame", "BG.ReceiveFrameTOC", BG.ReceiveMainFrame)
        BG.ReceiveFrameICC = CreateFrame("Frame", "BG.ReceiveFrameICC", BG.ReceiveMainFrame)
        BG.ReceiveFrameNAXX:Hide()
        BG.ReceiveFrameULD:Hide()
        BG.ReceiveFrameTOC:Hide()
        BG.ReceiveFrameICC:Hide()

        -- 表格底色
        local f = CreateFrame("Frame", "BG.MainFrameDs", BG.MainFrame, "BackdropTemplate")
        f:SetBackdrop({
            bgFile = "Interface/ChatFrame/ChatFrameBackground",
        })
        f:SetPoint("CENTER")
        f:Hide()
        BG["MainFrameDs"] = f

        -- local f = CreateFrame("Frame", nil, BG.FBMainFrame, "InsetFrameTemplate3")
        -- f:SetPoint("TOPLEFT", BG.MainFrame, "TOPLEFT", 3, -53)
        -- f:SetPoint("BOTTOMRIGHT", BG.MainFrame, "BOTTOMRIGHT", -8, 75)
    end
    ------------------设置------------------
    do
        local bt = CreateFrame("Button", nil, BG.MainFrame)
        bt:SetSize(50, 30)
        bt:SetPoint("TOPLEFT", BG.ShuoMingShu, "TOPRIGHT", 20, 0)
        bt:SetNormalFontObject(BG.FontGreen1)
        bt:SetDisabledFontObject(BG.FontDisabled)
        bt:SetHighlightFontObject(BG.FontHilight)
        bt:SetText(L["设置"])
        BG.ButtonSheZhi = bt

        bt:SetScript("OnClick", function(self)
            InterfaceOptionsFrame_OpenToCategory(L["BiaoGe"] or "|cff00BFFFBiaoGe|r")
            BG.MainFrame:Hide()
            PlaySound(BG.sound1, "Master")
        end)
        bt:SetScript("OnEnter", function(self)
            local text = L["快捷命令：/BGO"]
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -50 * BiaoGe.options.scale, 0)
            GameTooltip:ClearLines()
            GameTooltip:SetText(text)
        end)
        BG.GameTooltip_Hide(bt)
    end
    ------------------通知移动------------------
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
                    local name, link, quality, level, _, _, _, _, _, Texture, _, typeID = GetItemInfo(49623)
                    local FB = "ICC"
                    local num = 12
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
                                name, link, quality, level, _, _, _, _, _, Texture, _, typeID = GetItemInfo(49623)
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
        bt:SetSize(70, 30)
        bt:SetPoint("TOPLEFT", BG.ButtonSheZhi, "TOPRIGHT", 20, 0)
        bt:SetNormalFontObject(BG.FontGreen1)
        bt:SetDisabledFontObject(BG.FontDisabled)
        bt:SetHighlightFontObject(BG.FontHilight)
        bt:SetText(L["通知移动"])
        BG.ButtonMove = bt
        bt:SetScript("OnClick", BG.Move)
        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -70 * BiaoGe.options.scale, 0)
            GameTooltip:ClearLines()
            GameTooltip:SetText(L["调整装备记录通知和交易通知的位置\n快捷命令：/BGM"])
        end)
        bt:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)
        GetItemInfo(49623) -- 提前缓存
    end
    ------------------难度选择菜单------------------
    do
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
                local _, type = IsInInstance()
                if type ~= "raid" then
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
            AddButton(4, L["25人|cff00BFFF普通|r"], 12880)
            AddButton(5, L["10人|cffFF0000英雄|r"], 12873)
            AddButton(6, L["25人|cffFF0000英雄|r"], 12873)
        end)

        LibBG:UIDropDownMenu_SetAnchor(dropDown, 0, 0, "BOTTOM", dropDown, "TOP")
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
    ------------------副本切换按钮------------------
    do
        -- 按钮
        do
            local buttonsWidth = 0
            local last

            local function Create_FBButton(fbID)
                local bt = CreateFrame("Button", nil, BG.TabButtonsFB, "BackdropTemplate")
                bt:SetHeight(bt:GetParent():GetHeight())
                bt:SetNormalFontObject(BG.FontBlue1)
                bt:SetDisabledFontObject(BG.FontWhile2)
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
                -- local tex = bt:CreateTexture()
                -- tex:SetColorTexture(RGB("FFFFFF", 0.1))
                -- bt:SetHighlightTexture(tex)
                local tex = bt:CreateTexture(nil, "ARTWORK") -- 高亮材质
                tex:SetTexture("interface/paperdollinfoframe/ui-character-tab-highlight")
                bt:SetHighlightTexture(tex)
                last = bt
                return bt
            end

            BG.TabButtonsFB = CreateFrame("Frame", nil, BG.MainFrame)
            BG.TabButtonsFB:SetPoint("TOP", BG.MainFrame, "TOP", 0, -28)
            BG.TabButtonsFB:SetHeight(20)

            local bt = Create_FBButton(533)
            BG.ButtonNAXX = bt

            local bt = Create_FBButton(603)
            BG.ButtonULD = bt

            local bt = Create_FBButton(649)
            BG.ButtonTOC = bt

            local bt = Create_FBButton(631)
            BG.ButtonICC = bt

            BG["Button" .. BG.FB1]:SetEnabled(false)

            local l = BG.ButtonNAXX:CreateLine()
            l:SetColorTexture(RGB("D3D3D3", 0.8))
            l:SetStartPoint("BOTTOMLEFT", BG.ButtonNAXX, -30, -3)
            l:SetEndPoint("BOTTOMRIGHT", BG.ButtonICC, 30, -3)
            l:SetThickness(1.5)
            BG.LineFB = l
        end

        -- 副本切换单击触发
        do
            function BG.ClickFBbutton(FB)
                FrameHide(0)
                if BG.FBMainFrame:IsVisible() then
                    BG.FrameICC:Hide()
                    BG.FrameTOC:Hide()
                    BG.FrameULD:Hide()
                    BG.FrameNAXX:Hide()
                    BG["Frame" .. FB]:Show()
                elseif BG.HopeMainFrame:IsVisible() then
                    BG.HopeFrameICC:Hide()
                    BG.HopeFrameTOC:Hide()
                    BG.HopeFrameULD:Hide()
                    BG.HopeFrameNAXX:Hide()
                    BG["HopeFrame" .. FB]:Show()
                elseif BG.BossMainFrame:IsVisible() then
                    BG.BossFrameNAXX:Hide()
                    BG.BossFrameULD:Hide()
                    BG.BossFrameTOC:Hide()
                    BG.BossFrameICC:Hide()
                    BG["BossFrame" .. FB]:Show()
                end

                BG.ButtonICC:SetEnabled(false)
                BG.ButtonTOC:SetEnabled(false)
                BG.ButtonULD:SetEnabled(false)
                BG.ButtonNAXX:SetEnabled(false)
                C_Timer.After(0.5, function()
                    BG.ButtonICC:SetEnabled(true)
                    BG.ButtonTOC:SetEnabled(true)
                    BG.ButtonULD:SetEnabled(true)
                    BG.ButtonNAXX:SetEnabled(true)
                    BG["Button" .. FB]:SetEnabled(false)
                end)
                BG.FB1 = FB
                BiaoGe.FB = FB
                BG.History.HistoryButton:SetFormattedText(L["历史表格（共%d个）"], #BiaoGe.HistoryList[FB])
                BG.CreatHistoryListButton(FB)
                FrameDongHua(BG.MainFrame, Height[FB], Width[FB])

                BG.FBfilter()

                BG.duizhangNum = nil
                LibBG:UIDropDownMenu_SetText(BG.DuiZhangDropDown.DropDown, L["无"])
                BG.DuiZhang0()

                if BG.HopeSenddropDown and BG.HopeSenddropDown[FB] then
                    LibBG:UIDropDownMenu_SetText(BG.HopeSenddropDown[FB], BG.HopeSendTable[BiaoGe["HopeSendChannel"]])
                end
            end

            BG.ButtonICC:SetScript("OnClick", function(self) -- ICC
                BG.ClickFBbutton("ICC")
                PlaySound(BG.sound1, "Master")
            end)

            BG.ButtonTOC:SetScript("OnClick", function(self) -- TOC
                BG.ClickFBbutton("TOC")
                PlaySound(BG.sound1, "Master")
            end)

            BG.ButtonULD:SetScript("OnClick", function(self) -- ULD
                BG.ClickFBbutton("ULD")
                PlaySound(BG.sound1, "Master")
            end)

            BG.ButtonNAXX:SetScript("OnClick", function(self) -- NAXX
                BG.ClickFBbutton("NAXX")
                PlaySound(BG.sound1, "Master")
            end)
        end
    end
    ------------------底部选项卡------------------
    do
        BG.tabButtons = {}

        function BG.ClickTabButton(tabButtons, num)
            for i, v in pairs(tabButtons) do
                if i == num then
                    PanelTemplates_SelectTab(v.button)
                    v.frame:Show()
                    BG.tabButtonsHilight:SetParent(v.button)
                    BG.tabButtonsHilight:ClearAllPoints()
                    BG.tabButtonsHilight:SetPoint("TOPLEFT", 14, 0)
                    BG.tabButtonsHilight:SetPoint("BOTTOMRIGHT", -14, 10)
                    BG.tabButtonsHilight:Show()
                else
                    PanelTemplates_DeselectTab(v.button)
                    v.frame:Hide()
                end
            end
        end

        local function Create_TabButton(num, text, frame, width) -- 1,L["当前表格 "],BG["Frame" .. BG.FB1],150
            local bt = CreateFrame("Button", "BiaoGeTab" .. num, BG.MainFrame, "CharacterFrameTabButtonTemplate")
            bt:SetText(text)
            PanelTemplates_TabResize(bt, nil, width or 130)
            if num == 1 then
                bt:SetPoint("TOPLEFT", BG.MainFrame, "BOTTOM", -280, 0)
            else
                bt:SetPoint("LEFT", BG.tabButtons[num - 1].button, "RIGHT", -10, 0)
            end
            BG.tabButtons[num] = {
                button = bt,
                frame = frame
            }
            -- bt:SetScript("OnLoad", nil)
            bt:SetScript("OnEvent", nil)
            bt:SetScript("OnShow", nil)
            bt:SetScript("OnClick", function(self)
                BG.ClickTabButton(BG.tabButtons, num)
                PlaySound(BG.sound1, "Master")
            end)

            if not BG.tabButtonsHilight then
                local texture = bt:CreateTexture(nil, "ARTWORK") -- 高亮材质
                texture:SetTexture("interface/paperdollinfoframe/ui-character-tab-highlight")
                texture:SetTexCoord(0, 1, 0.1, 0.9)
                texture:Hide()
                BG.tabButtonsHilight = texture
            end

            return bt
        end

        local bt = Create_TabButton(1, L["当前表格"], BG.FBMainFrame)
        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:SetText(L["|cffffffff< 当前表格 >|r\n\n1、表格的核心功能都在这里"])
        end)
        local bt = Create_TabButton(2, L["心愿清单"], BG.HopeMainFrame)
        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:SetText(L["|cffffffff< 心愿清单 >|r\n\n1、你可以设置一些装备，\n    这些装备只要掉落就会有提醒，\n    并且掉落后自动关注团长拍卖\n"])
        end)
        local bt = Create_TabButton(3, L["对账"], BG.DuiZhangMainFrame)
        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:SetText(L["|cffffffff< 对账 >|r\n\n1、当团队有人通报BiaoGe/RaidLedger/大脚的账单，\n    你可以选择该账单，来对账\n2、只对比装备收入，不对比罚款收入，也不对比支出\n3、别人账单会自动保存1天，过后自动删除\n"])
        end)
        local bt = Create_TabButton(4, L["YY评价"], BG.YYMainFrame)
        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:SetText(L["|cffffffff< YY评价 >|cff808080（右键：开启/关闭该模块）|r|r\n\n1、你可以给YY频道做评价，帮助别人辨别该团好与坏\n2、你可以查询YY频道的大众评价\n3、聊天频道的YY号变为超链接，方便你复制该号码或查询大众评价\n4、替换集结号的评价框，击杀当前版本团本尾王后弹出\n"])
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
                                JoinChannelByName(YY)
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
        local bt = Create_TabButton(5, L["团本攻略"], BG.BossMainFrame)
        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:SetText(L["|cffffffff< 团本攻略 >|r\n\n1、了解BOSS技能和应对策略、职业职责\n"])
        end)
    end
    ------------------定时获取当前副本和提示清空表格------------------
    do
        -- 获取当前副本
        local FBtable = {
            [533] = "NAXX", -- 纳克萨玛斯
            [615] = "NAXX", -- 黑曜石圣殿
            [616] = "NAXX", -- 永恒之眼
            [603] = "ULD",  -- 奥杜尔
            [649] = "TOC",  -- 十字军的试炼
            [249] = "TOC",  -- 奥妮克希亚的巢穴
            [631] = "ICC",  -- 冰冠堡垒
            [724] = "ICC",  -- 红玉圣殿
        }

        local lastzoneId
        C_Timer.NewTicker(5, function() -- 每5秒执行一次
            if BG.DeBug then
                return
            end
            local fbId = select(8, GetInstanceInfo()) -- 获取副本ID
            local _, type = IsInInstance()
            if type ~= "raid" then
                BG.FB2 = nil
            else
                for id, value in pairs(FBtable) do -- 把副本ID转换为副本英文简写
                    if fbId == id then
                        BG.FB2 = value
                        break
                    else
                        BG.FB2 = nil
                    end
                end
                if lastzoneId ~= fbId then
                    if BG.FB2 then
                        local name = "showQingKong"
                        if BG.JinBenQingKong.Button and BiaoGe.options[name] == 1 then
                            BG.JinBenQingKong.Button:SetFormattedText(L["要清空表格< %s >吗？"], BG.FB2)
                            BG.JinBenQingKong.Button:Show()
                            local starttime = GetTime()
                            local duration = 8
                            BG.BarDongHua(BG.JinBenQingKong.bar, starttime, duration)
                        end
                        BG.ClickFBbutton(BG.FB2)
                    end
                end
            end
            lastzoneId = fbId
        end)
    end
    ------------------生成各副本UI------------------
    do
        if not BG.Vanilla() then
            BG.ICCUI("ICC")
            BG.TOCUI("TOC")
            BG.ULDUI("ULD")
        end
        BG.NAXXUI("NAXX")

        -- 生成心愿UI
        BG.HopeUI("ICC")
        BG.HopeUI("TOC")
        BG.HopeUI("ULD")
        BG.HopeUI("NAXX")

        BG.HistoryUI()
        BG.ReceiveUI()
        BG.DuiZhangUI()
        if not BG.Vanilla() then
            BG.RoleOverviewUI()
        end

        BG.ZhangDanUI()
        BG.LiuPaiUI()
        BG.QianKuanUI()
        BG.WCLUI()
        BG.XiaoFeiUI()
        BG.YongShiUI()
    end
    ------------------高亮团长发出的装备------------------
    do
        local f = CreateFrame("Frame")
        f:RegisterEvent("CHAT_MSG_RAID_LEADER")
        f:RegisterEvent("CHAT_MSG_RAID_WARNING")
        f:RegisterEvent("CHAT_MSG_RAID")
        f:RegisterEvent("CHAT_MSG_SAY")
        f:SetScript("OnEvent", function(self, even, text, playerName, ...)
            if even == "CHAT_MSG_RAID" then
                local a = string.find(playerName, "-")
                if a then
                    playerName = strsub(playerName, 1, a - 1)
                end
                if playerName ~= BG.MasterLooter then
                    return
                end
            end
            -- 把超链接转换成文字
            local textonly = ""
            local cc = 1
            local aa, bb
            for i = 1, 4, 1 do
                aa = string.find(text, "|h", cc)
                if aa then
                    bb = string.find(text, "]", aa)
                end
                if bb then
                    cc = bb + 10
                end
                if aa and bb then
                    textonly = textonly .. strsub(text, aa, bb)
                else
                    break
                end
            end
            -- 开始
            local name1 = "auctionHigh"
            if BiaoGe.options[name1] ~= 1 then return end
            local name2 = "auctionHighTime"
            local yes
            -- local FB = BG.FB1
            for _, FB in pairs(BG.FBtable) do
                for b = 1, Maxb[FB], 1 do
                    for i = 1, Maxi[FB], 1 do
                        if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i] then
                            if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:GetText() ~= "" then
                                local item, link, quality, level, _, _, _, _, _, Texture, _, typeID = GetItemInfo(BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:GetText())
                                if item then
                                    yes = string.find(textonly, item)
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
                                            BG.FrameLootMsg:AddMessage(BG.STC_g1(format(L["你关注的装备开始拍卖了：%s（右键取消关注）"],
                                                AddTexture(Texture) .. BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:GetText())))
                                            PlaySoundFile(BG.sound_paimai, "Master")
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
                                local item = GetItemInfo(BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:GetText())
                                if item then
                                    yes = string.find(textonly, item)
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
                if BG.IsML then -- 拍卖倒数
                    BG.StartCountDown(link)
                else            -- 关注装备
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
        local t = BG.MainFrame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
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
    ------------------拍卖倒数------------------
    do
        local f = CreateFrame("Frame")
        local PaiMai

        local function Channel(leader, assistant, looter, optionchannel)
            if leader then
                return optionchannel
            elseif assistant and looter then
                return optionchannel
            elseif looter then
                return "RAID"
            end
        end

        function BG.StartCountDown(link)
            if not link then return end
            if BiaoGe.options["countDown"] ~= 1 then return end
            local leader
            local assistant
            local looter
            local player = UnitName("player")
            if BG.raidRosterInfo and type(BG.raidRosterInfo) == "table" then
                for index, v in ipairs(BG.raidRosterInfo) do
                    if v.rank == 2 and v.name == player then
                        leader = true
                    elseif v.rank == 1 and v.name == player then
                        assistant = true
                    end
                    if v.isML and v.name == player then
                        looter = true
                    end
                end
            end
            if not leader and not looter then return end

            local channel = Channel(leader, assistant, looter, BiaoGe.options["countDownSendChannel"])
            if PaiMai then
                local text = L["{rt7}倒数暂停{rt7}"]
                SendChatMessage(text, channel)
                PaiMai = nil
                f:SetScript("OnUpdate", nil)
                return
            end

            local Maxtime = BiaoGe.options["countDownDuration"]
            local text = link .. L[" {rt1}拍卖倒数"] .. Maxtime .. L["秒{rt1}"]
            SendChatMessage(text, channel)
            PaiMai = true

            local timeElapsed = 0
            local lasttime = Maxtime + 1
            f:SetScript("OnUpdate", function(self, elapsed)
                timeElapsed = timeElapsed + elapsed
                if timeElapsed >= 1 then
                    lasttime = lasttime - format("%d", timeElapsed)
                    if lasttime <= 0 then
                        PaiMai = nil
                        f:SetScript("OnUpdate", nil)
                        return
                    end
                    local text = "> " .. lasttime .. " <"
                    SendChatMessage(text, channel)
                    timeElapsed = 0
                end
            end)
        end

        local function NDuiOnClick(self)
            if not IsAltKeyDown() then return end
            local link = C_Container.GetContainerItemLink(self.bagId, self.slotId)
            BG.StartCountDown(link)
        end

        local function EUIOnClick(self)
            if not IsAltKeyDown() then return end
            local link = C_Container.GetContainerItemLink(self.BagID, self.SlotID)
            BG.StartCountDown(link)
        end

        local function BigFootOnClick(self)
            if not IsAltKeyDown() then return end
            local link = C_Container.GetContainerItemLink(self:GetParent():GetID(), self:GetID())
            BG.StartCountDown(link)
        end

        local function OnClick(self)
            if not IsAltKeyDown() then return end
            local link = C_Container.GetContainerItemLink(self:GetParent():GetID(), self:GetID())
            BG.StartCountDown(link)
        end

        BG.RegisterEvent("PLAYER_ENTERING_WORLD", function(self, even, isLogin, isReload)
            if not (isLogin or isReload) then return end
            if _G["NDui_BackpackSlot1"] then
                --NDUI背包
                local i = 1
                while _G["NDui_BackpackSlot" .. i] do
                    _G["NDui_BackpackSlot" .. i]:HookScript("OnClick", NDuiOnClick)
                    i = i + 1
                end
            elseif _G["ElvUI_ContainerFrameBag-1Slot1"] then
                --EUI背包
                local b = -1
                local i = 1
                while _G["ElvUI_ContainerFrameBag" .. b .. "Slot" .. i] do
                    while _G["ElvUI_ContainerFrameBag" .. b .. "Slot" .. i] do
                        _G["ElvUI_ContainerFrameBag" .. b .. "Slot" .. i]:HookScript("OnClick", EUIOnClick)
                        i = i + 1
                    end
                    b = b + 1
                    i = 1
                end
            elseif _G["CombuctorFrame1"] then
                --大脚背包
                local yes
                _G["CombuctorFrame1"]:HookScript("OnShow", function()
                    if not yes then
                        local i = 1
                        while _G["CombuctorItem" .. i] do
                            _G["CombuctorItem" .. i]:HookScript("OnClick", BigFootOnClick)
                            i = i + 1
                        end
                        yes = true
                    end
                end)
            else
                -- 原生背包
                local b = 1
                local i = 1
                while _G["ContainerFrame" .. b .. "Item" .. i] do
                    while _G["ContainerFrame" .. b .. "Item" .. i] do
                        _G["ContainerFrame" .. b .. "Item" .. i]:HookScript("OnClick", OnClick)
                        i = i + 1
                    end
                    b = b + 1
                    i = 1
                end
            end
        end)
    end
    ------------------团队表格人数------------------
    do
        BG.raidBiaoGeVersion = {}

        local frame = CreateFrame("Frame", nil, BG.MainFrame)
        frame:SetSize(160, 20)
        frame:SetPoint("LEFT", BG.ButtonToken, "RIGHT", 20, 0)
        frame:Hide()
        local fontString = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
        fontString:SetPoint("CENTER")
        fontString:SetTextColor(RGB(BG.g1))
        fontString:SetJustifyH("LEFT")
        frame:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            local c1, c2, c3 = RGB(BG.g1)
            GameTooltip:AddLine(L["团员插件版本"], c1, c2, c3)
            GameTooltip:AddLine(" ")
            local raid = BG.PaiXuRaidRosterInfo()
            for i, v in ipairs(raid) do
                local Ver = L["无"]
                for name, ver in pairs(BG.raidBiaoGeVersion) do
                    if v.name == name then
                        Ver = ver
                    end
                end
                local role = ""
                local y
                if v.rank == 2 then
                    role = AddTexture("interface/groupframe/ui-group-leadericon", y)
                elseif v.rank == 1 then
                    role = AddTexture("interface/groupframe/ui-group-assistanticon", y)
                elseif v.isML then
                    role = AddTexture("interface/groupframe/ui-group-masterlooter", y)
                end
                local c1, c2, c3 = GetClassRGB(v.name)
                GameTooltip:AddDoubleLine(v.name .. role, Ver, c1, c2, c3, 1, 1, 1)
            end
            GameTooltip:Show()
        end)
        BG.GameTooltip_Hide(frame)

        local f = CreateFrame("Frame")
        f:RegisterEvent("GROUP_ROSTER_UPDATE")
        f:SetScript("OnEvent", function(self, even, ...)
            C_Timer.After(2, function()
                if IsInRaid(1) then
                    C_ChatInfo.SendAddonMessage("BiaoGe", "MyVer-" .. BG.ver, "RAID")
                else
                    BG.raidBiaoGeVersion = {}
                    frame:Hide()
                end
            end)
        end)

        -- 如果团队里有人退出，就删掉
        local leave = ERR_RAID_MEMBER_REMOVED_S:gsub("%%s", "(.+)")
        local f = CreateFrame("Frame")
        f:RegisterEvent("CHAT_MSG_SYSTEM")
        f:SetScript("OnEvent", function(self, even, text, ...)
            local name = strmatch(text, leave)
            if name then
                BG.raidBiaoGeVersion[name] = nil
                fontString:SetFormattedText(L["团员插件版本：%s"], (Size(BG.raidBiaoGeVersion) .. "/" .. GetNumGroupMembers()))
                frame:Show()
            end
        end)

        local f = CreateFrame("Frame")
        f:RegisterEvent("CHAT_MSG_ADDON")
        f:SetScript("OnEvent", function(self, even, ...)
            local prefix, msg, distType, sender = ...
            if distType ~= "RAID" then return end
            if prefix ~= "BiaoGe" then return end
            local sendername = strsplit("-", sender)
            if msg == "VersionCheck" then
                C_ChatInfo.SendAddonMessage("BiaoGe", "MyVer-" .. BG.ver, "RAID")
            elseif strfind(msg, "MyVer") then
                local _, version = strsplit("-", msg)
                BG.raidBiaoGeVersion[sendername] = version
                fontString:SetFormattedText(L["团员插件版本：%s"], (Size(BG.raidBiaoGeVersion) .. "/" .. GetNumGroupMembers()))
                frame:Show()
            end
        end)

        local f = CreateFrame("Frame")
        f:RegisterEvent("PLAYER_ENTERING_WORLD")
        f:SetScript("OnEvent", function(self, even, isLogin, isReload)
            if not (isLogin or isReload) then return end
            C_Timer.After(3, function()
                if IsInRaid(1) then
                    C_ChatInfo.SendAddonMessage("BiaoGe", "VersionCheck", "RAID")
                end
            end)
        end)
    end
    ------------------离队入队染上职业颜色------------------
    do
        local last
        local lastraidjoinname
        local lastpartyjoinname
        local function MsgClassColor(self, even, msg, player, l, cs, t, flag, channelId, ...)
            -- pt(msg, player, l, cs, t, flag, channelId, ...)

            -- if msg == last then return end
            -- last = msg
            -- if msg:find("加入") or msg:find("离开") then
            --     pt(msg)
            -- end
            if msg:match("%s$") then
                return
            end
            local raidleavename = strmatch(msg, ERR_RAID_MEMBER_REMOVED_S:gsub("%%s", "(.+)"))
            local raidjoinname = strmatch(msg, ERR_RAID_MEMBER_ADDED_S:gsub("%%s", "(.+)"))
            local partyleavename = strmatch(msg, ERR_LEFT_GROUP_S:gsub("%%s", "(.+)"))
            local partyjoinname = strmatch(msg, ERR_JOINED_GROUP_S:gsub("%%s", "(.+)"))
            -- 离开了团队
            if raidleavename then
                if BG.raidRosterInfo and type(BG.raidRosterInfo) == "table" then
                    for k, v in pairs(BG.raidRosterInfo) do
                        if raidleavename == v.name then
                            local c = select(4, GetClassColor(v.class))
                            local colorname = "|c" .. c .. raidleavename .. "|r"
                            msg = format(ERR_RAID_MEMBER_REMOVED_S, colorname)
                            lastraidjoinname = nil
                            return false, msg, player, l, cs, t, flag, channelId, ...
                        end
                    end
                end
                -- 加入了团队
            elseif raidjoinname then
                C_Timer.After(0.5, function()
                    if lastraidjoinname == raidjoinname then return end
                    local colorname = SetClassCFF(raidjoinname)
                    SendSystemMessage(format(ERR_RAID_MEMBER_ADDED_S .. " ", colorname))
                    lastraidjoinname = raidjoinname
                end)
                return true

                -- 离开了队伍
            elseif partyleavename then
                if BG.groupRosterInfo and type(BG.groupRosterInfo) == "table" then
                    for k, v in pairs(BG.groupRosterInfo) do
                        if partyleavename == v.name then
                            local c = select(4, GetClassColor(v.class))
                            local colorname = "|c" .. c .. partyleavename .. "|r"
                            msg = format(ERR_LEFT_GROUP_S, colorname)
                            lastpartyjoinname = nil
                            return false, msg, player, l, cs, t, flag, channelId, ...
                        end
                    end
                end
                -- 加入了队伍
            elseif partyjoinname then
                C_Timer.After(0.5, function()
                    if lastpartyjoinname == partyjoinname then return end
                    local colorname = SetClassCFF(partyjoinname)
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
            elseif not IsInGroup(1) then
                lastpartyjoinname = nil
            end
        end)
    end
    ------------------表格/背包高亮对应装备------------------
    do
        BG.LastBagItemFrame = {}
        BG.BagAddon = ""

        local function SetOnEnter(link)
            if not link then return end
            local FB = BG.FB1
            for b = 1, Maxb[FB], 1 do
                for i = 1, Maxi[FB], 1 do
                    local zb = BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]
                    if zb then
                        if GetItemID(link) == GetItemID(zb:GetText()) then
                            local f = CreateFrame("Frame", nil, BG.MainFrame, "BackdropTemplate")
                            f:SetBackdrop({
                                edgeFile = "Interface/ChatFrame/ChatFrameBackground",
                                edgeSize = 2,
                            })
                            f:SetBackdropBorderColor(1, 0, 0, 1)
                            f:SetPoint("TOPLEFT", BG.Frame[FB]["boss" .. b]["zhuangbei" .. i], "TOPLEFT", -4, -2)
                            f:SetPoint("BOTTOMRIGHT", BG.Frame[FB]["boss" .. b]["jine" .. i], "BOTTOMRIGHT", -2, 0)
                            f:SetFrameLevel(112)
                            tinsert(BG.LastBagItemFrame, f)
                        end
                    end
                end
            end
        end

        local function NDuiOnClick(self)
            local link = C_Container.GetContainerItemLink(self.bagId, self.slotId)
            SetOnEnter(link)
        end

        local function EUIOnClick(self)
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

        BG.RegisterEvent("PLAYER_ENTERING_WORLD", function(self, even, isLogin, isReload)
            if not (isLogin or isReload) then return end
            if _G["NDui_BackpackSlot1"] then
                --NDUI背包
                local i = 1
                while _G["NDui_BackpackSlot" .. i] do
                    _G["NDui_BackpackSlot" .. i]:HookScript("OnEnter", NDuiOnClick)
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
                        _G["ElvUI_ContainerFrameBag" .. b .. "Slot" .. i]:HookScript("OnEnter", EUIOnClick)
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

    -- ----------------------------------------------------------------------------
    -- 清空表格
    -- ----------------------------------------------------------------------------
    do
        -- 清空按钮
        do
            local bt = CreateFrame("Button", nil, BG.MainFrame, "UIPanelButtonTemplate")
            bt:SetSize(120, BG.ButtonZhangDan:GetHeight())
            bt:SetPoint("BOTTOMLEFT", BG.MainFrame, "BOTTOMLEFT", 30, select(5, BG.ButtonZhangDan:GetPoint()))
            bt:SetText(L["清空当前表格"])
            BG.ButtonQingKong = bt
            -- 按钮触发
            bt:SetScript("OnClick", function()
                PlaySound(BG.sound1, "Master")
                local num = BG.Frame:QingKong(BiaoGe[BG.FB1], BG.FB1, Maxb[BG.FB1], Maxi[BG.FB1], BiaoGe.Hope[RealmId][player][BG.FB1])
                if BG["Frame" .. BG.FB1] and BG["Frame" .. BG.FB1]:IsVisible() then
                    local name = "autoQingKong"
                    if BiaoGe.options[name] == 1 then
                        SendSystemMessage(BG.STC_b1(format(L["已清空表格< %s >，分钱人数已改为%s人"], BG.FB1, num)))
                    else
                        SendSystemMessage(BG.STC_b1(format(L["已清空表格< %s >"], BG.FB1)))
                    end
                else
                    SendSystemMessage(BG.STC_g1(format(L["已清空心愿< %s >"], BG.FB1)))
                end
                FrameHide(0)
            end)
            bt:SetScript("OnEnter", function(self)
                local text = L["|cffffffff< 清空当前表格/心愿 >|r\n\n1、表格界面时一键清空装备、买家、金额，同时还清空关注和欠款\n2、心愿界面时一键清空全部心愿装备\n"]
                GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
                GameTooltip:ClearLines()
                GameTooltip:SetText(text)
            end)
            BG.GameTooltip_Hide(bt)
        end
        -- 进副本提示清空
        do
            BG.JinBenQingKong = {}
            BG.JinBenQingKong.Button = CreateFrame("Button", nil, UIParent, "BackdropTemplate")
            BG.JinBenQingKong.Button:SetBackdrop({
                edgeFile = "Interface/ChatFrame/ChatFrameBackground",
                edgeSize = 1
            })
            BG.JinBenQingKong.Button:SetBackdropBorderColor(0, 0.75, 1, 1)
            BG.JinBenQingKong.Button:SetSize(300, 35)
            BG.JinBenQingKong.Button:SetPoint("TOP", UIParent, "TOP", 0, -300)
            BG.JinBenQingKong.Button:SetFrameLevel(200)
            BG.JinBenQingKong.Button:SetToplevel(true)
            BG.JinBenQingKong.Button:SetNormalFontObject(BG.FontBlue1)
            BG.JinBenQingKong.Button:SetHighlightFontObject(BG.FontHilight)
            BG.JinBenQingKong.Button:Hide()

            -- 窗口变小动画
            local s = CreateFrame("StatusBar", nil, BG.JinBenQingKong.Button)
            s:SetAllPoints()
            s:SetFrameLevel(s:GetParent():GetFrameLevel() - 5)
            s:SetStatusBarTexture("Interface/ChatFrame/ChatFrameBackground")
            s:SetStatusBarColor(0, 0.75, 1, 0.5)
            s:SetMinMaxValues(0, 10000)
            BG.JinBenQingKong.bar = s

            function BG.BarDongHua(bar, starttime, duration)
                bar:Show()
                bar:SetScript("OnUpdate", function()
                    local t = GetTime()
                    local a = (starttime + duration - t) / duration
                    local _, max = bar:GetMinMaxValues()
                    local v = a * max
                    bar:SetValue(v)
                    if v <= 0 then
                        bar:SetScript("OnUpdate", nil)
                        bar:GetParent():Hide()
                    end
                end)
            end

            StaticPopupDialogs["QINGKONGBIAOGE"] = {
                text = L["确认清空表格< %s >？"],
                button1 = L["是"],
                button2 = L["否"],
                OnAccept = function()
                    if BG.FB2 then
                        local num = BG.Frame:QingKong(BiaoGe[BG.FB2], BG.FB2, Maxb[BG.FB2], Maxi[BG.FB2])
                        BG.JinBenQingKong.Button:Hide()
                        PlaySoundFile(BG.sound_qingkong, "Master")
                        SendSystemMessage(BG.STC_b1(format(L["已清空表格< %s >，分钱人数已改为%d人"], BG.FB1, num)))
                    end
                end,
                OnCancel = function()
                end,
                timeout = 5,
                whileDead = true,
                hideOnEscape = true,
            }

            BG.JinBenQingKong.Button:SetScript("OnClick", function()
                StaticPopup_Show("QINGKONGBIAOGE", BG.FB2)
            end)
        end
    end

    -- ----------------------------------------------------------------------------
    -- 高亮天赋装备
    -- ----------------------------------------------------------------------------
    do
        local RealmId = GetRealmID()
        local player = UnitName("player")
        --点击
        local function OnClick(self, event)
            local FB = BG.FB1
            local _, class = UnitClass("player")
            local num = self.num
            if self.icon:IsDesaturated() then -- 如果已经去饱和（就是不生效的状态）
                for i = 1, 4 do
                    if BG.frameFilterIcon["Button" .. i].icon then
                        BG.frameFilterIcon["Button" .. i].icon:SetDesaturated(true)
                    end
                end
                BiaoGe.filterClassNum[RealmId][player] = num
                self.icon:SetDesaturated(false)
                BG.buttonHFilter0:SetPoint("CENTER", self, "CENTER")
                BG.buttonHFilter0:Show()

                for b = 1, Maxb[FB] do -- 当前表格
                    for i = 1, Maxi[FB] do
                        local bt = BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]
                        if bt then
                            BG.FilterClass(FB, b, i, bt, class, num, BiaoGeFilterTooltip, "Frame")
                        end
                    end
                end
                for b = 1, Maxb[FB] do -- 历史表格
                    for i = 1, Maxi[FB] do
                        local bt = BG.HistoryFrame[FB]["boss" .. b]["zhuangbei" .. i]
                        if bt then
                            BG.FilterClass(FB, b, i, bt, class, num, BiaoGeFilterTooltip, "HistoryFrame")
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
                if BG.ZhuangbeiList then
                    local i = 1
                    while BG.ZhuangbeiList["button" .. i] do
                        local button = BG.ZhuangbeiList["button" .. i]
                        BG.FilterClass(nil, nil, nil, button, class, num, BiaoGeFilterTooltip, "zhuangbei")
                        i = i + 1
                    end
                end
            else
                BiaoGe.filterClassNum[RealmId][player] = 0
                self.icon:SetDesaturated(true)
                BG.buttonHFilter0:Hide()

                local alpha = 1
                for b = 1, Maxb[FB] do
                    for i = 1, Maxi[FB] do
                        local bt = BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]
                        if bt then
                            BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:SetAlpha(alpha)
                            BG.Frame[FB]["boss" .. b]["maijia" .. i]:SetAlpha(alpha)
                            BG.Frame[FB]["boss" .. b]["jine" .. i]:SetAlpha(alpha)
                            BG.Frame[FB]["boss" .. b]["guanzhu" .. i]:SetAlpha(alpha)
                            BG.FrameDs[FB .. 1]["boss" .. b]["ds" .. i]:SetAlpha(alpha)
                            BG.FrameDs[FB .. 2]["boss" .. b]["ds" .. i]:SetAlpha(alpha)
                            BG.FrameDs[FB .. 3]["boss" .. b]["ds" .. i]:SetAlpha(alpha)

                            BG.HistoryFrame[FB]["boss" .. b]["zhuangbei" .. i]:SetAlpha(alpha)
                            BG.HistoryFrame[FB]["boss" .. b]["maijia" .. i]:SetAlpha(alpha)
                            BG.HistoryFrame[FB]["boss" .. b]["jine" .. i]:SetAlpha(alpha)
                            BG.HistoryFrameDs[FB .. 1]["boss" .. b]["ds" .. i]:SetAlpha(alpha)
                        end
                    end
                end
                for n = 1, HopeMaxn[FB] do
                    for b = 1, HopeMaxb[FB] do
                        for i = 1, 2 do
                            local bt = BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]
                            if bt then
                                BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:SetAlpha(alpha)
                                BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["yidiaoluo" .. i]:SetAlpha(alpha)
                                BG.HopeFrameDs[FB .. 1]["nandu" .. n]["boss" .. b]["ds" .. i]:SetAlpha(alpha)
                                BG.HopeFrameDs[FB .. 2]["nandu" .. n]["boss" .. b]["ds" .. i]:SetAlpha(alpha)
                                BG.HopeFrameDs[FB .. 3]["nandu" .. n]["boss" .. b]["ds" .. i]:SetAlpha(alpha)
                            end
                        end
                    end
                end
                if BG.ZhuangbeiList then
                    local i = 1
                    while BG.ZhuangbeiList["button" .. i] do
                        BG.ZhuangbeiList["button" .. i]:SetAlpha(alpha)
                        i = i + 1
                    end
                end
            end
            PlaySound(BG.sound1, "Master")
        end
        local function OnEnter(self, event)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:SetText(L["高亮该天赋的装备"])
        end
        local function OnLeave(self, event)
            GameTooltip:Hide()
        end

        -- 开始
        do
            BG.frameFilterIcon = CreateFrame("Frame", nil, BG.MainFrame)
            local _, class = UnitClass("player")
            local next

            local bt0 = CreateFrame("Button", nil, BG.frameFilterIcon) -- 高亮背景
            bt0:SetSize(38, 38)
            bt0:SetFrameLevel(102)
            BG.buttonHFilter0 = bt0
            bt0:Hide()
            local texture = bt0:CreateTexture(nil, "BACKGROUND") -- 高亮材质
            texture:SetAllPoints()
            texture:SetTexture("Interface/ChatFrame/UI-ChatIcon-BlinkHilight")

            for i = 1, 4 do
                local bt = CreateFrame("Button", nil, BG.frameFilterIcon, "BackdropTemplate")
                bt:SetSize(25, 25)
                bt:SetFrameLevel(105)
                if i == 1 then
                    bt:SetPoint("BOTTOMLEFT", BG.MainFrame, "BOTTOMLEFT", 430, 37)
                else
                    bt:SetPoint("LEFT", next, "RIGHT", 8, 0)
                end
                next = bt
                BG.frameFilterIcon["Button" .. i] = bt
                BG.frameFilterIcon["Button" .. i].num = i

                if BG.Icon[class .. i] then
                    local icon = bt:CreateTexture(nil, "ARTWORK") -- 图标
                    icon:SetAllPoints()
                    icon:SetTexture(BG.Icon[class .. i])
                    icon:SetDesaturated(true)
                    BG.frameFilterIcon["Button" .. i].icon = icon
                    if tonumber(BiaoGe.filterClassNum[RealmId][player]) == tonumber(i) then
                        icon:SetDesaturated(false)
                        BG.buttonHFilter0:SetPoint("CENTER", BG.frameFilterIcon["Button" .. i], "CENTER")
                        BG.buttonHFilter0:Show()
                    end

                    local higt = bt:CreateTexture() -- 高亮材质
                    higt:SetSize(21, 21)
                    higt:SetPoint("CENTER")
                    higt:SetColorTexture(RGB("FFFFFF", 0.1))
                    bt:SetHighlightTexture(higt)
                else
                    bt:Hide()
                end

                bt:SetScript("OnClick", OnClick)
                bt:SetScript("OnEnter", OnEnter)
                bt:SetScript("OnLeave", OnLeave)
            end
        end
    end


    ------------------初始显示------------------
    do
        if BiaoGe.lastFrame == "DuiZhang" then
            BG.DuiZhangMainFrame:Show()
            BG.ClickTabButton(BG.tabButtons, 3)
        elseif BiaoGe.lastFrame == "Hope" then
            BG.HopeMainFrame:Show()
            BG.ClickTabButton(BG.tabButtons, 2)
        elseif BiaoGe.lastFrame == "YY" then
            BG.YYMainFrame:Show()
            BG.ClickTabButton(BG.tabButtons, 4)
        elseif BiaoGe.lastFrame == "BOSS" then
            BG.BossMainFrame:Show()
            BG.ClickTabButton(BG.tabButtons, 5)
        else
            BG.FBMainFrame:Show()
            BG.ClickTabButton(BG.tabButtons, 1)
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

        local yes
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("CHAT_MSG_ADDON")
        frame:SetScript("OnEvent", function(self, even, prefix, msg, channel, sender)
            if prefix == "BiaoGe" and channel == "GUILD" then
                local sendername = strsplit("-", sender)
                local playername = UnitName("player")
                if sendername == playername then return end
                if msg == "VersionCheck" then
                    C_ChatInfo.SendAddonMessage("BiaoGe", "MyVer-" .. BG.ver, channel)
                elseif strfind(msg, "MyVer") then
                    if yes then return end
                    local _, version = strsplit("-", msg)
                    if VerGuoQi(BG.ver, version) then
                        SendSystemMessage("|cff00BFFF" .. format(L["< BiaoGe > 你的当前版本%s已过期，请更新插件"] .. RR, BG.STC_r1(BG.ver)))
                        BG.ShuoMingShuText:SetText(L["<说明书与更新记录> "] .. BG.STC_r1(BG.ver))
                        yes = true
                    end
                end
            end
        end)

        local f = CreateFrame("Frame")
        f:RegisterEvent("PLAYER_ENTERING_WORLD")
        f:SetScript("OnEvent", function(self, even, isLogin, isReload)
            if not (isLogin or isReload) then return end
            -- 开始发送版本请求
            C_Timer.After(5, function()
                if IsInGuild() then
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
    function BG.UpDateRaidRosterInfo()
        BG.raidRosterInfo = {}
        BG.groupRosterInfo = {}
        local yes_ML
        local yes_IsML
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
                        yes_ML = true
                    end
                    if name == UnitName("player") and (rank == 2 or isML) then
                        BG.IsML = true
                        yes_IsML = true
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
        if not yes_ML then
            BG.MasterLooter = nil
        end
        if not yes_IsML then
            BG.IsML = nil
        end
    end

    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", function(self, even, ...)
        C_Timer.After(1, function()
            BG.UpDateRaidRosterInfo()
        end)
    end)
    local f = CreateFrame("Frame")
    f:RegisterEvent("GROUP_ROSTER_UPDATE")
    f:SetScript("OnEvent", function(self, even, ...)
        C_Timer.After(0.5, function()
            BG.UpDateRaidRosterInfo()
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
            BG.UpDateRaidRosterInfo()
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
            -- C_Timer.After(1, function()
            --    SendSystemMessage("|cff00BFFF" .. format(L["< BiaoGe > 金团表格载入成功。插件命令：%s或%s，小地图图标：%s"] .. RR, "/BiaoGe", "/GBG", L["星星"]))
            -- end)
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
        InterfaceOptionsFrame_OpenToCategory(L["BiaoGe"] or "|cff00BFFFBiaoGe|r")
        BG.MainFrame:Hide()
    end
    SLASH_BIAOGEOPTIONS1 = "/bgo"



    -- DEBUG
    do
        SlashCmdList["BIAOGETEST"] = function()
            BG.FB2 = "ULD"

            if BG.DeBugLoot then
                BG.DeBug = true
                BG.DeBugLoot()
            end
            -- BG.EndPJ.new:Show()
        end
        SLASH_BIAOGETEST1 = "/bgdebug"

        SlashCmdList["BIAOGETEST2"] = function()
            BG.DeBug2 = true -- 测试过滤装备
            BiaoGeFilterTooltip:SetOwner(UIParent, "ANCHOR_NONE")
            BiaoGeFilterTooltip:ClearLines()
            BiaoGeFilterTooltip:SetItemByID(49623)
            for ii = 1, 30 do
                if _G["BiaoGeFilterTooltipTextLeft" .. ii] then
                    pt(_G["BiaoGeFilterTooltipTextLeft" .. ii]:GetText())
                end
            end
            pt(BiaoGeFilterTooltip)
        end
        SLASH_BIAOGETEST21 = "/bgdebug2"

        SlashCmdList["BIAOGETEST3"] = function()
            BG.DeBug3 = true -- 测试柱状动画
        end
        SLASH_BIAOGETEST31 = "/bgdebug3"



        function BG.DeBugLoot()
            if not BG.DeBug then return end
            local FB = "ULD"
            local name, link, quality, level, _, _, _, _, _, Texture, _, typeID = GetItemInfo(45038)
            if link then
                -- BG.FrameLootMsg:AddMessage(BG.STC_g2("自动关注心愿装备：" .. link .. "。团长拍卖此装备时会提醒"))
                -- BG.FrameLootMsg:AddMessage("|cff00BFFF" .. format(L["已自动记入表格已自动记入表格已自动记入表格：%s%s(%s) => %s< %s >%s"], RR, (AddTexture(Texture) .. link), level, "|cffFF1493", BG.Boss[FB]["boss" .. 1]["name2"], RR))
                BG.FrameLootMsg:AddMessage("|cff00BFFF" .. format(L["已自动记入表格：%s%s(%s) => %s< %s >%s"], RR, (AddTexture(Texture) .. link), level, "|cffFF1493", BG.Boss[FB]["boss" .. 1]["name2"], RR))
            end
        end

        local f = CreateFrame("Frame")
        f:RegisterEvent("CHAT_MSG_LOOT")
        f:SetScript("OnEvent", function(self, even, text, ...)
            if not BG.DeBug then return end
            local FB = "ULD"
            local name, link, quality, level, _, _, _, _, _, _, _, typeID = GetItemInfo(text)
            -- 心愿装备
            local Hope
            for n = 1, HopeMaxn[FB] do
                for b = 1, HopeMaxb[FB] do
                    for i = 1, HopeMaxi do
                        if BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] then
                            if GetItemID(link) == GetItemID(BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:GetText()) then
                                BG.FrameLootMsg:AddMessage(BG.STC_g1("你的心愿达成啦！！！>>>>> ") ..
                                    link .. "(" .. level .. ")" .. BG.STC_g1(" <<<<<"))
                                BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["yidiaoluo" .. i]:Show()
                                BiaoGe.Hope[RealmId][player][FB]["nandu" .. n]["boss" .. b]["yidiaoluo" .. i] = true
                                Hope = true
                                PlaySoundFile(BG.sound_hope, "Master")
                            end
                        end
                    end
                end
            end
            if Hope then
                -- BiaoGe[FB]["boss"..Maxb[FB]-1]["guanzhu"..1] = true
                -- BG.Frame[FB]["boss"..Maxb[FB]-1]["guanzhu"..1]:Show()
                BG.FrameLootMsg:AddMessage(BG.STC_g2("自动关注心愿装备：" .. link .. "。团长拍卖此装备时会提醒"))
            end
        end)
    end
end

--DEBUG
-- local f = CreateFrame("Frame")
-- f:RegisterEvent("PLAYER_ENTERING_WORLD")
-- f:SetScript("OnEvent", function(self, even, isLogin, isReload)
--     -- hooksecurefunc(GameTooltip, "SetCurrencyToken", function(self, index)
--     --     local id = select(12, GetCurrencyListInfo(index))
--     --     pt(id)
--     -- end)
-- end)


-- local f = CreateFrame("Frame", nil, UIParent, "InsetFrameTemplate3")
-- f:SetSize(500, 300)
-- f:SetPoint("CENTER", nil, "CENTER", 0, 0)

-- local tex = UIParent:CreateTexture()
-- tex:SetPoint("CENTER")
-- tex:SetTexture("interface/raidframe/readycheck-ready")

-- -- tex:SetTexCoord(0, 0.5, 0.5, 1)
