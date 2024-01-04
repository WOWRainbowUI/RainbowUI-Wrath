local Addon = CreateFrame("FRAME");
local addonName, addonTable = ...;
local L = addonTable["Locale"];
local letterBox;
local factorTextSpeed = 1;
local blizzardFont;
local timer = CreateFrame("FRAME");

-- 備份鏡頭參數
local CVar_Temp_ActioncamState		--No CVar directly shows the current state of ActionCam. Check this CVar for the moment. 1~On  2~Off
local Temp_CameraZoomLevel

local function createTimer(after, func)
	local total = 0;
	timer:SetScript("OnUpdate", function(self, elapsed)
		total = total + elapsed;
		if(total > after) then
			self:SetScript("OnUpdate", nil);
			func();
		end
	end);
end


local incombat = UnitAffectingCombat("player") 
local EventFrame = CreateFrame("Frame") 
EventFrame:RegisterEvent("PLAYER_REGEN_ENABLED") 
EventFrame:RegisterEvent("PLAYER_REGEN_DISABLED") 
EventFrame:SetScript("OnEvent", function(_, event, ...) 
    incombat = (event == "PLAYER_REGEN_DISABLED") 
    if (incombat) then 
    securecall("CloseAllWindows");
	letterBox:Hide();
	UIParent:Show();
    else 
    end 
end)

local function cancelTimer()
	timer:SetScript("OnUpdate", nil);
end

local function splitText(text)
	local tableLines, nextLine = {};
	while string.find(text,"\n") do
		nextLine = string.sub(text,0, string.find(text, "\n"));
		if not (strtrim(nextLine) == "") then
			table.insert(tableLines, nextLine);
		end
		text = string.sub(text, string.find(text, "\n")+1, -1);
	end
	if not (strtrim(text) == "") then
		table.insert(tableLines, string.sub(text, 0, string.find(text, "\n")));
	end
	return tableLines;
end

local function createButton(name, parent, text, onClickFunc)
	local buttonFrame = CreateFrame("FRAME", name, parent);
	buttonFrame:SetSize(200,50);
	buttonFrame.fontString = buttonFrame:CreateFontString();
	buttonFrame.fontString:SetFont(blizzardFont, 20, "OUTLINE");
	buttonFrame.fontString:SetText(text);
	buttonFrame.fontString:SetTextColor(0.45, 0.45, 0.45, 1);
	buttonFrame.fontString:SetPoint("CENTER");
	buttonFrame:EnableMouse(true);
	buttonFrame:SetScript("OnMouseUp", onClickFunc);
	buttonFrame:SetScript("OnEnter", function(self)
		self.fontString:SetTextColor(1.0, 0.75, 0.0, 1);
	end);
	buttonFrame:SetScript("OnLeave", function(self)
		self.fontString:SetTextColor(0.45, 0.45, 0.45, 1);
	end);
	
	buttonFrame:SetScript("OnShow", function(self)
		UIFrameFadeIn(self, 0.5, 0, 1);
	end);
	
	buttonFrame:Hide();
	return buttonFrame;
end

local animationFrame, isAnimating = CreateFrame("FRAME");
local function animateText(fontString)
	local total, numChars, totalSfx = 0, 0, 0;
	fontString:SetAlphaGradient(0,20);
	isAnimating = true;
	animationFrame:SetScript("OnUpdate", function(self, elapsed)
		total = total + elapsed;
		fontString:SetAlphaGradient(numChars,20);
		if(total > 0.02) then
			total = 0;
			numChars = numChars + factorTextSpeed;
			if(numChars >= string.len(fontString:GetText() or "")) then
				isAnimating = false;
				self:SetScript("OnUpdate", nil);
			end
		end
	end);
end

local function isTextAnimating()
	return isAnimating;
end

local blizz_SetView = SetView;
local currentView = -1;
local function SetView(view)
	if (not QuestCSV[UnitName("player")]["CameraEnabled"]) then
		return;
	end
	-- 備份鏡頭距離
	if currentView == -1 then
		Temp_CameraZoomLevel = GetCameraZoom()
	end
	if not (view == currentView) then
		currentView = view;
		blizz_SetView(view);
		if(QuestCSV[UnitName("player")]["ActionCamEnabled"]) then
			--[[
			if(view == -1) then
				ConsoleExec("ActionCam off");
			else
				ConsoleExec("ActionCam full");
			end
			--]]
			-- 還原鏡頭距離
			if view == -1 then
				CameraZoomOut(Temp_CameraZoomLevel-GetCameraZoom())
			end
			-- 還原 ActionCam
			if view == -1 and CVar_Temp_ActioncamState ~= 1 then		--Restore the acioncam state
				SetCVar("test_cameraDynamicPitch", 0)
				-- ConsoleExec( "ActionCam off" )
			end
			
		end
	end
