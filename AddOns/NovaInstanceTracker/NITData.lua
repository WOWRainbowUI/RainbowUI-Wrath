------------------------------
---NovaInstanceTracker data---
------------------------------

local locale = GetLocale();
if (locale == "deDE" and NIT.expansionNum < 5) then
	--Temporary fix for german clients having broken XP global strings that don't show the amount gained.
	--Not sure when this started but it was reported and tested 15/09/2023
	--Credit to user Tomatensalat and an addon https://www.wowinterface.com/downloads/download25450-aPVPName1s2s by Razyel.
	--Only fixing a few strings that are important to this addon while normal grouping for xp in dungs.
	COMBATLOG_XPGAIN_EXHAUSTION1_RAID = "%s stirbt, Ihr bekommt %d Erfahrung. (%s Erf. %s Bonus, -%d Schlachtzugsmalus)"
	COMBATLOG_XPGAIN_FIRSTPERSON = "%s stirbt, Ihr bekommt %d Erfahrung."
	COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED_RAID = "Ihr bekommt %d Erfahrung. (-%d Schlachtzugsmalus)"
	COMBATLOG_XPGAIN_FIRSTPERSON_GROUP = "%s stirbt, Ihr bekommt %d Erfahrung. (+%d Gruppen-Bonus)"
	COMBATLOG_XPGAIN_EXHAUSTION1_GROUP = "%s stirbt, Ihr bekommt %d Erfahrung. (%s Erf. %s Bonus, +%d Gruppen-Bonus)"
	COMBATLOG_XPGAIN_EXHAUSTION5_GROUP = "%s stirbt, Ihr bekommt %d Erfahrung. (%s Erf. %s Abzug, +%d Gruppen-Bonus)"
	COMBATLOG_XPGAIN_EXHAUSTION2_GROUP = "%s stirbt, Ihr bekommt %d Erfahrung. (%s Erf. %s Bonus, +%d Gruppen-Bonus)"
	COMBATLOG_XPGAIN_EXHAUSTION2 = "%s stirbt, Ihr bekommt %d Erfahrung. (%s Erf. %s Bonus)"
	COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED = "Ihr bekommt %d Erfahrung."
	COMBATLOG_XPGAIN_EXHAUSTION5 = "%s stirbt, Ihr bekommt %d Erfahrung. (%s-Erf. %s-Abzug)"
	COMBATLOG_XPGAIN_FIRSTPERSON_RAID = "%s stirbt, Ihr bekommt %d Erfahrung. (-%d Schlachtzugsmalus)"
	COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED_GROUP = "Ihr bekommt %d Erfahrung. (+%d Gruppen-Bonus)"
	COMBATLOG_XPGAIN_EXHAUSTION4_GROUP = "%s stirbt, Ihr bekommt %d Erfahrung. (%s Erf. %s Abzug, +%d Gruppen-Bonus)"
	COMBATLOG_XPGAIN_EXHAUSTION5_RAID = "%s stirbt, Ihr bekommt %d Erfahrung. (%s Erf. %s Abzug, -%d Schlachtzugsmalus)"
	COMBATLOG_XPGAIN_EXHAUSTION4 = "%s stirbt, Ihr bekommt %d Erfahrung. (%s-Erf. %s-Abzug)"
	COMBATLOG_XPGAIN_EXHAUSTION4_RAID = "%s stirbt, Ihr bekommt %d Erfahrung. (%s Erf. %s Abzug, -%d Schlachtzugsmalus)"
	COMBATLOG_XPGAIN_EXHAUSTION1 = "%s stirbt, Ihr bekommt %d Erfahrung. (%s Erf. %s Bonus)"
	COMBATLOG_XPGAIN_QUEST = "Ihr bekommt %d Erfahrung. (%s EP-Bonus durch %s)"
	COMBATLOG_XPGAIN_EXHAUSTION2_RAID = "%s stirbt, Ihr bekommt %d Erfahrung. (%s Erf. %s Bonus, -%d Schlachtzugsmalus)"
end

local L = LibStub("AceLocale-3.0"):GetLocale("NovaInstanceTracker");
local version = GetAddOnMetadata("NovaInstanceTracker", "Version") or 9999;
local GetContainerNumFreeSlots = GetContainerNumFreeSlots or C_Container.GetContainerNumFreeSlots;
local GetContainerNumSlots = GetContainerNumSlots or C_Container.GetContainerNumSlots;
local GetContainerItemCooldown = GetContainerItemCooldown or C_Container.GetContainerItemCooldown;
local GetContainerItemLink = GetContainerItemLink or C_Container.GetContainerItemLink;
local IsQuestFlaggedCompleted = IsQuestFlaggedCompleted or C_QuestLog.IsQuestFlaggedCompleted;

--Some of this addon comm stuff is copied from my other addon NovaWorldBuffs and is left here incase of future stuff being added.
function NIT:OnCommReceived(commPrefix, string, distribution, sender)
	--if (NIT.isDebug) then
	--	return;
	--end
	--AceComm doesn't supply realm name if it's on the same realm as player.
	--For now we'll check all 3 name types just to be sure until tested.
	local me = UnitName("player") .. "-" .. GetRealmName();
	local meNormalized = UnitName("player") .. "-" .. GetNormalizedRealmName();
	if (sender == UnitName("player") or sender == me or sender == meNormalized) then
		NIT.hasAddon[meNormalized] = tostring(version);
		return;
	end
	local _, realm = strsplit("-", sender, 2);
	--If realm found then it's not my realm, but just incase acecomm changes and starts supplying realm also check if realm exists.
	if (realm ~= nil or (realm and realm ~= GetRealmName() and realm ~= GetNormalizedRealmName())) then
		--Ignore data from other realms (in bgs).
		return;
	end
	--If no realm in name it must be our realm so add it.
	if (not string.match(sender, "-")) then
		--Add normalized realm since roster checks use this.
		sender = sender .. "-" .. GetNormalizedRealmName();
	end
	local decoded;
	if (distribution == "YELL" or distribution == "SAY") then
		return;
		--decoded = NIT.libDeflate:DecodeForWoWChatChannel(string);
	else
		decoded = NIT.libDeflate:DecodeForWoWAddonChannel(string);
	end
	if (not decoded) then
		NIT:debug("Incoming data decode failure");
		return;
	end
	local decompressed = NIT.libDeflate:DecompressDeflate(decoded);
	local deserializeResult, deserialized = NIT.serializer:Deserialize(decompressed);
	if (not deserializeResult) then
		NIT:debug("Error deserializing:", distribution);
		return;
	end
	local args = NIT:explode(" ", deserialized, 2);
	local cmd = args[1]; --Cmd (first arg) so we know where to send the data.
	local remoteVersion = args[2]; --Version number.
	local data = args[3]; --Data (everything after version arg).
	--if (data == nil and cmd ~= "ping") then
		--Temp fix for people with old version data structure sending incompatable data.
		--Only effects a few of the early testers.
	--	data = args[2]; --Data (everything after version arg).
	--	remoteVersion = "0";
	--end
	NIT.hasAddon[sender] = remoteVersion or "0";
	if (not tonumber(remoteVersion)) then
		--Trying to catch a lua error and find out why.
		NIT:debug("version missing", sender, cmd, data);
		return;
	end
	--Ignore data syncing for some recently out of date versions.
	if (tonumber(remoteVersion) < 1.00) then
		return;
	end
	if (cmd == "instanceReset") then
		--Instance reset.
		NIT:instanceResetComm(data, sender, distribution);
	elseif (cmd == "instanceResetNoMsg") then
		--Instance reset from someone with group msg disabled.
		NIT:instanceResetNoMsgComm(data, sender, distribution);
	elseif (cmd == "instanceResetOther") then
		--Instance reset from NWB user.
		NIT:instanceResetOtherComm(data, sender, distribution);
	end
	NIT:versionCheck(remoteVersion);
end

--Send to specified addon channel.
function NIT:sendComm(distribution, string, target)
	--if (NIT.isDebug) then
	--	return;
	--end
	--NIT:debug("Comms:", distribution, string);
	if (target == UnitName("player")) then
		return;
	end
	if (distribution == "GUILD" and not IsInGuild()) then
		return;
	end
	if ((UnitInBattleground("player") or NIT:isInArena()) and distribution ~= "GUILD") then
		return;
	end
	if (distribution == "CHANNEL") then
		--Get channel ID number.
		local addonChannelId = GetChannelName(target);
		--Not sure why this only accepts a string and not an int.
		--Addon channels are disabled in classic but I'll leave this here anyway.
		target = tostring(addonChannelId);
	elseif (distribution ~= "WHISPER") then
		target = nil;
	end
	local data, serialized;
	serialized = NIT.serializer:Serialize(string);
	local compressed = NIT.libDeflate:CompressDeflate(serialized, {level = 9});
	if (distribution == "YELL" or distribution == "SAY") then
		data = NIT.libDeflate:EncodeForWoWChatChannel(compressed);
	else
		data = NIT.libDeflate:EncodeForWoWAddonChannel(compressed);
	end
	NIT:SendCommMessage(NIT.commPrefix, data, distribution, target);
end

function NIT:versionCheck(remoteVersion)
	if (remoteVersion == 0) then
		--Comm is from NWB.
		return;
	end
	local lastVersionMsg = NIT.db.global.lastVersionMsg;
	if (tonumber(remoteVersion) > tonumber(version) and (GetServerTime() - lastVersionMsg) > 14400) then
		print("|cFF9CD6DE" .. L["versionOutOfDate"]);
		NIT.db.global.lastVersionMsg = GetServerTime();
	end
	if (tonumber(remoteVersion) > tonumber(version)) then
		NIT.latestRemoteVersion = remoteVersion;
	end
end

function NIT:sendVersion(distribution)
	--The "check" part needs to be here so it works with older versions, can be removed at some point later.
	if (distribution) then
		NIT:sendComm(distribution, "version " .. version .. " check");
	else
		NIT:sendGroupComm("version " .. version .. " check")
	end
end

--Instance reset sent by someone with this addon.
function NIT:instanceResetComm(data, sender, distribution)
	--Do nothing if they have group msg enabled to let us know anyway.
	--NIT:debug("Incoming data:", data);
end

--Instance reset sent by someone with this addon but with group msg disabled.
function NIT:instanceResetNoMsgComm(data, sender, distribution)
	NIT:debug("Incoming noMsg data:", data);
	local who, realm = strsplit("-", sender, 2);
	NIT:print(data .. " has been reset by the group leader (" .. who .. ").");
end

--Instance reset sent by someone without this addon (from NWB) so they won't print to party chat.
function NIT:instanceResetOtherComm(data, sender, distribution)
	NIT:debug("Incoming data from other:", data);
	local who, realm = strsplit("-", sender, 2);
	NIT:print(data .. " has been reset by the group leader (" .. who .. ").");
end

local doGUID, isGhost;
local currentXP, maxXP = 0, 0;
local f = CreateFrame("Frame");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("CHAT_MSG_ADDON");
f:RegisterEvent("PLAYER_UNGHOST");
f:RegisterEvent("PLAYER_LEAVING_WORLD");
f:RegisterEvent("ADDONS_UNLOADING");
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
f:RegisterEvent("PLAYER_TARGET_CHANGED");
f:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
f:RegisterEvent("NAME_PLATE_UNIT_ADDED");
f:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");
f:RegisterEvent("PLAYER_REGEN_ENABLED");
f:RegisterEvent("GROUP_ROSTER_UPDATE");
f:RegisterEvent("CHAT_MSG_MONEY");
f:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE");
f:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN");
f:RegisterEvent("PLAYER_UPDATE_RESTING");
f:RegisterEvent("PLAYER_XP_UPDATE");
f:RegisterEvent("PLAYER_LEVEL_UP");
f:RegisterEvent("PLAYER_DEAD");
f:RegisterEvent("BAG_UPDATE");
f:RegisterEvent("PLAYER_MONEY");
f:RegisterEvent("QUEST_TURNED_IN");
f:RegisterEvent("CHAT_MSG_SKILL");
f:RegisterEvent("UNIT_RANGEDDAMAGE");
f:RegisterEvent("LOCALPLAYER_PET_RENAMED");
f:RegisterEvent("UNIT_PET");
f:RegisterEvent("PLAYER_LOGOUT");
if (NIT.expansionNum < 4) then
	f:RegisterEvent("UNIT_PET_TRAINING_POINTS");
	f:RegisterEvent("TRADE_SKILL_UPDATE");
end
f:RegisterEvent("GROUP_JOINED");
f:RegisterEvent("GROUP_FORMED");
f:RegisterEvent("PLAYER_CAMPING");
f:RegisterEvent("TRADE_SKILL_SHOW");
f:RegisterEvent("TRADE_SKILL_CLOSE");
f:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
f:RegisterEvent("ENCOUNTER_END");
f:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
if (NIT.isRetail) then
	f:RegisterEvent("CHALLENGE_MODE_START");
	f:RegisterEvent("CHALLENGE_MODE_COMPLETED");
	f:RegisterEvent("CHALLENGE_MODE_MAPS_UPDATE")
	f:RegisterEvent("CHAT_MSG_LOOT");
	f:RegisterEvent("ITEM_CHANGED");
	f:RegisterEvent("WEEKLY_REWARDS_UPDATE");
