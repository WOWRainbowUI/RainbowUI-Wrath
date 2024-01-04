local Addon = CreateFrame("FRAME");
local addonName, addonTable = ...;
local L = addonTable["Locale"];
local letterBox;
local factorTextSpeed = 4;
local blizzardFont;
local timer = CreateFrame("FRAME");
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

-- print("TOFU: /tofu to open config menu")

local function getPlayerColors()
    local c = RAID_CLASS_COLORS[select(2,UnitClass("player"))]
    return c.r, c.g, c.b
end

PlayerName:SetTextColor(getPlayerColors())

local incombat = UnitAffectingCombat("player") 
local EventFrame = CreateFrame("Frame") 
EventFrame:RegisterEvent("PLAYER_REGEN_ENABLED") 
EventFrame:RegisterEvent("PLAYER_REGEN_DISABLED") 
EventFrame:SetScript("OnEvent", function(_, event, ...) 
    incombat = (event == "PLAYER_REGEN_DISABLED") 
    if (incombat) then 
	securecall("CloseAllWindows");
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
	buttonFrame:SetSize(100,100);
	buttonFrame.fontString = buttonFrame:CreateFontString();
	buttonFrame.fontString:SetFont(Symbols, 70);
	buttonFrame.fontString:SetText(text);
	buttonFrame.fontString:SetTextColor(0, 0, 0, 0.8);
	buttonFrame.fontString:SetPoint("CENTER");
	buttonFrame:EnableMouse(true);
	buttonFrame:SetScript("OnMouseUp", onClickFunc);
	buttonFrame:SetScript("OnEnter", function(self)
		self.fontString:SetTextColor(getPlayerColors());
			buttonFrame.fontString:SetAlpha(0.8);
	end);
	buttonFrame:SetScript("OnLeave", function(self)
		self.fontString:SetTextColor(0, 0, 0, 0.8);
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
	PlaySound(3093);
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
	if (not TSV[UnitName("player")]["CameraEnabled"]) then
		return;
	end
		if(TSV[UnitName("player")]["ActionCamEnabled"]) then
			if(view == -1) then
				ConsoleExec("ActionCam off");
			else
				ConsoleExec("ActionCam full");
			end
		end
	end

local frameFader = CreateFrame("FRAME");
local function hideLetterBox()
	if(not letterBox:IsShown()) then
		return;
	end
local alpha = UIParent:GetAlpha();
    QuestFrame:SetAlpha(1);
	QCQuestTitleFrame3:Hide();
	frameFader:SetScript("OnUpdate", function(self, elapsed)
		if(alpha < 1) then
			alpha = alpha + 0.05;
			UIParent:SetAlpha(alpha);
		else
			frameFader:SetScript("OnUpdate", nil);
		end
	
	end);
	
	QCDressUpModel:Hide();
	QCHelpFrame:Hide();
	QCQuestTitleFrame3:Hide();
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
    QuestFrame:SetAlpha(0);
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
	for i=1, 10 do
		CreateFrame("BUTTON", "QCChoicePanelItem"..i, QCChoicePanel, "QCItemButtonTemplate");
	end	
end



local function setUpQuestRewardPanel()
	QCRewardPanel.title:SetFont(blizzardFont, 18, "OUTLINE");
	QCRewardPanel.title:SetText("Congratulations!");

	for i=1, 5 do
		local btn = CreateFrame("BUTTON", "QCRewardPanelItem"..i, QCRewardPanel, "QCItemButtonTemplate");
		btn.type = "reward";
	end
end

local function onClickKey(self)

	if(not isTextAnimating() and QCQuestTitleFrame2:IsShown() and not QCQuestTitleFrame2.hideAnim:IsPlaying()) then
		QCQuestTitleFrame2.hideAnim:Play();
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
		self.declineButton:Show();
           
		
		if(self.questText:GetText()) then
			self.questText:SetText("");
				end

		local screenHeight = GetScreenHeight()*UIParent:GetEffectiveScale();
		if(self.acceptButton:IsShown()) then
			QCQuestTitleFrame3:Show();
			self.acceptButton:SetPoint("BOTTOM", 125, 102);
		else
			self.declineButton:SetPoint("BOTTOM", 125, 102);
			QCQuestTitleFrame3:Show();
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

	letterBox = QuestC;
	letterBox:SetAllPoints();

	letterBox.bottomPanel:SetSize(screenWidth, screenHeight/10);

	letterBox.questText:SetSize(screenWidth*0.23, screenHeight/4.2);
	letterBox.questText:SetFont(blizzardFont, 12); -- 任務內容文字大小
	letterBox.questText:SetAlpha(0.9)
	letterBox.questText:SetPoint("CENTER", 0, screenHeight/65); -- 任務內容文字位置
	letterBox.questText:SetJustifyH("LEFT");
	letterBox.questText:SetJustifyV("TOP");
	
	QCQuestTitleFrame:ClearAllPoints();
	QCQuestTitleFrame:SetPoint("BOTTOMLEFT", letterBox.questText, "TOPLEFT", 0, 6); -- 名字文字位置
	
local model = CreateFrame("PlayerModel", QCP2, QCQuestTitleFrame3)
model:SetSize(310, 85)
model:SetPoint("CENTER", QCQuestTitleFrame3, "CENTER", -50, -45)
model:SetUnit("player")
model:SetAlpha(0.1);
model:SetPortraitZoom(0.95);
model:SetPosition(-0.2,0.1,0);
model:SetScript("OnAnimFinished", function() model:SetAnimation(60); end);
model:RefreshCamera()
model:Show()
	

	setUpQuestChoicePanel();
	setUpQuestRewardPanel();
	
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
			if( not self.selectedButton and self.acceptButton:IsShown()) then
				self.selectedButton = self.acceptButton;
			elseif( not self.selectedButton and self.declineButton:IsShown()) then
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
			elseif(key == "F12") then
			Screenshot();
		end

	end);
	
	-- 支援遊戲原生搖桿
	letterBox:SetScript("OnGamePadButtonDown", function(self, key)
		if key == "PAD1" then
			-- 預設為接受
			if( not self.selectedButton and self.acceptButton:IsShown()) then
				self.selectedButton = self.acceptButton;
			elseif( not self.selectedButton and self.declineButton:IsShown()) then
				self.selectedButton = self.declineButton;
			elseif(self.selectedButton and (self.selectedButton == self.acceptButton or self.selectedButton == self.declineButton)) then
				onClickKey(self);
			end
			
			if(self.selectedButton and (self.acceptButton:IsShown() or self.declineButton:IsShown())) then
				self.selectedButton:GetScript("OnMouseUp")();
			else
				onClickKey(self);
			end
		elseif key == "PAD2" or key == "PADFORWARD" then
			securecall("CloseAllWindows");
			animationFrame:SetScript("OnUpdate", nil);
		end

	end);
	
	letterBox:SetScript("OnHide", function(self)
		QCQuestTitleFrame2:Hide();
		QCQuestTitleFrame3:Hide();
	end);
	
	letterBox:Hide();
end

local function loadSavedVariables()
	if(not TSV) then
		TSV = {};
		TSV[UnitName("player")] = {};
	elseif(TSV[UnitName("player")]) then
	else
		TSV[UnitName("player")] = {};
	end
end

local localeFonts = {
	["zhCN"] = "Fonts\\ARKai_T.TTF",
	["ruRU"] = "Fonts\\FRIZQT___CYR.TTF",
	["zhTW"] = "Fonts\\bHEI01B.TTF",
	["koKR"] = "Fonts\\2002.TTF",
}

Symbols = "Interface\\AddOns\\Tofu\\Font\\WebSymbols-Regular.otf"; 

local function onPlayerLogin()
	blizzardFont = localeFonts[GetLocale()] or STANDARD_TEXT_FONT;

    loadSavedVariables();
	setUpLetterBox();
	
	if(TSV[UnitName("player")]["SaveView"]) then
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
	QCQuestTitleFrame.levelFrame.questText:SetText(UnitName("NPC"));
    QCQuestTitleFrame:Show();
	QCQuestTitleFrame2.levelFrame.questText:SetText(GetTitleText());
	QCQuestTitleFrame2:Show();
	QCQuestTitleFrame3:Hide();
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
	
	QCQuestTitleFrame.levelFrame.questText:SetText(UnitName("NPC"));
	QCQuestTitleFrame:Show();
	QCQuestTitleFrame2.levelFrame.questText:SetText(GetTitleText());
	QCQuestTitleFrame2:Show();
	QCQuestTitleFrame3:Hide();
	
	showLetterBox();
	
	startInteraction();
end


local function onQuestComplete()
      cancelTimer();
      SetView(2);
	if(not letterBox:IsShown()) then
		QCQuestTitleFrame.levelFrame.questText:SetText(UnitName("NPC"));
		QCQuestTitleFrame:Show();
		QCQuestTitleFrame2.levelFrame.questText:SetText(GetTitleText());
	    QCQuestTitleFrame2:Show();
		QCQuestTitleFrame3:Hide();
	
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

SLASH_qc1, SLASH_qc2 = "/q", "/tofu";

local function SlashCmd(cmd)
if(cmd == "" or cmd:match("config")) then
    	if(not QCConfig:IsShown()) then
    		frameFade(QCConfig, 0.25, 0, 1);
    	else
    		frameFade(QCConfig, 0.25, 1, 0, true);
    	end
end
end

SlashCmdList["qc"] = SlashCmd;

Addon:SetScript("OnEvent", function(self, event, ...)
    QCQuestTitleFrame.levelFrame.questText:SetText(UnitName("NPC"));
    QCQuestTitleFrame:Show();
	QCQuestTitleFrame3:Hide();
	QCDressUpModel:Hide();
	if(Addon.scripts[event]) then
		Addon.scripts[event](...);
	elseif(event == "GOSSIP_CLOSED" or event == "MERCHANT_CLOSED" or event == "TRAINER_CLOSED" or event == "QUEST_FINISHED" or event == "TAXIMAP_CLOSED") then
		letterBox.rewardPanel:Hide();
		createTimer(0.05, function()
			hideLetterBox();
			SetView(-1);
		end);
	elseif(event == "MERCHANT_SHOW" or event == "TRAINER_SHOW" or event == "TAXIMAP_OPENED") then
		cancelTimer();
	end
end);


Addon:RegisterEvent("PLAYER_LOGIN");

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
		shoppingTooltip1:Show();
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
	QCQuestTitleFrame3:Hide();
end

L = {
		ACCEPT = "e ",
		DECLINE = " ",
		CONTINUE = "e",
		GOODBYE = " e",
		THANK_YOU = " e ",
		GIVE = ".",
	};


addonTable["Locale"] = L;

Addon:RegisterEvent("PLAYER_LOGIN");
