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

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName ~= AddonName then return end
    -- 拾取事件通报到屏幕中上
    local name = "lootTime"
    BG.options[name .. "reset"] = 8
    local f = CreateFrame("ScrollingMessageFrame", "BG.FrameLootMsg", UIParent, "BackdropTemplate")
    f:SetSpacing(3)                                                       -- 行间隔
    f:SetFadeDuration(1)                                                  -- 淡出动画的时间
    f:SetTimeVisible(BiaoGe.options[name] or BG.options[name .. "reset"]) -- 可见时间
    f:SetJustifyH("LEFT")                                                 -- 对齐格式
    f:SetSize(700, 200)                                                   -- 大小
    f:SetFont(BIAOGE_TEXT_FONT, BiaoGe.options["lootFontSize"] or 20, "OUTLINE")
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:SetFrameLevel(130)
    f:SetClampedToScreen(true)
    f:SetHyperlinksEnabled(true)
    f.name = L["装备记录通知"]
    f.homepoin = { "TOPLEFT", nil, "TOP", -200, 0 }
    if BiaoGe.point[f:GetName()] then
        f:SetPoint(unpack(BiaoGe.point[f:GetName()]))
    else
        f:SetPoint(unpack(f.homepoin)) --设置显示位置
    end
    tinsert(BG.Movetable, f)
    BG.FrameLootMsg = f

    f.name = f:CreateFontString()
    f.name:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
    f.name:SetTextColor(1, 1, 1, 1)
    f.name:SetText(L["装备记录通知"])
    f.name:SetPoint("TOP", 0, -5)
    f.name:Hide()

    BG.FrameLootMsg:SetScript("OnHyperlinkEnter", function(self, link, text, button)
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR", 0, 0)
        GameTooltip:ClearLines()
        local itemID = GetItemInfoInstant(link)
        if itemID then
            GameTooltip:SetItemByID(itemID)
            GameTooltip:Show()
        end
    end)
    BG.FrameLootMsg:SetScript("OnHyperlinkLeave", function(self, link, text, button)
        GameTooltip:Hide()
    end)
    BG.FrameLootMsg:SetScript("OnHyperlinkClick", function(self, link, text, button)
        local name, link, quality, level, _, _, _, _, _, Texture, _, typeID = GetItemInfo(link)

        if button == "RightButton" then -- 右键清除关注
            if BG.FB2 then
                for b = 1, Maxb[BG.FB2] do
                    for i = 1, Maxi[BG.FB2] do
                        if BG.Frame[BG.FB2]["boss" .. b]["zhuangbei" .. i] then
                            if GetItemID(link) == GetItemID(BG.Frame[BG.FB2]["boss" .. b]["zhuangbei" .. i]:GetText()) then
                                BiaoGe[BG.FB2]["boss" .. b]["guanzhu" .. i] = nil
                                BG.Frame[BG.FB2]["boss" .. b]["guanzhu" .. i]:Hide()
                                BG.FrameLootMsg:AddMessage(BG.STC_r1(format("已取消关注装备：%s",
                                    AddTexture(Texture) .. link)))
                                return
                            end
                        end
                    end
                end
            end
        end
        if IsShiftKeyDown() then
            ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
            ChatEdit_InsertLink(text)
            return
        end
        if IsAltKeyDown() then
            if BG.FB2 then
                for b = 1, Maxb[BG.FB2] do
                    for i = 1, Maxi[BG.FB2] do
                        if BG.Frame[BG.FB2]["boss" .. b]["zhuangbei" .. i] then
                            if GetItemID(link) == GetItemID(BG.Frame[BG.FB2]["boss" .. b]["zhuangbei" .. i]:GetText()) then
                                BiaoGe[BG.FB2]["boss" .. b]["guanzhu" .. i] = true
                                BG.Frame[BG.FB2]["boss" .. b]["guanzhu" .. i]:Show()
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
    -- 屏蔽交易添加
    local trade = true
    local f = CreateFrame("Frame")
    f:RegisterEvent("TRADE_SHOW")
    f:SetScript("OnEvent", function(self, ...)
        trade = false
    end)
    local f2 = CreateFrame("Frame")
    f2:RegisterEvent("TRADE_CLOSED")
    f2:SetScript("OnEvent", function(self, ...)
        trade = true
    end)

    local numb
    local lasttime, time
    local combat, combatyes

    -- 获取BOSS战ID
    local f = CreateFrame("Frame")
    f:RegisterEvent("BOSS_KILL")
    f:RegisterEvent("ENCOUNTER_START")
    f:RegisterEvent("ENCOUNTER_END")
    f:SetScript("OnEvent", function(self, even, ID)
        if BG.Loot.encounterID[BG.FB2] then
            for key, value in pairs(BG.Loot.encounterID[BG.FB2]) do
                if tonumber(ID) and tonumber(key) and tonumber(ID) == tonumber(key) then
                    numb = value
                end
            end
        end
        lasttime = GetTime()
    end)
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_REGEN_DISABLED") -- 进入战斗
    f:SetScript("OnEvent", function(self, even, ID)
        local FB = BG.FB2
        if not FB then -- 有没FB
            return
        end
        time = GetTime()
        if lasttime and time - lasttime >= 30 then -- 击杀BOSS 30秒后进入下一次战斗，就变回杂项
            numb = BG.Loot.encounterID[FB]["zaxiang"]
        end
    end)

    -- 拾取事件监听
    local f = CreateFrame("Frame")
    f:RegisterEvent("CHAT_MSG_LOOT")
    f:SetScript("OnEvent", function(self, even, msg, ...)
        local FB = BG.FB2
        local name = "autoLoot"
        if BiaoGe.options[name] ~= 1 then -- 有没勾选自动记录功能
            return
        end
        if not FB then -- 有没FB
            return
        end
        local _, type = IsInInstance()
        if type ~= "raid" and not BG.DeBug then -- 是否在副本
            return
        end
        if not trade then -- 是否刚交易完
            return
        end

        local name, link, count
        link, count = strmatch(msg, string.gsub(string.gsub(LOOT_ITEM_SELF_MULTIPLE, "%%s", "(.+)"), "%%d", "(%%d+)"));
        if (not link) then
            link, count = strmatch(msg, string.gsub(string.gsub(LOOT_ITEM_PUSHED_SELF_MULTIPLE, "%%s", "(.+)"), "%%d", "(%%d+)"));
            if (not link) then
                link = msg:match(LOOT_ITEM_SELF:gsub("%%s", "(.+)"));
                if (not link) then
                    link = msg:match(LOOT_ITEM_PUSHED_SELF:gsub("%%s", "(.+)"));

                    if (not link) then
                        name, link, count = strmatch(msg, string.gsub(string.gsub(LOOT_ITEM_MULTIPLE, "%%s", "(.+)"), "%%d", "(%%d+)"));
                        if (not link) then
                            name, link, count = strmatch(msg, string.gsub(string.gsub(LOOT_ITEM_PUSHED_MULTIPLE, "%%s", "(.+)"), "%%d", "(%%d+)"));
                            if (not link) then
                                name, link = msg:match("^" .. LOOT_ITEM:gsub("%%s", "(.+)"));
                                if (not link) then
                                    name, link = msg:match("^" .. LOOT_ITEM_PUSHED:gsub("%%s", "(.+)"));
                                end
                            end
                        end
                    end
                end
            end
        end

        if not link then
            return
        end

        if not count then
            count = 1
        end

        local name, _, quality, level, _, _, _, _, _, Texture, _, typeID, subclassID = GetItemInfo(link)
        -- local itemId = tonumber(link:match("item:(%d+):"))
        local itemId = GetItemInfoInstant(link)

        if BG.DeBug then
            pt(link, itemId)
        end

        if itemId ~= 45087 and itemId ~= 47556 and itemId ~= 49908 and quality < 4 then -- 是不是紫装或橙装
            return
        end

        if (typeID == 7 and subclassID == 12) then -- 是不是附魔分解的物品（例如：深渊水晶）
            return
        end

        if typeID == 9 or typeID == 10 or typeID == 3 then -- 是不是图纸或牌子或宝石
            return
        end

        if itemId == 45897 or itemId == 50226 or itemId == 50231 then -- [重铸的远古王者之锤][烂肠的酸性血液][腐面的酸性血液]
            return
        end

        -- 心愿装备
        local Hope
        for n = 1, HopeMaxn[FB] do
            for b = 1, HopeMaxb[FB] do
                for i = 1, HopeMaxi do
                    if BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i] then
                        if GetItemID(link) == GetItemID(BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]:GetText()) then
                            BG.FrameLootMsg:AddMessage(BG.STC_g1(format(L["你的心愿达成啦！！！>>>>> %s(%s) <<<<<"], (AddTexture(Texture) .. link), level)))
                            BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["yidiaoluo" .. i]:Show()
                            BiaoGe.Hope[RealmId][player][FB]["nandu" .. n]["boss" .. b]["yidiaoluo" .. i] = true
                            Hope = true
                            PlaySoundFile(BG.sound_hope, "Master")
                        end
                    end
                end
            end
        end

        -- 特殊物品记到杂项里
        local item
        if itemId == 45038 or itemId == 50274 then                        -- 如果掉落装备为橙片
            item = "ChengPian"
        elseif itemId == 45087 or itemId == 47556 or itemId == 49908 then -- 如果掉落装备为符文宝珠
            item = "BaoZhu"
        end
        if item then
            local numb = Maxb[FB] - 1
            local yes_zb, yes_db, yes_i
            if not BiaoGe[FB][item] then
                for i = 1, Maxi[FB] do
                    local zb = BG.Frame[FB]["boss" .. numb]["zhuangbei" .. i]
                    if zb and zb:GetText() == "" then
                        yes_i = i
                        yes_zb = BG.Frame[FB]["boss" .. numb]["zhuangbei" .. i]
                        break
                    end
                    local zb1 = BG.Frame[FB]["boss" .. numb]["zhuangbei" .. (i + 1)]
                    if zb and not zb1 then
                        BG.FrameLootMsg:AddMessage(format("|cffDC143C" .. L["自动记录失败：%s%s(%s)。因为%s< %s >%s的格子满了。。"], RR, (AddTexture(Texture) .. link), level, "|cffFF1493",
                            BG.Boss[FB]["boss" .. numb]["name2"], RR))
                        if Hope then
                            BG.FrameLootMsg:AddMessage(format("|cffDC143C" .. L["自动关注心愿装备失败：%s%s"], RR, ((AddTexture(Texture) .. link))))
                        end
                        return
                    end
                end
            else
                for i = 1, Maxi[FB] do
                    local zb = BG.Frame[FB]["boss" .. numb]["zhuangbei" .. i]
                    if zb and (GetItemID(zb:GetText()) == GetItemID(link)) then
                        yes_i = i
                        yes_zb = BG.Frame[FB]["boss" .. numb]["zhuangbei" .. i]
                        break
                    end
                end
            end
            if yes_i then
                local i = yes_i
                BiaoGe[FB][item] = (BiaoGe[FB][item] or 0) + count
                yes_zb:SetText(link .. "x" .. BiaoGe[FB][item])
                BiaoGe[FB]["boss" .. numb]["zhuangbei" .. i] = link .. "x" .. BiaoGe[FB][item]
                BG.FrameLootMsg:AddMessage(format("|cff00BFFF" .. L["已自动记入表格：%s%s(%s) x%d => %s< %s >%s"], RR, (AddTexture(Texture) .. link), level, BiaoGe[FB][item], "|cffFF1493",
                    BG.Boss[FB]["boss" .. numb]["name2"], RR))
                if Hope then
                    BiaoGe[FB]["boss" .. numb]["guanzhu" .. i] = true
                    BG.Frame[FB]["boss" .. numb]["guanzhu" .. i]:Show()
                    BG.FrameLootMsg:AddMessage(BG.STC_g2(format("自动关注心愿装备：%s。团长拍卖此装备时会提醒", (AddTexture(Texture) .. link))))
                end
                return
            end
        end

        -- TOC嘉奖宝箱通过读取掉落列表来记录装备
        if FB == "TOC" and itemId ~= 47242 then
            local nanduID = GetRaidDifficultyID()
            local H
            if nanduID == 6 or nanduID == 194 then     -- 25H
                H = "H25"
            elseif nanduID == 5 or nanduID == 193 then -- 10H
                H = "H10"
            end
            if H then
                for index, value in ipairs(BG.Loot.TOC[H].boss6) do
                    if itemId == value then
                        local numb = 6
                        for i = 1, Maxi[FB] do
                            local zb = BG.Frame[FB]["boss" .. numb]["zhuangbei" .. i]
                            local zb1 = BG.Frame[FB]["boss" .. numb]["zhuangbei" .. (i + 1)]
                            if zb and zb:GetText() == "" then
                                zb:SetText(link)
                                BiaoGe[FB]["boss" .. numb]["zhuangbei" .. i] = link
                                BG.FrameLootMsg:AddMessage("|cff00BFFF" ..
                                    format(L["已自动记入表格：%s%s(%s) => %s< %s >%s"], RR, (AddTexture(Texture) .. link), level, "|cffFF1493", BG.Boss[FB]["boss" .. numb]["name2"], RR))
                                if Hope then
                                    BiaoGe[FB]["boss" .. numb]["guanzhu" .. i] = true
                                    BG.Frame[FB]["boss" .. numb]["guanzhu" .. i]:Show()
                                    BG.FrameLootMsg:AddMessage(BG.STC_g2(format("自动关注心愿装备：%s。团长拍卖此装备时会提醒",
                                        (AddTexture(Texture) .. link))))
                                end
                                return
                            elseif zb and not zb1 then
                                BG.FrameLootMsg:AddMessage(format(
                                    "|cffDC143C" .. L["自动记录失败：%s%s(%s)。因为%s< %s >%s的格子满了。。"], RR, (AddTexture(Texture) .. link), level, "|cffFF1493", BG.Boss[FB]["boss" .. numb]["name2"], RR))
                                if Hope then
                                    BG.FrameLootMsg:AddMessage(format("|cffDC143C" .. L["自动关注心愿装备失败：%s%s"],
                                        RR, ((AddTexture(Texture) .. link))))
                                end
                                return
                            end
                        end
                    end
                end
            end
        end

        -- 正常拾取
        if not numb then
            numb = BG.Loot.encounterID[FB]["zaxiang"] -- 第一个boss前的小怪设为杂项
        end

        local zaxiang
        if itemId == 47242 then -- 如果掉落装备为北伐奖章
            zaxiang = Maxb[FB] - 1
        end
        local numb = zaxiang or numb

        for i = 1, Maxi[FB] do
            local zb = BG.Frame[FB]["boss" .. numb]["zhuangbei" .. i]
            local zb1 = BG.Frame[FB]["boss" .. numb]["zhuangbei" .. (i + 1)]
            if zb and zb:GetText() == "" then
                zb:SetText(link)
                BiaoGe[FB]["boss" .. numb]["zhuangbei" .. i] = link
                BG.FrameLootMsg:AddMessage("|cff00BFFF" ..
                    format(L["已自动记入表格：%s%s(%s) => %s< %s >%s"], RR, (AddTexture(Texture) .. link), level, "|cffFF1493", BG.Boss[FB]["boss" .. numb]["name2"], RR))
                if Hope then
                    BiaoGe[FB]["boss" .. numb]["guanzhu" .. i] = true
                    BG.Frame[FB]["boss" .. numb]["guanzhu" .. i]:Show()
                    BG.FrameLootMsg:AddMessage(BG.STC_g2(format("自动关注心愿装备：%s。团长拍卖此装备时会提醒", (AddTexture(Texture) .. link))))
                end
                return
            elseif zb and not zb1 then
                BG.FrameLootMsg:AddMessage(format("|cffDC143C" .. L["自动记录失败：%s%s(%s)。因为%s< %s >%s的格子满了。。"], RR, (AddTexture(Texture) .. link), level, "|cffFF1493",
                    BG.Boss[FB]["boss" .. numb]["name2"], RR))
                if Hope then
                    BG.FrameLootMsg:AddMessage(format("|cffDC143C" .. L["自动关注心愿装备失败：%s%s"], RR, ((AddTexture(Texture) .. link))))
                end
                return
            end
        end
    end)
end)