end
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "PLAYER_LEAVING_WORLD" ) then
		doGUID = nil;
		if (UnitIsGhost("player")) then
			isGhost = true;
			NIT:debug("ghost");
			C_Timer.After(5, function()
				isGhost = false;
			end)
		end
		NIT:playerLeavingWorld(...);
	elseif (event == "PLAYER_ENTERING_WORLD" ) then
		local isLogon, isReload = ...;
		NIT:playerEnteringWorld(...);
		if (isLogon) then
			C_Timer.After(10, function()
				--Let other comms go first, this can be removed later and just party version checking once more people have it.
				NIT:sendVersion("GUILD");
				currentXP = (UnitXP("player") or 0);
				maxXP = (UnitXPMax("player") or 0);
			end)
			C_Timer.After(5, function()
				NIT:fixCooldowns();
			end)
			NIT:trimTrades();
		end
		if (isLogon or isReload) then
			--Need to add a delay for pet data to load properly at logon.
			C_Timer.After(5, function()
				NIT:recordCharacterData();
			end)
			C_Timer.After(10, function()
				NIT:recordKeystoneData();
			end)
		else
			NIT:recordCharacterData();
		end
		C_Timer.After(3, function()
			NIT:recordLockoutData();
		end)
	elseif (event == "ADDONS_UNLOADING" ) then
		NIT:playerLogout(...);
		--Had this disable this here, too many player stats are set to 0 or nil right before PLAYER_LOGOUT.
		--Changed to a polling system.
		--NIT:recordCharacterData();
	elseif (event == "CHAT_MSG_ADDON") then
		local commPrefix, string, distribution, sender = ...;
		if (commPrefix == NIT.commPrefix) then
			local normalizedWho = string.gsub(sender, " ", "");
			normalizedWho = string.gsub(normalizedWho, "'", "");
			if (not string.match(normalizedWho, "-")) then
				--Sometimes it comes through without realm in classic?
				normalizedWho = normalizedWho .. "-" .. GetNormalizedRealmName();
			end
			if (not NIT.hasAddon[normalizedWho]) then
				NIT.hasAddon[normalizedWho] = "0";
			end
		end
	elseif (event == "PLAYER_UNGHOST" ) then
		--If player just unghosted then don't record new instance.
		--NIT:debug("unghost");
		isGhost = true;
		C_Timer.After(4, function()
			isGhost = false;
		end)
		NIT:throddleEventByFunc(event, 2, "recordDurabilityData", ...);
	elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		NIT:combatLogEventUnfiltered(...);
	elseif (event == "UNIT_TARGET" or event == "PLAYER_TARGET_CHANGED") then
		NIT:parseGUID("target", nil, "target");
		if (NIT.inInstance and NIT.isWrath) then
			NIT:scanDungeonSubDifficulty();
		end
	elseif (event == "UPDATE_MOUSEOVER_UNIT") then
		NIT:parseGUID("mouseover", nil, "mouseover");
	elseif (event == "NAME_PLATE_UNIT_ADDED") then
		NIT:parseGUID("nameplate1", nil, "nameplate");
	elseif (event == "CHAT_MSG_COMBAT_XP_GAIN") then
		NIT:chatMsgCombatXpGain(...);
		NIT:throddleEventByFunc(event, 2, "recordGroupInfo", ...);
	elseif (event == "ENCOUNTER_END") then
		local _, _, _, _, success = ...;
		NIT:throddleEventByFunc(event, 2, "recordGroupInfo", ...);
		C_Timer.After(3, function()
			NIT:recordLockoutData();
		end)
		if (success) then
			C_Timer.After(2, function()
				NIT:recordKeystoneData();
			end)
		end
	elseif (event == "CHAT_MSG_COMBAT_FACTION_CHANGE") then
		NIT:chatMsgCombatFactionChange(...);
	elseif (event == "CHAT_MSG_COMBAT_HONOR_GAIN") then
		NIT:chatMsgCombatHonorGain(...);
		NIT:recordHonorData();
	elseif (event == "PLAYER_REGEN_ENABLED") then
		NIT:recordCombatEndedData(...);
		--Send GUID from mage possibly later after pull is done.
	elseif (event == "GROUP_ROSTER_UPDATE") then
		NIT:recordGroupInfo();
	elseif (event == "CHAT_MSG_MONEY") then
		NIT:chatMsgMoney(...);
	elseif (event == "PLAYER_UPDATE_RESTING") then
		NIT:recordCharacterData();
	elseif (event == "PLAYER_XP_UPDATE") then
		--NIT:recordPlayerLevelData();
		NIT:throddleEventByFunc(event, 2, "recordPlayerLevelData", ...);
		currentXP = (UnitXP("player") or 0);
		maxXP = (UnitXPMax("player") or 0);
	elseif (event == "PLAYER_LEVEL_UP") then
		--Needs a delay to give time for client to update with right data.
		C_Timer.After(2, function()
			NIT:recordCharacterData();
		end)
	elseif (event == "PLAYER_DEAD") then
		NIT:throddleEventByFunc(event, 2, "recordDurabilityData", ...);
	elseif (event == "BAG_UPDATE" or event == "PLAYER_MONEY") then
		NIT:throddleEventByFunc(event, 3, "recordInventoryData", ...);
	elseif (event == "QUEST_TURNED_IN") then
		NIT:throddleEventByFunc(event, 2, "recordPlayerLevelData", ...);
		NIT:throddleEventByFunc(event, 1, "recordQuests", ...);
		C_Timer.After(5, function()
			NIT:recordQuests();
		end)
	elseif (event == "CHAT_MSG_SKILL") then
		NIT:throddleEventByFunc(event, 4, "recordSkillUpData", ...);
	elseif (event == "UNIT_RANGEDDAMAGE" or event == "LOCALPLAYER_PET_RENAMED" or event == "UNIT_PET"
			or event == "UNIT_PET_TRAINING_POINTS") then
		local unit = ...;
		if (unit and (event == "UNIT_RANGEDDAMAGE" and unit ~= "pet") or (event == "UNIT_PET" and unit ~= "player")
				or (event == "UNIT_PET_TRAINING_POINTS" and unit ~= "pet")) then
			--Check if it's my pet. (UNIT_RANGEDDAMAGE uses "pet", UNIT_PET uses "player")
			--This must be checked here and not in recordHunterData() becaus the
			--throddle function captures the first unit only and supresses the rest but
			--UNIT_PET spams for every pet dismissed around the player so it captures the entire team
			--and can capture someone elses pet first before thier own within the throddle suppression timer.
			return;
		end
		if (NIT.loadTime < (GetServerTime() - 8)) then
				--This throddle timer can't be longer than pet res cast time.
				NIT:throddleEventByFunc(event, 2, "recordHunterData", ...);
		end
	elseif (event == "GROUP_JOINED" or event == "GROUP_FORMED") then
		--If not in group when this fires it means you are first to invite and starting the group so we use GROUP_FORMED instead.
		if (IsInGroup()) then
			NIT:throddleEventByFunc(event, 3, "sendVersion");
			--C_Timer.After(3, function()
			--	if (IsInGroup()) then
			--		NIT:sendVersion();
			--	end
			--end)
		end
	elseif (event == "PLAYER_CAMPING") then
		--Print stats if logging out inside an instance for an offline reset.
		if (NIT.inInstance) then
			NIT.data.instances[1]["leftTime"] = GetServerTime();
			NIT:showInstanceStats();
		end
		NIT:recordLockoutData();
		NIT:recordQuests();
	elseif (event == "PLAYER_LOGOUT") then
		--Print stats if logging out inside an instance for an offline reset.
		NIT:recordLockoutData();
		NIT:recordQuests();
	elseif (event == "TRADE_SKILL_UPDATE" or event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE") then
		NIT:recordCooldowns();
	elseif (event == "UPDATE_BATTLEFIELD_SCORE") then
		NIT:recordBgStats();
	elseif (event == "CURRENCY_DISPLAY_UPDATE") then
		C_Timer.After(1, function()
			NIT:recordCurrency();
		end)
	elseif (event == "CHALLENGE_MODE_START") then
		if (NIT.inInstance and NIT.data.instances[1]) then
			local activeKeystoneLevel, activeAffixIDs, wasActiveKeystoneCharged = C_ChallengeMode.GetActiveKeystoneInfo();
			NIT.data.instances[1].mythicPlus = {
				level = activeKeystoneLevel;
				affixes = activeAffixIDs,
			};
			--record +key times for the dung
		end
	elseif (event == "CHALLENGE_MODE_COMPLETED") then
		NIT:debug("challenge mode completed")
		if (NIT.inInstance and NIT.data.instances[1]) then
			if (not NIT.data.instances[1].mythicPlus) then
				NIT.data.instances[1].mythicPlus = {};
			end
			local mapChallengeModeID, level, time, onTime, keystoneUpgradeLevels, practiceRun, oldOverallDungeonScore, newOverallDungeonScore,
					IsMapRecord, IsAffixRecord, PrimaryAffix, isEligibleForScore, members = C_ChallengeMode.GetCompletionInfo();
			local data = NIT.data.instances[1].mythicPlus;
			data.map = mapChallengeModeID;
			data.time = time;
			data.timed = onTime;
			data.upgrade = keystoneUpgradeLevels;
			data.oldScore = oldOverallDungeonScore;
			data.newScore = newOverallDungeonScore;
			data.completed = true;
			data.newRecord = IsAffixRecord == true or nil;
			local deaths, timeLost = C_ChallengeMode.GetDeathCount();
			data.deaths = deaths;
			data.timeLost = timeLost;
			--data.totalScore = C_ChallengeMode.GetOverallDungeonScore(); --Total score same as new score.
			C_Timer.After(2, function()
				NIT:recordKeystoneData();
			end)
		end
	elseif (event == "CHAT_MSG_LOOT") then
		NIT:chatMsgLoot(...)
	elseif (event == "ITEM_CHANGED") then
		NIT:debug("item changed");
		C_Timer.After(1, function()
			NIT:recordKeystoneData();
		end)
	elseif (event == "CHALLENGE_MODE_MAPS_UPDATE") then
		C_Timer.After(1, function()
			NIT:challengeModeMapsUpdate();
		end)
	elseif (event == "WEEKLY_REWARDS_UPDATE") then
		--Some issues with speed of update after looting vault.
		C_Timer.After(1, function()
			NIT:recordKeystoneData();
		end)
		C_Timer.After(5, function()
			NIT:checkRewards();
		end)
	end
end)

--Trim records to maxRecordsKept, can set records shown to max 500 in options, 100 is default.
function NIT:trimDatabase()
	local max = NIT.db.global.maxRecordsKept;
	for i, v in pairs(NIT.data.instances) do
		if (i > max) then
			table.remove(NIT.data.instances, i);
		end
	end
end

function NIT:trimTrades()
	local max = NIT.db.global.maxTradesKept;
	for i, v in pairs(NIT.data.trades) do
		if (i > max) then
			table.remove(NIT.data.trades, i);
		end
	end
end

function NIT:chatMsgLoot(...)
	local msg = ...;
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType,
				itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, itemClassID, itemSubClassID;
    --Get itemlink by checking all possible matches for self loot msgs and other players loot msg.
    --Check multiple msgs first so you dont end up with item links with x2 on the end.
    --Self receive multiple loot "You receive loot: [Item]x2"
    local amount;
    local name = UnitName("Player");
    local otherPlayer;
    --Self loot multiple item "You receive loot: [Item]x2"
	local itemLink, amount = strmatch(msg, string.gsub(string.gsub(LOOT_ITEM_SELF_MULTIPLE, "%%s", "(.+)"), "%%d", "(%%d+)"));
	if (not itemLink) then
 		--Self receive single loot "You receive loot: [Item]"
    	itemLink = msg:match(LOOT_ITEM_SELF:gsub("%%s", "(.+)"));
		if (not itemLink) then
 			--Self receive single item "You receive item: [Item]"
			itemLink = msg:match(LOOT_ITEM_PUSHED_SELF:gsub("%%s", "(.+)"));
		end
    end
    if (itemLink) then
    	if (string.match(itemLink, "|Hkeystone:(.+)|h") or string.match(itemLink, "item:180653")) then
    		C_Timer.After(1, function()
    			NIT:debug("looted keystone");
				NIT:recordKeystoneData(true);
			end)
			C_Timer.After(5, function()
				NIT:checkRewards();
			end)
			C_Timer.After(15, function()
				NIT:checkRewards();
			end)
    	end
    end
end

function NIT:combatLogEventUnfiltered(...)
	local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, 
			destName, destFlags, destRaidFlags, _, spellName = CombatLogGetCurrentEventInfo();
	--[[if (subEvent == "SWING_DAMAGE" or subEvent == "SPELL_DAMAGE" or subEvent == "RANGE_DAMAGE") then
		if (sourceGUID and string.match(sourceGUID, "Creature")) then
			NIT:parseGUID(nil, sourceGUID, "combatlogSourceGUID");
		elseif (destGUID and string.match(destGUID, "Creature")) then
			NIT:parseGUID(nil, destGUID, "combatlogDestGUID");
		end]]
	--elseif (subEvent == "UNIT_DIED" and UnitLevel("player") == NIT.maxLevel and string.match(destGUID, "Creature")) then
	--elseif (subEvent == "UNIT_DIED" and UnitLevel("player") == NIT.maxLevel and string.match(destGUID, "Creature")) then
	if (subEvent == "UNIT_DIED" and string.match(destGUID, "Creature")) then
		--If max level player then count mobs via death instead of xp.
		local _, _, _, _, zoneID, npcID = strsplit("-", destGUID);
		npcID = tonumber(npcID);
		if (NIT.critterCreatures[npcID]) then
			return;
		end
		NIT:countMobsFromKill(npcID);
	end
end

--[[Global XP strings.
COMBATLOG_XPGAIN_EXHAUSTION1 = "%s dies, you gain %d experience. (%s exp %s bonus)";
COMBATLOG_XPGAIN_EXHAUSTION1_GROUP = "%s dies, you gain %d experience. (%s exp %s bonus, +%d group bonus)";
COMBATLOG_XPGAIN_EXHAUSTION1_RAID = "%s dies, you gain %d experience. (%s exp %s bonus, -%d raid penalty)";
COMBATLOG_XPGAIN_EXHAUSTION2 = "%s dies, you gain %d experience. (%s exp %s bonus)";
COMBATLOG_XPGAIN_EXHAUSTION2_GROUP = "%s dies, you gain %d experience. (%s exp %s bonus, +%d group bonus)";
COMBATLOG_XPGAIN_EXHAUSTION2_RAID = "%s dies, you gain %d experience. (%s exp %s bonus, -%d raid penalty)";
COMBATLOG_XPGAIN_EXHAUSTION4 = "%s dies, you gain %d experience. (%s exp %s penalty)";
COMBATLOG_XPGAIN_EXHAUSTION4_GROUP = "%s dies, you gain %d experience. (%s exp %s penalty, +%d group bonus)";
COMBATLOG_XPGAIN_EXHAUSTION4_RAID = "%s dies, you gain %d experience. (%s exp %s penalty, -%d raid penalty)";
COMBATLOG_XPGAIN_EXHAUSTION5 = "%s dies, you gain %d experience. (%s exp %s penalty)";
COMBATLOG_XPGAIN_EXHAUSTION5_GROUP = "%s dies, you gain %d experience. (%s exp %s penalty, +%d group bonus)";
COMBATLOG_XPGAIN_EXHAUSTION5_RAID = "%s dies, you gain %d experience. (%s exp %s penalty, -%d raid penalty)";
COMBATLOG_XPGAIN_FIRSTPERSON = "%s dies, you gain %d experience.";
COMBATLOG_XPGAIN_FIRSTPERSON_GROUP = "%s dies, you gain %d experience. (+%d group bonus)";
COMBATLOG_XPGAIN_FIRSTPERSON_RAID = "%s dies, you gain %d experience. (-%d raid penalty)";
COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED = "You gain %d experience.";
COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED_GROUP = "You gain %d experience. (+%d group bonus)";
COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED_RAID = "You gain %d experience. (-%d raid penalty)";
COMBATLOG_XPGAIN_QUEST = "You gain %d experience. (%s exp %s bonus)";
COMBATLOG_XPLOSS_FIRSTPERSON_UNNAMED = "You lose %d experience.";]]

function NIT:chatMsgCombatXpGain(...)
	local text = ...;
	local xpGained = string.match(text, "%d+");
	if (xpGained) then
		if (LOCALE_koKR) then
			xpGained = string.match(text, "(%d+)의 경험치");
		end
		if (NIT.inInstance and NIT.data.instances[1]) then
			NIT.data.instances[1].xpFromChat = NIT.data.instances[1].xpFromChat + xpGained;
			if (NIT.data.instances[1].isPvp) then
				return;
			end
			NIT.data.instances[1].mobCount = NIT.data.instances[1].mobCount + 1;
		end
	else
		NIT:debug("Missing xp match:" ..  text);
	end
	currentXP = (UnitXP("player") or 0);
	maxXP = (UnitXPMax("player") or 0);
end

function NIT:countMobsFromKill(npcID)
	if (NIT.inInstance and NIT.data.instances[1]) then
		if (NIT.data.instances[1].isPvp) then
			return;
		end
		--NIT.data.instances[1].mobCount = NIT.data.instances[1].mobCount + 1;
		--Starting in this version we count mobs from the combat log even seperately as a backup.
		--And check both counts in the display, count from xp first, if no xp then check from death event.
		--This is to detect grey mobs dying from boosters that aren't NIT.maxLevel (70).
		NIT.data.instances[1].mobCountFromKill = NIT.data.instances[1].mobCountFromKill + 1;
	end
end

function NIT:chatMsgMoney(...)
	local text = ...;
	if (NIT.inInstance and NIT.data.instances[1]) then
		if (NIT.data.instances[1].isPvp) then
			return;
		end
		--local copperGained = string.match(text, "(%d+) Copper") or 0;
		--local silverGained = string.match(text, "(%d+) Silver") or 0;
		--local goldGained = string.match(text, "(%d+) Gold") or 0;
		local copperGained = string.match(text, string.gsub(COPPER_AMOUNT, "%%d", "(%%d+)")) or 0;
		local silverGained = string.match(text, string.gsub(SILVER_AMOUNT, "%%d", "(%%d+)")) or 0;
		local goldGained = string.match(text, string.gsub(GOLD_AMOUNT, "%%d", "(%%d+)")) or 0;
		local total = copperGained + (silverGained * 100) + (goldGained * 10000); --12482
		if (not NIT.data.instances[1].rawMoneyCount) then
			NIT.data.instances[1].rawMoneyCount = 0;
		end
		NIT.data.instances[1].rawMoneyCount = NIT.data.instances[1].rawMoneyCount + total;
	end
end

function NIT:chatMsgCombatFactionChange(...)
	if (not NIT.inInstance) then
		return;
	end
	if (not NIT.data.instances[1].rep) then
		NIT.data.instances[1].rep = {};
	end
	local text = ...;
	local repName, repAmount, decrease;
	--Your %s reputation has increased by %d.
	local repName, repAmount = string.match(text, string.gsub(string.gsub(FACTION_STANDING_INCREASED, "%%s", "(.+)"), "%%d", "(%%d+)"));
	--The above line doesn't work on RU clients due to declensions.
	if (LOCALE_ruRU and not repName or not repAmount) then
		--With declension.
		--Отношение |3-7(%s) к вам улучшилось на %d.
		repName, repAmount = string.match(text, "Отношение |3%-7%((.+)%) к вам улучшилось на (%d+).");
		if (LOCALE_ruRU and not repName or not repAmount) then
			--Without declension as a backup just incase.
			repName, repAmount = string.match(text, "Отношение (.+) к вам улучшилось на (%d+).");
		end
	end
	--Faction decrease.
	if (not repName or not repAmount) then
		repName, repAmount = string.match(text, string.gsub(string.gsub(FACTION_STANDING_DECREASED, "%%s", "(.+)"), "%%d", "(%%d+)"));
		decrease = true;
		if (LOCALE_ruRU and not repName or not repAmount) then
			--With Declension.
			--Отношение |3-7(%s) к вам ухудшилось на %d.
			repName, repAmount = string.match(text, "Отношение |3%-7%((.+)%) к вам ухудшилось на (%d+).");
			if (LOCALE_ruRU and not repName or not repAmount) then
				--Without Declension as a backup just incase.
				repName, repAmount = string.match(text, "Отношение (.+) к вам ухудшилось на (%d+).");
			end
		end
	end
	if (not repName or not repAmount) then
		NIT:debug("Faction error:", text);
		return;
	end
	if (not NIT.data.instances[1].rep[repName]) then
		NIT.data.instances[1].rep[repName] = 0
	end
	if (decrease) then
		NIT.data.instances[1].rep[repName] = NIT.data.instances[1].rep[repName] - repAmount;
	else
		NIT.data.instances[1].rep[repName] = NIT.data.instances[1].rep[repName] + repAmount;
	end
