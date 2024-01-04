local ADDON_NAME, ADDON = ...

-- Formatter types
ADDON.formats = {
	MASONRY = 0,
}

-- Locale
local locale = {
	enUS = {
		ALL_CHARACTERS = 'All Characters?',
		COLUMNS = 'Columns: %d',
		CATEGORY_SETTINGS = "Category Settings",
		CATEGORY_SETTINGS_FOR = "%s Category Settings",
		DJBAGS_CATEGORY_SETTINGS = "Category Settings",
		CATEGORY_NEW = NEW,
		SCALE = 'Scale: %s'
	},
	zhTW = {
		ALL_CHARACTERS = '所有角色共用',
		COLUMNS = '欄寬: %d',
		CATEGORY_SETTINGS = "分類設定",
		CATEGORY_SETTINGS_FOR = "DJ 背包分類設定",
		DJBAGS_CATEGORY_SETTINGS = "分類設定",
		CATEGORY_NEW = "新的",
		SCALE = '縮放: %s'
	}
}

ADDON.locale = locale[GetLocale()] or locale['enUS']

for k, v in pairs(ADDON.locale) do
	_G["DJBAGS_" .. k] = v
end
