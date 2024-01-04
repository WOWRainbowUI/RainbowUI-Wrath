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
local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi
local HopeMaxn = ADDONSELF.HopeMaxn
local HopeMaxb = ADDONSELF.HopeMaxb
local HopeMaxi = ADDONSELF.HopeMaxi
local FrameHide = ADDONSELF.FrameHide
local AddTexture = ADDONSELF.AddTexture
local GetItemID = ADDONSELF.GetItemID

local pt = print

local linshi_duizhang
local h_item = "|c.-|Hitem.-|h|r"
local bigfootyes
local bigfoot

local locales = {
    --金团账本
    ["RaidLedger:.... 收入 ...."] = { "RaidLedger:.... 收入 ....", "RaidLedger:.... Credit ...." },
    ["(%d+)金"] = { "(%d+)金", "(%d+)gold" },
    ["平均每人收入:"] = { "平均每人收入:", "Per Member credit:" },
    --金团表格
    ["通报金团账单"] = { "通报金团账单", "通報金團帳單", "Announce Raid Ledger" },
    ["感谢使用金团表格"] = { "感谢使用金团表格", "感謝使用金團表格", "Thank you for using the Raid Table" },
    --大脚金团助手
    ["事件：.-|c.-|Hitem.-|h|r"] = { "事件：.-|c.-|Hitem.-|h|r", },
    ["收入为："] = { "收入为：", "收入為：", },
    ["收入为：%d+。"] = { "收入为：%d+。", "收入為：%d+。", },
    ["-感谢使用大脚金团辅助工具-"] = { "-感谢使用大脚金团辅助工具-", "-感謝使用大脚金團輔助工具-", },
}

-- 自动记录别人账单
local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_RAID_WARNING")
f:RegisterEvent("CHAT_MSG_RAID_LEADER")
f:RegisterEvent("CHAT_MSG_RAID")
f:SetScript("OnEvent", function(self, even, text, playerName, ...)
    local player = strsplit("-", playerName)
    if BG.FindTableString(text, locales["RaidLedger:.... 收入 ...."]) or BG.FindTableString(text, locales["通报金团账单"]) then
        -- if strfind(text,L["RaidLedger:.... 收入 ...."]) or strfind(text,L["通报金团账单"]) then
        linshi_duizhang = {
            player = player,
            zhangdan = {},
            yes = nil,
            sunjine = 0,
            time = date("%H:%M:%S"),
            biaoti = "",
            t = time(),
        }
        if BG.FindTableString(text, locales["RaidLedger:.... 收入 ...."]) then
            linshi_duizhang.yes = 1
        elseif BG.FindTableString(text, locales["通报金团账单"]) then
            linshi_duizhang.yes = 2
        end
    elseif not bigfootyes and BG.FindTableString(text, locales["事件：.-|c.-|Hitem.-|h|r"]) then -- 大脚
        linshi_duizhang = {
            player = player,
            zhangdan = {},
            sunjine = 0,
            time = date("%H:%M:%S"),
            biaoti = "",
            t = time(),
        }
        bigfoot = {}
        bigfootyes = true
        tinsert(bigfoot, text)
        return
    end

    if linshi_duizhang then
        if linshi_duizhang.yes and player == linshi_duizhang.player and strfind(text, h_item) then
            local item = strmatch(text, h_item)
            local jine

            if linshi_duizhang.yes == 1 then
                jine = BG.MatchTableString(text, locales["(%d+)金"])
            elseif linshi_duizhang.yes == 2 then
                jine = strmatch(text, " (%d+)") or strmatch(text, "：(%d+)")
            end

            if jine and tonumber(jine) ~= 0 then
                local aaa = {
                    zhuangbei = item,
                    jine = jine,
                }
                tinsert(linshi_duizhang.zhangdan, aaa)
            end
        elseif bigfootyes and player == linshi_duizhang.player and (BG.FindTableString(text, locales["事件："]) or BG.FindTableString(text, locales["收入为："])) then -- 大脚
            tinsert(bigfoot, text)
        end
    end

    if linshi_duizhang then
        if linshi_duizhang.yes and player == linshi_duizhang.player and (BG.FindTableString(text, locales["平均每人收入:"]) or BG.FindTableString(text, locales["感谢使用金团表格"])) then
            linshi_duizhang.yes = nil
            local sunjin = 0
            for key, value in pairs(linshi_duizhang.zhangdan) do
                local jine = tonumber(value.jine) or 0
                sunjin = sunjin + jine
            end
            linshi_duizhang.sunjine = sunjin
            linshi_duizhang.biaoti = linshi_duizhang.time .. "，" .. SetClassCFF(linshi_duizhang.player) .. L["，装备总收入:"] .. BG.STC_g1(linshi_duizhang.sunjine)

            tinsert(BiaoGe.duizhang, 1, linshi_duizhang)
            if BG.duizhangNum then
                BG.duizhangNum = BG.duizhangNum + 1
            end
            linshi_duizhang = nil
            BG.DuiZhangList()
        elseif bigfootyes and player == linshi_duizhang.player and BG.FindTableString(text, locales["-感谢使用大脚金团辅助工具-"]) then -- 大脚
            for i, value in ipairs(bigfoot) do
                if strfind(bigfoot[i], h_item) then
                    if bigfoot[i + 1] and BG.FindTableString(bigfoot[i + 1], locales["收入为：%d+。"]) then
                        local item = strmatch(bigfoot[i], h_item)
                        local jine = tonumber(strmatch(bigfoot[i + 1], "%d+"))

                        if jine ~= "" and tonumber(jine) ~= 0 then
                            local aaa = {
                                zhuangbei = item,
                                jine = jine,
                            }
                            tinsert(linshi_duizhang.zhangdan, aaa)
                        end
                    end
                end
            end

            linshi_duizhang.yes = nil
            local sunjin = 0
            for key, value in pairs(linshi_duizhang.zhangdan) do
                local jine = tonumber(value.jine) or 0
                sunjin = sunjin + jine
            end
            linshi_duizhang.sunjine = sunjin
            linshi_duizhang.biaoti = linshi_duizhang.time .. "，" .. SetClassCFF(linshi_duizhang.player) .. L["，装备总收入:"] .. BG.STC_g1(linshi_duizhang.sunjine)

            tinsert(BiaoGe.duizhang, 1, linshi_duizhang)
            if BG.duizhangNum then
                BG.duizhangNum = BG.duizhangNum + 1
            end
            linshi_duizhang = nil
            bigfootyes = nil
            bigfoot = nil
            BG.DuiZhangList()
        end
    end
end)

