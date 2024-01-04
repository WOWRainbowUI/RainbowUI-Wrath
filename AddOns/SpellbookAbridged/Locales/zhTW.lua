if ( GetLocale() ~= "zhTW" ) then
	return;
end

local L = LibStub("AceLocale-3.0"):NewLocale("SpellbookAbridged", "zhTW")
if not L then return end

L["Auto UpRank"] = "自動升級快捷列的法術"
L["Spell Name"] = "法術名稱"
L["Spell Subtext"] = "法術說明"
