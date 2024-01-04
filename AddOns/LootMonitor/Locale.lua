local _, Addon = ...

-- 本地化字符串分配函数
local L = setmetatable({}, {
    __index = function(table, key)
        if key then
            table[key] = tostring(key)
        end
        return tostring(key)
    end,
})

Addon.L = L
local locale = GetLocale()

-- 本地化字符串
if locale == "enUs" then -- 英文
	L["Loot Monitor v%s"] = "Loot Monitor v%s"
	L["LootMonitor:"] = "LootMonitor:"
    L["<|cFFFF4500LM|r>Need Update your |cFFFF4500LootMonitor|r to newest one!"] = true
    L["|cFF4169E1Download Link|r https://www.curseforge.com/wow/addons/lootmonitor"] = true
    L["<|cFFFF4500LM|r>Check |cFFFF4500LootMonitor|r Addon State."] = true
    L["<|cFFFF4500LM|r>Not in a Group."] = true
    L["NoAddon"] = true
    L["Muted"] = true
    L["Quality"] = true
    L["|cFFFFFFFFCommon|r"] = true
    L["|cFF1EFF00Uncommon|r"] = true
    L["|cFF0081FFRare|r"] = true
    L["|cFFC600FFEpic|r"] = true
    L["Enabled"] = true
    L["Output to RW"] = true
    L["First Enterer"] = true
    L["Single Disable"] = true
    L["Check Stats"] = true
    L["Show Logs"] = true
    L["Boss Only"] = true
    L["<LM>Among all members who installed LootMonitor"] = true
    L["<LM><%s> has Looted <%s>'s Corpse"] = true
    L["<LM><%s>'s Corpse Opened"] = true
    L["<LM>Total "] = true
    L[" Common+ Item(s)"] = true
    L[" Uncommon+ Item(s)"] = true
    L[" Rare+ Item(s)"] = true
    L[" Epic+ Item(s)"] = true
    L["<LM>The first player who entered <%s> Raid Instance is <%s>."] = true
    L["Onyxia's Lair"] = true
	L["Molten Core"] = true
	L["Blackwing Lair"] = true
    L["Temple of Ahn'Qiraj"] = true
    L["Naxxramas"] = true
    L["Zul'Gurub"] = true
    L["Ruins of Ahn'Qiraj"] = true