------------------创建下拉列表UI------------------
function BG.DuiZhangUI()
    BG.DuiZhangDropDown = {}
    local dropDown = LibBG:Create_UIDropDownMenu("BG.DuiZhangDropDown.dropDown", BG.DuiZhangMainFrame)
    dropDown:SetPoint("TOP", BG.MainFrame, "TOP", 50, -25)
    LibBG:UIDropDownMenu_SetWidth(dropDown, 350)
    LibBG:UIDropDownMenu_SetText(dropDown, L["无"])
    BG.DuiZhangDropDown.DropDown = dropDown

    local text = dropDown:CreateFontString()
    text:SetPoint("RIGHT", dropDown, "LEFT", 10, 3)
    text:SetFont(BIAOGE_TEXT_FONT, 15, "OUTLINE")
    text:SetTextColor(RGB(BG.y2))
    text:SetText(BG.STC_g1(L["对比的账单："]))
    BG.DuiZhangDropDown.BiaoTi = text

    BG.DuiZhangList()
    LibBG:UIDropDownMenu_SetAnchor(dropDown, -10, 0, "TOPRIGHT", dropDown, "BOTTOMRIGHT")

    -- 一天后自动删掉相应账单
    local name = "duiZhangTime"
    BG.options[name .. "reset"] = 24 -- 对账单保存24小时
    if not BiaoGe.options[name] then
        BiaoGe.options[name] = BG.options[name .. "reset"]
    end
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", function(self, even, ...)
        C_Timer.After(1, function()
            local time2 = time()
            for key, value in pairs(BiaoGe.duizhang) do
                if type(value) == "table" and value.t then
                    local time1 = value.t
                    if tonumber(time2) - tonumber(time1) >= (BiaoGe.options[name] * 60 * 60) then
                        BiaoGe.duizhang[key] = nil
                        if BG.duizhangNum then
                            BG.duizhangNum = BG.duizhangNum - 1
                            if BG.duizhangNum == 0 then
                                BG.duizhangNum = nil
                            end
                        end
                    end
                end
            end
        end)
    end)
end

------------------生成下拉列表可选账单------------------
function BG.DuiZhangList()
    LibBG:UIDropDownMenu_Initialize(BG.DuiZhangDropDown.DropDown, function(self, level, menuList)
        FrameHide(0)
        if BG["DuiZhangFrame" .. BG.FB1] and BG["DuiZhangFrame" .. BG.FB1]:IsVisible() then
            PlaySound(BG.sound1, "Master")
        end
        for index, value in ipairs(BiaoGe.duizhang) do
            local info = LibBG:UIDropDownMenu_CreateInfo()
            info.text, info.func = value.biaoti, function()
                FrameHide(0)
                BG.duizhangNum = index
                BG.DuiZhangSet(index)
                LibBG:UIDropDownMenu_SetText(BG.DuiZhangDropDown.DropDown, value.biaoti)
                PlaySound(BG.sound1, "Master")
            end
            LibBG:UIDropDownMenu_AddButton(info)
        end
        local info = LibBG:UIDropDownMenu_CreateInfo()
        info.text, info.func = L["无"], function()
            FrameHide(0)
            BG.duizhangNum = nil
            BG.DuiZhang0()
            LibBG:UIDropDownMenu_SetText(BG.DuiZhangDropDown.DropDown, L["无"])
            PlaySound(BG.sound1, "Master")
        end
        LibBG:UIDropDownMenu_AddButton(info)
    end)
