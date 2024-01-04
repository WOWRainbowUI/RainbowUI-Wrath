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

local pt = print

BG.RegisterEvent("PLAYER_ENTERING_WORLD", function(self, even, isLogin, isReload)
    if not (isLogin or isReload) then return end

    BG.MeetingHorn = {}
    local addonName = "MeetingHorn"
    if not IsAddOnLoaded(addonName) then return end
    local MeetingHorn = LibStub("AceAddon-3.0"):GetAddon(addonName)

    if not BiaoGe.MeetingHorn then
        BiaoGe.MeetingHorn = {}
    end
    local RealmId = GetRealmID()
    local player = UnitName("player")
    if not BiaoGe.MeetingHorn[RealmId] then
        BiaoGe.MeetingHorn[RealmId] = {}
    end
    if not BiaoGe.MeetingHorn[RealmId][player] then
        BiaoGe.MeetingHorn[RealmId][player] = {}
    end
    if BiaoGe.MeetingHorn[player] then
        for i, v in ipairs(BiaoGe.MeetingHorn[player]) do
            tinsert(BiaoGe.MeetingHorn[RealmId][player], v)
        end
        BiaoGe.MeetingHorn[player] = nil
    end

    -- 历史搜索记录
    do
        local edit = MeetingHorn.MainPanel.Browser.Input

        local f = CreateFrame("Frame", nil, edit, "BackdropTemplate")
        f:SetBackdrop({
            bgFile = "Interface/ChatFrame/ChatFrameBackground",
            edgeFile = "Interface/ChatFrame/ChatFrameBackground",
            edgeSize = 2,
        })
        f:SetBackdropColor(0, 0, 0, 0.8)
        f:SetBackdropBorderColor(0, 0, 0, 1)
        f:SetSize(240, 50)
        f:SetPoint("BOTTOMRIGHT", edit, "TOPRIGHT", 0, 0)
        f:Hide()

        local t = f:CreateFontString()
        t:SetPoint("BOTTOM", f, "TOP", 0, 0)
        t:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
        t:SetTextColor(RGB("FFFFFF"))
        t:SetText(L["< 历史搜索记录 >"])

        local buttons = {}
        local max = 8
        local function CreateHistory()
            for i, v in pairs(buttons) do
                v:Hide()
            end
            buttons = {}

            for i, v in ipairs(BiaoGe.MeetingHorn[RealmId][player]) do
                if #BiaoGe.MeetingHorn[RealmId][player] <= max then
                    break
                end
                tremove(BiaoGe.MeetingHorn[RealmId][player])
            end

            local lastBotton
            for i, v in ipairs(BiaoGe.MeetingHorn[RealmId][player]) do
                local bt = CreateFrame("Button", nil, f)
                bt:SetNormalFontObject(BG.FontGold1)
                bt:SetDisabledFontObject(BG.FontDisabled)
                bt:SetHighlightFontObject(BG.FontHilight)
                bt:SetSize(f:GetWidth() / (max / 2) - 2, 25)
                bt:RegisterForClicks("LeftButtonUp", "RightButtonUp")
                if i == 1 then
                    bt:SetPoint("TOPLEFT", 3, -2)
                elseif i == (max / 2 + 1) then
                    bt:SetPoint("TOPLEFT", 3, -26)
                else
                    bt:SetPoint("LEFT", lastBotton, "RIGHT")
                end
                bt:SetText(v)
                local string = bt:GetFontString()
                if string then
                    string:SetWidth(bt:GetWidth())
                    string:SetWordWrap(false)
                end
                lastBotton = bt
                tinsert(buttons, bt)

                bt:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(f, "ANCHOR_BOTTOMLEFT", -2, 50)
                    GameTooltip:ClearLines()
                    GameTooltip:SetText(L["|cffFFFFFF左键：|r搜索该记录\n|cffFFFFFF右键：|r删除该记录"])
                end)
                BG.GameTooltip_Hide(bt)
                bt:SetScript("OnLeave", function(self)
                    GameTooltip:Hide()
                end)
                bt:SetScript("OnClick", function(self, enter)
                    if enter == "RightButton" then
                        tremove(BiaoGe.MeetingHorn[RealmId][player], i)
                        CreateHistory()
                    else
                        edit:SetText(v)
                        PlaySound(BG.sound1, "Master")
                    end
                end)
            end
        end

        local bt = CreateFrame("Button", nil, edit)
        bt:SetSize(16, 16)
        bt:SetPoint("RIGHT", -22, 0)
        bt:SetNormalTexture("interface/raidframe/readycheck-ready")
        bt:SetHighlightTexture("interface/raidframe/readycheck-ready")
        bt:Hide()
        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:SetText(L["把搜索文本添加至历史记录"])
        end)
        BG.GameTooltip_Hide(bt)
        bt:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)
        bt:SetScript("OnClick", function(self)
            local text = edit:GetText()
            if text ~= "" then
                tinsert(BiaoGe.MeetingHorn[RealmId][player], 1, edit:GetText())
                CreateHistory()
                PlaySound(BG.sound1, "Master")
            end
        end)

        edit:HookScript("OnEditFocusGained", function(self)
            local name = "MeetingHorn_history"
            if BiaoGe.options[name] == 1 then
                CreateHistory()
                f:Show()
                bt:Show()
            end
        end)
        edit:HookScript("OnEditFocusLost", function(self)
            f:Hide()
            bt:Hide()
        end)
    end

    -- 不自动退出集结号频道
    do
        local LFG = MeetingHorn:GetModule('LFG', 'AceEvent-3.0', 'AceTimer-3.0', 'AceComm-3.0', 'LibCommSocket-3.0')

        MeetingHorn.MainPanel:HookScript("OnHide", function(self)
            C_Timer.After(0.5, function()
                local name = "MeetingHorn_always"
                if BiaoGe.options[name] == 1 then
                    LFG.leaveTimer:Stop()
                end
            end)
        end)
    end

    -- 按人数排序
    do
        local Browser = MeetingHorn.MainPanel.Browser

        local bt = MeetingHorn.MainPanel.Browser.Header3
        local name = "MeetingHorn_members"
        if BiaoGe.options[name] == 1 then
            bt:SetEnabled(true)
        end

        function Browser:Sort()
            sort(self.ActivityList:GetItemList(), function(a, b)
                local acl, bcl = a:GetCertificationLevel(), b:GetCertificationLevel()
                if acl or bcl then
                    if acl and bcl then
                        return acl > bcl
                    else
                        return acl
                    end
                end
                if not self.sortId then
                    return false
                end

                if self.sortId == 3 then -- 按队伍人数排序
                    local aid, bid = a:GetMembers(), b:GetMembers()
                    if aid and bid then
                        if aid == bid then
                            local aid, bid = a:GetActivityId(), b:GetActivityId()
                            if aid == bid then
                                return a:GetTick() < b:GetTick()
                            else
                                return aid < bid
                            end
                        end
                        if self.sortOrder == 0 then
                            return aid > bid
                        else
                            return bid > aid
                        end
                    elseif aid and not bid then
                        return true
                    elseif bid and not aid then
                        return false
                    else
                        return false
                    end
                elseif self.sortId == 1 then -- 按副本排序
                    local aid, bid = a:GetActivityId(), b:GetActivityId()
                    if aid == bid then
                        return a:GetTick() < b:GetTick()
                    end

                    if aid == 0 then
                        return false
                    elseif bid == 0 then
                        return true
                    end

                    if self.sortOrder == 0 then
                        return aid < bid
                    else
                        return bid < aid
                    end
                end
            end)
            self.ActivityList:Refresh()

            if self.sortId then
                self.Sorter:Show()
                self.Sorter:SetParent(self['Header' .. self.sortId])
                self.Sorter:ClearAllPoints()
                self.Sorter:SetPoint('RIGHT', self['Header' .. self.sortId], 'RIGHT', -5, 0)

                if self.sortOrder == 0 then
                    self.Sorter:SetTexCoord(0, 0.5, 0, 1)
                else
                    self.Sorter:SetTexCoord(0, 0.5, 1, 0)
                end
            else
                self.Sorter:Hide()
            end
        end
    end

    -- 密语增强
    do
        if not BiaoGe.MeetingHornWhisper then
            BiaoGe.MeetingHornWhisper = {}
        end
        local RealmId = GetRealmID()
        local player = UnitName("player")
        if not BiaoGe.MeetingHornWhisper[RealmId] then
            BiaoGe.MeetingHornWhisper[RealmId] = {}
        end
        if not BiaoGe.MeetingHornWhisper[RealmId][player] then
            BiaoGe.MeetingHornWhisper[RealmId][player] = {}
        end


        local M = {}
        local Browser = MeetingHorn.MainPanel.Browser

        local bt = CreateFrame("Button", nil, Browser, "UIPanelButtonTemplate")
        bt:SetSize(120, 22)
        bt:SetPoint("RIGHT", Browser.RechargeBtn, "LEFT", -10, 0)
        bt:SetText(L["密语模板"])
        bt:SetFrameLevel(4)
        BG.MeetingHorn.WhisperButton = bt
        if BiaoGe.options["MeetingHorn_whisper"] ~= 1 then
            bt:Hide()
        end
        bt:SetScript("OnClick", function(self)
            if BG.MeetingHorn.WhisperFrame:IsVisible() then
                BG.MeetingHorn.WhisperFrame:Hide()
                BiaoGe.MeetingHornWhisper.WhisperFrame = nil
            else
                BG.MeetingHorn.WhisperFrame:Show()
                BiaoGe.MeetingHornWhisper.WhisperFrame = true
            end
            PlaySound(BG.sound1, "Master")
        end)

        -- 背景框
        local f = CreateFrame("Frame", nil, BG.MeetingHorn.WhisperButton, "BackdropTemplate")
        f:SetBackdrop({
            bgFile = "Interface/ChatFrame/ChatFrameBackground",
            edgeFile = "Interface/ChatFrame/ChatFrameBackground",
            edgeSize = 2,
        })
        f:SetBackdropColor(0, 0, 0, 0.8)
        f:SetBackdropBorderColor(0, 0, 0, 0.8)
        f.width = 200
        f:SetPoint("TOPLEFT", MeetingHorn.MainPanel, "TOPRIGHT", 0, -f.width)
        f:SetPoint("BOTTOMRIGHT", MeetingHorn.MainPanel, "BOTTOMRIGHT", f.width, 0)
        f:EnableMouse(true)
        BG.MeetingHorn.WhisperFrame = f
        if not BiaoGe.MeetingHornWhisper.WhisperFrame then
            f:Hide()
        end
        f.CloseButton = CreateFrame("Button", nil, f, "UIPanelCloseButton")
        f.CloseButton:SetPoint("TOPRIGHT", 3, 3)
        f.CloseButton:HookScript("OnClick", function()
            BiaoGe.MeetingHornWhisper.WhisperFrame = nil
            PlaySound(BG.sound1, "Master")
        end)

        -- 标题
        local t = f:CreateFontString()
        t:SetPoint("TOP", 0, -5)
        t:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
        t:SetTextColor(RGB("FFFFFF"))
        t:SetText(L["< 密语模板 >"])

        -- 提示
        local bt = CreateFrame("Button", nil, f)
        bt:SetSize(30, 30)
        bt:SetPoint("TOPLEFT", 3, 3)
        -- bt:SetPoint("LEFT", t, "RIGHT", -2, -1)
        local tex = bt:CreateTexture()
        tex:SetAllPoints()
        tex:SetTexture(616343)
        bt:SetHighlightTexture(616343)
        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:AddLine(L["密语模板"], 1, 1, 1)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(L["1、预设成就、装等、自定义文本，当你点击集结号活动密语时会自动添加该内容"])
            GameTooltip:AddLine(L["2、按住SHIFT+点击密语时不会添加"])
            GameTooltip:AddLine(L["3、右键聊天频道玩家的菜单里增加密语模板按钮"])
            GameTooltip:AddLine(L["4、右键聊天输入框增加密语模板按钮"])
            GameTooltip:Show()
        end)
        BG.GameTooltip_Hide(bt)

        -- 成就
        local AchievementTitle, AchievementTitleID, AchievementEdit, AchievementCheckButton
        do
            local t = f:CreateFontString()
            t:SetPoint("TOPLEFT", 15, -35)
            t:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
            t:SetTextColor(RGB(BG.g1))
            t:SetText(L["成就"])
            AchievementTitle = t

            local l = f:CreateLine()
            l:SetColorTexture(RGB("808080", 1))
            l:SetStartPoint("BOTTOMLEFT", t, -5, -2)
            l:SetEndPoint("BOTTOMLEFT", t, f.width - 25, -2)
            l:SetThickness(1)

            local t = f:CreateFontString()
            t:SetPoint("TOPLEFT", AchievementTitle, "BOTTOMLEFT", 0, -8)
            t:SetFont(BIAOGE_TEXT_FONT, 14, "OUTLINE")
            t:SetTextColor(RGB("FFFFFF"))
            t:SetText(L["成就ID："])
            AchievementTitleID = t

            -- 编辑框
            local edit = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
            edit:SetSize(80, 20)
            edit:SetPoint("LEFT", t, "RIGHT", 5, 0)
            edit:SetAutoFocus(false)
            edit:SetNumeric(true)
            if BiaoGe.MeetingHornWhisper[RealmId][player].AchievementID then
                edit:SetText(BiaoGe.MeetingHornWhisper[RealmId][player].AchievementID)
            end
            AchievementEdit = edit
            edit:SetScript("OnMouseDown", function(self, enter)
                if enter == "RightButton" then
                    edit:SetEnabled(false)
                    edit:SetText("")
                else
                    edit:SetFocus()
                end
            end)
            edit:SetScript("OnMouseUp", function(self, enter)
                if enter == "RightButton" then
                    edit:SetEnabled(true)
                end
            end)
            edit:SetScript("OnEnterPressed", function(self)
                self:ClearFocus()
            end)
            edit:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
                GameTooltip:ClearLines()
                GameTooltip:AddLine(L["成就ID参考"], 1, 1, 1)
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("ICC", 1, 1, 1)
                GameTooltip:AddLine("4637: " .. GetAchievementLink(4637))
                GameTooltip:AddLine("4608: " .. GetAchievementLink(4608))
                GameTooltip:AddLine("4636: " .. GetAchievementLink(4636))
                GameTooltip:AddLine("4532: " .. GetAchievementLink(4532))
                GameTooltip:AddLine("TOC", 1, 1, 1)
                GameTooltip:AddLine("3819: " .. GetAchievementLink(3819))
                GameTooltip:AddLine("3818: " .. GetAchievementLink(3818))
                GameTooltip:AddLine("3810: " .. GetAchievementLink(3810))
                GameTooltip:Show()
            end)
            BG.GameTooltip_Hide(edit)

            local bt = CreateFrame("CheckButton", nil, f, "ChatConfigCheckButtonTemplate")
            bt:SetSize(25, 25)
            bt:SetPoint("TOPLEFT", AchievementTitleID, "BOTTOMLEFT", 0, -5)
            bt:SetHitRectInsets(0, -BG.MeetingHorn.WhisperFrame.width + 50, 0, 0)
            bt.Text:SetTextColor(RGB(BG.dis))
            bt.Text:SetWidth(BG.MeetingHorn.WhisperFrame.width - 50)
            bt.Text:SetWordWrap(false)
            if BiaoGe.MeetingHornWhisper[RealmId][player].AchievementChoose then
                bt:SetChecked(true)
            end
            AchievementCheckButton = bt
            bt:SetScript("OnClick", function(self)
                if self:GetChecked() then
                    BiaoGe.MeetingHornWhisper[RealmId][player].AchievementChoose = true
                else
                    BiaoGe.MeetingHornWhisper[RealmId][player].AchievementChoose = nil
                end
                PlaySound(BG.sound1, "Master")
            end)
            bt:SetScript("OnEnter", function(self)
                if edit:GetText() ~= "" and GetAchievementLink(edit:GetText()) then
                    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
                    GameTooltip:ClearLines()
                    GameTooltip:SetHyperlink(GetAchievementLink(edit:GetText()))
                end
            end)
            BG.GameTooltip_Hide(bt)

            edit:SetScript("OnTextChanged", function(self)
                if self:GetText() ~= "" and GetAchievementLink(self:GetText()) then
                    bt.Text:SetText(GetAchievementLink(self:GetText()))
                    BiaoGe.MeetingHornWhisper[RealmId][player].AchievementID = self:GetText()
                else
                    bt.Text:SetText(L["当前没有成就"])
                    BiaoGe.MeetingHornWhisper[RealmId][player].AchievementID = nil
                end
            end)
        end

        -- 装等
        local iLevelTitle, iLevelCheckButton
        do
            local t = f:CreateFontString()
            t:SetPoint("TOPLEFT", AchievementCheckButton, "BOTTOMLEFT", 0, -10)
            t:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
            t:SetTextColor(RGB(BG.g1))
            t:SetText(L["装等"])
            iLevelTitle = t

            local l = f:CreateLine()
            l:SetColorTexture(RGB("808080", 1))
            l:SetStartPoint("BOTTOMLEFT", t, -5, -2)
            l:SetEndPoint("BOTTOMLEFT", t, f.width - 25, -2)
            l:SetThickness(1)

            local bt = CreateFrame("CheckButton", nil, f, "ChatConfigCheckButtonTemplate")
            bt:SetSize(25, 25)
            bt:SetPoint("TOPLEFT", iLevelTitle, "BOTTOMLEFT", 0, -5)
            bt:SetHitRectInsets(0, 0, 0, 0)
            bt.Text:SetWidth(BG.MeetingHorn.WhisperFrame.width - 50)
            bt.Text:SetWordWrap(false)
            if BiaoGe.MeetingHornWhisper[RealmId][player].iLevelChoose then
                bt:SetChecked(true)
            end
            iLevelCheckButton = bt
            BG.MeetingHorn.iLevelCheckButton = bt
            bt:SetScript("OnClick", function(self)
                if self:GetChecked() then
                    BiaoGe.MeetingHornWhisper[RealmId][player].iLevelChoose = true
                else
                    BiaoGe.MeetingHornWhisper[RealmId][player].iLevelChoose = nil
                end
                PlaySound(BG.sound1, "Master")
            end)
        end

        -- 自定义文本
        local otherTitle, otherCheckButton, otherEdit
        do
            local t = f:CreateFontString()
            t:SetPoint("TOPLEFT", iLevelCheckButton, "BOTTOMLEFT", 0, -10)
            t:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
            t:SetTextColor(RGB(BG.g1))
            t:SetText(L["自定义文本"])
            otherTitle = t

            local l = f:CreateLine()
            l:SetColorTexture(RGB("808080", 1))
            l:SetStartPoint("BOTTOMLEFT", t, -5, -2)
            l:SetEndPoint("BOTTOMLEFT", t, f.width - 25, -2)
            l:SetThickness(1)

            local bt = CreateFrame("CheckButton", nil, f, "ChatConfigCheckButtonTemplate")
            bt:SetSize(25, 25)
            bt:SetPoint("TOPLEFT", otherTitle, "BOTTOMLEFT", 0, -5)
            bt:SetHitRectInsets(0, 0, 0, 0)
            if BiaoGe.MeetingHornWhisper[RealmId][player].otherChoose then
                bt:SetChecked(true)
            end
            otherCheckButton = bt
            BG.MeetingHorn.otherCheckButton = bt
            bt:SetScript("OnClick", function(self)
                if self:GetChecked() then
                    BiaoGe.MeetingHornWhisper[RealmId][player].otherChoose = true
                else
                    BiaoGe.MeetingHornWhisper[RealmId][player].otherChoose = nil
                end
                PlaySound(BG.sound1, "Master")
            end)

            -- 编辑框
            local edit = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
            edit:SetPoint("TOPLEFT", otherCheckButton, "TOPRIGHT", 5, -2)
            edit:SetSize(BG.MeetingHorn.WhisperFrame.width - 60, 20)
            edit:SetAutoFocus(false)
            edit:SetMaxBytes(100)
            if BiaoGe.MeetingHornWhisper[RealmId][player].otherText then
                edit:SetText(BiaoGe.MeetingHornWhisper[RealmId][player].otherText)
            end
            otherEdit = edit
            edit:SetScript("OnMouseDown", function(self, enter)
                if enter == "RightButton" then
                    edit:SetEnabled(false)
                    edit:SetText("")
                else
                    edit:SetFocus()
                end
            end)
            edit:SetScript("OnMouseUp", function(self, enter)
                if enter == "RightButton" then
                    edit:SetEnabled(true)
                end
            end)
            edit:SetScript("OnTextChanged", function(self)
                if self:GetText() ~= "" then
                    BiaoGe.MeetingHornWhisper[RealmId][player].otherText = self:GetText()
                else
                    BiaoGe.MeetingHornWhisper[RealmId][player].otherText = nil
                end
            end)
            edit:SetScript("OnEnterPressed", function(self)
                self:ClearFocus()
            end)
            edit:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
                GameTooltip:ClearLines()
                GameTooltip:AddLine(L["自定义文本参考"], 1, 1, 1)
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine(L["1、可以输入你的职业、天赋"])
                GameTooltip:AddLine(L["2、或你的经验、WCL分数等等"])
                GameTooltip:Show()
            end)
            BG.GameTooltip_Hide(edit)
        end

        -- 发送
        do
            local function SendWhisper(notshift)
                local text = " "
                if notshift and IsShiftKeyDown() then
                    return text
                end
                if BiaoGe.options["MeetingHorn_whisper"] == 1 then
                    if AchievementCheckButton:GetChecked() and AchievementEdit:GetText() ~= "" and GetAchievementLink(AchievementEdit:GetText()) then
                        text = text .. GetAchievementLink(AchievementEdit:GetText()) .. " "
                    end
                    if iLevelCheckButton:GetChecked() then
                        text = text .. iLevelCheckButton.Text:GetText() .. " "
                    end
                    if otherCheckButton:GetChecked() then
                        text = text .. otherEdit:GetText() .. " "
                    end
                end
                return text
            end

            Browser.ActivityList:SetCallback('OnItemSignupClick', function(_, button, item)
                if item:IsActivity() then
                    -- ChatFrame_SendTell(item:GetLeader())
                    ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
                    ChatEdit_ChooseBoxForSend():SetText("")
                    local text = "/W " .. item:GetLeader() .. SendWhisper("notshift")
                    ChatEdit_InsertLink(text)
                end
            end)

            local LFG = MeetingHorn:GetModule('LFG', 'AceEvent-3.0', 'AceTimer-3.0', 'AceComm-3.0', 'LibCommSocket-3.0')
            function Browser:CreateActivityMenu(activity)
                return {
                    {
                        text = format('|c%s%s|r', select(4, GetClassColor(activity:GetLeaderClass())), activity:GetLeader()),
                        isTitle = true,
                    }, {
                    text = WHISPER,
                    func = function()
                        -- ChatFrame_SendTell(activity:GetLeader())
                        ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
                        ChatEdit_ChooseBoxForSend():SetText("")
                        local text = "/W " .. activity:GetLeader() .. SendWhisper("notshift")
                        ChatEdit_InsertLink(text)
                    end,
                }, {
                    text = C_FriendList.IsIgnored(activity:GetLeader()) and IGNORE_REMOVE or IGNORE,
                    func = function()
                        C_FriendList.AddOrDelIgnore(activity:GetLeader())
                        if not C_FriendList.IsIgnored(activity:GetLeader()) then
                            LFG:RemoveActivity(activity)
                        end
                    end,
                }, { isSeparator = true }, { text = REPORT_PLAYER, isTitle = true }, {
                    text = REPORT_CHAT,
                    func = function()
                        local reportInfo = ReportInfo:CreateReportInfoFromType(Enum.ReportType.Chat)
                        local leader = activity:GetLeader()
                        print(leader)
                        ReportFrame:InitiateReport(reportInfo, leader, activity:GetLeaderPlayerLocation())
                        -- ns.GUI:CloseMenu()
                    end,
                }, { isSeparator = true }, { text = CANCEL },
                }
            end

            local function FindDropdownItem(dropdown, text)
                local name = dropdown:GetName()
                for i = 1, UIDROPDOWNMENU_MAXBUTTONS do
                    local dropdownItem = _G[name .. 'Button' .. i]
                    if dropdownItem:IsShown() and dropdownItem:GetText() == text then
                        return i, dropdownItem
                    end
                end
            end
            hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData)
                -- pt(dropdownMenu, which, unit, name, userData)
                if BiaoGe.options["MeetingHorn_whisper"] ~= 1 then return end
                if (UIDROPDOWNMENU_MENU_LEVEL > 1) then return end
                if which == "FRIEND" then
                    local info = UIDropDownMenu_CreateInfo()
                    info.text = L["密语模板"]
                    info.notCheckable = true
                    info.tooltipTitle = L["使用密语模板"]
                    local text = SendWhisper()
                    if text ~= " " then
                        text = text:sub(2)
                        info.tooltipText = text
                    end
                    info.func = function()
                        ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
                        ChatEdit_ChooseBoxForSend():SetText("")
                        local text = "/W " .. dropdownMenu.name .. SendWhisper()
                        ChatEdit_InsertLink(text)
                    end
                    UIDropDownMenu_AddButton(info)

                    -- 调整按钮位置，放在密语按钮后
                    local dropdownName = 'DropDownList' .. 1
                    local dropdown = _G[dropdownName]
                    local myindex, mybutton = FindDropdownItem(dropdown, L["密语模板"])
                    local index, whisperbutton = FindDropdownItem(dropdown, WHISPER)
                    local x, y = select(4, whisperbutton:GetPoint())
                    y = y - UIDROPDOWNMENU_BUTTON_HEIGHT
                    if IsAddOnLoaded("tdInspect") and not UnitIsUnit('player', Ambiguate(name, 'none')) then
                        y = y - UIDROPDOWNMENU_BUTTON_HEIGHT
                    end
                    mybutton:ClearAllPoints()
                    mybutton:SetPoint("TOPLEFT", x, y)

                    for i = index + 1, UIDROPDOWNMENU_MAXBUTTONS do
                        if i ~= myindex then
                            local dropdownItem = _G[dropdownName .. 'Button' .. i]
                            if dropdownItem:IsShown() then
                                local p, r, rp, x, y = dropdownItem:GetPoint(1)
                                dropdownItem:SetPoint(p, r, rp, x, y - UIDROPDOWNMENU_BUTTON_HEIGHT)
                            else
                                break
                            end
                        end
                    end
                    if IsAddOnLoaded("tdInspect") and not UnitIsUnit('player', Ambiguate(name, 'none')) then
                        dropdown:SetHeight(dropdown:GetHeight() + UIDROPDOWNMENU_BUTTON_HEIGHT)
                    end
                end
            end)

            local edit = ChatEdit_ChooseBoxForSend()
            local dropDown = LibBG:Create_UIDropDownMenu(nil, edit)
            edit:HookScript("OnMouseUp", function(self, button)
                if BiaoGe.options["MeetingHorn_whisper"] ~= 1 then return end
                if button == "RightButton" then
                    local menu = {
                        {
                            text = L["密语模板"],
                            notCheckable = true,
                            tooltipTitle = L["使用密语模板"],
                            func = function()
                                ChatEdit_ActivateChat(edit)
                                local text = SendWhisper()
                                text = text:gsub("^%s", "")
                                edit:SetCursorPosition(strlen(edit:GetText()))
                                ChatEdit_InsertLink(text)
                            end
                        },
                        {
                            text = CANCEL,
                            notCheckable = true,
                            func = function(self)
                                LibBG:CloseDropDownMenus()
                            end,
                        }
                    }
                    local text = SendWhisper()
                    if text ~= " " then
                        text = text:sub(2)
                        menu[1].tooltipText = text
                    end
                    LibBG:EasyMenu(menu, dropDown, "cursor", 0, 20, "MENU", 2)
                end
            end)
        end
    end
end)
