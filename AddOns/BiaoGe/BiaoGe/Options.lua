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
local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi

local pt = print

local O = {}

local function OptionsUI()
    local main = CreateFrame("Frame", nil, UIParent)
    main:Hide()
    main.name = L["BiaoGe"]
    InterfaceOptions_AddCategory(main)
    local t = main:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    t:SetText("|cff" .. "00BFFF" .. L["< BiaoGe > 金 团 表 格"] .. "|r")
    t:SetPoint("TOPLEFT", main, 15, 0)
    local top = t
    local t = main:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall2")
    t:SetText(L["|cff808080（带*的设置为即时生效，否则需要重载才能生效）|r"])
    t:SetPoint("BOTTOMLEFT", top, "BOTTOMRIGHT", 5, 0)
    -- RL
    local bt = CreateFrame("Button", nil, main, "UIPanelButtonTemplate")
    bt:SetSize(80, 25)
    bt:SetPoint("TOPRIGHT", 0, 0)
    bt:SetText(L["重载界面"])
    bt:SetScript("OnClick", function(self)
        ReloadUI()
    end)
    bt:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
        GameTooltip:ClearLines()
        GameTooltip:SetText(L["不能即时生效的设置在重载后生效"])
    end)
    bt:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    -- 背景框
    local f = CreateFrame("Frame", nil, main, "BackdropTemplate")
    f:SetBackdrop({
        bgFile = "Interface/ChatFrame/ChatFrameBackground",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    f:SetBackdropColor(0, 0, 0, 0.4)
    f:SetPoint("TOPLEFT", SettingsPanel.Container, 5, -60)
    f:SetPoint("BOTTOMRIGHT", SettingsPanel.Container, -5, 0)
    BG.optionsBackground = f
    -- 点空白处取消光标
    SettingsPanel.Container:HookScript("OnMouseDown", function(self, enter)
        local f = GetCurrentKeyBoardFocus()
        if f then
            f:ClearFocus()
        end
    end)


    -- 子选项
    local Frames = {}
    local biaoge, roleOverview, boss, others
    do
        local last

        local function CreateTab(name, text) -- "Options_biaoge",L["表格"],biaoge
            local bt = CreateFrame("Button", "BG.Button" .. name, main)
            bt:SetHeight(25)
            bt:SetNormalFontObject(BG.FontBlue1)
            bt:SetDisabledFontObject(BG.FontWhile1)
            bt:SetHighlightFontObject(BG.FontHilight)
            -- local tex = bt:CreateTexture()
            -- tex:SetColorTexture(RGB("FFFFFF", 0.1))
            -- bt:SetHighlightTexture(tex)
            local tex = bt:CreateTexture(nil, "ARTWORK") -- 高亮材质
            tex:SetTexture("interface/paperdollinfoframe/ui-character-tab-highlight")
            bt:SetHighlightTexture(tex)
            if not last then
                bt:SetPoint("TOPLEFT", 15, -35)
            else
                bt:SetPoint("LEFT", last, "RIGHT", 0, 0)
            end
            bt:SetText(text)
            local t = bt:GetFontString()
            bt:SetWidth(t:GetStringWidth() + 30)
            BG["Button" .. name] = bt
            last = bt
            bt:SetScript("OnClick", function(self)
                BG.HideTab(Frames, BG["Frame" .. name])
                BiaoGe.options.lastFrame = "Frame" .. name
                PlaySound(BG.sound1, "Master")
            end)

            local f = CreateFrame("Frame", nil, bt)
            tinsert(Frames, f)
            f:Hide()
            BG["Frame" .. name] = f
            local frame = CreateFrame("Frame", nil, f)
            frame:SetSize(1, 1)
            local s = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
            s:SetPoint("TOPLEFT", SettingsPanel.Container, 15, -70)
            s:SetPoint("BOTTOMRIGHT", SettingsPanel.Container, -35, 10)
            s:SetScrollChild(frame)

            return frame
        end

        biaoge = CreateTab("Options_biaoge", L["表格"])
        roleOverview = CreateTab("Options_roleOverview", L["角色总览"])
        boss = CreateTab("Options_boss", L["团本攻略"])
        others = CreateTab("Options_others", L["其他插件增强"])

        if BiaoGe.options.lastFrame then
            BG[BiaoGe.options.lastFrame]:Show()
            BG[BiaoGe.options.lastFrame]:GetParent():SetEnabled(false)
        else
            BG.FrameOptions_biaoge:Show()
            BG.FrameOptions_biaoge:GetParent():SetEnabled(false)
        end
    end



    -- 模板
    do
        -- 滑块
        do
            local function updateSliderEditBox(self)
                local slider = self.__owner
                local minValue, maxValue = slider:GetMinMaxValues()
                local text = tonumber(self:GetText())
                if not text then return end
                text = min(maxValue, text)
                text = max(minValue, text)
                slider:SetValue(text)
                self:SetText(text)
                BiaoGe.options[slider.name] = text
                self:ClearFocus()
                PlaySound(BG.sound1, "Master")
            end
            local function OnValueChanged(self, value)
                self.edit:ClearFocus()
                value = tonumber(value)
                BiaoGe.options[self.name] = value
                self.edit:SetText(value)
            end
            local function OnClick(self, enter)
                local slider = self.__owner
                if enter == "RightButton" then
                    if BG.options[slider.name .. "reset"] then
                        local value = BG.options[slider.name .. "reset"]
                        BiaoGe.options[slider.name] = value
                        slider:SetValue(value)
                        slider.edit:SetText(value)
                        PlaySound(BG.sound1, "Master")
                    end
                end
            end
            local function OnEnter(self)
                local slider = self.__owner
                if slider.ontext then
                    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 5)
                    GameTooltip:ClearLines()
                    GameTooltip:SetText(slider.ontext)
                end
            end
            local function OnLeave(self)
                GameTooltip:Hide()
            end
            function O.CreateSlider(name, text, parent, minValue, maxValue, step, x, y, ontext, width)
                local value = min(maxValue, BiaoGe.options[name])
                value = max(minValue, value)
                BiaoGe.options[name] = value

                local slider = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
                slider:SetPoint("TOPLEFT", parent, x, y)
                slider:SetWidth(width or 180)
                slider:SetMinMaxValues(minValue, maxValue)
                slider:SetValueStep(step)
                slider:SetObeyStepOnDrag(true)
                slider:SetHitRectInsets(0, 0, 0, 0)
                slider:SetValue(BiaoGe.options[name])
                slider.name = name
                slider.ontext = ontext
                slider:SetScript("OnValueChanged", OnValueChanged)

                slider.Low:SetText(minValue)
                slider.Low:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 10, -2)
                slider.High:SetText(maxValue)
                slider.High:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", -10, -2)
                slider.Text:ClearAllPoints()
                slider.Text:SetPoint("CENTER", 0, 25)
                slider.Text:SetText(text)
                slider.Text:SetTextColor(1, .8, 0)

                slider.edit = CreateFrame("EditBox", nil, slider, "InputBoxTemplate")
                slider.edit:SetSize(50, 20)
                slider.edit:SetPoint("TOP", slider, "BOTTOM")
                slider.edit:SetJustifyH("CENTER")
                slider.edit:SetAutoFocus(false)
                slider.edit:SetText(BiaoGe.options[name])
                slider.edit:SetCursorPosition(0)
                slider.edit.__owner = slider
                slider.edit:SetScript("OnEnterPressed", updateSliderEditBox)
                slider.edit:SetScript("OnEditFocusLost", updateSliderEditBox)

                slider.button = CreateFrame("Button", nil, slider)
                slider.button:SetAllPoints(slider.Text)
                slider.button:RegisterForClicks("RightButtonUp")
                slider.button.__owner = slider
                slider.button:SetScript("OnClick", OnClick)
                slider.button:SetScript("OnEnter", OnEnter)
                slider.button:SetScript("OnLeave", OnLeave)

                return slider
            end
        end
        -- 多选按钮
        do
            local function OnClick(self)
                if self:GetChecked() then
                    BiaoGe.options[self.name] = 1
                else
                    BiaoGe.options[self.name] = 0
                end
                PlaySound(BG.sound1, "Master")
            end
            local function OnEnter(self)
                GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
                GameTooltip:ClearLines()
                GameTooltip:SetText(self.ontext)
            end
            local function OnLeave(self)
                GameTooltip:Hide()
            end
            function O.CreateCheckButton(name, text, parent, x, y, ontext)
                local bt = CreateFrame("CheckButton", nil, parent, "ChatConfigCheckButtonTemplate")
                bt:SetSize(30, 30)
                bt:SetPoint("TOPLEFT", parent, x, y)
                bt.Text:SetText(text)
                bt:SetHitRectInsets(0, -bt.Text:GetWidth(), 0, 0)
                bt.name = name
                bt.ontext = ontext
                BG.options["button" .. name] = bt
                if BiaoGe.options[name] == 1 then
                    bt:SetChecked(true)
                else
                    bt:SetChecked(false)
                end
                bt:SetScript("OnClick", OnClick)
                bt:SetScript("OnEnter", OnEnter)
                bt:SetScript("OnLeave", OnLeave)
                return bt
            end
        end
        -- 线
        do
            function O.CreateLine(parent, y, height)
                local l = parent:CreateLine()
                l:SetColorTexture(RGB("808080", 1))
                l:SetStartPoint("TOPLEFT", 5, y)
                l:SetEndPoint("TOPLEFT", SettingsPanel.Container:GetWidth() - 20, y)
                l:SetThickness(height or 1.5)
                return l
            end
        end
    end
    --------------------------------------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------------------------------------
    -- 表格设置
    do
        local height = 0

        -- UI缩放
        do
            local name = "scale"
            do
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

                if not BiaoGe.options[name] then
                    if BiaoGe.Scale then
                        BiaoGe.options[name] = BiaoGe.Scale
                    else
                        BiaoGe.options[name] = BG.options[name .. "reset"]
                    end
                end
                BG.MainFrame:SetScale(BiaoGe.options[name])
                BG.ReceiveMainFrame:SetScale(tonumber(BiaoGe.options[name]) * 0.95)
                if BG.FBCDFrame then
                    BG.FBCDFrame:SetScale(BiaoGe.options[name])
                end
            end

            local ontext = L["|cffffffff< UI缩放 >|r|cff808080（右键还原设置）|r\n\n1、调整表格UI的大小"]
            local f = O.CreateSlider(name, "|cffFFFFFF" .. L["UI缩放*"] .. "|r", biaoge, 0.5, 1.5, 0.05, 15, height - 30, ontext)
            BG.options["button" .. name] = f

            f:SetScript("OnValueChanged", function(self, value)
                f.edit:ClearFocus()
                value = tonumber(string.format("%.2f", value))
                BiaoGe.options[name] = value
                f.edit:SetText(value)
                BG.MainFrame:SetScale(value)
                BG.ReceiveMainFrame:SetScale(tonumber(value) * 0.95)
                if BG.FBCDFrame then
                    BG.FBCDFrame:SetScale(value)
                end
            end)
            f.button:SetScript("OnClick", function(self, enter)
                if enter == "RightButton" then
                    if BG.options[name .. "reset"] then
                        local value = BG.options[name .. "reset"]
                        BiaoGe.options[name] = value
                        f:SetValue(value)
                        f.edit:SetText(value)
                        BG.MainFrame:SetScale(value)
                        BG.ReceiveMainFrame:SetScale(tonumber(value) * 0.95)
                        if BG.FBCDFrame then
                            BG.FBCDFrame:SetScale(value)
                        end
                        PlaySound(BG.sound1, "Master")
                    end
                end
            end)
        end
        -- UI透明度
        do
            local name = "alpha"
            BG.options[name .. "reset"] = 1
            if not BiaoGe.options[name] then
                if BiaoGe.Alpha then
                    BiaoGe.options[name] = BiaoGe.Alpha
                else
                    BiaoGe.options[name] = BG.options[name .. "reset"]
                end
            end
            BG.MainFrame:SetAlpha(BiaoGe.options[name])

            local ontext = L["|cffffffff< UI透明度 >|r|cff808080（右键还原设置）|r\n\n1、调整表格UI的透明度"]
            local f = O.CreateSlider(name, "|cffFFFFFF" .. L["UI透明度*"] .. "|r", biaoge, 0.5, 1, 0.05, 220, height - 30, ontext)
            BG.options["button" .. name] = f

            f:SetScript("OnValueChanged", function(self, value)
                f.edit:ClearFocus()
                value = tonumber(string.format("%.2f", value))
                BiaoGe.options[name] = value
                f.edit:SetText(value)
                BG.MainFrame:SetAlpha(value)
                roleOverview:SetAlpha(value)
            end)
            f.button:SetScript("OnClick", function(self, enter)
                if enter == "RightButton" then
                    if BG.options[name .. "reset"] then
                        local value = BG.options[name .. "reset"]
                        BiaoGe.options[name] = value
                        f:SetValue(value)
                        f.edit:SetText(value)
                        BG.MainFrame:SetAlpha(value)
                        PlaySound(BG.sound1, "Master")
                    end
                end
            end)
        end


        local h = 85
        O.CreateLine(biaoge, height - h)
        h = h + 15
        -- 自动记录装备
        do
            local name = "autoLoot"
            BG.options[name .. "reset"] = 1
            if not BiaoGe.options[name] then
                if BiaoGe.AutoLoot then
                    BiaoGe.options[name] = BiaoGe.AutoLoot
                else
                    BiaoGe.options[name] = BG.options[name .. "reset"]
                end
            end
            local ontext = L["|cffffffff< 自动记录装备 >|r\n\n1、在团本里拾取装备时，会自动记录进表格\n2、只会记录橙装、紫装、和蓝色的宝珠，不会记录图纸，小怪掉落会记录到杂项里\n"]
            local f = O.CreateCheckButton(name, BG.STC_g1(L["自动记录装备*"]), biaoge, 15, height - h, ontext)
            BG.options["button" .. name] = f
            f:HookScript("OnClick", function()
                local name1 = "lootTime"
                local name2 = "lootFontSize"
                if f:GetChecked() then
                    BG.options["button" .. name1]:Show()
                    BG.options["button" .. name2]:Show()
                else
                    BG.options["button" .. name1]:Hide()
                    BG.options["button" .. name2]:Hide()
                end
            end)
        end
        -- 装备记录通知显示时长
        do
            local name = "lootTime"
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 装备记录通知时长 >|r|cff808080（右键还原设置）|r\n\n1、自动记录装备后会在屏幕上方通知记录结果"]
            local f = O.CreateSlider(name, "|cffFFFFFF" .. L["装备记录通知时长(秒)"] .. "|r", biaoge, 1, 30, 1, 220, height - h - 25, ontext)
            BG.options["button" .. name] = f
            local name = "autoLoot"
            if BiaoGe.options[name] ~= 1 then
                f:Hide()
            end
        end
        -- 装备记录通知字体大小
        do
            local name = "lootFontSize"
            BG.options[name .. "reset"] = 20
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 装备记录通知字体大小 >|r|cff808080（右键还原设置）|r\n\n1、调整该字体的大小"]
            local f = O.CreateSlider(name, "|cffFFFFFF" .. L["装备记录通知字体大小*"] .. "|r", biaoge, 10, 30, 1, 425, height - h - 25, ontext)
            BG.options["button" .. name] = f
            f:HookScript("OnValueChanged", function(self, value)
                BG.FrameLootMsg:SetFont(BIAOGE_TEXT_FONT, value, "OUTLINE")
            end)
            local name = "autoLoot"
            if BiaoGe.options[name] ~= 1 then
                f:Hide()
            end
        end


        local h = 180
        O.CreateLine(biaoge, height - h)
        h = h + 15
        -- 交易自动记账
        do
            local name = "autoTrade"
            BG.options[name .. "reset"] = 1
            if not BiaoGe.options[name] then
                if BiaoGe.AutoTrade then
                    BiaoGe.options[name] = BiaoGe.AutoTrade
                else
                    BiaoGe.options[name] = BG.options[name .. "reset"]
                end
            end
            local ontext = L["|cffffffff< 交易自动记账 >|r\n\n1、需要配合自动记录装备，因为如果表格里没有该交易的装备，则记账失败\n2、如果一次交易两件装备以上，则只会记第一件装备\n"]
            local f = O.CreateCheckButton(name, BG.STC_g1(L["交易自动记账*"]), biaoge, 15, height - h, ontext)
            BG.options["button" .. name] = f
            f:HookScript("OnClick", function()
                local name1 = "tradePreview"
                local name2 = "tradeNotice"
                local name3 = "tradeTime"
                local name4 = "tradeFontSize"
                if f:GetChecked() then
                    BG.options["button" .. name1]:Show()
                    BG.options["button" .. name2]:Show()
                    BG.options["button" .. name3]:Show()
                    BG.options["button" .. name4]:Show()
                else
                    BG.options["button" .. name1]:Hide()
                    BG.options["button" .. name2]:Hide()
                    BG.options["button" .. name3]:Hide()
                    BG.options["button" .. name4]:Hide()
                end
            end)
        end
        -- 交易通知显示时长
        do
            local name = "tradeTime"
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 交易通知时长 >|r|cff808080（右键还原设置）|r\n\n1、通知显示多久"]
            local f = O.CreateSlider(name, "|cffFFFFFF" .. L["交易通知时长(秒)"] .. "|r", biaoge, 1, 10, 1, 220, height - h - 25, ontext)
            BG.options["button" .. name] = f
            local name = "autoTrade"
            if BiaoGe.options[name] ~= 1 or BiaoGe.options["tradeNotice"] ~= 1 then
                f:Hide()
            end
        end
        -- 交易通知字体大小
        do
            local name = "tradeFontSize"
            BG.options[name .. "reset"] = 20
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 交易通知字体大小 >|r|cff808080（右键还原设置）|r\n\n1、调整该字体的大小"]
            local f = O.CreateSlider(name, "|cffFFFFFF" .. L["交易通知字体大小*"] .. "|r", biaoge, 10, 30, 1, 425, height - h - 25, ontext)
            BG.options["button" .. name] = f
            f:HookScript("OnValueChanged", function(self, value)
                BG.FrameTradeMsg:SetFont(BIAOGE_TEXT_FONT, value, "OUTLINE")
            end)
            local name = "autoTrade"
            if BiaoGe.options[name] ~= 1 or BiaoGe.options["tradeNotice"] ~= 1 then
                f:Hide()
            end
        end
        h = h + 30
        -- 交易通知
        do
            local name = "tradeNotice"
            BG.options[name .. "reset"] = 1
            if not BiaoGe.options[name] then
                if BiaoGe.AutoTrade then
                    BiaoGe.options[name] = BiaoGe.AutoTrade
                else
                    BiaoGe.options[name] = BG.options[name .. "reset"]
                end
            end
            local ontext = L["|cffffffff< 交易通知 >|r\n\n1、交易完成后会在屏幕中央通知本次记账结果\n"]
            local f = O.CreateCheckButton(name, L["交易通知*"], biaoge, 15, height - h, ontext)
            BG.options["button" .. name] = f
            f:HookScript("OnClick", function()
                local name1 = "tradeTime"
                local name2 = "tradeFontSize"
                if f:GetChecked() then
                    BG.options["button" .. name1]:Show()
                    BG.options["button" .. name2]:Show()
                else
                    BG.options["button" .. name1]:Hide()
                    BG.options["button" .. name2]:Hide()
                end
            end)
            local name = "autoTrade"
            if BiaoGe.options[name] ~= 1 then
                f:Hide()
            end
        end
        h = h + 30
        -- 记账效果预览框
        do
            local name = "tradePreview"
            BG.options[name .. "reset"] = 1
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 记账效果预览框 >|r\n\n1、交易的时候，可以预览这次的记账效果\n2、如果这次交易的装备不在表格，则可以选择强制记账"]
            local f = O.CreateCheckButton(name, L["记账效果预览框*"], biaoge, 15, height - h, ontext)
            BG.options["button" .. name] = f
            local name = "autoTrade"
            if BiaoGe.options[name] ~= 1 then
                f:Hide()
            end
        end


        local h = 300
        O.CreateLine(biaoge, height - h)
        h = h + 15
        -- 高亮拍卖装备
        do
            local name = "auctionHigh"
            BG.options[name .. "reset"] = 1
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 高亮拍卖装备 >|r\n\n1、当团长或物品分配者贴出装备开始拍卖时，会自动高亮表格里相应的装备"]
            local f = O.CreateCheckButton(name, BG.STC_g1(L["高亮拍卖装备*"]), biaoge, 15, height - h, ontext)
            BG.options["button" .. name] = f
            f:HookScript("OnClick", function()
                local name = "auctionHighTime"
                if f:GetChecked() then
                    BG.options["button" .. name]:Show()
                else
                    BG.options["button" .. name]:Hide()
                end
            end)
        end
        -- 高亮拍卖装备时长
        do
            local name = "auctionHighTime"
            BG.options[name .. "reset"] = 20
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 高亮拍卖装备时长 >|r|cff808080（右键还原设置）|r\n\n1、高亮拍卖装备多久"]
            local f = O.CreateSlider(name, "|cffFFFFFF" .. L["高亮拍卖装备时长(秒)*"] .. "|r", biaoge, 1, 60, 1, 220, height - h - 25, ontext)
            BG.options["button" .. name] = f
            local name = "auctionHigh"
            if BiaoGe.options[name] ~= 1 then
                f:Hide()
            end
        end
        h = h + 30
        -- 拍卖聊天记录框
        do
            local name = "auctionChat"
            BG.options[name .. "reset"] = 1
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 拍卖聊天记录框 >|r\n\n1、自动记录全团跟拍卖有关的聊天\n2、当你点击买家或金额时会显示拍卖聊天记录"]
            local f = O.CreateCheckButton(name, L["拍卖聊天记录框*"], biaoge, 15, height - h, ontext)
            BG.options["button" .. name] = f
        end


        local h = 395
        O.CreateLine(biaoge, height - h)
        h = h + 15
        -- 拍卖倒数
        do
            local name = "countDown"
            BG.options[name .. "reset"] = 1
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 拍卖倒数 >|r\n\n1、该功能只有团长或物品分配者可用\n2、ALT+点击当前表格、背包、聊天框的装备，自动开始拍卖倒数\n3、背包目前支持原生背包、NDUI背包、EUI背包、大脚背包\n"]
            local f = O.CreateCheckButton(name, BG.STC_b1(L["拍卖倒数*"]), biaoge, 15, height - h, ontext)
            BG.options["button" .. name] = f
            f:HookScript("OnClick", function()
                local name1 = "countDownDuration"
                local name2 = "countDownSendChannel"
                if f:GetChecked() then
                    BG.options["button" .. name1]:Show()
                    BG.options["button" .. name2]:Show()
                else
                    BG.options["button" .. name1]:Hide()
                    BG.options["button" .. name2]:Hide()
                end
            end)
        end
        -- 拍卖倒数时长
        do
            local name = "countDownDuration"
            BG.options[name .. "reset"] = 8
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 拍卖倒数时长 >|r|cff808080（右键还原设置）|r\n\n1、拍卖装备倒数多久，默认是8秒"]
            local f = O.CreateSlider(name, "|cffFFFFFF" .. L["拍卖倒数时长(秒)*"] .. "|r", biaoge, 1, 20, 1, 220, height - h - 25, ontext)
            BG.options["button" .. name] = f
            local name = "countDown"
            if BiaoGe.options[name] ~= 1 then
                f:Hide()
            end
        end
        h = h + 30
        -- 拍卖倒数通报频道
        do
            local name = "countDownSendChannel"
            BG.options[name .. "reset"] = "RAID_WARNING"
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end

            local function RaidText(channel)
                local text
                if channel == "RAID_WARNING" then
                    text = L["通报至团队通知频道"]
                elseif channel == "RAID" then
                    text = L["通报至团队频道"]
                end
                return text
            end

            local dropDown = LibBG:Create_UIDropDownMenu(nil, biaoge)
            dropDown:SetPoint("TOPLEFT", 0, height - h - 2)
            LibBG:UIDropDownMenu_SetWidth(dropDown, 170)
            LibBG:UIDropDownMenu_SetText(dropDown, RaidText(BiaoGe.options[name]))
            BG.options["button" .. name] = dropDown

            LibBG:UIDropDownMenu_Initialize(dropDown, function(self, level)
                PlaySound(BG.sound1, "Master")
                local info = LibBG:UIDropDownMenu_CreateInfo()
                info.text, info.func = L["通报至团队通知频道"], function()
                    BiaoGe.options[name] = "RAID_WARNING"
                    LibBG:UIDropDownMenu_SetText(dropDown, RaidText(BiaoGe.options[name]))
                    PlaySound(BG.sound1, "Master")
                end
                LibBG:UIDropDownMenu_AddButton(info)
                local info = LibBG:UIDropDownMenu_CreateInfo()
                info.text, info.func = L["通报至团队频道"], function()
                    BiaoGe.options[name] = "RAID"
                    LibBG:UIDropDownMenu_SetText(dropDown, RaidText(BiaoGe.options[name]))
                    PlaySound(BG.sound1, "Master")
                end
                LibBG:UIDropDownMenu_AddButton(info)
            end)

            local name = "countDown"
            if BiaoGe.options[name] ~= 1 then
                dropDown:Hide()
            end
        end


        local h = 490
        O.CreateLine(biaoge, height - h)
        h = h + 15
        -- 进本提示清空表格
        do
            local name = "showQingKong"
            BG.options[name .. "reset"] = 1
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 进本提示清空表格 >|r\n\n1、每次进入副本都会提示清空表格"]
            local f = O.CreateCheckButton(name, L["进本提示清空表格*"], biaoge, 15, height - h, ontext)
            BG.options["button" .. name] = f
        end
        -- 清空表格时保留支出补贴名称
        do
            local name = "retainExpenses"
            BG.options[name .. "reset"] = 1
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 清空表格时保留支出补贴名称 >|r\n\n1、只保留补贴名称（例如XX补贴），支出玩家和支出金额正常清空\n2、这样就不用每次都重复填写补贴名称\n3、只有补贴名称，但没有补贴金额的，在通报账单时不会被通报"]
            local f = O.CreateCheckButton(name, L["清空表格时保留支出补贴名称*"], biaoge, 220, height - h, ontext)
            BG.options["button" .. name] = f
        end
        h = h + 30
        -- 清空表格时根据副本难度设置分钱人数
        do
            local name = "autoQingKong"
            BG.options[name .. "reset"] = 1
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 清空表格时根据副本难度设置分钱人数 >|r\n\n1、10人团本默认分钱人数为10人\n2、25人团本默认分钱人数为25人"]
            local f = O.CreateCheckButton(name, L["清空表格时根据副本难度设置分钱人数*"], biaoge, 15, height - h, ontext)
            BG.options["button" .. name] = f
            f:HookScript("OnClick", function()
                local name = "MaxPlayers"
                if f:GetChecked() then
                    BG.options["button" .. name]:Show()
                else
                    BG.options["button" .. name]:Hide()
                end
            end)
        end
        h = h + 30
        -- 分钱人数
        do
            local name = "MaxPlayers"
            local f = CreateFrame("Frame", nil, BG.options.buttonautoQingKong)
            BG.options["button" .. name] = f
            local name = "autoQingKong"
            if BiaoGe.options[name] ~= 1 then
                f:Hide()
            end

            local text = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            text:SetPoint("TOPLEFT", BG.options.buttonautoQingKong, "BOTTOMRIGHT", 0, -5)
            text:SetText(L["|cffFFFFFF10人团本分钱人数：|r"])

            local edit = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
            edit:SetSize(50, 20)
            edit:SetPoint("LEFT", text, "RIGHT", 5, 0)
            edit:SetJustifyH("CENTER")
            edit:SetText(BiaoGe.options["10MaxPlayers"] or "10")
            edit:SetAutoFocus(false)
            edit:SetScript("OnTextChanged", function(self)
                BiaoGe.options["10MaxPlayers"] = tonumber(self:GetText()) or 10
            end)

            local text = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            text:SetPoint("LEFT", edit, "RIGHT", 40, 0)
            text:SetText(L["|cffFFFFFF25人团本分钱人数：|r"])

            local edit = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
            edit:SetSize(50, 20)
            edit:SetPoint("LEFT", text, "RIGHT", 5, 0)
            edit:SetJustifyH("CENTER")
            edit:SetText(BiaoGe.options["25MaxPlayers"] or "25")
            edit:SetAutoFocus(false)
            edit:SetScript("OnTextChanged", function(self)
                BiaoGe.options["25MaxPlayers"] = tonumber(self:GetText()) or 25
            end)
        end



        local h = 605
        O.CreateLine(biaoge, height - h)
        h = h + 15
        -- 金额自动加零
        do
            local name = "autoAdd0"
            BG.options[name .. "reset"] = 0
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 金额自动加零 >|r\n\n1、输入金额和欠款时自动加两个0，减少记账操作，提高记账效率"]
            local f = O.CreateCheckButton(name, L["金额自动加零*"], biaoge, 15, height - h, ontext)
            BG.options["button" .. name] = f
        end

        -- 对账单保存时长(小时)
        do
            local name = "duiZhangTime"
            local ontext = L["|cffffffff< 对账单保存时长(小时) >|r|cff808080（右键还原设置）|r\n\n1、对账单保存多久后自动删除"]
            local f = O.CreateSlider(name, "|cffFFFFFF" .. L["对账单保存时长(小时)"] .. "|r", biaoge, 1, 168, 1, 220, height - h - 25, ontext)
            BG.options["button" .. name] = f
        end
        h = h + 30

        -- 按键交互声音
        do
            local name = "buttonSound"
            BG.options[name .. "reset"] = 1
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            if BiaoGe.options[name] == 1 then
                BG.sound1 = SOUNDKIT.GS_TITLE_OPTION_OK
                BG.sound2 = 569593
            else
                BG.sound1 = 1
                BG.sound2 = 1
            end
            local ontext = L["|cffffffff< 按键交互声音 >|r\n\n1、点击按钮时的声音"]
            local f = O.CreateCheckButton(name, L["按键交互声音*"], biaoge, 15, height - h, ontext)
            BG.options["button" .. name] = f
            f:HookScript("OnClick", function()
                if f:GetChecked() then
                    BG.sound1 = SOUNDKIT.GS_TITLE_OPTION_OK
                    BG.sound2 = 569593
                else
                    BG.sound1 = 1
                    BG.sound2 = 1
                end
            end)
        end
        h = h + 30

        -- 小地图图标
        do
            local name = "miniMap"
            BG.options[name .. "reset"] = 1
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 小地图图标 >|r\n\n1、显示小地图图标"]
            local f = O.CreateCheckButton(name, L["小地图图标*"], biaoge, 15, height - h, ontext)
            BG.options["button" .. name] = f
            f:HookScript("OnClick", function()
                local icon = LibStub("LibDBIcon-1.0", true)
                if icon then
                    if f:GetChecked() then
                        icon:Show(AddonName)
                    else
                        icon:Hide(AddonName)
                    end
                end
            end)
        end
    end

    -- 角色总览设置
    do
        if not BG.Vanilla() then
            local function CreateFBCDbutton(FBCDall_table, n1, n2, width, height, width2)
                local right
                for i = n1, n2 do
                    local name = FBCDall_table[i].name
                    local color = FBCDall_table[i].color
                    local fbId = FBCDall_table[i].fbId
                    local maxplayers = FBCDall_table[i].num and (FBCDall_table[i].num .. L["人"]) or ""

                    local bt = CreateFrame("CheckButton", nil, roleOverview, "ChatConfigCheckButtonTemplate")
                    bt:SetSize(25, 25)
                    bt:SetHitRectInsets(0, -width2 + 45, 0, 0)
                    if not right then
                        bt:SetPoint("TOPLEFT", roleOverview, "TOPLEFT", width, height)
                    else
                        bt:SetPoint("TOPLEFT", right, "TOPLEFT", width2, 0)
                    end
                    right = bt
                    bt.Text:SetText("|cff" .. color .. name .. RR)

                    if not BiaoGe.FBCDchoice[name] or BiaoGe.FBCDchoice[name] == 0 then
                        BiaoGe.FBCDchoice[name] = nil
                        bt:SetChecked(false)
                    else
                        BiaoGe.FBCDchoice[name] = 1
                        bt:SetChecked(true)
                    end

                    bt:SetScript("OnClick", function(self)
                        if self:GetChecked() then
                            BiaoGe.FBCDchoice[name] = 1
                        else
                            BiaoGe.FBCDchoice[name] = nil
                        end

                        PlaySound(BG.sound1, "Master")
                    end)
                    -- 鼠标悬停提示
                    bt:SetScript("OnEnter", function(self)
                        local text = "|cff" .. color .. maxplayers .. GetRealZoneText(fbId) .. RR
                        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
                        GameTooltip:ClearLines()
                        GameTooltip:SetText(text)
                    end)
                    bt:SetScript("OnLeave", function(self)
                        GameTooltip:Hide()
                    end)
                end
            end
            local function CreateMONEYbutton(MONEYall_table, n1, n2, width, height, width2)
                local right
                for i = n1, n2 do
                    local name = MONEYall_table[i].name
                    local tex = MONEYall_table[i].tex
                    local color = MONEYall_table[i].color
                    local id = MONEYall_table[i].id

                    local bt = CreateFrame("CheckButton", nil, roleOverview, "ChatConfigCheckButtonTemplate")
                    bt:SetSize(25, 25)
                    bt:SetHitRectInsets(0, -width2 + 40, 0, 0)
                    if not right then
                        bt:SetPoint("TOPLEFT", roleOverview, "TOPLEFT", width, height)
                    else
                        bt:SetPoint("TOPLEFT", right, "TOPLEFT", width2, 0)
                    end
                    right = bt
                    bt.Text:SetText(AddTexture(tex))

                    if not BiaoGe.MONEYchoice[id] or BiaoGe.MONEYchoice[id] == 0 then
                        BiaoGe.MONEYchoice[id] = nil
                        bt:SetChecked(false)
                    else
                        BiaoGe.MONEYchoice[id] = 1
                        bt:SetChecked(true)
                    end

                    bt:SetScript("OnClick", function(self)
                        if self:GetChecked() then
                            BiaoGe.MONEYchoice[id] = 1
                        else
                            BiaoGe.MONEYchoice[id] = nil
                        end
                        BG.MoneyBannerupdate()

                        PlaySound(BG.sound1, "Master")
                    end)
                    -- 鼠标悬停提示
                    bt:SetScript("OnEnter", function(self)
                        local text = "|cff" .. color .. name .. RR
                        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
                        GameTooltip:ClearLines()
                        GameTooltip:SetText(text)
                    end)
                    bt:SetScript("OnLeave", function(self)
                        GameTooltip:Hide()
                    end)
                end
            end

            -- 删除按钮
            local bt = CreateFrame("Button", nil, roleOverview)
            bt:SetSize(70, 22)
            bt:SetPoint("TOPRIGHT", BG.optionsBackground, -30, -15)
            bt:SetNormalFontObject(BG.FontRed1)
            bt:SetDisabledFontObject(BG.FontDisabled)
            bt:SetHighlightFontObject(BG.FontHilight)
            bt:SetText(L["删除角色"])
            local dropDown = LibBG:Create_UIDropDownMenu(nil, roleOverview)
            LibBG:UIDropDownMenu_SetAnchor(dropDown, 0, 0, "TOPLEFT", bt, "TOPRIGHT")
            bt:SetScript("OnMouseUp", function()
                if _G.L_DropDownList1 and _G.L_DropDownList1:IsVisible() then
                    _G.L_DropDownList1:Hide()
                else
                    BG.SetFBCD()
                    local RealmId = GetRealmID()
                    local channelTypeMenu = {
                        {
                            isTitle = true,
                            text = L["删除角色"],
                            notCheckable = true,
                        },
                        {
                            isTitle = true,
                            text = L["总览数据"],
                            notCheckable = true,
                        },
                        {
                            isTitle = true,
                            text = "",
                            notCheckable = true,
                        },
                    }

                    for i, _ in ipairs(BG.PlayerItemsLevel) do
                        for p, v in pairs(BiaoGe.Money[RealmId]) do
                            if BG.PlayerItemsLevel[i].player == p then
                                local a = {
                                    text = v.colorplayer,
                                    notCheckable = true,
                                    func = function()
                                        BiaoGe.Money[RealmId][p] = nil
                                        BiaoGe.FBCD[RealmId][p] = nil
                                        BiaoGe.PlayerItemsLevel[RealmId][p] = nil
                                        for i = #BG.PlayerItemsLevel, 1, -1 do
                                            if BG.PlayerItemsLevel[i].player == p then
                                                tremove(BG.PlayerItemsLevel, i)
                                            end
                                        end
                                    end
                                }
                                tinsert(channelTypeMenu, a)
                            end
                        end
                    end

                    local a = {
                        isTitle = true,
                        text = "",
                        notCheckable = true,
                    }
                    tinsert(channelTypeMenu, a)

                    local a = {
                        text = CANCEL,
                        notCheckable = true,
                        func = function(self)
                            LibBG:CloseDropDownMenus()
                        end,
                    }
                    tinsert(channelTypeMenu, a)
                    LibBG:EasyMenu(channelTypeMenu, dropDown, bt, 0, 0, "MENU", 3)
                    PlaySound(BG.sound1, "Master")
                end
            end)

            -- 创建多选按钮
            do
                local width = 15
                local height = -15
                local height_jiange = 22
                local line_height = 4

                --团本CD
                local text = roleOverview:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                text:SetPoint("TOPLEFT", width, height)
                text:SetText(BG.STC_b1(L["巫妖王之怒*"]))
                height = height - height_jiange

                O.CreateLine(roleOverview, height + line_height)

                CreateFBCDbutton(BG.FBCDall_table, 1, 4, width, height, 100)
                height = height - height_jiange
                CreateFBCDbutton(BG.FBCDall_table, 5, 8, width, height, 100)
                height = height - height_jiange
                CreateFBCDbutton(BG.FBCDall_table, 9, 12, width, height, 100)
                height = height - height_jiange
                CreateFBCDbutton(BG.FBCDall_table, 13, 18, width, height, 100)

                height = height - height_jiange - height_jiange
                local text = roleOverview:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                text:SetPoint("TOPLEFT", width, height)
                text:SetText(BG.STC_r3(L["燃烧的远征*"]))
                height = height - height_jiange

                O.CreateLine(roleOverview, height + line_height)

                CreateFBCDbutton(BG.FBCDall_table, 19, 27, width, height, 65)
                height = height - height_jiange - height_jiange
                local text = roleOverview:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                text:SetPoint("TOPLEFT", width, height)
                text:SetText(BG.STC_g2(L["经典旧世*"]))
                height = height - height_jiange

                O.CreateLine(roleOverview, height + line_height)

                CreateFBCDbutton(BG.FBCDall_table, 28, 32, width, height, 65)

                -- 货币
                height = height - height_jiange - height_jiange
                local text = roleOverview:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                text:SetPoint("TOPLEFT", width, height)
                text:SetText(BG.STC_y1(L["货币*"]))
                height = height - height_jiange

                local l = O.CreateLine(roleOverview, height + line_height)

                CreateMONEYbutton(BG.MONEYall_table, 1, 9, width, height, 65)
                height = height - height_jiange
                CreateMONEYbutton(BG.MONEYall_table, 10, 14, width, height, 65)
                height = height - height_jiange * 3

                -- 5人本完成总览
                do
                    local name = "FB5M"
                    BG.options[name .. "reset"] = 1
                    if not BiaoGe.options[name] then
                        BiaoGe.options[name] = BG.options[name .. "reset"]
                    end
                    local ontext = L["|cffffffff< 角色5人本完成总览 >|r\n\n1、在队伍查找器旁边显示角色5人本完成总览"]
                    local f = O.CreateCheckButton(name, BG.STC_g1(L["显示角色5人本完成总览*"]), roleOverview, 15, height, ontext)
                    BG.options["button" .. name] = f
                    f:HookScript("OnClick", function()
                        if BG.FBCD_5M_Frame then
                            if f:GetChecked() then
                                BG.FBCD_5M_Frame:Show()
                            else
                                BG.FBCD_5M_Frame:Hide()
                            end
                        end
                    end)
                end
            end
        end
    end

    -- 团本攻略设置
    do
        if not BG.Vanilla() then
            local height = 0

            -- 团本攻略字体大小
            do
                local name = "BossFontSize"
                if not BiaoGe.options[name] then
                    BiaoGe.options[name] = BG.options[name .. "reset"]
                end
                local ontext = L["|cffffffff< 团本攻略字体大小 >|r|cff808080（右键还原设置）|r\n\n1、调整该字体的大小"]
                local f = O.CreateSlider(name, "|cffFFFFFF" .. L["团本攻略字体大小"] .. "|r", boss, 10, 20, 1, 15, height - 30, ontext)
                BG.options["button" .. name] = f
            end
        end
    end

    -- 其他插件增强设置
    do
        local width = 15
        local height = -15
        local height_jiange = 22
        local line_height = 4
        local h = 5

        --团本CD
        local text = others:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        text:SetPoint("TOPLEFT", width, height)
        text:SetText(BG.STC_g1(L["集结号"]))
        height = height - height_jiange

        O.CreateLine(others, height + line_height)

        -- 不自动退出集结号频道
        do
            local name = "MeetingHorn_always"
            BG.options[name .. "reset"] = 0
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 不自动退出集结号频道 >|r\n\n1、这样你可以一直同步集结号的组队消息，让你随时打开集结号都能查看全部活动"]
            local f = O.CreateCheckButton(name, L["不自动退出集结号频道*"], others, 15, height - h, ontext)
            BG.options["button" .. name] = f
        end
        h = h + 30

        -- 历史搜索记录
        do
            local name = "MeetingHorn_history"
            BG.options[name .. "reset"] = 0
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 历史搜索记录 >|r\n\n1、给集结号的搜索框增加一个历史搜索记录，提高你搜索的效率"]
            local f = O.CreateCheckButton(name, L["历史搜索记录*"], others, 15, height - h, ontext)
            BG.options["button" .. name] = f
        end
        h = h + 30

        -- 按队伍人数排序
        do
            local name = "MeetingHorn_members"
            BG.options[name .. "reset"] = 0
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 按队伍人数排序 >|r\n\n1、集结号活动可以按队伍人数排序"]
            local f = O.CreateCheckButton(name, L["按队伍人数排序*"], others, 15, height - h, ontext)
            BG.options["button" .. name] = f
            f:HookScript("OnClick", function()
                local addonName = "MeetingHorn"
                if not IsAddOnLoaded(addonName) then return end

                local MeetingHorn = LibStub("AceAddon-3.0"):GetAddon(addonName)
                local bt = MeetingHorn.MainPanel.Browser.Header3

                if f:GetChecked() then
                    bt:SetEnabled(true)
                else
                    bt:SetEnabled(false)
                end
            end)
        end
        h = h + 30

        -- 密语模板
        do
            local name = "MeetingHorn_whisper"
            BG.options[name .. "reset"] = 0
            if not BiaoGe.options[name] then
                BiaoGe.options[name] = BG.options[name .. "reset"]
            end
            local ontext = L["|cffffffff< 密语模板 >|r\n\n1、预设成就、装等、自定义文本，当你点击集结号活动密语时会自动添加该内容\n2、按住SHIFT+点击密语时不会添加"]
            local f = O.CreateCheckButton(name, L["密语模板*"], others, 15, height - h, ontext)
            BG.options["button" .. name] = f
            f:HookScript("OnClick", function()
                local addonName = "MeetingHorn"
                if not IsAddOnLoaded(addonName) then return end

                if f:GetChecked() then
                    BG.MeetingHorn.WhisperButton:Show()
                    BG.MeetingHorn.WhisperFrame:Show()
                    BiaoGe.MeetingHornWhisper.WhisperFrame = true
                else
                    BG.MeetingHorn.WhisperButton:Hide()
                end
            end)
        end
    end
