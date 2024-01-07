local AddonName, ADDONSELF = ...

if (GetLocale() ~= "zhTW") then return end

local update = ""
do --繁体说明书
    local text
    text = "|cffFFFFFF< 我是說明書 >|r\n\n"
    text = text .. "1、打開命令：|cff00BFFF/BiaoGe或/GBG|r，或遊戲設定裏綁定按鍵。小地圖圖標：" .. "|TInterface\\AddOns\\BiaoGe\\Media\\icon\\icon:0|t" .. "\n"
    text = text .. "2、按Tab、Enter、方向鍵可以跳轉光標，ALT/CTRL/SHIFT+方向鍵跳轉至下個BOSS。\n    點空白處可取消光標，右鍵輸入框可清除內容\n"
    text = text .. "3、SHIFT+點擊裝備可把裝備發到聊天框。相反點聊天裏的裝備也可添加到表格\n從背包把裝備拖到表格裏也能添加裝備\n"
    text = text .. "4、ALT+點擊裝備可關注裝備，團長拍賣此裝備時會提醒\n"
    text = text .. "    团长或物品分配者ALT+點擊當前表格、背包、聊天框的裝備，自動開始拍賣倒數\n"
    text = text .. "5、CTRL+點擊裝備可通報歷史價格，這個功能需要你的歷史表格曾記錄過該裝備的金額\n"
    text = text .. "6、CTRL+ALT+點擊格子1，再點格子2，可交換兩行全部內容（裝備、買家、金額、關注、欠款）\n"
    text = text .. "7、當團長貼出裝備開始拍賣時，會自動高亮表格裏相應的裝備\n\n"
    text = text .. "BUG可迴響到： buick_hbj@163.com或Q群322785325\n\n"

    update = update .. "|cff00FF00" .. "10月12日更新1.5.8版本" .. "|r\n"
    update = update .. "1、更新ICC7、8、9、10號BOSS攻略" .. "\n"
    update = update .. [[2、現在"某某加入了團隊"的系統消息也會染上職業顏色]] .. "\n"
    update = update .. "3、現在右鍵聊天輸入框也可以使用密語模板" .. "\n"
    update = update .. "4、其他一些小調整" .. "\n\n"

    update = update .. "|cff00FF00" .. "10月7日更新1.5.7版本" .. "|r\n"
    update = update .. "1、WTF數據文件優化：現在所有數據統一保存在賬號文件夾" .. "\n"
    update = update .. "2、優化和增強聊天頻道的查詢YY大眾評價功能" .. "\n"
    update = update .. "3、聊天頻道右鍵玩家的菜單裡，增加密語模板按鈕" .. "\n"
    update = update .. "4、角色總覽現在按裝等從高到低排序" .. "\n\n"

    text = text .. update
    text = text .. "|cff00FF00按住ALT顯示更多更新記錄|r"

    ADDONSELF.instructionsText = text
end
do --繁体更新内容
    local update = "|cff00BFFF< 主要更新記錄 >|r\n\n" .. update

    update = update .. "|cff00FF00" .. "10月1日更新1.5.6d版本" .. "|r\n"
    update = update .. "1、修復了點擊裝備下拉列表第二列後設置的裝備不正確的問題" .. "\n\n"

    update = update .. "|cff00FF00" .. "9月29日更新1.5.6c版本" .. "|r\n"
    update = update .. "1、集結號密語模板優化：在按住SHIFT+點擊密語時不會添加模板內容" .. "\n"
    update = update .. "2、修復了在你充當團長時，裝備自動記錄功能偶爾會漏記的問題" .. "\n"
    update = update .. "3、修復了多個計時器在介面隱藏時沒有繼續計時的問題" .. "\n"
    update = update .. "4、修復了高亮天賦裝備偶爾不生效的問題" .. "\n\n"

    update = update .. "|cff00FF00" .. "9月27日更新1.5.6b版本" .. "|r\n"
    update = update .. "1、調整角色總覽顯示位置，不再出現遮擋的情況" .. "\n"
    update = update .. "2、修復了高亮天賦裝備出現的錯誤" .. "\n\n"

    update = update .. "|cff00FF00" .. "9月26日更新1.5.6版本" .. "|r\n"
    update = update .. "1、新增角色5人本完成总览，顯示在隊伍查找器右邊" .. "\n"
    update = update .. "2、新增集結號密語模板（預設成就、裝等、自定義文本）。可在插件設置裡開啟該功能" .. "\n"
    update = update .. "3、更新ICC1、2、4、5、6號BOSS攻略" .. "\n"
    update = update .. "4、插件設置增加選項：團本攻略字體大小" .. "\n"
    update = update .. "5、3.4.3版本的角色貨幣總覽添加新牌子：褻瀆者的天災石" .. "\n"
    update = update .. "6、修復了繁體端部分文本亂碼的問題" .. "\n"
    update = update .. "7、為了更高效收集插件問題，新建了Q群322785325，可以進群反饋問題" .. "\n\n"

    update = update .. "|cff00FF00" .. "9月12日更新1.5.5版本" .. "|r\n"
    update = update .. "1、插件設置增加選項：集結號活動按隊伍人數排序。該功能默認關閉" .. "\n"
    update = update .. "2、集結號歷史搜索記錄的最大保存數量改為8個" .. "\n\n"

    update = update .. "|cff00FF00" .. "9月8日更新1.5.4版本" .. "|r\n"
    update = update .. "1、插件設置增加選項：不自動退出集結號頻道（讓你隨時打開集結號都能查看全部活動）。該功能默認關閉" .. "\n"
    update = update .. "2、集結號歷史搜索記錄現在可以右鍵刪除記錄" .. "\n"
    update = update .. "3、裝備下拉列表加寬，盡可能顯示裝備全稱" .. "\n\n"

    update = update .. "|cff00FF00" .. "9月5日更新1.5.3版本" .. "|r\n"
    update = update .. "1、YY評價增加一個開關，右鍵底部標籤頁選擇開啟/關閉該模塊" .. "\n"
    update = update .. "2、說明書與更新記錄現在按住ALT切換顯示" .. "\n"
    update = update .. "3、更新ICC老一攻略，修復一些錯誤內容" .. "\n"
    update = update .. "4、給集結號的搜索框增加一個歷史搜索記錄" .. "\n\n"

    ADDONSELF.upDateText = update
end

local L = setmetatable({}, {
    __index = function(table, key)
        return tostring(key)
    end
})