elseif locale == "zhCN" then -- 简体中文
    L["<|cFFFF4500LM|r>Need Update your |cFFFF4500LootMonitor|r to newest one!"] = "<|cFFFF4500LM|r>需要升级你的LootMonitor插件！"
    L["|cFF4169E1Download Link|r https://www.curseforge.com/wow/addons/lootmonitor"] = "|cFF4169E1下载链接|r https://www.curseforge.com/wow/addons/lootmonitor"
    L["<|cFFFF4500LM|r>Check |cFFFF4500LootMonitor|r Addon State."] = "<|cFFFF4500LM|r>检查|cFFFF4500LootMonitor|r插件安装情况。"
    L["<|cFFFF4500LM|r>Not in a Group."] = "<|cFFFF4500LM|r>你不在一个队伍/团队中。"
    L["NoAddon"] = "无插件"
    L["Muted"] = "不发言"
    L["Quality"] = "通报等级"
    L["|cFFFFFFFFCommon|r"] = "|cFFFFFFFF白色物品|r"
    L["|cFF1EFF00Uncommon|r"] = "|cFF1EFF00绿色物品|r"
    L["|cFF0081FFRare|r"] = "|cFF0081FF蓝色物品|r"
    L["|cFFC600FFEpic|r"] = "|cFFC600FF紫色物品|r"
    L["Enabled"] = "启用"
    L["Output to RW"] = "输出到RW"
    L["First Enterer"] = "首个进本通报"
    L["Single Disable"] = "单人禁用"
    L["Check Stats"] = "检查版本"
    L["Show Logs"] = "显示记录"
    L["Boss Only"] = "仅BOSS通报"
    L["Mini Btn"] = "迷你按钮"
    L["<LM><%s> has Looted <%s>'s Corpse"] = "<LM><%s>第一个开启<%s>："
    L["<LM><%s>'s Corpse Opened"] = "<LM><%s>已开启"
    L["<LM>Total "] = "<LM>共"
    L[" Common+ Item(s)"] = "件白色以上物品"
    L[" Uncommon+ Item(s)"] = "件绿色以上物品"
    L[" Rare+ Item(s)"] = "件蓝色以上物品"
    L[" Epic+ Item(s)"] = "件紫色以上物品"
    L["<LM>The first player who entered <%s> Raid Instance is <%s>."] = "<LM>第一个进入Raid副本<%s>的玩家是<%s>。"
    L["Onyxia's Lair"] = "奥妮克希亚的巢穴"
	L["Molten Core"] = "熔火之心"
	L["Blackwing Lair"] = "黑翼之巢"
    L["Temple of Ahn'Qiraj"] = "安其拉神殿"
    L["Naxxramas"] = "纳克萨玛斯"
    L["Zul'Gurub"] = "祖尔格拉布"
    L["Ruins of Ahn'Qiraj"] = "安其拉废墟"
    L["Karazhan"] = "卡拉赞"
    L["Black Temple"] = "黑暗神殿"
    L["Gruul's Lair"] = "格鲁尔的巢穴"
    L["Hyjal Summit"] = "海加尔峰"
    L["Magtheridon's Lair"] = "玛瑟里顿的巢穴"
    L["Serpentshrine Cavern"] = "毒蛇神殿"
    L["Sunwell Plateau"] = "太阳之井高地"
    L["Tempest Keep"] = "风暴要塞"
    L["Zul'Aman"] = "祖阿曼"
    L["Expired In "] = "保存："
    L[" Day(s)"] = "天"
    L["UNKNOWN"] = "未知"
    L["Clean"] = "清空"
    L["Loot Logs"] = "拾取记录"
    L["<|cFFBA55D3LootMonitor|r>No Loot Log!"] = "<|cFFBA55D3LootMonitor|r>没有拾取记录!"
    L["[|cFFFFFF00%s|r]  |cFFFF69B4Raid Instance:|r <|cFFDC143C%s|r>\n    |cFF00BFFFAlt in Raid:|r [%s|r]\n    |cFFFFA07AInstance ID:|r |cFFFFD700%s|r\n    |cFFDA70D6First Entered Player:|r [%s|r]\n"] = "[|cFFFFFF00%s|r]  |cFFFF69B4Raid副本:|r <|cFFDC143C%s|r>\n    |cFF00BFFF参与者:|r [%s|r]\n    |cFFFFA07A副本ID:|r |cFFFFD700%s|r\n    |cFFDA70D6首个进入:|r [%s|r]\n"
    L["|cFFBA55D3LootMonitor|r Tips: Use |cFF00BFFF/lootmonitor|r or |cFF00BFFF/lm|r open GUI, Use |cFF00BFFF/lootmonitor|r |cFFFF9000lootlog|r or |cFF00BFFF/lm|r |cFFFF9000ll|r open Loots Logs."] = "|cFFBA55D3LootMonitor|r命令行提示: 输入|cFF00BFFF/lootmonitor|r 或 |cFF00BFFF/lm|r 打开设置页面, 输入|cFF00BFFF/lootmonitor|r |cFFFF9000lootlog|r 或 |cFF00BFFF/lm|r |cFFFF9000ll|r 查看Loot记录。"
    L["|cFF00FF00Left Click|r to Open Log Frame"] = "|cFF00FF00左键|r打开记录窗口"
	L["|cFF00FF00Right Click|r to Open Config Frame"] = "|cFF00FF00右键|r打开设置窗口"
	L["|cFF00FF00Shift+Left|r to Restore Log Frame Position"] = "|cFF00FF00Shift+左键|r重置记录窗口位置"
	L["|cFF00FF00Shift+Right|r to Restore Minimap Icon Position"] = "|cFF00FF00Shift+右键|r重置小地图按钮位置"