end


local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == AddonName then
        OptionsUI()

        -- 清理旧数据
        if not BiaoGe.options.SearchHistory.dt231005 then
            BiaoGe.Scale = nil
            BiaoGe.Alpha = nil
            BiaoGe.AutoLoot = nil
            BiaoGe.AutoTrade = nil
            BiaoGe.AutoJine0 = nil
            BiaoGe.helperZF = nil
            BiaoGe.tradeFrame = nil
            BiaoGe.helperTongBao = nil
            BiaoGe.text = nil
            BiaoGe.HopeSendICC = nil
            BiaoGe.HopeSendTOC = nil
            BiaoGe.HopeSendULD = nil
            BiaoGe.HopeSendNAXX = nil
            BiaoGe.HopeShow = nil
            BiaoGe.mini = nil

            for fb, _ in pairs(BiaoGe.History) do
                for dt, v in pairs(BiaoGe.History[fb]) do
                    for b = 1, Maxb[fb] + 2 do
                        for i = 1, Maxi[fb] + 10 do
                            if BiaoGe.History[fb][dt]["boss" .. b]["zhuangbei" .. i] then
                                if BiaoGe.History[fb][dt]["boss" .. b]["zhuangbei" .. i] == "" then
                                    BiaoGe.History[fb][dt]["boss" .. b]["zhuangbei" .. i] = nil
                                end
                                if BiaoGe.History[fb][dt]["boss" .. b]["maijia" .. i] == "" then
                                    BiaoGe.History[fb][dt]["boss" .. b]["maijia" .. i] = nil
                                    BiaoGe.History[fb][dt]["boss" .. b]["color" .. i] = nil
                                end
                                if BiaoGe.History[fb][dt]["boss" .. b]["jine" .. i] == "" then
                                    BiaoGe.History[fb][dt]["boss" .. b]["jine" .. i] = nil
                                end
                            end

                            if BiaoGe[fb]["boss" .. b]["zhuangbei" .. i] or BiaoGe[fb]["boss" .. b]["qiankuan" .. i] then
                                if BiaoGe[fb]["boss" .. b]["zhuangbei" .. i] == "" then
                                    BiaoGe[fb]["boss" .. b]["zhuangbei" .. i] = nil
                                end
                                if BiaoGe[fb]["boss" .. b]["maijia" .. i] == "" then
                                    BiaoGe[fb]["boss" .. b]["maijia" .. i] = nil
                                    BiaoGe[fb]["boss" .. b]["color" .. i] = nil
                                end
                                if BiaoGe[fb]["boss" .. b]["jine" .. i] == "" then
                                    BiaoGe[fb]["boss" .. b]["jine" .. i] = nil
                                end
                                if BiaoGe[fb]["boss" .. b]["qiankuan" .. i] == "" then
                                    BiaoGe[fb]["boss" .. b]["qiankuan" .. i] = nil
                                end
                            end
                        end
                        if BiaoGe.History[fb][dt]["boss" .. b]["time"] then
                            if BiaoGe.History[fb][dt]["boss" .. b]["time"] == "" then
                                BiaoGe.History[fb][dt]["boss" .. b]["time"] = nil
                            end
                        end
                    end
                end
            end
            BiaoGe.options.SearchHistory.dt231005 = true
        end
    end
end)
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, addonName)
    local name = "miniMap"
    local icon = LibStub("LibDBIcon-1.0", true)
    if icon then
        if BiaoGe.options[name] == 1 then
            icon:Show(AddonName)
        else
            icon:Hide(AddonName)
        end
    end
end)

-- -- debug
-- local f = CreateFrame("Frame")
-- f:RegisterEvent("PLAYER_ENTERING_WORLD")
-- f:SetScript("OnEvent", function(self, even, ...)
--     InterfaceOptionsFrame_OpenToCategory(L["BiaoGe"] or "|cff00BFFFBiaoGe|r")
-- end)