end

function NIT:chatMsgCombatHonorGain(...)
	if (not NIT.inInstance or NIT.data.instances[1].type ~= "bg") then
		return;
	end
	if (not NIT.data.instances[1].honor) then
		NIT.data.instances[1].honor = 0;
	end
	local text = ...;
	local honorGained = string.match(text, "%d+");
	if (not honorGained) then
		NIT:debug("Honor error:", text);
		return;
	end
	NIT.data.instances[1].honor = NIT.data.instances[1].honor + honorGained;
end

function NIT:playerEnteringWorld(...)
	local isLogon, isReload = ...;
	--On rare occasions you PLAYER_ENTERING_WORLD as a ghost still instead of unghosting beforehand.
	local isInstance, instanceType = IsInInstance();
	if (isInstance) then
		if (isReload) then
			C_Timer.After(0.5, function()
				NIT:enteredInstance(true);
			end)
		elseif (isLogon) then
			C_Timer.After(0.5, function()
				NIT:enteredInstance(nil, true);
			end)
		else
			C_Timer.After(0.5, function()
				if (isInstance) then
					NIT:enteredInstance();
				end
			end)
		end
	elseif (NIT.inInstance and not isReload) then
		NIT:leftInstance();
	end
end

function NIT:playerLeavingWorld(...)
	--Moved to PEW, some people had a chat reconnect delay that stopped the stats working.
	--if (NIT.inInstance) then
		--NIT:leftInstance();
	--end
end

function NIT:playerLogout(...)
	if (NIT.inInstance) then
		NIT:leftInstance();
	end
end

function NIT:recordBgStats()
	if (not NIT.inInstance) then
		return;
	end
	local instance = NIT.data.instances[1];
	local totalPlayers = GetNumBattlefieldScores();
	--local mapID = C_Map.GetBestMapForUnit("player");
	if (NIT.data.instances[1].type == "bg") then
		for i = 1, totalPlayers do
			local name, kb, hk, deaths, honor, faction, rank, race, class, classEnglish, damage, healing = GetBattlefieldScore(i);
			--local rankName, rankNumber = GetPVPRankInfo(rank, faction);
			--Record me only.
			local me = UnitName("player");
			if (name == me) then
				instance.kb = kb;
				instance.hk = hk;
				instance.deaths = deaths;
				--instance.bonusHonor = honor;
				instance.faction = faction;
				--instance.classEnglish = classEnglish;
				instance.damage = damage;
				instance.healing = healing;
				local objectives = {};
				for j = 1, GetNumBattlefieldStats() do
					local score = GetBattlefieldStatData(i, j);
					if (score and score > 0) then
						local text, icon = GetBattlefieldStatInfo(j);
						--Icons textures end in 0 or 1 for each faction.
						--We want to display the right color for our real faction and not same faction vs same faction wrong side.
						--[[if (NIT.faction == "Horde") then
							icon = icon .. "1";
						else
							icon = icon .. "0";
						end]]
						icon = icon .. faction;
						local t = {
							score = score,
							text = text,
							icon = icon,
						};
						table.insert(objectives, t);
						--/run NIT.data.instances[1].objectives = {}
						--/run NIT.data.instances[1].objectives[1] = {score = 3,text = "Flag Captures",icon = "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture0"};
					end
				end
				if (next(objectives)) then
					instance.objectives = objectives;
				end
			end
		end
		if (GetBattlefieldWinner() == 0) then
			--Horde won.
			instance.winningFaction = 0;
		elseif (GetBattlefieldWinner() == 1) then
			--Alliance won.
			instance.winningFaction = 1;
		end
	elseif (NIT.data.instances[1].type == "arena") then
		local purpleTeam, goldTeam = {}, {};
		for i = 1, totalPlayers do
			local name, kb, hk, deaths, honor, faction, rank, race, class, classEnglish, damage, healing = GetBattlefieldScore(i);
			--Record all players.
			local me = UnitName("player");
			if (name) then
				local t = {
					kb = kb,
					faction = faction,
					class = classEnglish,
					damage = damage,
					healing = healing,
					race = race,
				};
				local teamName, teamRating, newTeamRating, teamMMR = GetBattlefieldTeamInfo(faction);
				--if (NIT.isTBC) then
					if (teamName) then
						t.teamName = teamName;
					end
					if (teamRating) then
						t.teamRating = teamRating;
					end
					if (newTeamRating) then
						t.newTeamRating = newTeamRating;
					end
				--end
				if (teamMMR) then
					t.teamMMR = teamMMR;
				end
				if (faction == 0) then
					if (teamName == "" and instance.purpleTeam and instance.purpleTeam[name] and instance.purpleTeam[name].teamName) then
						--If team name is showing an empty string but we already have a team name recorded then use the already recorded name instead and don't overwrite.
						t.teamName = instance.purpleTeam[name].teamName;
					end
					purpleTeam[name] = t;
				else
					if (teamName == "" and instance.goldTeam and instance.goldTeam[name] and instance.goldTeam[name].teamName) then
						t.teamName = instance.goldTeam[name].teamName;
					end
					goldTeam[name] = t;
				end
				if (name == me) then
					instance.faction = faction;
				end
			end
		end --/tinspect NIT.data.instances[1]
		if (GetBattlefieldWinner() == 0) then
			--Purple team won.
			instance.winningFaction = 0;
		elseif (GetBattlefieldWinner() == 1) then
			--Gold team won.
			instance.winningFaction = 1;
		end
		--No winner name means a draw.
		local drawName;
		--I've seen one time GetBattlefieldWinner() be nil when not a draw so had to add a check here.
		if (GetBattlefieldWinner()) then
			local drawName = GetBattlefieldTeamInfo(GetBattlefieldWinner());
			if (not drawName) then
				instance.draw = true;
			end
		end
		if (next(purpleTeam)) then
			instance.purpleTeam = purpleTeam;
		end
		if (next(goldTeam)) then
			instance.goldTeam = goldTeam;
		end
	end
	--instance.pvpStats = stats;
	NIT:recordGroupInfo();
end
if (NIT.expansionNum < 4) then
	hooksecurefunc("WorldStateScoreFrame_OnShow", function(...) NIT:recordBgStats() end);
end

--Seems to be some issue with it not recording as an arena if we check before the zone data is upedated properly in blizz's end?
local function doubleCheckArena()
	if (NIT.isTBC and NIT.inInstance) then
		if (NIT:isInArena()) then
			NIT.data.instances[1].type = "arena";
		end
	end
end

--This frame is only used for same instance detection and disabled after first event after entering.
--Changed to it's own frame for disabling to see if it makes a performance difference.
local instanceDetectionFrame = CreateFrame("Frame");
instanceDetectionFrame:SetScript('OnEvent', function(self, event, ...)
	local _, subEvent, _, sourceGUID, _, _, _, destGUID = CombatLogGetCurrentEventInfo();
	if (subEvent == "SWING_DAMAGE" or subEvent == "SPELL_DAMAGE" or subEvent == "RANGE_DAMAGE") then
		if (sourceGUID and string.match(sourceGUID, "Creature")) then
			NIT:parseGUID(nil, sourceGUID, "combatlogSourceGUID");
			instanceDetectionFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		elseif (destGUID and string.match(destGUID, "Creature")) then
			NIT:parseGUID(nil, destGUID, "combatlogDestGUID");
			instanceDetectionFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		end
	end
end)

--No API available to get alpha/beta/gamma difficulty yet.
--[[local function getDungeonSubDifficulty()
	if (IsInInstance()) then
		local diff;
		--wtb dungeon api for these new difficulties.
		NIT:print("Getting dungeon difficulty:", diff);
		return diff;
	end
end

function NIT:updateCurrentDungeonSubDifficulty()
	if (IsInInstance()) then
		local diff = getDungeonSubDifficulty();
		if (diff) then
			NIT.data.instances[1].subDifficulty = diff;
			NIT:debug("Updated dungeon sub difficulty.");
		end
	end
end]]

--Get dungeon sub difficulty by scanning npc buffs instead.
local subDiffculties = {
	--Gamma dungs.
	[424205] = "gamma", --Gamma Empowered: Titan Rune
	[424203] = "gamma", --Gamma Empowered: Blood Rune
	[424210] = "gamma", --Gamma Empowered: Plague Rune
	[424196] = "gamma", --Gamma Empowered: Arcane Rune
	[424211] = "gamma", --Gamma Empowered: Gladiator Rune
	[424194] = "gamma", --Gamma Empowered: Frost Rune
	[424201] = "gamma", --Gamma Empowered: Shadow Rune
	--Beta dungs.
	[413573] = "beta", --Beta Empowered: Gladiator Rune
	[412770] = "beta", --Beta Empowered: Frost Rune
	[412991] = "beta", --Beta Empowered: Arcane Rune
	[412867] = "beta", --Beta Empowered: Plague Rune
	[413169] = "beta", --Beta Empowered: Blood Rune
	[412470] = "beta", --Beta Empowered: Shadow Rune
	--Alpha dungs.
	[394441] = "alpha", --Alpha Empowered: Titan Rune
	[392430] = "alpha", --Alpha Empowered: Frost Rune
	[394444] = "alpha", --Alpha Empowered: Plague Rune
	[394435] = "alpha", --Alpha Empowered: Arcane Rune
	[394437] = "alpha", --Alpha Empowered: Shadow Rune
	[394438] = "alpha", --Alpha Empowered: Blood Rune
};
function NIT:scanDungeonSubDifficulty()
	--Only scan once if we found it.
	if (NIT.inInstance and not NIT.data.instances[1].subDifficulty) then
		local found;
		local guid = UnitGUID("target");
		if (guid and string.match(guid, "Creature")) then
			for i = 1, 10 do
				local name, _, _, _, _, _, _, _, _, spellID = UnitBuff("target", i);
				if (name) then
					if (subDiffculties[spellID]) then
						NIT.data.instances[1].subDifficulty = subDiffculties[spellID];
						NIT:debug("Updated dungeon sub difficulty:", subDiffculties[spellID]);
						found = true;
					elseif (string.match(name, "Gamma Empowered: %w+ Rune")) then
						--English backups so if they add more it will atleast work for english client without updates.
						NIT.data.instances[1].subDifficulty = "gamma";
						found = true;
					elseif (string.match(name, "Beta Empowered: %w+ Rune")) then
						NIT.data.instances[1].subDifficulty = "beta";
						found = true;
					elseif (string.match(name, "Alpha Empowered: %w+ Rune")) then
						NIT.data.instances[1].subDifficulty = "alpha";
						found = true;
					end
				else
					break;
				end
			end
		end
		if (found and NIT.data.instances[1].subDifficulty == "gamma" and NIT.db.global.autoGammaBuffReminder)then
			--If we don't have a buff already then remind us, should only fire once per dung.
			local hasBuff;
			local gammaBuffs = {
				[424400] = true, --Melee.
				[424403] = true, --Ranged.
				[424405] = true, --Healer.
				[424407] = true, --Tank.
			};
			for i = 1, 32 do
				local _, _, _, _, _, _, _, _, _, spellID = UnitBuff("player", i);
				if (spellID) then
					if (gammaBuffs[spellID]) then
						hasBuff = true;
						break;
					end
				else
					break;
				end
			end
			if (not hasBuff) then
				local npcType;
				if (NIT.faction == "Horde") then
					npcType = L["Sunreaver Warden"];
				else
					npcType = L["Silver Covenant Warden"];
				end
				NIT:print("|cFF00FF00" .. string.format(L["autoGammaBuffReminder"], npcType), nil, "[NIT Reminder]");
				local colorTable = {r = 1, g = 0.96, b = 0.41, id = 41, sticky = 0};
				RaidNotice_AddMessage(RaidWarningFrame, NIT.prefixColor .. "[NIT Reminder]:|r |cFF00FF00" .. string.format(L["autoGammaBuffReminder"], npcType), colorTable, 6);
			end
		end
	end
end

function test()
	local npcType;
	if (NIT.faction == "Horde") then
		npcType = L["Sunreaver Warden"];
	else
		npcType = L["Silver Covenant Warden"];
	end
	NIT:print("|cFF00FF00" .. string.format(L["autoGammaBuffReminder"], npcType), nil, "[NIT Reminder]");
	local colorTable = {r = 1, g = 0.96, b = 0.41, id = 41, sticky = 0};
	RaidNotice_AddMessage(RaidWarningFrame, NIT.prefixColor .. "[NIT Reminder]:|r |cFF00FF00" .. string.format(L["autoGammaBuffReminder"], npcType), colorTable, 6);
end