end

local frameFader = CreateFrame("FRAME");
local function hideLetterBox()
	if(not letterBox:IsShown()) then
		return;
	end
	local alpha = UIParent:GetAlpha();
	MinimapCluster:Show();
	Minimap:Show();
	frameFader:SetScript("OnUpdate", function(self, elapsed)
		if(alpha < 1) then
			alpha = alpha + 0.05;
			if alpha > 1 then alpha = 1 end
			UIParent:SetAlpha(alpha);
		else
			frameFader:SetScript("OnUpdate", nil);
		end
	
	end);
	
	QCDressUpModel:Hide();
	QCHelpFrame:Hide();
	local alpha = letterBox:GetAlpha();
	letterBox:SetScript("OnUpdate", function(self, elapsed)
		letterBox:SetAlpha(alpha);
		alpha = alpha - 0.05;
		if(alpha < 0) then
			letterBox:SetScript("OnUpdate", nil);
			letterBox:Hide();
		end
	end);

	letterBox:EnableKeyboard(false);
end

local function showLetterBox()
	if(IsModifierKeyDown() or not QuestFrame:IsShown()) then
		return;
	end
	
	frameFader:SetScript("OnUpdate", nil);
	UIParent:SetAlpha(0);
	MinimapCluster:Hide();
	Minimap:Hide();
	local alpha = letterBox:GetAlpha();
	letterBox:Show();
	letterBox:SetScript("OnUpdate", function(self, elapsed)
		letterBox:SetAlpha(alpha);
		alpha = alpha + 0.05;
		if(alpha > 1) then
			self:SetScript("OnUpdate", nil);
		end
	end);
	letterBox.selectedButton = nil;
	letterBox:EnableKeyboard(true);
end

local function startInteraction()
	letterBox.acceptButton:Hide();
	letterBox.declineButton:Hide();
	letterBox.choicePanel:Hide();
	letterBox.rewardPanel:Hide();
	letterBox.text = splitText(letterBox.text);
	letterBox.textIndex = 1;
	letterBox.questText:SetText(letterBox.text[letterBox.textIndex]);
	
	animateText(letterBox.questText);
end

local function setUpQuestChoicePanel()
	QCChoicePanel.textureLeft:SetAlpha(0);
	QCChoicePanel.textureRight:SetAlpha(0);
	QCChoicePanel.title:SetFont(blizzardFont, 18, "OUTLINE");
	QCChoicePanel.title:SetText(L.REWARD);
	
	for i=1, 10 do
		CreateFrame("BUTTON", "QCChoicePanelItem"..i, QCChoicePanel, "QCItemButtonTemplate");
	end
	
end


local function setUpQuestRewardPanel()
	-- QCRewardPanel.title:SetFont(blizzardFont, 18, "OUTLINE");
	-- QCRewardPanel.title:SetText(L.CONGRAT);

	for i=1, 5 do
		local btn = CreateFrame("BUTTON", "QCRewardPanelItem"..i, QCRewardPanel, "QCItemButtonTemplate");
		btn.type = "reward";
	end
end

