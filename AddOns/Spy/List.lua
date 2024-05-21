local HBDP = LibStub("HereBeDragons-Pins-2.0")
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("Spy")
local _

function Spy:RefreshCurrentList(player, source)
	local MainWindow = Spy.MainWindow
	if not MainWindow:IsShown() then
		return
	end

	local mode = Spy.db.profile.CurrentList
	local manageFunction = Spy.ListTypes[mode][2]
	if manageFunction then
		manageFunction()
	end

	local button = 1
	for index, data in pairs(Spy.CurrentList) do
		if button <= Spy.ButtonLimit then
			local description = ""
			local level = "??"
			local class = "UNKNOWN"
			local guild = "??"
--			local rank = 0
			local opacity = 1

			local playerData = SpyPerCharDB.PlayerData[data.player]
			if playerData then
				if playerData.level then
					level = playerData.level
					if playerData.isGuess == true and tonumber(playerData.level) < Spy.MaximumPlayerLevel then
						level = level.."+"
					end
				end
				if playerData.class then
					class = playerData.class
				end
				if playerData.guild then
					guild = playerData.guild
				end
--				if playerData.rank then
--					rank = playerData.rank
--				end
			end
			
			if Spy.db.profile.DisplayListData == "1NameLevelClass" then
				description = level.." "
				if L[class] and type(L[class]) == "string" then
					description = description..L[class]
				end
			elseif Spy.db.profile.DisplayListData == "2NameLevelGuild" then
				description = level.." "..guild
			elseif Spy.db.profile.DisplayListData == "3NameLevelOnly" then
				description = level.." "
			elseif Spy.db.profile.DisplayListData == "4NamePvPRank" then
				description = L["Rank"].." "..rank
			elseif Spy.db.profile.DisplayListData == "5NameGuild" then
				description = guild
			end
			if mode == 1 and Spy.InactiveList[data.player] then
				opacity = 0.5
			end
			if player == data.player then
				if not source or source ~= Spy.CharacterName then
					Spy:AlertPlayer(player, source)
					if not source then
						Spy:AnnouncePlayer(player)
					end
				end
			end

			Spy:SetBar(button, data.player, description, 100, "Class", class, nil, opacity)
			Spy.ButtonName[button] = data.player
			button = button + 1
		end
	end
	Spy.ListAmountDisplayed = button - 1

	if Spy.db.profile.ResizeSpy then
		Spy:AutomaticallyResize()
	else
		if not Spy.db.profile.InvertSpy then
			if not InCombatLockdown() and Spy.MainWindow:GetHeight()< 34 then
				Spy:RestoreMainWindowPosition(Spy.MainWindow:GetLeft(), Spy.MainWindow:GetTop(), Spy.MainWindow:GetWidth(), 34)
			end
		else
			if not InCombatLockdown() and Spy.MainWindow:GetHeight()< 34 then 
				Spy:RestoreMainWindowPosition(Spy.MainWindow:GetLeft(), Spy.MainWindow:GetBottom(), Spy.MainWindow:GetWidth(), 34)
			end
		end	
	end
	Spy:ManageBarsDisplayed()
end

function Spy:ManageNearbyList()
	local prioritiseKoS = Spy.db.profile.PrioritiseKoS

	local activeKoS = {}
	local active = {}
	for player in pairs(Spy.ActiveList) do
		local position = Spy.NearbyList[player]
		if position ~= nil then
			if prioritiseKoS and SpyPerCharDB.KOSData[player] then
				table.insert(activeKoS, { player = player, time = position })
			else
				table.insert(active, { player = player, time = position })
			end
		end
	end

	local inactiveKoS = {}
	local inactive = {}
	for player in pairs(Spy.InactiveList) do
		local position = Spy.NearbyList[player]
		if position ~= nil then
			if prioritiseKoS and SpyPerCharDB.KOSData[player] then
				table.insert(inactiveKoS, { player = player, time = position })
			else
				table.insert(inactive, { player = player, time = position })
			end
		end
	end

	table.sort(activeKoS, function(a, b) return a.time < b.time end)
	table.sort(inactiveKoS, function(a, b) return a.time < b.time end)
	table.sort(active, function(a, b) return a.time < b.time end)
	table.sort(inactive, function(a, b) return a.time < b.time end)

	local list = {}
	for player in pairs(activeKoS) do table.insert(list, activeKoS[player]) end
	for player in pairs(inactiveKoS) do table.insert(list, inactiveKoS[player]) end
	for player in pairs(active) do table.insert(list, active[player]) end
	for player in pairs(inactive) do table.insert(list, inactive[player]) end
	Spy.CurrentList = list
end

function Spy:ManageLastHourList()
	local list = {}
	for player in pairs(Spy.LastHourList) do
		table.insert(list, { player = player, time = Spy.LastHourList[player] })
	end
	table.sort(list, function(a, b) return a.time > b.time end)
	Spy.CurrentList = list
end

function Spy:ManageIgnoreList()
	local list = {}
	for player in pairs(SpyPerCharDB.IgnoreData) do
		local playerData = SpyPerCharDB.PlayerData[player]
		local position = time()
		if playerData then position = playerData.time end
		table.insert(list, { player = player, time = position })
	end
	table.sort(list, function(a, b) return a.time > b.time end)
	Spy.CurrentList = list
end

function Spy:ManageKillOnSightList()
	local list = {}
	for player in pairs(SpyPerCharDB.KOSData) do
		local playerData = SpyPerCharDB.PlayerData[player]
		local position = time()
		if playerData then position = playerData.time end
		table.insert(list, { player = player, time = position })
	end
	table.sort(list, function(a, b) return a.time > b.time end)
	Spy.CurrentList = list
end

function Spy:GetNearbyListSize()
	local entries = 0
	for v in pairs(Spy.NearbyList) do
		entries = entries + 1
	end
	return entries
end

function Spy:UpdateActiveCount()
    local activeCount = 0
    for k in pairs(Spy.ActiveList) do
        activeCount = activeCount + 1
    end
	local theFrame = Spy.MainWindow
    if activeCount > 0 then 
		theFrame.CountFrame.Text:SetText("|cFF0070DE" .. activeCount .. "|r") 
    else 
        theFrame.CountFrame.Text:SetText("|cFF0070DE0|r")
    end
end

function Spy:ManageExpirations()
	local mode = Spy.db.profile.CurrentList
	local expirationFunction = Spy.ListTypes[mode][3]
	if expirationFunction then
		expirationFunction()
	end
end

function Spy:ManageNearbyListExpirations()
	local expired = false
	local currentTime = time()
	for player in pairs(Spy.ActiveList) do
		if (currentTime - Spy.ActiveList[player]) > Spy.ActiveTimeout then
			Spy.InactiveList[player] = Spy.ActiveList[player]
			Spy.ActiveList[player] = nil
			expired = true
		end
	end
	if Spy.db.profile.RemoveUndetected ~= "Never" then
		for player in pairs(Spy.InactiveList) do
			if (currentTime - Spy.InactiveList[player]) > Spy.InactiveTimeout then
				if Spy.PlayerCommList[player] ~= nil then
					Spy.MapNoteList[Spy.PlayerCommList[player]].displayed = false
					Spy.MapNoteList[Spy.PlayerCommList[player]].worldIcon:Hide()
					HBDP:RemoveMinimapIcon(self, Spy.MapNoteList[Spy.PlayerCommList[player]].miniIcon)
					Spy.PlayerCommList[player] = nil
				end
				Spy.InactiveList[player] = nil
				Spy.NearbyList[player] = nil
				expired = true
			end
		end
	end
	if expired then
		Spy:RefreshCurrentList()
		Spy:UpdateActiveCount()
		if Spy.db.profile.HideSpy and Spy:GetNearbyListSize() == 0 then 
			if not InCombatLockdown() then
				Spy.MainWindow:Hide()
			else	
				Spy:HideSpyCombatCheck()
			end
		end
	end
end

function Spy:ManageLastHourListExpirations()
	local expired = false
	local currentTime = time()
	for player in pairs(Spy.LastHourList) do
		if (currentTime - Spy.LastHourList[player]) > 3600 then
			Spy.LastHourList[player] = nil
			expired = true
		end
	end
	if expired then
		Spy:RefreshCurrentList()
	end
end

function Spy:RemovePlayerFromList(player)
	Spy.NearbyList[player] = nil
	Spy.ActiveList[player] = nil
	Spy.InactiveList[player] = nil
	if Spy.PlayerCommList[player] ~= nil then
		Spy.MapNoteList[Spy.PlayerCommList[player]].displayed = false
		Spy.MapNoteList[Spy.PlayerCommList[player]].worldIcon:Hide()
		HBDP:RemoveMinimapIcon(self, Spy.MapNoteList[Spy.PlayerCommList[player]].miniIcon)
		Spy.PlayerCommList[player] = nil
	end
	Spy:RefreshCurrentList()
	Spy:UpdateActiveCount()	
end

function Spy:ClearList()
	if IsShiftKeyDown () then
		Spy:EnableSound(not Spy.db.profile.EnableSound, false)
	else	
		Spy.NearbyList = {}
		Spy.ActiveList = {}
		Spy.InactiveList = {}
		Spy.PlayerCommList = {}
		Spy.ListAmountDisplayed = 0
		for i = 1, Spy.MapNoteLimit do
			Spy.MapNoteList[i].displayed = false
			Spy.MapNoteList[i].worldIcon:Hide()
			HBDP:RemoveMinimapIcon(self, Spy.MapNoteList[i].miniIcon)
		end
		Spy:SetCurrentList(1)
		if IsControlKeyDown() then
			Spy:EnableSpy(not Spy.db.profile.Enabled, false)
		end
		Spy:UpdateActiveCount()
	end	
end

function Spy:AddPlayerData(name, class, level, race, guild, faction, isEnemy, isGuess)
	local info = {}
	info.name = name  --++ added to normalize data
	info.class = class
	if type(level) == "number" then info.level = level end
	info.race = race
	info.guild = guild
	info.faction = faction
	info.isEnemy = isEnemy
	info.isGuess = isGuess
	SpyPerCharDB.PlayerData[name] = info
	return SpyPerCharDB.PlayerData[name]
end

function Spy:UpdatePlayerData(name, class, level, race, guild, faction, isEnemy, isGuess)
	local detected = true
	local playerData = SpyPerCharDB.PlayerData[name]
	if not playerData then
		playerData = Spy:AddPlayerData(name, class, level, race, guild, faction, isEnemy, isGuess)
	else
		if name ~= nil then playerData.name = name end  
		if class ~= nil then playerData.class = class end
		if type(level) == "number" then playerData.level = level end
		if race ~= nil then playerData.race = race end
		if guild ~= nil then playerData.guild = guild end
		if faction ~= nil then playerData.faction = faction end
		if isEnemy ~= nil then playerData.isEnemy = isEnemy end
		if isGuess ~= nil then playerData.isGuess = isGuess end
	end
	if playerData then
		playerData.time = time()
		if not Spy.ActiveList[name] then
			if (WorldMapFrame:IsVisible() and Spy.db.profile.SwitchToZone) then
				WorldMapFrame:SetMapID(C_Map.GetBestMapForUnit("player"))
			end
			if (nil == C_Map.GetBestMapForUnit("player")) or (nil == C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player")) then
				local x,y = 0,0
				local InsName = GetInstanceInfo()
				playerData.zone = InsName
				playerData.subZone = ""
			else
				local mapX, mapY = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY()			
				if mapX ~= 0 and mapY ~= 0 then
					mapX = math.floor(tonumber(mapX) * 100) / 100
					mapY = math.floor(tonumber(mapY) * 100) / 100
					playerData.mapX = mapX
					playerData.mapY = mapY
					playerData.zone = GetZoneText()
					playerData.mapID = C_Map.GetBestMapForUnit("player") --++8.0
					playerData.subZone = GetSubZoneText()
				else
					detected = false
				end
			end
		end	
	end
	return detected
end

function Spy:UpdatePlayerStatus(name, class, level, race, guild, faction, isEnemy, isGuess)
	local playerData = SpyPerCharDB.PlayerData[name]
	if not playerData then
		playerData = Spy:AddPlayerData(name, class, level, race, guild, faction, isEnemy, isGuess)
	else
		if name ~= nil then playerData.name = name end  
		if class ~= nil then playerData.class = class end
		if type(level) == "number" then playerData.level = level end
		if race ~= nil then playerData.race = race end
		if guild ~= nil then playerData.guild = guild end
		if faction ~= nil then playerData.faction = faction end
		if isEnemy ~= nil then playerData.isEnemy = isEnemy end
		if isGuess ~= nil then playerData.isGuess = isGuess end
	end
	if playerData.time == nil then
		playerData.time = time()
	end	
end

function Spy:RemovePlayerData(name)
	local playerData = SpyPerCharDB.PlayerData[name]
		if ((playerData.loses == nil) and (playerData.wins == nil)) then
			SpyPerCharDB.PlayerData[name] = nil
		else
			playerData.isEnemy = false
		end
end

function Spy:RemovePlayerDataFromStats(name)
	SpyPerCharDB.PlayerData[name] = nil
end

function Spy:AddIgnoreData(name)
	SpyPerCharDB.IgnoreData[name] = true
end

function Spy:RemoveIgnoreData(name)
	if SpyPerCharDB.IgnoreData[name] then
		SpyPerCharDB.IgnoreData[name] = nil
	end
end

function Spy:AddKOSData(name)
	SpyPerCharDB.KOSData[name] = time()
--	SpyPerCharDB.PlayerData[name].kos = 1 
	if Spy.db.profile.ShareKOSBetweenCharacters then
		SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName][name] = nil
	end
end

function Spy:RemoveKOSData(name)
	if SpyPerCharDB.KOSData[name] then
		local playerData = SpyPerCharDB.PlayerData[name]
		if playerData and playerData.reason then
			playerData.reason = nil
		end
		SpyPerCharDB.KOSData[name] = nil
		if SpyPerCharDB.PlayerData[name] then
			SpyPerCharDB.PlayerData[name].kos = nil
		end
		if Spy.db.profile.ShareKOSBetweenCharacters then
			SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName][name] = time()
		end
	end
end

function Spy:SetKOSReason(name, reason, other)
	local playerData = SpyPerCharDB.PlayerData[name]
	if playerData then
		if not reason then
			playerData.reason = nil
		else
			if not playerData.reason then playerData.reason = {} end
			if reason == L["KOSReasonOther"] then
				if not other then 
					local dialog = StaticPopup_Show("Spy_SetKOSReasonOther", name)
					if dialog then
						dialog.playerName = name
					end
				else
					if other == "" then
						playerData.reason[L["KOSReasonOther"]] = nil
					else
						playerData.reason[L["KOSReasonOther"]] = other
					end
					Spy:RegenerateKOSCentralList(name)
				end
			else
				if playerData.reason[reason] then
					playerData.reason[reason] = nil
				else
					playerData.reason[reason] = true
				end
				Spy:RegenerateKOSCentralList(name)
			end
		end
	end
end

function Spy:AlertPlayer(player, source)
	local playerData = SpyPerCharDB.PlayerData[player]
	if SpyPerCharDB.KOSData[player] and Spy.db.profile.WarnOnKOS then
--		if Spy.db.profile.DisplayWarningsInErrorsFrame then
		if Spy.db.profile.DisplayWarnings == "ErrorFrame" then
			local text = Spy.db.profile.Colors.Warning["Warning Text"]
			local msg = L["KOSWarning"]..player
			UIErrorsFrame:AddMessage(msg, text.r, text.g, text.b, 1.0, UIERRORS_HOLD_TIME)
		else
			if source ~= nil and source ~= Spy.CharacterName then
				Spy:ShowAlert("kosaway", player, source, Spy:GetPlayerLocation(playerData))
			else
				local reasonText = ""
				if playerData.reason then
					for reason in pairs(playerData.reason) do
						if reasonText ~= "" then reasonText = reasonText..", " end
						if reason == L["KOSReasonOther"] then
							reasonText = reasonText..playerData.reason[reason]
						else
							reasonText = reasonText..reason
						end
					end
				end
				Spy:ShowAlert("kos", player, nil, reasonText)
			end
		end
		if Spy.db.profile.EnableSound then
			if source ~= nil and source ~= Spy.CharacterName then
				PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-kosaway.mp3", Spy.db.profile.SoundChannel)
			else
				PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-kos.mp3", Spy.db.profile.SoundChannel)
			end
		end
		if Spy.db.profile.ShareKOSBetweenCharacters then Spy:RegenerateKOSCentralList(player) end
	elseif Spy.db.profile.WarnOnKOSGuild then
		if playerData and playerData.guild and Spy.KOSGuild[playerData.guild] then
--			if Spy.db.profile.DisplayWarningsInErrorsFrame then
			if Spy.db.profile.DisplayWarnings == "ErrorFrame" then
				local text = Spy.db.profile.Colors.Warning["Warning Text"]
				local msg = L["KOSGuildWarning"].."<"..playerData.guild..">"
				UIErrorsFrame:AddMessage(msg, text.r, text.g, text.b, 1.0, UIERRORS_HOLD_TIME)				
			else
				if source ~= nil and source ~= Spy.CharacterName then
					Spy:ShowAlert("kosguildaway", "<"..playerData.guild..">", source, Spy:GetPlayerLocation(playerData))
				else
					Spy:ShowAlert("kosguild", "<"..playerData.guild..">")
				end
			end
			if Spy.db.profile.EnableSound then
				if source ~= nil and source ~= Spy.CharacterName then
					PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-kosaway.mp3", Spy.db.profile.SoundChannel)
				else
					PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-kosguild.mp3", Spy.db.profile.SoundChannel)
				end
			end
		else
			if Spy.db.profile.EnableSound and not Spy.db.profile.OnlySoundKoS then 
				if source == nil or source == Spy.CharacterName then
					if playerData and Spy.db.profile.WarnOnRace and playerData.race == Spy.db.profile.SelectWarnRace then --++
						PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-race.mp3", Spy.db.profile.SoundChannel) 
					else
						PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-nearby.mp3", Spy.db.profile.SoundChannel)
					end
				end
			end
		end 
	elseif Spy.db.profile.EnableSound and not Spy.db.profile.OnlySoundKoS then 
		if source == nil or source == Spy.CharacterName then
			if playerData and Spy.db.profile.WarnOnRace and playerData.race == Spy.db.profile.SelectWarnRace then
				PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-race.mp3", Spy.db.profile.SoundChannel) 
			else
				PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-nearby.mp3", Spy.db.profile.SoundChannel)
			end
		end
	elseif Spy.db.profile.EnableSound and not Spy.db.profile.OnlySoundKoS then
		if source == nil or source == Spy.CharacterName then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-nearby.mp3", Spy.db.profile.SoundChannel)
		end
	end
end

function Spy:AlertStealthPlayer(player)
	if Spy.db.profile.WarnOnStealth then
--		if Spy.db.profile.DisplayWarningsInErrorsFrame then
		if Spy.db.profile.DisplayWarnings == "ErrorFrame" then
			local text = Spy.db.profile.Colors.Warning["Warning Text"]
			local msg = L["StealthWarning"]..player
			UIErrorsFrame:AddMessage(msg, text.r, text.g, text.b, 1.0, UIERRORS_HOLD_TIME)
		else
			Spy:ShowAlert("stealth", player)
		end
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-stealth.mp3", Spy.db.profile.SoundChannel)
		end
	end
end

function Spy:AlertProwlPlayer(player)
	if Spy.db.profile.WarnOnStealth then
--		if Spy.db.profile.DisplayWarningsInErrorsFrame then
		if Spy.db.profile.DisplayWarnings == "ErrorFrame" then
			local text = Spy.db.profile.Colors.Warning["Warning Text"]
			local msg = L["StealthWarning"]..player
			UIErrorsFrame:AddMessage(msg, text.r, text.g, text.b, 1.0, UIERRORS_HOLD_TIME)
		else
			Spy:ShowAlert("prowl", player)
		end
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-stealth.mp3", Spy.db.profile.SoundChannel)
		end
	end
end

function Spy:AnnouncePlayer(player, channel)
	if not Spy_IgnoreList[player] then
		local msg = ""
		local isKOS = SpyPerCharDB.KOSData[player]
		local playerData = SpyPerCharDB.PlayerData[player]

		local announce = Spy.db.profile.Announce  
		if channel or announce == "Self" or announce == "LocalDefense" or (announce == "Guild" and GetGuildInfo("player") ~= nil and not Spy.InInstance) or (announce == "Party" and GetNumGroupMembers() > 0) or (announce == "Raid" and UnitInRaid("player")) then --++
			if announce == "Self" and not channel then
				if isKOS then
					msg = msg..L["SpySignatureColored"]..L["KillOnSightDetectedColored"]..player.." "
				else
					msg = msg..L["SpySignatureColored"]..L["PlayerDetectedColored"]..player.." "
				end
			else
				if isKOS then
					msg = msg..L["KillOnSightDetected"]..player.." "
				else
					msg = msg..L["PlayerDetected"]..player.." "
				end
			end
			if playerData then
				if playerData.guild and playerData.guild ~= "" then
					msg = msg.."<"..playerData.guild.."> "
				end
				if playerData.level or playerData.race or (playerData.class and playerData.class ~= "") then
					msg = msg.."- "
					if playerData.level and playerData.isGuess == false then
						msg = msg..L["Level"].." "..playerData.level.." "
					end
					if playerData.race and playerData.race ~= "" then
						msg = msg..playerData.race.." "
					end
					if playerData.class and playerData.class ~= "" then
						msg = msg..L[playerData.class].." "
					end
				end
				if playerData.zone then
					if playerData.subZone and playerData.subZone ~= "" and playerData.subZone ~= playerData.zone then
						msg = msg.."- "..playerData.subZone..", "..playerData.zone
					else
						msg = msg.."- "..playerData.zone
					end
				end
				if playerData.mapX and playerData.mapY then
					msg = msg.." ("..math.floor(tonumber(playerData.mapX) * 100)..","..math.floor(tonumber(playerData.mapY) * 100)..")"
				end
			end

			if channel then
				-- announce to selected channel
				if (channel == "PARTY" and GetNumGroupMembers() > 0) or (channel == "RAID" and UnitInRaid("player")) or (channel == "GUILD" and GetGuildInfo("player") ~= nil) then
					SendChatMessage(msg, channel)
				elseif channel == "LOCAL" then
					SendChatMessage(msg, "CHANNEL", nil, GetChannelName(L["LocalDefenseChannelName"].." - "..GetZoneText()))
				end
			else
				-- announce to standard channel
				if isKOS or not Spy.db.profile.OnlyAnnounceKoS then
					if announce == "Self" then
						DEFAULT_CHAT_FRAME:AddMessage(msg)
					elseif announce == "LocalDefense" then
						SendChatMessage(msg, "CHANNEL", nil, GetChannelName(L["LocalDefenseChannelName"].." - "..GetZoneText()))
					else
						SendChatMessage(msg, strupper(announce))
					end
				end
			end
		end

		-- announce to other Spy users
		if Spy.db.profile.ShareData then
			local class, level, race, zone, subZone, mapX, mapY, guild, mapID = "", "", "", "", "", "", "", "", ""
			if playerData then
				if playerData.class then class = playerData.class end
				if playerData.level and playerData.isGuess == false then level = playerData.level end
				if playerData.race then race = playerData.race end
				if playerData.zone then zone = playerData.zone end
				if playerData.mapID then mapID = playerData.mapID end
				if playerData.subZone then subZone = playerData.subZone end
				if playerData.mapX then mapX = playerData.mapX end
				if playerData.mapY then mapY = playerData.mapY end
				if playerData.guild then guild = playerData.guild end
			end
			local details = Spy.Version.."|"..player.."|"..class.."|"..level.."|"..race.."|"..zone.."|"..subZone.."|"..mapX.."|"..mapY.."|"..guild.."|"..mapID
			if strlen(details) < 240 then
				if channel then
					if (channel == "PARTY" and GetNumGroupMembers() > 0) or (channel == "RAID" and UnitInRaid("player")) or (channel == "GUILD" and GetGuildInfo("player") ~= nil) then
						Spy:SendCommMessage(Spy.Signature, details, channel)
					end
				else
					if GetNumGroupMembers() > 0 then
						Spy:SendCommMessage(Spy.Signature, details, "PARTY")
					end
					if UnitInRaid("player") then
						Spy:SendCommMessage(Spy.Signature, details, "RAID")
					end
					if Spy.InInstance == false and GetGuildInfo("player") ~= nil then
						Spy:SendCommMessage(Spy.Signature, details, "GUILD")
					end
				end
			end
		end
	end	
