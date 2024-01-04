local AB, _, T = assert(OPie.ActionBook:compatible(2,14), "Requires a compatible version of ActionBook"), ...
local ORI, EV, L, PC = OPie.UI, T.Evie, T.L, T.OPieCore
local COMPAT = select(4,GetBuildInfo())
local MODERN, CF_WRATH = COMPAT >= 10e4, COMPAT < 10e4 and COMPAT >= 3e4
local MODERN_CONTAINERS = MODERN or C_Container and C_Container.GetContainerNumSlots

local exclude, questItems, IsQuestItem, disItems = PC:RegisterPVar("AutoQuestExclude", {}), {}
local function getContainerItemQuestInfo(bag, slot)
	local iqi = C_Container.GetContainerItemQuestInfo(bag, slot)
	return iqi.isQuestItem, iqi.questID, iqi.isActive
end
if MODERN then
	questItems[30148] = {72986, 72985}
	local include do
		local function isInPrimalistFutureScenario()
			return C_TaskQuest.IsActive(74378) and C_Scenario.IsInScenario() and select(8, GetInstanceInfo()) == 2512
		end
		local function isOnKeysOfLoyalty()
			local q = C_QuestLog.IsOnQuest
			return q(66805) or q(66133)
		end
		local function have15(iid)
			return GetItemCount(iid) >= 15, nil, nil, 4
		end
		local function have1()
			return true, false, false, 4
		end
		local function consume()
			return true, false, false, 3
		end
		local mapMarker = consume
		local function flightstone100()
			local ci = C_CurrencyInfo.GetCurrencyInfo(2245)
			if ci and ci.maxQuantity and ci.maxQuantity > 0 and (ci.quantity or 0) + 100 <= ci.maxQuantity then
				return true, false, false, 3
			end
		end
		include = {
			[33634]=true, [35797]=true, [37888]=true, [37860]=true, [37859]=true, [37815]=true, [46847]=true, [47030]=true, [39213]=true, [42986]=true, [49278]=true,
			[86425]={31332, 31333, 31334, 31335, 31336, 31337}, [90006]=true, [86536]=true, [86534]=true,
			[180008]=-60609, [180009]=-60609, [180170]=-60649,
			[174464]=true, [168035]=true,
			[191251]=isOnKeysOfLoyalty, [202096]=isInPrimalistFutureScenario, [203478]=isInPrimalistFutureScenario,
			[194540]=mapMarker, [198843]=mapMarker, [198852]=mapMarker, [198854]=mapMarker, [199061]=mapMarker, [199062]=mapMarker, [199065]=mapMarker,
			[199066]=mapMarker, [199067]=mapMarker, [199068]=mapMarker, [199069]=mapMarker, [200738]=mapMarker, [202667]=mapMarker, [202668]=mapMarker,
			[202669]=mapMarker, [202670]=mapMarker,
			[204075]=have15, [204076]=have15, [204078]=have15, [204077]=have15, [204911]=have1,
			[202171]=flightstone100, [205254]=consume,
		}
	end
	local includeSpell = {
		[GetSpellInfo(375806) or 0]=3,
		[GetSpellInfo(411602) or 0]=3,
		[GetSpellInfo(409074) or 0]=3,
		[GetSpellInfo(409490) or 0]=3,
		[GetSpellInfo(409643) or 0]=3,
	}
	includeSpell[0] = nil
	disItems = {
		[198798]=3, [198800]=3, [201359]=3, [198675]=3, [198694]=3, [198689]=3, [198799]=3, [201358]=3,
		[201356]=3, [201357]=3, [201360]=3, [204990]=3, [205001]=3, [204999]=3,
		[200939]=3, [200940]=3, [200941]=3, [200942]=3, [200943]=3, [200945]=3, [200946]=3, [200947]=3,
	}
	setmetatable(exclude, {__index={
		[204561]=1,
	}})
	function IsQuestItem(iid, bag, slot)
		if exclude[iid] then return false end
		if disItems[iid] then return true, false, disItems[iid] end
		local inc, isQuest, startQuestId, isQuestActive = include[iid], getContainerItemQuestInfo(bag, slot)
		isQuest = iid and ((isQuest and GetItemSpell(iid)) or (inc == true) or (startQuestId and not isQuestActive and not C_QuestLog.IsQuestFlaggedCompleted(startQuestId)))
		local tinc, rcat = inc and not isQuest and type(inc), nil
		if tinc == "function" then
			isQuest, startQuestId, isQuestActive, rcat = inc(iid)
		elseif tinc then
			isQuest = true
			for i=tinc == "number" and 1 or #inc, 1, -1 do
				local qid, wq = tinc == "number" and inc or inc[i]
				wq, qid = qid < 0, qid < 0 and -qid or qid
				if C_QuestLog.IsQuestFlaggedCompleted(qid) or
				   wq and not C_QuestLog.IsOnQuest(qid) then
					return false
				end
			end
		end
		if inc == nil and not isQuest then
			local isn, isid = GetItemSpell(iid)
			if isid and includeSpell[isn] and IsUsableSpell(isid) then
				isQuest, startQuestId, rcat = true, false, includeSpell[isn]
			end
		end
		return isQuest, startQuestId and not isQuestActive, rcat
	end