do
    L["该BOSS攻略提供：@大树先生\n点击复制NGA攻略地址"] = "该BOSS攻略提供：@大樹先生\n點擊複製NGA攻略地址"
    L["3、右键聊天频道玩家的菜单里增加密语模板按钮"] = "3、右鍵聊天頻道玩家的菜單裡增加密語模板按鈕"
    L["4、右键聊天输入框增加密语模板按钮"] = "4、右鍵聊天輸入框增加密語模板按鈕"
    L["< 查询大众评价 >"] = "< 查詢大眾評價 >"
    L["1、对BiaoGeYY频道的在线玩家发出该YY的请求"] = "1、對BiaoGeYY頻道的在線玩家發出該YY的請求"
    L["2、如果这些玩家有该YY的评价，则会通过匿名方式把评价发送给你"] = "2、如果這些玩家有該YY的評價，則會通過匿名方式把評價發送給你"
    L["3、不同时间查询到的大众评价可能会不同，因为在线的玩家会不同"] = "3、不同時間查詢到的大眾評價可能會不同，因為在線的玩家會不同"


    L["使用密语模板"] = "使用密語模板"
    L["查询正在初始化，请稍后再试"] = "查詢正在初始化，請稍後再試"
    L["正在查询中"] = "正在查詢中"
    L["查询CD中，剩余%s秒"] = "查詢CD中，剩餘%s秒"
    L["正在查询YY%s的大众评价"] = "正在查詢YY%s的大眾評價"
    L["详细"] = "詳細"
    L["|cffFFFFFF左键：|r查询大众评价"] = "|cffFFFFFF左鍵：|r查詢大眾評價"
    L["|cffFFFFFFSHIFT+左键：|r复制该号码"] = "|cffFFFFFFSHIFT+左鍵：|r複製該號碼"
    L["以往查询结果(%s)："] = "以往查詢結果(%s)："
    L["以往查询结果(可能已过时)："] = "以往查詢結果(可能已過時)："
    L["|cff00FF00好评：%s个|r"] = "|cff00FF00好評：%s個|r"
    L["|cffFFFF00中评：%s个|r"] = "|cffFFFF00中評：%s個|r"
    L["|cffDC143C差评：%s个|r"] = "|cffDC143C差評：%s個|r"
    L["查询成功：YY%s的评价|cffFFFFFF一共%s个|r。|cff00FF00好评%s个|r，|cffFFFF00中评%s个|r，|cffDC143C差评%s个。|r%s"] = "查詢成功：YY%s的評價|cffFFFFFF一共%s個|r。|cff00FF00好評%s個|r，|cffFFFF00中評%s個|r，|cffDC143C差評%s個。|r%s"
    L["查询成功！CD"] = "查詢成功！CD"


    L["你的评价可以帮助别人辨别该团好与坏\n当其他玩家查询大众评价而你有该YY的评价时，会以匿名的方式发送给对方"] = "你的評價可以幫助別人辨別該團好與壞\n當其他玩家查詢大眾評價而你有該YY的評價時，會以匿名的方式發送給對方"
    L["你的评价被其他玩家查询的次数"] = "你的評價被其他玩家查詢的次數"


    L["1、预设成就、装等、自定义文本，当你点击集结号活动密语时会自动添加该内容"] = "1、預設成就、裝等、自定義文本，當你點擊集結號活動密語時會自動添加該內容"
    L["2、按住SHIFT+点击密语时不会添加"] = "2、按住SHIFT+點擊密語時不會添加"


    L["|cff808080（右键打开设置）|r"] = "|cff808080（右鍵打開設置）|r"
    L["|cff808080（左键打开表格，右键打开设置）|r"] = "|cff808080（左鍵打開表格，右鍵打開設置）|r"


    L["该攻略是按照25H去呈现，但由于暴雪数据库问题，部分技能链接里的描述文本并不符合25H的真实情况。请看技能的介绍文本"] = "該攻略是按照25H去呈現，但由於暴雪數據庫問題，部分技能鏈接裏的描述文本並不符合25H的真實情況。請看技能的介紹文本"
    L["|cffffffff< 角色5人本完成总览 >|r\n\n1、在队伍查找器旁边显示角色5人本完成总览"] = "|cffffffff< 角色5人本完成總覽 >|r\n\n1、在隊伍查找器旁邊顯示角色5人本完成總覽"
    L["显示角色5人本完成总览*"] = "顯示角色5人本完成總覽*"
    L["|cffffffff< 团本攻略字体大小 >|r|cff808080（右键还原设置）|r\n\n1、调整该字体的大小"] = "|cffffffff< 團本攻略字體大小 >|r|cff808080（右鍵還原設置）|r\n\n1、調整該字體的大小"
    L["团本攻略字体大小"] = "團本攻略字體大小"
    L["|cffffffff< 密语模板 >|r\n\n1、预设成就、装等、自定义文本，当你点击集结号活动密语时会自动添加该内容\n2、按住SHIFT+点击密语时不会添加"] = "|cffffffff< 密語模板 >|r\n\n1、預設成就、裝等、自定義文本，當你點擊集結號活動密語時會自動添加該內容\n2、按住SHIFT+點擊密語時不會添加"
    L["密语模板*"] = "密語模板*"
    L["< 历史搜索记录 >"] = "< 歷史搜索記錄 >"
    L["|cffFFFFFF左键：|r搜索该记录\n|cffFFFFFF右键：|r删除该记录"] = "|cffFFFFFF左鍵：|r搜索該記錄\n|cffFFFFFF右鍵：|r刪除該記錄"
    L["把搜索文本添加至历史记录"] = "把搜索文本添加至歷史記錄"
    L["密语模板"] = "密語模板"
    L["< 密语模板 >"] = "< 密語模板 >"
    L["成就"] = "成就"
    L["成就ID："] = "成就ID："
    L["成就ID参考"] = "成就ID參考"
    L["当前没有成就"] = "當前沒有成就"
    L["装等"] = "裝等"
    L["自定义文本"] = "自定義文本"
    L["自定义文本参考"] = "自定義文本參考"
    L["1、可以输入你的职业、天赋"] = "1、可以輸入你的職業、天賦"
    L["2、或你的经验、WCL分数等等"] = "2、或你的經驗、WCL分數等等"
    L["其他插件增强"] = "其他插件增強"


    L["|cffffffff< 按队伍人数排序 >|r\n\n1、集结号活动可以按队伍人数排序"] = "|cffffffff< 按隊伍人數排序 >|r\n\n1、集結號活動可以按隊伍人數排序"
    L["按队伍人数排序*"] = "按隊伍人數排序*"


    L["|cffFFFFFF左键：|r搜索该记录\n|cffFFFFFF右键：|r删除该记录"] = "|cffFFFFFF左鍵：|r搜索該記錄\n|cffFFFFFF右鍵：|r刪除該記錄"
    L["集结号"] = "集結號"
    L["|cffffffff< 历史搜索记录 >|r\n\n1、给集结号的搜索框增加一个历史搜索记录，提高你搜索的效率"] = "|cffffffff< 歷史搜索記錄 >|r\n\n1、給集結號的搜索框增加一個歷史搜索記錄，提高你搜索的效率"
    L["历史搜索记录*"] = "歷史搜索記錄*"
    L["|cffffffff< 不自动退出集结号频道 >|r\n\n1、这样你可以一直同步集结号的组队消息，让你随时打开集结号都能查看全部活动"] = "|cffffffff< 不自動退出集結號頻道 >|r\n\n1、這樣你可以一直同步集結號的組隊消息，讓你隨時打開集結號都能查看全部活動"
    L["不自动退出集结号频道*"] = "不自動退出集結號頻道*"


    L["|cffffffff< YY评价 >|cff808080（右键：开启/关闭该模块）|r|r\n\n1、你可以给YY频道做评价，帮助别人辨别该团好与坏\n2、你可以查询YY频道的大众评价\n3、聊天频道的YY号变为超链接，方便你复制该号码或查询大众评价\n4、替换集结号的评价框，击杀当前版本团本尾王后弹出\n"] = "|cffffffff< YY評價 >|cff808080（右鍵：開啟/關閉該模塊）|r|r\n\n1、你可以給YY頻道做評價，幫助別人辨別該團好與壞\n2、你可以查詢YY頻道的大眾評價\n3、聊天頻道的YY號變為超鏈接，方便你複製該號碼或查詢大眾評價\n4、替換集結號的評價框，擊殺當前版本團本尾王後彈出\n"
    L["模块开关"] = "模塊開關"
    L["开启"] = "開啟"
    L["关闭"] = "關閉"
    L["该模块已关闭。右键底部标签页开启"] = "該模塊已關閉。右鍵底部標籤頁開啟"
    L["< 历史搜索记录 >"] = "< 歷史搜索記錄 >"
    L["把搜索文本添加至历史记录"] = "把搜索文本添加至歷史記錄"


    L["团本攻略"] = "團本攻略"
    L["|cffffffff< 团本攻略 >|r\n\n1、了解BOSS技能和应对策略、职业职责\n"] = "|cffffffff< 團本攻略 >|r\n\n1、了解BOSS技能和應對策略、職業職責\n"
    L["查看该BOSS攻略"] = "查看該BOSS攻略"
    L["当前时光徽章不可用"] = "當前時光徽章不可用"
    L["< BOSS >"] = "< BOSS >"
    L["< 技能应对 >"] = "< 技能應對 >"
    L["< 职业职责 >"] = "< 職業職責 >"
    L["（SHIFT+点击技能可发送到聊天框）"] = "（SHIFT+點擊技能可發送到聊天框）"
    L["该BOSS攻略提供：@大树先生"] = "該BOSS攻略提供：@大樹先生"
    L["介绍："] = "介紹："
    L["应对："] = "應對："
    L["坦克预警"] = "坦克預警"
    L["输出预警"] = "輸出預警"
    L["治疗预警"] = "治療預警"
    L["英雄难度"] = "英雄難度"
    L["灭团技能"] = "滅團技能"
    L["重要"] = "重要"
    L["可打断技能"] = "可打斷技能"
    L["法术效果"] = "法術效果"
    L["诅咒"] = "詛咒"
    L["中毒"] = "中毒"
    L["疾病"] = "疾病"
    L["坦克职责"] = "坦克職責"
    L["治疗职责"] = "治療職責"
    L["输出职责"] = "輸出職責"
    L["近战职责"] = "近戰職責"
    L["远程职责"] = "遠程職責"
    L["该副本没有团本攻略"] = "該副本沒有團本攻略"


    L["< BiaoGe > 你的当前版本%s已过期，请更新插件"] = "< BiaoGe > 你的當前版本%s已過期，請更新插件"
    L["团长YY（根据聊天记录帮你生成）"] = "團長YY（根據聊天記錄幫你生成）"
    L["详细评价"] = "詳細評價"
    L["< 快速评价 >"] = "< 快速評價 >"
    L["恭喜你们击杀尾王！请给团长个评价吧！"] = "恭喜你們擊殺尾王！請給團長個評價吧！"
    L["YY号必填，填写数字"] = "YY號必填，填寫數字"
    L["评价:"] = "評價:"
    L["评价必填，默认中评"] = "評價必填，默認中評"
    L["必填"] = "必填"
    L["修改评价"] = "修改評價"
    L["详细评价"] = "詳細評價"
    L["好评"] = "好評"
    L["中评"] = "中評"
    L["差评"] = "差評"
    L["感谢你的评价：|cff%sYY%s，%s|r"] = "感謝你的評價：|cff%sYY%s，%s|r"
    L["保存"] = "保存"
    L["详细评价"] = "詳細評價"
    L["|cffffffff< 详细评价 >|r\n\n1、在金团表格里写详细评价"] = "|cffffffff< 詳細評價 >|r\n\n1、在金團表格裡寫詳細評價"
    L["|cffffffff< 修改评价 >|r\n\n1、该YY号已有评价，去金团表格里修改评价"] = "|cffffffff< 修改評價 >|r\n\n1、該YY號已有評價，去金團表格裡修改評價"
    L["退出"] = "退出"

    L["|cffffffff< 装备记录通知字体大小 >|r|cff808080（右键还原设置）|r\n\n1、调整该字体的大小"] = "|cffffffff< 裝備記錄通知字體大小 >|r|cff808080（右鍵還原設置）|r\n\n1、調整該字體的大小"
    L["装备记录通知字体大小*"] = "裝備記錄通知字體大小*"
    L["|cffffffff< 交易通知字体大小 >|r|cff808080（右键还原设置）|r\n\n1、调整该字体的大小"] = "|cffffffff< 交易通知字體大小 >|r|cff808080（右鍵還原設置）|r\n\n1、調整該字體的大小"
    L["交易通知字体大小*"] = "交易通知字體大小*"
    L["|cffffffff< 当前表格 >|r\n\n1、表格的核心功能都在这里"] = "|cffffffff< 當前表格 >|r\n\n1、表格的覈心功能都在這裡"
    L["当前表格"] = "當前表格"
    L["对账"] = "對賬"
    L["心愿清单"] = "心願清單"
    L["YY评价"] = "YY評價"
    L["团员插件版本"] = "團員插件版本"
    L["团员插件版本：%s"] = "團員插件版本：%s"

    L["当前时光徽章："] = "當前時光徽章："
    L["|cffFFFFFF左键：|r查询|cff00BFFFYY%s|r的大众评价\n|cffFFFFFFSHIFT+左键：|r复制该YY号"] = "|cffFFFFFF左鍵：|r查詢|cff00BFFFYY%s|r的大眾評價\n|cffFFFFFFSHIFT+左鍵：|r複製該YY號"
    L["通报至团队通知频道"] = "通報至團隊通知頻道"
    L["通报至团队频道"] = "通報至團隊頻道"
    L["|cffffffff< 拍卖倒数时长 >|r|cff808080（右键还原设置）|r\n\n1、拍卖装备倒数多久，默认是8秒"] = "|cffffffff< 拍賣倒數時長 >|r|cff808080（右鍵還原設置）|r\n\n1、拍賣裝備倒數多久，默認是8秒"
    L["拍卖倒数时长(秒)*"] = "拍賣倒數時長(秒)*"
    L["|cffffffff< 拍卖倒数 >|r\n\n1、该功能只有团长或物品分配者可用\n2、ALT+点击当前表格、背包、聊天框的装备，自动开始拍卖倒数\n3、背包目前支持原生背包、NDUI背包、EUI背包、大脚背包\n"] = "|cffffffff< 拍賣倒數 >|r\n\n1、該功能只有團長或物品分配者可用\n2、ALT+點擊當前表格、背包、聊天框的裝備，自動開始拍賣倒數\n3、背包目前支援原生背包、NDUI背包、EUI背包、大腳背包\n"
    L["拍卖倒数*"] = "拍賣倒數*"
    L["你已共享|r |cff00FF00%s|r |cffffffff人次评价"] = "你已共享|r |cff00FF00%s|r |cffffffff人次評價"
    L["{rt7}倒数暂停{rt7}"] = "{rt7}倒數暫停{rt7}"
    L[" {rt1}拍卖倒数"] = " {rt1}拍賣倒數"
    L["秒{rt1}"] = "秒{rt1}"

    L["（左键修改评价，SHIFT+左键查询大众评价，ALT+右键删除评价）"] = "（左鍵修改評價，SHIFT+左鍵查詢大眾評價，ALT+右鍵刪除評價）"
    L["|cffffffff< 共享我的评价 >   （你已共享|r |cff00FF00%s|r |cffffffff人次评价）|r\n\n1、当别人查询大众评价时，如果你有该YY的评价，则会以匿名的方式共享给对方\n2、如果你不开启该功能，则你的查询大众评价功能会被禁用，因为共享是相互的\n3、开启该功能后，会使聊天记录里的YY号变为超链接\n4、没满级的角色会被禁止共享和使用查询大众评价"] = "|cffffffff< 共享我的評價 >   （你已共享|r |cff00FF00%s|r |cffffffff人次評價）|r\n\n1、當別人查詢大眾評價時，如果你有該YY的評價，則會以匿名的方式共享給對方\n2、如果你不開啟該功能，則你的查詢大眾評價功能會被禁用，因為共享是相互的\n3、開啟該功能後，會使聊天記錄裡的YY號變為超鏈接\n4、沒滿級的角色會被禁止共享和使用查詢大眾評價"
    L["金币已超上限！"] = "金幣已超上限！"

    L["|cffffffff< YY评价 >|r\n\n1、你可以查询某个YY的评价如何\n2、降低你进入坑团的可能\n"] = L["|cffffffff< YY評價 >|r\n\n1、你可以查詢某個YY的評價如何\n2、降低你進入坑團的可能\n"]
    L["< 新增评价 >"] = L["< 新增評價 >"]
    L["YY号必填，填写数字"] = L["YY號必填，填寫數字"]
    L["频道名称:"] = L["頻道名稱:"]
    L["频道名称选填，方便自己辨认是哪个YY\n该名称不会共享给别人，仅自己可见"] = L["頻道名稱選填，方便自己辨認是哪個YY\n該名稱不會共享給別人，僅自己可見"]
    L["评价:"] = L["評價:"]
    L["评价必填，默认中评"] = L["評價必填，默認中評"]
    L["理由:"] = L["理由:"]
    L["理由选填"] = L["理由選填"]
    L["必填"] = L["必填"]
    L["选填"] = L["選填"]
    L["好评"] = L["好評"]
    L["中评"] = L["中評"]
    L["差评"] = L["差評"]
    L["好评或差评需要填写不少于6字"] = L["好評或差評需要填寫不少於6字"]
    L["保存评价"] = L["保存評價"]
    L["|cffffffff< 保存评价 >|r\n\n1、必填项填完才能保存\n2、同一个YY只能写一次评价，但你可以修改之前的评价"] = L["|cffffffff< 保存評價 >|r\n\n1、必填項填完才能保存\n2、同一個YY只能寫一次評價，但你可以修改之前的評價"]
    L["退出修改"] = L["退出修改"]
    L["该YY已有评价，需要修改吗？"] = L["該YY已有評價，需要修改嗎？"]
    L["< 我的评价 >"] = L["< 我的評價 >"]
    L["序号"] = L["序號"]
    L["日期"] = L["日期"]
    L["YY"] = L["YY"]
    L["频道名称"] = L["頻道名稱"]
    L["评价"] = L["評價"]
    L["理由"] = L["理由"]
    L["正在初始化"] = L["正在初始化"]
    L["|cffffffff< 共享我的评价 >   （你已共享|r |cff00FF00%s|r |cffffffff人次评价）|r\n\n1、当别人查询大众评价时，如果你有该YY的评价，则会以匿名的方式共享给对方\n2、如果你不开启该功能，则你的查询大众评价功能会被禁用，所以共享是相互的\n3、没满级的角色会被禁止共享和使用查询大众评价"] = L["|cffffffff< 共享我的評價 >   （你已共享|r |cff00FF00%s|r |cffffffff人次評價）|r\n\n1、當別人查詢大眾評價時，如果你有該YY的評價，則會以匿名的方式共享給對方\n2、如果你不開啟該功能，則你的查詢大眾評價功能會被禁用，所以共享是相互的\n3、沒滿級的角色會被禁止共享和使用查詢大眾評價"]
    L["理由"] = L["理由"]
    L["好评"] = L["好評"]
    L["中评"] = L["中評"]
    L["差评"] = L["差評"]
    L["< 新增评价 >"] = L["< 新增評價 >"]
    L["保存评价"] = L["保存評價"]
    L["< 修改评价 >"] = L["< 修改評價 >"]
    L["保存修改"] = L["保存修改"]
    L["（左键修改评价，SHIFT+左键把yy号发到查询里，ALT+右键删除评价）"] = L["（左鍵修改評價，SHIFT+左鍵把yy號發到查詢裡，ALT+右鍵刪除評㓂）"]
    L["< 查询大众评价 >"] = L["< 查詢大眾評價 >"]
    L["查询成功：YY%s的评价|cffFFFFFF一共%s个|r。|cff00FF00好评%s个|r，|cffFFFF00中评%s个|r，|cffDC143C差评%s个|r"] = L["查詢成功：YY%s的評價|cffFFFFFF一共%s個|r，|cff00FF00好評%s個|r，|cffFFFF00中評%s個|r，|cffDC143C差評%s個|r"]
    L["查询成功！CD"] = L["查詢成功！CD"]
    L["查询"] = L["查詢"]
    L["无"] = L["無"]
    L["查询失败：没有找到YY%s的评价"] = L["查詢失敗：沒有找到YY%s的評價"]
    L["查询中 "] = L["查詢中 "]
    L["个)|r"] = L["個)|r"]
    L["无"] = L["無"]
    L["无"] = L["無"]
    L["无"] = L["無"]
    L["历史查询："] = L["歷史查詢："]
    L["筛选："] = L["篩選："]
    L["全部"] = L["全部"]
    L["好评"] = L["好評"]
    L["中评"] = L["中評"]
    L["差评"] = L["差評"]
    L[" (0个)"] = L[" (0個)"]
    L["无"] = L["無"]
    L["序号"] = L["序號"]
    L["日期"] = L["日期"]
    L["YY"] = L["YY"]
    L["评价"] = L["評價"]
    L["理由"] = L["理由"]
    L["理由"] = L["理由"]
    L["个"] = L["個"]
    L["个"] = L["個"]
    L["查询"] = L["查詢"]
    L["共享我的评价"] = L["共享我的評價"]
    L["查询"] = L["查詢"]
    L["共享我的评价"] = L["共享我的評價"]
    L["共享我的评价"] = L["共享我的評價"]
    L["查询"] = L["查詢"]

    L["< BiaoGe > 金 团 表 格"] = "< BiaoGe > 金 團 表 格"
    L["|cff808080（带的设置为即时生效，否则需要重载才能生效）|r"] = "|cff808080（帶的設置為即時生效，否則需要重載才能生效）|r"
    L["重载界面"] = RELOADUI
    L["不能即时生效的设置在重载后生效"] = "不能即時生效的設置在重載後生效"
    L["表格"] = "表格"
    L["角色总览"] = "角色總覽"
    L["|cffffffff< UI缩放 >|r|cff808080（右键还原设置）|r\n\n1、调整表格UI的大小"] = "|cffffffff< UI縮放 >|r|cff808080（右鍵還原設置）|r\n\n1、調整表格UI的大小"
    L["UI缩放*"] = "UI縮放*"
    L["|cffffffff< UI透明度 >|r|cff808080（右键还原设置）|r\n\n1、调整表格UI的透明度"] = "|cffffffff< UI透明度 >|r|cff808080（右鍵還原設置）|r\n\n1、調整表格UI的透明度"
    L["UI透明度*"] = "UI透明度*"
    L["|cffffffff< 自动记录装备 >|r\n\n1、在团本里拾取装备时，会自动记录进表格\n2、只会记录橙装、紫装、和蓝色的宝珠，不会记录图纸，小怪掉落会记录到杂项里\n"] = "|cffffffff< 自動記錄裝備 >|r\n\n1、在團本裡拾取裝備時，會自動記錄進表格\n2、只會記錄橙裝、紫裝、和藍色的寶珠，不會記錄圖紙，小怪掉落會記錄到雜項裡\n"
    L["自动记录装备*"] = "自動記錄裝備*"
    L["|cffffffff< 装备记录通知时长 >|r|cff808080（右键还原设置）|r\n\n1、自动记录装备后会在屏幕上方通知记录结果"] = "|cffffffff< 裝備記錄通知時長 >|r|cff808080（右鍵還原設置）|r\n\n1、自動記錄裝備後會在螢幕上方通知記錄結果"
    L["装备记录通知时长(秒)"] = "裝備記錄通知時長(秒)"
    L["|cffffffff< 交易自动记账 >|r\n\n1、需要配合自动记录装备，因为如果表格里没有该交易的装备，则记账失败\n2、如果一次交易两件装备以上，则只会记第一件装备\n"] = "|cffffffff< 交易自動記賬 >|r\n\n1、需要配合自動記錄裝備，因為如果表格裡沒有該交易的裝備，則記賬失敗\n2、如果一次交易兩件裝備以上，則只會記第一件裝備\n"
    L["交易自动记账*"] = "交易自動記賬*"
    L["|cffffffff< 交易通知时长 >|r|cff808080（右键还原设置）|r\n\n1、通知显示多久"] = "|cffffffff< 交易通知時長 >|r|cff808080（右鍵還原設置）|r\n\n1、通知顯示多久"
    L["交易通知时长(秒)"] = "交易通知時長(秒)"
    L["|cffffffff< 交易通知 >|r\n\n1、交易完成后会在屏幕中央通知本次记账结果\n"] = "|cffffffff< 交易通知 >|r\n\n1、交易完成後會在螢幕中央通知本次記賬結果\n"
    L["交易通知*"] = "交易通知*"
    L["|cffffffff< 记账效果预览框 >|r\n\n1、交易的时候，可以预览这次的记账效果\n2、如果这次交易的装备不在表格，则可以选择强制记账"] = "|cffffffff< 記賬效果預覽框 >|r\n\n1、交易的時候，可以預覽這次的記賬效果\n2、如果這次交易的裝備不在表格，則可以選擇強制記賬"
    L["记账效果预览框*"] = "記賬效果預覽框*"
    L["|cffffffff< 高亮拍卖装备 >|r\n\n1、当团长或物品分配者贴出装备开始拍卖时，会自动高亮表格里相应的装备"] = "|cffffffff< 高亮拍賣裝備 >|r\n\n1、當團長或物品分配者貼出裝備開始拍賣時，會自動高亮表格里相應的裝備"
    L["高亮拍卖装备*"] = "高亮拍賣裝備*"
    L["|cffffffff< 高亮拍卖装备时长 >|r|cff808080（右键还原设置）|r\n\n1、高亮拍卖装备多久"] = "|cffffffff< 高亮拍賣裝備時長 >|r|cff808080（右鍵還原設置）|r\n\n1、高亮拍賣裝備多久"
    L["高亮拍卖装备时长(秒)*"] = "高亮拍賣裝備時長(秒)*"
    L["|cffffffff< 拍卖聊天记录框 >|r\n\n1、自动记录全团跟拍卖有关的聊天\n2、当你点击买家或金额时会显示拍卖聊天记录"] = "|cffffffff< 拍賣聊天記錄框 >|r\n\n1、自動記錄全團跟拍賣有關的聊天\n2、當你點擊買家或金額時會顯示拍賣聊天記錄"
    L["拍卖聊天记录框*"] = "拍賣聊天記錄框*"
    L["|cffffffff< 金额自动加零 >|r\n\n1、输入金额和欠款时自动加两个0，减少记账操作，提高记账效率"] = "|cffffffff< 金額自動加零 >|r\n\n1、輸入金額和欠款時自動加兩個0，減少記賬操作，提高記賬效率"
    L["金额自动加零*"] = "金額自動加零*"
    L["|cffffffff< 对账单保存时长(小时) >|r|cff808080（右键还原设置）|r\n\n1、对账单保存多久后自动删除"] = "|cffffffff< 對賬單保存時長(小時) >|r|cff808080（右鍵還原設置）|r\n\n1、對賬單保存多久後自動刪除"
    L["对账单保存时长(小时)"] = "對賬單保存時長(小時)"
    L["|cffffffff< 进本提示清空表格 >|r\n\n1、每次进入副本都会提示清空表格"] = "|cffffffff< 進本提示清空表格 >|r\n\n1、每次進入副本都會提示清空表格"
    L["进本提示清空表格*"] = "進本提示清空表格*"
    L["|cffffffff< 按键交互声音 >|r\n\n1、点击按钮时的声音"] = "|cffffffff< 按鍵交互聲音 >|r\n\n1、點擊按鈕時的聲音"
    L["按键交互声音*"] = "按鍵交互聲音*"
    L["|cffffffff< 小地图图标 >|r\n\n1、显示小地图图标"] = "|cffffffff< 小地圖圖示 >|r\n\n1、顯示小地圖圖示"
    L["小地图图标*"] = "小地圖圖示*"
    L["人"] = "人"
    L["删除角色"] = "刪除角色"
    L["删除角色"] = "刪除角色"
    L["总览数据"] = "總覽數據"
    L["巫妖王之怒*"] = "巫妖王之怒*"
    L["燃烧的远征*"] = "燃燒的遠征*"
    L["经典旧世*"] = "經典舊世*"
    L["货币*"] = "貨幣*"
    L["|cffffffff< 清空表格时根据副本难度设置分钱人数 >|r\n\n1、10人团本默认分钱人数为10人\n2、25人团本默认分钱人数为25人"] = "|cffffffff< 清空表格時根據副本難度設置分錢人數 >|r\n\n1、10人團本默認分錢人數為10人\n2、25人團本默認分錢人數為25人"
    L["清空表格时根据副本难度设置分钱人数*"] = "清空表格時根據副本難度設置分錢人數*"
    L["|cffFFFFFF10人团本分钱人数：|r"] = "|cffFFFFFF10人團本分錢人數：|r"
    L["|cffFFFFFF25人团本分钱人数：|r"] = "|cffFFFFFF25人團本分錢人數：|r"
    L["快捷命令：/BGO"] = "快捷命令：/BGO"
    L["|cffffffff< 清空表格时保留支出补贴名称 >|r\n\n1、只保留补贴名称（例如XX补贴），支出玩家和支出金额正常清空\n2、这样就不用每次都重复填写补贴名称\n3、只有补贴名称，但没有补贴金额的，在通报账单时不会被通报"] = "|cffffffff< 清空表格時保留支出補貼名稱 >|r\n\n1、只保留補貼名稱（例如XX補貼），支出玩家和支出金額正常清空\n2、這樣就不用每次都重複填寫補貼名稱\n3、只有補貼名稱，但沒有補貼金額的，在通報賬單時不會被通報"
    L["清空表格时保留支出补贴名称*"] = "清空表格時保留支出補貼名稱*"

    L["< BiaoGe > 金 团 表 格"] = "< BiaoGe > 金 團 表 格"
    L["<说明书与更新记录> "] = "<說明書與更新記錄> "
    L["保存至历史表格"] = "保存至歷史表格"
    L["该表格已在你历史表格里"] = "該表格已在你歷史表格裡"
    L["历史表格（共%d个）"] = "歷史表格(共%d個)"
    L["已保存至历史表格1"] = "已保存至歷史表格1"
    L["设置"] = "設置"
    L["当前难度:"] = "當前難度:"
    L["切换副本难度"] = "切換副本難度"
    L["10人|cff00BFFF普通|r"] = "10人|cff00BFFF普通|r"
    L["25人|cff00BFFF普通|r"] = "25人|cff00BFFF普通|r"
    L["10人|cffFF0000英雄|r"] = "10人|cffFF0000英雄|r"
    L["25人|cffFF0000英雄|r"] = "25人|cffFF0000英雄|r"
    L["确认切换难度为< %s >？"] = "確認切換難度為< %s >?"
    L["是"] = "是"
    L["否"] = "否"
    L["心愿清单"] = "心願清單"
    L["清空当前表格"] = "清空當前表格"
    L["关闭心愿清单"] = "關閉心願清單"
    L["清空当前心愿"] = "清空當前心願"
    L["对账"] = "對賬"
    L["关闭对账"] = "關閉對賬"
    L["要清空表格< %s >吗？"] = "要清空表格< %s >嗎？"
    L["角色"] = "角色"
    L["黑龙"] = "黑龍"
    L["宝库"] = "寶庫"
    L["赛德精华"] = "恆星精華"
    L["金币"] = "金幣"
    L["< 角色团本完成总览 >"] = "< 角色團本完成總覽 >"
    L["（团本重置时间：%s）"] = "(團本重置時間: %s)"
    L["当前没有符合的角色"] = "當前沒有符合的角色"
    L["（右键删除角色总览数据）"] = "(右鍵刪除角色總覽數據)"
    L["（插件右下角右键可删除数据）"] = "(插件右下角右鍵可刪除數據)"
    L["< 角色货币总览 >"] = "< 角色貨幣總覽 >"
    L["金"] = "金"
    L["合计"] = "合計"
    L["删除角色"] = "刪除角色"
    L["总览数据"] = "總覽數據"
    L["你关注的装备开始拍卖了：%s（右键取消关注）"] = "你關注的裝備開始拍賣了: %s(右鍵取消關注)"
    L["已成功关注装备：%s。团长拍卖此装备时会提醒"] = "已成功關注裝備: %s. 團長拍賣此裝備時會提醒"
    L["<自动记录装备>"] = "<自動記錄裝備>"
    L["已取消关注装备：%s"] = "已取消關注裝備: %s"
    L["你的心愿达成啦！！！>>>>> %s(%s) <<<<<"] = "你的心願達成啦!!!>>>>> %s(%s) <<<<<"
    L["已自动记入表格：%s%s(%s) x%d => %s< %s >%s"] = "已自動記入表格: %s%s(%s) x%d => %s< %s >%s"
    L["自动关注心愿装备：%s%s。团长拍卖此装备时会提醒"] = "自動關注心願裝備: %s%s。團長拍賣此裝備時會提醒"
    L["自动记录失败：%s%s(%s)。因为%s< %s >%s的格子满了。。"] = "自動記錄失敗: %s%s(%s)。因為%s< %s >%s的格子滿了..."
    L["自动关注心愿装备失败：%s%s"] = "自動關注心願裝備失敗：%s%s"
    L["已自动记入表格：%s%s(%s) => %s< %s >%s"] = "已自動記入表格：%s%s(%s) => %s< %s >%s"
    L["< 交易记账失败 >"] = "< 交易記賬失敗 >"
    L["双方都给了装备，但没金额"] = "雙方都給了裝備, 但沒金額"
    L["我不知道谁才是买家"] = "我不知道誰才是買家"
    L["如果有金额我就能识别了"] = "如果有金額我就能識別了"
    L["（欠款%d）"] = "（欠款%d）"
    L["< 交易记账成功 >"] = "< 交易記賬成功 >"
    L["< 交易记账成功 >|r\n装备：%s\n买家：%s\n金额：%s%d|rg%s\nBOSS：%s< %s >|r"] = "< 交易記賬成功 >|r\n裝備: %s\n買家: %s\n金額: %s%d|rg%s\nBOSS: %s< %s >|r"
    L["表格里没找到此次交易的装备"] = "表格裡沒找到此次交易的裝備"
    L["该BOSS格子已满"] = "該BOSS格子已滿"
    L["欠款："] = "欠款: "
    L["记账效果预览"] = "記賬效果預覽"
    L["无"] = "無"
    L["<交易自动记账>"] = "<交易自動記賬>"
    L["次"] = "次"
    L["打断"] = "打斷"
    L["级"] = "級"
    L["装等"] = "裝等"
    L["分钟"] = "分鐘"
    L["时间"] = "時間"
    L["已清空表格< %s >，分钱人数已改为%d人"] = "已清空表格< %s >，分錢人數已改為%d人"
    L["已清空表格< %s >"] = "已清空表格< %s >"
    L["已清空心愿< %s >"] = "已清空心願< %s >"
    L["确认清空表格< %s >？"] = "確認清空表格< %s >？"
    L["高亮该天赋的装备"] = "高亮該天賦的裝備"
    L["<金额自动加零>"] = "<金額自動加零>"
    L["<UI缩放>"] = "<UI縮放>"
    L["<UI透明度>"] = "<UI透明度>"
    L["< BiaoGe > 版本过期提醒，最新版本是：%s，你的当前版本是：%s"] = "< BiaoGe > 版本過期提醒, 最新版本是: %s, 你的當前版本是: %s"
    L["你可以前往curseforge搜索biaoge更新"] = "你可以前往curseforge搜索biaoge更新"
    L["< BiaoGe > 金团表格载入成功。插件命令：%s或%s，小地图图标：%s"] = "< BiaoGe > 金團表格載入成功. 插件命令: %s或%s, 小地圖圖標: %s"
    L["星星"] = "星星"
    L["BiaoGe金团表格"] = "BiaoGe金團表格"
    L["显示/关闭表格"] = "顯示/關閉表格"
    L["对比的账单："] = "對比的賬單："
    L["  项目"] = "  項目"
    L["装备"] = "裝備"
    L["我的金额"] = "我的金額"
    L["对方金额"] = "對方金額"
    L["装备总收入"] = "裝備總收入"
    L["差额"] = "差額"
    L["买家"] = "買家"
    L["金额"] = "金額"
    L["关注"] = "關注"
    L["关注中，团长拍卖此装备会提醒"] = "關注中, 團長拍賣此裝備會提醒"
    L["右键取消关注"] = "右鍵取消關注"
    L["欠款：%s|r\n右键清除欠款"] = "欠款: %s|r\n右鍵清除欠款"
    L["坦克补贴"] = "坦克補貼"
    L["治疗补贴"] = "治療補貼"
    L["输出补贴"] = "輸出補貼"
    L["放鱼补贴"] = "放魚補貼"
    L["人数可自行修改"] = "人數可自行修改"
    L["（ALT+点击可设置为已掉落，SHIFT+点击可发送装备，CTRL+点击可通报历史价格）"] = "(ALT+點擊可設置為已掉落, SHIFT+點擊可發送裝備, CTRL+點擊可通報歷史價格)"
    L["（ALT+点击可关注装备，SHIFT+点击可发送装备，CTRL+点击可通报历史价格）"] = "(ALT+點擊可關注裝備, SHIFT+點擊可發送裝備, CTRL+點擊可通報歷史價格)"
    L["欠款金额"] = "欠款金額"
    L["不在团队，无法通报"] = "不在團隊, 無法通報"
    L["———通报历史价格———"] = "———通報歷史價格———"
    L["装备：%s(%s)"] = "裝備: %s(%s)"
    L["月"] = "月"
    L["日"] = "日"
    L["，价格:"] = ", 價格:"
    L["，买家:"] = ", 買家:"
    L["取消交换"] = "取消交換"
    L["你正在交换该行全部内容"] = "你正在交換該行全部內容"
    L["\n点击取消交换"] = "\n點擊取消交換"
    L["交换成功"] = "交換成功"
    L["（ALT+左键改名，ALT+右键删除表格）"] = "(ALT+左鍵改名, ALT+右鍵刪除表格)"
    L["保存表格"] = "保存表格"
    L["把当前表格保存至历史表格\n但不会保存欠款和关注"] = "把當前表格保存至歷史表格\n但不會保存欠款和關注"
    L["%m月%d日%H:%M:%S\n"] = "%m月%d日%H:%M:%S\n"
    L["%s %s %s人 工资:%s"] = "%s %s %s人 薪水: %s"
    L["分享表格"] = "分享表格"
    L["把当前表格发给别人，类似发WA那样"] = "把當前表格發給別人, 類似發WA那樣"
    L["当前表格-"] = "當前表格-"
    L["历史表格-"] = "歷史表格-"
    L["导出表格"] = "導出表格"
    L["把表格导出为文本"] = "把表格導出為文本"
    L["应用表格"] = "應用表格"
    L["把该历史表格复制粘贴到当前表格，这样你可以编辑内容"] = "把該歷史表格複製粘貼到當前表格, 這樣你可以編輯內容"
    L["确定应用表格？\n你当前的表格将被"] = "確定應用表格? \n你當前的表格將被"
    L[" 替换 "] = " 替換 "
    L["当前名字："] = "當前名字: "
    L["名字改为："] = "名字改為: "
    L["确定"] = "確定"
    L["取消"] = "取消"
    L["（CTRL+点击可通报历史价格）"] = "(CTRL+點擊可通報歷史價格)"
    L["< 历史表格 > "] = "< 歷史表格 > "
    L["你正在改名第 %s 个表格"] = "你正在改名第 %s 個表格"
    L["< |cffFFFFFF10人|r|cff00BFFF普通|r >"] = "< |cffFFFFFF10人|r|cff00BFFF普通|r >"
    L["< |cffFFFFFF25人|r|cff00BFFF普通|r >"] = "< |cffFFFFFF25人|r|cff00BFFF普通|r >"
    L["< |cffFFFFFF10人|r|cffFF0000英雄|r >"] = "< |cffFFFFFF10人|r|cffFF0000英雄|r >"
    L["< |cffFFFFFF25人|r|cffFF0000英雄|r >"] = "< |cffFFFFFF25人|r|cffFF0000英雄|r >"
    L["心愿1"] = "心願1"
    L["心愿2"] = "心願2"
    L["已掉落"] = "已掉落"
    L["恭喜你，该装备已掉落"] = "<恭喜你，該裝備已掉落>"
    L["\n右键取消提示"] = "<\n右鍵取消提示>"
    L["当前团队还有 %s 人也许愿该装备！"] = "當前團隊還有 %s 人也許願該裝備! "
    L["查询心愿竞争"] = "<查詢心願競爭>"
    L["查询团队里，有多少人许愿跟你相同的装备"] = "查詢團隊裡, 有多少人許願跟你相同的裝備"
    L["不在团队，无法查询"] = "不在團隊, 無法查詢"
    L["恭喜你，当前团队没人许愿跟你相同的装备"] = "恭喜你, 當前團隊沒人許願跟你相同的裝備"
    L["分享心愿10PT"] = "<分享心願10PT>"
    L["分享心愿25PT"] = "<分享心願25PT>"
    L["分享心愿10H"] = "<分享心願10H>"
    L["分享心愿25H"] = "<分享心願25H>"
    L["< 我 的 心 愿 >"] = "< 我 的 心 願 >"
    L["副本难度："] = "副本難度: "
    L["频道：团队"] = "頻道: 團隊"
    L["频道：队伍"] = "頻道: 隊伍"
    L["不在队伍，无法通报"] = "不在隊伍, 無法通報"
    L["频道：公会"] = "頻道: 公會"
    L["没有公会，无法通报"] = "沒有公會, 無法通報"
    L["频道：密语"] = "頻道: 密語"
    L["没有目标，无法通报"] = "沒有目標, 無法通報"
    L["————我的心愿————"] = "————我的心願————"
    L["——感谢使用金团表格——"] = "——感謝使用金團表格——"
    L["队伍"] = "隊伍"
    L["公会"] = "公會"
    L["团队"] = "團隊"
    L["密语目标"] = "密語目標"
    L["心愿清单："] = "心願清單: "
    L["心愿装备只要掉落就会有提醒，并且掉落后自动关注团长拍卖"] = "心願裝備只要掉落就會有提醒, 且掉落後自動關注團長拍賣"
    L["你今天的运气指数(1-100)："] = "你今天的運氣指數(1-100): "
    L["当前表格"] = "當前表格"
    L["历史表格"] = "歷史表格"
    L["（当前为自动显示)"] = "(當前為自動顯示)"
    L["<BiaoGe>金团表格"] = "<BiaoGe>金團表格"
    L["左键：|r打开表格"] = "左鍵: |r打開表格"
    L["中键：|r切换自动显示角色总览"] = "中鍵: |r切換自動顯示角色總覽"
    L["（当前为不自动显示)"] = "(當前為不自動顯示)"
    L["通报流拍"] = "通報流拍"
    L["< 流 拍 装 备 >"] = "< 流 拍 裝 備 >"
    L["通报欠款"] = "通報欠款"
    L["< 通 报 欠 款 >"] = "< 通 報 欠 款 >"
    L["< 合 计 欠 款 >"] = "< 合 計 欠 款 >"
    L["没记买家"] = "未記錄買家"
    L["合计欠款："] = "合計欠款"
    L["————通报欠款————"] = "————通報欠款————"
    L["{rt7} 合计欠款 {rt7}"] = "{rt7} 合計欠款 {rt7}"
    L[" 合计欠款："] = " 合計欠款: "
    L["没有WCL记录"] = "沒有WCL記錄"
    L["读取不到数据，你可能没安装或者没打开WCL插件"] = "未能讀取數據, 你可能沒有安裝或打開WCL插件"
    L["更新时间："] = "更新時間: "
    L["< WCL分数 >"] = "< WCL分數 >"
    L["———通报WCL分数———"] = "———通報WCL分數———"
    L["通报WCL"] = "通報WCL"
    L["通报消费"] = "通報消費"
    L["< 消 费 排 名 >"] = "< 消 費 排 名 >"
    L["———通报消费排名———"] = "———通報消費排名———"
    L["< 通报击杀用时 >"] = "< 通報擊殺用時 >"
    L["———通报击杀用时———"] = "———通報擊殺用時———"
    L["分"] = "分"
    L["秒"] = "秒"
    L["击杀用时："] = "擊殺用時: "
    L["通报账单"] = "通報賬單"
    L["< 收  入 >"] = "< 收  入 >"
    L["Boss："] = "Boss: "
    L["项目："] = "項目: "
    L["< 支  出 >"] = "< 支  出 >"
    L["< 总  览 >"] = "< 總  覽 >"
    L["< 工  资 >"] = "< 薪    水  >"
    L["———通报金团账单———"] = "———通報金團賬單———"
    L["< 收 {rt1} 入 >"] = "< 收 {rt1} 入 >"
    L["< 支 {rt4} 出 >"] = "< 支 {rt4} 出 >"
    L["< 总 {rt3} 览 >"] = "< 總 {rt3} 覽 >"
    L["人"] = "人"
    L["< 工 {rt6} 资 >"] = "< 薪 {rt6} 水 >"
    L["|cffffffff< 心愿清单 >|r\n\n1、你可以设置一些装备，\n    这些装备只要掉落就会有提醒，\n    并且掉落后自动关注团长拍卖\n"] = "|cffffffff< 心願清單 >|r\n\n1、你可以設置一些裝備, \n    這些裝備只要掉落就會有提醒, \n    並且掉落後自動關注團長拍賣\n"
    L["|cffffffff< 自动记录装备 >|r\n\n1、只会记录紫装和橙装\n2、橙片、飞机头、小怪掉落\n    会存到杂项里\n3、图纸不会自动保存\n"] = "|cffffffff< 自動記錄裝備 >|r\n\n1、只會記錄紫裝和橙裝\n2、橙片、飛機頭、小怪掉落\n    會存到雜項裡\n3、圖紙不會自動保存\n"
    L["|cffffffff< 对账 >|r\n\n1、当团队有人通报BiaoGe/RaidLedger/大脚的账单，\n    你可以选择该账单，来对账\n2、只对比装备收入，不对比罚款收入，也不对比支出\n3、别人账单会自动保存1天，过后自动删除\n"] = "|cffffffff< 對賬 >|r\n\n1、當團隊有人通報BiaoGe/RaidLedger/大腳的賬單, \n    你可以選擇該賬單, 來對賬\n2、只對比裝備收入, 不對比罰款收入, 也不對比支出\n3、別人賬單會自動保存1天, 過後自動刪除\n"
    L["|cffffffff< 交易自动记账 >|r\n\n1、需要配合自动记录装备，因为\n    如果表格里没有该交易的装备，\n    则记账失败\n2、如果一次交易两件装备以上，\n    则只会记第一件装备，\n"] = "|cffffffff< 交易自動記賬 >|r\n\n1、需要配合自動記錄裝備, 因為\n    如果表格裡沒有該交易的裝備, \n    則記賬失敗\n2、如果一次交易兩件裝備以上, \n    則只會記第一件裝備, \n"
    L["|cffffffff< 清空当前表格/心愿 >|r\n\n1、表格界面时一键清空装备、买家、金额，同时还清空关注和欠款\n2、心愿界面时一键清空全部心愿装备\n"] = "|cffffffff< 清空當前表格/心願 >|r\n\n1、表格界面時一鍵清空裝備、買家、金額, 同時還清空關注和欠款\n2、心願界面時一鍵清空全部心願裝備\n"
    L["|cffffffff< 金额自动加零 >|r\n\n1、输入金额和欠款时自动加两个0\n    减少记账操作，提高记账效率\n"] = "|cffffffff< 金額自動加零 >|r\n\n1、輸入金額和欠款時自動加兩個0\n    減少記賬操作, 提高記賬效率\n"
    L["通报金团账单"] = "通報金團賬單"
    L["RaidLedger:.... 收入 ...."] = "RaidLedger:.... 收入 ...."
    L["事件：.-|c.-|Hitem.-|h|r"] = "事件：.-|c.-|Hitem.-|h|r"
    L["(%d+)金"] = "(%d+)金"
    L["收入为："] = "收入為: "
    L["收入为：%d+。"] = "收入為: %d+."
    L["平均每人收入:"] = "平均每人收入:"
    L["感谢使用金团表格"] = "感謝使用金團表格"
    L["，装备总收入:"] = ", 裝備總收入:"
    L["-感谢使用大脚金团辅助工具-"] = "-感謝使用大腳金團輔助工具-"
    L["总收入"] = "總收入"
    L["总支出"] = "總支出"
    L["净收入"] = "淨收入"
    L["分钱人数"] = "分錢人數"
    L["人均工资"] = "人均薪水"
    L["历史价格：%s%s(%s)"] = "歷史價格: %s%s(%s)"
    L["通报用时"] = "通報用時"
    L["返回表格"] = "返回表格"
    L["当前"] = "當前"
    L["没有金额"] = "沒有金額"
    L["———通报流拍装备———"] = "———通報流拍裝備———"
    L["欠"] = "欠"
    L["人"] = "人"
    L["< 角色总览设置 >"] = "< 角色總覽設置 >"
    L["删除角色"] = "刪除角色"
    L["巫妖王之怒"] = "巫妖王之怒"
    L["燃烧的远征"] = "燃燒的遠征"
    L["经典旧世"] = "經典舊世"
    L["货币"] = "貨幣"
    L["角色"] = "角色"
    L["（右键打开设置）"] = "(右鍵打開設置)"
    L["< 角色货币总览 >"] = "< 角色貨幣總覽 >"
    L["中键：|r切换自动显示角色总览"] = "中鍵：|r切換自動顯示角色總覽"
    L["右键：|r打开设置"] = "右鍵：|r打開設置"
    L[" （测试） "] = " （測試） "
    L["通知锁定"] = "通知鎖定"
    L["通知移动"] = "通知移動"
    L["调整装备记录通知和交易通知的位置\n快捷命令：/BGM"] = "調整裝備記錄通知和交易通知的位置\n快捷命令：/BGM"
    L["|cffFF0000（欠款2000）|r"] = "|cffFF0000（欠款2000）|r"
    L["装备记录通知"] = "裝備記錄通知"
    L["交易通知"] = "交易通知"
	
	-- 自行加入
	L["BiaoGe"] = "金團表格"
