--[[--
	alex@0
--]]--
----------------------------------------------------------------------------------------------------
local __addon, __private = ...;
local MT = __private.MT;
local CT = __private.CT;
local VT = __private.VT;
local DT = __private.DT;
local l10n = CT.l10n;

if GetLocale() ~= "zhTW" then return;end

BINDING_NAME_ALARAIDTOOL_NEWWINDOW = "新增模擬器";
BINDING_NAME_ALARAIDTOOL_QUERY = "查看目標天賦";
BINDING_HEADER_ALATALENTEMU_HEADER = "<\124cff00ff00alaTalentEmu\124r>天賦模擬器";

l10n.Locale = "zhTW";

l10n.Emu = "天賦模擬器";
l10n.OK = "確定";
l10n.Cancel = "取消";
l10n.Search = "搜尋";
l10n.Hide = "隱藏";
l10n.CurTreePointsLabel = "點數";
l10n.CurPointsTotal = "總點數";
l10n.CurPointsRemaining = "剩餘";
l10n.CurPointsUsed = "已使用";
l10n.CurPointsReqLevel = "等級";
l10n.message = "*聊天訊息";
l10n.import = "匯入";
l10n.me = "我";

l10n.ReadOnly = "|cffff0000唯讀|r";
l10n.NonReadOnly = "|cff00ff00可編輯|r";
l10n.LabelPointsChanged = "(|cffff0000修改|r)";
l10n.ResetButton = "重置本欄天賦";
l10n.ResetAllButton = "重置所有天賦";
l10n.ResetToSetButton = "重置到初始狀態";
l10n.ReadOnlyButton = "\124cff00ff00點一下\124r設定";
l10n.CloseButton = "關閉視窗";

l10n.ClassButton = "\n\124cff00ff00左鍵\124r切換職業\n\124cff00ff00右鍵\124r載入預設天賦樹\n    (來源\124cffff0000wowhead\124r)";
l10n.InspectTargetButton = "觀察目標天賦";
l10n.SpellListButton = "技能列表";
l10n.SpellAvailable = "|cff00ff00技能可用|r";
l10n.SpellUnavailable = "|cffff0000技能不可用|r";
l10n.TrainCost = "訓練費用 ";
l10n.ShowAllSpell = "顯示所有等級";
l10n.ApplyTalentsButton = "套用目前模擬的天賦";
l10n.ApplyTalentsButton_Notify = "是否確定要套用目前所模擬的天賦?";
l10n.ApplyTalentsFinished = "天賦已套用";
l10n.ImportButton = "匯入字串或 wowhead/nfu/yxrank 連結";
l10n.ExportButton = "|cff00ff00左鍵|r匯出字串\n|cff00ff00右鍵|r匯出 |cffff0000wowhead/nfu|r 網頁連結";
l10n.AllData = "天賦+雕紋+裝備";
l10n.SaveButton = "|cff00ff00左鍵|r儲存天賦設定\n|cff00ff00右鍵|r載入已儲存的天賦\n|cff00ff00ALT+右鍵|r載入其他角色的天賦雕紋裝備\n|cff00ff00子選單中Shift+左鍵|r删除天賦";
l10n.SendButton = "|cff00ff00左鍵|r發送天賦到聊天\n|cff00ff00右鍵|r查看最近聊天中的天賦";
l10n.EquipmentFrameButton = "打開裝備查看";

l10n.TalentFrameCallButton = "打開ala天賦模擬器";
l10n.TalentFrameCallButtonString = "模擬器";
l10n.CurRank = "目前等級";
l10n.NextRank = "下一等級";
l10n.MaxRank = "最高等級";
l10n.ReqPoints = "%d/%d點%s";