else
	local include = PC:RegisterPVar("AutoQuestWhitelist", {}) do
		local hexclude, hinclude = {}, {}
		for i in ("12460 12451 12450 12455 12457 12458 12459"):gmatch("%d+") do
			hexclude[i+0] = true
		end
		for i in (CF_WRATH and "33634 35797 37888 37860 37859 37815 46847 47030 39213 42986 49278" or ""):gmatch("%d+") do
			hinclude[i+0] = true
		end
		setmetatable(exclude, {__index=hexclude})
		setmetatable(include, CF_WRATH and {__index=hinclude} or nil)
	end
	local QUEST_ITEM = Enum.ItemClass.Questitem
	function IsQuestItem(iid, bag, slot, skipTypeCheck)
		local isQuest, startsQuest = false, false
		if include[iid] then
			isQuest = true
		elseif not (iid and GetItemSpell(iid) and not exclude[iid]) then
		elseif select(12, GetItemInfo(iid)) == QUEST_ITEM then
			isQuest = true
		elseif skipTypeCheck then
			include[iid], isQuest = true, true
		end
		if CF_WRATH and bag and slot then
			local _isQuestItem, startQuestId, isQuestActive = getContainerItemQuestInfo(bag, slot)
			startsQuest = startQuestId and not isQuestActive and not C_QuestLog.IsQuestFlaggedCompleted(startQuestId) or false
			isQuest = isQuest or startsQuest
		end
		return isQuest, startsQuest
	end

	local lastQuestAcceptTime = GetTime()-20
	function EV.QUEST_ACCEPTED()
		lastQuestAcceptTime = GetTime()
	end
	function EV:CHAT_MSG_LOOT(text)
		local iid = text:match("|Hitem:(%d+).-|h")
		if iid and (GetTime()-lastQuestAcceptTime) < 1 then
			IsQuestItem(iid+0, nil, nil, true)
		end
	end
end
local GetQuestLogTitle = GetQuestLogTitle or function(i)
	local q = C_QuestLog.GetInfo(i)
	if q then
		local qid = q.questID
		return nil, nil, nil, q.isHeader, q.isCollapsed, C_QuestLog.IsComplete(qid), nil, qid
	end
end