local isGhost = false;
NIT.lastInstanceName = "(Unknown Instance)";
local doneFirstGUIDCheck;
function NIT:enteredInstance(isReload, isLogon, checkAgain)
	doGUID = true;
	local instance, instanceType = IsInInstance();
	local type;
	--instanceType was showing "pvp" at the start of tbc, now it shows "arena".
	--Leave some redunant checks here in place anyway incase it ever reverts back.
	if (instanceType == "pvp" or instanceType == "arena") then
		if (NIT:isInArena() or instanceType == "arena") then
			type = "arena";
		elseif (UnitInBattleground("player")) then
			type = "bg";
		end
		if (not type and not checkAgain) then
			--Sometimes UnitInBattleground() is slow to return true after PEW.
			--So recheck after a couple of seconds if we're in a pvp instance and both arena and bg wern't found.
			NIT:debug("PvP type not found, rechecking.");
			C_Timer.After(2, function()
				NIT:enteredInstance(isReload, isLogon, true);
			end)
			return;
		end
	end
	if (checkAgain) then
		NIT:debug("Rechecked Instance:", instance, "Type:", instanceType, NIT:isInArena(), UnitInBattleground("player"));
	end
	if (instance == true and ((instanceType == "party") or (instanceType == "raid")
			or (type == "bg") or (type == "arena"))) then
		local instanceName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty,
				isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo();
		if (NIT.inInstance and NIT.lastInstanceName ~= instanceName) then
			--If we zone from one instance into another instance and the instance name if different (UBRS to BWL etc).
			--Close out the old instance data before starting a new.
			NIT:leftInstance();
		end
		NIT.lastInstanceName = instanceName;
		if (not instanceName) then
			instanceName = "(Instance Name Not Found)";
		end
		local instanceNameMsg = instanceName;
		if (difficultyID == 174) then
			instanceNameMsg = instanceNameMsg .. " |cFF9CD6DE(|r|cFFFF2222H|r|cFF9CD6DE)|r";
		end
		if (isGhost) then
			--This never worked and doesn't need to anyway.
			--if (NIT.db.global.enteredMsg) then
			--	local texture = "|TInterface\\AddOns\\NovaInstanceTracker\\Media\\greenTick:12:12:0:0|t";
				--NIT:print("Entered " .. instanceName .. " as ghost, not recording new instance. "
				--		.. "If you would like to force record a new instance click |HNITCustomLink:deletelast|h" .. texture .. "|h");
			--end
		else
			if (not isReload) then
				local class, classEnglish = UnitClass("player");
				local t = {
					playerName = UnitName("player"),
					class = class,
					classEnglish = classEnglish,
					instanceName = instanceName,
					instanceID = instanceID,
					difficultyID = difficultyID,
					type = type,
					enteredTime = GetServerTime(),
					enteredLevel = UnitLevel("player");
					enteredXP = UnitXP("player");
					enteredMoney = GetMoney(),
					leftTime = 0,
					leftMoney = 0,
					mobCount = 0,
					mobCountFromKill = 0,
					rawMoneyCount = 0,
					xpFromChat = 0,
					group = {},
					rep = {},
				};
				--No API available to get alpha/beta/gamma difficulty yet.
				--t.subDifficulty = getDungeonSubDifficulty();
				if (type == "bg") then
					t.honor = 0;
				end
				if (type == "bg" or type == "arena") then
					t.isPvp = true;
				end
				if (t.isPvp) then
					--No need to store certain things for pvp instances.
					t.difficultyID = nil;
					--t.enteredLevel = nil;
					--t.enteredXP = nil;
					t.enteredMoney = nil;
					t.rawMoneyCount = nil;
					--t.xpFromChat = nil;
					t.mobCount = nil;
					--t.mobCountFromKill = nil;
					C_Timer.After(2, function()
						doubleCheckArena();
					end)
				end
				--NIT:debug("entered", UnitLevel("player"));
				--if (NIT.isDebug) then
				--	t.GUIDList = {};
				--end
				--This should really be called noLockout instead of raid but not changing it or the local string now.
				local raid;
				if (NIT.noRaidLockouts and instanceID and NIT.zones[instanceID] and NIT.zones[instanceID].noLockout) then
					raid = true;
				end
				--Insert as first row, instances are stored newest first in the data table.
				table.insert(NIT.data.instances, 1, t);
				local texture = "|TInterface\\AddOns\\NovaInstanceTracker\\Media\\redX2:12:12:0:0|t";
				local hourCount, hourCount24, hourTimestamp, hourTimestamp24 = NIT:getInstanceLockoutInfo();
				local countMsg = "(" .. NIT.prefixColor .. hourCount .. "|r" .. NIT.chatColor .. " " .. L["thisHour"] .. ")";
				if (t.isPvp) then
					if (NIT.db.global.pvpEnteredMsg) then
						local msg = string.format(L["enteredDungeon"], instanceNameMsg, "");
						msg = string.gsub(msg, " , ", ", ")
						C_Timer.After(0.5, function()
							--local hourCount, hourCount24, hourTimestamp, hourTimestamp24 = NIT:getInstanceLockoutInfo();
							NIT:print("|HNITCustomLink:instancelog|h" .. msg .. "|h"
									.. "|HNITCustomLink:deletelast|h" .. texture
									.. "|h |HNITCustomLink:instancelog|h" .. L["enteredDungeon2"] .. "|h");
						end)
					end
				elseif (raid) then
					if (NIT.db.global.raidEnteredMsg) then
						C_Timer.After(0.5, function()
							NIT:print("|HNITCustomLink:instancelog|h" .. string.format(L["enteredRaid"], instanceNameMsg) .. "|h");
						end)
					end
				elseif (isLogon) then
					C_Timer.After(3, function()
						--local hourCount, hourCount24, hourTimestamp, hourTimestamp24 = NIT:getInstanceLockoutInfo();
						NIT:print("|HNITCustomLink:instancelog|h" .. string.format(L["loggedInDungeon"], instanceNameMsg, countMsg) .. "|h"
								.. " |HNITCustomLink:deletelast|h" .. texture
								.. "|h |HNITCustomLink:instancelog|h " .. L["loggedInDungeon2"] .. "|h");
					end)
				else
					if (NIT.db.global.enteredMsg) then
						C_Timer.After(0.5, function()
							--local hourCount, hourCount24, hourTimestamp, hourTimestamp24 = NIT:getInstanceLockoutInfo();
							NIT:print("|HNITCustomLink:instancelog|h" .. string.format(L["enteredDungeon"], instanceNameMsg, countMsg) .. "|h"
									.. "|HNITCustomLink:deletelast|h" .. texture
									.. "|h |HNITCustomLink:instancelog|h" .. L["enteredDungeon2"] .. "|h");
						end)
					end
				end
				--Changed to when targeting a mob at start of dung.
				--[[if (t.subDifficulty == "gamma" and NIT.db.global.autoGammaBuffReminder) then
					C_Timer.After(3, function()
						NIT:print("|cFF00FF00Gamma Dungeon:|r " .. L["autoGammaBuffReminder"]);
					end)
				end]]
			elseif (isReload) then
				C_Timer.After(3, function()
					local texture = "|TInterface\\AddOns\\NovaInstanceTracker\\Media\\redX2:12:12:0:0|t";
					local hourCount, hourCount24, hourTimestamp, hourTimestamp24 = NIT:getInstanceLockoutInfo();
					local countMsg = "(" .. NIT.prefixColor .. hourCount .. NIT.chatColor .. " " .. L["thisHour"] .. ")";
					NIT:print(string.format(L["reloadDungeon"], countMsg));
				end)
			end
			C_Timer.After(0.5, function()
				NIT.inInstance = GetServerTime();
			end)
			--NIT.lastInstanceID = #NIT.data.instances + 1;
			--NIT.data.instances[NIT.lastInstanceID] = t;
			isGhost = false;
			NIT:trimDatabase();
			NIT:addInstanceCount(instanceID);
			local type = "unknown";
			if (instanceID and NIT.zones[instanceID] and NIT.zones[instanceID].type) then
					type = NIT.zones[instanceID].type;
			end
			NIT:pushInstanceEntered(instanceName, instanceID, type, isReload, isLogon);
			doneFirstGUIDCheck = nil;
			instanceDetectionFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		end
		C_Timer.After(1, function()
			NIT:recordGroupInfo();
		end)
		C_Timer.After(30, function()
			NIT:recordGroupInfo();
		end)
	end
end

function NIT:leftInstance()
	if (NIT.inInstance and NIT.data.instances[1]) then
		local isPvp = NIT.data.instances[1].isPvp
		NIT.data.instances[1]["leftTime"] = GetServerTime();
		if (not isPvp) then
			NIT.data.instances[1]["leftLevel"] = UnitLevel("player");
			NIT.data.instances[1]["leftXP"] = UnitXP("player");
			NIT.data.instances[1]["leftMoney"] = GetMoney();
		end
		--NIT:debug("left", UnitLevel("player"));
		--Don't show party stats if bg or arena, only self.
		if (not isPvp or NIT.db.global.instanceStatsOutputWhere == "self") then
			NIT:showInstanceStats();
		end
		NIT:pushInstanceLeft(NIT.data.instances[1].instanceName, NIT.data.instances[1].instanceID);
	end
	C_Timer.After(5, function()
		NIT:recordKeystoneData();
	end)
	NIT.inInstance = nil;
	NIT.lastNpcID = 999999999;
	NIT.lastInstanceName = "(Unknown Instance)";
	if (NITAUTORESET) then
	print(1)
		if (NIT.data.instances[1] and NIT.data.instances[1].mobCount and NIT.data.instances[1].mobCount > 10) then
print(2)
			C_Timer.After(2, function()
				if (UnitIsGroupLeader("player") and not IsInInstance() and not UnitIsGhost("player")) then
print(3)
					local msg = "Auto resetting dungeons.";
					if (IsInGroup()) then
			  			NIT:sendGroup("[NIT] " .. msg);
					else
						NIT:print(NIT.prefixColor .. msg);
					end
					ResetInstances();
				end
			end)
		end
	end
end

function NIT:showInstanceStats(id, output, showAll, customPrefix, showDate)
	if (not id) then
		id = 1;
	end
	if (not NIT.data.instances[id]) then
		NIT:print(string.format(L["statsError"], id));
		return;
	end
	local data = NIT.data.instances[id];
	local level = data.enteredLevel or UnitLevel("player");
	local timeSpent = "";
	local timeSpentRaw = 0;
	if (data.enteredTime and data.leftTime and data.enteredTime > 0 and data.leftTime > 0) then
		timeSpentRaw = data.leftTime - data.enteredTime;
	elseif (data.enteredTime and data.leftTime and data.enteredTime > 0 and (GetServerTime() - data.enteredTime) < 21600
			--Make sure we're not checking /nit stats while still inside an instance we have re-entered and recorded a leave time.
			and not NIT.inInstance) then
		timeSpentRaw = GetServerTime() - data.enteredTime;
	end
	if ((not data.leftTime or data.leftTime == 0) or NIT.inInstance) then
		timeSpent = NIT:getTimeString(GetServerTime() - data.enteredTime, true, true);
	else
		timeSpent = NIT:getTimeString(data.leftTime - data.enteredTime, true, true);
	end
	--local timeSpent = NIT:getTimeString(data.leftTime - data.enteredTime, true, true);
	--UnitLevel("player") == NIT.maxLevel
	--local pColor, sColor = "|cFF9CD6DE", "|cFFc3e6eb";
	local pColor, sColor = "|cFFFFFFFF", "|cFF9CD6DE";
	--local text = "(" .. NIT.lastInstanceName .. ")";
	--local text = pColor;
	--local text = sColor .. NIT.lastInstanceName;
	local text = sColor .. data.instanceName .. "|r";
	if (data.subDifficulty) then
		text = sColor .. data.instanceName .. " (|cFFFF2222" .. gsub(data.subDifficulty, "^%l", string.upper) .. "|r)|r"; 
	end
	local mobCount = 0;
	local money = 0;
	if (showDate) then
		local dateString;
		local useTime = data.enteredTime;
		if (data.leftTime and data.leftTime > 0) then
			useTime = data.leftTime;
		end
		if (GetServerTime() - useTime < 86400) then
			--If within last 24h then show as time ago instead of date.
			local timeAgo = GetServerTime() - useTime;
			dateString = "|cFFFFFFFF(" .. NIT:getTimeString(timeAgo, true, "short") .. " " .. L["ago"] .. ")|r";
		else
			dateString = "|cFFFFFFFF(" .. NIT:getTimeFormat(useTime, true, true) .. ")|r";
		end
		text = dateString .. " " .. text;
	end
	if (data.isPvp) then
		if (data.type == "bg") then
			text = text .. pColor .. " " .. L["Honor"] .. ":|r " .. sColor .. (data.honor or 0) .. "|r";
			if (NIT.db.global.instanceStatsOutputHK) then
				text = text .. pColor .. " " .. L["HKs"] .. ":|r " .. sColor .. (data.hk or 0) .. "|r";
			end
		end
		if (not NIT.isClassic and not NIT.isTBC and data.type ~= "arena") then
			if ((NIT.db.global.instanceStatsOutputXP or showAll) and level ~= NIT.maxLevel) then
				text = text .. pColor .. " " .. L["statsXP"] .. "|r " .. sColor .. NIT:commaValue(data.xpFromChat) .. "|r";
			end
		end
	else
		--Check both count from xp and count from combat log event.
		--So it works for boosters that mobs are grey and people out of range of combat event but still get xp.
		if (data.mobCount and data.mobCount > 0) then
			mobCount = data.mobCount;
		elseif (data.mobCountFromKill and data.mobCountFromKill > 0) then
			mobCount = data.mobCountFromKill;
		end
		if (NIT.db.global.instanceStatsOutputMobCount or showAll) then
			--text = text .. " |cFF9CD6DEMobs: " .. data.mobCount;
			text = text .. pColor .. " " .. L["statsMobs"] .. "|r " .. sColor .. mobCount .. "|r";
		end
		if ((NIT.db.global.instanceStatsOutputXP or showAll) and level ~= NIT.maxLevel) then
			text = text .. pColor .. " " .. L["statsXP"] .. "|r " .. sColor .. NIT:commaValue(data.xpFromChat) .. "|r";
		end
		if ((NIT.db.global.instanceStatsOutputXpPerHour or showAll) and level ~= NIT.maxLevel) then
			if (timeSpentRaw and timeSpentRaw > 0 and tonumber(data.xpFromChat) and data.xpFromChat > 0) then
				local xpPerHour = NIT:commaValue(NIT:round((tonumber(data.xpFromChat) / timeSpentRaw) * 3600));
				text = text .. pColor .. " " .. L["experiencePerHour"] .. ":|r " .. sColor .. xpPerHour .. "|r";
			end
		end
		if ((NIT.db.global.instanceStatsOutputAverageXP or showAll) and level ~= NIT.maxLevel) then
			--if (data.xpFromChat and data.xpFromChat > 0 and data.mobCount and data.mobCount > 0) then
			if (data.xpFromChat and data.xpFromChat > 0) then
				local averageXP = data.xpFromChat / mobCount;
				text = text .. pColor .. " " .. L["statsAverageXP"] .. "|r " .. sColor .. NIT:commaValue(NIT:round(averageXP, 2)) .. "|r";
			else
				text = text .. pColor .. " " .. L["statsAverageXP"] .. "|r " .. sColor .. "0|r";
			end
		end
	end
	if (NIT.db.global.instanceStatsOutputTime or showAll) then
		text = text .. pColor .. " " .. L["statsTime"] .. "|r " .. sColor .. timeSpent .. "|r";
	end
	if (not data.isPvp) then
		if ((NIT.db.global.instanceStatsOutputAverageGroupLevel or showAll) and data.groupAverage) then
			text = text .. pColor .. " " .. L["statsAverageGroupLevel"] .. "|r " .. sColor .. NIT:round(data.groupAverage, 2) .. "|r";
		end
		--Don't send gold to group chat.
		if ((NIT.db.global.instanceStatsOutputGold and NIT.db.global.instanceStatsOutput ~= "group") or showAll) then
			if (data.rawMoneyCount and data.rawMoneyCount > 0) then
				money = data.rawMoneyCount;
			elseif (data.enteredMoney and data.leftMoney and data.enteredMoney > 0 and data.leftMoney > 0) then
				--Backup for people with addons installed using an altered money string.
				money = data.leftMoney - data.enteredMoney;
			end
			text = text .. pColor .. " " .. L["statsGold"] .. "|r " .. sColor .. NIT:convertMoney(money, true, "", true, sColor) .. "|r";
		end
		if (id == 1 and data.xpFromChat and data.xpFromChat > 0) then
			if (currentXP == 0) then
				currentXP = (UnitXP("player") or 0);
			end
			if (maxXP == 0) then
				maxXP = (UnitXPMax("player") or 0);
			end
			--Will add rested xp left calcs in to this later.
			--local restedXP = (GetXPExhaustion() or 0);
			--local percent = NIT:round((data.xpFromChat/maxXP) * 100);
			local runsPerLevel = NIT:round(maxXP / data.xpFromChat, 1);
			local runsToLevel = NIT:round((maxXP - currentXP) / data.xpFromChat, 1);
			if ((NIT.db.global.instanceStatsOutputRunsPerLevel or showAll) and runsPerLevel > 0) then
				text = text .. pColor .. " " .. L["statsRunsPerLevel"] .. "|r " .. sColor .. runsPerLevel .. "|r";
			end
			if ((NIT.db.global.instanceStatsOutputRunsNextLevel or showAll) and runsToLevel > 0) then
				text = text .. pColor .. " " .. L["statsRunsNextLevel"] .. "|r " .. sColor .. runsToLevel .. "|r";
			end
		end
	end
	if (NIT.db.global.instanceStatsOutputRep or showAll) then
		local repText = "";
		if (data.rep and next(data.rep)) then
			for k, v in NIT:pairsByKeys(data.rep) do
				if (v > 0) then
					v = "+" .. NIT:commaValue(v);
				else
					v = "-" .. NIT:commaValue(v);
				end
				repText = repText .. "(" .. k .. " " .. v .. ")";
			end
		end
		if (repText ~= "") then
			text = text .. pColor .. " " .. L["statsRep"] .. "|r " .. sColor .. repText .. "|r";
		end
	end
	if (output) then
		local prefix = "Last Dungeon";
		if (customPrefix) then
			prefix = customPrefix;
		else
			if (NIT.inInstance and id == 1) then
				prefix = "Current Dungeon";
			end
		end
		if (output == "copypaste") then
			NIT:openNITCopyFrame("[NIT] " .. NIT:stripColors(prefix.. " " .. text));
		elseif (output == "group") then
			if (IsInGroup()) then
	  			NIT:sendGroup("[NIT] " .. NIT:stripColors(prefix.. " " .. text));
			else
				NIT:print(NIT.prefixColor .. prefix.. " " .. text);
			end
		elseif (output == "say" or output == "yell" or output == "party" or output == "guild"
			or output == "officer" or output == "raid") then
			if (output == "raid" and not IsInRaid()) then
				NIT:print("You are not in a raid.");
				return;
		  	elseif (output == "party" and not IsInGroup()) then
		  		NIT:print("You are not in a party.");
		  		return;
			end
			SendChatMessage("[NIT] " .. NIT:stripColors(prefix.. " " .. text), string.upper(output));
		elseif (output == "self") then
			NIT:print(NIT.prefixColor .. prefix.. " " .. text);
		elseif (output == "send") then
			--If no channel was specified run the normal output with added prefix.
			if (NIT.db.global.instanceStatsOutputWhere == "group") then
				if (IsInRaid()) then
					if (NIT.db.global.showStatsInRaid) then
		  				SendChatMessage("[NIT] " .. NIT:stripColors(prefix.. " " .. text), "RAID");
		  			elseif (NIT.db.global.printRaidInstead) then
		  				NIT:print(NIT.prefixColor .. prefix.. " " .. text);
		  			end
		  		elseif (IsInGroup()) then
		  			SendChatMessage("[NIT] " .. NIT:stripColors(prefix.. " " .. text), "PARTY");
				end
			else
				NIT:print(NIT.prefixColor .. prefix.. " " .. text);
			end
		end
	elseif (not NIT.db.global.statsOnlyWhenActivity or ((data.xpFromChat and data.xpFromChat > 0)
			or mobCount > 0 or tonumber(money) > 0)) then
		C_Timer.After(0.7, function()
			if (NIT.db.global.instanceStatsOutput and NIT.db.global.instanceStatsOutputWhere == "group") then
				if (IsInRaid()) then
					if (NIT.db.global.showStatsInRaid) then
		  				SendChatMessage("[NIT] " .. NIT:stripColors(text), "RAID");
		  			elseif (NIT.db.global.printRaidInstead) then
		  				NIT:print(text);
		  			end
		  		elseif (IsInGroup()) then
		  			SendChatMessage("[NIT] " .. NIT:stripColors(text), "PARTY");
				end
			elseif (NIT.db.global.instanceStatsOutput) then
				--NIT:print(text, nil, "[" .. NIT.lastInstanceName .. "]");
				NIT:print(text);
			end
		end)
	end
