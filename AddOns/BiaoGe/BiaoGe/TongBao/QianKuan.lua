local AddonName, ADDONSELF = ...

local LibBG = ADDONSELF.LibBG
local L = ADDONSELF.L

local RR = ADDONSELF.RR
local NN = ADDONSELF.NN
local RN = ADDONSELF.RN
local Size = ADDONSELF.Size
local FrameHide = ADDONSELF.FrameHide
local SetClassCFF = ADDONSELF.SetClassCFF

local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi
local HopeMaxn = ADDONSELF.HopeMaxn
local HopeMaxb = ADDONSELF.HopeMaxb
local HopeMaxi = ADDONSELF.HopeMaxi

local pt = print

------------------函数：通报欠款-----------------
local function QianKuan()
    local alltable = {}
    local maijiatable = {}
    local sumtable = {}
    local FB = BG.FB1
    for b = 1, Maxb[FB] do
        for i = 1, Maxi[FB] do
            if BG.Frame[FB]["boss" .. b]["qiankuan" .. i] then
                if BiaoGe[FB]["boss" .. b]["qiankuan" .. i] then
                    local q = {
                        zhuangbei = BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]:GetText(),
                        maijia = BG.Frame[FB]["boss" .. b]["maijia" .. i]:GetText(),
                        qiankuan = tonumber(BiaoGe[FB]["boss" .. b]["qiankuan" .. i])
                    }
                    tinsert(alltable, q)
                    -- 单独保存买家名字
                    maijiatable[BG.Frame[FB]["boss" .. b]["maijia" .. i]:GetText()] = true
                end
            end
        end
    end
    for maijia, _ in pairs(maijiatable) do
        local sum = 0
        for i, v in ipairs(alltable) do
            if maijia == v.maijia then
                sum = v.qiankuan + sum
            end
        end
        local s = { maijia = maijia, qiankuan = sum }
        tinsert(sumtable, s)
    end
    return alltable, sumtable
end


function BG.QianKuanUI()
    local bt = CreateFrame("Button", nil, BG.MainFrame, "UIPanelButtonTemplate")
    bt:SetSize(90, BG.ButtonZhangDan:GetHeight())
    bt:SetPoint("BOTTOMRIGHT", BG.MainFrame, "BOTTOMRIGHT", -230, select(5, BG.ButtonZhangDan:GetPoint()))
    -- bt:SetPoint("BOTTOM", BG.MainFrame, "BOTTOM", 30, 24)
    bt:SetText(L["通报欠款"])
    bt:Show()
    BG.ButtonQianKuan = bt

    bt:SetScript("OnEnter", function(self)
        local alltable, sumtable = QianKuan()
        local text = "|cffffffff" .. L["< 通 报 欠 款 >"] .. RN
        for i = 1, #alltable do
            text = text .. i .. "、" .. SetClassCFF(alltable[i].maijia) .. " " .. alltable[i].zhuangbei .. "|cffFF0000" .. L["欠款："] .. alltable[i].qiankuan .. RN
        end
        if #sumtable >= 1 then
            text = text .. "|cffffffff" .. L["< 合 计 欠 款 >"] .. RN
            for i = 1, #sumtable do
                local name
                if sumtable[i].maijia == "" then
                    name = L["没记买家"]
                else
                    name = SetClassCFF(sumtable[i].maijia)
                end
                text = text .. i .. "、" .. name .. " |cffFF0000" .. L["合计欠款："] .. sumtable[i].qiankuan .. RN
            end
        end
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0);
        GameTooltip:ClearLines()
        GameTooltip:SetText(text)
    end)
    bt:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    -- 单击触发
    bt:SetScript("OnClick", function(self)
        FrameHide(0)
        if not IsInRaid(1) then
            SendSystemMessage(L["不在团队，无法通报"])
            PlaySound(BG.sound1, "Master")
        else
            self:SetEnabled(false) -- 点击后按钮变灰2秒
            C_Timer.After(2, function()
                bt:SetEnabled(true)
            end)
            local text = L["————通报欠款————"]
            SendChatMessage(text, "RAID")
            local alltable, sumtable = QianKuan()
            for i = 1, #alltable do
                text = i .. "、" .. alltable[i].maijia .. " " .. alltable[i].zhuangbei .. L["欠款："] .. alltable[i].qiankuan
                SendChatMessage(text, "RAID")
            end
            if #sumtable >= 1 then
                text = L["{rt7} 合计欠款 {rt7}"]
                SendChatMessage(text, "RAID")
                for i = 1, #sumtable do
                    local name
                    if sumtable[i].maijia == "" then
                        name = L["没记买家"]
                    else
                        name = sumtable[i].maijia
                    end
                    text = i .. "、" .. name .. L[" 合计欠款："] .. sumtable[i].qiankuan
                    SendChatMessage(text, "RAID")
                end
            end
            text = L["——感谢使用金团表格——"]
            SendChatMessage(text, "RAID")
            PlaySoundFile(BG.sound2, "Master")
        end
    end)
end