l10n.AutoShowEquipmentFrame_TRUE = "自動顯示裝備列表";
l10n.AutoShowEquipmentFrame_FALSE = "手動顯示裝備列表";
l10n.Minimap_TRUE = "顯示小地圖按鈕";
l10n.Minimap_FALSE = "隱藏小地圖按鈕";
l10n.ResizableBorder_TRUE = "拖曳視窗邊緣改變大小";
l10n.ResizableBorder_FALSE = "停用拖曳視窗邊緣改變大小";
l10n.SetWinStyle_BLZ = "設為暴雪風格視窗";
l10n.SetWinStyle_ALA = "設為平面風格視窗";
l10n.SetSingleFrame_True = "設為顯示單一視窗";
l10n.SetSingleFrame_False = "設為顯示多個視窗";
l10n.SetStyleAllTo1_ThisWin = "視窗設為三欄顯示所有天賦";
l10n.SetStyleAllTo2_ThisWin = "視窗設為為單欄顯示天賦樹，使用標籤頁切換";
l10n.SetStyleAllTo1_AlsoSetShownWin = "設為三欄顯示所有天賦 (同時更改已顯示的視窗)";
l10n.SetStyleAllTo1_LaterWin = "設為三欄顯示所有天賦";
l10n.SetStyleAllTo2_AlsoSetShownWin = "設為單欄顯示天賦樹，使用標籤頁切換 (同時更改已顯示的視窗)";
l10n.SetStyleAllTo2_LaterWin = "設為單欄顯示天賦樹，使用標籤頁切換";
l10n.TalentsInTip_TRUE = "在滑鼠提示中顯示玩家天賦";
l10n.TalentsInTip_FALSE = "不要在滑鼠提示中顯示玩家天賦";
l10n.TalentsInTipIcon_TRUE = "滑鼠提示中使用圖示表示天賦樹";
l10n.TalentsInTipIcon_FALSE = "滑鼠提示中使用文字表示天賦樹";
l10n.InspectButtonOnUnitFrame_TRUE = "啟用觀察按鈕 (按住 Alt/Ctrl/Shift 鍵在目標頭像上顯示觀察按鈕)";
l10n.InspectButtonOnUnitFrame_FALSE = "停用觀察按鈕";
l10n.InsepctKey_ALT = "按住 Alt 鍵顯示觀察按鈕";
l10n.InsepctKey_CTRLK = "按住 Ctrl 鍵顯示觀察按鈕";
l10n.InsepctKey_SHIFT = "按住 Shift 鍵顯示觀察按鈕";

l10n.DBIcon_Text = "\124cff00ff00左鍵\124r新增模擬器\n\124cff00ff00右鍵\124r打開隊伍檢查";
l10n.SpellListFrameGTTSpellLevel = "技能等級: ";
l10n.SpellListFrameGTTReqLevel = "需要等級: ";

l10n.DATA = {
	talent = "天賦",

	DEATHKNIGHT = "死亡騎士",
	DRUID = "德魯伊",
	HUNTER = "獵人",
	MAGE = "法師",
	PALADIN = "聖騎士",
	PRIEST = "牧師",
	ROGUE = "盜賊",
	SHAMAN = "薩滿",
	WARLOCK = "術士",
	WARRIOR = "戰士",

	[398] = "鮮血",
	[399] = "冰霜",
	[400] = "邪惡",
	[283] = "平衡",
	[281] = "野性戰鬥",
	[282] = "恢復",
	[361] = "野獸控制",
	[363] = "射擊",
	[362] = "生存",
	[81] = "祕法",
	[41] = "火焰",
	[61] = "冰霜",
	[382] = "神聖",
	[383] = "防護",
	[381] = "懲戒",
	[201] = "戒律",
	[202] = "神聖",
	[203] = "暗影",
	[182] = "刺殺",
	[181] = "戰鬥",
	[183] = "敏銳",
	[261] = "元素",
	[263] = "增強",
	[262] = "恢復",
	[302] = "痛苦",
	[303] = "惡魔學識",
	[301] = "毀滅",
	[161] = "武器",
	[164] = "狂怒",
	[163] = "防護",

	H = "|cff00ff00治療者|r",
	D = "|cffff0000DPS|r",
	T = "|cffafafff坦克|r",
	P = "|cffff0000PVP|r",
	E = "|cffffff00PVE|r",

};

