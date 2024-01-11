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
local HopeMaxn = ADDONSELF.HopeMaxn
local HopeMaxb = ADDONSELF.HopeMaxb
local HopeMaxi = ADDONSELF.HopeMaxi
local FrameHide = ADDONSELF.FrameHide
local AddTexture = ADDONSELF.AddTexture
local GetItemID = ADDONSELF.GetItemID

local pt = print
local RealmId = GetRealmID()
local player = UnitName("player")
local itemlib

function BG.HopeUI(FB)
    if not BG.Frame[FB].boss1.zhuangbei1 then return end

    local preWidget
    local framedown
    local frameright
    local framedownH
    local red, greed, blue = 1, 1, 1
    local touming1, touming2 = 0.1, 0.1
    local btwidth = 120
    local titlewidth = 100
    local titlewidth2 = 20

    for n = 1, HopeMaxn[FB], 1 do
        ------------------标题------------------
        do
            local version = BG["HopeFrame" .. FB]:CreateFontString()
            if n == 1 then
                version:SetPoint("TOPLEFT", BG.MainFrame, "TOPLEFT", 10, -60)
            elseif n == 2 or n == 4 then
                version:SetPoint("TOPLEFT", frameright, "TOPRIGHT", titlewidth2, 0)
            elseif n == 3 then
                version:SetPoint("TOPRIGHT", framedownH, "TOPLEFT", -titlewidth2, -30)
            end
            version:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
            version:SetTextColor(RGB(BG.y2))
            version:SetWidth(titlewidth)
            version:SetWordWrap(false)
            version:SetJustifyH("RIGHT")
            if not BG.IsVanilla() then
                if n == 1 then
                    version:SetText(L["< |cffFFFFFF10人|r|cff00BFFF普通|r >"])
                elseif n == 2 then
                    version:SetText(L["< |cffFFFFFF25人|r|cff00BFFF普通|r >"])
                elseif n == 3 then
                    version:SetText(L["< |cffFFFFFF10人|r|cffFF0000英雄|r >"])
                elseif n == 4 then
                    version:SetText(L["< |cffFFFFFF25人|r|cffFF0000英雄|r >"])
                end
            end
            preWidget = version

            for i = 1, HopeMaxi, 1 do
                local version = BG["HopeFrame" .. FB]:CreateFontString()
                if i == 1 then
                    version:SetPoint("TOPLEFT", preWidget, "TOPRIGHT", titlewidth2, 0)
                    framedown = version
                else
                    version:SetPoint("TOPLEFT", preWidget, "TOPRIGHT", titlewidth2 + 6, 0)
                    frameright = version
                end
                version:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
                version:SetTextColor(RGB(BG.y2))
                version:SetText(L["心愿"] .. i)
                version:SetWidth(btwidth)
                version:SetWordWrap(false)
                version:SetJustifyH("LEFT")
                preWidget = version
            end
        end
        for b = 1, HopeMaxb[FB], 1 do
            for i = 1, HopeMaxi, 1 do
                ------------------装备------------------
                do
                    local bt = CreateFrame("EditBox", nil, BG["HopeFrame" .. FB], "InputBoxTemplate")
                    bt:SetSize(btwidth, 20)
                    bt:SetFrameLevel(110)
                    if i == 1 then
                        bt:SetPoint("TOPLEFT", framedown, "BOTTOMLEFT", 0, -4)
                    else
                        bt:SetPoint("TOPLEFT", framedown, "TOPLEFT", (btwidth + 26) * (i - 1), 0)
                    end
                    bt:SetAutoFocus(false)
                    bt:Show()
                    bt.FB = FB
                    bt.bossnum = b
                    bt.hopenandu = n
                    bt.i = i
                    bt.icon = bt:CreateTexture(nil, 'ARTWORK')
                    bt.icon:SetPoint('LEFT', -22, 0)
                    bt.icon:SetSize(16, 16)
                    if BiaoGe.Hope[RealmId][player][FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] then
                        if BiaoGe.Hope[RealmId][player][FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] ~= "" then
                            bt:SetText(BiaoGe.Hope[RealmId][player][FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i])
                        else
                            BiaoGe.Hope[RealmId][player][FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] = nil
                        end
                    end
                    BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] = bt
                    preWidget = bt
                    if i == 1 then
                        framedown = bt
                        if n == 1 or n == 3 and b == HopeMaxb[FB] then
                            framedownH = bt
                        end
                    end
                    -- 创建已掉落文本
                    BG.LootedText(bt)

                    -- 内容改变时
                    local _, class = UnitClass("player")
                    local RealmId = GetRealmID()
                    local player = UnitName("player")
                    bt:SetScript("OnTextChanged", function(self)
                        local itemText = bt:GetText()
                        local itemID = select(1, GetItemInfoInstant(itemText))
                        local name, link, quality, level, _, _, _, _, _, Texture, _, typeID, _, bindType = GetItemInfo(itemText)
                        local hard
                        if link then
                            if FB == "ULD" then
                                for index, value in ipairs(BG.Loot.ULD.Hard10) do
                                    if itemID == value then
                                        self:SetText(link .. "H")
                                        hard = true
                                    end
                                end
                                if not hard then
                                    for index, value in ipairs(BG.Loot.ULD.Hard25) do
                                        if itemID == value then
                                            self:SetText(link .. "H")
                                        end
                                    end
                                end
                            elseif FB == "ICC" then
                                if itemID == 52030 or itemID == 52029 or itemID == 52028 then
                                    self:SetText(link .. "H")
                                end
                            end
                            -- 装备图标
                            self.icon:SetTexture(Texture)
                        else
                            self.icon:SetTexture(nil)
                        end
                        if self:GetText() == "" then
                            BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["jingzheng" .. i]:Hide()
                        end

                        local num = BiaoGe.FilterClassItemDB[RealmId][player].chooseID -- 隐藏
                        if num ~= 0 then
                            BG.UpdateFilter(self)
                        end

                        -- 更新装备库心愿
                        local _itemID = GetItemID(self:GetText())
                        local itemID = GetItemID(BiaoGe.Hope[RealmId][player][FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i])
                        if not _itemID and itemID then
                            BG.UpdateItemLib_LeftHope(itemID, 0)
                            BG.UpdateItemLib_RightHope(itemID, 0)
                        elseif _itemID and _itemID ~= itemID then
                            BG.UpdateItemLib_LeftHope(_itemID, 1)
                            BG.UpdateItemLib_RightHope(_itemID, 1)
                        end

                        if bt:GetText() ~= "" then
                            BiaoGe.Hope[RealmId][player][FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] = bt:GetText() -- 储存文本
                        else
                            BiaoGe.Hope[RealmId][player][FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] = nil
                        end

                        -- 装绑图标
                        BG.BindOnEquip(self, bindType)
                        -- 在按钮右边增加装等显示
                        BG.LevelText(self, level, typeID)
                        -- 更新已掉落
                        BG.Update_IsLooted(self)
                    end)
                    -- 点击
                    bt:SetScript("OnMouseDown", function(self, enter)
                        if enter == "RightButton" then -- 右键清空格子
                            self:SetEnabled(false)
                            self:SetText("")
                            if BG.lastfocus then
                                BG.lastfocus:ClearFocus()
                            end
                            return
                        end
                        if IsShiftKeyDown() then
                            if self:GetText() ~= "" then
                                self:SetEnabled(false)
                                bt:ClearFocus()
                                if BG.lastfocus then
                                    BG.lastfocus:ClearFocus()
                                end
                                local f = GetCurrentKeyBoardFocus()
                                if not f then
                                    ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
                                end
                                local text = self:GetText()
                                ChatEdit_InsertLink(text)
                            end
                            return
                        end
                        if IsAltKeyDown() then
                            if self:GetText() ~= "" then
                                self:SetEnabled(false)
                                bt:ClearFocus()
                                if BG.lastfocus then
                                    BG.lastfocus:ClearFocus()
                                end
                            end
                            return
                        end
                        if IsControlKeyDown() then
                            if self:GetText() ~= "" then
                                self:SetEnabled(false)
                                BG.TurntoItemLib(self)
                            end
                            return
                        end
                    end)
                    bt:SetScript("OnMouseUp", function(self, enter)
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
                        for n = 1, HopeMaxn[FB], 1 do
                            for b = 1, HopeMaxb[FB] do
                                for i = 1, HopeMaxi do
                                    if BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] then
                                        BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:SetEnabled(true)
                                    end
                                end
                            end
                        end
                        if enter == "RightButton" then -- 右键清空格子
                            self:SetEnabled(true)
                        end
                    end)
                    -- 鼠标悬停在装备时
                    bt:SetScript("OnEnter", function(self)
                        BG.HopeFrameDs[FB .. 1]["nandu" .. n]["boss" .. b]["ds" .. i]:Show()
                        if not tonumber(self:GetText()) then
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
                            GameTooltip:ClearLines()
                            local itemLink = bt:GetText()
                            local itemID = select(1, GetItemInfoInstant(itemLink))
                            if itemID then
                                GameTooltip:SetItemByID(itemID)
                                GameTooltip:Show()
                                -- BG.HistoryJine(FB, itemID)
                                local h = { FB, itemID }
                                BG.HistoryJine(unpack(h))
                                BG.HistoryMOD = h
                            end
                        end
                    end)
                    bt:SetScript("OnLeave", function(self)
                        BG.HopeFrameDs[FB .. 1]["nandu" .. n]["boss" .. b]["ds" .. i]:Hide()
                        GameTooltip:Hide()
                        if BG["HistoryJineFrameDB1"] then
                            for i = 1, BG.HistoryJineFrameDBMax do
                                BG["HistoryJineFrameDB" .. i]:Hide()
                            end
                            BG.HistoryJineFrame:Hide()
                        end
                    end)
                    -- 获得光标时
                    bt:SetScript("OnEditFocusGained", function(self)
                        FrameHide(1)
                        self:HighlightText()
                        BG.lastfocuszhuangbei = self
                        BG.lastfocus = self

                        local infoType, itemID, itemLink = GetCursorInfo()
                        if infoType ~= "item" then
                            BG.SetListzhuangbei(self)
                        end

                        if BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i + 1] then
                            BG.lastfocuszhuangbei2 = BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i + 1]
                        else
                            BG.lastfocuszhuangbei2 = nil
                        end
                        BG.HopeFrameDs[FB .. 2]["nandu" .. n]["boss" .. b]["ds" .. i]:Show()
                    end)
                    -- 失去光标时
                    bt:SetScript("OnEditFocusLost", function(self)
                        self:HighlightText(0, 0)
                        BG.HopeFrameDs[FB .. 2]["nandu" .. n]["boss" .. b]["ds" .. i]:Hide()
                    end)
                    -- 按TAB跳转右边
                    bt:SetScript("OnTabPressed", function(self)
                        if i == 1 then
                            BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. 2]:SetFocus()
                        elseif b ~= HopeMaxb[FB] then
                            BG.HopeFrame[FB]["nandu" .. n]["boss" .. b + 1]["zhuangbei" .. 1]:SetFocus()
                        elseif n ~= HopeMaxn[FB] then
                            local nn
                            if n == 3 then
                                nn = 2
                            elseif n == 2 then
                                nn = 4
                            elseif n == 1 then
                                if HopeMaxn[FB] > 2 then
                                    nn = 3
                                else
                                    nn = 2
                                end
                            end
                            BG.HopeFrame[FB]["nandu" .. nn]["boss" .. 1]["zhuangbei" .. 1]:SetFocus()
                        end
                    end)
                    -- 按ENTER跳转下边
                    bt:SetScript("OnEnterPressed", function(self)
                        if b ~= HopeMaxb[FB] then
                            BG.HopeFrame[FB]["nandu" .. n]["boss" .. b + 1]["zhuangbei" .. i]:SetFocus()
                        elseif n ~= HopeMaxn[FB] then
                            local nn
                            if n == 3 then
                                nn = 2
                            elseif n == 2 then
                                nn = 4
                            elseif n == 1 then
                                if HopeMaxn[FB] > 2 then
                                    nn = 3
                                else
                                    nn = 2
                                end
                            end
                            BG.HopeFrame[FB]["nandu" .. nn]["boss" .. 1]["zhuangbei" .. i]:SetFocus()
                        end
                    end)
                    -- 按箭头跳转
                    bt:SetScript("OnKeyDown", function(self, enter)
                        if not IsModifierKeyDown() then
                            if enter == "UP" then -- 上↑
                                if b ~= 1 then
                                    BG.HopeFrame[FB]["nandu" .. n]["boss" .. b - 1]["zhuangbei" .. i]:SetFocus()
                                else
                                    local nn
                                    if n == 4 then
                                        nn = 2
                                    elseif n == 3 then
                                        nn = 1
                                    elseif n == 2 then
                                        if HopeMaxn[FB] > 2 then
                                            nn = 4
                                        else
                                            nn = 2
                                        end
                                    elseif n == 1 then
                                        if HopeMaxn[FB] > 2 then
                                            nn = 3
                                        else
                                            nn = 1
                                        end
                                    end
                                    BG.HopeFrame[FB]["nandu" .. nn]["boss" .. HopeMaxb[FB]]["zhuangbei" .. i]:SetFocus()
                                end
                            elseif enter == "DOWN" then -- 下↓
                                if b ~= HopeMaxb[FB] then
                                    BG.HopeFrame[FB]["nandu" .. n]["boss" .. b + 1]["zhuangbei" .. i]:SetFocus()
                                else
                                    local nn
                                    if n == 4 then
                                        nn = 2
                                    elseif n == 3 then
                                        nn = 1
                                    elseif n == 2 then
                                        if HopeMaxn[FB] > 2 then
                                            nn = 4
                                        else
                                            nn = 1
                                        end
                                    elseif n == 1 then
                                        if HopeMaxn[FB] > 2 then
                                            nn = 3
                                        else
                                            nn = 1
                                        end
                                    end
                                    BG.HopeFrame[FB]["nandu" .. nn]["boss" .. 1]["zhuangbei" .. i]:SetFocus()
                                end
                            elseif enter == "LEFT" then -- 左←
                                if i == 2 then
                                    BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. 1]:SetFocus()
                                else
                                    local nn
                                    if n == 4 then
                                        nn = 3
                                    elseif n == 3 then
                                        nn = 4
                                    elseif n == 2 then
                                        nn = 1
                                    elseif n == 1 then
                                        nn = 2
                                    end
                                    BG.HopeFrame[FB]["nandu" .. nn]["boss" .. b]["zhuangbei" .. 2]:SetFocus()
                                end
                            elseif enter == "RIGHT" then -- 右→
                                if i == 1 then
                                    BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. 2]:SetFocus()
                                else
                                    local nn
                                    if n == 4 then
                                        nn = 3
                                    elseif n == 3 then
                                        nn = 4
                                    elseif n == 2 then
                                        nn = 1
                                    elseif n == 1 then
                                        nn = 2
                                    end
                                    BG.HopeFrame[FB]["nandu" .. nn]["boss" .. b]["zhuangbei" .. 1]:SetFocus()
                                end
                            end
                        else
                            if enter == "UP" or enter == "DOWN" then -- 上↑下↓
                                if HopeMaxn[FB] > 2 then
                                    local nn
                                    if n == 1 or n == 2 then
                                        nn = n + 2
                                    else
                                        nn = n - 2
                                    end
                                    BG.HopeFrame[FB]["nandu" .. nn]["boss" .. b]["zhuangbei" .. i]:SetFocus()
                                end
                            elseif enter == "LEFT" or enter == "RIGHT" then -- 左←右→
                                local nn
                                if n == 1 or n == 3 then
                                    nn = n + 1
                                else
                                    nn = n - 1
                                end
                                BG.HopeFrame[FB]["nandu" .. nn]["boss" .. b]["zhuangbei" .. i]:SetFocus()
                            end
                        end
                    end)
                    -- 按ESC退出
                    bt:SetScript("OnEscapePressed", function(self)
                        self:ClearFocus()
                        if BG.FrameZhuangbeiList then
                            BG.FrameZhuangbeiList:Hide()
                        end
                    end)
                    -- 复原按钮为可点击
                    bt:SetScript("OnShow", function(self)
                        bt:Enable()
                    end)
                end

                ------------------装备有竞争------------------
                do
                    local f = CreateFrame("Frame", nil, BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i])
                    f:SetSize(25, 23)
                    f:SetPoint("CENTER", 0, 0)
                    f:SetFrameLevel(112)
                    f:Hide()
                    f.text = f:CreateFontString()
                    f.text:SetPoint("CENTER")
                    f.text:SetSize(25, 23)
                    f.text:SetFont(BIAOGE_TEXT_FONT, 20, "OUTLINE")
                    BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["jingzheng" .. i] = f

                    -- 鼠标悬停提示
                    f:SetScript("OnEnter", function(self)
                        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
                        GameTooltip:ClearLines()
                        GameTooltip:AddLine(format(L["当前团队还有 %s 人也许愿该装备！"], self.text:GetText()), 1, 0, 0, true)
                        GameTooltip:AddLine(L["右键取消提示"], 1, 0.82, 0, true)
                        GameTooltip:Show()
                    end)
                    f:SetScript("OnLeave", function(self)
                        GameTooltip:Hide()
                    end)
                    -- 单击触发
                    f:SetScript("OnMouseDown", function(self, enter)
                        if enter == "RightButton" then -- 右键清空格子
                            FrameHide(0)
                            self:Hide()
                        end
                    end)
                end

                ------------------底色材质------------------
                do
                    -- 先做底色材质1（鼠标悬停的）
                    local textrue = BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:CreateTexture()
                    textrue:SetPoint("TOPLEFT", BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i], "TOPLEFT", -4, -2)
                    textrue:SetPoint("BOTTOMRIGHT", BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i], "BOTTOMRIGHT", -1, 0)
                    textrue:SetColorTexture(red, greed, blue, touming1)
                    textrue:Hide()
                    BG.HopeFrameDs[FB .. 1]["nandu" .. n]["boss" .. b]["ds" .. i] = textrue

                    -- 底色材质2（点击框体后）
                    local textrue = BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:CreateTexture()
                    textrue:SetPoint("TOPLEFT", BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i], "TOPLEFT", -4, -2)
                    textrue:SetPoint("BOTTOMRIGHT", BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i], "BOTTOMRIGHT", -1, 0)
                    textrue:SetColorTexture(red, greed, blue, touming2)
                    textrue:Hide()
                    BG.HopeFrameDs[FB .. 2]["nandu" .. n]["boss" .. b]["ds" .. i] = textrue

                    -- 底色材质3（团长发的装备高亮）
                    local textrue = BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:CreateTexture()
                    textrue:SetPoint("TOPLEFT", BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i], "TOPLEFT", -4, -2)
                    textrue:SetPoint("BOTTOMRIGHT", BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i], "BOTTOMRIGHT", -1, 0)
                    textrue:SetColorTexture(1, 1, 0, BG.HighLightAlpha)
                    textrue:Hide()
                    BG.HopeFrameDs[FB .. 3]["nandu" .. n]["boss" .. b]["ds" .. i] = textrue
                end
            end
            ------------------BOSS名字------------------
            do
                local version = BG["HopeFrame" .. FB]:CreateFontString()
                version:SetPoint("TOPRIGHT", BG.HopeFrame[FB]["nandu" .. n]["boss" .. b].zhuangbei1, "TOPLEFT", -titlewidth2 - 6, -3)
                version:SetFont(BIAOGE_TEXT_FONT, 14, "OUTLINE")
                version:SetTextColor(RGB(BG.Boss[FB]["boss" .. b].color))
                version:SetText(BG.Boss[FB]["boss" .. b].name2)
                version:SetWidth(titlewidth)
                version:SetWordWrap(false)
                version:SetJustifyH("RIGHT")

                BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["name"] = version
            end
        end
    end

    ------------------查询团队竞争------------------
    do
        local btjingzheng = CreateFrame("Button", nil, BG["HopeFrame" .. FB], "UIPanelButtonTemplate") -- 查询团队竞争按键
        btjingzheng:SetSize(130, 30)
        btjingzheng:SetPoint("TOPRIGHT", BG.MainFrame, "TOPRIGHT", -30, -80)
        btjingzheng:SetText(L["查询心愿竞争"])
        btjingzheng:Show()
        btjingzheng:SetFrameLevel(105)
        BG["HopeJingZheng" .. FB] = btjingzheng

        btjingzheng:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:SetText(L["查询团队里，有多少人许愿跟你相同的装备"])
        end)
        btjingzheng:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)
        btjingzheng:SetScript("OnClick", function(self) -- 点击
            if not IsInRaid(1) then
                SendSystemMessage(L["不在团队，无法查询"])
                return
            end
            BG.HopeJingzheng = {}
            local yes
            for n = 1, HopeMaxn[FB] do
                for b = 1, HopeMaxb[FB] do
                    for i = 1, HopeMaxi do
                        if BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] then
                            BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["jingzheng" .. i]:Hide()
                            local itemID = GetItemInfoInstant(BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:GetText())
                            if itemID then
                                BG.HopeJingzheng[itemID] = {}
                                C_ChatInfo.SendAddonMessage("BiaoGe", "Hope-" .. FB .. " " .. itemID, "RAID")
                            end
                        end
                    end
                end
            end

            C_Timer.After(1.5, function() -- 2秒后出结果
                for n = 1, HopeMaxn[FB] do
                    for b = 1, HopeMaxb[FB] do
                        for i = 1, HopeMaxi do
                            if BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] then
                                local itemID = GetItemInfoInstant(BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:GetText())
                                if itemID then
                                    for key, value in pairs(BG.HopeJingzheng) do
                                        if tonumber(itemID) == tonumber(key) and #BG.HopeJingzheng[key] ~= 0 then
                                            BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["jingzheng" .. i].text:SetText(BG.STC_r1(#BG.HopeJingzheng[key]))
                                            BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["jingzheng" .. i]:Show()
                                            yes = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if not yes then
                    SendSystemMessage(BG.STC_g1(L["恭喜你，当前团队没人许愿跟你相同的装备"]))
                end
            end)
            self:SetEnabled(false)
            C_Timer.After(2, function()
                self:SetEnabled(true)
            end)
        end)
    end

    ------------------分享心愿------------------
    do
        local f
        local xinyuan
        if BG.IsVanilla() then
            xinyuan = {
                { name1 = L["分享心愿"], name2 = "" },
            }
        else
            xinyuan = {
                { name1 = L["分享心愿10PT"], name2 = "10PT" },
                { name1 = L["分享心愿25PT"], name2 = "25PT" },
                { name1 = L["分享心愿10H"], name2 = "10H" },
                { name1 = L["分享心愿25H"], name2 = "25H" },
            }
        end
        -- local xinyuan = { L["分享心愿10PT"], L["分享心愿25PT"], L["分享心愿10H"], L["分享心愿25H"] }
        -- local xinyuan2 = { "10PT", "25PT", "10H", "25H" }
        for n = 1, HopeMaxn[FB] do
            local bt = CreateFrame("Button", nil, BG["HopeFrame" .. FB], "UIPanelButtonTemplate") -- 分享心愿按键
            bt:SetSize(130, 30)
            if n == 1 then
                bt:SetPoint("TOPLEFT", BG["HopeJingZheng" .. FB], "BOTTOMLEFT", 0, -50)
            else
                bt:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -10)
            end
            bt:SetText(xinyuan[n].name1)
            bt:SetFrameLevel(105)
            f = bt

            -- 鼠标悬停提示
            bt:SetScript("OnEnter", function(self)
                local text = "|cffffffff" .. L["< 我 的 心 愿 >"] .. RN
                text = text .. L["副本: "] .. (BG[FB .. "name"] .. " " .. xinyuan[n].name2) .. "\n"
                for b = 1, HopeMaxb[FB] do
                    local link = {}
                    for i = 1, HopeMaxi do
                        if BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] then
                            local _, l = GetItemInfo(BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:GetText())
                            if l then
                                table.insert(link, l)
                            end
                        end
                    end
                    local tx
                    if Size(link) ~= 0 then
                        tx = "|cff" .. BG.Boss[FB]["boss" .. b]["color"] .. BG.Boss[FB]["boss" .. b]["name2"] .. ": |r"
                        for index, value in ipairs(link) do
                            tx = tx .. value
                        end
                        text = text .. tx .. "\n"
                    end
                end
                GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
                GameTooltip:ClearLines()
                GameTooltip:SetText(text)
            end)
            bt:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
            end)

            -- 单击触发
            bt:SetScript("OnClick", function(self)
                FrameHide(0)
                if not BiaoGe["HopeSendChannel"] then return end
                if BiaoGe["HopeSendChannel"] == "RAID" then
                    if not IsInRaid(1) then
                        SendSystemMessage(L["不在团队，无法通报"])
                        PlaySound(BG.sound1, "Master")
                        return
                    end
                end
                if BiaoGe["HopeSendChannel"] == "PARTY" then
                    if not IsInGroup() then
                        SendSystemMessage(L["不在队伍，无法通报"])
                        PlaySound(BG.sound1, "Master")
                        return
                    end
                end
                if BiaoGe["HopeSendChannel"] == "GUILD" then
                    if not IsInGuild() then
                        SendSystemMessage(L["没有公会，无法通报"])
                        PlaySound(BG.sound1, "Master")
                        return
                    end
                end
                if BiaoGe["HopeSendChannel"] == "WHISPER" then
                    if not UnitName("target") then
                        SendSystemMessage(L["没有目标，无法通报"])
                        PlaySound(BG.sound1, "Master")
                        return
                    end
                end

                self:SetEnabled(false) -- 点击后按钮变灰2秒
                C_Timer.After(2, function()
                    bt:SetEnabled(true)
                end)
                local channel = BiaoGe["HopeSendChannel"]
                local text = L["————我的心愿————"]
                SendChatMessage(text, channel, nil, UnitName("target"))
                text = L["副本: "] .. BG[FB .. "name"] .. " " .. xinyuan[n].name2
                SendChatMessage(text, channel, nil, UnitName("target"))
                for b = 1, HopeMaxb[FB] do
                    local link = {}
                    for i = 1, HopeMaxi do
                        if BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] then
                            local _, l = GetItemInfo(BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:GetText())
                            if l then
                                table.insert(link, l)
                            end
                        end
                    end
                    if Size(link) ~= 0 then
                        text = BG.Boss[FB]["boss" .. b]["name2"] .. ": "
                        for index, value in ipairs(link) do
                            text = text .. value
                        end
                        SendChatMessage(text, channel, nil, UnitName("target"))
                    end
                end
                -- text = L["——感谢使用金团表格——"]
                -- SendChatMessage(text, channel, nil, UnitName("target"))
                PlaySoundFile(BG.sound2)
            end)
        end

        -- 频道
        BG.HopeSendTable = {
            RAID = L["频道：团队"],
            PARTY = L["频道：队伍"],
            GUILD = L["频道：公会"],
            WHISPER = L["频道：密语"],
        }
        if not BG.HopeSenddropDown then
            BG.HopeSenddropDown = {}
        end
        if not BiaoGe["HopeSendChannel"] then
            BiaoGe["HopeSendChannel"] = "RAID"
        end

        local dropDown = LibBG:Create_UIDropDownMenu(nil, BG["HopeFrame" .. FB])
        BG.HopeSenddropDown[FB] = dropDown
        BG.dropDownToggle(dropDown)
        dropDown:SetPoint("TOP", f, "BOTTOM", 0, -10)
        LibBG:UIDropDownMenu_SetWidth(dropDown, 120)
        LibBG:UIDropDownMenu_SetAnchor(dropDown, -10, 0, "TOPRIGHT", dropDown, "BOTTOMRIGHT")
        LibBG:UIDropDownMenu_SetText(dropDown, BG.HopeSendTable[BiaoGe["HopeSendChannel"]])
        LibBG:UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
            FrameHide(0)
            PlaySound(BG.sound1, "Master")
            local info = LibBG:UIDropDownMenu_CreateInfo()
            info.text, info.func = L["团队"], function()
                BiaoGe["HopeSendChannel"] = "RAID"
                LibBG:UIDropDownMenu_SetText(dropDown, BG.HopeSendTable[BiaoGe["HopeSendChannel"]])
                FrameHide(0)
                PlaySound(BG.sound1, "Master")
            end
            LibBG:UIDropDownMenu_AddButton(info)
            local info = LibBG:UIDropDownMenu_CreateInfo()
            info.text, info.func = L["队伍"], function()
                BiaoGe["HopeSendChannel"] = "PARTY"
                LibBG:UIDropDownMenu_SetText(dropDown, BG.HopeSendTable[BiaoGe["HopeSendChannel"]])
                FrameHide(0)
                PlaySound(BG.sound1, "Master")
            end
            LibBG:UIDropDownMenu_AddButton(info)
            local info = LibBG:UIDropDownMenu_CreateInfo()
            info.text, info.func = L["公会"], function()
                BiaoGe["HopeSendChannel"] = "GUILD"
                LibBG:UIDropDownMenu_SetText(dropDown, BG.HopeSendTable[BiaoGe["HopeSendChannel"]])
                FrameHide(0)
                PlaySound(BG.sound1, "Master")
            end
            LibBG:UIDropDownMenu_AddButton(info)
            local info = LibBG:UIDropDownMenu_CreateInfo()
            info.text, info.func = L["密语目标"], function()
                BiaoGe["HopeSendChannel"] = "WHISPER"
                LibBG:UIDropDownMenu_SetText(dropDown, BG.HopeSendTable[BiaoGe["HopeSendChannel"]])
                FrameHide(0)
                PlaySound(BG.sound1, "Master")
            end
            LibBG:UIDropDownMenu_AddButton(info)
        end)
    end

    -- 更新已掉落显示
    BG["HopeFrame" .. FB]:HookScript("OnShow", function(self)
        BG.UpdateHopeFrame_IsLooted_All()
    end)

    -- 退队后装备竞争数字隐藏
    BG.RegisterEvent("GROUP_ROSTER_UPDATE", function(self, even)
        BG.After(1, function()
            if not IsInRaid(1) then
                for k, FB in pairs(BG.FBtable) do
                    for n = 1, HopeMaxn[FB] do
                        for b = 1, HopeMaxb[FB] do
                            for i = 1, HopeMaxi do
                                if BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] then
                                    BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["jingzheng" .. i]:Hide()
                                end
                            end
                        end
                    end
                end
            end
        end)
    end)