end

function Spy:SendKoStoGuild(player)
	local playerData = SpyPerCharDB.PlayerData[player]
	local class, level, race, zone, subZone, mapX, mapY, guild, mapID = "", "", "", "", "", "", "", "", ""	 			
	if playerData then
		if playerData.class then class = playerData.class end
		if playerData.level and playerData.isGuess == false then level = playerData.level end
		if playerData.race then race = playerData.race end
		if playerData.zone then zone = playerData.zone end
		if playerData.mapID then mapID = playerData.mapID end
		if playerData.subZone then subZone = playerData.subZone end
		if playerData.mapX then mapX = playerData.mapX end
		if playerData.mapY then mapY = playerData.mapY end
		if playerData.guild then guild = playerData.guild end
	end
	local details = Spy.Version.."|"..player.."|"..class.."|"..level.."|"..race.."|"..zone.."|"..subZone.."|"..mapX.."|"..mapY.."|"..guild.."|"..mapID
	if strlen(details) < 240 then
		if Spy.InInstance == false and GetGuildInfo("player") ~= nil then
			Spy:SendCommMessage(Spy.Signature, details, "GUILD")
		end
	end
end

function Spy:ToggleIgnorePlayer(ignore, player)
	if ignore then
		Spy:AddIgnoreData(player)
		Spy:RemoveKOSData(player)
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\list-add.mp3", Spy.db.profile.SoundChannel)
		end
		DEFAULT_CHAT_FRAME:AddMessage(L["SpySignatureColored"]..L["PlayerAddedToIgnoreColored"]..player)
	else
		Spy:RemoveIgnoreData(player)
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\list-remove.mp3", Spy.db.profile.SoundChannel)
		end
		DEFAULT_CHAT_FRAME:AddMessage(L["SpySignatureColored"]..L["PlayerRemovedFromIgnoreColored"]..player)
	end
	Spy:RegenerateKOSGuildList()
	if Spy.db.profile.ShareKOSBetweenCharacters then
		Spy:RegenerateKOSCentralList()
	end
	Spy:RefreshCurrentList()
end

function Spy:ToggleKOSPlayer(kos, player)
	if kos then
		Spy:AddKOSData(player)
		Spy:RemoveIgnoreData(player)
		if player ~= SpyPerCharDB.PlayerData[name] then
--			Spy:UpdatePlayerData(player, nil, nil, nil, nil, nil, true, nil)
			Spy:UpdatePlayerStatus(player, nil, nil, nil, nil, nil, true, nil)
			SpyPerCharDB.PlayerData[player].kos = 1
		end	
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\list-add.mp3", Spy.db.profile.SoundChannel)
		end
		DEFAULT_CHAT_FRAME:AddMessage(L["SpySignatureColored"]..L["PlayerAddedToKOSColored"]..player)
	else
		Spy:RemoveKOSData(player)
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\list-remove.mp3", Spy.db.profile.SoundChannel)
		end
		DEFAULT_CHAT_FRAME:AddMessage(L["SpySignatureColored"]..L["PlayerRemovedFromKOSColored"]..player)
	end
	Spy:RegenerateKOSGuildList()
	if Spy.db.profile.ShareKOSBetweenCharacters then
		Spy:RegenerateKOSCentralList()
	end
	Spy:RefreshCurrentList()
end

function Spy:PurgeUndetectedData()
	local secondsPerDay = 60 * 60 * 24
	local timeout = 90 * secondsPerDay
	if Spy.db.profile.PurgeData == "OneDay" then
		timeout = secondsPerDay
	elseif Spy.db.profile.PurgeData == "FiveDays" then
		timeout = 5 * secondsPerDay
	elseif Spy.db.profile.PurgeData == "TenDays" then
		timeout = 10 * secondsPerDay
	elseif Spy.db.profile.PurgeData == "ThirtyDays" then
		timeout = 30 * secondsPerDay
	elseif Spy.db.profile.PurgeData == "SixtyDays" then
		timeout = 60 * secondsPerDay
	elseif Spy.db.profile.PurgeData == "NinetyDays" then
		timeout = 90 * secondsPerDay
	end

	-- remove expired players held in character data
	local currentTime = time()
	for player in pairs(SpyPerCharDB.PlayerData) do
		local playerData = SpyPerCharDB.PlayerData[player]
		if Spy.db.profile.PurgeWinLossData then
--			if not playerData.time or (currentTime - playerData.time) > timeout or not playerData.isEnemy then
			if not playerData.time or (currentTime - playerData.time) > timeout then
				Spy:RemoveIgnoreData(player)
				Spy:RemoveKOSData(player)
				SpyPerCharDB.PlayerData[player] = nil
			end
		else
			if ((playerData.loses == nil) and (playerData.wins == nil)) then
--				if not playerData.time or (currentTime - playerData.time) > timeout or not playerData.isEnemy then
				if not playerData.time or (currentTime - playerData.time) > timeout then
					Spy:RemoveIgnoreData(player)
					if Spy.db.profile.PurgeKoS then
						Spy:RemoveKOSData(player)
						SpyPerCharDB.PlayerData[player] = nil
					else
						if (playerData.kos == nil) then
							SpyPerCharDB.PlayerData[player] = nil
						end	
					end	
				end
			end
		end
	end
	
	-- remove expired kos players held in central data
	local kosData = SpyDB.kosData[Spy.RealmName][Spy.FactionName]
	for characterName in pairs(kosData) do
		local characterKosData = kosData[characterName]
		for player in pairs(characterKosData) do
			local kosPlayerData = characterKosData[player]
			if Spy.db.profile.PurgeKoS then
				if not kosPlayerData.time or (currentTime - kosPlayerData.time) > timeout or not kosPlayerData.isEnemy then
					SpyDB.kosData[Spy.RealmName][Spy.FactionName][characterName][player] = nil
					SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName][player] = nil
				end
			end
		end
	end
	if not Spy.db.profile.AppendUnitNameCheck then 	
		Spy:AppendUnitNames() end
	if not Spy.db.profile.AppendUnitKoSCheck then
		Spy:AppendUnitKoS() end
end

function Spy:RegenerateKOSGuildList()
	Spy.KOSGuild = {}
	for player in pairs(SpyPerCharDB.KOSData) do
		local playerData = SpyPerCharDB.PlayerData[player]
		if playerData and playerData.guild then
			Spy.KOSGuild[playerData.guild] = true
		end
	end
end

function Spy:RemoveLocalKOSPlayers()
	for player in pairs(SpyPerCharDB.KOSData) do
		if SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName][player] then
			Spy:RemoveKOSData(player)
		end
	end
end

function Spy:RegenerateKOSCentralList(player)
	if player then
		local playerData = SpyPerCharDB.PlayerData[player]
		SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player] = {}
		if playerData then
			SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player] = playerData
		end
		SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player].added = SpyPerCharDB.KOSData[player]
	else
		for player in pairs(SpyPerCharDB.KOSData) do
			local playerData = SpyPerCharDB.PlayerData[player]
			SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player] = {}
			if playerData then
				SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player] = playerData
			end
			SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player].added = SpyPerCharDB.KOSData[player]
		end
	end
end

function Spy:RegenerateKOSListFromCentral()
	local kosData = SpyDB.kosData[Spy.RealmName][Spy.FactionName]
	for characterName in pairs(kosData) do
		if characterName ~= Spy.CharacterName then
			local characterKosData = kosData[characterName]
			for player in pairs(characterKosData) do
				if not SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName][player] then
					local playerData = SpyPerCharDB.PlayerData[player]
					if not playerData then
						playerData = Spy:AddPlayerData(player, class, level, race, guild, faction, isEnemy, isGuess)
					end
					local kosPlayerData = characterKosData[player]
					if kosPlayerData.time and (not playerData.time or (playerData.time and playerData.time < kosPlayerData.time)) then
						playerData.time = kosPlayerData.time
						if kosPlayerData.class then
							playerData.class = kosPlayerData.class
						end
						if type(kosPlayerData.level) == "number" and (type(playerData.level) ~= "number" or playerData.level < kosPlayerData.level) then
							playerData.level = kosPlayerData.level
						end
						if kosPlayerData.race then
							playerData.race = kosPlayerData.race
						end
						if kosPlayerData.guild then
							playerData.guild = kosPlayerData.guild
						end
						if kosPlayerData.faction then
							playerData.faction = kosPlayerData.faction
						end
						if kosPlayerData.isEnemy then
							playerData.isEnemy = kosPlayerData.isEnemy
						end
						if kosPlayerData.isGuess then
							playerData.isGuess = kosPlayerData.isGuess
						end
						if type(kosPlayerData.wins) == "number" and (type(playerData.wins) ~= "number" or playerData.wins < kosPlayerData.wins) then
							playerData.wins = kosPlayerData.wins
						end
						if type(kosPlayerData.loses) == "number" and (type(playerData.loses) ~= "number" or playerData.loses < kosPlayerData.loses) then
							playerData.loses = kosPlayerData.loses
						end
						if kosPlayerData.mapX then
							playerData.mapX = kosPlayerData.mapX
						end
						if kosPlayerData.mapY then
							playerData.mapY = kosPlayerData.mapY
						end
						if kosPlayerData.zone then
							playerData.zone = kosPlayerData.zone
						end
						if kosPlayerData.mapID then
							playerData.mapID = kosPlayerData.mapID
						end
						if kosPlayerData.subZone then
							playerData.subZone = kosPlayerData.subZone
						end
						if kosPlayerData.reason then
							playerData.reason = {}
							for reason in pairs(kosPlayerData.reason) do
								playerData.reason[reason] = kosPlayerData.reason[reason]
							end
						end
					end
					local characterKOSPlayerData = SpyPerCharDB.KOSData[player]
					if kosPlayerData.added and (not characterKOSPlayerData or characterKOSPlayerData < kosPlayerData.added) then
						SpyPerCharDB.KOSData[player] = kosPlayerData.added
					end
				end
			end
		end
	end
end

function Spy:ButtonClicked(self, button)
	local name = Spy.ButtonName[self.id]
	if name and name ~= "" then
		if button == "LeftButton" then
			if IsShiftKeyDown() then
				if SpyPerCharDB.KOSData[name] then
					Spy:ToggleKOSPlayer(false, name)
				else
					Spy:ToggleKOSPlayer(true, name)
				end
			elseif IsControlKeyDown() then
				if SpyPerCharDB.IgnoreData[name] then
					Spy:ToggleIgnorePlayer(false, name)
				else
					Spy:ToggleIgnorePlayer(true, name)
				end
			else
				if not InCombatLockdown() then
					self:SetAttribute("macrotext", "/targetexact "..name)
				end
			end
		elseif button == "RightButton" then
			Spy:BarDropDownOpen(self)
			CloseDropDownMenus(1)
			ToggleDropDownMenu(1, nil, Spy_BarDropDownMenu)
		end
	end
end

function Spy:ParseMinimapTooltip(tooltip)
	local newTooltip = ""
	local newLine = false
	for text in string.gmatch(tooltip, "[^\n]*") do
		local name = text
		if string.len(text) > 0 then
			if strsub(text, 1, 2) == "|T" then
			name = strtrim(gsub(gsub(text, "|T.-|t", ""), "|r", ""))
			end
			local playerData = SpyPerCharDB.PlayerData[name]
			if not playerData then
				for index, v in pairs(Spy.LastHourList) do
					local realmSeparator = strfind(index, "-")
					if realmSeparator and realmSeparator > 1 and strsub(index, 1, realmSeparator - 1) == strsub(name, 1, realmSeparator - 1) then
						playerData = SpyPerCharDB.PlayerData[index]
						break
					end
				end
			end
			if playerData and playerData.isEnemy then
				local desc = ""
				if playerData.class and playerData.level then
					desc = L["MinimapClassText"..playerData.class].." ["..playerData.level.." "..L[playerData.class].."]|r"
				elseif playerData.class then
					desc = L["MinimapClassText"..playerData.class].." ["..L[playerData.class].."]|r"
				elseif playerData.level then
					desc = " ["..playerData.level.."]|r"
				end
				if (newTooltip and desc == "") then
					newTooltip = text 
				elseif (newTooltip == "") then	
					newTooltip = text.."|r"..desc
				else
					newTooltip = newTooltip.."\r"..text.."|r"..desc
				end	
				if not SpyPerCharDB.IgnoreData[name] and not Spy.InInstance then
					local detected = Spy:UpdatePlayerData(name, nil, nil, nil, nil, nil, true, nil)
					if detected and Spy.db.profile.MinimapDetection then
						Spy:AddDetected(name, time(), false)
					end
				end
			else
				if (newTooltip == "") then
					newTooltip = text
				else	
					newTooltip = newTooltip.."\n"..text
				end
			end
			newLine = false
		elseif not newLine then
			newTooltip = newTooltip
			newLine = true
		end
	end
	return newTooltip
end

function Spy:ParseUnitAbility(analyseSpell, event, player, class, race, spellId, spellName)
	local learnt = false
	if player then
--		local class = nil
		local level = nil
--		local race = nil
		local isEnemy = true
		local isGuess = true

		local playerData = SpyPerCharDB.PlayerData[player]
		if not playerData or playerData.isEnemy == nil then
			learnt = true
		end

		if analyseSpell then
			local abilityType = strsub(event, 1, 5)
			if abilityType == "SWING" or abilityType == "SPELL" or abilityType == "RANGE" then
--				local ability = Spy_AbilityList[spellName]
				local ability = Spy_AbilityList[spellId]
				if ability then
					if class == nil then
						if ability.class and not (playerData and playerData.class) then
							class = ability.class
							learnt = true
						end
					end
					if ability.level then
						local playerLevelNumber = nil
						if playerData and playerData.level then
							playerLevelNumber = tonumber(playerData.level)
						end
						if type(playerLevelNumber) ~= "number" or playerLevelNumber < ability.level then
							level = ability.level
							learnt = true
						end
					end
					if race == nil then
						if ability.race and not (playerData and playerData.race) then
							race = ability.race
							learnt = true
						end
					end	
				else	
--					print(spellId, " - ", spellName)
				end
				if class and race and level == Spy.MaximumPlayerLevel then
					isGuess = false
					learnt = true
				end
			end
		end

		Spy:UpdatePlayerData(player, class, level, race, nil, nil, isEnemy, isGuess)
		return learnt, playerData
	end
	return learnt, nil
end

function Spy:ParseUnitDetails(player, class, level, race, zone, subZone, mapX, mapY, guild, mapID)
	if player then
		local playerData = SpyPerCharDB.PlayerData[player]
		if not playerData then
			playerData = Spy:AddPlayerData(player, class, level, race, guild, nil, true, true)
		else
			if not playerData.class then playerData.class = class end
			if level then
				local levelNumber = tonumber(level)
				if type(levelNumber) == "number" then
					if playerData.level then
						local playerLevelNumber = tonumber(playerData.level)
						if type(playerLevelNumber) == "number" and playerLevelNumber < levelNumber then playerData.level = levelNumber end
					else
						playerData.level = levelNumber
					end
				end
			end
			if not playerData.race then
				playerData.race = race
			end
			if not playerData.guild then
				playerData.guild = guild
			end
		end
		playerData.isEnemy = true
		playerData.time = time()
		playerData.zone = zone
		playerData.mapID = mapID
		playerData.subZone = subZone
		playerData.mapX = mapX
		playerData.mapY = mapY

		return true, playerData
	end
	return true, nil
end

function Spy:AddDetected(player, timestamp, learnt, source)
	if Spy.db.profile.StopAlertsOnTaxi then
		if not UnitOnTaxi("player") then 
			Spy:AddDetectedToLists(player, timestamp, learnt, source)
		end
	else
		Spy:AddDetectedToLists(player, timestamp, learnt, source)
	end
--[[if Spy.db.profile.ShowOnlyPvPFlagged then
		if UnitIsPVP("target") then
			Spy:AddDetectedToLists(player, timestamp, learnt, source)
		end	
	else
		Spy:AddDetectedToLists(player, timestamp, learnt, source)
	end ]]--
end

function Spy:AddDetectedToLists(player, timestamp, learnt, source)
	if not Spy.NearbyList[player] then
		if Spy.db.profile.ShowOnDetection and not Spy.db.profile.MainWindowVis then
			Spy:SetCurrentList(1)
			Spy:EnableSpy(true, true, true)
		end
		if Spy.db.profile.CurrentList ~= 1 and Spy.db.profile.MainWindowVis and Spy.db.profile.ShowNearbyList then
			Spy:SetCurrentList(1)
		end

		if source and source ~= Spy.CharacterName and not Spy.ActiveList[player] then
			Spy.NearbyList[player] = timestamp
			Spy.LastHourList[player] = timestamp
			Spy.InactiveList[player] = timestamp
		else
			Spy.NearbyList[player] = timestamp
			Spy.LastHourList[player] = timestamp
			Spy.ActiveList[player] = timestamp
			Spy.InactiveList[player] = nil
		end

		if Spy.db.profile.CurrentList == 1 then
			Spy:RefreshCurrentList(player, source)
			Spy:UpdateActiveCount()			
		else
			if not source or source ~= Spy.CharacterName then
				Spy:AlertPlayer(player, source)
				if not source then Spy:AnnouncePlayer(player) end
			end
		end
	elseif not Spy.ActiveList[player] then
		if Spy.db.profile.ShowOnDetection and not Spy.db.profile.MainWindowVis then
			Spy:SetCurrentList(1)
			Spy:EnableSpy(true, true, true)
		end
		if Spy.db.profile.CurrentList ~= 1 and Spy.db.profile.MainWindowVis and Spy.db.profile.ShowNearbyList then
			Spy:SetCurrentList(1)
		end

		Spy.LastHourList[player] = timestamp
		Spy.ActiveList[player] = timestamp
		Spy.InactiveList[player] = nil

		if Spy.PlayerCommList[player] ~= nil then
			if Spy.db.profile.CurrentList == 1 then
				Spy:RefreshCurrentList(player, source)
			else
				if not source or source ~= Spy.CharacterName then
					Spy:AlertPlayer(player, source)
					if not source then Spy:AnnouncePlayer(player) end
				end
			end
		else
			if Spy.db.profile.CurrentList == 1 then
				Spy:RefreshCurrentList()
				Spy:UpdateActiveCount()
			end
		end
	else
		Spy.ActiveList[player] = timestamp
		Spy.LastHourList[player] = timestamp
		if learnt and Spy.db.profile.CurrentList == 1 then
			Spy:RefreshCurrentList()
			Spy:UpdateActiveCount()
		end
	end
end

function Spy:AppendUnitNames()
	for key, unit in pairs(SpyPerCharDB.PlayerData) do	
		-- find any units without a name
		if not unit.name then
			local name = key
		-- if unit.name does not exist update info
			if (not unit.name) and name then
				unit.name = key
			end
		end
    end
	-- set profile so it only runs once
	Spy.db.profile.AppendUnitNameCheck=true
end

function Spy:AppendUnitKoS()
	for kosName, value in pairs(SpyPerCharDB.KOSData) do
		if kosName then	
			local playerData = SpyPerCharDB.PlayerData[kosName]
			if not playerData then 
				Spy:UpdatePlayerData(kosName, nil, nil, nil, nil, nil, true, nil) 
				SpyPerCharDB.PlayerData[kosName].kos = 1
				SpyPerCharDB.PlayerData[kosName].time = value
			end
		end
    end
	-- set profile so it only runs once
	Spy.db.profile.AppendUnitKoSCheck=true
end

Spy.ListTypes = {
	{L["Nearby"], Spy.ManageNearbyList, Spy.ManageNearbyListExpirations},
	{L["LastHour"], Spy.ManageLastHourList, Spy.ManageLastHourListExpirations},
	{L["Ignore"], Spy.ManageIgnoreList},
	{L["KillOnSight"], Spy.ManageKillOnSightList},
}

