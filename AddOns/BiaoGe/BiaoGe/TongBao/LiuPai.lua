local AddonName, ADDONSELF = ...

local LibBG = ADDONSELF.LibBG
local L = ADDONSELF.L

local RR = ADDONSELF.RR
local NN = ADDONSELF.NN
local RN = ADDONSELF.RN
local FrameHide = ADDONSELF.FrameHide
local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi
local HopeMaxn = ADDONSELF.HopeMaxn
local HopeMaxb = ADDONSELF.HopeMaxb
local HopeMaxi = ADDONSELF.HopeMaxi

local pt = print

function BG.LiuPaiUI()
    local bt = CreateFrame("Button", nil, BG.MainFrame, "UIPanelButtonTemplate")
    bt:SetSize(90, BG.ButtonZhangDan:GetHeight())
    bt:SetPoint("BOTTOMRIGHT", BG.MainFrame, "BOTTOMRIGHT", -430, select(5, BG.ButtonZhangDan:GetPoint()))
    -- bt:SetPoint("BOTTOM", BG.MainFrame, "BOTTOM", 140, 24)
    bt:SetText(L["通报流拍"])
    bt:Show()
    BG.ButtonLiuPai = bt

    bt:SetScript("OnEnter", function(self)
        local text = "|cffffffff" .. L["< 流 拍 装 备 >"] .. RN
        local num = 1
        for b = 1, Maxb[BG.FB1] do
            for i = 1, Maxi[BG.FB1] do
                if BG.Frame[BG.FB1]["boss" .. b]["zhuangbei" .. i] then
                    if BG.Frame[BG.FB1]["boss" .. b]["zhuangbei" .. i]:GetText() ~= "" and BG.Frame[BG.FB1]["boss" .. b]["jine" .. i]:GetText() == "" or tonumber(BG.Frame[BG.FB1]["boss" .. b]["jine" .. i]:GetText()) == 0 then
                        if GetItemInfoInstant(BG.Frame[BG.FB1]["boss" .. b]["zhuangbei" .. i]:GetText()) then
                            local name, link, quality, level, _, _, _, _, _, _, _, typeID = GetItemInfo(BG.Frame[BG.FB1]["boss" .. b]["zhuangbei" .. i]:GetText())
                            text = text .. num .. "、" .. BG.Frame[BG.FB1]["boss" .. b]["zhuangbei" .. i]:GetText() .. "|cff9370DB(" .. level .. ")|r\n"
                            num = num + 1
                        end
                    end
                end
            end
        end
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0);
        GameTooltip:ClearLines()
        GameTooltip:SetText(text)
    end)
    bt:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

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
            local text = L["———通报流拍装备———"]
            SendChatMessage(text, "RAID")
            local num = 1
            for b = 1, Maxb[BG.FB1] do
                for i = 1, Maxi[BG.FB1] do
                    if BG.Frame[BG.FB1]["boss" .. b]["zhuangbei" .. i] then
                        if BG.Frame[BG.FB1]["boss" .. b]["zhuangbei" .. i]:GetText() ~= "" and BG.Frame[BG.FB1]["boss" .. b]["jine" .. i]:GetText() == "" or tonumber(BG.Frame[BG.FB1]["boss" .. b]["jine" .. i]:GetText()) == 0 then
                            if GetItemInfoInstant(BG.Frame[BG.FB1]["boss" .. b]["zhuangbei" .. i]:GetText()) then
                                local name, link, quality, level, _, _, _, _, _, _, _, typeID = GetItemInfo(BG.Frame[BG.FB1]["boss" .. b]["zhuangbei" .. i]:GetText())
                                text = num .. "、" .. BG.Frame[BG.FB1]["boss" .. b]["zhuangbei" .. i]:GetText() .. "(" .. level .. ")"
                                SendChatMessage(text, "RAID")
                                num = num + 1
                            end
                        end
                    end
                end
            end
            text = L["——感谢使用金团表格——"]
            SendChatMessage(text, "RAID")
            PlaySoundFile(BG.sound2, "Master")
        end
    end)
end

-- local frame = CreateFrame("Frame")
-- frame:RegisterEvent("ADDON_LOADED")
-- frame:SetScript("OnEvent", function(self, event, addonName)
--     if addonName == AddonName then
--         TongBaoUI()
--     end
-- end)
