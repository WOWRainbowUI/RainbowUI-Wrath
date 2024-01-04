local AddonName, ADDONSELF = ...

local LibBG = ADDONSELF.LibBG
local L = ADDONSELF.L

local RR = ADDONSELF.RR
local NN = ADDONSELF.NN
local RN = ADDONSELF.RN
local FrameHide = ADDONSELF.FrameHide
local SetClassCFF = ADDONSELF.SetClassCFF

local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi
local HopeMaxn = ADDONSELF.HopeMaxn
local HopeMaxb = ADDONSELF.HopeMaxb
local HopeMaxi = ADDONSELF.HopeMaxi

local pt = print

function BG.ZhangDanUI()
    local bt = CreateFrame("Button", nil, BG.MainFrame, "UIPanelButtonTemplate")
    bt:SetSize(90, 30)
    bt:SetPoint("BOTTOMRIGHT", BG.MainFrame, "BOTTOMRIGHT", -530, 35)
    -- bt:SetPoint("BOTTOM", BG.MainFrame, "BOTTOM", 140, 55)
    bt:SetText(L["通报账单"])
    bt:Show()
    BG.ButtonZhangDan = bt

    -- 鼠标悬停提示账单
    bt:SetScript("OnEnter", function(self)
        local FB = BG.FB1
        local tx = {}
        -- 收入
        do
            local text = "|cffffffff" .. L["< 收  入 >"] .. RN
            table.insert(tx, text)
            local yes
            for b = 1, Maxb[FB] do
                local tx_1 = {}
                local num = 1
                for i = 1, Maxi[FB] do
                    if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i] then
                        if tonumber(BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText()) and
                            tonumber(BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText()) ~= 0 then
                            local text = BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:GetText() .. " " ..
                                SetClassCFF(BG.Frame[FB]["boss" .. b]["maijia" .. i]:GetText()) .. " " ..
                                BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText() .. "\n"
                            table.insert(tx_1, text)
                            num = num + 1
                        end
                    end
                end
                if #tx_1 ~= 0 then
                    yes = true
                    local text = ""
                    local b_tx
                    if b == Maxb[FB] - 1 or b == Maxb[FB] then
                        b_tx = L["项目："]
                    else
                        b_tx = L["Boss："]
                    end
                    local bossname2 = BG.Boss[FB]["boss" .. b].name2
                    local bosscolor = BG.Boss[FB]["boss" .. b].color
                    text = "|cff" .. bosscolor .. b_tx .. bossname2 .. RN
                    table.insert(tx_1, 1, text)
                    for index, value in ipairs(tx_1) do
                        table.insert(tx, value)
                    end
                end
            end
            if not yes then
                local text = L["无"] .. NN
                table.insert(tx, text)
            end
        end
        -- 支出
        do
            local text = "|cffffffff" .. L["< 支  出 >"] .. RN
            table.insert(tx, text)
            local yes
            local tx_1 = {}
            local num = 1

            local b = Maxb[FB] + 1
            for i = 1, Maxi[FB], 1 do
                if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i] then
                    if tonumber(BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText()) and
                        tonumber(BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText()) ~= 0 then
                        local text = BG.STC_g1(BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:GetText()) .. " " ..
                            SetClassCFF(BG.Frame[FB]["boss" .. b]["maijia" .. i]:GetText()) .. " " ..
                            BG.STC_g1(BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText()) .. "\n"
                        table.insert(tx_1, text)
                        num = num + 1
                    end
                end
            end
            if #tx_1 ~= 0 then
                yes = true
                for index, value in ipairs(tx_1) do
                    table.insert(tx, value)
                end
            end
            if not yes then
                local text = L["无"] .. NN
                table.insert(tx, text)
            end
        end
        -- 总览和工资
        do
            local text = "|cffffffff" .. L["< 总  览 >"] .. RN
            table.insert(tx, text)
            local tx_1 = {}

            local b = Maxb[FB] + 2
            for i = 1, 3, 1 do
                if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i] then
                    local text = "|cffEE82EE" .. BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:GetText() .. "：" ..
                        BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText() .. RN
                    table.insert(tx_1, text)
                end
            end

            local text = "|cffffffff" .. L["< 工  资 >"] .. RN
            table.insert(tx_1, text)
            local text = "|cff00BFFF" .. BG.Frame[FB]["boss" .. b]["zhuangbei4"]:GetText() .. "：" ..
                BG.Frame[FB]["boss" .. b]["jine4"]:GetText() .. L["人"] .. RN
            table.insert(tx_1, text)
            local text = "|cff00BFFF" .. BG.Frame[FB]["boss" .. b]["zhuangbei5"]:GetText() .. "：" ..
                BG.Frame[FB]["boss" .. b]["jine5"]:GetText() .. RN
            table.insert(tx_1, text)
            local text = "|cff00BFFF" .. BG.Frame[FB]["boss" .. b]["jine5"]:GetText() .. " x 5 = " ..
                (tonumber(BG.Frame[FB]["boss" .. b]["jine5"]:GetText()) * 5) .. RN
            table.insert(tx_1, text)

            for index, value in ipairs(tx_1) do
                table.insert(tx, value)
            end
        end

        local text = table.concat(tx)
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0);
        GameTooltip:ClearLines()
        GameTooltip:SetText(text)
        local a = GameTooltip:GetHeight()
        local b = UIParent:GetHeight()
        if a and b then
            a = tonumber(a)
            b = tonumber(b)
            if a >= b then
                local scale = 1 - ((a - b) / b) * 0.5
                local s = 0
                if scale >= 0.9 then
                    s = 0.13
                elseif scale >= 0.8 then
                    s = 0.15
                elseif scale >= 0.7 then
                    s = 0.11
                elseif scale >= 0.6 then
                    s = 0.08
                elseif scale >= 0.55 then
                    s = 0.06
                elseif scale >= 0.5 then
                    s = 0.05
                end
                scale = string.format("%.2f", scale) - s
                if scale <= 0 then
                    scale = 0.4
                end
                GameTooltip:SetScale(scale)
            end
        end
    end)
    bt:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
        GameTooltip:SetScale(1)
    end)
    -- 点击通报账单
    bt:SetScript("OnClick", function(self)
        local FB = BG.FB1
        FrameHide(0)
        if not IsInRaid(1) then
            SendSystemMessage(L["不在团队，无法通报"])
            PlaySound(BG.sound1, "Master")
        else
            self:SetEnabled(false) -- 点击后按钮变灰2秒
            C_Timer.After(2, function()
                bt:SetEnabled(true)
            end)

            local tx = {}
            local text = L["———通报金团账单———"]
            table.insert(tx, text)

            -- 收入
            do
                local text = L["< 收 {rt1} 入 >"]
                table.insert(tx, text)
                local yes

                for b = 1, Maxb[FB] do
                    local tx_1 = {}
                    local num = 1
                    for i = 1, Maxi[FB] do
                        if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i] then
                            if tonumber(BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText()) and
                                tonumber(BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText()) ~= 0 then
                                local text = BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:GetText() .. " " ..
                                    (BG.Frame[FB]["boss" .. b]["maijia" .. i]:GetText()) .. " " ..
                                    BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText()
                                table.insert(tx_1, text)
                                num = num + 1
                            end
                        end
                    end
                    if #tx_1 ~= 0 then
                        yes = true
                        local b_tx = ""
                        if b == Maxb[FB] - 1 or b == Maxb[FB] then
                            b_tx = L["项目："]
                        else
                            b_tx = L["Boss："]
                        end
                        local text = b_tx .. BG.Boss[FB]["boss" .. b]["name2"]
                        table.insert(tx_1, 1, text)
                        for index, value in ipairs(tx_1) do
                            table.insert(tx, value)
                        end
                    end
                end
                if not yes then
                    local text = L["无"]
                    table.insert(tx, text)
                end
            end
            -- 支出
            do
                local text = L["< 支 {rt4} 出 >"]
                table.insert(tx, text)
                local yes
                local tx_1 = {}
                local num = 1

                local b = Maxb[FB] + 1
                for i = 1, Maxi[FB], 1 do
                    if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i] then
                        if tonumber(BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText()) and
                            tonumber(BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText()) ~= 0 then
                            local text = (BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:GetText()) .. " " ..
                                (BG.Frame[FB]["boss" .. b]["maijia" .. i]:GetText()) .. " " ..
                                (BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText())
                            table.insert(tx_1, text)
                            num = num + 1
                        end
                    end
                end
                if #tx_1 ~= 0 then
                    yes = true
                    for index, value in ipairs(tx_1) do
                        table.insert(tx, value)
                    end
                end
                if not yes then
                    local text = L["无"]
                    table.insert(tx, text)
                end
            end
            -- 总览和工资
            do
                local text = L["< 总 {rt3} 览 >"]
                table.insert(tx, text)
                local tx_1 = {}

                local b = Maxb[FB] + 2
                for i = 1, 3, 1 do
                    if BG.Frame[FB]["boss" .. b]["zhuangbei" .. i] then
                        local text = BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:GetText() .. "：" ..
                            BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText()
                        table.insert(tx_1, text)
                    end
                end

                local text = L["< 工 {rt6} 资 >"]
                table.insert(tx_1, text)
                local text = BG.Frame[FB]["boss" .. b]["zhuangbei4"]:GetText() .. "：" .. BG.Frame[FB]["boss" .. b]["jine4"]:GetText() .. L["人"]
                table.insert(tx_1, text)
                local text = BG.Frame[FB]["boss" .. b]["zhuangbei5"]:GetText() .. "：" .. BG.Frame[FB]["boss" .. b]["jine5"]:GetText()
                table.insert(tx_1, text)
                local text = BG.Frame[FB]["boss" .. b]["jine5"]:GetText() .. " x 5 = " .. (tonumber(BG.Frame[FB]["boss" .. b]["jine5"]:GetText()) * 5)
                table.insert(tx_1, text)

                for index, value in ipairs(tx_1) do
                    table.insert(tx, value)
                end
            end

            local text = L["——感谢使用金团表格——"]
            table.insert(tx, text)
            for index, value in ipairs(tx) do
                SendChatMessage(value, "RAID")
            end

            PlaySoundFile(BG.sound2, "Master")
        end
    end)
end

-- local frame = CreateFrame("Frame")
-- frame:RegisterEvent("ADDON_LOADED")
-- frame:SetScript("OnEvent", function(self, event, addonName)
--     if addonName == AddonName then
--         ZhangDanUI()
--     end
-- end)