end

function NIT:addInstanceCount(instanceID)
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	if (not NIT.data.myChars[char].instances) then
		NIT.data.myChars[char].instances = {};
	end
	if (not NIT.data.myChars[char].instances[instanceID]) then
		NIT.data.myChars[char].instances[instanceID] = 0;
	end
	NIT.data.myChars[char].instances[instanceID] = NIT.data.myChars[char].instances[instanceID] + 1;
end

function NIT:removeInstanceCount(instanceID)
	local char = UnitName("player");
	if (NIT.data.myChars[char] and NIT.data.myChars[char].instances and NIT.data.myChars[char].instances[instanceID]
			and NIT.data.myChars[char].instances[instanceID] > 0) then
		NIT.data.myChars[char].instances[instanceID] = NIT.data.myChars[char].instances[instanceID] - 1;
	end
end

NIT.lastNpcID = 999999999;
function NIT:parseGUID(unit, GUID, source)
	--Don't merge pvp instances, zoneids can come from temporary pets with a creature guid.
	if (NIT.data.instances[1] and NIT.data.instances[1].isPvp) then
		return;
	end
	if (not GUID) then
		GUID = UnitGUID(unit);
	end
	if (GUID and doGUID and NIT.inInstance and (not string.match(source, "combatlog") or GetServerTime() - NIT.inInstance > 2)) then
		local unitType, _, _, _, zoneID, npcID = strsplit("-", GUID);
		local zoneID = tonumber(zoneID);
		if (unitType ~= "Creature" or NIT.companionCreatures[tonumber(npcID)]) then
			--NIT:debug("not a creature");
			return;
		end
		--[[if (NIT.isDebug) then
			if (not NIT.data.instances[1].GUIDList) then
				NIT.data.instances[1].GUIDList = {};
			end
			local data = (GUID or "nil");
			NIT.data.instances[1].GUIDList[data] = true;
		end]]
		NIT.lastNpcID = npcID;
		if (zoneID and zoneID > 0 and NIT.data.instances[1]) then
			---Trying a few different things here to work out some bugs.
			---The next step if these don't work will be creating NPC whitelists.

			--Only merge if current GUID isn't set (first GUID of the instance).
			if (NIT.data.instances[2] and NIT.data.instances[2]["zoneID"] and NIT.data.instances[2]["zoneID"] == zoneID
					and not NIT.data.instances[1].zoneID) then
					--and (not NIT.data.instances[1].zoneID or NIT.data.instances[1].zoneID < 1)) then
					
			--Oirignal version
			--if (NIT.data.instances[2] and NIT.data.instances[2]["zoneID"] and NIT.data.instances[2]["zoneID"] == zoneID) then
				if (NIT.db.global.detectSameInstance) then
					--NIT:debug("OldGUID:", NIT.data.instances[2].GUID, "NewGUID:", GUID, source);
					--NIT:debug("OldZoneID:", NIT.data.instances[2]["zoneID"], "NewZoneID:", zoneID, source);
					--Merge instances data and then delete last.
					NIT:mergeLastInstances(GUID, source);
					local texture = "|TInterface\\AddOns\\NovaInstanceTracker\\Media\\redX2:12:12:0:0|t";
					local hourCount, hourCount24, hourTimestamp, hourTimestamp24 = NIT:getInstanceLockoutInfo();
					local countMsg = "(" .. NIT.prefixColor .. hourCount .. "|r" .. NIT.mergeColor .. " " .. L["thisHour"] .. ")";
					C_Timer.After(0.7, function()
						local isInstance, instanceType = IsInInstance();
						if (instanceType ~= "raid" or not NIT.db.global.noRaidInstanceMergeMsg) then
							NIT:print(NIT.mergeColor .. string.format(L["sameInstance"], countMsg));
						end
					end)
				end
			elseif (NIT.lastNpcID == npcID or (not NIT.data.instances[1].zoneID or NIT.data.instances[1].zoneID < 1)) then
				--Set new zoneID if we get the same zoneid from 2 mobs in a row the same or one isn't set yet.
				NIT.data.instances[1].zoneID = zoneID;
				NIT.data.instances[1].GUID = GUID;
				NIT.data.instances[1].GUIDSource = unit or "combatLog";
				if (not doneFirstGUIDCheck) then
					if (NIT.data.instances[1]) then
						NIT:pushDifferentInstanceConfirmed(NIT.data.instances[1].instanceName, NIT.data.instances[1].instanceID)
					end
				end
			end
			doneFirstGUIDCheck = true;
		end
	end
end

--Merged countable instance data when deleting duplicate instance.
NIT.lastMerge = 0;
function NIT:mergeLastInstances(GUID, source)
	--Update static stuff with new character that entered stats.
	--[[if (NIT.isDebug) then
		if (not NIT.data.instancesDebug) then
			NIT.data.instancesDebug = {};
		end
		table.insert(NIT.data.instancesDebug, 1, NIT.data.instances[1]);
	end]]
	local class, classEnglish = UnitClass("player");
	NIT.data.instances[2].playerName = UnitName("player");
	NIT.data.instances[2].class = class;
	NIT.data.instances[2].classEnglish = classEnglish;
	NIT.data.instances[2].enteredLevel = UnitLevel("player");
	NIT.data.instances[2].enteredXP = UnitXP("player");
	NIT.data.instances[2].enteredMoney = GetMoney();
	if (not NIT.data.instances[1].isPvp) then
		NIT.data.instances[2].mobCount =  NIT.data.instances[2].mobCount + NIT.data.instances[1].mobCount;
		NIT.data.instances[2].mobCountFromKill =  NIT.data.instances[2].mobCountFromKill + NIT.data.instances[1].mobCountFromKill;
		NIT.data.instances[2].rawMoneyCount =  NIT.data.instances[2].rawMoneyCount + NIT.data.instances[1].rawMoneyCount;
		NIT.data.instances[2].xpFromChat =  NIT.data.instances[2].xpFromChat + NIT.data.instances[1].xpFromChat;
	end
	NIT.data.instances[2].oldZoneID = NIT.data.instances[1].zoneID;
	if (GUID) then
		NIT.data.instances[2].mergeGUID = GUID;
	end
	if (source) then
		NIT.data.instances[2].mergeSource = source;
	end
	local data = NIT.data.instances[1];
	if (data and data.instanceID) then
		NIT:removeInstanceCount(data.instanceID);
	end
	if (NIT.data.instances[1]) then
		NIT:pushSameInstanceConfirmed(NIT.data.instances[1].instanceName, NIT.data.instances[1].instanceID);
	end
	table.remove(NIT.data.instances, 1);
	NIT.lastMerge = GetServerTime();
end

local recordGroupInfoThroddle = 0;
function NIT:recordGroupInfo()
	if (not NIT.inInstance) then
		return;
	end
	if (NIT.data.instances[1].type == "arena") then
		--We get the group info from scoreboard in arena.
		return;
	end
	if ((GetServerTime() - recordGroupInfoThroddle) < 2) then
		--Throddle to only run this once every 2 seconds because it can be called from a few different things.
		return;
	end
	if (not NIT.data.instances[1].group) then
		NIT.data.instances[1].group = {};
	end
	recordGroupInfoThroddle = GetServerTime();
	local average, count = 0, 0;
	local nums = {};
	nums[0] = UnitLevel("player");
	if (IsInRaid()) then
		for i = 1, 40 do
			local level = NIT:addToGroupData("raid" .. i);
			if (level) then
				if (level > 0) then
					count = count + 1;
					average = ((average * (count - 1)) + level) / count;
				end
			end
		end
	elseif (IsInGroup()) then
		for i = 1, 5 do
			local level = NIT:addToGroupData("party" .. i);
			if (level) then
				if (level > 0) then
					count = count + 1;
					average = ((average * (count - 1)) + level) / count;
				end
			end
		end
	else
		return;
	end
	local level = NIT:addToGroupData("player");
	if (level) then
		if (level > 0) then
			count = count + 1;
			average = ((average * (count - 1)) + level) / count;
		end
	end
	NIT.data.instances[1].groupAverage = average;
	return average;
end

function NIT:addToGroupData(unit)
	local level = UnitLevel(unit);
	local name, realm = UnitName(unit);
	if (realm and realm ~= "" and realm ~= GetRealmName()) then
	--if (NIT.data.instances[1] and NIT.data.instances[1].isPvp) then
		--if (realm) then
			name = name .. "-" .. realm;
		--end
	end
	if (name == "Unknown") then
		--Sometimes the game can't get info from a group member.
		return 0;
	end
	local class, classEnglish = UnitClass(unit);
	local guildName, guildRankName, guildRankIndex = GetGuildInfo(unit);
	if (level and name) then
		--[[NIT.data.instances[1].group[name] = {
			level = level,
			class = class,
			classEnglish = classEnglish,
		}]]
		if (not NIT.data.instances[1].group[name]) then
			NIT.data.instances[1].group[name] = {};
		end
		--Only overwrite things if they are valid and not player out of range.
		if (level and (not NIT.data.instances[1].group[name].level or level > 0)) then
			NIT.data.instances[1].group[name].level = level;
		end
		if (class and (not NIT.data.instances[1].group[name].class or class ~= "")) then
			NIT.data.instances[1].group[name].class = class;
		end
		if (classEnglish and (not NIT.data.instances[1].group[name].classEnglish or classEnglish ~= "")) then
			NIT.data.instances[1].group[name].classEnglish = classEnglish;
		end
		if (guildName and (not NIT.data.instances[1].group[name].guildName or guildName ~= "")) then
			NIT.data.instances[1].group[name].guildName = guildName;
		end
	end
	--Return level for average calc.
	if (not level) then
		level = 0;
	end
	return level;
end

--Delete instance by number, called by confirmation popup.
function NIT:deleteInstance(num, displayNum)
	local data = NIT.data.instances[num];
	if (data) then
		local timeAgo = GetServerTime() - data.enteredTime;
		if (data.instanceID) then
			NIT:removeInstanceCount(data.instanceID);
		end
		if (displayNum) then
			NIT:print(string.format(L["deleteInstance"], displayNum, data.instanceName, NIT:getTimeString(timeAgo, true)));
		else
			NIT:print(string.format(L["deleteInstance"], num, data.instanceName, NIT:getTimeString(timeAgo, true)));
		end
		table.remove(NIT.data.instances, num);
		NIT:recalcInstanceLineFrames();
	else
		NIT:print(string.format(L["deleteInstanceError"], num));
	end
end

--Delete character data.
function NIT:deleteCharacter(realm, char)
	local data = NIT.db.global[realm].myChars[char];
	if (data) then
		if (char == UnitName("player")) then
			NIT.db.global[realm].myChars[char] = nil;
			NIT:print("Deleted character " .. char .. " on realm [" .. realm .. "], recording new info.")
			NIT:recalcAltsLineFrames();
			NIT:recordCharacterData();
		else
			NIT.db.global[realm].myChars[char] = nil;
			NIT:print("Deleted character " .. char .. " on realm [" .. realm .. "].")
			NIT:recalcAltsLineFrames();
		end
	else
		NIT:print("Error deleting " .. char .. ".")
	end
end

function NIT:getInstanceLockoutInfoString(char)
	local hourCount, hourCount24, hourTimestamp, hourTimestamp24 = NIT:getInstanceLockoutInfo(char);
	local countString = string.format(L["countString"], hourCount, hourCount24);
	local countStringColorized = NIT.chatColor
			.. string.format(L["countStringColorized"], NIT.prefixColor, hourCount, NIT.chatColor, NIT.prefixColor, hourCount24, NIT.chatColor);
	local lockoutInfo = L["now"];
	--local timeLeft24 = 86400 - (GetServerTime() - hourTimestamp24);
	--local timeLeft = 3600 - (GetServerTime() - hourTimestamp);
	--local timeLeftMax = math.max(timeLeft24, timeLeft);
	--if (GetServerTime() - hourTimestamp24 < 86400 and hourCount24 >= NIT.dailyLimit and timeLeft24 == timeLeftMax) then
	if (GetServerTime() - hourTimestamp24 < 86400 and hourCount24 >= NIT.dailyLimit and not NIT.noDailyLockout) then
		lockoutInfo = L["in"] .. " " .. NIT:getTimeString(86400 - (GetServerTime() - hourTimestamp24), true) .. " (" .. L["active24"] .. ")";
	elseif (GetServerTime() - hourTimestamp < 3600 and hourCount >= NIT.hourlyLimit) then
		lockoutInfo = L["in"] .. " " .. NIT:getTimeString(3600 - (GetServerTime() - hourTimestamp), true);
	end
	lockoutInfo = L["nextInstanceAvailable"] .. " " .. lockoutInfo;
	local lockoutStringShort = lockoutInfo .. ".";
	local lockoutString = countString .. ". " .. lockoutInfo .. ".";
	local lockoutStringColorized = countStringColorized .. ". " .. lockoutInfo .. ".";
	return lockoutString, lockoutStringShort, lockoutStringColorized;
end

function NIT:getInstanceLockoutInfo(char)
	local hourCount, hourCount24, hourTimestamp, hourTimestamp24 = 0, 0, 0, 0;
	local count = 0;
	local instances, lastInstance, lastInstance24 = 0, 0, 0;
	local target = UnitName("player");
	local maxCount = NIT.dailyLimit + 50;
	if (char) then
		target = char;
	end
	for k, v in ipairs(NIT.data.instances) do
		if (not NIT.perCharOnly or target == v.playerName) then
			if (v.isPvp or (NIT.noRaidLockouts and v.instanceID and NIT.zones[v.instanceID] and NIT.zones[v.instanceID].noLockout)) then
				--NIT:debug("skipping raid", v.instanceID);
			else
				count = count + 1;
				if (count > maxCount) then
				--if (count > 80) then
					break;
				end
				--Check leftTime first, then fallback to enteredTime if there's no time recorded for leaving instance.
				if (v.leftTime and v.leftTime > (GetServerTime() - 3600)) then
					hourCount = hourCount + 1;
					hourTimestamp = v.leftTime;
				elseif (v.enteredTime and v.enteredTime > (GetServerTime() - 3600)) then
					hourCount = hourCount + 1;
					hourTimestamp = v.enteredTime;
				end
				if (v.leftTime and v.leftTime > (GetServerTime() - 86400)) then
					hourCount24 = hourCount24 + 1;
					hourTimestamp24 = v.leftTime;
				elseif (v.enteredTime and v.enteredTime > (GetServerTime() - 86400)) then
					hourCount24 = hourCount24 + 1;
					hourTimestamp24 = v.enteredTime;
				end
			end
		end
	end
	return hourCount, hourCount24, hourTimestamp, hourTimestamp24;
end

