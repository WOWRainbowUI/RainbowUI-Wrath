local TC2, C, L, _ = unpack(select(2, ...))
if TC2.locale ~= "zhTW" then return end

-----------------------------
--	zhTW client 彩虹-由麻也
--  Last update: 2022/09/04						   
-----------------------------
-- main frame
L.gui_threat		= "仇恨列表"
L.gui_config			= "設定選項"

-- config frame
L.reset					= "重置成預設值"

-- messages
L.message_welcome		= "輸入 /tc2 進入設定"
L.message_leader		= "你必須是隊長或助理"
L.message_outdated		= "|cFFFBB709TC:|r新版本已發佈，請去 https://www.curseforge.com/wow/addons/threatclassic2 下載最新版本。"
L.message_incompatible	= "你的 |cFFFBB709TC2仇恨監控|r 已過期，因此不相容，請立即升級。"

L.general				= "一般"
L.general_welcome		= "登入時顯示資訊"
L.general_rawPercent    = "啟用原始威脅值百分比 (近戰 110% / 遠程 130% 的仇恨)"   
L.general_downscaleThreat = "啟用調整威脅值 (修正後威脅值是1傷害等於1威脅值)"
L.general_downscaleThreatDesc = "暴雪威脅API是每造成1點傷害算100點威脅值。此設置是將威脅API的數字縮減為我們在補丁1.13.5之前使用的數字。"
L.general_updateFreq    = "更新間隔最短時間 (秒)。"   														  
L.general_updateFreq_desc            = "這個設置是為了限制tc2更新時的CPU消耗(例如，在targettarget模式下)。一般來說，威脅值不能更新得更快，因為暴雪的API更新速度限制了它們。"
L.general_test			= "啟用測試模式."
--L.general_minimap		= "小地圖按鈕."
--L.general_ignorePets	= "忽略玩家寵物的仇恨."

L.visibility			    = "可見性"
L.visibility_hideOOC	    = "離開戰鬥時隱藏框架"
L.visibility_hideSolo	    = "不在隊伍中時隱藏框架"
L.visibility_hideInPvP	    = "在戰場中隱藏框架"
L.visibility_hideOpenWorld  = "不在團隊中隱藏框架 (也隱藏世界首領!)"
L.visibility_hideAlways     = "總是隱藏框架。(輸入 /tc2 切換顯示)"

L.profiles              = "設定檔"

L.color					= "顏色"
L.color_good			= "低"
L.color_neutral			= "中"
L.color_bad				= "高"

L.appearance			= "外觀"

L.frame					= "框架"
L.frame_header			= "標題"
L.frame_bg				= "背景"
L.frame_test			= "測試模式"
L.frame_strata			= "層級"
L.frame_scale			= "大小"
L.frame_growup          = "向上生長"
L.frame_lock			= "鎖定"
L.frame_headerShow		= "顯示標題"
L.frame_headerColor		= "標題顏色"
L.frame_position        = "位置"
L.frame_width			= "寬度"
L.frame_height          = "高度"
L.frame_xOffset         = "水平位置"
L.frame_yOffset         = "垂直位置"

L.bar					= "仇恨條"
L.bar_descend			= "反向增長"
L.bar_height			= "高度"
L.bar_padding			= "間距"
L.bar_texture			= "材質"
L.bar_alpha				= "仇很條透明度 (預設顏色)"
L.bar_textOptions       = "文字設置"
L.bar_showThreatValue   = "顯示仇恨值"
L.bar_showThreatPercentage = "顯示仇恨百分比"
L.bar_showIgniteIndicator = "顯示點燃圖示"
L.bar_showIgniteIndicator_desc = "在當前擁有點燃的玩家姓名旁邊顯示一個小點燃圖示"

L.backdrop              = "仇恨條背景"
L.backdrop_texture    = "背景材質"
L.backdrop_color      = "背景顏色"
L.backdrop_edge         = "邊框"
L.backdrop_edgeTexture  = "邊框材質"
L.backdrop_edgeColor    = "邊框顏色"
L.backdrop_edgeSize     = "邊框大小"

L.igniteIndicator       = "點燃圖示"
L.igniteIndicator_makeRound = "圓角圖示"
L.igniteIndicator_makeRound_desc = "需要重新載入插件，以重新創建材質。"
L.igniteIndicator_size  = "大小"

L.customBarColors 			        = "自訂顏色"
L.customBarColorsPlayer_enabled	    = "啟用自訂玩家顏色"
L.customBarColorsPlayer_desc        = "無論任何其他顏色設定為何，此選項都會改為固定顏色."
L.customBarColorsActiveTank_enabled	= "啟用自訂坦克顏色"
L.customBarColorsOtherUnit_enabled 	= "啟用自訂其他玩家顏色"
L.customBarColorsIgnite_enabled     = "啟用點燃顏色"
L.customBarColorsIgnite_desc        = "如果單位擁有目標上的點燃，將更改仇恨條顏色。 坦克和玩家顏色優先。"
L.customBarColorsPlayer_color 	    = "玩家顏色"
L.customBarColorsActiveTank_color 	= "主坦克顏色"
L.customBarColorsOtherUnit_color 	= "其他玩家顏色"
L.customBarColorsIgnite_color       = "點燃單位顏色"

L.font					= "字體"
L.font_name			    = "名字"
L.font_size				= "大小"
L.font_style			= "樣式"
L.NONE                  = "無"
L.OUTLINE               = "外框"
L.THICKOUTLINE          = "粗外框"
L.font_shadow			= "文字陰影"

L.filter                = "過濾"
L.filter_outOfMelee     = "隱藏近戰範圍外的玩家"
L.filter_useTargetList  = "只過濾清單上的玩家"
L.filter_targetList     = "過濾清單 (使用Shift+Enter換行隔開)\n "
L.filter_targetList_desc = "輸入要過濾的首領或玩家。每行一個。注意:需要添加正確的名稱，例如：弒龍者戈魯爾"

L.warnings				= "警報"
L.warnings_disableWhileTanking  = "當你是坦克時關閉"
L.warnings_disableWhileTanking_desc = "當你處於防禦姿態或熊形態或正義之怒狀態時，或你被認為是坦克時。"
L.warnings_flash        = "啟用螢幕閃爍"
L.warnings_sound		= "啟用聲音"
L.warnings_threshold	= "警報仇恨臨界值 (100% = 獲得仇恨)"
L.warnings_minThreatAmount = "觸發警告的最小威脅值"
L.warnings_minThreatAmount_desc = "該值取決於 '一般->啟用原始威脅值百分比' 的設定，並與顯示的威脅相符合。可以在輸入框中設為更大的數字。"

L.warnings_soundFile = "警報音效"
L.warnings_soundChannel = "聲音頻道"

L.soundChannel_ambience = "環境"
L.soundChannel_master = "主音"
L.soundChannel_music = "音樂"
L.soundChannel_sfx = "音效"
L.addonName = "仇恨監控"