elseif locale == "zhTW" then -- 繁体中文 供中国台湾省、香港特别行政区、澳门特别行政区同胞使用
    L["Loot Monitor v%s"] = "拾取監控 v%s"
	L["LootMonitor:"] = "拾取監控"
	L["<|cFFFF4500LM|r>Need Update your |cFFFF4500LootMonitor|r to newest one!"] = "<|cFFFF4500LM|r> 需要升級你的 LootMonitor！"
    L["|cFF4169E1Download Link|r https://www.curseforge.com/wow/addons/lootmonitor"] = "|cFF4169E1下載連結|r https://www.curseforge.com/wow/addons/lootmonitor"
    L["<|cFFFF4500LM|r>Check |cFFFF4500LootMonitor|r Addon State."] = "<|cFFFF4500LM|r> 檢查隊伍/團隊 |cFFFF4500LootMonitor|r 安裝情況。"
    L["<|cFFFF4500LM|r>Not in a Group."] = "<|cFFFF4500LM|r> 你不在一個隊伍/團隊中。"
    L["NoAddon"] = "沒有插件"
    L["Muted"] = "不通報"
    L["Quality"] = "物品等級"
    L["|cFFFFFFFFCommon|r"] = "|cFFFFFFFF普通物品|r"
    L["|cFF1EFF00Uncommon|r"] = "|cFF1EFF00優秀物品|r"
    L["|cFF0081FFRare|r"] = "|cFF0081FF精良物品|r"
    L["|cFFC600FFEpic|r"] = "|cFFC600FF史詩物品|r"
	L["Enabled"] = "啟用"
    L["Output to RW"] = "輸出到 RW"
    L["First Enterer"] = "通報誰第一個進本"
    L["Single Disable"] = "單人時停用"
    L["Check Stats"] = "檢查版本"
    L["Show Logs"] = "顯示記錄"
	L["Boss Only"] = "只通報首領"
	L["Mini Btn"] = "小地圖按鈕"							  
    L["<LM><%s> has Looted <%s>'s Corpse"] = "<LM> <%s> 打開了 <%s> 的屍體"
    L["<LM><%s>'s Corpse Opened"] = "<LM> <%S> 的屍體打開了"
    L["<LM>Total "] = "<LM>共 "
    L[" Common+ Item(s)"] = " 件普通以上物品"
    L[" Uncommon+ Item(s)"] = " 件優秀以上物品"
    L[" Rare+ Item(s)"] = " 件精良以上物品"
    L[" Epic+ Item(s)"] = " 件史詩以上物品"
    L["<LM>The first player who entered <%s> Raid Instance is <%s>."] = "<LM> 第一個進入 <%s> 的玩家是 <%s>。"
	L["Onyxia's Lair"] = "奧妮克希亞的巢穴"
	L["Molten Core"] = "熔火之心"
	L["Blackwing Lair"] = "黑翼之巢"
    L["Temple of Ahn'Qiraj"] = "安其拉神殿"
    L["Naxxramas"] = "納克薩瑪斯"
    L["Zul'Gurub"] = "祖爾格拉布"
    L["Ruins of Ahn'Qiraj"] = "安其拉廢墟"
    L["Karazhan"] = "卡拉赞"
    L["Black Temple"] = "黑暗神廟"
    L["Gruul's Lair"] = "戈魯爾之巢"
    L["Hyjal Summit"] = "海加爾山"
    L["Magtheridon's Lair"] = "瑪瑟里頓的巢穴"
    L["Serpentshrine Cavern"] = "毒蛇神殿"
    L["Sunwell Plateau"] = "太陽之井高地"
    L["Tempest Keep"] = "風暴要塞"
    L["Zul'Aman"] = "祖阿曼"
    L["Expired In "] = "保留: "
    L[" Day(s)"] = " 天"
    L["UNKNOWN"] = "未知"
    L["Clean"] = "清空"
    L["Loot Logs"] = "拾取記錄"
    L["<|cFFBA55D3LootMonitor|r>No Loot Log!"] = "<|cFFBA55D3LootMonitor|r> 沒有拾取記錄!"
    L["[|cFFFFFF00%s|r]  |cFFFF69B4Raid Instance:|r <|cFFDC143C%s|r>\n    |cFF00BFFFAlt in Raid:|r [%s|r]\n    |cFFFFA07AInstance ID:|r |cFFFFD700%s|r\n    |cFFDA70D6First Entered Player:|r [%s|r]\n"] = "[|cFFFFFF00%s|r]  |cFFFF69B4團本:|r <|cFFDC143C%s|r>\n    |cFF00BFFF參與者:|r [%s|r]\n    |cFFFFA07A副本 ID:|r |cFFFFD700%s|r\n    |cFFDA70D6第一個進入:|r [%s|r]\n"
    L["|cFFBA55D3LootMonitor|r Tips: Use |cFF00BFFF/lootmonitor|r or |cFF00BFFF/lm|r open GUI, Use |cFF00BFFF/lootmonitor|r |cFFFF9000lootlog|r or |cFF00BFFF/lm|r |cFFFF9000ll|r open Loots Logs."] = "|cFFBA55D3LootMonitor|r 指令說明: 輸入 |cFF00BFFF/lootmonitor|r 或 |cFF00BFFF/lm|r 打開設定選項，輸入 |cFF00BFFF/lootmonitor|r |cFFFF9000lootlog|r 或 |cFF00BFFF/lm|r |cFFFF9000ll|r 查看拾取記錄。"
    L["|cFF00FF00Left Click|r to Open Log Frame"] = "|cFF00FF00左鍵|r 打開記錄視窗"
    L["|cFF00FF00Right Click|r to Open Config Frame"] = "|cFF00FF00右鍵|r 打開設定選項"
    L["|cFF00FF00Shift+Left|r to Restore Log Frame Position"] = "|cFF00FF00Shift+左鍵|r 重置記錄視窗位置"
    L["|cFF00FF00Shift+Right|r to Restore Minimap Icon Position"] = "|cFF00FF00Shift+右鍵|r 重置小地圖按鈕位置"