local colId, current, changed
local collection, inring, ctok = MODERN and {"OPbQIEB", OPbQIEB=AB:GetActionSlot("extrabutton", 1)} or {}, {}, 0
local addSlice, sortQICollection do
	local tokCat, colOrder = {}, {}
	function addSlice(tok, cat, ...)
		if inring[tok] then
			inring[tok], tokCat[tok] = current, cat
		else
			local slot = AB:GetActionSlot(...)
			if slot then
				inring[tok], tokCat[tok] = current, cat
				collection[#collection+1], collection[tok], changed = tok, slot, true
			end
		end
		return tok
	end
	local function cmpEntry(a, b)
		local ac, bc = tokCat[a], tokCat[b]
		if ac ~= bc then
			if (not ac) ~= (not bc) then
				return not ac
			end
			return ac < bc
		end
		return colOrder[a] < colOrder[b]
	end
	function sortQICollection()
		for i=1, #collection do
			colOrder[collection[i]] = i
		end
		for k in pairs(tokCat) do
			if not inring[k] then
				tokCat[k] = nil
			end
		end
		table.sort(collection, cmpEntry)
	end
end
local function scanQuests(i)
	for i=i or 1, (MODERN and C_QuestLog.GetNumQuestLogEntries or GetNumQuestLogEntries)() do
		local _, _, _, isHeader, isCollapsed, isComplete, _, qid = GetQuestLogTitle(i)
		if isHeader and isCollapsed then
			ExpandQuestHeader(i)
			return scanQuests(i+1), CollapseQuestHeader(i)
		elseif questItems[qid] and not isComplete then
			for _, iid in ipairs(questItems[qid]) do
				local act = not exclude[iid] and AB:GetActionSlot("item", iid)
				if act then
					addSlice("OPbQIi" .. iid, 2, "item", iid)
					break
				end
			end
		elseif MODERN then
			local link, _, _, showWhenComplete = GetQuestLogSpecialItemInfo(i)
			if link and (showWhenComplete or not isComplete) then
				local iid = tonumber(link:match("item:(%d+)"))
				if not exclude[iid] then
					addSlice("OPbQIi" .. iid, 2, "item", iid)
				end
			end
		end
	end
end
local function syncRing(_, _, upId)
	if upId ~= colId then return end
	changed, current = false, (ctok + 1) % 2
	
	local za = C_ZoneAbility and C_ZoneAbility.GetActiveAbilities()
	for i=1, za and #za or 0 do
		local ai = za[i]
		local asid = ai and ai.spellID
		if asid and not IsPassiveSpell(asid) then
			addSlice("OPbQIz" .. asid, 1, "spell", asid)
		end
	end

	local ns = MODERN_CONTAINERS and C_Container.GetContainerNumSlots or GetContainerNumSlots
	local giid = MODERN_CONTAINERS and C_Container.GetContainerItemID or GetContainerItemID
	for bag=0,MODERN and 5 or 4 do
		for slot=1, ns(bag) or 0 do
			local iid = giid(bag, slot)
			local include, startsQuestMark, qiCat = IsQuestItem(iid, bag, slot)
			if include then
				local tok = addSlice("OPbQIi" .. iid, qiCat or 2, disItems and disItems[iid] and "disenchant" or "item", iid)
				ORI:SetQuestHint(tok, startsQuestMark)
			end
		end
	end
	for i=0,INVSLOT_LAST_EQUIPPED do
		local tok = "OPbQIi" .. (GetInventoryItemID("player", i) or 0)
		if inring[tok] then
			inring[tok] = current
		end
	end
	scanQuests()

	local freePos, oldCount = MODERN and 2 or 1, #collection
	for i=freePos, oldCount do
		local v = collection[i]
		collection[freePos], freePos, collection[v], inring[v] = collection[i], freePos + (inring[v] == current and 1 or 0), (inring[v] == current and collection[v] or nil), inring[v] == current and current or nil
	end
	for i=oldCount,freePos,-1 do
		collection[i] = nil
	end
	ctok = current

	if changed or freePos <= oldCount then
		sortQICollection()
		AB:UpdateActionSlot(colId, collection)
	end
end
colId = AB:CreateActionSlot(nil,nil, "collection",collection)
OPie:SetRing("OPieAutoQuest", colId, {name=L"Quest Items", hotkey="ALT-Q"})
AB:AddObserver("internal.collection.preopen", syncRing)
function EV.PLAYER_REGEN_DISABLED()
	syncRing(nil, nil, colId)
end

local function excludeItemID(iid)
	if iid > 0 then
		exclude[iid] = true
	else
		exclude[-iid] = nil
		if exclude[-iid] then
			exclude[-iid] = false
		end
	end
end
T.AddSlashSuffix(function(msg)
	local args = msg:match("^%s*%S+%s*(.*)$")
	if args:match("^[%d%s%-]+$") then
		for iid in args:gmatch("[%-]?%d+") do
			excludeItemID(tonumber(iid))
		end
	else
		local flag, _, link
		flag, args = args:match("^(%-?)(.*)$")
		_, link = GetItemInfo(args:match("|H(item:%d+)") or args)
		local iid = link and link:match("item:(%d+)")
		if iid then
			excludeItemID(tonumber(iid) * (flag == "-" and -1 or 1))
		end
	end
end, "exclude-quest-item")