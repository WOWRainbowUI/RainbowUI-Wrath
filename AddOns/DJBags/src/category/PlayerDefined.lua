local ADDON_NAME, ADDON = ...

DJBags_AddCategoryFilter(function(bag, slot)
    local cInfo = C_Container.GetContainerItemInfo(bag, slot)
    local itemID = cInfo and cInfo.itemID
    -- local _, _, _, _, _, _, _, _, _, itemID = C_Container.GetContainerItemInfo(bag, slot)

    return DJBags_DB_Char.categories[itemID] or DJBags_DB.categories[itemID]
end, '玩家自訂分類')

function ADDON:GetAllPlayerDefinedCategories()
	local flags = {}
	local output = {}

	for k, v in pairs(DJBags_DB.categories) do
		if not flags[v] then
			flags[v] = true
			tinsert(output, v)
		end
	end

	for k, v in pairs(DJBags_DB_Char.categories) do
		if not flags[v] then
			flags[v] = true
			tinsert(output, v)
		end
	end

	table.sort(output)
	return output
end
