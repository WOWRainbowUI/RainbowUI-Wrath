local AS_Sound = true;--false
local AS_Max_Enemies = 2
local AS_InstanceType = nil
local AS_PlayerName = nil
local AS_Enemies = {}
local AS_EnemyCheckTimer1 = 0
local AS_EnemyCheckTimer2 = 0
local AS_MinAlpha = 0.1

local AS_Frame = CreateFrame("Frame")
local AS_AlertFrame = CreateFrame("MessageFrame","AS_AlertFrame",UIParent)

function AddEnemyTarget(enemyName,enemyClassName,partyName,className)
	if AS_Enemies[enemyName] then
		local enemy = AS_Enemies[enemyName]
		if enemy.name~=partyName then
			enemy.name = partyName
			enemy.class = className
			enemy.time = 0
			return true;
		else
			enemy.time = 0
			return false;
		end
	else
		AS_Enemies[enemyName] = {
			name = partyName,
			class = className,
			time = 0
		}
		return true;
	end
	return false;
end

function ClearEnemyTarget(enemyName)
	if AS_Enemies[enemyName] then
		local enemy = AS_Enemies[enemyName]
		if enemy.name~=nil then
			enemy.name = nil
			enemy.class = nil
			enemy.time = 0
			AS_Enemies[enemyName] = nil
			return true;
		end
	end
	return false;
end

function EnemyTargetCheck()
	local partyList = {}
	
	for k,enemy in pairs(AS_Enemies) do
		if enemy.name ~= nil then
			if partyList[enemy.name] then 
				local party = partyList[enemy.name]
				party.count = party.count + 1
			else
				partyList[enemy.name]={
					count = 1,
					class = enemy.class
					}
			end
		end
	end
	local sClass = ""
	local sName = ""
	local nCount = 0
	
	for k,party in pairs(partyList) do
		if( party.count > nCount and party.count >=1 ) then
			nCount = party.count
			sClass = party.class
			sName = k
		end
	end
	
	if( nCount>= AS_Max_Enemies ) then
		if( sName == AS_PlayerName ) then
			AS_Frame:Show()
			AS_AlertFrame:AddMessage("[你]|cffFFFF40被 "..nCount.." 個敵人盯上了!|r")
			DEFAULT_CHAT_FRAME:AddMessage("[你]|cffFFFF40被 "..nCount.." 個敵人盯上了!|r")
			if AS_Sound then
				PlaySoundFile("Sound\\Creature\\Executus\\ExecutusSlay01.wav")
			end
		else
			AS_AlertFrame:AddMessage("|cffFFFF40" .. sName .. "|r [" .. sClass .. "]|cffFFFF40被 " .. nCount .. " 個敵人盯上了!|r")
			AS_AlertFrame:AddMessage("|cffFFFF40" .. sName .. "|r [" .. sClass .. "]|cffFFFF40被 " .. nCount .. " 個敵人盯上了!|r")
		end
	end
end

function AS_Delete(t)
	if type(t)~="table" then return end
	for k,v in pairs(t) do
		AS_Delete(t[k])
		t[k] = nil
	end
end

AS_Frame:SetScript("OnShow", function(self)
	self.elapsed = 0
	self:SetAlpha(0)
end)

AS_Frame:SetScript("OnUpdate", function(self, elapsed)
	AS_EnemyCheckTimer1 = AS_EnemyCheckTimer1 + elapsed
	if( AS_EnemyCheckTimer1 >= 0.03 ) then
		self.elapsed = self.elapsed + AS_EnemyCheckTimer1
		AS_EnemyCheckTimer1 = 0
		if self.elapsed < 2.6 then
			local alpha = self.elapsed % 1.3
			if alpha < 0.055 then
				self:SetAlpha(alpha / 0.055)
			elseif alpha < 0.9 then
				alpha = 1 - (alpha - 0.055) / 0.6
				if alpha <= 0 then
					self:Hide()
				else
					self:SetAlpha(alpha)
				end
			else
				self:Hide()
			end
		elseif self.elapsed < 10 then
			if (not UnitIsDeadOrGhost("player")) and (UnitHealth("player")/UnitHealthMax("player")<=AS_MinAlpha) then
				AS_Frame:Show()
			else
				self.elapsed = 10
				self:Hide()
			end
		end
	end
	AS_EnemyCheckTimer2 = AS_EnemyCheckTimer2 + elapsed
	if( AS_EnemyCheckTimer2 >= 1 ) then
		for k,enemy in pairs(AS_Enemies) do
			if enemy.name~=nil then
				enemy.time = enemy.time + AS_EnemyCheckTimer2
				if enemy.time>=2.6 then
					enemy.name = nil
					enemy.class = nil
					enemy.time = 0	
					AS_Enemies[k] = nil
				end
			end
		end
		AS_EnemyCheckTimer2 = 0
	end
end)