l10n.RACE = "种族";
l10n["HUMAN|DWARF|NIGHTELF|GNOME|DRAENEI"] = "聯盟";
l10n["ORC|SCOURGE|TAUREN|TROLL|BLOODELF"] = "部落";
l10n["HUMAN"] = "人類";
l10n["DWARF"] = "矮人";
l10n["NIGHTELF"] = "夜精靈";
l10n["GNOME"] = "地精";
l10n["DRAENEI"] = "德萊尼";
l10n["ORC"] = "獸人";
l10n["SCOURGE"] = "不死族";
l10n["TAUREN"] = "牛頭人";
l10n["TROLL"] = "食人妖";
l10n["BLOODELF"] = "血精靈";


l10n.RaidToolLableItemLevel = "裝等";
l10n.RaidToolLableItemSummary = "裝備";
l10n.RaidToolLableEnchantSummary = "附魔";
l10n.RaidToolLableGemSummary = "寶石";
l10n.RaidToolLableBossModInfo = "DBM版本";										
l10n.guildList = "公會成員";

l10n.SLOT = {
	[0] = "子彈",
	[1] = "頭部",
	[2] = "頸部",
	[3] = "肩部",
	[4] = "襯衣",
	[5] = "胸甲",
	[6] = "腰帶",
	[7] = "腿部",
	[8] = "靴子",
	[9] = "護腕",
	[10] = "手套",
	[11] = "戒指",
	[12] = "戒指",
	[13] = "飾品",
	[14] = "飾品",
	[15] = "披風",
	[16] = "主手",
	[17] = "副手",
	[18] = "遠程",
	[19] = "戰袍",
};
l10n.EMTPY_SLOT = "|cffff0000未裝備|r";
l10n.MISS_ENCHANT = "|cffff0000缺少附魔|r";

l10n.Gem = {
	Red = "|cffff0000紅|r",
	Blue = "|cff007fff藍|r",
	Yellow = "|cfffcff00黃|r",
	Purple = "|cffff00ff紫|r",
	Green = "|cff00ff00綠|r",
	Orange = "|cffff7f00橙|r",
	Meta = "|cffffffff彩|r",
	Prismatic = "|cffffffff棱|r",
};
l10n.MissGem = {
	["?"] = "|cff7f7f7f？|r",
	Red = "|cff7f7f7f紅|r",
	Blue = "|cff7f7f7f藍|r",
	Yellow = "|cff7f7f7f黃|r",
	Purple = "|cff7f7f7f紫|r",
	Green = "|cff7f7f7f綠|r",
	Orange = "|cff7f7f7f橙|r",
	Meta = "|cff7f7f7f彩|r",
	Prismatic = "|cff7f7f7f棱|r",
};




l10n["CANNOT APPLY : NEED MORE TALENT POINTS."] = "無法套用天賦: 需要更多天賦點數";
l10n["CANNOT APPLY : TALENTS IN CONFLICT."] = "無法套用天賦: 與當前天賦衝突";
l10n["CANNOT APPLY : UNABLE TO GENERATE TALENT MAP."] = "無法套用天賦: 創建天賦對映表發生錯誤";
l10n["CANNOT APPLY : TALENT MAP ERROR."] = "無法套用天賦: 讀取天賦對映表發生錯誤";
l10n["TalentDB Error : DB SIZE IS NOT EQUAL TO TalentFrame SIZE."] = "數據錯誤: 與天賦面板的天賦數量不一致";


l10n.PopupQuery = "查詢天賦";

--	emulib
l10n["WOW VERSION"] = "不是當前版本客戶端的天賦";
l10n["NO DECODER"] = "無法解析天賦數據";