elseif locale == "ruRU" then -- Русский by Hubbotu
    L["<|cFFFF4500LM|r>Need Update your |cFFFF4500LootMonitor|r to newest one!"] = "<|cFFFF4500LM|r>Нужно обновить ваш |cFFFF4500LootMonitor|r до последней версии!"
    L["|cFF4169E1Download Link|r https://www.curseforge.com/wow/addons/lootmonitor"] = "|cFF4169E1Ссылка на скачивание|r https://www.curseforge.com/wow/addons/lootmonitor"
    L["<|cFFFF4500LM|r>Check |cFFFF4500LootMonitor|r Addon State."] = "<|cFFFF4500LM|r>Проверьте |cFFFF4500LootMonitor|r Состояние Аддона."
    L["<|cFFFF4500LM|r>Not in a Group."] = "<|cFFFF4500LM|r>Не в группе."
    L["NoAddon"] = "Без Аддона"
    L["Quality"] = "Качество"
    L["|cFFFFFFFFCommon|r"] = "|cFFFFFFFFОбычный|r"
    L["|cFF1EFF00Uncommon|r"] = "|cFF1EFF00Необычный|r"
    L["|cFF0081FFRare|r"] = "|cFF0081FFРедкий|r"
    L["|cFFC600FFEpic|r"] = "|cFFC600FFЭпический|r"
    L["Output to RW"] = "Вывод на RW"
    L["Always"] = "Всегда"
    L["Single Disable"] = "Одиночное Отключение"
    L["Check ALL"] = "Проверьте все"
    L["Show State"] = "Показать Состояние"
    L["<LM><%s> has Looted <%s>'s Corpse"] = "<LM><%s> добыча с <%s>"
    L["<LM><%s>'s Corpse Opened"] = "<LM><%s>'s Corpse Opened"
    L["<LM>Total "] = "<LM>Всего "
    L[" Common+ Item(s)"] = " Обычный+ Предмет(ы)"
    L[" Uncommon+ Item(s)"] = " Необычный+ Предмет(ы)"
    L[" Rare+ Item(s)"] = " Редкий+ Предмет(ы)"
    L[" Epic+ Item(s)"] = " Эпический+ Предмет(ы)"
end