AS_Frame:SetScript("OnEvent", function(self, event, ...)
    local arg1 = ...;
	if( event == "VARIABLES_LOADED" ) then
		AS_PlayerName = UnitName("player")
		AS_Frame:UnregisterEvent("VARIABLES_LOADED")
		
		SLASH_ARENASCREENSHOT1 = "/as"
		SLASH_ARENASCREENSHOT2 = "/arenascreenshot"
		SlashCmdList["ARENASCREENSHOT"] = function(msg)
			msg = msg or ""
			local cmd, arg = string.split(" ", msg, 2)
			cmd = string.lower(cmd or "")
			arg = string.lower(arg or "")	
			if( cmd == "" ) then AS_Sound = not AS_Sound
				if AS_Sound then
					DEFAULT_CHAT_FRAME:AddMessage("/as , 打開聲音")
				else
					DEFAULT_CHAT_FRAME:AddMessage("/as , 關閉聲音")
				end
			end
		end
	elseif (event=="ZONE_CHANGED_NEW_AREA" or event=="PLAYER_ENTERING_WORLD" or event=="UPDATE_BATTLEFIELD_STATUS" or event=="UPDATE_WORLD_STATES") then
		local type = select(2, IsInInstance()) 
		if( type == "arena" and type ~= AS_InstanceType ) then
			AS_Delete(AS_Enemies)
			AS_Enemies = {}
		elseif (type == "arena" and GetBattlefieldWinner()~=nil) then
			AS_Delete(AS_Enemies)
			AS_Enemies = {}
		elseif (event=="PLAYER_ENTERING_WORLD") then
			AS_Delete(AS_Enemies)
			AS_Enemies = {}			
		end
		AS_InstanceType = type
	elseif (event == "PARTY_MEMBER_DISABLE") then
		for k,enemy in pairs(AS_Enemies) do
			if enemy.name==arg1 then
				enemy.name = nil
				enemy.class = nil
				enemy.time = 0
				AS_Enemies[k] = nil
			end
		end
	elseif (event == "PLAYER_DEAD") then
		for k,enemy in pairs(AS_Enemies) do
			if enemy.name==AS_PlayerName then
				enemy.name = nil
				enemy.class = nil
				enemy.time = 0
				AS_Enemies[k] = nil
			end
		end	
	elseif( event == "UNIT_TARGET") then
		if (UnitInParty(arg1) and UnitIsPlayer(arg1)) then
			if (UnitExists(arg1.."target") and UnitIsEnemy("player",arg1.."target") and UnitIsPlayer(arg1.."target") and (not UnitIsDeadOrGhost(arg1.."target"))) then 
				if (UnitInParty(arg1.."targettarget") and (not UnitIsDead(arg1.."targettarget"))) then
					if AddEnemyTarget(UnitName(arg1.."target"),UnitClass(arg1.."target"),UnitName(arg1.."targettarget"),UnitClass(arg1.."targettarget")) then
						EnemyTargetCheck()
					end
				else ClearEnemyTarget(UnitName(arg1.."target"))								
				end
			end
		end
	elseif (event == "UPDATE_MOUSEOVER_UNIT") then
		if (UnitIsEnemy("player","mouseover") and UnitIsPlayer("mouseover") and (not UnitIsDeadOrGhost("mouseover"))) then
			if (UnitInParty("mouseovertarget") and (not UnitIsDead("mouseovertarget"))) then
				if AddEnemyTarget(UnitName("mouseover"),UnitClass("mouseover"),UnitName("mouseovertarget"),UnitClass("mouseovertarget")) then
					EnemyTargetCheck()
				end				
			end
		end
	end
end)

AS_Frame:Hide()
AS_Frame:SetToplevel(true)
AS_Frame:SetFrameStrata("FULLSCREEN_DIALOG")
AS_Frame:SetAllPoints(UIParent)
AS_Frame:EnableMouse(false)
AS_Frame.texture = AS_Frame:CreateTexture(nil, "BACKGROUND")
AS_Frame.texture:SetTexture("Interface\\FullScreenTextures\\LowHealth")
AS_Frame.texture:SetAllPoints(UIParent)
AS_Frame.texture:SetBlendMode("ADD")

AS_AlertFrame:SetWidth(UIParent:GetWidth())
AS_AlertFrame:SetHeight(32)
AS_AlertFrame:SetInsertMode("TOP")
AS_AlertFrame:SetFrameStrata("HIGH")
AS_AlertFrame:SetTimeVisible(1.5)
AS_AlertFrame:SetFadeDuration(1)
AS_AlertFrame:SetFont(STANDARD_TEXT_FONT, 26, "OUTLINE")
AS_AlertFrame:SetPoint("CENTER", 0, 210)


AS_Frame:RegisterEvent("VARIABLES_LOADED")
AS_Frame:RegisterEvent("UNIT_TARGET")
AS_Frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
AS_Frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
AS_Frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
AS_Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
AS_Frame:RegisterEvent("PARTY_MEMBER_DISABLE")
AS_Frame:RegisterEvent("PLAYER_DEAD")