function NIT:recordCharacterData()
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	--Some of these can be nil or 0 at logout for some reason so we have to check.
	local classLocalized, classEnglish = UnitClass("player");
	NIT.data.myChars[char].realm = GetRealmName();
	NIT.data.myChars[char].level = UnitLevel("player");
	NIT.data.myChars[char].classLocalized = classLocalized;
	NIT.data.myChars[char].classEnglish = classEnglish;
	NIT.data.myChars[char].race = UnitRace("player");
	--if (UnitXP("player") > 0) then
		NIT.data.myChars[char].currentXP = UnitXP("player");
	--end
	--if (UnitXPMax("player") > 0) then
		NIT.data.myChars[char].maxXP = UnitXPMax("player");
	--end
	if (GetXPExhaustion()) then
		NIT.data.myChars[char].restedXP = GetXPExhaustion();
	else
		NIT.data.myChars[char].restedXP = 0
	end
	NIT.data.myChars[char].resting = IsResting();
	NIT.data.myChars[char].time = GetServerTime();
	--Race.
	local raceLocalized, raceEnglish = UnitRace("player");
	if (not raceEnglish) then
		raceEnglish = "unknownrace";
		raceLocalized = "unknownrace";
	end
	NIT.data.myChars[char].raceLocalized = raceLocalized;
	NIT.data.myChars[char].raceEnglish = raceEnglish;
	--Gender.
	local gender, genderNum = "Neutral", UnitSex("player");
	if (genderNum == 2) then
		gender = "Male";
	elseif (genderNum == 3) then
		gender = "Female";
	end
	NIT.data.myChars[char].gender = gender;
	local guild, guildRankName, guildRankIndex = GetGuildInfo("player");
	if (not guild) then
		guild = "No guild";
	end
	if (not guildRankName) then
		guildRankName = "No guild rank";
	end
	NIT.data.myChars[char].guild = guild;
	NIT.data.myChars[char].guildRankName = guildRankName;
	--Durability.
	local durabilityAverage = NIT.getAverageDurability();
	NIT.data.myChars[char].durabilityAverage = durabilityAverage;
	--Professions
	local prof1, prof2, fishing, cooking, firstaid = "none", "none", "none", "none", "none";
	local profSkill1, profSkill2, fishingSkill, cookingSkill, firstaidSkill = 0, 0, 0, 0, 0;
	local profSkillMax1, profSkillMax2, fishingSkillMax, cookingSkillMax, firstaidSkillMax = 0, 0, 0, 0, 0;
	if (NIT.isRetail) then
		local prof1, prof2, archaeology, fishing, cooking = GetProfessions();
		if (prof1) then
			local prof1Name = GetProfessionInfo(prof1);
			NIT.data.myChars[char].prof1 = prof1Name;
		end
		if (prof2) then
			local prof2Name = GetProfessionInfo(prof2);
			NIT.data.myChars[char].prof2 = prof2Name;
		end
	elseif (NIT.classic) then
		--Skill list is always in same order, so we can get primary/secondary/weapon by checking the section headers.
		local section, primaryCount, secondaryCount, weaponCount = 0, 0, 0, 0;
		for i = 1, GetNumSkillLines() do
			local skillName, isHeader, _, skillRank, _, _, skillMaxRank = GetSkillLineInfo(i)
			--[[if (isHeader and skillName == "Professions") then
				section = 2;
			elseif (isHeader and skillName == "Secondary Skills") then
				section = 3;
			elseif (isHeader and skillName == "Weapon Skills") then
				section = 4;
			elseif (isHeader and skillName == "Armor Proficiencies") then
				section = 5;
			elseif (isHeader and skillName == "Languages") then
				section = 6;
			end]]
			if (isHeader and skillName == TRADE_SKILLS) then
				section = 2;
			elseif (isHeader and skillName == string.gsub(SECONDARY_SKILLS, ":", "")) then
				section = 3;
			elseif (isHeader and string.find(skillName, COMBAT_RATING_NAME1)) then
				section = 4;
			elseif (isHeader and string.find(skillName, string.gsub(PROFICIENCIES, ":", ""))) then
				--Global string PROFICIENCIES has a colon so strip it and use that as a close enough.
				--Couldn't find a "Armor Proficiencies" global string.
				section = 5;
			elseif (isHeader and skillName == LANGUAGES_LABEL) then
				section = 6;
			end
			if (not isHeader and section == 2) then
				--Primary professions.
				primaryCount = primaryCount + 1;
				if (primaryCount == 1) then
					prof1 = skillName;
					profSkill1 = skillRank;
					profSkillMax1 = skillMaxRank;
				elseif (primaryCount == 2) then
					prof2 = skillName;
					profSkill2 = skillRank;
					profSkillMax2 = skillMaxRank;
				end
			elseif (not isHeader and (section == 3 or section == 2)) then
				--Secondary professions.
				secondaryCount = secondaryCount + 1;
				if (skillName == PROFESSIONS_FISHING) then
					fishing = skillName;
					fishingSkill = skillRank;
					fishingSkillMax = skillMaxRank;
				elseif (skillName == PROFESSIONS_COOKING) then
					cooking = skillName;
					cookingSkill = skillRank;
					cookingSkillMax = skillMaxRank;
				elseif (skillName == PROFESSIONS_FIRST_AID) then
					firstaid = skillName;
					firstaidSkill = skillRank;
					firstaidSkillMax = skillMaxRank;
				end
			elseif (not isHeader and section == 4) then
				--Weapon skills.
				weaponCount = weaponCount + 1;
			end
		end
		NIT.data.myChars[char].prof1 = prof1;
		NIT.data.myChars[char].profSkill1 = profSkill1;
		NIT.data.myChars[char].profSkillMax1 = profSkillMax1;
		NIT.data.myChars[char].prof2 = prof2;
		NIT.data.myChars[char].profSkill2 = profSkill2;
		NIT.data.myChars[char].profSkillMax2 = profSkillMax2;
		--NIT.data.myChars[char].fishing = fishing;
		NIT.data.myChars[char].fishingSkill = fishingSkill;
		NIT.data.myChars[char].fishingSkillMax = fishingSkillMax;
		--NIT.data.myChars[char].cooking = cooking;
		NIT.data.myChars[char].cookingSkill = cookingSkill;
		NIT.data.myChars[char].cookingSkillMax = cookingSkillMax;
		--NIT.data.myChars[char].firstaid = firstaid;
		NIT.data.myChars[char].firstaidSkill = firstaidSkill;
		NIT.data.myChars[char].firstaidSkillMax = firstaidSkillMax;
	end
	if (IsQuestFlaggedCompleted(7848) or IsQuestFlaggedCompleted(7487)) then
		NIT.data.myChars[char].mcAttune = true;
	end
	if (IsQuestFlaggedCompleted(6502) or IsQuestFlaggedCompleted(6602)) then
		NIT.data.myChars[char].onyAttune = true;
	end
	if (IsQuestFlaggedCompleted(7761)) then
		NIT.data.myChars[char].bwlAttune = true;
	end
	if (IsQuestFlaggedCompleted(9121) or IsQuestFlaggedCompleted(9122) or IsQuestFlaggedCompleted(9123)) then
		NIT.data.myChars[char].naxxAttune = true;
	end
	if (IsQuestFlaggedCompleted(9838)) then
		NIT.data.myChars[char].karaAttune = true;
	end
	if (IsQuestFlaggedCompleted(10764) or IsQuestFlaggedCompleted(10758)) then
		NIT.data.myChars[char].shatteredHallsAttune = true;
	end
	if (IsQuestFlaggedCompleted(10901)) then
		NIT.data.myChars[char].serpentshrineAttune = true;
	end
	--if (IsQuestFlaggedCompleted(10704)) then
	--	NIT.data.myChars[char].arcatrazAttune = true;
	--end
	--if (IsQuestFlaggedCompleted(10285)) then
	--	NIT.data.myChars[char].cavernsAttune = true;
	--end
	if (IsQuestFlaggedCompleted(10297) and IsQuestFlaggedCompleted(10298)) then
		NIT.data.myChars[char].blackMorassAttune = true;
	end
	if (IsQuestFlaggedCompleted(10445)) then
		NIT.data.myChars[char].hyjalAttune = true;
	end
	--if (IsQuestFlaggedCompleted(10888)) then
	--	NIT.data.myChars[char].tempestKeepAttune = true;
	--end
	if (IsQuestFlaggedCompleted(10959)) then
		NIT.data.myChars[char].blackTempleAttune = true;
	end
	if (classEnglish and classEnglish == "HUNTER") then
		NIT:recordHunterData();
	end
	NIT:recordAttunementKeys();
	NIT:recordInventoryData();
	NIT:recordLockoutData();
	NIT:recordPvpData();
	NIT:recordHonorData();
	NIT:recordArenaPoints();
	NIT:recordMarksData();
	NIT:recordCooldowns();
	NIT:recordQuests();
end

--Weeklys.
local recordQuests = {};
if (NIT.isRetail) then
	recordQuests[70893] = L["Feast Weekly"];
	recordQuests[70866] = L["Siege on Dragonbane Keep"];
	recordQuests[70906] = L["Grand Hunt (1st Time)"];
	recordQuests[71136] = L["Grand Hunt (2nd Time)"];
	recordQuests[71137] = L["Grand Hunt (3rd Time)"];
	recordQuests[71995] = L["Trial of Elements"];
	recordQuests[71033] = L["Trial of Flood"];
	recordQuests[69927] = L["World Boss (Bazual)"];
	recordQuests[69928] = L["World Boss (Liskanoth)"];
	recordQuests[69929] = L["World Boss (Strunraan)"];
	recordQuests[69930] = L["World Boss (Basrikron)"];
end
if (NIT.isWrath) then
	recordQuests[24590] = "Lord Marrowgar Must Die!";
	recordQuests[24580] = "Anub'Rekhan Must Die!";
	recordQuests[24585] = "Flame Leviathan Must Die!";
	recordQuests[24587] = "Ignis the Furnace Master Must Die!";
	recordQuests[24582] = "Instructor Razuvious Must Die!";
	recordQuests[24589] = "Lord Jaraxxus Must Die!";
	recordQuests[24584] = "Malygos Must Die!";
	recordQuests[24581] = "Noth the Plaguebringer Must Die!";
	recordQuests[24583] = "Patchwerk Must Die!";
	recordQuests[24586] = "Razorscale Must Die!";
	recordQuests[24579] = "Sartharion Must Die!";
	recordQuests[24588] = "XT-002 Deconstructor Must Die!";
end

--Dailys.
local recordDailyQuests = {};
if (NIT.isWrath) then
	recordDailyQuests[78752] = L["Proof of Demise: Titan Rune Protocol Gamma"];
	recordDailyQuests[78753] = L["Proof of Demise: Threats to Azeroth"];
end

function NIT:recordQuests()
	if (not C_DateAndTime or not C_DateAndTime.GetSecondsUntilWeeklyReset) then
		return;
	end
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	if (not NIT.data.myChars[char].quests) then
		NIT.data.myChars[char].quests = {};
	end
	--All wrath weeklies are flagged as complete when 1 is so just record 1 and not all.
	local wrathWeeklyComplete;
	local wrathWeeklies = {
		[24590] = "Lord Marrowgar Must Die!";
		[24580] = "Anub'Rekhan Must Die!";
		[24585] = "Flame Leviathan Must Die!";
		[24587] = "Ignis the Furnace Master Must Die!";
		[24582] = "Instructor Razuvious Must Die!";
		[24589] = "Lord Jaraxxus Must Die!";
		[24584] = "Malygos Must Die!";
		[24581] = "Noth the Plaguebringer Must Die!";
		[24583] = "Patchwerk Must Die!";
		[24586] = "Razorscale Must Die!";
		[24579] = "Sartharion Must Die!";
		[24588] = "XT-002 Deconstructor Must Die!";
	};
	local resetTime = GetServerTime() + C_DateAndTime.GetSecondsUntilWeeklyReset();
	for k, v in pairs(recordQuests) do
		if (IsQuestFlaggedCompleted(k)) then
			--There's bugs with this that need more testing before release.
			if (wrathWeeklies[k]) then
				if (not wrathWeeklyComplete) then
					wrathWeeklyComplete = true;
					NIT.data.myChars[char].quests[L["Wrath Raid Boss Weekly"]] = resetTime;
					--Wrath raid weekly isn't resetting at normal server time, it's resetting later on in the day so it's still recording as complete until the following week.
					--Watching this and see if they fix the reset time, maybe they had to manual reset first week due to a bug?
				end
			else
				NIT.data.myChars[char].quests[v] = resetTime;
			end
		end
	end
	if (not NIT.data.myChars[char].questsDaily) then
		NIT.data.myChars[char].questsDaily = {};
	end
	local resetTime = GetServerTime() + C_DateAndTime.GetSecondsUntilDailyReset();
	for k, v in pairs(recordDailyQuests) do
		if (IsQuestFlaggedCompleted(k)) then
			NIT.data.myChars[char].questsDaily[v] = resetTime;
		end
	end
end

function NIT:recordAttunementKeys()
	if (NIT.expansionNum > 3) then
		return;
	end
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	--Check the keyring for attunement keys.
	for slot = 1, 32 do
		local slotID = KeyRingButtonIDToInvSlotID(slot);
		if (slotID) then
			local item = Item:CreateFromEquipmentSlot(slotID);
			if (item) then
				local itemID = item:GetItemID(item);
				local itemName = item:GetItemName(item);
				if (itemID == 185686 or itemID == 185687 or itemID == 30637 or itemID == 30622) then
					NIT.data.myChars[char].hellfireCitadelAttune = true;
				end
				if (itemID == 30623 or itemID == 185690) then
					NIT.data.myChars[char].coilfangAttune = true;
				end
				if (itemID == 30633 or itemID == 185691) then
					NIT.data.myChars[char].auchindounAttune = true;
				end
				if (itemID == 27991) then
					NIT.data.myChars[char].shadowLabAttune = true;
				end
				if (itemID == 30634 or itemID == 185692) then
					NIT.data.myChars[char].tempestKeepAttune = true;
				end
				if (itemID == 30635 or itemID == 185693) then
					NIT.data.myChars[char].cavernsAttune = true;
				end
				if (itemID == 31084) then
					NIT.data.myChars[char].arcatrazAttune = true;
				end
				--if (itemID == 7146) then
				--	NIT.data.myChars[char].testAttune = true;
				--end
				--if (itemName and string.find(itemName, "Key")) then
				--	print(itemName, itemID)
				--end
			end
		end
	end
end

function NIT:recordPvpData()
	if (NIT.isRetail) then
		return;
	end
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	local rankID = UnitPVPRank("player");
	if (rankID) then
		local rankName, rankNumber = GetPVPRankInfo(rankID);
		local rankPercent = GetPVPRankProgress();
		if (rankName and rankNumber and rankPercent) then
			if (NIT.data.myChars[char].pvpRankPercent and rankPercent and tostring(rankPercent) ~= tostring(NIT.data.myChars[char].pvpRankPercent)) then
				NIT.data.myChars[char].pvpRankNameLastWeek = NIT.data.myChars[char].pvpRankName;
				NIT.data.myChars[char].pvpRankNumberLastWeek = NIT.data.myChars[char].pvpRankNumber;
				NIT.data.myChars[char].pvpRankPercentLastWeek = NIT.data.myChars[char].pvpRankPercent;
			end
			NIT.data.myChars[char].pvpRankName = rankName;
			NIT.data.myChars[char].pvpRankNumber = rankNumber;
			NIT.data.myChars[char].pvpRankPercent = rankPercent;
		end
	end
end

function NIT:recordHonorData()
	if (NIT.isClassic) then
		return;
	end
	local data = C_CurrencyInfo.GetCurrencyInfo(1901);
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	if (data and data.quantity and data.quantity > 0) then
		NIT.data.myChars[char].honor = data.quantity;
	else
		NIT.data.myChars[char].honor = 0;
	end
end

function NIT:recordArenaPoints()
	if (NIT.isClassic) then
		return;
	end
	local data = C_CurrencyInfo.GetCurrencyInfo(1900);
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	if (data and data.quantity and data.quantity > 0) then
		NIT.data.myChars[char].arenaPoints = data.quantity;
	else
		NIT.data.myChars[char].arenaPoints = 0;
	end
end

NIT.bgMarks = {
	[20558] = {
		name = "Warsong Gulch Mark of Honor",
		icon = 134420,
	};
	[20559] = {
		name = "Arathi Basin Mark of Honor",
		icon = 133282,
	};
	[20560] = {
		name = "Alterac Valley Mark of Honor",
		icon = 133308,
	};
};
if (NIT.isTBC) then
	NIT.bgMarks[29024] = {
		name = "Eye of the Storm Mark of Honor",
		icon = 136032,
	};
end
if (NIT.isWrath) then
	NIT.bgMarks[29024] = {
		name = "Eye of the Storm Mark of Honor",
		icon = 136032,
	};
	NIT.bgMarks[42425] = {
		name = "Strand of the Ancients Mark of Honor",
		icon = 133276,
	};
	NIT.bgMarks[47395] = {
		name = "Isle of Conquest Mark of Honor",
		icon = 133314,
	};
end

function NIT:recordMarksData()
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	if (not NIT.data.myChars[char].marks) then
		NIT.data.myChars[char].marks = {};
	end
	for k, v in pairs(NIT.bgMarks) do
		NIT.data.myChars[char].marks[k] = (GetItemCount(k, true) or 0);
	end
end

function NIT:recordLockoutData()
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	if (not NIT.data.myChars[char].savedInstances) then
		NIT.data.myChars[char].savedInstances = {};
	end
	local data = {};
	for i = 1, GetNumSavedInstances() do
		local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers,
				difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i);
		local resetTime = GetServerTime() + reset;
		if (tonumber(id)) then
			NIT.data.myChars[char].savedInstances[tonumber(id)] = {
				name = name,
				resetTime = resetTime,
				difficultyName = difficultyName,
				locked = locked,
			};
		end
	end