end

------------------处理查询团队竞争事件------------------
do
    local f = CreateFrame("Frame") -- 团队消息
    f:RegisterEvent("CHAT_MSG_ADDON")
    f:SetScript("OnEvent", function(self, even, ...)
        local prefix, msg, distType, sender = ...
        if prefix ~= "BiaoGe" then return end
        if distType ~= "RAID" then return end
        local sendername = strsplit("-", sender)
        local playername = UnitName("player")
        if sendername == playername then return end
        if strfind(msg, "^(Hope)") then
            local _, fbitemID = strsplit("-", msg)
            local FB, itemID = strsplit(" ", fbitemID)
            itemID = tonumber(itemID)
            if not itemID then return end
            for n = 1, HopeMaxn[FB] do
                for b = 1, HopeMaxb[FB] do
                    for i = 1, HopeMaxi do
                        if BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] then
                            if itemID == GetItemInfoInstant(BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:GetText()) then
                                C_ChatInfo.SendAddonMessage("BiaoGe", "True-" .. itemID, "WHISPER", sender)
                                return
                            end
                        end
                    end
                end
            end
        end
    end)

    local f = CreateFrame("Frame") -- 私密消息
    f:RegisterEvent("CHAT_MSG_ADDON")
    f:SetScript("OnEvent", function(self, even, ...)
        local prefix, msg, distType, sender = ...
        if prefix ~= "BiaoGe" then return end
        if distType ~= "WHISPER" then return end
        if strfind(msg, "^(True)") then
            local _, itemID = strsplit("-", msg)
            itemID = tonumber(itemID)
            if not itemID then return end
            table.insert(BG.HopeJingzheng[itemID], itemID)
        end
    end)
end
