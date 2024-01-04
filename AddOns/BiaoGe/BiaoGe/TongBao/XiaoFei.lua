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

------------------函数：通报消费排名-----------------
local function XiaoFei()
    local XiaoFei1 = {} -- 消费列表（买家，金额）
    local XiaoFei2 = {} -- 买家名字
    local XiaoFei3 = {} -- 个人消费合计
    local XiaoFei4 = {} -- 排序后的个人消费合计
    local num = 1
    local FB = BG.FB1
    for b = 1, Maxb[FB] do
        for i = 1, Maxi[FB] do
            if BG.Frame[FB]["boss" .. b]["maijia" .. i] then
                if BG.Frame[FB]["boss" .. b]["maijia" .. i]:GetText() ~= "" then
                    if not XiaoFei1[num] then
                        XiaoFei1[num] = {}
                    end
                    local jine = BG.Frame[FB]["boss" .. b]["jine" .. i]:GetText()
                    if not tonumber(jine) then
                        jine = 0
                    end
                    table.insert(XiaoFei1[num], BG.Frame[FB]["boss" .. b]["maijia" .. i]:GetText())
                    table.insert(XiaoFei1[num], jine)
                    num = num + 1
                    if Size(XiaoFei2) == 0 then
                        table.insert(XiaoFei2, BG.Frame[FB]["boss" .. b]["maijia" .. i]:GetText())
                    else
                        local yes = true
                        for index, value in ipairs(XiaoFei2) do
                            if value == BG.Frame[FB]["boss" .. b]["maijia" .. i]:GetText() then
                                yes = false
                            end
                        end
                        if yes then
                            table.insert(XiaoFei2, BG.Frame[FB]["boss" .. b]["maijia" .. i]:GetText())
                        end
                    end
                end
            end
        end
    end
    for ii = 1, #XiaoFei2 do
        local sum = 0
        for i = 1, #XiaoFei1 do
            if XiaoFei2[ii] == XiaoFei1[i][1] then
                sum = sum + XiaoFei1[i][2]
            end
        end
        if not XiaoFei3[ii] then
            XiaoFei3[ii] = {}
        end
        table.insert(XiaoFei3[ii], XiaoFei2[ii])
        table.insert(XiaoFei3[ii], sum)
    end

    for t = 1, #XiaoFei3 do -- 找到最大数值
        local max = nil
        for k, v in ipairs(XiaoFei3) do
            if max == nil then
                max = v[2]
            end
            if max < v[2] then
                max = v[2]
            end
        end
        if not max then
            break
        end
        for i = 1, #XiaoFei3 do
            if XiaoFei3[i][2] == max then
                if not XiaoFei4[t] then
                    XiaoFei4[t] = {}
                end
                table.insert(XiaoFei4[t], XiaoFei3[i][1])
                table.insert(XiaoFei4[t], XiaoFei3[i][2])

                table.remove(XiaoFei3, i)
                break
            end
        end
    end
    return XiaoFei4
end


function BG.XiaoFeiUI()
    local bt = CreateFrame("Button", nil, BG.MainFrame, "UIPanelButtonTemplate")
    bt:SetSize(90, BG.ButtonZhangDan:GetHeight())
    bt:SetPoint("BOTTOMRIGHT", BG.MainFrame, "BOTTOMRIGHT", -330, select(5, BG.ButtonZhangDan:GetPoint()))
    -- bt:SetPoint("BOTTOM", BG.MainFrame, "BOTTOM", 30, 55)
    bt:SetText(L["通报消费"])
    bt:Show()
    BG.ButtonXiaoFei = bt
    -- 鼠标悬停提示
    bt:SetScript("OnEnter", function(self)
        local text = "|cffffffff" .. L["< 消 费 排 名 >"] .. "|r\n"
        local XiaoFei4 = XiaoFei()
        for i = 1, #XiaoFei4 do
            if XiaoFei4[i] then
                text = text .. i .. "、" .. SetClassCFF(XiaoFei4[i][1]) .. "：" .. XiaoFei4[i][2] .. "\n"
            end
        end
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0);
        GameTooltip:ClearLines();
        GameTooltip:SetText(text)
    end)
    bt:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    -- 点击通报消费排名
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
            local text = L["———通报消费排名———"]
            SendChatMessage(text, "RAID")
            local XiaoFei4 = XiaoFei()
            for i = 1, #XiaoFei4 do
                if XiaoFei4[i] then
                    text = i .. "、" .. XiaoFei4[i][1] .. "：" .. XiaoFei4[i][2]
                    SendChatMessage(text, "RAID")
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