local function onClickKey(self)

	if(not isTextAnimating() and QCQuestTitleFrame:IsShown() and not QCQuestTitleFrame.hideAnim:IsPlaying()) then
		QCQuestTitleFrame.hideAnim:Play();
	end
	
	if(not isTextAnimating() and (self.textIndex == #self.text or #self.text == 0)) then
	
		if(self.acceptButton.fontString:GetText() == L.CONTINUE) then
			if(IsQuestCompletable()) then
				self.acceptButton:Show();
			else
				self.acceptButton:Hide();
			end
		else
			self.acceptButton:Show();
		end

		if(self.acceptButton.fontString:GetText() == L.THANK_YOU and (self.textIndex == #self.text or #self.text == 0)) then
			if(GetNumQuestChoices() > 1 and	not self.choicePanel:IsShown()) then
				UIFrameFadeIn(self.choicePanel, 0.5, 0, 1);
			end
			if((GetNumQuestRewards() > 0 or GetNumQuestChoices() == 1) and not self.rewardPanel:IsShown()) then
				UIFrameFadeIn(self.rewardPanel, 0.5, 0, 1);
			end
		end
		-- DoEmote("ponder")
		self.declineButton:Show();
           

		
		if(self.questText:GetText()) then
			self.questText:SetText("");
				end

		local screenHeight = GetScreenHeight()*UIParent:GetEffectiveScale();
		if(self.acceptButton:IsShown()) then
			self.acceptButton:SetPoint("BOTTOM", 100, screenHeight/42);
			self.declineButton:SetPoint("BOTTOM", -100, screenHeight/42);
		else
			self.declineButton:SetPoint("BOTTOM", 0, screenHeight/42);
		end
		
		
		return;
	end
	if(isTextAnimating()) then
		self.questText:SetAlphaGradient(string.len(self.questText:GetText()),1);
		isAnimating = false;
		animationFrame:SetScript("OnUpdate", nil);
	else
		self.textIndex = self.textIndex + 1;
		self.questText:SetText(self.text[self.textIndex]);
		animateText(self.questText);
	end
end

local function setUpLetterBox()
	local screenWidth = GetScreenWidth()*UIParent:GetEffectiveScale();
	local screenHeight = GetScreenHeight()*UIParent:GetEffectiveScale();

	letterBox = QuestC; --CreateFrame("FRAME", "QuestC", nil);
	letterBox:SetAllPoints();

	letterBox.bottomPanel:SetSize(screenWidth, screenHeight/9);

	letterBox.questText:SetSize(screenWidth*0.75, screenHeight/9);
	letterBox.questText:SetFont(blizzardFont, 20, "OUTLINE");

	setUpQuestChoicePanel();
	setUpQuestRewardPanel();
	-- 暫時修正按鈕翻譯
	letterBox.acceptButton = createButton("QCacceptButton", letterBox, L.ACCEPT, function(self, button)
		QuestDetailAcceptButton_OnClick();
	end);

	letterBox.declineButton = createButton("QCdeclineButton", letterBox, L.DECLINE, function(self, button)
		QuestDetailDeclineButton_OnClick();
	end);
	
	
	letterBox:EnableMouse(true);
	letterBox:SetScript("OnMouseUp", function(self, button)
		onClickKey(self);
	end);
	
	letterBox:SetScript("OnKeyUp", function(self, key)
	-- 加上支援搖桿按鈕
		if(key == "SPACE" or key == "F11") then
			-- 預設為接受
			if( not self.selectedButton) then
				self.acceptButton.fontString:SetTextColor(1, 1, 1, 1);
				self.declineButton.fontString:SetTextColor(0.45, 0.45, 0.45, 1);
			end
			if( not self.selectedButton and self.acceptButton:IsShown()) then
				self.selectedButton = self.acceptButton;
			elseif( not self.selectedButton and self.declineButton:IsShown()) then
				self.declineButton.fontString:SetTextColor(1, 1, 1, 1);
				self.acceptButton.fontString:SetTextColor(0.45, 0.45, 0.45, 1);
				self.selectedButton = self.declineButton;
			elseif(self.selectedButton and (self.selectedButton == self.acceptButton or self.selectedButton == self.declineButton)) then
				onClickKey(self);
			end
			
			if(self.selectedButton and (self.acceptButton:IsShown() or self.declineButton:IsShown())) then
				self.selectedButton:GetScript("OnMouseUp")();
			else
				onClickKey(self);
			end
		elseif(key == "ESCAPE" or key == "F10" or key == "F6") then
			securecall("CloseAllWindows");
			animationFrame:SetScript("OnUpdate", nil);
		elseif((key == "D" or key == "F2") and self.acceptButton:IsShown()) then
			self.selectedButton = self.acceptButton;
			self.acceptButton.fontString:SetTextColor(1, 1, 1, 1);
			self.declineButton.fontString:SetTextColor(0.45, 0.45, 0.45, 1);
		elseif((key == "A" or key == "F4")and self.declineButton:IsShown()) then
			self.selectedButton = self.declineButton;
			self.declineButton.fontString:SetTextColor(1, 1, 1, 1);
			self.acceptButton.fontString:SetTextColor(0.45, 0.45, 0.45, 1);
		elseif(key == "F12") then
			Screenshot();
		end

	end);
	
	letterBox:SetScript("OnHide", function(self)
		QCQuestTitleFrame:Hide();
	end);
	
	letterBox:Hide();
end

local function loadSavedVariables()
	if(not QuestCSV) then
	     QuestCSV = {};
	     QuestCSV[UnitName("player")] = {};
	     QuestCSV[UnitName("player")]["FactorTextSpeed"] = 1;
	     QuestCSV[UnitName("player")]["ActionCamEnabled"] = 1;
	     QuestCSV[UnitName("player")]["CameraEnabled"] = 1;
	elseif(QuestC[UnitName("player")]) then
		factorTextSpeed = QuestCSV[UnitName("player")]["FactorTextSpeed"];
		questSoundEnabled = QuestCSV[UnitName("player")]["QuestSoundEnabled"];
	else
	      QuestCSV[UnitName("player")] = {};
	      QuestCSV[UnitName("player")]["FactorTextSpeed"] = 1;
	      QuestCSV[UnitName("player")]["ActionCamEnabled"] = 1;
	      QuestCSV[UnitName("player")]["CameraEnabled"] = 1;

	end
end


local localeFonts = {
	["zhCN"] = "Fonts\\ARKai_T.TTF",
	["ruRU"] = "Fonts\\FRIZQT___CYR.TTF",
	["zhTW"] = "Fonts\\bLEI00D.TTF",
	["koKR"] = "Fonts\\2002.TTF",
}


local function onPlayerLogin()
	blizzardFont = localeFonts[GetLocale()] or STANDARD_TEXT_FONT;

	setUpLetterBox();
	loadSavedVariables();
	
	-- 備份鏡頭參數
	C_Timer.After(10, function()
		CVar_Temp_ActioncamState = tonumber(GetCVar("test_cameraDynamicPitch"));
		Temp_CameraZoomLevel = GetCameraZoom()
	end)
	
	if(QuestCSV[UnitName("player")]["SaveView"]) then
		SaveView(2);
	end
	
	if(IsAddOnLoaded("ElvUI")) then
		MMHolder:SetParent(ElvUIParent);
	end
	
	Addon:RegisterEvent("GOSSIP_SHOW");
	Addon:RegisterEvent("MERCHANT_SHOW");
	Addon:RegisterEvent("TRAINER_SHOW");
	Addon:RegisterEvent("TAXIMAP_OPENED");
	Addon:RegisterEvent("GOSSIP_CLOSED");
	Addon:RegisterEvent("MERCHANT_CLOSED");
	Addon:RegisterEvent("TRAINER_CLOSED");
	Addon:RegisterEvent("TAXIMAP_CLOSED");
	Addon:RegisterEvent("QUEST_GREETING");
	Addon:RegisterEvent("QUEST_DETAIL");
	Addon:RegisterEvent("QUEST_PROGRESS");
	Addon:RegisterEvent("QUEST_COMPLETE");
	Addon:RegisterEvent("QUEST_FINISHED");
	Addon:RegisterEvent("QUEST_TURNED_IN");
	
	UIParent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED");
end

local function onQuestDetail(questStartItemID)
	if (questStartItemID and questStartItemID ~= 0) then
		return;
	end
	
	cancelTimer();
	SetView(2);
	
	letterBox.text = GetQuestText();
	letterBox.acceptButton.fontString:SetText(L.ACCEPT);
	letterBox.acceptButton:SetScript("OnMouseUp", function() QuestDetailAcceptButton_OnClick(); hideLetterBox(); end);
	letterBox.declineButton.fontString:SetText(L.DECLINE);
	letterBox.declineButton:SetScript("OnMouseUp", QuestDetailDeclineButton_OnClick);
	QCQuestTitleFrame.levelFrame.questText:SetText(GetTitleText());

	QCQuestTitleFrame:Show();
	showLetterBox();
	
	startInteraction();
end


local function onQuestProgress()
	cancelTimer();
	SetView(2);
	letterBox.text = GetProgressText();
	letterBox.acceptButton.fontString:SetText(L.CONTINUE);
	letterBox.acceptButton:SetScript("OnMouseUp", QuestProgressCompleteButton_OnClick);
	
	letterBox.declineButton.fontString:SetText(L.GOODBYE);
	
	QCQuestTitleFrame.levelFrame.questText:SetText(GetTitleText());
	QCQuestTitleFrame:Show();
	
	showLetterBox();
	
	startInteraction();
end


local function onQuestComplete()
	cancelTimer();
	SetView(2);
	if(not letterBox:IsShown()) then
		QCQuestTitleFrame.levelFrame.questText:SetText(GetTitleText());
		QCQuestTitleFrame:Show();
	
		showLetterBox();
	end
	
	letterBox.text = GetRewardText();
	
	startInteraction();
	
	local money = GetQuestMoneyToGet();
	if ( money and money > 0 ) then
		letterBox.acceptButton.fontString:SetText(L.GIVE .. GetCoinTextureString(money));
	else
		letterBox.acceptButton.fontString:SetText(L.THANK_YOU);
	end
	letterBox.acceptButton:SetScript("OnMouseUp", function(self, button)
		if(QuestInfoFrame.itemChoice == 0 and GetNumQuestChoices() > 1 ) then
			UIFrameFlash(letterBox.choicePanel, 0.5, 0.5, 1.5, true, 0, 0);
		else
			if(money and money > 0) then
				GetQuestReward(QuestInfoFrame.itemChoice);
			else
				QuestRewardCompleteButton_OnClick();
			end
		end
	end);
	
	letterBox.declineButton:Hide();
	
	if(GetNumQuestChoices() > 1) then
		--show icons of quests rewards
		for i=1, GetNumQuestChoices() do
			local btn = _G["QCChoicePanelItem"..i];


			local name, texture, numItems, quality, isUsable = GetQuestItemInfo(btn.type, i);

			SetItemButtonTexture(btn, texture);
			_G[btn:GetName().."IconTexture"]:SetVertexColor(0.35,0.35,0.35,1.0);

			btn:SetPoint("CENTER", (i-1)*64-(GetNumQuestChoices()/2*64)+32, -12);

			btn:SetID(i);
			btn:Show();
		end

		for i=GetNumQuestChoices()+1, 10 do
			_G["QCChoicePanelItem"..i]:Hide();
		end
	else
		letterBox.choicePanel:Hide();
	end

	if(GetNumQuestRewards() > 0 or GetNumQuestChoices() == 1) then
		if(GetNumQuestChoices() == 1) then
			local btn = _G["QCRewardPanelItem1"];
			btn.type = "choice";

			local name, texture, numItems, quality, isUsable = GetQuestItemInfo(btn.type, 1);

			SetItemButtonTexture(btn, texture);

			btn:SetPoint("CENTER", 50, -(GetNumQuestRewards()/2*32));

			btn:SetID(1);
			btn:Show();
			
			for i=1, GetNumQuestRewards() do
				local btn = _G["QCRewardPanelItem"..i+1];
				btn.type = "reward";

				local name, texture, numItems, quality, isUsable = GetQuestItemInfo(btn.type, i);

				SetItemButtonTexture(btn, texture);

				btn:SetPoint("CENTER", 50, (i+1-1)*64-(GetNumQuestRewards()/2*32));

				btn:SetID(i);
				btn:Show();				
			end
		else
			for i=1, GetNumQuestRewards() do
				local btn = _G["QCRewardPanelItem"..i];
				btn.type = "reward";

				local name, texture, numItems, quality, isUsable = GetQuestItemInfo(btn.type, i);

				SetItemButtonTexture(btn, texture);

				btn:SetPoint("CENTER", 50, (i-1)*64-(GetNumQuestRewards()/2*32));

				btn:SetID(i);
				btn:Show();
			end
		end
		
		local i = GetNumQuestRewards();
		if(GetNumQuestChoices() == 1) then
			i = i + 1;
		end
		
		letterBox.rewardPanel:SetWidth(32*i + 128);
		
		while(i < 5) do
			i = i + 1;
			_G["QCRewardPanelItem"..i]:Hide();
		end
	else
		letterBox.rewardPanel:Hide();
	end
end


local function onQuestTurnedIn()
	if(timer:GetScript("OnUpdate")) then
		return;
	end
	letterBox.rewardPanel:Hide();
	createTimer(0.5, function()
		hideLetterBox();
		SetView(-1);
	end);
end


Addon.scripts = {
	["PLAYER_LOGIN"] = onPlayerLogin,
	["QUEST_DETAIL"] = onQuestDetail,
	["QUEST_PROGRESS"] = onQuestProgress,
	["QUEST_COMPLETE"] = onQuestComplete,
	["QUEST_TURNED_IN"] = onQuestTurnedIn,
};


Addon:SetScript("OnEvent", function(self, event, ...)
	if(Addon.scripts[event]) then
		Addon.scripts[event](...);
	elseif(event == "GOSSIP_CLOSED" or event == "MERCHANT_CLOSED" or event == "TRAINER_CLOSED" or event == "QUEST_FINISHED" or event == "TAXIMAP_CLOSED") then
		letterBox.rewardPanel:Hide();
		
		createTimer(0.05, function()
			hideLetterBox();
			SetView(-1);
                -- DoEmote("nod")

		end);
	elseif(event == "MERCHANT_SHOW" or event == "TRAINER_SHOW" or event == "TAXIMAP_OPENED") then
		cancelTimer();
	end
end);

local frameFadeManager = CreateFrame("FRAME");
local queueFrame = {};
local size = 0;
local GetTime = GetTime;

function frameFade(frame, duration, startAlpha, endAlpha, hideEnd)

	if(size > 0) then
		if(not queueFrame[frame]) then
			size = size + 1;
		end
		queueFrame[frame] = { GetTime(), GetTime()+duration, duration, startAlpha, endAlpha, hideEnd};
		frame:SetAlpha(startAlpha);
		if(not frame:IsProtected()) then
			frame:Show();
		end
		return;
	end
	
	local currentTime, newAlpha;
	
	size = 1;
	queueFrame[frame] = { GetTime(), GetTime()+duration, duration, startAlpha, endAlpha, hideEnd};
	if(not frame:IsProtected()) then
		frame:Show();
	end
	
	frameFadeManager:SetScript("OnUpdate", function(self, elapsed)
		currentTime = GetTime();
		for frame, animationInfo in pairs(queueFrame) do
			local startTime, endTime, duration, startAlpha, endAlpha, hideEnd = unpack(animationInfo);
			
			local timeElapsed = currentTime - startTime;
			newAlpha = endAlpha*(timeElapsed/duration) + startAlpha*((endTime - currentTime)/duration);
			
			frame:SetAlpha(newAlpha);
			
			if(currentTime > endTime) then
				frame:SetAlpha(endAlpha);
				if(hideEnd and not frame:IsProtected()) then
					frame:Hide();
					frame:SetAlpha(1);
				end
				queueFrame[frame] = nil;
				size = size - 1;
				if(size == 0) then
					self:SetScript("OnUpdate", nil);
				end
			end
		end	
	end);
	
end

function cancelFade(frame)
	queueFrame[frame] = nil;
end

function isFrameFading(frame)
	return queueFrame[frame];
end

function QC_GameTooltip_ShowCompareItem(self, shift)
	GameTooltip_ShowCompareItem(self,shift);

	local shoppingTooltip1, shoppingTooltip2 = unpack(self.shoppingTooltips);
	if(QuestC:IsShown() and shoppingTooltip2:IsShown()) then
		
		local item, link = self:GetItem();
		
		local side = "left";
		local rightDist = 0;
		local leftPos = self:GetLeft();
		local rightPos = self:GetRight();
		if ( not rightPos ) then
			rightPos = 0;
		end
		if ( not leftPos ) then
			leftPos = 0;
		end
	
		rightDist = GetScreenWidth() - rightPos;
	
		if (leftPos and (rightDist < leftPos)) then
			side = "left";
		else
			side = "right";
		end
		
		shoppingTooltip1:SetOwner(self, "ANCHOR_NONE");
		shoppingTooltip1:ClearAllPoints();
		
		if ( side and side == "left" ) then
			shoppingTooltip1:SetPoint("TOPRIGHT", self, "TOPLEFT", 0, -10);
		else
			shoppingTooltip1:SetPoint("TOPLEFT", self, "TOPRIGHT", 0, -10);
		end
		shoppingTooltip1:SetHyperlinkCompareItem(link, 1, shift, self);
		shoppingTooltip1:Show();
		
		shoppingTooltip2:SetOwner(shoppingTooltip1, "ANCHOR_TOP");
		shoppingTooltip2:SetHyperlinkCompareItem(link, 2, shift, self);
		shoppingTooltip2:Show();
	end
	
end

function QC_DressUpItemLink(link)
	if ( not link or not IsDressableItem(link) ) then
		return;
	end
	
	if ( not QCDressUpModel:IsShown() ) then
		QCDressUpModel:Show();
		QCDressUpModel:SetUnit("player");
	end
	
	QCDressUpModel:TryOn(link);
end

Addon:RegisterEvent("PLAYER_LOGIN");