end

function NIT:resetOldLockouts()
	for realm, realmData in pairs(NIT.db.global) do
		if (type(realmData) == "table" and realmData ~= "minimapIcon" and realmData ~= "data") then
			if (realmData.myChars) then
				for char, charData in pairs(realmData.myChars) do
					if (charData.savedInstances) then
						for k, v in pairs(charData.savedInstances) do
							if (v.resetTime and v.resetTime < GetServerTime()) then
								NIT.db.global[realm].myChars[char].savedInstances[k] = nil;
							end
						end
					end
				end
			end
		end
	end
end

function NIT:recordKeystoneData(lootedKeystone)
	if (not NIT.isRetail) then
		return;
	end
	C_MythicPlus.RequestMapInfo(); --Instead of a timer this should be changed to wait for CHALLENGE_MODE_MAPS_UPDATE later.
	if (lootedKeystone) then
		--Force record data if we just looted a keystone from the vault.
		--For some reason running C_MythicPlus.RequestMapInfo() right after loot doesn't trigger any event.
		--Maybe a throddle?
		NIT:challengeModeMapsUpdate();
	end
end

function NIT:challengeModeMapsUpdate()
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	if (not NIT.data.myChars[char].keystoneData) then
		NIT.data.myChars[char].keystoneData = {};
	end
	NIT.data.myChars[char].keystoneScore = C_ChallengeMode.GetOverallDungeonScore();
	local _, class = UnitClass("player");
	local keystone, bestMap, bestLevel;
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
      		local item = GetContainerItemLink(bag,slot);
      		if (item and strfind(item, "|Hkeystone")) then
      			keystone = item;
      			break;
			end
		end
	end
	--if (keystone) then
	--	level = C_MythicPlus.GetOwnedKeystoneLevel();
	--	local mapID = C_MythicPlus.GetOwnedKeystoneMapID();
	--	local mapName = C_ChallengeMode.GetMapUIInfo(mapID);
	--	mapData = C_Map.GetMapInfo(mapID);
	--end
	if (keystone) then
		NIT.data.myChars[char].keystoneData.itemLink = keystone;
	end
	local bestLevel, bestScore = 0, 0;
	local bestMapName, bestMapID;
	local weeklyRuns = C_MythicPlus.GetRunHistory(false, true);
	for i = 1, #weeklyRuns do
		local run = weeklyRuns[i];
		if (run.thisWeek and run.level > bestLevel) then
			bestLevel = run.level;
		end
	end
	--Check all keys equal to our max level done to find the best score so we can display which map it was.
	for i = 1, #weeklyRuns do
		local run = weeklyRuns[i];
		if (run.thisWeek and run.level == bestLevel) then
			if (run.runScore > bestScore or bestScore == 0) then
				bestScore = run.runScore;
				bestMapID = run.mapChallengeModeID;
			end
		end
	end
	if (bestMapID and bestLevel > 0) then
		bestMapName = C_ChallengeMode.GetMapUIInfo(bestMapID);
		NIT.data.myChars[char].keystoneData.bestMapName = bestMapName;
		NIT.data.myChars[char].keystoneData.bestLevel = bestLevel;
	end
	if (C_WeeklyRewards.HasAvailableRewards()) then
		NIT.data.myChars[char].weeklyCache = true;
	else
		NIT.data.myChars[char].weeklyCache = nil;
	end
end

function NIT:checkRewards()
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	if (C_WeeklyRewards.HasAvailableRewards()) then
		NIT.data.myChars[char].weeklyCache = true;
	else
		NIT.data.myChars[char].weeklyCache = nil;
	end
end

function NIT:resetWeeklyData()
	for realm, realmData in pairs(NIT.db.global) do
		if (type(realmData) == "table" and realmData ~= "minimapIcon" and realmData ~= "data") then
			if (realmData.myChars) then
				local resetTime = (realmData.weeklyResetTime or 0);
				for char, charData in pairs(realmData.myChars) do
					if (charData.quests) then
						for k, v in pairs(charData.quests) do
							if (v < GetServerTime()) then
								NIT.db.global[realm].myChars[char].quests[k] = nil;
							end
						end
					end
					if (charData.questsDaily) then
						for k, v in pairs(charData.questsDaily) do
							if (v < GetServerTime()) then
								NIT.db.global[realm].myChars[char].questsDaily[k] = nil;
							end
						end
					end
					if (charData.keystoneData) then
						if (resetTime < GetServerTime()) then
							NIT.db.global[realm].myChars[char].keystoneData = nil;
						end
					end
				end
			end
		end
	end
end

function NIT:updateWeeklyResetTime()
	NIT.db.global[NIT.realm].weeklyResetTime = GetServerTime() + C_DateAndTime.GetSecondsUntilWeeklyReset();
end

function NIT:doOnceAfterWeeklyReset()
	for realm, realmData in pairs(NIT.db.global) do
		if (type(realmData) == "table" and realmData ~= "minimapIcon" and realmData ~= "data") then
			if (realmData.myChars) then
				local resetTime = (realmData.weeklyResetTime or 0);
				if (GetServerTime() > resetTime) then
					--resetTime is set after this func is run at logon so it's easy to check if it's first logon after weekly reset.
					--If it's first logon after weekly reset we do things like setting flags that chars need to loot weekly cache etc.
					for char, charData in pairs(realmData.myChars) do
						if (charData.keystoneData and charData.keystoneData.bestLevel and charData.keystoneData.bestLevel > 0) then
							NIT.db.global[realm].myChars[char].weeklyCache = true;
						end
					end
				end
			end
		end
	end
end

--These are structured like this so there's a sort order.
--minLvl is min lvl that you need to cast the spells that require them.

NIT.trackItemsMAGE = {
	[1] = {
		id = 17031,
		name = "Rune of Teleportation",
		texture = "Interface\\Icons\\inv_misc_rune_06",
		minLvl = 20;
	},
	[2] = {
		id = 17032,
		name = "Rune of Portals",
		texture = "Interface\\Icons\\inv_misc_rune_08",
		minLvl = 40;
	},
	[3] = {
		id = 17020,
		name = "Arcane Powder",
		texture = "Interface\\Icons\\inv_misc_dust_01",
		minLvl = 56;
	},
	[4] = {
		id = 17056,
		name = "Light Feather",
		texture = "Interface\\Icons\\inv_feather_04",
		minLvl = 12;
	},
};

if (NIT.isTBC or NIT.isPrepatch) then
	NIT.trackItemsDRUID = {
		[1] = {
			id = 22148,
			name = "Wild Quillvine",
			texture = "Interface\\Icons\\inv_misc_root_01",
			minLvl = 70;
		},
		[2] = {
			id = 22147,
			name = "Flintweed Seed",
			texture = "Interface\\Icons\\inv_misc_food_02",
			minLvl = 70;
		},
	};
	NIT.trackItemsPRIEST = {
		[1] = {
			id = 17029,
			name = "Sacred Candle",
			texture = "Interface\\Icons\\inv_misc_candle_02",
			minLvl = 56,
		},
		[2] = {
			id = 17056,
			name = "Light Feather",
			texture = "Interface\\Icons\\inv_feather_04",
			minLvl = 24,
		},
	};
elseif (NIT.isWrath) then
	NIT.trackItemsDRUID = {
		[1] = {
			id = 44605,
			name = "Wild Spineleaf",
			texture = "Interface\\Icons\\inv_misc_spineleaf-_01",
			minLvl = 80;
		},
		[2] = {
			id = 44614,
			name = "Starleaf Seed",
			texture = "Interface\\Icons\\inv_misc_food_02",
			minLvl = 80;
		},
	};
	NIT.trackItemsPRIEST = {
		[1] = {
			id = 44615,
			name = "Devout Candle",
			texture = "Interface\\Icons\\inv_misc_candle_01",
			minLvl = 56,
		},
		[2] = {
			id = 17056,
			name = "Light Feather",
			texture = "Interface\\Icons\\inv_feather_04",
			minLvl = 24,
		},
	};
else
	NIT.trackItemsDRUID = {
		[1] = {
			id = 17026,
			name = "Wild Thornroot",
			texture = "Interface\\Icons\\inv_misc_root_01",
			minLvl = 60;
		},
		[2] = {
			id = 17038,
			name = "Ironwood Seed",
			texture = "Interface\\Icons\\inv_misc_food_02",
			minLvl = 60;
		},
	};
	NIT.trackItemsPRIEST = {
		[1] = {
			id = 17029,
			name = "Sacred Candle",
			texture = "Interface\\Icons\\inv_misc_candle_02",
			minLvl = 56,
		},
		[2] = {
			id = 17056,
			name = "Light Feather",
			texture = "Interface\\Icons\\inv_feather_04",
			minLvl = 24,
		},
	};
end
NIT.trackItemsWARLOCK = {
	[1] = {
		id = 6265,
		name = "Soul Shard",
		texture = "Interface\\Icons\\inv_misc_gem_amethyst_02",
		minLvl = 10;
	},
};

NIT.trackItemsSHAMAN = {
	[1] = {
		id = 17030,
		name = "Ankh",
		texture = "Interface\\Icons\\inv_jewelry_talisman_06",
		minLvl = 30;
	},
	[2] = {
		id = 17058,
		name = "Fish Oil",
		texture = "Interface\\Icons\\inv_potion_64",
		minLvl = 28;
	},
	[3] = {
		id = 17057,
		name = "Shiny Fish Scales",
		texture = "Interface\\Icons\\inv_misc_monsterscales_08",
		minLvl = 22;
	},
};

NIT.trackItemsPALADIN = {
	[1] = {
		id = 21177,
		name = "Symbol of Kings",
		texture = "Interface\\Icons\\inv_misc_symbolofkings_01",
		minLvl = 52;
	},
	[2] = {
		id = 17033,
		name = "Symbol of Divinity",
		texture = "Interface\\Icons\\inv_stone_weightstone_05",
		minLvl = 30;
	},
};

--Sometimes we only need to update inventory data.
function NIT:recordInventoryData()
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	--Gold.
	local gold = GetMoney();
	if (not gold) then
		gold = 0;
	end
	NIT.data.myChars[char].gold = gold;
	--Bags.
	local freeBagSlots, totalBagSlots = NIT.getBagSlots();
	if (not freeBagSlots) then
		freeBagSlots = 0;
	end
	if (not totalBagSlots) then
		totalBagSlots = 0;
	end
	NIT.data.myChars[char].freeBagSlots = freeBagSlots;
	NIT.data.myChars[char].totalBagSlots = totalBagSlots;
	local _, classEnglish = UnitClass("player");
	if (classEnglish and classEnglish == "HUNTER") then
		local ammo, ammoType = NIT.getAmmoCount();
		NIT.data.myChars[char].ammo = ammo;
		NIT.data.myChars[char].ammoType = ammoType;
	else
		if (_G["NIT"]["trackItems" .. classEnglish]) then
			for k, v in pairs(_G["NIT"]["trackItems" .. classEnglish]) do
				NIT.data.myChars[char][v.id] = (GetItemCount(v.id) or 0);
			end
		end
	end
	NIT:recordMarksData();
	NIT:recordCurrency();
end

local currencyItems = {
	--TBC.
	[135884] = "Badge of Justice",
	--Wrath
	[237547] = "Emblem of Valor",
	[135979] = "Emblem of Triumph",
	[135947] = "Emblem of Heroism",
	[135885] = "Emblem of Conquest",
	[334365] = "Emblem of Frost",
	[134375] = "Stone Keeper's Shards",
	[133408] = "Wintergrasp Mark of Honor",
	[237235] = "Sidereal Essence",
	[236246] = "Champion's Seal",
	[237273] = "Defiler's Scourgestone",
	--Profession tokens.
	[134411] = "Epicurean's Award",
	[134138] = "Dalaran Jewelcrafter's Token",
};

function NIT:recordCurrency()
	if (NIT.isClassic or NIT.isTBC or NIT.isRetail) then
		return;
	end
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	if (not NIT.data.myChars[char].currency) then
		NIT.data.myChars[char].currency = {};
	end
	for i = 1, GetCurrencyListSize() do
		local name, isHeader, _, _, _, count, icon, max = GetCurrencyListInfo(i);
		if (icon and currencyItems[icon]) then
			NIT.data.myChars[char].currency[icon] = {
				name = name,
				count = count,
				max = max,
			};
		end
	end
end

function NIT:recordPlayerLevelData()
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	NIT.data.myChars[char].level = UnitLevel("player");
	if (UnitXP("player") > 0) then
		NIT.data.myChars[char].currentXP = UnitXP("player");
	end
	if (UnitXPMax("player") > 0) then
		NIT.data.myChars[char].maxXP = UnitXPMax("player");
	end
	if (GetXPExhaustion()) then
		NIT.data.myChars[char].restedXP = GetXPExhaustion();
	else
		NIT.data.myChars[char].restedXP = 0
	end
	NIT.data.myChars[char].resting = IsResting();
	NIT.data.myChars[char].time = GetServerTime();
end

function NIT:recordSkillUpData(...)
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	local prof1, prof2, fishing, cooking, firstaid = "none", "none", "none", "none", "none";
	local profSkill1, profSkill2, fishingSkill, cookingSkill, firstaidSkill = 0, 0, 0, 0, 0;
	local profSkillMax1, profSkillMax2, fishingSkillMax, cookingSkillMax, firstaidSkillMax = 0, 0, 0, 0, 0;
	if (NIT.classic) then
		--Skill list is always in same order, so we can get primary/secondary/weapon by checking the section headers.
		local section, primaryCount, secondaryCount, weaponCount = 0, 0, 0, 0;
		for i = 1, GetNumSkillLines() do
			local skillName, isHeader, _, skillRank, _, _, skillMaxRank = GetSkillLineInfo(i)
			if (isHeader and skillName == TRADE_SKILLS) then
				section = 2;
			elseif (isHeader and skillName == string.gsub(SECONDARY_SKILLS, ":", "")) then
				section = 3;
			elseif (isHeader and string.find(skillName, COMBAT_RATING_NAME1)) then
				section = 4;
			elseif (isHeader and string.find(skillName, string.gsub(PROFICIENCIES, ":", ""))) then
				--Global string PROFICIENCIES has a colon so strip it and use that as a close enough.
				--Couldn't find a "Armor Proficiencies" global string.
				section = 5;
			elseif (isHeader and skillName == LANGUAGES_LABEL) then
				section = 6;
			end
			if (not isHeader and section == 2) then
				--Primary professions.
				primaryCount = primaryCount + 1;
				if (primaryCount == 1) then
					prof1 = skillName;
					profSkill1 = skillRank;
					profSkillMax1 = skillMaxRank;
				elseif (primaryCount == 2) then
					prof2 = skillName;
					profSkill2 = skillRank;
					profSkillMax2 = skillMaxRank;
				end
			elseif (not isHeader and section == 3) then
				--Secondary professions.
				secondaryCount = secondaryCount + 1;
				if (skillName == L["Fishing"]) then
					fishing = skillName;
					fishingSkill = skillRank;
					fishingSkillMax = skillMaxRank;
				elseif (skillName == L["Cooking"]) then
					cooking = skillName;
					cookingSkill = skillRank;
					cookingSkillMax = skillMaxRank;
				elseif (skillName == L["firstAid"]) then
					firstaid = skillName;
					firstaidSkill = skillRank;
					firstaidSkillMax = skillMaxRank;
				end
			elseif (not isHeader and section == 4) then
				--Weapon skills.
				weaponCount = weaponCount + 1;
			end
		end
		NIT.data.myChars[char].prof1 = prof1;
		NIT.data.myChars[char].profSkill1 = profSkill1;
		NIT.data.myChars[char].profSkillMax1 = profSkillMax1;
		NIT.data.myChars[char].prof2 = prof2;
		NIT.data.myChars[char].profSkill2 = profSkill2;
		NIT.data.myChars[char].profSkillMax2 = profSkillMax2;
		--NIT.data.myChars[char].fishing = fishing;
		NIT.data.myChars[char].fishingSkill = fishingSkill;
		NIT.data.myChars[char].fishingSkillMax = fishingSkillMax;
		--NIT.data.myChars[char].cooking = cooking;
		NIT.data.myChars[char].cookingSkill = cookingSkill;
		NIT.data.myChars[char].cookingSkillMax = cookingSkillMax;
		--NIT.data.myChars[char].firstaid = firstaid;
		NIT.data.myChars[char].firstaidSkill = firstaidSkill;
		NIT.data.myChars[char].firstaidSkillMax = firstaidSkillMax;
	end
end

