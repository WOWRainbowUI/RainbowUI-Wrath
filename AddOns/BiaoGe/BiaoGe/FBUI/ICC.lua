local _, ADDONSELF = ...

local Size = ADDONSELF.Size
local RGB = ADDONSELF.RGB
local GetClassRGB = ADDONSELF.GetClassRGB
local SetClassCFF = ADDONSELF.SetClassCFF
local Sumjine = ADDONSELF.Sumjine
local SumZC = ADDONSELF.SumZC
local SumJ = ADDONSELF.SumJ
local SumGZ = ADDONSELF.SumGZ
local TongBao = ADDONSELF.TongBao
local XiaoFei = ADDONSELF.XiaoFei
local Classpx = ADDONSELF.Classpx
local WCLpm = ADDONSELF.WCLpm
local WCLcolor = ADDONSELF.WCLcolor
local Trade = ADDONSELF.Trade
local Listzhuangbei = ADDONSELF.Listzhuangbei
local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi
local Listjine = ADDONSELF.Listjine
local BossNum = ADDONSELF.BossNum
local FrameHide = ADDONSELF.FrameHide

local pt = print

local p = {}
local preWidget
local framedown
local frameright
local red, greed, blue = 1, 1, 1
local touming1, touming2 = 0.2, 0.4

function BG.ICCUI(FB)
    local bn = {
        [1] = 3,
        [2] = 3,
        [3] = 3,
        [4] = 4,
        [5] = 3,
        [6] = 3,
        [7] = 4,
        [8] = 3,
        [9] = 4,
        [10] = 3,
        [11] = 4,
        [12] = 5,
        [13] = 4,
        [14] = 7,
        [15] = 16,
        [16] = 8,
        [17] = 5,
    }

    for t = 1, 3 do
        local bb
        if t == 1 then
            bb = 8
        elseif t == 2 then
            bb = 6
        elseif t == 3 then
            bb = 6
        end
        for b = 1, bb do
            if t == 3 and b == 4 then -- 第3列第6个boss就不再创建
                break
            end

            local ii = bn[BossNum(FB, b, t)]
            for i = 1, ii do
                BG.FBBiaoTiUI(FB, t, b, bb, i, ii)
                BG.HistoryBiaoTiUI(FB, t, b, bb, i, ii)
                BG.ReceiveBiaoTiUI(FB, t, b, bb, i, ii)

                BG.FBZhuangBeiUI(FB, t, b, bb, i, ii)
                BG.HistoryZhuangBeiUI(FB, t, b, bb, i, ii)
                BG.ReceiveZhuangBeiUI(FB, t, b, bb, i, ii)

                BG.FBGuanZhuUI(FB, t, b, bb, i, ii)

                BG.FBMaiJiaUI(FB, t, b, bb, i, ii)
                BG.HistoryMaiJiaUI(FB, t, b, bb, i, ii)
                BG.ReceiveMaiJiaUI(FB, t, b, bb, i, ii)

                BG.FBJinEUI(FB, t, b, bb, i, ii)
                BG.HistoryJinEUI(FB, t, b, bb, i, ii)
                BG.ReceiveJinEUI(FB, t, b, bb, i, ii)

                BG.FBQianKuanUI(FB, t, b, bb, i, ii)

                BG.FBDiSeUI(FB, t, b, bb, i, ii)
                BG.HistoryDiSeUI(FB, t, b, bb, i, ii)
                BG.ReceiveDiSeUI(FB, t, b, bb, i, ii)
            end

            -- 对账
            do
                for i = 1, ii do
                    BG.DuiZhangBiaoTiUI(FB, t, b, bb, i, ii)
                    if BossNum(FB, b, t) <= Maxb[FB] then
                        BG.DuiZhangZhuangBeiUI(FB, t, b, bb, i, ii)
                        BG.DuiZhangMyJinEUI(FB, t, b, bb, i, ii)
                        BG.DuiZhangOtherJinEUI(FB, t, b, bb, i, ii)
                        BG.DuiZhangDiSeUI(FB, t, b, bb, i, ii)
                    end
                end

                if BossNum(FB, b, t) == Maxb[FB] + 1 then
                    local ii = 2
                    for i = 1, ii do
                        BG.DuiZhangZhuangBeiUI(FB, t, b, bb, i, ii)
                        BG.DuiZhangMyJinEUI(FB, t, b, bb, i, ii)
                        BG.DuiZhangOtherJinEUI(FB, t, b, bb, i, ii)
                        BG.DuiZhangDiSeUI(FB, t, b, bb, i, ii)
                    end
                end
                BG.DuiZhangBossNameUI(FB, t, b, bb, i, ii)
            end

            BG.FBBossNameUI(FB, t, b, bb, i, ii)
            BG.HistoryBossNameUI(FB, t, b, bb, i, ii)
            BG.ReceiveBossNameUI(FB, t, b, bb, i, ii)

            BG.FBJiShaUI(FB, t, b, bb, i, ii)
            BG.HistoryJiShaUI(FB, t, b, bb, i, ii)
            BG.ReceiveJiShaUI(FB, t, b, bb, i, ii)
        end
    end
    BG.FBZhiChuZongLanGongZiUI(FB)
    BG.HistoryZhiChuZongLanGongZiUI(FB)
    BG.ReceiveZhiChuZongLanGongZiUI(FB)

    -- BOSS模型
    do
        local model = CreateFrame("PlayerModel", nil, BG["Frame" .. FB])
        model:SetWidth(250)
        model:SetHeight(250)
        model:SetPoint("TOP", BG.Frame[FB].boss12.zhuangbei1, "TOPLEFT", -35, 70)
        model:SetFrameLevel(101)
        model:SetAlpha(0.5)
        model:SetDisplayInfo(25337)
        model:SetHitRectInsets(70, 70, 60, 100)

        local time = GetTime()
        local c = 1
        local s = 1
        local ss = { 17349, 17350, 17351, 17352, 17353, 17354, 17355, 17356, 17357 }
        model:SetScript("OnMouseUp", function()
            if c == 1 then
                PlaySound(ss[s], "Master")
                if s == #ss then
                    s = 1
                else
                    s = s + 1
                end
                time = GetTime()
                c = 2
            elseif GetTime() - time >= 10 then
                PlaySound(ss[s], "Master")
                if s == #ss then
                    s = 1
                else
                    s = s + 1
                end
                time = GetTime()
            end
        end)
    end
end