end







-- BOSS名字
do
    L["你\n漏\n记\n的\n装\n备"] = "你\n漏\n記\n的\n裝\n備"
    L["总\n结"] = "總\n結"
    L["工\n资"] = "薪\n水"
    L["杂\n\n项"] = "雜\n\n項"
    L["罚\n\n款"] = "罰\n\n款"
    L["支\n\n出"] = "支\n\n出"
    L["总\n览"] = "總\n覽"

    L["玛\n洛\n加\n尔"] = "瑪\n洛\n嘉\n領\n主"
    L["亡\n语\n者\n女\n士"] = "亡\n語\n女\n士"
    L["炮\n舰\n战"] = "炮\n艇\n戰"
    L["萨\n鲁\n法\n尔"] = "薩\n魯\n法\n爾"
    L["烂\n肠"] = "濃\n腸"
    L["腐\n面"] = "腐\n臉"
    L["普\n崔\n塞\n德\n教\n授"] = "普\n崔\n希\n德\n教\n授"
    L["鲜\n血\n议\n会"] = "血\n親\n王\n議\n會"
    L["鲜\n血\n女\n王"] = "鮮\n血\n女\n王"
    L["踏\n梦\n者"] = "夢\n行\n者"
    L["辛\n达\n苟\n萨"] = "辛\n德\n拉\n苟\n撒"
    L["巫\n妖\n王"] = "巫\n妖\n王"
    L["海\n里\n昂"] = "海\n萊\n恩"

    L["诺\n森\n德\n猛\n兽"] = "北\n裂\n境\n巨\n獸"
    L["加\n拉\n克\n苏\n斯"] = "賈\n拉\n克\n瑟\n斯\n領\n主"
    L["阵\n营\n冠\n军"] = "陣\n營\n勇\n士"
    L["瓦\n克\n里\n双\n子"] = "華\n爾\n其\n雙\n子"
    L["阿\n努\n巴\n拉\n克"] = "阿\n努\n巴\n拉\n克"
    L["嘉\n奖\n宝\n箱"] = "銀\n白\n十\n字\n獻\n禮\n箱"
    L["奥\n妮\n克\n希\n亚"] = "奧\n妮\n克\n西\n亞"

    L["烈\n焰\n巨\n兽"] = "烈\n焰\n戰\n輪"
    L["锋\n鳞"] = "銳\n鱗"
    L["掌\n炉\n者"] = "伊\n格\n尼\n司"
    L["拆\n解\n者"] = "拆\n解\n者"
    L["钢\n铁\n议\n会"] = "鋼\n之\n議\n會"
    L["科\n隆\n加\n恩"] = "柯\n洛\n剛\n恩"
    L["欧\n尔\n利\n亚"] = "奧\n芮\n雅"
    L["霍\n迪\n尔"] = "霍\n迪\n爾"
    L["托\n里\n姆"] = "索\n林\n姆"
    L["弗\n蕾\n亚"] = "芙\n蕾\n雅"
    L["米\n米\n尔\n隆"] = "彌\n米\n倫"
    L["维\n扎\n克\n斯\n将\n军"] = "威\n札\n斯\n將\n軍"
    L["尤\n格\n萨\n隆"] = "尤\n格\n薩\n隆"
    L["奥\n尔\n加\n隆"] = "艾\n爾\n加\n隆"

    L["阿\n努\n布\n雷\n坎"] = "阿\n努\n比\n瑞\n克\n漢"
    L["黑\n女\n巫\n法\n琳\n娜"] = "大\n寡\n婦\n費\n琳\n娜"
    L["迈\n克\n斯\n纳"] = "梅\n克\n絲\n娜"
    L["瘟\n疫\n使\n者\n诺\n斯"] = "瘟\n疫\n者\n諾\n斯"
    L["肮\n脏\n的\n希\n尔\n盖"] = "骯\n髒\n者\n海\n根"
    L["洛\n欧\n塞\n布"] = "洛\n斯\n伯"
    L["教\n官"] = "講\n師\n拉\n祖\n維\n斯"
    L["收\n割\n者\n戈\n提\n克"] = "收\n割\n者\n高\n希"
    L["天\n启\n四\n骑\n士"] = "四\n騎\n士"
    L["帕\n奇\n维\n克"] = "縫\n補\n者"
    L["格\n罗\n布\n鲁\n斯"] = "葛\n羅\n巴\n斯"
    L["格\n拉\n斯"] = "古\n魯\n斯"
    L["塔\n迪\n乌\n斯"] = "泰\n迪\n斯"
    L["萨\n菲\n隆"] = "薩\n菲\n隆"
    L["克\n尔\n苏\n加\n德"] = "科\n爾\n蘇\n加\n德"
    L["萨\n塔\n里\n奥"] = "撒\n爾\n薩\n里\n安"
    L["玛\n里\n苟\n斯"] = "瑪\n里\n苟\n斯"


    -- L[] = true
    -- L[] = true
    -- L[] = true
    -- L[] = true
    -- L[] = true
    -- L[] = true
    -- L[] = true
    -- L[] = true
    -- L[] = true
    -- L[] = true
    -- L[] = true
    -- L[] = true
    -- L[] = true
    -- L[] = true
    -- L[] = true
end

ADDONSELF.L = L