--Update certain data like XP etc when combat ends instead of every mob.
function NIT:recordCombatEndedData()
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	
	if (UnitXP("player") > 0) then
		NIT.data.myChars[char].currentXP = UnitXP("player");
	end
	if (UnitXPMax("player") > 0) then
		NIT.data.myChars[char].maxXP = UnitXPMax("player");
	end
	if (GetXPExhaustion()) then
		NIT.data.myChars[char].restedXP = GetXPExhaustion();
	else
		NIT.data.myChars[char].restedXP = 0
	end
	NIT.data.myChars[char].resting = IsResting();
	NIT.data.myChars[char].time = GetServerTime();
	local durabilityAverage = NIT.getAverageDurability();
	NIT.data.myChars[char].durabilityAverage = durabilityAverage;
	local localizedClass, englishClass = UnitClass("player");
	if (englishClass == "HUNTER") then
		NIT:recordHunterData();
	end
end

local durabilityFirstRun = true;
function NIT:recordDurabilityData()
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	--Don't run this at logon, this data gets recorded already in recordCharacterData();
	if (durabilityFirstRun) then
		durabilityFirstRun = false;
		return
	end
	local durabilityAverage = NIT.getAverageDurability();
	NIT.data.myChars[char].durabilityAverage = durabilityAverage;
end

--Big thanks to this comment https://github.com/Stanzilla/WoWUIBugs/issues/47#issuecomment-710698976
local function GetCooldownLeft(start, duration)
	if (start < GetTime()) then
		local cdEndTime = start + duration;
		local cdLeftDuration = cdEndTime - GetTime();
		return cdLeftDuration;
	end
	local time = time();
	local startupTime = time - GetTime();
	local cdTime = (2 ^ 32) / 1000 - start;
	local cdStartTime = startupTime - cdTime;
	local cdEndTime = cdStartTime + duration;
	local cdLeftDuration = cdEndTime - time;
    return cdLeftDuration;
end

--[[local cooldownList = {
	--[14342] = CHARACTER_PROFESSION_TAILORING, --(These global strings don't seem to exist in classic)).
	[14342] = L["Tailoring"], --Mooncloth.
};]]

local itemCooldowns = {};
if (NIT.isClassic) then
	itemCooldowns = {
		[15846] = L["Salt Shaker"],
	}
end

function NIT:recordCooldowns()
	if (NIT.isRetail) then
		return;
	end
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	if (not NIT.data.myChars[char].cooldowns) then
		NIT.data.myChars[char].cooldowns = {};
	end
	--GetNumTradeSkills() is 0 unless a prof window has been opened since logon.
	--But it doesn't matter because it only goes on cooldown when opening it to use it anyway.
	local count = {};
	local data = {};
	local error;
	local duplicateCheck = true;
	local numTradeSkills = GetNumTradeSkills() or 0;
	if (numTradeSkills < 1) then
		--Try crafts for enchanting.
		numTradeSkills = GetNumCrafts();
	end
	if (duplicateCheck) then
		for i = 1, numTradeSkills do
			local secondsLeft = GetTradeSkillCooldown(i) or GetCraftCooldown(i);
			if (secondsLeft and secondsLeft > 60) then
				local skillName = GetTradeSkillInfo(i) or GetCraftInfo(i);
				--NIT:debug("Check Skill:", skillName, "Cooldown:", secondsLeft);
				data[skillName] = secondsLeft;
				--Alchemy has 12 skills that share a cooldown, if there's more than 12 duplicate timestamps we have a rare bug.
				count[secondsLeft] = (count[secondsLeft] or 0) + 1;
				if (count[secondsLeft] > 15) then
					error = true;
				end
			end
		end
		if (not error) then
			for skillName, secondsLeft in pairs(data) do
				if (not NIT.data.myChars[char].cooldowns[skillName]) then
					NIT.data.myChars[char].cooldowns[skillName] = {};
				end
				NIT.data.myChars[char].cooldowns[skillName].time = GetServerTime() + secondsLeft;
			end
		end
	else
		for i = 1, numTradeSkills do
			local secondsLeft = GetTradeSkillCooldown(i);
			if (secondsLeft and secondsLeft > 60) then
				local skillName = GetTradeSkillInfo(i);
				--NIT:debug("Skill:", skillName, "Cooldown:", secondsLeft);
				if (not NIT.data.myChars[char].cooldowns[skillName]) then
					NIT.data.myChars[char].cooldowns[skillName] = {};
				end
				NIT.data.myChars[char].cooldowns[skillName].time = GetServerTime() + secondsLeft;
			end
		end
	end
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local item = Item:CreateFromBagAndSlot(bag, slot);
			if (item) then
				local itemID = item:GetItemID(item);
				local itemName = item:GetItemName(item);
				if (itemID and itemName and itemCooldowns[itemID]) then
					local startTime, duration, isEnabled = GetContainerItemCooldown(bag, slot);
					--local endTime = (startTime + duration) - (GetTime() - GetServerTime());
					local endTime = GetCooldownLeft(startTime, duration) + GetServerTime();
					if (isEnabled == 1 and startTime > 0 and duration > 0) then
						if (not NIT.data.myChars[char].cooldowns[itemName]) then
							NIT.data.myChars[char].cooldowns[itemName] = {};
						end
						NIT.data.myChars[char].cooldowns[itemName].time = endTime;
						--NIT:debug("Check Item:", itemName, "Cooldown:", endTime);
					end
				end
			end
		end
	end
end

--Fix and issue where the entire tradeskill list was recording a cooldown.
function NIT:fixCooldowns()
	local count = {};
	local found;
	for realm, v in pairs(NIT.db.global) do --Iterate realms.
		if (type(v) == "table" and v.myChars) then
			for char, v in pairs(v.myChars) do
				if (v.cooldowns) then
					for skill, vv in pairs(v.cooldowns) do
						count[vv.time] = (count[vv.time] or 0) + 1;
						if (count[vv.time] > 30) then
							local time = vv.time;
							for skill, data in pairs(v.cooldowns) do
								--Remove all duplicate timestamp entries.
								if (data.time and time == data.time) then
									NIT.db.global[realm].myChars[char].cooldowns[skill] = nil;
								end
							end
							NIT:print("Data error found in tradeskill cooldowns for " .. char .. "-" .. realm .. ", resetting cooldown data.");
							break;
						end
					end
				end
			end
		end
	end
end

function NIT:recordHunterData()
	if (NIT.expansionNum > 3) then
		return;
	end
	local _, class = UnitClass("player");
	if (class ~= "HUNTER") then
		return;
	end
	local char = UnitName("player");
	if (not NIT.data.myChars[char]) then
		NIT.data.myChars[char] = {};
	end
	local hasUI = HasPetUI();
	local hasPet, petHappiness, petLoyaltyRate, petCurrentXP, petMaxXP, petLevel, petName, petFamily, loyaltyString;
	local totalPetPoints, spentPetPoints = 0, 0;
	if (hasUI) then
		hasPet = true;
		petHappiness, _, petLoyaltyRate = GetPetHappiness();
		petCurrentXP, petMaxXP = GetPetExperience();
		petLevel = UnitLevel("pet");
		petName = UnitName("pet");
		petFamily = UnitCreatureFamily("pet");
		loyaltyString = GetPetLoyalty();
		totalPetPoints, spentPetPoints = GetPetTrainingPoints();
        --local percent = NIT:round((currXP/nextXP) * 100);
	else
		hasPet = false;
		--Fallback to stable for some data incase pet isn't out.
		_, petName, petLevel, petFamily, loyaltyString = GetStablePetInfo(0);
	end
	local isPetDead = false;
	if (UnitIsDead("pet")) then
		isPetDead = true;
	end
	local ammo, ammoType = NIT.getAmmoCount();
	NIT.data.myChars[char].hasPet = hasPet;
	NIT.data.myChars[char].isPetDead = isPetDead;
	NIT.data.myChars[char].ammo = ammo;
	NIT.data.myChars[char].ammoType = ammoType;
	--I check these before setting them so last data is displayed anyway and not overwritten with 0/nil.
	if (petHappiness) then
		NIT.data.myChars[char].petHappiness = petHappiness;
	end
	if (petLoyaltyRate) then
		NIT.data.myChars[char].petLoyaltyRate = petLoyaltyRate;
	end
	if (petCurrentXP) then
		NIT.data.myChars[char].petCurrentXP = petCurrentXP;
	end
	if (petMaxXP) then
		NIT.data.myChars[char].petMaxXP = petMaxXP;
	end
	if (petLevel) then
		NIT.data.myChars[char].petLevel = petLevel;
	end
	if (petLevel) then
		NIT.data.myChars[char].petName = petName;
	end
	if (petFamily) then
		NIT.data.myChars[char].petFamily = petFamily;
	end
	if (loyaltyString) then
		NIT.data.myChars[char].loyaltyString = loyaltyString;
	end
	if (totalPetPoints) then
		NIT.data.myChars[char].totalPetPoints = totalPetPoints;
	end
	if (spentPetPoints) then
		NIT.data.myChars[char].spentPetPoints = spentPetPoints;
	end
end

function NIT.getAverageDurability()
	local totalCurrent, totalMax = 0, 0;
	for i = 0, 19 do
		local current, max = GetInventoryItemDurability(i)
		if (current and max) then
			totalCurrent = totalCurrent + current;
			totalMax = totalMax + max;
		end
	end
	if (totalMax == 0) then
		--If no durability found then armor is off or they have unbreakable armor on.
		return 100;
	end
	local totalAverage = ((totalCurrent/totalMax)*100);
	return totalAverage;
end

function NIT.getAmmoCount()
	local slotID = GetInventorySlotInfo("AmmoSlot");
	if (slotID) then
		local itemID = GetInventoryItemID("player", slotID);
		if (itemID) then
			local ammoCount = GetItemCount(itemID);
			if (ammoCount) then
				return ammoCount, itemID;
			end
		end
	end
	return 0;
end

function NIT:getBagSlots()
	local freeSlots = 0;
	local totalSlots = 0;
	for bag = 0, NUM_BAG_SLOTS do
		local free, bagType = GetContainerNumFreeSlots(bag);
		local total = GetContainerNumSlots(bag);
		--Bag type 0 is a normal storage bag (non professon bag).
		if (bagType == 0) then
			freeSlots = freeSlots + free;
			totalSlots = totalSlots + total;
		end
	end
	return freeSlots, totalSlots;
end

--Throddle by function name, delays event for non-vital info and catches any extras to avoid spam when mass looting etc.
local throddle = true;
NIT.currentThroddles = {};
function NIT:throddleEventByFunc(event, time, func, ...)
	if (throddle and NIT.currentThroddles[func] == nil) then
		--Must be false and not nil.
		NIT.currentThroddles[func] = ... or false;
		C_Timer.After(time, function()
			self[func](self, NIT.currentThroddles[func]);
			NIT.currentThroddles[func] = nil;
		end)
	elseif (not throddle) then
		self[func](...);
	end
end

--Record character data every 60 seconds as a backup, there's good reason for this.
function NIT:tickerCharacterData()
	C_Timer.After(60, function()
		NIT:recordCharacterData()
		NIT:tickerCharacterData();
	end)
end

function NIT:resetCharData()
	if (NIT.db.global.resetCharData) then
		for k, v in pairs(NIT.db.global) do
			if (type(v) == "table" and k ~= "minimapIcon" and k ~= "data") then
				if (v.myChars) then
					NIT.db.global[k].myChars = {};
				end
			end
		end
		NIT:recalcAltsLineFrames();
		NIT:recordCharacterData();
	end
	NIT.db.global.resetCharData = false;
end
---Trades---

local f = CreateFrame("Frame");
f:RegisterEvent("TRADE_SHOW");
--f:RegisterEvent("TRADE_CLOSED");
--f:RegisterEvent("PLAYER_TRADE_MONEY");
f:RegisterEvent("TRADE_MONEY_CHANGED");
f:RegisterEvent("TRADE_ACCEPT_UPDATE");
f:RegisterEvent("TRADE_REQUEST_CANCEL");
f:RegisterEvent("UI_INFO_MESSAGE");
f:RegisterEvent("UI_ERROR_MESSAGE");
local playerMoney, targetMoney, tradeWho, tradeWhoClass = 0, 0, "", "";
local doTrade;
f:SetScript("OnEvent", function(self, event, ...)
	if (event == "TRADE_SHOW") then
		tradeWho = UnitName("npc");
		_, tradeWhoClass = UnitClass("npc");
	elseif (event == "TRADE_MONEY_CHANGED") then
		playerMoney = GetPlayerTradeMoney();
		targetMoney = GetTargetTradeMoney();
	elseif (event == "TRADE_ACCEPT_UPDATE") then
		playerMoney = GetPlayerTradeMoney();
		targetMoney = GetTargetTradeMoney();
	elseif (event == "TRADE_REQUEST_CANCEL") then
		NIT:resetCurrentTradeData();
	elseif (event == "UI_INFO_MESSAGE" or event == "UI_ERROR_MESSAGE") then
		local type, msg = ...;
		if (msg == ERR_TRADE_BAG_FULL or msg == ERR_TRADE_TARGET_BAG_FULL or msg == ERR_TRADE_CANCELLED
				or msg == ERR_TRADE_TARGET_MAX_LIMIT_CATEGORY_COUNT_EXCEEDED_IS) then
			NIT:resetCurrentTradeData();
		elseif (msg == ERR_TRADE_COMPLETE) then
			NIT:doTrade();
		end
	end
end)

function NIT:doTrade()
	local traded;
	local _, _, _, classColorHex = GetClassColor(string.upper(tradeWhoClass));
	--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
	if (not classColorHex and string.upper(tradeWhoClass) == "SHAMAN") then
		classColorHex = "ff0070dd";
	elseif (not classColorHex) then
		classColorHex = "ffffffff";
	end
	if (playerMoney > 0) then
		if (NIT.db.global.showMoneyTradedChat) then
			NIT:print("|HNITCustomLink:tradelog|h|cFF9CD6DE" .. L["gave"] .. "|r|h |r" .. NIT:getCoinString(playerMoney)
					.. NIT.chatColor .. " |HNITCustomLink:tradelog|h|cFF9CD6DE" .. L["to"] .. "|r |c"
					.. classColorHex .. tradeWho .. NIT.chatColor .. ".|h", nil, nil, true, true);
		end
		traded = true;
	end
	if (targetMoney > 0) then
		if (NIT.db.global.showMoneyTradedChat) then
			NIT:print("|HNITCustomLink:tradelog|h|cFF9CD6DE" .. L["received"] .. "|r|h |r" .. NIT:getCoinString(targetMoney)
					.. NIT.chatColor .. " |HNITCustomLink:tradelog|h|cFF9CD6DE" .. L["from"] .. "|r |c"
					.. classColorHex .. tradeWho .. NIT.chatColor .. ".|h", nil, nil, true, true);
		end
		traded = true;
	end
	if (not NIT.data.trades) then
		NIT.data.trades = {};
	end
	local where = GetZoneText() or "";
	if (NIT.inInstance) then
		local instanceName = GetInstanceInfo();
		where = instanceName;
	end
	if (traded) then
		local t = {
			playerMoney = playerMoney,
			targetMoney = targetMoney,
			tradeWho = tradeWho,
			tradeWhoClass = tradeWhoClass,
			where = where,
			time = GetServerTime(),
		};
		table.insert(NIT.data.trades, 1, t);
	end
	NIT:resetCurrentTradeData();
end

function NIT:resetCurrentTradeData()
	playerMoney, targetMoney, tradeWho, tradeWhoClass = 0, 0, "", "";
end

---Some intergration for softres.it
--instanceType can be raid/dungeon/unknown.
--isReload is if we did a reload inside a dungeon.
--isLogon is if we relogged inside a dungeon.
function NIT:pushInstanceEntered(instanceName, instanceID, instanceType, isReload, isLogon)
	if (Softresit and Softresit.NIT_ENTERED) then
		Softresit:NIT_ENTERED(instanceName, instanceID, instanceType, isReload, isLogon);
	end
end

function NIT:pushInstanceLeft(instanceName, instanceID)
	if (Softresit and Softresit.NIT_LEFT) then
		Softresit:NIT_LEFT(instanceName, instanceID);
	end
end

--Same instance as last we entered confirmed via NPC data (done only once mobs are seen).
function NIT:pushSameInstanceConfirmed(instanceName, instanceID)
	if (Softresit and Softresit.NIT_SAME_INSTANCE) then
		Softresit:NIT_SAME_INSTANCE(instanceName, instanceID);
	end
end

--Different instance than last we entered confirmed via NPC data (done only once mobs are seen).
function NIT:pushDifferentInstanceConfirmed(instanceName, instanceID)
	if (Softresit and Softresit.NIT_SAME_INSTANCE) then
		Softresit:NIT_DIFFERENT_INSTANCE(instanceName, instanceID);
	end
end