Spy_AbilityList = {
--++ Racial Traits ++	
	[822]={ race = "Blood Elf", level = 1, },
	[5227]={ race = "Undead", level = 1, },
	[6562]={ race = "Draenei", level = 1, },
	[7744]={ race = "Undead", level = 1, },
	[20549]={ race = "Tauren", level = 1, },
	[20550]={ race = "Tauren", level = 1, },
	[20551]={ race = "Tauren", level = 1, },
	[20552]={ race = "Tauren", level = 1, },
	[20555]={ race = "Troll", level = 1, },
	[20557]={ race = "Troll", level = 1, },
	[20558]={ race = "Troll", level = 1, },
	[20572]={ race = "Orc", level = 1, },
	[20573]={ race = "Orc", level = 1, },
	[20574]={ race = "Orc", level = 1, },
	[20575]={ race = "Orc", level = 1, },
	[20577]={ race = "Undead", level = 1, },
	[20579]={ race = "Undead", level = 1, },
	[20582]={ race = "Night Elf", level = 1, },
	[20583]={ race = "Night Elf", level = 1, },
	[20585]={ race = "Night Elf", level = 1, },
	[20589]={ race = "Gnome", level = 1, },
	[20591]={ race = "Gnome", level = 1, },
	[20592]={ race = "Gnome", level = 1, },
	[20593]={ race = "Gnome", level = 1, },
	[20594]={ race = "Dwarf", level = 1, },
	[20595]={ race = "Dwarf", level = 1, },
	[20596]={ race = "Dwarf", level = 1, },
	[20597]={ race = "Human", level = 1, },
	[20598]={ race = "Human", level = 1, },
	[20599]={ race = "Human", level = 1, },
	[20864]={ race = "Human", level = 1, },
	[25046]={ race = "Blood Elf", level = 1, },
	[26290]={ race = "Troll", level = 1, },
	[26297]={ race = "Troll", level = 1, },
	[28730]={ race = "Blood Elf", level = 1, },
	[28875]={ race = "Draenei", level = 1, },
	[28877]={ race = "Blood Elf", level = 1, },
	[28878]={ race = "Draenei", level = 1, },
	[28880]={ race = "Draenei", level = 1, },
	[33697]={ race = "Orc", level = 1, },
	[33702]={ race = "Orc", level = 1, },
	[50613]={ race = "Blood Elf", level = 1, },
	[54562]={ race = "Orc", level = 1, },
	[58943]={ race = "Troll", level = 1, },
	[58984]={ race = "Night Elf", level = 1, },
	[59221]={ race = "Draenei", level = 1, },
	[59224]={ race = "Dwarf", level = 1, },
	[59535]={ race = "Draenei", level = 1, },
	[59536]={ race = "Draenei", level = 1, },
	[59538]={ race = "Draenei", level = 1, },
	[59539]={ race = "Draenei", level = 1, },
	[59540]={ race = "Draenei", level = 1, },
	[59541]={ race = "Draenei", level = 1, },
	[59542]={ race = "Draenei", level = 1, },
	[59543]={ race = "Draenei", level = 1, },
	[59544]={ race = "Draenei", level = 1, },
	[59545]={ race = "Draenei", level = 1, },
	[59547]={ race = "Draenei", level = 1, },
	[59548]={ race = "Draenei", level = 1, },
	[59752]={ race = "Human", level = 1, },
	[65222]={ race = "Orc", level = 1, },
	[68975]={ race = "Worgen", level = 1, },
	[68976]={ race = "Worgen", level = 1, },
	[68978]={ race = "Worgen", level = 1, },
	[68992]={ race = "Worgen", level = 1, },
	[68996]={ race = "Worgen", level = 1, },
	[69041]={ race = "Goblin", level = 1, },
	[69042]={ race = "Goblin", level = 1, },
	[69044]={ race = "Goblin", level = 1, },
	[69045]={ race = "Goblin", level = 1, },
	[69046]={ race = "Goblin", level = 1, },
	[69070]={ race = "Goblin", level = 1, },
	[69179]={ race = "Blood Elf", level = 1, },
	[76252]={ race = "Night Elf", level = 1, },
	[79738]={ race = "Human", level = 1, },
	[79739]={ race = "Dwarf", level = 1, },
	[79740]={ race = "Gnome", level = 1, },
	[79741]={ race = "Draenei", level = 1, },
	[79742]={ race = "Worgen", level = 1, },
	[79743]={ race = "Orc", level = 1, },
	[79744]={ race = "Troll", level = 1, },
	[79746]={ race = "Tauren", level = 1, },
	[79747]={ race = "Undead", level = 1, },
	[79748]={ race = "Blood Elf", level = 1, },
	[79749]={ race = "Goblin", level = 1, },
	[80483]={ race = "Blood Elf", level = 1, },
	[87840]={ race = "Worgen", level = 1, },
	[92680]={ race = "Gnome", level = 1, },
	[92682]={ race = "Dwarf", level = 1, },
	[94293]={ race = "Worgen", level = 1, },
--++ Death Knight Abilities ++	
	[48778]={ class = "DEATHKNIGHT", level = 55, },
	[59879]={ class = "DEATHKNIGHT", level = 55, },
	[45902]={ class = "DEATHKNIGHT", level = 55, },
	[47541]={ class = "DEATHKNIGHT", level = 55, },
	[50977]={ class = "DEATHKNIGHT", level = 55, },
	[49576]={ class = "DEATHKNIGHT", level = 55, },
	[49410]={ class = "DEATHKNIGHT", level = 55, },
	[59921]={ class = "DEATHKNIGHT", level = 55, },
	[48266]={ class = "DEATHKNIGHT", level = 55, },
	[66198]={ class = "DEATHKNIGHT", level = 55, },
	[82246]={ class = "DEATHKNIGHT", level = 55, },
	[45462]={ class = "DEATHKNIGHT", level = 55, },
	[53341]={ class = "DEATHKNIGHT", level = 55, },
	[53343]={ class = "DEATHKNIGHT", level = 55, },
	[53428]={ class = "DEATHKNIGHT", level = 55, },
	[91107]={ class = "DEATHKNIGHT", level = 55, },
	[93099]={ class = "DEATHKNIGHT", level = 55, },
	[49998]={ class = "DEATHKNIGHT", level = 56, },
	[45470]={ class = "DEATHKNIGHT", level = 56, },
	[89832]={ class = "DEATHKNIGHT", level = 56, },
	[50842]={ class = "DEATHKNIGHT", level = 56, },
	[46584]={ class = "DEATHKNIGHT", level = 56, },
	[48263]={ class = "DEATHKNIGHT", level = 57, },
	[47528]={ class = "DEATHKNIGHT", level = 57, },
	[54447]={ class = "DEATHKNIGHT", level = 57, },
	[53342]={ class = "DEATHKNIGHT", level = 57, },
	[48721]={ class = "DEATHKNIGHT", level = 58, },
	[53331]={ class = "DEATHKNIGHT", level = 60, },
	[49020]={ class = "DEATHKNIGHT", level = 61, },
	[48792]={ class = "DEATHKNIGHT", level = 62, },
	[54446]={ class = "DEATHKNIGHT", level = 63, },
	[53323]={ class = "DEATHKNIGHT", level = 63, },
	[45529]={ class = "DEATHKNIGHT", level = 64, },
	[85948]={ class = "DEATHKNIGHT", level = 64, },
	[48743]={ class = "DEATHKNIGHT", level = 66, },
	[56815]={ class = "DEATHKNIGHT", level = 67, },
	[48707]={ class = "DEATHKNIGHT", level = 68, },
	[53344]={ class = "DEATHKNIGHT", level = 70, },
	[62158]={ class = "DEATHKNIGHT", level = 70, },
	[48265]={ class = "DEATHKNIGHT", level = 70, },
	[61999]={ class = "DEATHKNIGHT", level = 72, },
	[70164]={ class = "DEATHKNIGHT", level = 72, },
	[86061]={ class = "DEATHKNIGHT", level = 74, },
	[47568]={ class = "DEATHKNIGHT", level = 75, },
	[42650]={ class = "DEATHKNIGHT", level = 80, },
	[77575]={ class = "DEATHKNIGHT", level = 81, },
	[73975]={ class = "DEATHKNIGHT", level = 83, },
	[77606]={ class = "DEATHKNIGHT", level = 85, },
--++ Death Knight Talents ++	
	[51468]={ class = "DEATHKNIGHT", level = 55, },
	[51472]={ class = "DEATHKNIGHT", level = 55, },
	[51473]={ class = "DEATHKNIGHT", level = 55, },
	[51052]={ class = "DEATHKNIGHT", level = 55, },
	[49182]={ class = "DEATHKNIGHT", level = 55, },
	[49500]={ class = "DEATHKNIGHT", level = 55, },
	[49501]={ class = "DEATHKNIGHT", level = 55, },
	[48978]={ class = "DEATHKNIGHT", level = 55, },
	[49390]={ class = "DEATHKNIGHT", level = 55, },
	[49391]={ class = "DEATHKNIGHT", level = 55, },
	[49393]={ class = "DEATHKNIGHT", level = 55, },
	[54637]={ class = "DEATHKNIGHT", level = 55, },
	[49027]={ class = "DEATHKNIGHT", level = 55, },
	[49542]={ class = "DEATHKNIGHT", level = 55, },
	[50034]={ class = "DEATHKNIGHT", level = 55, },
	[49219]={ class = "DEATHKNIGHT", level = 55, },
	[49627]={ class = "DEATHKNIGHT", level = 55, },
	[49628]={ class = "DEATHKNIGHT", level = 55, },
	[49222]={ class = "DEATHKNIGHT", level = 55, },
	[81327]={ class = "DEATHKNIGHT", level = 55, },
	[81328]={ class = "DEATHKNIGHT", level = 55, },
	[48979]={ class = "DEATHKNIGHT", level = 55, },
	[49483]={ class = "DEATHKNIGHT", level = 55, },
	[50040]={ class = "DEATHKNIGHT", level = 55, },
	[50041]={ class = "DEATHKNIGHT", level = 55, },
	[49149]={ class = "DEATHKNIGHT", level = 55, },
	[50115]={ class = "DEATHKNIGHT", level = 55, },
	[91316]={ class = "DEATHKNIGHT", level = 55, },
	[91319]={ class = "DEATHKNIGHT", level = 55, },
	[81135]={ class = "DEATHKNIGHT", level = 55, },
	[81136]={ class = "DEATHKNIGHT", level = 55, },
	[49028]={ class = "DEATHKNIGHT", level = 55, },
	[63560]={ class = "DEATHKNIGHT", level = 55, },
	[96269]={ class = "DEATHKNIGHT", level = 55, },
	[96270]={ class = "DEATHKNIGHT", level = 55, },
	[55666]={ class = "DEATHKNIGHT", level = 55, },
	[55667]={ class = "DEATHKNIGHT", level = 55, },
	[51099]={ class = "DEATHKNIGHT", level = 55, },
	[51160]={ class = "DEATHKNIGHT", level = 55, },
	[49137]={ class = "DEATHKNIGHT", level = 55, },
	[49657]={ class = "DEATHKNIGHT", level = 55, },
	[49036]={ class = "DEATHKNIGHT", level = 55, },
	[49562]={ class = "DEATHKNIGHT", level = 55, },
	[81334]={ class = "DEATHKNIGHT", level = 55, },
	[49143]={ class = "DEATHKNIGHT", level = 55, },
	[85793]={ class = "DEATHKNIGHT", level = 55, },
	[85794]={ class = "DEATHKNIGHT", level = 55, },
	[55050]={ class = "DEATHKNIGHT", level = 55, },
	[49184]={ class = "DEATHKNIGHT", level = 55, },
	[55061]={ class = "DEATHKNIGHT", level = 55, },
	[55062]={ class = "DEATHKNIGHT", level = 55, },
	[50887]={ class = "DEATHKNIGHT", level = 55, },
	[50365]={ class = "DEATHKNIGHT", level = 55, },
	[50371]={ class = "DEATHKNIGHT", level = 55, },
	[94553]={ class = "DEATHKNIGHT", level = 55, },
	[94555]={ class = "DEATHKNIGHT", level = 55, },
	[62905]={ class = "DEATHKNIGHT", level = 55, },
	[62908]={ class = "DEATHKNIGHT", level = 55, },
	[81138]={ class = "DEATHKNIGHT", level = 55, },
	[50384]={ class = "DEATHKNIGHT", level = 55, },
	[50385]={ class = "DEATHKNIGHT", level = 55, },
	[55610]={ class = "DEATHKNIGHT", level = 55, },
	[48985]={ class = "DEATHKNIGHT", level = 55, },
	[49488]={ class = "DEATHKNIGHT", level = 55, },
	[49489]={ class = "DEATHKNIGHT", level = 55, },
	[50391]={ class = "DEATHKNIGHT", level = 55, },
	[50392]={ class = "DEATHKNIGHT", level = 55, },
	[51123]={ class = "DEATHKNIGHT", level = 55, },
	[51127]={ class = "DEATHKNIGHT", level = 55, },
	[51128]={ class = "DEATHKNIGHT", level = 55, },
	[49039]={ class = "DEATHKNIGHT", level = 55, },
	[49224]={ class = "DEATHKNIGHT", level = 55, },
	[49610]={ class = "DEATHKNIGHT", level = 55, },
	[49611]={ class = "DEATHKNIGHT", level = 55, },
	[52143]={ class = "DEATHKNIGHT", level = 55, },
	[49024]={ class = "DEATHKNIGHT", level = 55, },
	[49538]={ class = "DEATHKNIGHT", level = 55, },
	[81330]={ class = "DEATHKNIGHT", level = 55, },
	[81332]={ class = "DEATHKNIGHT", level = 55, },
	[81333]={ class = "DEATHKNIGHT", level = 55, },
	[48963]={ class = "DEATHKNIGHT", level = 55, },
	[49564]={ class = "DEATHKNIGHT", level = 55, },
	[49565]={ class = "DEATHKNIGHT", level = 55, },
	[49226]={ class = "DEATHKNIGHT", level = 55, },
	[50137]={ class = "DEATHKNIGHT", level = 55, },
	[50138]={ class = "DEATHKNIGHT", level = 55, },
	[51986]={ class = "DEATHKNIGHT", level = 55, },
	[51271]={ class = "DEATHKNIGHT", level = 55, },
	[51745]={ class = "DEATHKNIGHT", level = 55, },
	[51746]={ class = "DEATHKNIGHT", level = 55, },
	[91323]={ class = "DEATHKNIGHT", level = 55, },
	[56835]={ class = "DEATHKNIGHT", level = 55, },
	[81338]={ class = "DEATHKNIGHT", level = 55, },
	[81339]={ class = "DEATHKNIGHT", level = 55, },
	[49188]={ class = "DEATHKNIGHT", level = 55, },
	[56822]={ class = "DEATHKNIGHT", level = 55, },
	[59057]={ class = "DEATHKNIGHT", level = 55, },
	[48982]={ class = "DEATHKNIGHT", level = 55, },
	[51459]={ class = "DEATHKNIGHT", level = 55, },
	[51462]={ class = "DEATHKNIGHT", level = 55, },
	[81229]={ class = "DEATHKNIGHT", level = 55, },
	[49455]={ class = "DEATHKNIGHT", level = 55, },
	[50147]={ class = "DEATHKNIGHT", level = 55, },
	[91145]={ class = "DEATHKNIGHT", level = 55, },
	[81125]={ class = "DEATHKNIGHT", level = 55, },
	[81127]={ class = "DEATHKNIGHT", level = 55, },
	[81131]={ class = "DEATHKNIGHT", level = 55, },
	[81132]={ class = "DEATHKNIGHT", level = 55, },
	[49004]={ class = "DEATHKNIGHT", level = 55, },
	[49508]={ class = "DEATHKNIGHT", level = 55, },
	[49509]={ class = "DEATHKNIGHT", level = 55, },
	[55090]={ class = "DEATHKNIGHT", level = 55, },
	[48965]={ class = "DEATHKNIGHT", level = 55, },
	[49571]={ class = "DEATHKNIGHT", level = 55, },
	[49572]={ class = "DEATHKNIGHT", level = 55, },
	[49018]={ class = "DEATHKNIGHT", level = 55, },
	[49529]={ class = "DEATHKNIGHT", level = 55, },
	[49530]={ class = "DEATHKNIGHT", level = 55, },
	[49206]={ class = "DEATHKNIGHT", level = 55, },
	[65661]={ class = "DEATHKNIGHT", level = 55, },
	[66191]={ class = "DEATHKNIGHT", level = 55, },
	[66192]={ class = "DEATHKNIGHT", level = 55, },
	[49042]={ class = "DEATHKNIGHT", level = 55, },
	[49786]={ class = "DEATHKNIGHT", level = 55, },
	[49787]={ class = "DEATHKNIGHT", level = 55, },
	[49194]={ class = "DEATHKNIGHT", level = 55, },
	[49588]={ class = "DEATHKNIGHT", level = 55, },
	[49589]={ class = "DEATHKNIGHT", level = 55, },
	[55233]={ class = "DEATHKNIGHT", level = 55, },
	[50029]={ class = "DEATHKNIGHT", level = 55, },
	[48962]={ class = "DEATHKNIGHT", level = 55, },
	[49567]={ class = "DEATHKNIGHT", level = 55, },
	[49568]={ class = "DEATHKNIGHT", level = 55, },
	[52284]={ class = "DEATHKNIGHT", level = 55, },
	[81163]={ class = "DEATHKNIGHT", level = 55, },
	[81164]={ class = "DEATHKNIGHT", level = 55, },
--++ Druid Abilities ++	
	[84735]={ class = "DRUID", level = 1, },
	[84738]={ class = "DRUID", level = 1, },
	[96429]={ class = "DRUID", level = 1, },
	[87335]={ class = "DRUID", level = 1, },
	[87305]={ class = "DRUID", level = 1, },
	[33601]={ class = "DRUID", level = 1, },
	[33602]={ class = "DRUID", level = 1, },
	[85101]={ class = "DRUID", level = 1, },
	[16961]={ class = "DRUID", level = 1, },
	[87793]={ class = "DRUID", level = 1, },
	[84840]={ class = "DRUID", level = 1, },
	[79577]={ class = "DRUID", level = 1, },
	[60089]={ class = "DRUID", level = 1, },
	[80861]={ class = "DRUID", level = 1, },
	[84736]={ class = "DRUID", level = 1, },
	[80951]={ class = "DRUID", level = 1, },
	[44203]={ class = "DRUID", level = 1, },
	[5176]={ class = "DRUID", level = 1, },
	[774]={ class = "DRUID", level = 3, },
	[81283]={ class = "DRUID", level = 4, },
	[81291]={ class = "DRUID", level = 4, },
	[8921]={ class = "DRUID", level = 4, },
	[93402]={ class = "DRUID", level = 4, },
	[339]={ class = "DRUID", level = 7, },
	[768]={ class = "DRUID", level = 8, },
	[1082]={ class = "DRUID", level = 8, },
	[50464]={ class = "DRUID", level = 8, },
	[1822]={ class = "DRUID", level = 8, },
	[2912]={ class = "DRUID", level = 8, },
	[22568]={ class = "DRUID", level = 10, },
	[33876]={ class = "DRUID", level = 10, },
	[33878]={ class = "DRUID", level = 10, },
	[5215]={ class = "DRUID", level = 10, },
	[8936]={ class = "DRUID", level = 12, },
	[50769]={ class = "DRUID", level = 12, },
	[5487]={ class = "DRUID", level = 15, },
	[99]={ class = "DRUID", level = 15, },
	[6795]={ class = "DRUID", level = 15, },
	[6807]={ class = "DRUID", level = 15, },
	[18960]={ class = "DRUID", level = 15, },
	[1066]={ class = "DRUID", level = 16, },
	[783]={ class = "DRUID", level = 16, },
	[779]={ class = "DRUID", level = 18, },
	[16979]={ class = "DRUID", level = 20, },
	[49376]={ class = "DRUID", level = 20, },
	[5570]={ class = "DRUID", level = 20, },
	[20484]={ class = "DRUID", level = 20, },
	[5229]={ class = "DRUID", level = 22, },
	[6785]={ class = "DRUID", level = 22, },
	[81170]={ class = "DRUID", level = 22, },
	[80964]={ class = "DRUID", level = 22, },
	[80965]={ class = "DRUID", level = 22, },
	[770]={ class = "DRUID", level = 24, },
	[16857]={ class = "DRUID", level = 24, },
	[2782]={ class = "DRUID", level = 24, },
	[5217]={ class = "DRUID", level = 24, },
	[8998]={ class = "DRUID", level = 26, },
	[1850]={ class = "DRUID", level = 26, },
	[20719]={ class = "DRUID", level = 26, },
	[5209]={ class = "DRUID", level = 28, },
	[29166]={ class = "DRUID", level = 28, },
	[2908]={ class = "DRUID", level = 28, },
	[1126]={ class = "DRUID", level = 30, },
	[5211]={ class = "DRUID", level = 32, },
	[9005]={ class = "DRUID", level = 32, },
	[5225]={ class = "DRUID", level = 32, },
	[62078]={ class = "DRUID", level = 36, },
	[62600]={ class = "DRUID", level = 40, },
	[16914]={ class = "DRUID", level = 44, },
	[450759]={ class = "DRUID", level = 44, },
	[5221]={ class = "DRUID", level = 46, },
	[2637]={ class = "DRUID", level = 48, },
	[22842]={ class = "DRUID", level = 52, },
	[16689]={ class = "DRUID", level = 52, },
	[1079]={ class = "DRUID", level = 54, },
	[22812]={ class = "DRUID", level = 58, },
	[33943]={ class = "DRUID", level = 60, },
	[22570]={ class = "DRUID", level = 62, },
	[33763]={ class = "DRUID", level = 64, },
	[33745]={ class = "DRUID", level = 66, },
	[740]={ class = "DRUID", level = 68, },
	[40120]={ class = "DRUID", level = 70, },
	[33786]={ class = "DRUID", level = 74, },
	[52610]={ class = "DRUID", level = 76, },
	[5185]={ class = "DRUID", level = 78, },
	[78777]={ class = "DRUID", level = 80, },
	[77758]={ class = "DRUID", level = 81, },
	[77761]={ class = "DRUID", level = 83, },
	[77764]={ class = "DRUID", level = 83, },
	[88747]={ class = "DRUID", level = 85, },
	[88751]={ class = "DRUID", level = 85, },
--++ Druid Talents ++	
	[33592]={ class = "DRUID", level = 10, },
	[33596]={ class = "DRUID", level = 10, },
	[50334]={ class = "DRUID", level = 10, },
	[78784]={ class = "DRUID", level = 10, },
	[78785]={ class = "DRUID", level = 10, },
	[80318]={ class = "DRUID", level = 59, },
	[80863]={ class = "DRUID", level = 59, },
	[80319]={ class = "DRUID", level = 61, },
	[16940]={ class = "DRUID", level = 10, },
	[16941]={ class = "DRUID", level = 10, },
	[80554]={ class = "DRUID", level = 10, },
	[33597]={ class = "DRUID", level = 10, },
	[33599]={ class = "DRUID", level = 10, },
	[48506]={ class = "DRUID", level = 10, },
	[34151]={ class = "DRUID", level = 10, },
	[81274]={ class = "DRUID", level = 10, },
	[81275]={ class = "DRUID", level = 10, },
	[33888]={ class = "DRUID", level = 10, },
	[33889]={ class = "DRUID", level = 10, },
	[33890]={ class = "DRUID", level = 10, },
	[33879]={ class = "DRUID", level = 10, },
	[33880]={ class = "DRUID", level = 10, },
	[80314]={ class = "DRUID", level = 10, },
	[80315]={ class = "DRUID", level = 10, },
	[81061]={ class = "DRUID", level = 10, },
	[81062]={ class = "DRUID", level = 10, },
	[16858]={ class = "DRUID", level = 10, },
	[16859]={ class = "DRUID", level = 10, },
	[49377]={ class = "DRUID", level = 10, },
	[16949]={ class = "DRUID", level = 10, },
	[17002]={ class = "DRUID", level = 10, },
	[24866]={ class = "DRUID", level = 10, },
	[33831]={ class = "DRUID", level = 10, },
	[78788]={ class = "DRUID", level = 10, },
	[78789]={ class = "DRUID", level = 10, },
	[17056]={ class = "DRUID", level = 10, },
	[17058]={ class = "DRUID", level = 10, },
	[17059]={ class = "DRUID", level = 10, },
	[17104]={ class = "DRUID", level = 10, },
	[24943]={ class = "DRUID", level = 10, },
	[48532]={ class = "DRUID", level = 10, },
	[80552]={ class = "DRUID", level = 10, },
	[80553]={ class = "DRUID", level = 10, },
	[48488]={ class = "DRUID", level = 10, },
	[48514]={ class = "DRUID", level = 10, },
	[57810]={ class = "DRUID", level = 10, },
	[57811]={ class = "DRUID", level = 10, },
	[57812]={ class = "DRUID", level = 10, },
	[51179]={ class = "DRUID", level = 10, },
	[51180]={ class = "DRUID", level = 10, },
	[51181]={ class = "DRUID", level = 10, },
	[17003]={ class = "DRUID", level = 10, },
	[17004]={ class = "DRUID", level = 10, },
	[17005]={ class = "DRUID", level = 10, },
	[48521]={ class = "DRUID", level = 10, },
	[17111]={ class = "DRUID", level = 10, },
	[17112]={ class = "DRUID", level = 10, },
	[17113]={ class = "DRUID", level = 10, },
	[17123]={ class = "DRUID", level = 10, },
	[17124]={ class = "DRUID", level = 10, },
	[48483]={ class = "DRUID", level = 10, },
	[48484]={ class = "DRUID", level = 10, },
	[48492]={ class = "DRUID", level = 10, },
	[48494]={ class = "DRUID", level = 10, },
	[48495]={ class = "DRUID", level = 10, },
	[17007]={ class = "DRUID", level = 10, },
	[48496]={ class = "DRUID", level = 10, },
	[48499]={ class = "DRUID", level = 10, },
	[48500]={ class = "DRUID", level = 10, },
	[33589]={ class = "DRUID", level = 10, },
	[33590]={ class = "DRUID", level = 10, },
	[33591]={ class = "DRUID", level = 10, },
	[16896]={ class = "DRUID", level = 10, },
	[16897]={ class = "DRUID", level = 10, },
	[16899]={ class = "DRUID", level = 10, },
	[33603]={ class = "DRUID", level = 10, },
	[33604]={ class = "DRUID", level = 10, },
	[33605]={ class = "DRUID", level = 10, },
	[92363]={ class = "DRUID", level = 10, },
	[92364]={ class = "DRUID", level = 10, },
	[33917]={ class = "DRUID", level = 50, },
	[48411]={ class = "DRUID", level = 10, },
	[16913]={ class = "DRUID", level = 10, },
	[16845]={ class = "DRUID", level = 10, },
	[16846]={ class = "DRUID", level = 10, },
	[16847]={ class = "DRUID", level = 10, },
	[24858]={ class = "DRUID", level = 10, },
	[57878]={ class = "DRUID", level = 10, },
	[57880]={ class = "DRUID", level = 10, },
	[16833]={ class = "DRUID", level = 10, },
	[16834]={ class = "DRUID", level = 10, },
	[17069]={ class = "DRUID", level = 10, },
	[17070]={ class = "DRUID", level = 10, },
	[17074]={ class = "DRUID", level = 10, },
	[17075]={ class = "DRUID", level = 10, },
	[17076]={ class = "DRUID", level = 10, },
	[88423]={ class = "DRUID", level = 10, },
	[16880]={ class = "DRUID", level = 10, },
	[61345]={ class = "DRUID", level = 10, },
	[61346]={ class = "DRUID", level = 10, },
	[35363]={ class = "DRUID", level = 10, },
	[35364]={ class = "DRUID", level = 10, },
	[17116]={ class = "DRUID", level = 10, },
	[33881]={ class = "DRUID", level = 10, },
	[33882]={ class = "DRUID", level = 10, },
	[33872]={ class = "DRUID", level = 10, },
	[33873]={ class = "DRUID", level = 10, },
	[16864]={ class = "DRUID", level = 10, },
	[16840]={ class = "DRUID", level = 10, },
	[48389]={ class = "DRUID", level = 39, },
	[48392]={ class = "DRUID", level = 41, },
	[48393]={ class = "DRUID", level = 43, },
	[78734]={ class = "DRUID", level = 19, },
	[78735]={ class = "DRUID", level = 21, },
	[78736]={ class = "DRUID", level = 23, },
	[78737]={ class = "DRUID", level = 23, },
	[78738]={ class = "DRUID", level = 23, },
	[48525]={ class = "DRUID", level = 10, },
	[48516]={ class = "DRUID", level = 10, },
	[33859]={ class = "DRUID", level = 10, },
	[33866]={ class = "DRUID", level = 10, },
	[33867]={ class = "DRUID", level = 10, },
	[16972]={ class = "DRUID", level = 10, },
	[16974]={ class = "DRUID", level = 10, },
	[37116]={ class = "DRUID", level = 10, },
	[37117]={ class = "DRUID", level = 10, },
	[80316]={ class = "DRUID", level = 49, },
	[80879]={ class = "DRUID", level = 49, },
	[17080]={ class = "DRUID", level = 49, },
	[80886]={ class = "DRUID", level = 49, },
	[80317]={ class = "DRUID", level = 51, },
	[57873]={ class = "DRUID", level = 10, },
	[57876]={ class = "DRUID", level = 10, },
	[57877]={ class = "DRUID", level = 10, },
	[80313]={ class = "DRUID", level = 10, },
	[48432]={ class = "DRUID", level = 10, },
	[48433]={ class = "DRUID", level = 10, },
	[48434]={ class = "DRUID", level = 10, },
	[48539]={ class = "DRUID", level = 10, },
	[48544]={ class = "DRUID", level = 10, },
	[93398]={ class = "DRUID", level = 10, },
	[93399]={ class = "DRUID", level = 10, },
	[78675]={ class = "DRUID", level = 10, },
	[78892]={ class = "DRUID", level = 31, },
	[81016]={ class = "DRUID", level = 31, },
	[81021]={ class = "DRUID", level = 31, },
	[78893]={ class = "DRUID", level = 33, },
	[81017]={ class = "DRUID", level = 33, },
	[81022]={ class = "DRUID", level = 33, },
	[48505]={ class = "DRUID", level = 10, },
	[16814]={ class = "DRUID", level = 10, },
	[16815]={ class = "DRUID", level = 10, },
	[16816]={ class = "DRUID", level = 10, },
	[78674]={ class = "DRUID", level = 10, },
	[93401]={ class = "DRUID", level = 10, },
	[61336]={ class = "DRUID", level = 10, },
	[33886]={ class = "DRUID", level = 10, },
	[18562]={ class = "DRUID", level = 10, },
	[16929]={ class = "DRUID", level = 10, },
	[16930]={ class = "DRUID", level = 10, },
	[16931]={ class = "DRUID", level = 10, },
	[33891]={ class = "DRUID", level = 10, },
	[65139]={ class = "DRUID", level = 10, },
	[50516]={ class = "DRUID", level = 10, },
	[48438]={ class = "DRUID", level = 10, },
--++ Hunter Abilities ++	
	[87325]={ class = "HUNTER", level = 1, },
	[87326]={ class = "HUNTER", level = 1, },
	[87324]={ class = "HUNTER", level = 1, },
	[84729]={ class = "HUNTER", level = 1, },
	[3044]={ class = "HUNTER", level = 1, },
	[75]={ class = "HUNTER", level = 1, },
	[883]={ class = "HUNTER", level = 1, },
	[982]={ class = "HUNTER", level = 1, },
	[56641]={ class = "HUNTER", level = 3, },
	[1494]={ class = "HUNTER", level = 4, },
	[2973]={ class = "HUNTER", level = 6, },
	[5116]={ class = "HUNTER", level = 8, },
	[82243]={ class = "HUNTER", level = 8, },
	[82928]={ class = "HUNTER", level = 10, },
	[1462]={ class = "HUNTER", level = 10, },
	[2641]={ class = "HUNTER", level = 10, },
	[6991]={ class = "HUNTER", level = 10, },
	[1539]={ class = "HUNTER", level = 10, },
	[34026]={ class = "HUNTER", level = 10, },
	[1978]={ class = "HUNTER", level = 10, },
	[1515]={ class = "HUNTER", level = 10, },
	[13165]={ class = "HUNTER", level = 12, },
	[19883]={ class = "HUNTER", level = 12, },
	[2974]={ class = "HUNTER", level = 12, },
	[781]={ class = "HUNTER", level = 14, },
	[1130]={ class = "HUNTER", level = 14, },
	[6197]={ class = "HUNTER", level = 16, },
	[136]={ class = "HUNTER", level = 16, },
	[83242]={ class = "HUNTER", level = 18, },
	[19884]={ class = "HUNTER", level = 18, },
	[13795]={ class = "HUNTER", level = 22, },
	[82945]={ class = "HUNTER", level = 22, },
	[5118]={ class = "HUNTER", level = 24, },
	[2643]={ class = "HUNTER", level = 24, },
	[19885]={ class = "HUNTER", level = 26, },
	[1499]={ class = "HUNTER", level = 28, },
	[60192]={ class = "HUNTER", level = 28, },
	[5384]={ class = "HUNTER", level = 32, },
	[19880]={ class = "HUNTER", level = 34, },
	[53351]={ class = "HUNTER", level = 35, },
	[19801]={ class = "HUNTER", level = 35, },
	[1513]={ class = "HUNTER", level = 36, },
	[19878]={ class = "HUNTER", level = 36, },
	[13813]={ class = "HUNTER", level = 38, },
	[82939]={ class = "HUNTER", level = 38, },
	[1543]={ class = "HUNTER", level = 38, },
	[82654]={ class = "HUNTER", level = 40, },
	[83243]={ class = "HUNTER", level = 42, },
	[13809]={ class = "HUNTER", level = 46, },
	[82941]={ class = "HUNTER", level = 46, },
	[19882]={ class = "HUNTER", level = 46, },
	[77769]={ class = "HUNTER", level = 48, },
	[20736]={ class = "HUNTER", level = 52, },
	[19879]={ class = "HUNTER", level = 52, },
	[3045]={ class = "HUNTER", level = 54, },
	[83244]={ class = "HUNTER", level = 62, },
	[20043]={ class = "HUNTER", level = 64, },
	[34600]={ class = "HUNTER", level = 66, },
	[82948]={ class = "HUNTER", level = 66, },
	[53271]={ class = "HUNTER", level = 74, },
	[34477]={ class = "HUNTER", level = 76, },
	[19263]={ class = "HUNTER", level = 78, },
	[77767]={ class = "HUNTER", level = 81, },
	[83245]={ class = "HUNTER", level = 82, },
	[82661]={ class = "HUNTER", level = 83, },
	[51753]={ class = "HUNTER", level = 85, },
	[51755]={ class = "HUNTER", level = 85, },
--++ Hunter Talents ++	
	[19434]={ class = "HUNTER", level = 10, },
	[53270]={ class = "HUNTER", level = 10, },
	[19590]={ class = "HUNTER", level = 10, },
	[19592]={ class = "HUNTER", level = 10, },
	[82687]={ class = "HUNTER", level = 10, },
	[19574]={ class = "HUNTER", level = 10, },
	[35104]={ class = "HUNTER", level = 10, },
	[35110]={ class = "HUNTER", level = 10, },
	[34482]={ class = "HUNTER", level = 10, },
	[34483]={ class = "HUNTER", level = 10, },
	[53209]={ class = "HUNTER", level = 10, },
	[53256]={ class = "HUNTER", level = 10, },
	[53259]={ class = "HUNTER", level = 10, },
	[53260]={ class = "HUNTER", level = 10, },
	[35100]={ class = "HUNTER", level = 10, },
	[35102]={ class = "HUNTER", level = 10, },
	[19306]={ class = "HUNTER", level = 10, },
	[82898]={ class = "HUNTER", level = 10, },
	[82899]={ class = "HUNTER", level = 10, },
	[19416]={ class = "HUNTER", level = 10, },
	[19417]={ class = "HUNTER", level = 10, },
	[19418]={ class = "HUNTER", level = 10, },
	[19184]={ class = "HUNTER", level = 10, },
	[19387]={ class = "HUNTER", level = 10, },
	[53301]={ class = "HUNTER", level = 10, },
	[34460]={ class = "HUNTER", level = 10, },
	[82726]={ class = "HUNTER", level = 10, },
	[82692]={ class = "HUNTER", level = 10, },
	[19621]={ class = "HUNTER", level = 10, },
	[19622]={ class = "HUNTER", level = 10, },
	[19623]={ class = "HUNTER", level = 10, },
	[34950]={ class = "HUNTER", level = 10, },
	[34954]={ class = "HUNTER", level = 10, },
	[56339]={ class = "HUNTER", level = 10, },
	[56340]={ class = "HUNTER", level = 10, },
	[56341]={ class = "HUNTER", level = 10, },
	[53290]={ class = "HUNTER", level = 10, },
	[35029]={ class = "HUNTER", level = 10, },
	[35030]={ class = "HUNTER", level = 10, },
	[19572]={ class = "HUNTER", level = 10, },
	[19573]={ class = "HUNTER", level = 10, },
	[19464]={ class = "HUNTER", level = 10, },
	[82834]={ class = "HUNTER", level = 10, },
	[53221]={ class = "HUNTER", level = 10, },
	[53222]={ class = "HUNTER", level = 10, },
	[53224]={ class = "HUNTER", level = 10, },
	[19577]={ class = "HUNTER", level = 10, },
	[53252]={ class = "HUNTER", level = 10, },
	[53253]={ class = "HUNTER", level = 10, },
	[82748]={ class = "HUNTER", level = 10, },
	[82749]={ class = "HUNTER", level = 10, },
	[56314]={ class = "HUNTER", level = 10, },
	[56315]={ class = "HUNTER", level = 10, },
	[56342]={ class = "HUNTER", level = 10, },
	[56343]={ class = "HUNTER", level = 10, },
	[53262]={ class = "HUNTER", level = 10, },
	[53263]={ class = "HUNTER", level = 10, },
	[53264]={ class = "HUNTER", level = 10, },
	[53241]={ class = "HUNTER", level = 10, },
	[53243]={ class = "HUNTER", level = 10, },
	[34485]={ class = "HUNTER", level = 10, },
	[34486]={ class = "HUNTER", level = 10, },
	[34487]={ class = "HUNTER", level = 10, },
	[34507]={ class = "HUNTER", level = 10, },
	[34508]={ class = "HUNTER", level = 10, },
	[34838]={ class = "HUNTER", level = 10, },
	[34839]={ class = "HUNTER", level = 10, },
	[34506]={ class = "HUNTER", level = 10, },
	[83494]={ class = "HUNTER", level = 10, },
	[83495]={ class = "HUNTER", level = 10, },
	[53295]={ class = "HUNTER", level = 10, },
	[53296]={ class = "HUNTER", level = 10, },
	[82682]={ class = "HUNTER", level = 10, },
	[82683]={ class = "HUNTER", level = 10, },
	[82684]={ class = "HUNTER", level = 10, },
	[19559]={ class = "HUNTER", level = 10, },
	[19560]={ class = "HUNTER", level = 10, },
	[52783]={ class = "HUNTER", level = 10, },
	[52785]={ class = "HUNTER", level = 10, },
	[52786]={ class = "HUNTER", level = 10, },
	[53234]={ class = "HUNTER", level = 10, },
	[53237]={ class = "HUNTER", level = 10, },
	[53238]={ class = "HUNTER", level = 10, },
	[53298]={ class = "HUNTER", level = 10, },
	[53299]={ class = "HUNTER", level = 10, },
	[83558]={ class = "HUNTER", level = 59, },
	[83559]={ class = "HUNTER", level = 59, },
	[83560]={ class = "HUNTER", level = 61, },
	[34948]={ class = "HUNTER", level = 10, },
	[34949]={ class = "HUNTER", level = 10, },
	[53228]={ class = "HUNTER", level = 10, },
	[53232]={ class = "HUNTER", level = 10, },
	[23989]={ class = "HUNTER", level = 10, },
	[82893]={ class = "HUNTER", level = 39, },
	[82897]={ class = "HUNTER", level = 39, },
	[82894]={ class = "HUNTER", level = 41, },
	[34491]={ class = "HUNTER", level = 10, },
	[34492]={ class = "HUNTER", level = 10, },
	[34493]={ class = "HUNTER", level = 10, },
	[19503]={ class = "HUNTER", level = 10, },
	[87934]={ class = "HUNTER", level = 10, },
	[87935]={ class = "HUNTER", level = 10, },
	[83340]={ class = "HUNTER", level = 19, },
	[83359]={ class = "HUNTER", level = 19, },
	[83356]={ class = "HUNTER", level = 21, },
	[34490]={ class = "HUNTER", level = 10, },
	[53302]={ class = "HUNTER", level = 10, },
	[53303]={ class = "HUNTER", level = 10, },
	[53304]={ class = "HUNTER", level = 10, },
	[19578]={ class = "HUNTER", level = 10, },
	[20895]={ class = "HUNTER", level = 10, },
	[19290]={ class = "HUNTER", level = 10, },
	[19294]={ class = "HUNTER", level = 10, },
	[24283]={ class = "HUNTER", level = 10, },
	[19286]={ class = "HUNTER", level = 10, },
	[19287]={ class = "HUNTER", level = 10, },
	[56333]={ class = "HUNTER", level = 10, },
	[56336]={ class = "HUNTER", level = 10, },
	[83489]={ class = "HUNTER", level = 10, },
	[83490]={ class = "HUNTER", level = 10, },
	[34692]={ class = "HUNTER", level = 10, },
	[34497]={ class = "HUNTER", level = 10, },
	[34498]={ class = "HUNTER", level = 10, },
	[34499]={ class = "HUNTER", level = 10, },
	[82832]={ class = "HUNTER", level = 10, },
	[82833]={ class = "HUNTER", level = 10, },
	[19376]={ class = "HUNTER", level = 10, },
	[63457]={ class = "HUNTER", level = 10, },
	[63458]={ class = "HUNTER", level = 10, },
	[19386]={ class = "HUNTER", level = 10, },
--++ Mage Abilities ++	
	[84671]={ class = "MAGE", level = 1, },
	[84668]={ class = "MAGE", level = 1, },
	[84669]={ class = "MAGE", level = 1, },
	[83619]={ class = "MAGE", level = 1, },
	[133]={ class = "MAGE", level = 1, },
	[413843]={ class = "MAGE", level = 1, },
	[5143]={ class = "MAGE", level = 3, },
	[79683]={ class = "mAGE", level = 3, },
	[79684]={ class = "MAGE", level = 3, },
	[2136]={ class = "MAGE", level = 5, },
	[116]={ class = "MAGE", level = 7, },
	[122]={ class = "MAGE", level = 8, },
	[2139]={ class = "MAGE", level = 9, },
	[92315]={ class = "MAGE", level = 10, },
	[12051]={ class = "MAGE", level = 12, },
	[118]={ class = "MAGE", level = 14, },
	[1953]={ class = "MAGE", level = 16, },
	[120]={ class = "MAGE", level = 18, },
	[30451]={ class = "MAGE", level = 20, },
	[1449]={ class = "MAGE", level = 22, },
	[3565]={ class = "MAGE", level = 24, },
	[32271]={ class = "MAGE", level = 24, },
	[3562]={ class = "MAGE", level = 24, },
	[3567]={ class = "MAGE", level = 24, },
	[32272]={ class = "MAGE", level = 24, },
	[3561]={ class = "MAGE", level = 24, },
	[49359]={ class = "MAGE", level = 24, },
	[3566]={ class = "MAGE", level = 24, },
	[3563]={ class = "MAGE", level = 24, },
	[2948]={ class = "MAGE", level = 26, },
	[30455]={ class = "MAGE", level = 28, },
	[45438]={ class = "MAGE", level = 30, },
	[475]={ class = "MAGE", level = 30, },
	[130]={ class = "MAGE", level = 32, },
	[30482]={ class = "MAGE", level = 34, },
	[543]={ class = "MAGE", level = 36, },
	[42955]={ class = "MAGE", level = 38, },
	[11419]={ class = "MAGE", level = 42, },
	[32266]={ class = "MAGE", level = 42, },
	[11416]={ class = "MAGE", level = 42, },
	[11417]={ class = "MAGE", level = 42, },
	[32267]={ class = "MAGE", level = 42, },
	[10059]={ class = "MAGE", level = 42, },
	[49360]={ class = "MAGE", level = 42, },
	[11420]={ class = "MAGE", level = 42, },
	[11418]={ class = "MAGE", level = 42, },
	[2120]={ class = "MAGE", level = 44, },
	[88148]={ class = "MAGE", level = 44, },
	[1463]={ class = "MAGE", level = 46, },
	[759]={ class = "MAGE", level = 48, },
	[55342]={ class = "MAGE", level = 50, },
	[10]={ class = "MAGE", level = 52, },
	[49361]={ class = "MAGE", level = 52, },
	[49358]={ class = "MAGE", level = 52, },
	[7302]={ class = "MAGE", level = 54, },
	[44614]={ class = "MAGE", level = 56, },
	[1459]={ class = "MAGE", level = 58, },
	[71757]={ class = "MAGE", level = 60, },
	[28271]={ class = "MAGE", level = 60, },
	[28272]={ class = "MAGE", level = 60, },
	[61305]={ class = "MAGE", level = 60, },
	[61721]={ class = "MAGE", level = 60, },
	[61780]={ class = "MAGE", level = 60, },
	[33690]={ class = "MAGE", level = 62, },
	[35715]={ class = "MAGE", level = 62, },
	[33691]={ class = "MAGE", level = 62, },
	[35717]={ class = "MAGE", level = 62, },
	[6117]={ class = "MAGE", level = 68, },
	[30449]={ class = "MAGE", level = 70, },
	[53140]={ class = "MAGE", level = 71, },
	[53142]={ class = "MAGE", level = 74, },
	[43987]={ class = "MAGE", level = 76, },
	[66]={ class = "MAGE", level = 78, },
	[61316]={ class = "MAGE", level = 80, },
	[82731]={ class = "MAGE", level = 81, },
	[82676]={ class = "MAGE", level = 83, },
	[82691]={ class = "MAGE", level = 83, },
	[88345]={ class = "MAGE", level = 85, },
	[88346]={ class = "MAGE", level = 85, },
	[88342]={ class = "MAGE", level = 85, },
	[88344]={ class = "MAGE", level = 85, },
	[80353]={ class = "MAGE", level = 85, },
--++ Mage Talents ++	
	[44425]={ class = "MAGE", level = 10, },
	[11213]={ class = "MAGE", level = 10, },
	[12574]={ class = "MAGE", level = 10, },
	[12575]={ class = "MAGE", level = 10, },
	[31579]={ class = "MAGE", level = 10, },
	[31582]={ class = "MAGE", level = 10, },
	[31583]={ class = "MAGE", level = 10, },
	[44378]={ class = "MAGE", level = 10, },
	[44379]={ class = "MAGE", level = 10, },
	[11222]={ class = "MAGE", level = 10, },
	[12839]={ class = "MAGE", level = 10, },
	[12840]={ class = "MAGE", level = 10, },
	[28574]={ class = "MAGE", level = 10, },
	[54658]={ class = "MAGE", level = 10, },
	[54659]={ class = "MAGE", level = 10, },
	[15058]={ class = "MAGE", level = 10, },
	[15059]={ class = "MAGE", level = 10, },
	[15060]={ class = "MAGE", level = 10, },
	[18462]={ class = "MAGE", level = 10, },
	[18463]={ class = "MAGE", level = 10, },
	[18464]={ class = "MAGE", level = 10, },
	[11232]={ class = "MAGE", level = 10, },
	[12500]={ class = "MAGE", level = 10, },
	[12501]={ class = "MAGE", level = 10, },
	[12502]={ class = "MAGE", level = 10, },
	[12503]={ class = "MAGE", level = 10, },
	[31571]={ class = "MAGE", level = 10, },
	[31572]={ class = "MAGE", level = 10, },
	[12042]={ class = "MAGE", level = 10, },
	[44397]={ class = "MAGE", level = 10, },
	[44398]={ class = "MAGE", level = 10, },
	[44399]={ class = "MAGE", level = 10, },
	[11252]={ class = "MAGE", level = 10, },
	[12605]={ class = "MAGE", level = 10, },
	[11237]={ class = "MAGE", level = 10, },
	[12463]={ class = "MAGE", level = 10, },
	[82930]={ class = "MAGE", level = 10, },
	[16757]={ class = "MAGE", level = 10, },
	[16758]={ class = "MAGE", level = 10, },
	[31674]={ class = "MAGE", level = 10, },
	[31675]={ class = "MAGE", level = 10, },
	[31676]={ class = "MAGE", level = 10, },
	[11113]={ class = "MAGE", level = 10, },
	[31641]={ class = "MAGE", level = 10, },
	[31642]={ class = "MAGE", level = 10, },
	[44546]={ class = "MAGE", level = 10, },
	[44548]={ class = "MAGE", level = 10, },
	[44549]={ class = "MAGE", level = 10, },
	[54747]={ class = "MAGE", level = 10, },
	[54749]={ class = "MAGE", level = 10, },
	[83501]={ class = "MAGE", level = 10, },
	[11083]={ class = "MAGE", level = 10, },
	[84253]={ class = "MAGE", level = 10, },
	[84254]={ class = "MAGE", level = 10, },
	[44449]={ class = "MAGE", level = 10, },
	[44469]={ class = "MAGE", level = 10, },
	[44470]={ class = "MAGE", level = 10, },
	[44471]={ class = "MAGE", level = 10, },
	[44472]={ class = "MAGE", level = 10, },
	[86948]={ class = "MAGE", level = 29, },
	[86949]={ class = "MAGE", level = 31, },
	[44566]={ class = "MAGE", level = 10, },
	[44567]={ class = "MAGE", level = 10, },
	[44568]={ class = "MAGE", level = 10, },
	[44570]={ class = "MAGE", level = 10, },
	[44571]={ class = "MAGE", level = 10, },
	[55091]={ class = "MAGE", level = 10, },
	[55092]={ class = "MAGE", level = 10, },
	[11958]={ class = "MAGE", level = 10, },
	[11129]={ class = "MAGE", level = 10, },
	[11095]={ class = "MAGE", level = 10, },
	[12872]={ class = "MAGE", level = 10, },
	[12873]={ class = "MAGE", level = 10, },
	[44572]={ class = "MAGE", level = 10, },
	[31661]={ class = "MAGE", level = 10, },
	[83049]={ class = "MAGE", level = 10, },
	[83050]={ class = "MAGE", level = 10, },
	[31656]={ class = "MAGE", level = 10, },
	[31657]={ class = "MAGE", level = 10, },
	[31658]={ class = "MAGE", level = 10, },
	[31682]={ class = "MAGE", level = 10, },
	[31683]={ class = "MAGE", level = 10, },
	[83082]={ class = "MAGE", level = 10, },
	[44561]={ class = "MAGE", level = 39, },
	[86500]={ class = "MAGE", level = 41, },
	[86508]={ class = "MAGE", level = 43, },
	[64353]={ class = "MAGE", level = 10, },
	[64357]={ class = "MAGE", level = 10, },
	[44543]={ class = "MAGE", level = 10, },
	[44545]={ class = "MAGE", level = 10, },
	[83074]={ class = "MAGE", level = 10, },
	[18459]={ class = "MAGE", level = 10, },
	[18460]={ class = "MAGE", level = 10, },
	[54734]={ class = "MAGE", level = 10, },
	[86914]={ class = "MAGE", level = 10, },
	[54646]={ class = "MAGE", level = 10, },
	[11160]={ class = "MAGE", level = 10, },
	[12518]={ class = "MAGE", level = 10, },
	[12519]={ class = "MAGE", level = 10, },
	[11189]={ class = "MAGE", level = 10, },
	[28332]={ class = "MAGE", level = 10, },
	[84726]={ class = "MAGE", level = 10, },
	[84727]={ class = "MAGE", level = 10, },
	[31667]={ class = "MAGE", level = 10, },
	[31668]={ class = "MAGE", level = 10, },
	[31669]={ class = "MAGE", level = 10, },
	[44445]={ class = "MAGE", level = 10, },
	[11426]={ class = "MAGE", level = 10, },
	[31670]={ class = "MAGE", level = 10, },
	[31672]={ class = "MAGE", level = 10, },
	[55094]={ class = "MAGE", level = 10, },
	[11185]={ class = "MAGE", level = 10, },
	[12487]={ class = "MAGE", level = 10, },
	[12472]={ class = "MAGE", level = 10, },
	[11119]={ class = "MAGE", level = 10, },
	[11120]={ class = "MAGE", level = 10, },
	[12846]={ class = "MAGE", level = 10, },
	[11103]={ class = "MAGE", level = 10, },
	[12357]={ class = "MAGE", level = 10, },
	[12358]={ class = "MAGE", level = 10, },
	[90787]={ class = "MAGE", level = 10, },
	[90788]={ class = "MAGE", level = 10, },
	[83513]={ class = "MAGE", level = 10, },
	[83515]={ class = "MAGE", level = 10, },
	[31569]={ class = "MAGE", level = 10, },
	[31570]={ class = "MAGE", level = 10, },
	[12488]={ class = "MAGE", level = 10, },
	[11190]={ class = "MAGE", level = 10, },
	[12489]={ class = "MAGE", level = 10, },
	[11255]={ class = "MAGE", level = 10, },
	[12598]={ class = "MAGE", level = 10, },
	[11078]={ class = "MAGE", level = 10, },
	[11080]={ class = "MAGE", level = 10, },
	[11069]={ class = "MAGE", level = 10, },
	[12338]={ class = "MAGE", level = 10, },
	[12339]={ class = "MAGE", level = 10, },
	[12340]={ class = "MAGE", level = 10, },
	[12341]={ class = "MAGE", level = 10, },
	[84673]={ class = "MAGE", level = 10, },
	[84674]={ class = "MAGE", level = 10, },
	[86259]={ class = "MAGE", level = 10, },
	[86260]={ class = "MAGE", level = 10, },
	[86314]={ class = "MAGE", level = 10, },
	[11070]={ class = "MAGE", level = 10, },
	[12473]={ class = "MAGE", level = 10, },
	[16763]={ class = "MAGE", level = 10, },
	[16765]={ class = "MAGE", level = 10, },
	[16766]={ class = "MAGE", level = 10, },
	[44446]={ class = "MAGE", level = 10, },
	[44448]={ class = "MAGE", level = 10, },
	[31584]={ class = "MAGE", level = 10, },
	[31585]={ class = "MAGE", level = 10, },
	[31586]={ class = "MAGE", level = 10, },
	[11210]={ class = "MAGE", level = 10, },
	[12592]={ class = "MAGE", level = 10, },
	[11115]={ class = "MAGE", level = 10, },
	[11367]={ class = "MAGE", level = 10, },
	[44394]={ class = "MAGE", level = 10, },
	[44395]={ class = "MAGE", level = 10, },
	[11124]={ class = "MAGE", level = 10, },
	[12378]={ class = "MAGE", level = 10, },
	[84722]={ class = "MAGE", level = 10, },
	[84723]={ class = "MAGE", level = 10, },
	[44457]={ class = "MAGE", level = 10, },
	[29441]={ class = "MAGE", level = 10, },
	[29444]={ class = "MAGE", level = 10, },
	[11247]={ class = "MAGE", level = 10, },
	[12606]={ class = "MAGE", level = 10, },
	[29074]={ class = "MAGE", level = 10, },
	[29075]={ class = "MAGE", level = 10, },
	[29076]={ class = "MAGE", level = 10, },
	[44404]={ class = "MAGE", level = 10, },
	[54486]={ class = "MAGE", level = 10, },
	[31679]={ class = "MAGE", level = 10, },
	[31680]={ class = "MAGE", level = 10, },
	[86880]={ class = "MAGE", level = 10, },
	[11094]={ class = "MAGE", level = 10, },
	[86181]={ class = "MAGE", level = 10, },
	[86209]={ class = "MAGE", level = 10, },
	[44400]={ class = "MAGE", level = 10, },
	[44402]={ class = "MAGE", level = 10, },
	[44403]={ class = "MAGE", level = 10, },
	[11175]={ class = "MAGE", level = 10, },
	[12569]={ class = "MAGE", level = 10, },
	[12571]={ class = "MAGE", level = 10, },
	[83156]={ class = "MAGE", level = 10, },
	[83157]={ class = "MAGE", level = 10, },
	[11151]={ class = "MAGE", level = 10, },
	[12952]={ class = "MAGE", level = 10, },
	[12953]={ class = "MAGE", level = 10, },
	[31638]={ class = "MAGE", level = 10, },
	[31639]={ class = "MAGE", level = 10, },
	[31640]={ class = "MAGE", level = 10, },
	[29438]={ class = "MAGE", level = 10, },
	[29439]={ class = "MAGE", level = 10, },
	[29440]={ class = "MAGE", level = 10, },
	[12043]={ class = "MAGE", level = 10, },
	[31574]={ class = "MAGE", level = 10, },
	[31575]={ class = "MAGE", level = 10, },
	[54354]={ class = "MAGE", level = 10, },
	[11366]={ class = "MAGE", level = 10, },
	[34293]={ class = "MAGE", level = 10, },
	[34295]={ class = "MAGE", level = 10, },
	[34296]={ class = "MAGE", level = 10, },
	[86303]={ class = "MAGE", level = 10, },
	[86304]={ class = "MAGE", level = 10, },
	[11170]={ class = "MAGE", level = 10, },
	[12982]={ class = "MAGE", level = 10, },
	[12983]={ class = "MAGE", level = 10, },
	[44745]={ class = "MAGE", level = 10, },
	[54787]={ class = "MAGE", level = 10, },
	[31589]={ class = "MAGE", level = 10, },
	[11242]={ class = "MAGE", level = 10, },
	[12467]={ class = "MAGE", level = 10, },
	[12469]={ class = "MAGE", level = 10, },
	[35578]={ class = "MAGE", level = 10, },
	[35581]={ class = "MAGE", level = 10, },
	[31687]={ class = "MAGE", level = 10, },
	[29447]={ class = "MAGE", level = 10, },
	[55339]={ class = "MAGE", level = 10, },
	[55340]={ class = "MAGE", level = 10, },
	[11180]={ class = "MAGE", level = 10, },
	[28592]={ class = "MAGE", level = 10, },
	[28593]={ class = "MAGE", level = 10, },
	[11108]={ class = "MAGE", level = 10, },
	[12349]={ class = "MAGE", level = 10, },
	[12350]={ class = "MAGE", level = 10, },
--++ Paladin Abilities ++	
	[89901]={ class = "PALADIN", level = 1, },
	[95859]={ class = "PALADIN", level = 1, },
	[84839]={ class = "PALADIN", level = 1, },
	[85102]={ class = "PALADIN", level = 1, },
	[35395]={ class = "PALADIN", level = 1, },
	[54968]={ class = "PALADIN", level = 1, },
	[85256]={ class = "PALADIN", level = 1, },
	[20271]={ class = "PALADIN", level = 3, },
	[20154]={ class = "PALADIN", level = 3, },
	[635]={ class = "PALADIN", level = 7, },
	[85673]={ class = "PALADIN", level = 9, },
	[82242]={ class = "PALADIN", level = 10, },
	[7328]={ class = "PALADIN", level = 12, },
	[25780]={ class = "PALADIN", level = 12, },
	[853]={ class = "PALADIN", level = 14, },
	[62124]={ class = "PALADIN", level = 14, },
	[19750]={ class = "PALADIN", level = 16, },
	[633]={ class = "PALADIN", level = 16, },
	[879]={ class = "PALADIN", level = 18, },
	[73629]={ class = "PALADIN", level = 20, },
	[69820]={ class = "PALADIN", level = 20, },
	[13819]={ class = "PALADIN", level = 20, },
	[34769]={ class = "PALADIN", level = 20, },
	[20217]={ class = "PALADIN", level = 22, },
	[26573]={ class = "PALADIN", level = 24, },
	[2812]={ class = "PALADIN", level = 28, },
	[498]={ class = "PALADIN", level = 30, },
	[20165]={ class = "PALADIN", level = 32, },
	[4987]={ class = "PALADIN", level = 34, },
	[31789]={ class = "PALADIN", level = 36, },
	[23214]={ class = "PALADIN", level = 41, },
	[34767]={ class = "PALADIN", level = 43, },
	[73630]={ class = "PALADIN", level = 45, },
	[69826]={ class = "PALADIN", level = 47, },
	[450761]={ class = "PALADIN", level = 44, },
	[54428]={ class = "PALADIN", level = 44, },
	[31801]={ class = "PALADIN", level = 44, },
	[24275]={ class = "PALADIN", level = 46, },
	[642]={ class = "PALADIN", level = 48, },
	[1044]={ class = "PALADIN", level = 52, },
	[96231]={ class = "PALADIN", level = 54, },
	[19740]={ class = "PALADIN", level = 56, },
	[356110]={ class = "PALADIN", level = 64, },
	[356112]={ class = "PALADIN", level = 64, },
	[348704]={ class = "PALADIN", level = 64, },
	[20164]={ class = "PALADIN", level = 64, },
	[1038]={ class = "PALADIN", level = 66, },
	[31884]={ class = "PALADIN", level = 72, },
	[10326]={ class = "PALADIN", level = 78, },
	[6940]={ class = "PALADIN", level = 80, },
	[84963]={ class = "PALADIN", level = 81, },
	[82327]={ class = "PALADIN", level = 83, },
	[86150]={ class = "PALADIN", level = 85, },
--++ Paladin Talents ++	
	[85446]={ class = "PALADIN", level = 10, },
	[85795]={ class = "PALADIN", level = 10, },
	[20359]={ class = "PALADIN", level = 10, },
	[20360]={ class = "PALADIN", level = 10, },
	[31850]={ class = "PALADIN", level = 10, },
	[31821]={ class = "PALADIN", level = 49, },
	[53563]={ class = "PALADIN", level = 10, },
	[20237]={ class = "PALADIN", level = 10, },
	[20238]={ class = "PALADIN", level = 10, },
	[31828]={ class = "PALADIN", level = 10, },
	[31829]={ class = "PALADIN", level = 10, },
	[85462]={ class = "PALADIN", level = 10, },
	[85463]={ class = "PALADIN", level = 10, },
	[85464]={ class = "PALADIN", level = 10, },
	[31876]={ class = "PALADIN", level = 10, },
	[20049]={ class = "PALADIN", level = 10, },
	[20056]={ class = "PALADIN", level = 10, },
	[20057]={ class = "PALADIN", level = 10, },
	[31866]={ class = "PALADIN", level = 10, },
	[31867]={ class = "PALADIN", level = 10, },
	[31868]={ class = "PALADIN", level = 10, },
	[88820]={ class = "PALADIN", level = 10, },
	[88821]={ class = "PALADIN", level = 10, },
	[31825]={ class = "PALADIN", level = 10, },
	[85510]={ class = "PALADIN", level = 10, },
	[31842]={ class = "PALADIN", level = 10, },
	[70940]={ class = "PALADIN", level = 10, },
	[82326]={ class = "PALADIN", level = 10, },
	[85117]={ class = "PALADIN", level = 10, },
	[86172]={ class = "PALADIN", level = 10, },
	[64205]={ class = "PALADIN", level = 10, },
	[53385]={ class = "PALADIN", level = 10, },
	[63646]={ class = "PALADIN", level = 10, },
	[63647]={ class = "PALADIN", level = 10, },
	[63648]={ class = "PALADIN", level = 10, },
	[53556]={ class = "PALADIN", level = 10, },
	[53557]={ class = "PALADIN", level = 10, },
	[87163]={ class = "PALADIN", level = 10, },
	[87164]={ class = "PALADIN", level = 10, },
	[9799]={ class = "PALADIN", level = 10, },
	[25988]={ class = "PALADIN", level = 10, },
	[75806]={ class = "PALADIN", level = 10, },
	[85043]={ class = "PALADIN", level = 10, },
	[85639]={ class = "PALADIN", level = 10, },
	[85646]={ class = "PALADIN", level = 10, },
	[20174]={ class = "PALADIN", level = 10, },
	[20175]={ class = "PALADIN", level = 10, },
	[84631]={ class = "PALADIN", level = 10, },
	[84633]={ class = "PALADIN", level = 10, },
	[53595]={ class = "PALADIN", level = 10, },
	[20925]={ class = "PALADIN", level = 10, },
	[20473]={ class = "PALADIN", level = 10, },
	[20487]={ class = "PALADIN", level = 10, },
	[20488]={ class = "PALADIN", level = 10, },
	[87174]={ class = "PALADIN", level = 10, },
	[87175]={ class = "PALADIN", level = 10, },
	[53569]={ class = "PALADIN", level = 10, },
	[53576]={ class = "PALADIN", level = 10, },
	[53380]={ class = "PALADIN", level = 10, },
	[53381]={ class = "PALADIN", level = 10, },
	[53382]={ class = "PALADIN", level = 10, },
	[53695]={ class = "PALADIN", level = 10, },
	[53696]={ class = "PALADIN", level = 10, },
	[53671]={ class = "PALADIN", level = 10, },
	[53673]={ class = "PALADIN", level = 10, },
	[54151]={ class = "PALADIN", level = 10, },
	[31878]={ class = "PALADIN", level = 10, },
	[20234]={ class = "PALADIN", level = 10, },
	[20235]={ class = "PALADIN", level = 10, },
	[85222]={ class = "PALADIN", level = 10, },
	[87168]={ class = "PALADIN", level = 10, },
	[87172]={ class = "PALADIN", level = 10, },
	[20208]={ class = "PALADIN", level = 10, },
	[93417]={ class = "PALADIN", level = 10, },
	[93418]={ class = "PALADIN", level = 10, },
	[20138]={ class = "PALADIN", level = 10, },
	[20139]={ class = "PALADIN", level = 10, },
	[20140]={ class = "PALADIN", level = 10, },
	[31822]={ class = "PALADIN", level = 10, },
	[31823]={ class = "PALADIN", level = 10, },
	[26022]={ class = "PALADIN", level = 10, },
	[26023]={ class = "PALADIN", level = 10, },
	[20177]={ class = "PALADIN", level = 10, },
	[20179]={ class = "PALADIN", level = 10, },
	[20066]={ class = "PALADIN", level = 10, },
	[85457]={ class = "PALADIN", level = 10, },
	[85458]={ class = "PALADIN", level = 10, },
	[87461]={ class = "PALADIN", level = 10, },
	[53551]={ class = "PALADIN", level = 10, },
	[53709]={ class = "PALADIN", level = 10, },
	[53710]={ class = "PALADIN", level = 10, },
	[85285]={ class = "PALADIN", level = 10, },
	[53375]={ class = "PALADIN", level = 10, },
	[53376]={ class = "PALADIN", level = 10, },
	[90286]={ class = "PALADIN", level = 10, },
	[25956]={ class = "PALADIN", level = 10, },
	[20911]={ class = "PALADIN", level = 29, },
	[57319]={ class = "PALADIN", level = 29, },
	[84628]={ class = "PALADIN", level = 10, },
	[84629]={ class = "PALADIN", level = 10, },
	[85126]={ class = "PALADIN", level = 10, },
	[20224]={ class = "PALADIN", level = 10, },
	[20225]={ class = "PALADIN", level = 10, },
	[85803]={ class = "PALADIN", level = 10, },
	[85804]={ class = "PALADIN", level = 10, },
	[53503]={ class = "PALADIN", level = 10, },
	[53600]={ class = "PALADIN", level = 10, },
	[31848]={ class = "PALADIN", level = 10, },
	[31849]={ class = "PALADIN", level = 10, },
	[84854]={ class = "PALADIN", level = 10, },
	[85495]={ class = "PALADIN", level = 10, },
	[85498]={ class = "PALADIN", level = 10, },
	[85499]={ class = "PALADIN", level = 10, },
	[53486]={ class = "PALADIN", level = 10, },
	[53488]={ class = "PALADIN", level = 10, },
	[87138]={ class = "PALADIN", level = 10, },
	[53592]={ class = "PALADIN", level = 10, },
	[20143]={ class = "PALADIN", level = 10, },
	[20144]={ class = "PALADIN", level = 10, },
	[20145]={ class = "PALADIN", level = 10, },
	[84800]={ class = "PALADIN", level = 10, },
	[85511]={ class = "PALADIN", level = 10, },
	[85512]={ class = "PALADIN", level = 10, },
	[20113]={ class = "PALADIN", level = 10, },
	[26016]={ class = "PALADIN", level = 10, },
	[84635]={ class = "PALADIN", level = 10, },
	[84636]={ class = "PALADIN", level = 10, },
	[85696]={ class = "PALADIN", level = 10, },
--++ Priest Abilities ++	
	[33167]={ class = "PRIEST", level = 1, },
	[84734]={ class = "PRIEST", level = 1, },
	[84732]={ class = "PRIEST", level = 1, },
	[95860]={ class = "PRIEST", level = 1, },
	[95861]={ class = "PRIEST", level = 1, },
	[49868]={ class = "PRIEST", level = 1, },
	[33192]={ class = "PRIEST", level = 1, },
	[95740]={ class = "PRIEST", level = 1, },
	[87327]={ class = "PRIEST", level = 1, },
	[87336]={ class = "PRIEST", level = 1, },
	[63544]={ class = "PRIEST", level = 1, },
	[84733]={ class = "PRIEST", level = 1, },
	[88625]={ class = "PRIEST", level = 1, },
	[88685]={ class = "PRIEST", level = 1, },
	[64904]={ class = "PRIEST", level = 1, },
	[585]={ class = "PRIEST", level = 1, },
	[2061]={ class = "PRIEST", level = 3, },
	[101062]={ class = "PRIEST", level = 3, },
	[589]={ class = "PRIEST", level = 4, },
	[17]={ class = "PRIEST", level = 5, },
	[588]={ class = "PRIEST", level = 7, },
	[139]={ class = "PRIEST", level = 8, },
	[8092]={ class = "PRIEST", level = 9, },
	[8122]={ class = "PRIEST", level = 12, },
	[21562]={ class = "PRIEST", level = 14, },
	[2006]={ class = "PRIEST", level = 14, },
	[2050]={ class = "PRIEST", level = 16, },
	[14914]={ class = "PRIEST", level = 18, },
	[70772]={ class = "PRIEST", level = 20, },
	[88684]={ class = "PRIEST", level = 20, },
	[528]={ class = "PRIEST", level = 22, },
	[586]={ class = "PRIEST", level = 24, },
	[527]={ class = "PRIEST", level = 26, },
	[2944]={ class = "PRIEST", level = 28, },
	[9484]={ class = "PRIEST", level = 32, },
	[32379]={ class = "PRIEST", level = 32, },
	[1706]={ class = "PRIEST", level = 34, },
	[2096]={ class = "PRIEST", level = 36, },
	[2060]={ class = "PRIEST", level = 38, },
	[605]={ class = "PRIEST", level = 38, },
	[83968]={ class = "PRIEST", level = 44, },
	[596]={ class = "PRIEST", level = 44, },
	[32546]={ class = "PRIEST", level = 48, },
	[27683]={ class = "PRIEST", level = 52, },
	[6346]={ class = "PRIEST", level = 54, },
	[453]={ class = "PRIEST", level = 56, },
	[8129]={ class = "PRIEST", level = 58, },
	[15237]={ class = "PRIEST", level = 62, },
	[64901]={ class = "PRIEST", level = 64, },
	[34433]={ class = "PRIEST", level = 66, },
	[33076]={ class = "PRIEST", level = 68, },
	[32375]={ class = "PRIEST", level = 72, },
	[48045]={ class = "PRIEST", level = 74, },
	[64843]={ class = "PRIEST", level = 78, },
	[73510]={ class = "PRIEST", level = 81, },
	[73413]={ class = "PRIEST", level = 83, },
	[73325]={ class = "PRIEST", level = 85, },
--++ Priest Talents ++	
	[81700]={ class = "PRIEST", level = 10, },
	[87151]={ class = "PRIEST", level = 10, },
	[14523]={ class = "PRIEST", level = 10, },
	[81749]={ class = "PRIEST", level = 10, },
	[14911]={ class = "PRIEST", level = 10, },
	[15018]={ class = "PRIEST", level = 10, },
	[27811]={ class = "PRIEST", level = 10, },
	[27815]={ class = "PRIEST", level = 10, },
	[27816]={ class = "PRIEST", level = 10, },
	[33142]={ class = "PRIEST", level = 10, },
	[33145]={ class = "PRIEST", level = 10, },
	[64127]={ class = "PRIEST", level = 10, },
	[64129]={ class = "PRIEST", level = 10, },
	[52795]={ class = "PRIEST", level = 10, },
	[52797]={ class = "PRIEST", level = 10, },
	[52798]={ class = "PRIEST", level = 10, },
	[14751]={ class = "PRIEST", level = 10, },
	[34861]={ class = "PRIEST", level = 10, },
	[15259]={ class = "PRIEST", level = 10, },
	[15307]={ class = "PRIEST", level = 10, },
	[15308]={ class = "PRIEST", level = 10, },
	[19236]={ class = "PRIEST", level = 10, },
	[47585]={ class = "PRIEST", level = 10, },
	[81762]={ class = "PRIEST", level = 10, },
	[81763]={ class = "PRIEST", level = 10, },
	[47509]={ class = "PRIEST", level = 10, },
	[47511]={ class = "PRIEST", level = 10, },
	[47515]={ class = "PRIEST", level = 10, },
	[18530]={ class = "PRIEST", level = 10, },
	[18531]={ class = "PRIEST", level = 10, },
	[18533]={ class = "PRIEST", level = 10, },
	[47562]={ class = "PRIEST", level = 10, },
	[47564]={ class = "PRIEST", level = 10, },
	[47565]={ class = "PRIEST", level = 10, },
	[47566]={ class = "PRIEST", level = 10, },
	[47567]={ class = "PRIEST", level = 10, },
	[63534]={ class = "PRIEST", level = 10, },
	[63542]={ class = "PRIEST", level = 10, },
	[33158]={ class = "PRIEST", level = 10, },
	[33159]={ class = "PRIEST", level = 10, },
	[33160]={ class = "PRIEST", level = 10, },
	[81659]={ class = "PRIEST", level = 10, },
	[81662]={ class = "PRIEST", level = 10, },
	[45234]={ class = "PRIEST", level = 10, },
	[45243]={ class = "PRIEST", level = 10, },
	[47516]={ class = "PRIEST", level = 10, },
	[47517]={ class = "PRIEST", level = 10, },
	[47788]={ class = "PRIEST", level = 10, },
	[33191]={ class = "PRIEST", level = 10, },
	[78228]={ class = "PRIEST", level = 10, },
	[87430]={ class = "PRIEST", level = 10, },
	[87431]={ class = "PRIEST", level = 10, },
	[34753]={ class = "PRIEST", level = 10, },
	[34859]={ class = "PRIEST", level = 10, },
	[27789]={ class = "PRIEST", level = 10, },
	[27790]={ class = "PRIEST", level = 10, },
	[14889]={ class = "PRIEST", level = 10, },
	[15008]={ class = "PRIEST", level = 10, },
	[15009]={ class = "PRIEST", level = 10, },
	[15010]={ class = "PRIEST", level = 10, },
	[15011]={ class = "PRIEST", level = 10, },
	[63625]={ class = "PRIEST", level = 10, },
	[63626]={ class = "PRIEST", level = 10, },
	[14912]={ class = "PRIEST", level = 10, },
	[15013]={ class = "PRIEST", level = 10, },
	[81766]={ class = "PRIEST", level = 10, },
	[81830]={ class = "PRIEST", level = 10, },
	[15273]={ class = "PRIEST", level = 10, },
	[15312]={ class = "PRIEST", level = 10, },
	[15313]={ class = "PRIEST", level = 10, },
	[14748]={ class = "PRIEST", level = 10, },
	[14768]={ class = "PRIEST", level = 10, },
	[15392]={ class = "PRIEST", level = 10, },
	[15448]={ class = "PRIEST", level = 10, },
	[14908]={ class = "PRIEST", level = 10, },
	[15020]={ class = "PRIEST", level = 10, },
	[15275]={ class = "PRIEST", level = 10, },
	[15317]={ class = "PRIEST", level = 10, },
	[89485]={ class = "PRIEST", level = 10, },
	[14747]={ class = "PRIEST", level = 10, },
	[14770]={ class = "PRIEST", level = 10, },
	[14771]={ class = "PRIEST", level = 10, },
	[14892]={ class = "PRIEST", level = 10, },
	[15362]={ class = "PRIEST", level = 10, },
	[724]={ class = "PRIEST", level = 10, },
	[88994]={ class = "PRIEST", level = 10, },
	[88995]={ class = "PRIEST", level = 10, },
	[14520]={ class = "PRIEST", level = 10, },
	[14780]={ class = "PRIEST", level = 10, },
	[14781]={ class = "PRIEST", level = 10, },
	[15407]={ class = "PRIEST", level = 10, },
	[14910]={ class = "PRIEST", level = 10, },
	[33371]={ class = "PRIEST", level = 10, },
	[47580]={ class = "PRIEST", level = 10, },
	[47581]={ class = "PRIEST", level = 10, },
	[33206]={ class = "PRIEST", level = 10, },
	[87192]={ class = "PRIEST", level = 10, },
	[87195]={ class = "PRIEST", level = 10, },
	[47540]={ class = "PRIEST", level = 10, },
	[81656]={ class = "PRIEST", level = 10, },
	[81657]={ class = "PRIEST", level = 10, },
	[47569]={ class = "PRIEST", level = 10, },
	[47570]={ class = "PRIEST", level = 10, },
	[10060]={ class = "PRIEST", level = 10, },
	[14769]={ class = "PRIEST", level = 10, },
	[62618]={ class = "PRIEST", level = 10, },
	[64044]={ class = "PRIEST", level = 10, },
	[95649]={ class = "PRIEST", level = 10, },
	[47535]={ class = "PRIEST", level = 10, },
	[47536]={ class = "PRIEST", level = 10, },
	[47537]={ class = "PRIEST", level = 10, },
	[33201]={ class = "PRIEST", level = 10, },
	[33202]={ class = "PRIEST", level = 10, },
	[57470]={ class = "PRIEST", level = 10, },
	[57472]={ class = "PRIEST", level = 10, },
	[88627]={ class = "PRIEST", level = 10, },
	[14909]={ class = "PRIEST", level = 10, },
	[15017]={ class = "PRIEST", level = 10, },
	[78069]={ class = "PRIEST", level = 10, },
	[63730]={ class = "PRIEST", level = 10, },
	[63733]={ class = "PRIEST", level = 10, },
	[15473]={ class = "PRIEST", level = 10, },
	[78202]={ class = "PRIEST", level = 10, },
	[78203]={ class = "PRIEST", level = 10, },
	[78204]={ class = "PRIEST", level = 10, },
	[87099]={ class = "PRIEST", level = 10, },
	[87100]={ class = "PRIEST", level = 10, },
	[63574]={ class = "PRIEST", level = 10, },
	[78500]={ class = "PRIEST", level = 10, },
	[78501]={ class = "PRIEST", level = 10, },
	[20711]={ class = "PRIEST", level = 10, },
	[15028]={ class = "PRIEST", level = 10, },
	[15029]={ class = "PRIEST", level = 10, },
	[15030]={ class = "PRIEST", level = 10, },
	[15031]={ class = "PRIEST", level = 10, },
	[89488]={ class = "PRIEST", level = 10, },
	[89489]={ class = "PRIEST", level = 10, },
	[88687]={ class = "PRIEST", level = 10, },
	[88690]={ class = "PRIEST", level = 10, },
	[47558]={ class = "PRIEST", level = 10, },
	[47559]={ class = "PRIEST", level = 10, },
	[47560]={ class = "PRIEST", level = 10, },
	[78245]={ class = "PRIEST", level = 10, },
	[78244]={ class = "PRIEST", level = 10, },
	[14898]={ class = "PRIEST", level = 10, },
	[81625]={ class = "PRIEST", level = 10, },
	[92295]={ class = "PRIEST", level = 10, },
	[92297]={ class = "PRIEST", level = 10, },
	[47586]={ class = "PRIEST", level = 10, },
	[47587]={ class = "PRIEST", level = 10, },
	[47588]={ class = "PRIEST", level = 10, },
	[47573]={ class = "PRIEST", level = 10, },
	[47577]={ class = "PRIEST", level = 10, },
	[14522]={ class = "PRIEST", level = 10, },
	[14788]={ class = "PRIEST", level = 10, },
	[14789]={ class = "PRIEST", level = 10, },
	[14790]={ class = "PRIEST", level = 10, },
	[14791]={ class = "PRIEST", level = 10, },
	[15286]={ class = "PRIEST", level = 10, },
	[34914]={ class = "PRIEST", level = 10, },
	[15274]={ class = "PRIEST", level = 10, },
	[15311]={ class = "PRIEST", level = 10, },
--++ Rogue Abilities ++	
	[84601]={ class = "ROGUE", level = 1, },
	[5374]={ class = "ROGUE", level = 1, },
	[27576]={ class = "ROGUE", level = 1, },
	[1752]={ class = "ROGUE", level = 1, },
	[2098]={ class = "ROGUE", level = 3, },
	[79327]={ class = "ROGUE", level = 3, },
	[1784]={ class = "ROGUE", level = 5, },
	[921]={ class = "ROGUE", level = 7, },
	[8676]={ class = "ROGUE", level = 8, },
	[5277]={ class = "ROGUE", level = 9, },
	[2842]={ class = "ROGUE", level = 10, },
	[6770]={ class = "ROGUE", level = 10, },
	[82245]={ class = "ROGUE", level = 12, },
	[73651]={ class = "ROGUE", level = 12, },
	[1766]={ class = "ROGUE", level = 14, },
	[1776]={ class = "ROGUE", level = 16, },
	[2983]={ class = "ROGUE", level = 16, },
	[53]={ class = "ROGUE", level = 18, },
	[1804]={ class = "ROGUE", level = 20, },
	[5171]={ class = "ROGUE", level = 22, },
	[1856]={ class = "ROGUE", level = 24, },
	[1833]={ class = "ROGUE", level = 26, },
	[1725]={ class = "ROGUE", level = 28, },
	[408]={ class = "ROGUE", level = 30, },
	[2836]={ class = "ROGUE", level = 32, },
	[2094]={ class = "ROGUE", level = 34, },
	[8647]={ class = "ROGUE", level = 36, },
	[51722]={ class = "ROGUE", level = 38, },
	[703]={ class = "ROGUE", level = 40, },
	[1966]={ class = "ROGUE", level = 42, },
	[1842]={ class = "ROGUE", level = 44, },
	[1943]={ class = "ROGUE", level = 46, },
	[1860]={ class = "ROGUE", level = 48, },
	[32645]={ class = "ROGUE", level = 54, },
	[31224]={ class = "ROGUE", level = 58, },
	[26679]={ class = "ROGUE", level = 62, },
	[5938]={ class = "ROGUE", level = 70, },
	[57934]={ class = "ROGUE", level = 75, },
	[51723]={ class = "ROGUE", level = 80, },
	[74001]={ class = "ROGUE", level = 81, },
	[73981]={ class = "ROGUE", level = 83, },
	[76577]={ class = "ROGUE", level = 85, },
--++ Rogue Talents ++	
	[13750]={ class = "ROGUE", level = 10, },
	[18427]={ class = "ROGUE", level = 10, },
	[18428]={ class = "ROGUE", level = 10, },
	[18429]={ class = "ROGUE", level = 10, },
	[13852]={ class = "ROGUE", level = 10, },
	[84652]={ class = "ROGUE", level = 10, },
	[84653]={ class = "ROGUE", level = 10, },
	[84654]={ class = "ROGUE", level = 10, },
	[79123]={ class = "ROGUE", level = 10, },
	[79125]={ class = "ROGUE", level = 10, },
	[13877]={ class = "ROGUE", level = 10, },
	[31124]={ class = "ROGUE", level = 10, },
	[31126]={ class = "ROGUE", level = 10, },
	[31228]={ class = "ROGUE", level = 10, },
	[31229]={ class = "ROGUE", level = 10, },
	[31230]={ class = "ROGUE", level = 10, },
	[14177]={ class = "ROGUE", level = 10, },
	[35541]={ class = "ROGUE", level = 10, },
	[35550]={ class = "ROGUE", level = 10, },
	[35551]={ class = "ROGUE", level = 10, },
	[14162]={ class = "ROGUE", level = 10, },
	[14163]={ class = "ROGUE", level = 10, },
	[14164]={ class = "ROGUE", level = 10, },
	[51664]={ class = "ROGUE", level = 10, },
	[51665]={ class = "ROGUE", level = 10, },
	[51667]={ class = "ROGUE", level = 10, },
	[31380]={ class = "ROGUE", level = 10, },
	[31382]={ class = "ROGUE", level = 10, },
	[31383]={ class = "ROGUE", level = 10, },
	[30902]={ class = "ROGUE", level = 10, },
	[30903]={ class = "ROGUE", level = 10, },
	[30904]={ class = "ROGUE", level = 10, },
	[30905]={ class = "ROGUE", level = 10, },
	[30906]={ class = "ROGUE", level = 10, },
	[51625]={ class = "ROGUE", level = 10, },
	[51626]={ class = "ROGUE", level = 10, },
	[79121]={ class = "ROGUE", level = 10, },
	[79122]={ class = "ROGUE", level = 10, },
	[13713]={ class = "ROGUE", level = 10, },
	[13853]={ class = "ROGUE", level = 10, },
	[13854]={ class = "ROGUE", level = 10, },
	[14082]={ class = "ROGUE", level = 10, },
	[14083]={ class = "ROGUE", level = 10, },
	[13981]={ class = "ROGUE", level = 10, },
	[14066]={ class = "ROGUE", level = 10, },
	[79150]={ class = "ROGUE", level = 10, },
	[79151]={ class = "ROGUE", level = 10, },
	[79152]={ class = "ROGUE", level = 10, },
	[31211]={ class = "ROGUE", level = 10, },
	[31212]={ class = "ROGUE", level = 10, },
	[31213]={ class = "ROGUE", level = 10, },
	[58414]={ class = "ROGUE", level = 10, },
	[58415]={ class = "ROGUE", level = 10, },
	[51632]={ class = "ROGUE", level = 10, },
	[91023]={ class = "ROGUE", level = 10, },
	[13960]={ class = "ROGUE", level = 10, },
	[13961]={ class = "ROGUE", level = 10, },
	[13962]={ class = "ROGUE", level = 10, },
	[30894]={ class = "ROGUE", level = 10, },
	[30895]={ class = "ROGUE", level = 10, },
	[16511]={ class = "ROGUE", level = 10, },
	[51698]={ class = "ROGUE", level = 10, },
	[51700]={ class = "ROGUE", level = 10, },
	[51701]={ class = "ROGUE", level = 10, },
	[14079]={ class = "ROGUE", level = 10, },
	[14080]={ class = "ROGUE", level = 10, },
	[84661]={ class = "ROGUE", level = 10, },
	[14168]={ class = "ROGUE", level = 10, },
	[14169]={ class = "ROGUE", level = 10, },
	[13741]={ class = "ROGUE", level = 10, },
	[13793]={ class = "ROGUE", level = 10, },
	[13754]={ class = "ROGUE", level = 10, },
	[13867]={ class = "ROGUE", level = 10, },
	[14174]={ class = "ROGUE", level = 10, },
	[14175]={ class = "ROGUE", level = 10, },
	[14176]={ class = "ROGUE", level = 10, },
	[14113]={ class = "ROGUE", level = 10, },
	[14114]={ class = "ROGUE", level = 10, },
	[14115]={ class = "ROGUE", level = 10, },
	[14116]={ class = "ROGUE", level = 10, },
	[14117]={ class = "ROGUE", level = 10, },
	[79007]={ class = "ROGUE", level = 10, },
	[79008]={ class = "ROGUE", level = 10, },
	[13732]={ class = "ROGUE", level = 10, },
	[13863]={ class = "ROGUE", level = 10, },
	[79004]={ class = "ROGUE", level = 10, },
	[14165]={ class = "ROGUE", level = 10, },
	[14166]={ class = "ROGUE", level = 10, },
	[13743]={ class = "ROGUE", level = 10, },
	[13875]={ class = "ROGUE", level = 10, },
	[13976]={ class = "ROGUE", level = 10, },
	[13979]={ class = "ROGUE", level = 10, },
	[51690]={ class = "ROGUE", level = 10, },
	[14128]={ class = "ROGUE", level = 10, },
	[14132]={ class = "ROGUE", level = 10, },
	[14135]={ class = "ROGUE", level = 10, },
	[13712]={ class = "ROGUE", level = 10, },
	[13788]={ class = "ROGUE", level = 10, },
	[13789]={ class = "ROGUE", level = 10, },
	[14138]={ class = "ROGUE", level = 10, },
	[14139]={ class = "ROGUE", level = 10, },
	[14140]={ class = "ROGUE", level = 10, },
	[14141]={ class = "ROGUE", level = 10, },
	[14142]={ class = "ROGUE", level = 10, },
	[31223]={ class = "ROGUE", level = 10, },
	[58410]={ class = "ROGUE", level = 10, },
	[14158]={ class = "ROGUE", level = 10, },
	[14159]={ class = "ROGUE", level = 10, },
	[1329]={ class = "ROGUE", level = 10, },
	[31130]={ class = "ROGUE", level = 10, },
	[31131]={ class = "ROGUE", level = 10, },
	[13975]={ class = "ROGUE", level = 10, },
	[14062]={ class = "ROGUE", level = 10, },
	[14057]={ class = "ROGUE", level = 10, },
	[14072]={ class = "ROGUE", level = 10, },
	[79141]={ class = "ROGUE", level = 10, },
	[58426]={ class = "ROGUE", level = 10, },
	[13705]={ class = "ROGUE", level = 10, },
	[13832]={ class = "ROGUE", level = 10, },
	[13843]={ class = "ROGUE", level = 10, },
	[14183]={ class = "ROGUE", level = 10, },
	[14185]={ class = "ROGUE", level = 10, },
	[51685]={ class = "ROGUE", level = 10, },
	[51686]={ class = "ROGUE", level = 10, },
	[51687]={ class = "ROGUE", level = 10, },
	[51688]={ class = "ROGUE", level = 10, },
	[51689]={ class = "ROGUE", level = 10, },
	[13733]={ class = "ROGUE", level = 10, },
	[13865]={ class = "ROGUE", level = 10, },
	[13866]={ class = "ROGUE", level = 10, },
	[31244]={ class = "ROGUE", level = 10, },
	[31245]={ class = "ROGUE", level = 10, },
	[31208]={ class = "ROGUE", level = 10, },
	[31209]={ class = "ROGUE", level = 10, },
	[79077]={ class = "ROGUE", level = 10, },
	[79079]={ class = "ROGUE", level = 10, },
	[14179]={ class = "ROGUE", level = 10, },
	[58422]={ class = "ROGUE", level = 10, },
	[58423]={ class = "ROGUE", level = 10, },
	[14144]={ class = "ROGUE", level = 10, },
	[14148]={ class = "ROGUE", level = 10, },
	[79095]={ class = "ROGUE", level = 10, },
	[79096]={ class = "ROGUE", level = 10, },
	[84617]={ class = "ROGUE", level = 10, },
	[14251]={ class = "ROGUE", level = 10, },
	[14156]={ class = "ROGUE", level = 10, },
	[14160]={ class = "ROGUE", level = 10, },
	[14161]={ class = "ROGUE", level = 10, },
	[79146]={ class = "ROGUE", level = 10, },
	[79147]={ class = "ROGUE", level = 10, },
	[51682]={ class = "ROGUE", level = 10, },
	[58413]={ class = "ROGUE", level = 10, },
	[14186]={ class = "ROGUE", level = 10, },
	[14190]={ class = "ROGUE", level = 10, },
	[14171]={ class = "ROGUE", level = 10, },
	[14172]={ class = "ROGUE", level = 10, },
	[13983]={ class = "ROGUE", level = 10, },
	[14070]={ class = "ROGUE", level = 10, },
	[14071]={ class = "ROGUE", level = 10, },
	[51713]={ class = "ROGUE", level = 10, },
	[36554]={ class = "ROGUE", level = 10, },
	[31220]={ class = "ROGUE", level = 10, },
	[51708]={ class = "ROGUE", level = 10, },
	[51709]={ class = "ROGUE", level = 10, },
	[51710]={ class = "ROGUE", level = 10, },
	[32601]={ class = "ROGUE", level = 10, },
	[5952]={ class = "ROGUE", level = 10, },
	[51679]={ class = "ROGUE", level = 10, },
	[51627]={ class = "ROGUE", level = 10, },
	[51628]={ class = "ROGUE", level = 10, },
	[51629]={ class = "ROGUE", level = 10, },
	[51672]={ class = "ROGUE", level = 10, },
	[51674]={ class = "ROGUE", level = 10, },
	[79140]={ class = "ROGUE", level = 10, },
	[79133]={ class = "ROGUE", level = 10, },
	[79134]={ class = "ROGUE", level = 10, },
	[14983]={ class = "ROGUE", level = 10, },
	[16513]={ class = "ROGUE", level = 10, },
	[16514]={ class = "ROGUE", level = 10, },
	[16515]={ class = "ROGUE", level = 10, },
	[61329]={ class = "ROGUE", level = 10, },
	[51692]={ class = "ROGUE", level = 10, },
	[51696]={ class = "ROGUE", level = 10, },
	[30919]={ class = "ROGUE", level = 10, },
	[30920]={ class = "ROGUE", level = 10, },
--++ Shaman Abilities ++	
	[86961]={ class = "SHAMAN", level = 1, },
	[86958]={ class = "SHAMAN", level = 1, },
	[88767]={ class = "SHAMAN", level = 1, },
	[95862]={ class = "SHAMAN", level = 1, },
	[16213]={ class = "SHAMAN", level = 1, },
	[73683]={ class = "SHAMAN", level = 1, },
	[73681]={ class = "SHAMAN", level = 1, },
	[86629]={ class = "SHAMAN", level = 1, },
	[82980]={ class = "SHAMAN", level = 1, },
	[82981]={ class = "SHAMAN", level = 1, },
	[82982]={ class = "SHAMAN", level = 1, },
	[77451]={ class = "SHAMAN", level = 1, },
	[403]={ class = "SHAMAN", level = 1, },
	[73899]={ class = "SHAMAN", level = 3, },
	[8075]={ class = "SHAMAN", level = 4, },
	[8042]={ class = "SHAMAN", level = 5, },
	[331]={ class = "SHAMAN", level = 7, },
	[324]={ class = "SHAMAN", level = 8, },
	[8024]={ class = "SHAMAN", level = 10, },
	[3599]={ class = "SHAMAN", level = 10, },
	[2008]={ class = "SHAMAN", level = 12, },
	[8349]={ class = "SHAMAN", level = 12, },
	[8227]={ class = "SHAMAN", level = 12, },
	[370]={ class = "SHAMAN", level = 12, },
	[8050]={ class = "SHAMAN", level = 14, },
	[2645]={ class = "SHAMAN", level = 15, },
	[57994]={ class = "SHAMAN", level = 16, },
	[51886]={ class = "SHAMAN", level = 18, },
	[2484]={ class = "SHAMAN", level = 18, },
	[5394]={ class = "SHAMAN", level = 20, },
	[8004]={ class = "SHAMAN", level = 20, },
	[52127]={ class = "SHAMAN", level = 20, },
	[8056]={ class = "SHAMAN", level = 22, },
	[546]={ class = "SHAMAN", level = 24, },
	[8033]={ class = "SHAMAN", level = 26, },
	[421]={ class = "SHAMAN", level = 28, },
	[1535]={ class = "SHAMAN", level = 28, },
	[556]={ class = "SHAMAN", level = 30, },
	[66842]={ class = "SHAMAN", level = 30, },
	[20608]={ class = "SHAMAN", level = 30, },
	[36936]={ class = "SHAMAN", level = 30, },
	[8512]={ class = "SHAMAN", level = 30, },
	[8232]={ class = "SHAMAN", level = 32, },
	[51505]={ class = "SHAMAN", level = 34, },
	[6196]={ class = "SHAMAN", level = 36, },
	[8190]={ class = "SHAMAN", level = 36, },
	[8177]={ class = "SHAMAN", level = 38, },
	[66843]={ class = "SHAMAN", level = 40, },
	[1064]={ class = "SHAMAN", level = 40, },
	[5675]={ class = "SHAMAN", level = 42, },
	[450762]={ class = "SHAMAN", level = 44, },
	[3738]={ class = "SHAMAN", level = 44, },
	[131]={ class = "SHAMAN", level = 46, },
	[8071]={ class = "SHAMAN", level = 48, },
	[66844]={ class = "SHAMAN", level = 50, },
	[77478]={ class = "SHAMAN", level = 50, },
	[8143]={ class = "SHAMAN", level = 52, },
	[51730]={ class = "SHAMAN", level = 54, },
	[2062]={ class = "SHAMAN", level = 56, },
	[5730]={ class = "SHAMAN", level = 58, },
	[8184]={ class = "SHAMAN", level = 62, },
	[76780]={ class = "SHAMAN", level = 64, },
	[2894]={ class = "SHAMAN", level = 66, },
	[77472]={ class = "SHAMAN", level = 68, },
	[87718]={ class = "SHAMAN", level = 74, },
	[8017]={ class = "SHAMAN", level = 75, },
	[51514]={ class = "SHAMAN", level = 80, },
	[73680]={ class = "SHAMAN", level = 81, },
	[73920]={ class = "SHAMAN", level = 83, },
	[79206]={ class = "SHAMAN", level = 85, },
--++ Shaman Talents ++	
	[17485]={ class = "SHAMAN", level = 10, },
	[17486]={ class = "SHAMAN", level = 10, },
	[17487]={ class = "SHAMAN", level = 10, },
	[30675]={ class = "SHAMAN", level = 10, },
	[30678]={ class = "SHAMAN", level = 10, },
	[30679]={ class = "SHAMAN", level = 10, },
	[51556]={ class = "SHAMAN", level = 10, },
	[51557]={ class = "SHAMAN", level = 10, },
	[51558]={ class = "SHAMAN", level = 10, },
	[16176]={ class = "SHAMAN", level = 10, },
	[16235]={ class = "SHAMAN", level = 10, },
	[77829]={ class = "SHAMAN", level = 10, },
	[77830]={ class = "SHAMAN", level = 10, },
	[16262]={ class = "SHAMAN", level = 10, },
	[16287]={ class = "SHAMAN", level = 10, },
	[51474]={ class = "SHAMAN", level = 10, },
	[51478]={ class = "SHAMAN", level = 10, },
	[51479]={ class = "SHAMAN", level = 10, },
	[51554]={ class = "SHAMAN", level = 10, },
	[51555]={ class = "SHAMAN", level = 10, },
	[63370]={ class = "SHAMAN", level = 10, },
	[63372]={ class = "SHAMAN", level = 10, },
	[16038]={ class = "SHAMAN", level = 10, },
	[16160]={ class = "SHAMAN", level = 10, },
	[86959]={ class = "SHAMAN", level = 10, },
	[86962]={ class = "SHAMAN", level = 10, },
	[16035]={ class = "SHAMAN", level = 10, },
	[16105]={ class = "SHAMAN", level = 10, },
	[16106]={ class = "SHAMAN", level = 10, },
	[16039]={ class = "SHAMAN", level = 10, },
	[16109]={ class = "SHAMAN", level = 10, },
	[30798]={ class = "SHAMAN", level = 10, },
	[974]={ class = "SHAMAN", level = 10, },
	[51483]={ class = "SHAMAN", level = 10, },
	[51485]={ class = "SHAMAN", level = 10, },
	[51523]={ class = "SHAMAN", level = 10, },
	[51524]={ class = "SHAMAN", level = 10, },
	[61882]={ class = "SHAMAN", level = 10, },
	[29179]={ class = "SHAMAN", level = 10, },
	[29180]={ class = "SHAMAN", level = 10, },
	[30160]={ class = "SHAMAN", level = 10, },
	[16164]={ class = "SHAMAN", level = 10, },
	[60188]={ class = "SHAMAN", level = 10, },
	[16166]={ class = "SHAMAN", level = 10, },
	[51466]={ class = "SHAMAN", level = 10, },
	[51470]={ class = "SHAMAN", level = 10, },
	[30672]={ class = "SHAMAN", level = 10, },
	[30673]={ class = "SHAMAN", level = 10, },
	[30674]={ class = "SHAMAN", level = 10, },
	[28999]={ class = "SHAMAN", level = 10, },
	[29000]={ class = "SHAMAN", level = 10, },
	[28996]={ class = "SHAMAN", level = 10, },
	[28997]={ class = "SHAMAN", level = 10, },
	[28998]={ class = "SHAMAN", level = 10, },
	[16266]={ class = "SHAMAN", level = 10, },
	[29079]={ class = "SHAMAN", level = 10, },
	[86183]={ class = "SHAMAN", level = 10, },
	[86184]={ class = "SHAMAN", level = 10, },
	[86185]={ class = "SHAMAN", level = 10, },
	[51533]={ class = "SHAMAN", level = 10, },
	[16256]={ class = "SHAMAN", level = 10, },
	[16281]={ class = "SHAMAN", level = 10, },
	[16282]={ class = "SHAMAN", level = 10, },
	[77794]={ class = "SHAMAN", level = 10, },
	[77795]={ class = "SHAMAN", level = 10, },
	[77796]={ class = "SHAMAN", level = 10, },
	[30864]={ class = "SHAMAN", level = 10, },
	[30865]={ class = "SHAMAN", level = 10, },
	[30866]={ class = "SHAMAN", level = 10, },
	[77536]={ class = "SHAMAN", level = 10, },
	[77537]={ class = "SHAMAN", level = 10, },
	[77538]={ class = "SHAMAN", level = 10, },
	[63373]={ class = "SHAMAN", level = 10, },
	[63374]={ class = "SHAMAN", level = 10, },
	[88766]={ class = "SHAMAN", level = 10, },
	[16181]={ class = "SHAMAN", level = 10, },
	[16230]={ class = "SHAMAN", level = 10, },
	[16232]={ class = "SHAMAN", level = 10, },
	[29187]={ class = "SHAMAN", level = 10, },
	[29189]={ class = "SHAMAN", level = 10, },
	[29191]={ class = "SHAMAN", level = 10, },
	[29202]={ class = "SHAMAN", level = 10, },
	[29205]={ class = "SHAMAN", level = 10, },
	[29206]={ class = "SHAMAN", level = 10, },
	[30872]={ class = "SHAMAN", level = 10, },
	[30873]={ class = "SHAMAN", level = 10, },
	[77130]={ class = "SHAMAN", level = 10, },
	[77700]={ class = "SHAMAN", level = 10, },
	[77701]={ class = "SHAMAN", level = 10, },
	[16261]={ class = "SHAMAN", level = 10, },
	[16290]={ class = "SHAMAN", level = 10, },
	[51881]={ class = "SHAMAN", level = 10, },
	[51480]={ class = "SHAMAN", level = 10, },
	[51481]={ class = "SHAMAN", level = 10, },
	[51482]={ class = "SHAMAN", level = 10, },
	[60103]={ class = "SHAMAN", level = 10, },
	[77755]={ class = "SHAMAN", level = 10, },
	[77756]={ class = "SHAMAN", level = 10, },
	[51528]={ class = "SHAMAN", level = 10, },
	[51529]={ class = "SHAMAN", level = 10, },
	[51530]={ class = "SHAMAN", level = 10, },
	[16190]={ class = "SHAMAN", level = 10, },
	[30814]={ class = "SHAMAN", level = 10, },
	[30867]={ class = "SHAMAN", level = 10, },
	[30868]={ class = "SHAMAN", level = 10, },
	[30869]={ class = "SHAMAN", level = 10, },
	[30881]={ class = "SHAMAN", level = 10, },
	[30883]={ class = "SHAMAN", level = 10, },
	[30884]={ class = "SHAMAN", level = 10, },
	[16188]={ class = "SHAMAN", level = 10, },
	[51522]={ class = "SHAMAN", level = 10, },
	[16180]={ class = "SHAMAN", level = 10, },
	[16196]={ class = "SHAMAN", level = 10, },
	[16040]={ class = "SHAMAN", level = 10, },
	[16113]={ class = "SHAMAN", level = 10, },
	[61295]={ class = "SHAMAN", level = 10, },
	[88756]={ class = "SHAMAN", level = 10, },
	[88764]={ class = "SHAMAN", level = 10, },
	[77655]={ class = "SHAMAN", level = 10, },
	[77656]={ class = "SHAMAN", level = 10, },
	[77657]={ class = "SHAMAN", level = 10, },
	[16086]={ class = "SHAMAN", level = 10, },
	[16544]={ class = "SHAMAN", level = 10, },
	[62099]={ class = "SHAMAN", level = 10, },
	[43338]={ class = "SHAMAN", level = 10, },
	[30823]={ class = "SHAMAN", level = 10, },
	[16187]={ class = "SHAMAN", level = 10, },
	[16205]={ class = "SHAMAN", level = 10, },
	[84846]={ class = "SHAMAN", level = 10, },
	[84847]={ class = "SHAMAN", level = 10, },
	[84848]={ class = "SHAMAN", level = 10, },
	[98008]={ class = "SHAMAN", level = 10, },
	[51525]={ class = "SHAMAN", level = 10, },
	[51526]={ class = "SHAMAN", level = 10, },
	[51527]={ class = "SHAMAN", level = 10, },
	[17364]={ class = "SHAMAN", level = 10, },
	[82984]={ class = "SHAMAN", level = 10, },
	[82988]={ class = "SHAMAN", level = 10, },
	[51490]={ class = "SHAMAN", level = 10, },
	[16179]={ class = "SHAMAN", level = 10, },
	[16214]={ class = "SHAMAN", level = 10, },
	[16215]={ class = "SHAMAN", level = 10, },
	[55198]={ class = "SHAMAN", level = 10, },
	[51562]={ class = "SHAMAN", level = 10, },
	[51563]={ class = "SHAMAN", level = 10, },
	[51564]={ class = "SHAMAN", level = 10, },
	[16173]={ class = "SHAMAN", level = 10, },
	[16222]={ class = "SHAMAN", level = 10, },
	[86935]={ class = "SHAMAN", level = 10, },
	[86936]={ class = "SHAMAN", level = 10, },
	[77692]={ class = "SHAMAN", level = 10, },
	[77693]={ class = "SHAMAN", level = 10, },
	[77746]={ class = "SHAMAN", level = 10, },
	[16252]={ class = "SHAMAN", level = 10, },
	[16306]={ class = "SHAMAN", level = 10, },
	[16307]={ class = "SHAMAN", level = 10, },
	[30802]={ class = "SHAMAN", level = 10, },
	[30808]={ class = "SHAMAN", level = 10, },
	[30664]={ class = "SHAMAN", level = 10, },
	[30665]={ class = "SHAMAN", level = 10, },
	[30666]={ class = "SHAMAN", level = 10, },
--++ Warlock Abilities ++	
	[84741]={ class = "WARLOCK", level = 1, },
	[84739]={ class = "WARLOCK", level = 1, },
	[75445]={ class = "WARLOCK", level = 1, },
	[84740]={ class = "WARLOCK", level = 1, },
	[88448]={ class = "WARLOCK", level = 1, },
	[87339]={ class = "WARLOCK", level = 1, },
	[87330]={ class = "WARLOCK", level = 1, },
	[54786]={ class = "WARLOCK", level = 1, },
	[686]={ class = "WARLOCK", level = 1, },
	[86213]={ class = "WARLOCK", level = 1, },
	[688]={ class = "WARLOCK", level = 1, },
	[348]={ class = "WARLOCK", level = 3, },
	[172]={ class = "WARLOCK", level = 4, },
	[1454]={ class = "WARLOCK", level = 5, },
	[689]={ class = "WARLOCK", level = 6, },
	[89420]={ class = "WARLOCK", level = 6, },
	[687]={ class = "WARLOCK", level = 8, },
	[697]={ class = "WARLOCK", level = 8, },
	[6201]={ class = "WARLOCK", level = 9, },
	[1120]={ class = "WARLOCK", level = 10, },
	[74434]={ class = "WARLOCK", level = 10, },
	[980]={ class = "WARLOCK", level = 12, },
	[755]={ class = "WARLOCK", level = 12, },
	[79268]={ class = "WARLOCK", level = 12, },
	[5782]={ class = "WARLOCK", level = 14, },
	[702]={ class = "WARLOCK", level = 16, },
	[5697]={ class = "WARLOCK", level = 16, },
	[693]={ class = "WARLOCK", level = 18, },
	[5740]={ class = "WARLOCK", level = 18, },
	[5676]={ class = "WARLOCK", level = 18, },
	[603]={ class = "WARLOCK", level = 20, },
	[5784]={ class = "WARLOCK", level = 20, },
	[6353]={ class = "WARLOCK", level = 20, },
	[713]={ class = "WARLOCK", level = 20, },
	[712]={ class = "WARLOCK", level = 20, },
	[126]={ class = "WARLOCK", level = 22, },
	[1714]={ class = "WARLOCK", level = 26, },
	[1949]={ class = "WARLOCK", level = 30, },
	[85403]={ class = "WARLOCK", level = 30, },
	[1098]={ class = "WARLOCK", level = 30, },
	[691]={ class = "WARLOCK", level = 30, },
	[710]={ class = "WARLOCK", level = 32, },
	[91711]={ class = "WARLOCK", level = 34, },
	[6229]={ class = "WARLOCK", level = 34, },
	[23161]={ class = "WARLOCK", level = 40, },
	[6789]={ class = "WARLOCK", level = 42, },
	[698]={ class = "WARLOCK", level = 42, },
	[5484]={ class = "WARLOCK", level = 44, },
	[22703]={ class = "WARLOCK", level = 50, },
	[1122]={ class = "WARLOCK", level = 50, },
	[1490]={ class = "WARLOCK", level = 52, },
	[18540]={ class = "WARLOCK", level = 58, },
	[54785]={ class = "WARLOCK", level = 60, },
	[50590]={ class = "WARLOCK", level = 60, },
	[28176]={ class = "WARLOCK", level = 62, },
	[29722]={ class = "WARLOCK", level = 64, },
	[29858]={ class = "WARLOCK", level = 66, },
	[29893]={ class = "WARLOCK", level = 68, },
	[27243]={ class = "WARLOCK", level = 72, },
	[47960]={ class = "WARLOCK", level = 75, },
	[47897]={ class = "WARLOCK", level = 76, },
	[48018]={ class = "WARLOCK", level = 78, },
	[48020]={ class = "WARLOCK", level = 78, },
	[77799]={ class = "WARLOCK", level = 81, },
	[80398]={ class = "WARLOCK", level = 83, },
	[77801]={ class = "WARLOCK", level = 85, },
--++ Warlock Talents ++	
	[85113]={ class = "WARLOCK", level = 10, },
	[85114]={ class = "WARLOCK", level = 10, },
	[18288]={ class = "WARLOCK", level = 10, },
	[85109]={ class = "WARLOCK", level = 10, },
	[85110]={ class = "WARLOCK", level = 10, },
	[89604]={ class = "WARLOCK", level = 10, },
	[89605]={ class = "WARLOCK", level = 10, },
	[47258]={ class = "WARLOCK", level = 10, },
	[47259]={ class = "WARLOCK", level = 10, },
	[47260]={ class = "WARLOCK", level = 10, },
	[34935]={ class = "WARLOCK", level = 39, },
	[34938]={ class = "WARLOCK", level = 41, },
	[34939]={ class = "WARLOCK", level = 43, },
	[17788]={ class = "WARLOCK", level = 10, },
	[17789]={ class = "WARLOCK", level = 10, },
	[17790]={ class = "WARLOCK", level = 10, },
	[80240]={ class = "WARLOCK", level = 10, },
	[85112]={ class = "WARLOCK", level = 10, },
	[91986]={ class = "WARLOCK", level = 10, },
	[17778]={ class = "WARLOCK", level = 10, },
	[17779]={ class = "WARLOCK", level = 10, },
	[17780]={ class = "WARLOCK", level = 10, },
	[50796]={ class = "WARLOCK", level = 10, },
	[17962]={ class = "WARLOCK", level = 10, },
	[30060]={ class = "WARLOCK", level = 10, },
	[30061]={ class = "WARLOCK", level = 10, },
	[30062]={ class = "WARLOCK", level = 10, },
	[30063]={ class = "WARLOCK", level = 10, },
	[30064]={ class = "WARLOCK", level = 10, },
	[85103]={ class = "WARLOCK", level = 10, },
	[85104]={ class = "WARLOCK", level = 10, },
	[18223]={ class = "WARLOCK", level = 10, },
	[18694]={ class = "WARLOCK", level = 10, },
	[85283]={ class = "WARLOCK", level = 10, },
	[85284]={ class = "WARLOCK", level = 10, },
	[47198]={ class = "WARLOCK", level = 10, },
	[47199]={ class = "WARLOCK", level = 10, },
	[47200]={ class = "WARLOCK", level = 10, },
	[63156]={ class = "WARLOCK", level = 10, },
	[63158]={ class = "WARLOCK", level = 10, },
	[30143]={ class = "WARLOCK", level = 10, },
	[30144]={ class = "WARLOCK", level = 10, },
	[18705]={ class = "WARLOCK", level = 10, },
	[18706]={ class = "WARLOCK", level = 10, },
	[18707]={ class = "WARLOCK", level = 10, },
	[18697]={ class = "WARLOCK", level = 10, },
	[18698]={ class = "WARLOCK", level = 10, },
	[18699]={ class = "WARLOCK", level = 10, },
	[47193]={ class = "WARLOCK", level = 10, },
	[54509]={ class = "WARLOCK", level = 10, },
	[35691]={ class = "WARLOCK", level = 10, },
	[35692]={ class = "WARLOCK", level = 10, },
	[35693]={ class = "WARLOCK", level = 10, },
	[47236]={ class = "WARLOCK", level = 10, },
	[18126]={ class = "WARLOCK", level = 10, },
	[18127]={ class = "WARLOCK", level = 10, },
	[80228]={ class = "WARLOCK", level = 10, },
	[80229]={ class = "WARLOCK", level = 10, },
	[88446]={ class = "WARLOCK", level = 10, },
	[88447]={ class = "WARLOCK", level = 10, },
	[30319]={ class = "WARLOCK", level = 10, },
	[30320]={ class = "WARLOCK", level = 10, },
	[30321]={ class = "WARLOCK", level = 10, },
	[30242]={ class = "WARLOCK", level = 10, },
	[30245]={ class = "WARLOCK", level = 10, },
	[30246]={ class = "WARLOCK", level = 10, },
	[30247]={ class = "WARLOCK", level = 10, },
	[30248]={ class = "WARLOCK", level = 10, },
	[17917]={ class = "WARLOCK", level = 10, },
	[17918]={ class = "WARLOCK", level = 10, },
	[18827]={ class = "WARLOCK", level = 10, },
	[18829]={ class = "WARLOCK", level = 10, },
	[17954]={ class = "WARLOCK", level = 10, },
	[17955]={ class = "WARLOCK", level = 10, },
	[32381]={ class = "WARLOCK", level = 10, },
	[32382]={ class = "WARLOCK", level = 10, },
	[32383]={ class = "WARLOCK", level = 10, },
	[47220]={ class = "WARLOCK", level = 10, },
	[47221]={ class = "WARLOCK", level = 10, },
	[47195]={ class = "WARLOCK", level = 10, },
	[47196]={ class = "WARLOCK", level = 10, },
	[47197]={ class = "WARLOCK", level = 10, },
	[47201]={ class = "WARLOCK", level = 10, },
	[47202]={ class = "WARLOCK", level = 10, },
	[47203]={ class = "WARLOCK", level = 10, },
	[17783]={ class = "WARLOCK", level = 10, },
	[17784]={ class = "WARLOCK", level = 10, },
	[17785]={ class = "WARLOCK", level = 10, },
	[18708]={ class = "WARLOCK", level = 10, },
	[47230]={ class = "WARLOCK", level = 10, },
	[47231]={ class = "WARLOCK", level = 10, },
	[18731]={ class = "WARLOCK", level = 10, },
	[18743]={ class = "WARLOCK", level = 10, },
	[18744]={ class = "WARLOCK", level = 10, },
	[47266]={ class = "WARLOCK", level = 10, },
	[47267]={ class = "WARLOCK", level = 10, },
	[47268]={ class = "WARLOCK", level = 10, },
	[47269]={ class = "WARLOCK", level = 10, },
	[47270]={ class = "WARLOCK", level = 10, },
	[18218]={ class = "WARLOCK", level = 10, },
	[18219]={ class = "WARLOCK", level = 10, },
	[71521]={ class = "WARLOCK", level = 10, },
	[48181]={ class = "WARLOCK", level = 10, },
	[85106]={ class = "WARLOCK", level = 10, },
	[85107]={ class = "WARLOCK", level = 10, },
	[85108]={ class = "WARLOCK", level = 10, },
	[17810]={ class = "WARLOCK", level = 10, },
	[17811]={ class = "WARLOCK", level = 10, },
	[17812]={ class = "WARLOCK", level = 10, },
	[17813]={ class = "WARLOCK", level = 10, },
	[17814]={ class = "WARLOCK", level = 10, },
	[18180]={ class = "WARLOCK", level = 10, },
	[54347]={ class = "WARLOCK", level = 10, },
	[54348]={ class = "WARLOCK", level = 10, },
	[54349]={ class = "WARLOCK", level = 10, },
	[53754]={ class = "WARLOCK", level = 10, },
	[53759]={ class = "WARLOCK", level = 10, },
	[18703]={ class = "WARLOCK", level = 10, },
	[18704]={ class = "WARLOCK", level = 10, },
	[30054]={ class = "WARLOCK", level = 10, },
	[30057]={ class = "WARLOCK", level = 10, },
	[17815]={ class = "WARLOCK", level = 10, },
	[17833]={ class = "WARLOCK", level = 10, },
	[17834]={ class = "WARLOCK", level = 10, },
	[18695]={ class = "WARLOCK", level = 10, },
	[18696]={ class = "WARLOCK", level = 10, },
	[18182]={ class = "WARLOCK", level = 10, },
	[18183]={ class = "WARLOCK", level = 10, },
	[18754]={ class = "WARLOCK", level = 10, },
	[18755]={ class = "WARLOCK", level = 10, },
	[18756]={ class = "WARLOCK", level = 10, },
	[17927]={ class = "WARLOCK", level = 10, },
	[17929]={ class = "WARLOCK", level = 10, },
	[18119]={ class = "WARLOCK", level = 10, },
	[18120]={ class = "WARLOCK", level = 10, },
	[54118]={ class = "WARLOCK", level = 10, },
	[85105]={ class = "WARLOCK", level = 10, },
	[18135]={ class = "WARLOCK", level = 10, },
	[18136]={ class = "WARLOCK", level = 10, },
	[18179]={ class = "WARLOCK", level = 10, },
	[85479]={ class = "WARLOCK", level = 10, },
	[32477]={ class = "WARLOCK", level = 10, },
	[32483]={ class = "WARLOCK", level = 10, },
	[32484]={ class = "WARLOCK", level = 10, },
	[30326]={ class = "WARLOCK", level = 10, },
	[85175]={ class = "WARLOCK", level = 10, },
	[18767]={ class = "WARLOCK", level = 10, },
	[18768]={ class = "WARLOCK", level = 10, },
	[23785]={ class = "WARLOCK", level = 10, },
	[23822]={ class = "WARLOCK", level = 10, },
	[23823]={ class = "WARLOCK", level = 10, },
	[23824]={ class = "WARLOCK", level = 10, },
	[23825]={ class = "WARLOCK", level = 10, },
	[18709]={ class = "WARLOCK", level = 10, },
	[18710]={ class = "WARLOCK", level = 10, },
	[59672]={ class = "WARLOCK", level = 10, },
	[47245]={ class = "WARLOCK", level = 10, },
	[47246]={ class = "WARLOCK", level = 10, },
	[47247]={ class = "WARLOCK", level = 10, },
	[63117]={ class = "WARLOCK", level = 10, },
	[63121]={ class = "WARLOCK", level = 10, },
	[30299]={ class = "WARLOCK", level = 10, },
	[30301]={ class = "WARLOCK", level = 10, },
	[91713]={ class = "WARLOCK", level = 10, },
	[18094]={ class = "WARLOCK", level = 10, },
	[18095]={ class = "WARLOCK", level = 10, },
	[85099]={ class = "WARLOCK", level = 10, },
	[85100]={ class = "WARLOCK", level = 10, },
	[17959]={ class = "WARLOCK", level = 10, },
	[59738]={ class = "WARLOCK", level = 10, },
	[59739]={ class = "WARLOCK", level = 10, },
	[59740]={ class = "WARLOCK", level = 10, },
	[59741]={ class = "WARLOCK", level = 10, },
	[17793]={ class = "WARLOCK", level = 10, },
	[17796]={ class = "WARLOCK", level = 10, },
	[17801]={ class = "WARLOCK", level = 10, },
	[32385]={ class = "WARLOCK", level = 10, },
	[32387]={ class = "WARLOCK", level = 10, },
	[32392]={ class = "WARLOCK", level = 10, },
	[18271]={ class = "WARLOCK", level = 10, },
	[18272]={ class = "WARLOCK", level = 10, },
	[18273]={ class = "WARLOCK", level = 10, },
	[18274]={ class = "WARLOCK", level = 10, },
	[18275]={ class = "WARLOCK", level = 10, },
	[17877]={ class = "WARLOCK", level = 10, },
	[30283]={ class = "WARLOCK", level = 10, },
	[63108]={ class = "WARLOCK", level = 10, },
	[86667]={ class = "WARLOCK", level = 10, },
	[30293]={ class = "WARLOCK", level = 10, },
	[30295]={ class = "WARLOCK", level = 10, },
	[19028]={ class = "WARLOCK", level = 10, },
	[17804]={ class = "WARLOCK", level = 10, },
	[17805]={ class = "WARLOCK", level = 10, },
	[86121]={ class = "WARLOCK", level = 10, },
	[86664]={ class = "WARLOCK", level = 10, },
	[30146]={ class = "WARLOCK", level = 10, },
	[18769]={ class = "WARLOCK", level = 10, },
	[18770]={ class = "WARLOCK", level = 10, },
	[18771]={ class = "WARLOCK", level = 10, },
	[18772]={ class = "WARLOCK", level = 10, },
	[18773]={ class = "WARLOCK", level = 10, },
	[30108]={ class = "WARLOCK", level = 10, },
--++ Warrior Abilities ++	
	[93098]={ class = "WARRIOR", level = 1, },
	[2457]={ class = "WARRIOR", level = 1, },
	[20253]={ class = "WARRIOR", level = 1, },
	[76858]={ class = "WARRIOR", level = 1, },
	[88161]={ class = "WARRIOR", level = 1, },
	[100]={ class = "WARRIOR", level = 3, },
	[34428]={ class = "WARRIOR", level = 5, },
	[772]={ class = "WARRIOR", level = 7, },
	[6343]={ class = "WARRIOR", level = 9, },
	[71]={ class = "WARRIOR", level = 10, },
	[3127]={ class = "WARRIOR", level = 10, },
	[355]={ class = "WARRIOR", level = 12, },
	[78]={ class = "WARRIOR", level = 14, },
	[5308]={ class = "WARRIOR", level = 16, },
	[7386]={ class = "WARRIOR", level = 18, },
	[57755]={ class = "WARRIOR", level = 20, },
	[7384]={ class = "WARRIOR", level = 22, },
	[845]={ class = "WARRIOR", level = 24, },
	[1715]={ class = "WARRIOR", level = 26, },
	[2565]={ class = "WARRIOR", level = 28, },
	[2458]={ class = "WARRIOR", level = 30, },
	[676]={ class = "WARRIOR", level = 34, },
	[1680]={ class = "WARRIOR", level = 36, },
	[6552]={ class = "WARRIOR", level = 38, },
	[96103]={ class = "WARRIOR", level = 39, },
	[85384]={ class = "WARRIOR", level = 39, },
	[6572]={ class = "WARRIOR", level = 40, },
	[1464]={ class = "WARRIOR", level = 44, },
	[871]={ class = "WARRIOR", level = 48, },
	[20252]={ class = "WARRIOR", level = 50, },
	[18499]={ class = "WARRIOR", level = 54, },
	[1134]={ class = "WARRIOR", level = 56, },
	[12678]={ class = "WARRIOR", level = 58, },
	[20230]={ class = "WARRIOR", level = 62, },
	[1719]={ class = "WARRIOR", level = 64, },
	[23920]={ class = "WARRIOR", level = 66, },
	[3411]={ class = "WARRIOR", level = 72, },
	[64382]={ class = "WARRIOR", level = 74, },
	[55694]={ class = "WARRIOR", level = 76, },
	[86346]={ class = "WARRIOR", level = 81, },
	[97462]={ class = "WARRIOR", level = 83, },
	[6544]={ class = "WARRIOR", level = 85, },
	[52174]={ class = "WARRIOR", level = 85, },
--++ Warrior Talents ++	
	[12296]={ class = "WARRIOR", level = 10, },
	[29593]={ class = "WARRIOR", level = 10, },
	[29594]={ class = "WARRIOR", level = 10, },
	[12322]={ class = "WARRIOR", level = 10, },
	[85741]={ class = "WARRIOR", level = 10, },
	[85742]={ class = "WARRIOR", level = 10, },
	[46924]={ class = "WARRIOR", level = 10, },
	[80976]={ class = "WARRIOR", level = 10, },
	[80977]={ class = "WARRIOR", level = 10, },
	[84614]={ class = "WARRIOR", level = 10, },
	[84615]={ class = "WARRIOR", level = 10, },
	[16487]={ class = "WARRIOR", level = 10, },
	[16489]={ class = "WARRIOR", level = 10, },
	[16492]={ class = "WARRIOR", level = 10, },
	[29836]={ class = "WARRIOR", level = 10, },
	[29859]={ class = "WARRIOR", level = 10, },
	[46913]={ class = "WARRIOR", level = 10, },
	[46914]={ class = "WARRIOR", level = 10, },
	[46915]={ class = "WARRIOR", level = 10, },
	[23881]={ class = "WARRIOR", level = 10, },
	[12321]={ class = "WARRIOR", level = 10, },
	[12835]={ class = "WARRIOR", level = 10, },
	[12809]={ class = "WARRIOR", level = 10, },
	[12320]={ class = "WARRIOR", level = 10, },
	[12852]={ class = "WARRIOR", level = 10, },
	[85730]={ class = "WARRIOR", level = 10, },
	[12292]={ class = "WARRIOR", level = 10, },
	[12834]={ class = "WARRIOR", level = 10, },
	[12849]={ class = "WARRIOR", level = 10, },
	[12867]={ class = "WARRIOR", level = 10, },
	[20243]={ class = "WARRIOR", level = 10, },
	[81913]={ class = "WARRIOR", level = 10, },
	[81914]={ class = "WARRIOR", level = 10, },
	[12290]={ class = "WARRIOR", level = 10, },
	[12963]={ class = "WARRIOR", level = 10, },
	[23588]={ class = "WARRIOR", level = 10, },
	[12317]={ class = "WARRIOR", level = 10, },
	[13045]={ class = "WARRIOR", level = 10, },
	[13046]={ class = "WARRIOR", level = 10, },
	[20502]={ class = "WARRIOR", level = 10, },
	[20503]={ class = "WARRIOR", level = 10, },
	[84579]={ class = "WARRIOR", level = 10, },
	[84580]={ class = "WARRIOR", level = 10, },
	[12319]={ class = "WARRIOR", level = 10, },
	[12971]={ class = "WARRIOR", level = 10, },
	[12972]={ class = "WARRIOR", level = 10, },
	[46910]={ class = "WARRIOR", level = 10, },
	[12311]={ class = "WARRIOR", level = 10, },
	[12958]={ class = "WARRIOR", level = 10, },
	[86894]={ class = "WARRIOR", level = 10, },
	[86896]={ class = "WARRIOR", level = 10, },
	[60970]={ class = "WARRIOR", level = 10, },
	[84604]={ class = "WARRIOR", level = 10, },
	[84621]={ class = "WARRIOR", level = 10, },
	[16493]={ class = "WARRIOR", level = 10, },
	[16494]={ class = "WARRIOR", level = 10, },
	[80128]={ class = "WARRIOR", level = 10, },
	[80129]={ class = "WARRIOR", level = 10, },
	[12289]={ class = "WARRIOR", level = 10, },
	[12668]={ class = "WARRIOR", level = 10, },
	[12797]={ class = "WARRIOR", level = 10, },
	[12799]={ class = "WARRIOR", level = 10, },
	[12330]={ class = "WARRIOR", level = 10, },
	[86655]={ class = "WARRIOR", level = 10, },
	[50685]={ class = "WARRIOR", level = 10, },
	[50686]={ class = "WARRIOR", level = 10, },
	[50687]={ class = "WARRIOR", level = 10, },
	[46908]={ class = "WARRIOR", level = 10, },
	[46909]={ class = "WARRIOR", level = 10, },
	[64976]={ class = "WARRIOR", level = 10, },
	[84583]={ class = "WARRIOR", level = 10, },
	[84587]={ class = "WARRIOR", level = 10, },
	[84588]={ class = "WARRIOR", level = 10, },
	[12975]={ class = "WARRIOR", level = 10, },
	[12329]={ class = "WARRIOR", level = 10, },
	[12950]={ class = "WARRIOR", level = 10, },
	[12294]={ class = "WARRIOR", level = 10, },
	[12323]={ class = "WARRIOR", level = 10, },
	[29592]={ class = "WARRIOR", level = 10, },
	[85288]={ class = "WARRIOR", level = 10, },
	[29801]={ class = "WARRIOR", level = 10, },
	[61216]={ class = "WARRIOR", level = 10, },
	[61221]={ class = "WARRIOR", level = 10, },
	[46945]={ class = "WARRIOR", level = 10, },
	[46949]={ class = "WARRIOR", level = 10, },
	[29834]={ class = "WARRIOR", level = 10, },
	[29838]={ class = "WARRIOR", level = 10, },
	[29144]={ class = "WARRIOR", level = 10, },
	[29598]={ class = "WARRIOR", level = 10, },
	[84607]={ class = "WARRIOR", level = 10, },
	[84608]={ class = "WARRIOR", level = 10, },
	[23922]={ class = "WARRIOR", level = 10, },
	[12298]={ class = "WARRIOR", level = 10, },
	[12724]={ class = "WARRIOR", level = 10, },
	[12725]={ class = "WARRIOR", level = 10, },
	[46968]={ class = "WARRIOR", level = 10, },
	[81099]={ class = "WARRIOR", level = 10, },
	[29888]={ class = "WARRIOR", level = 10, },
	[29889]={ class = "WARRIOR", level = 10, },
	[29723]={ class = "WARRIOR", level = 10, },
	[29725]={ class = "WARRIOR", level = 10, },
	[80981]={ class = "WARRIOR", level = 10, },
	[12328]={ class = "WARRIOR", level = 10, },
	[46951]={ class = "WARRIOR", level = 10, },
	[46952]={ class = "WARRIOR", level = 10, },
	[46953]={ class = "WARRIOR", level = 10, },
	[12295]={ class = "WARRIOR", level = 10, },
	[12676]={ class = "WARRIOR", level = 10, },
	[56636]={ class = "WARRIOR", level = 10, },
	[56637]={ class = "WARRIOR", level = 10, },
	[56638]={ class = "WARRIOR", level = 10, },
	[85388]={ class = "WARRIOR", level = 10, },
	[80979]={ class = "WARRIOR", level = 10, },
	[80980]={ class = "WARRIOR", level = 10, },
	[46917]={ class = "WARRIOR", level = 10, },
	[12299]={ class = "WARRIOR", level = 10, },
	[12761]={ class = "WARRIOR", level = 10, },
	[12762]={ class = "WARRIOR", level = 10, },
	[12712]={ class = "WARRIOR", level = 10, },
	[50720]={ class = "WARRIOR", level = 10, },
	[84570]={ class = "WARRIOR", level = 10, },
	[84571]={ class = "WARRIOR", level = 10, },
	[84572]={ class = "WARRIOR", level = 10, },
	[57499]={ class = "WARRIOR", level = 10, },
	[46867]={ class = "WARRIOR", level = 10, },
	[56611]={ class = "WARRIOR", level = 10, },
	[56612]={ class = "WARRIOR", level = 10, },
--++++++++++	
	[53137]={ level = 1, },
	[53138]={ level = 1, },
	[55078]={ level = 1, },
	[50452]={ level = 1, },
	[45524]={ level = 1, },
	[56222]={ level = 1, },
	[43265]={ level = 1, },
	[49560]={ level = 1, },
	[68766]={ level = 1, },
	[55095]={ level = 1, },
	[67719]={ level = 1, },
	[69917]={ level = 1, },
	[57330]={ level = 1, },
	[49203]={ level = 1, },
	[45477]={ level = 1, },
	[3714]={ level = 1, },
	[60068]={ level = 1, },
	[47476]={ level = 1, },
	[50536]={ level = 1, },
	[49016]={ level = 1, },
	[45334]={ level = 1, },
	[58179]={ level = 1, },
	[58180]={ level = 1, },
	[467]={ level = 1, },
	[13159]={ level = 1, },
	[19506]={ level = 1, },
	[413841]={ level = 1, },
	[57669]={ level = 1, },
	[31935]={ level = 1, },
	[79063]={ level = 1, },
	[79101]={ level = 1, },
	[19746]={ level = 1, },
	[32223]={ level = 1, },
	[465]={ level = 1, },
	[25771]={ level = 1, },
	[1022]={ level = 1, },
	[19891]={ level = 1, },
	[7294]={ level = 1, },
	[79105]={ level = 1, },
	[79107]={ level = 1, },
	[15487]={ level = 1, },
	[3409]={ level = 1, },
	[2825]={ level = 1, },
	[73682]={ level = 1, },
	[57724]={ level = 1, },
	[32182]={ level = 1, },
	[57723]={ level = 1, },
	[32643]={ level = 1, },
	[50589]={ level = 1, },
	[6673]={ level = 1, },
	[1161]={ level = 1, },
	[469]={ level = 1, },
	[413763]={ level = 1, },
	[413764]={ level = 1, },
	[1160]={ level = 1, },
	[5246]={ level = 1, },
	[46857]={ level = 1, },
	[674]={ level = 10, },
	[43308]={ level = 1, },
	[2383]={ level = 1, },
	[8387]={ level = 1, },
	[2580]={ level = 1, },
	[8388]={ level = 1, },
	[28925]={ level = 1, },
	[32977]={ level = 1, },
	[28093]={ level = 1, },
	[38068]={ level = 1, },
	[50310]={ level = 1, },
	[29358]={ level = 1, },
	[29356]={ level = 1, },
	[29361]={ level = 1, },
	[377749]={ level = 1, },
	[45444]={ level = 1, },
	[29175]={ level = 1, },
	[46352]={ level = 1, },
	[48892]={ level = 1, },
	[48890]={ level = 1, },
	[48889]={ level = 1, },
	[48891]={ level = 1, },
	[24708]={ level = 1, },
	[24709]={ level = 1, },
	[24710]={ level = 1, },
	[24711]={ level = 1, },
	[24712]={ level = 1, },
	[24713]={ level = 1, },
	[24714]={ level = 1, },
	[24715]={ level = 1, },
	[24717]={ level = 1, },
	[24718]={ level = 1, },
	[24719]={ level = 1, },
	[24720]={ level = 1, },
	[24723]={ level = 1, },
	[24724]={ level = 1, },
	[24732]={ level = 1, },
	[24733]={ level = 1, },
	[24735]={ level = 1, },
	[24736]={ level = 1, },
	[24737]={ level = 1, },
	[24740]={ level = 1, },
	[24741]={ level = 1, },
	[39953]={ level = 1, },
	[39913]={ level = 1, },
	[39911]={ level = 1, },
	[22888]={ level = 1, },
	[24425]={ level = 1, },
	[16609]={ level = 1, },
	[15366]={ level = 1, },
	[22817]={ level = 50, },
	[22818]={ level = 50, },
	[22820]={ level = 50, },
	[58450]={ level = 70, },
	[58451]={ level = 80, },
	[58452]={ level = 70, },
	[48101]={ level = 70, },
	[60345]={ level = 48, },
	[3166]={ level = 10, },
	[53749]={ level = 27, },
	[60341]={ level = 48, },
	[60344]={ level = 48, },
	[53748]={ level = 48, },
	[60347]={ level = 48, },
	[28499]={ level = 55, },
	[41608]={ level = 70, },
	[67016]={ level = 15, },
	[67017]={ level = 15, },
	[67018]={ level = 15, },
	[67019]={ level = 15, },
	[8690]={ level = 1, },
	[50251]={ level = 1, },
	[32098]={ level = 55, },
	[30452]={ level = 1, },
	[51582]={ level = 1, },
	[349981]={ level = 1, },
	[33265]={ level = 55, },
	[33268]={ level = 55, },
	[35272]={ level = 55, },
	[57079]={ level = 70, },
	[57100]={ level = 70, },
	[57107]={ level = 70, },
	[57325]={ level = 70, },
	[57327]={ level = 70, },
	[57329]={ level = 70, },
};