end

------------------账单生成函数------------------
function BG.DuiZhangSet(num)
    local dz = BiaoGe.duizhang[num].zhangdan
    local FB = BG.FB1

    BG.DuiZhang0()

    for key, value in pairs(dz) do
        if value.zhuangbei then
            local item = value.zhuangbei
            local jine = value.jine
            if jine ~= "" and tonumber(jine) ~= 0 then
                local yes
                for b = 1, Maxb[FB] - 1 do
                    for i = 1, Maxi[FB] do
                        local zhuangbei = BG.DuiZhangFrame[FB]["boss" .. b]["zhuangbei" .. i]
                        local myjine = BG.DuiZhangFrame[FB]["boss" .. b]["myjine" .. i]
                        local otherjine = BG.DuiZhangFrame[FB]["boss" .. b]["otherjine" .. i]
                        local tx = BG.DuiZhangFrame[FB]["boss" .. b]["yes" .. i]
                        if zhuangbei then
                            if GetItemID(zhuangbei:GetText()) == GetItemID(item) and (otherjine:GetText() == "" or tonumber(otherjine:GetText()) == 0) then
                                otherjine:SetText(jine)
                                yes = true
                                break
                            end
                        end
                    end
                    if yes then
                        break
                    end
                end
                if not yes then
                    local b = Maxb[FB]
                    for i = 1, Maxi[FB] do
                        local zhuangbei = BG.DuiZhangFrame[FB]["boss" .. b]["zhuangbei" .. i]
                        local otherjine = BG.DuiZhangFrame[FB]["boss" .. b]["otherjine" .. i]
                        if zhuangbei then
                            if GetItemID(zhuangbei:GetText()) == "" then
                                zhuangbei:SetText(item)
                                otherjine:SetText(jine)
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    -- 设置打钩/叉叉材质
    C_Timer.After(0.05, function()
        for b = 1, Maxb[FB] + 1 do
            for i = 1, Maxi[FB] do
                local zhuangbei = BG.DuiZhangFrame[FB]["boss" .. b]["zhuangbei" .. i]
                local myjine = BG.DuiZhangFrame[FB]["boss" .. b]["myjine" .. i]
                local otherjine = BG.DuiZhangFrame[FB]["boss" .. b]["otherjine" .. i]
                local tx = BG.DuiZhangFrame[FB]["boss" .. b]["yes" .. i]
                if zhuangbei and zhuangbei ~= BG.DuiZhangFrame[FB]["boss" .. Maxb[FB] + 1]["zhuangbei2"] then
                    local mj = myjine:GetText()
                    local oj = otherjine:GetText()
                    if tonumber(mj) == 0 then
                        mj = ""
                    end
                    if tonumber(oj) == 0 then
                        oj = ""
                    end
                    if mj == "" and oj == "" then
                        tx:SetTexture(nil)
                    elseif tonumber(mj) == tonumber(oj) then
                        tx:SetTexture("interface/raidframe/readycheck-ready")
                    elseif tonumber(mj) ~= tonumber(oj) then
                        tx:SetTexture("interface/raidframe/readycheck-notready")
                    end
                end
            end
        end
    end)
end

------------------对账格子清空------------------
function BG.DuiZhang0()
    local FB = BG.FB1
    for b = 1, Maxb[FB] do
        for i = 1, Maxi[FB] do
            local zhuangbei = BG.DuiZhangFrame[FB]["boss" .. b]["zhuangbei" .. i]
            local otherjine = BG.DuiZhangFrame[FB]["boss" .. b]["otherjine" .. i]
            local tx = BG.DuiZhangFrame[FB]["boss" .. b]["yes" .. i]
            if zhuangbei then
                otherjine:SetText("")
                tx:SetTexture(nil)
            end
        end
    end
    local tx = BG.DuiZhangFrame[FB]["boss" .. Maxb[FB] + 1]["yes1"]
    tx:SetTexture(nil)

    local b = Maxb[FB]
    for i = 1, Maxi[FB] do
        local zhuangbei = BG.DuiZhangFrame[FB]["boss" .. b]["zhuangbei" .. i]
        local otherjine = BG.DuiZhangFrame[FB]["boss" .. b]["otherjine" .. i]
        if zhuangbei then
            zhuangbei:SetText("")
            otherjine:SetText("")
        end
    end
end
