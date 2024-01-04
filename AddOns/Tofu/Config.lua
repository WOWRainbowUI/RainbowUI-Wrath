local addonName, addonTable = ...;
local L = addonTable["Locale"];

function QCConfigMenuButton_OnClick(self, button)
	for num, button in pairs(self:GetParent().menuButtonsTable) do
		button:Enable();
	end
	PlaySound(856);
	self:Disable();
	
	self.func();
end

function QCConfigCheckButton_OnClick(self, button)
	if(self:GetChecked()) then
		self.text:SetTextColor(1.0, 0.75, 0.0, 0.8);
	else
		self.text:SetTextColor(1, 0, 0, 0.8);
	end
	PlaySound(856);
	self.func(self:GetChecked());
end


function QCConfig_OnLoad(self)
	
	self.menuButtonsTable = {
		self.cameraMenuButton,
	};
end

function QCConfig_OnShow()
	
	local menu = QCConfigCameraMenu;
menu.toggleActionCam:SetChecked(TSV[UnitName("player")]["ActionCamEnabled"]);
	if(TSV[UnitName("player")]["ActionCamEnabled"]) then
		menu.toggleActionCam.text:SetTextColor(1.0, 0.75, 0.0, 8.0);
	else
		menu.toggleActionCam.text:SetTextColor(1, 0, 0, 0.8);
	end
end

function QCConfigCameraMenuToggleActionCam_OnLoad(self)
	self.text:SetText(L.ENABLE_ACTION_CAM);
	self.tooltipText = L.ENABLE_ACTION_CAM_TOOLTIP;

	self.func = function(newValue)
	    TSV[UnitName("player")]["CameraEnabled"] = newValue;
		TSV[UnitName("player")]["ActionCamEnabled"] = newValue;
	end
end


	L = {
		ENABLE_ACTION_CAM = "QuestCam",
		ENABLE_ACTION_CAM_TOOLTIP = "Uses Blizzard's 'ActionCam' feature to give a better view.\n\nWarning: Don't use it if you are already playing with it.",
	};


addonTable["Locale"] = L;