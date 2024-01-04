--[==[
Copyright ©2019 Samuel Thomas Pain

The contents of this addon, excluding third-party resources, are
copyrighted to their authors with all rights reserved.

This addon is free to use and the authors hereby grants you the following rights:

1. 	You may make modifications to this addon for private use only, you
    	may not publicize any portion of this addon.

2. 	Do not modify the name of this addon, including the addon folders.

3. 	This copyright notice shall be included in all copies or substantial
    	portions of the Software.

All rights not explicitly addressed in this license are reserved by
the copyright holders.
]==]--


--[==[

TODO
add cloak/helm toggles for sets
add info into UI regarding set count etc

]==]--

local _, Wardrobe = ...

local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemID = C_Container.GetContainerItemID
local GetContainerItemLink = C_Container.GetContainerItemLink

Wardrobe.UI = {}
Wardrobe.Vars = { CurrentlyEquippedOutfit = nil, SelectedOutfit = nil, Debug = false, TooltipLineAdded = false, BagSpaceTable = {}, BankBagSpaceTable = {}, EmptyBagSpace = 0 }
Wardrobe.QuickPanelButtons = {}


Wardrobe.EventFrame = CreateFrame("FRAME", "Wardrobe_EventFrame", UIParent)
Wardrobe.EventFrame:RegisterEvent("ADDON_LOADED")
Wardrobe.EventFrame:RegisterEvent("BANKFRAME_OPENED")
Wardrobe.EventFrame:RegisterEvent("BANKFRAME_CLOSED")
Wardrobe.EventFrame:RegisterEvent("PLAYER_LOGOUT")

function Wardrobe.GetArgs(...)
    for i=1, select("#", ...) do
        arg = select(i, ...)
        print(i.." "..tostring(arg))
    end
end

function Wardrobe.MakeFrameMovable(frame)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
end

function Wardrobe.LockFramePos(frame)
	frame:SetMovable(false)
end

function Wardrobe.PrintMessage(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cffFF7D0A裝備管理員: |r"..msg)
end

function Wardrobe.DebugMessage(msg)
    if Wardrobe.Vars.Debug == true then
        DEFAULT_CHAT_FRAME:AddMessage("|cffC41F3BWardrobe DEBUG: |r"..msg)
    end
end



SLASH_WARDROBE1 = '/wardrobe'
SlashCmdList['WARDROBE'] = function(msg)

    if msg == 'help' then
        print('no help!')
        Wardrobe.FixDb()

    elseif msg == 'debug-ON' then
        Wardrobe.Vars.Debug = true
        DEFAULT_CHAT_FRAME:AddMessage("|cffC41F3BWardrobe DEBUG: |r"..'debug is on!')

    elseif msg == 'debug-OFF' then
        Wardrobe.Vars.Debug = false
        DEFAULT_CHAT_FRAME:AddMessage("|cffC41F3BWardrobe DEBUG: |r"..'debug is off!')
        

    elseif string.find(msg, 'equipset-') then
        if WardrobeDb[UnitGUID('player')] ~= nil then
            for k, outfit in ipairs(WardrobeDb[UnitGUID('player')].Outfits) do
                if outfit.Name == string.sub(msg, 10) then
                    Wardrobe.Vars.SelectedOutfit = outfit.Name
                    UIDropDownMenu_SetText(Wardrobe.UI.OutfitFrame.OutfitDropDown, outfit.Name)
                    --Wardrobe.EquipCurrentSet()
                    Wardrobe.IterateSet(outfit.Name)
                end
            end
        end


    end

end

StaticPopupDialogs["Wardrobe_NewOutfit"] = {
	text = "新套裝名稱", button1 = OKAY, button2 = CANCEL,
    hasEditBox = true, EditBoxOnTextChanged = function(self) if self:GetText() ~= '' then self:GetParent().button1:Enable() else self:GetParent().button1:Disable() end end,
	OnShow = function(self) self.editBox:SetText('') self.button1:Disable() end,
	OnAccept = function(self) Wardrobe.CreateNewOutfit(self.editBox:GetText()) end,
	timeout = 0, whileDead = true, hideOnEscape = true,	preferredIndex = 3,
}

StaticPopupDialogs["Wardrobe_CustomIconDialog"] = {
	text = "請輸入你想要使用的圖示材質 fileID\n\n這是可以在 wowhead 找到的 6 位數字", button1 = OKAY, button2 = CANCEL,
    hasEditBox = true, EditBoxOnTextChanged = function(self) if self:GetText() ~= '' then self:GetParent().button1:Enable() else self:GetParent().button1:Disable() end end,
	OnShow = function(self) self.editBox:SetText('') self.button1:Disable() end,
	OnAccept = function(self) Wardrobe.SetIcon(tonumber(self.editBox:GetText())) end,
	timeout = 0, whileDead = true, hideOnEscape = true,	preferredIndex = 3,
}

--tooltip info, uses item ID which is still an issue where a player may have 2 items of the same name but with different random enchants (of the owl, of the boar) i assume the item keeps the same id but would have a different link?
function Wardrobe.OnTooltipSetItem(tooltip, ...)
    local ItemName, ItemLink = GameTooltip:GetItem()
    if ItemLink then
        local setsString = nil
        if WardrobeDb[UnitGUID('player')] ~= nil then
            for k, outfit in ipairs(WardrobeDb[UnitGUID('player')].Outfits) do
                for slot, itemID in pairs(outfit) do
                    local added = false
                    if added == true then break end
                    if slot ~= 'Name' then
                        local id = select(1, GetItemInfoInstant(ItemLink))
                        if id == itemID then
                            if setsString == nil then
                                setsString = outfit.Name
                                added = true
                            else
                                setsString = tostring(setsString..', '..outfit.Name)
                                added = true
                            end
                        end
                    end
                end
            end
        end
        if setsString ~= nil then
            if not Wardrobe.Vars.TooltipLineAdded then
                tooltip:AddLine(' ') --create a line break
                tooltip:AddLine("套裝:", 1.00, 0.49, 0.04)
                tooltip:AddLine(setsString, 1, 1, 1)
                Wardrobe.Vars.TooltipLineAdded = true
            end
        end
    end
end

function Wardrobe.OnTooltipCleared(tooltip, ...)
    Wardrobe.Vars.TooltipLineAdded = false
end

GameTooltip:HookScript("OnTooltipSetItem", Wardrobe.OnTooltipSetItem)
GameTooltip:HookScript("OnTooltipCleared", Wardrobe.OnTooltipCleared)

Wardrobe.UI.OpenWardrobeButton = CreateFrame("BUTTON", "Wardrobe_OpenButton", PaperDollFrame) --, "UIPanelSquareButton") -- "UIPanelButtonTemplate")
Wardrobe.UI.OpenWardrobeButton:SetPoint("TOPRIGHT", -40, -40)
Wardrobe.UI.OpenWardrobeButton:SetSize(35, 30)
Wardrobe.UI.OpenWardrobeButton.Texture = Wardrobe.UI.OpenWardrobeButton:CreateTexture("$parent_Texture", "OVERLAY")
Wardrobe.UI.OpenWardrobeButton.Texture:SetAllPoints(Wardrobe.UI.OpenWardrobeButton)
Wardrobe.UI.OpenWardrobeButton.Texture:SetTexture("interface/paperdollinfoframe/ui-gearmanager-button")
Wardrobe.UI.OpenWardrobeButton:SetScript("OnEnter", function(self) 
	self:SetAlpha(0.85)
	GameTooltip:SetOwner (self, "ANCHOR_RIGHT")
	GameTooltip:SetText ("裝備管理員", nil, nil, nil, nil, true)
	GameTooltip:Show()
end)
Wardrobe.UI.OpenWardrobeButton:SetScript("OnLeave", function(self)
	self:SetAlpha(1.0)
	GameTooltip:Hide()
end)	
Wardrobe.UI.OpenWardrobeButton:SetScript("OnMouseDown", function(self) self.Texture:SetTexture("interface/paperdollinfoframe/ui-gearmanager-button-pushed") end)
Wardrobe.UI.OpenWardrobeButton:SetScript("OnMouseUp", function(self) self.Texture:SetTexture("interface/paperdollinfoframe/ui-gearmanager-button") end)
Wardrobe.UI.OpenWardrobeButton:SetScript("OnClick", function() if Wardrobe.UI.OutfitFrame:IsVisible() then Wardrobe.UI.OutfitFrame:Hide() else Wardrobe.UI.OutfitFrame:Show() end end)

Wardrobe.UI.OutfitFrame = CreateFrame("FRAME", "Wardrobe_Outfitframe", PaperDollFrame, BackdropTemplateMixin and "BackdropTemplate" or nil)
Wardrobe.UI.OutfitFrame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "interface/dialogframe/ui-dialogbox-border", tile = true, tileSize = 16, edgeSize = 20, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
Wardrobe.UI.OutfitFrame:SetBackdropColor(0, 0, 0, 0.9)
Wardrobe.UI.OutfitFrame:SetSize(240, 120) -- 面板大小
Wardrobe.UI.OutfitFrame:SetPoint("BOTTOMRIGHT", Wardrobe.UI.OpenWardrobeButton, "TOPRIGHT", 10, 25)
Wardrobe.UI.OutfitFrame:Hide()

Wardrobe.UI.OutfitFrame.NewOutfitButton = CreateFrame("BUTTON", "Wardrobe_NewOutfitButton", Wardrobe_Outfitframe, "UIPanelButtonTemplate")
Wardrobe.UI.OutfitFrame.NewOutfitButton:SetPoint("TOPLEFT", 10, -10)
Wardrobe.UI.OutfitFrame.NewOutfitButton:SetText('新套裝')
Wardrobe.UI.OutfitFrame.NewOutfitButton:SetSize(70, 22)
Wardrobe.UI.OutfitFrame.NewOutfitButton:SetScript("OnClick", function() StaticPopup_Show("Wardrobe_NewOutfit") end)

Wardrobe.UI.OutfitFrame.SaveCurrentlyEquippedButton = CreateFrame("BUTTON", "Wardrobe_SaveCurrentlyEquippedButton", Wardrobe_Outfitframe, "UIPanelButtonTemplate")
Wardrobe.UI.OutfitFrame.SaveCurrentlyEquippedButton:SetPoint("TOPLEFT", 85, -10)
Wardrobe.UI.OutfitFrame.SaveCurrentlyEquippedButton:SetText('儲存')
Wardrobe.UI.OutfitFrame.SaveCurrentlyEquippedButton:SetSize(70, 22)
Wardrobe.UI.OutfitFrame.SaveCurrentlyEquippedButton:SetScript("OnClick", function() Wardrobe.SaveCurrentOutfit() end)

Wardrobe.UI.OutfitFrame.DeleteCurrentSet = CreateFrame("BUTTON", "Wardrobe_DeleteCurrentSet", Wardrobe_Outfitframe, "UIPanelButtonTemplate")
Wardrobe.UI.OutfitFrame.DeleteCurrentSet:SetPoint("TOPLEFT", 160, -10)
Wardrobe.UI.OutfitFrame.DeleteCurrentSet:SetText('刪除')
Wardrobe.UI.OutfitFrame.DeleteCurrentSet:SetSize(70, 22)
Wardrobe.UI.OutfitFrame.DeleteCurrentSet:SetScript("OnClick", function() Wardrobe.DeleteCurrentSet() end)

Wardrobe.UI.OutfitFrame.EquipCurrentSet = CreateFrame("BUTTON", "Wardrobe_EquipCurrentSet", Wardrobe_Outfitframe, "UIPanelButtonTemplate")
Wardrobe.UI.OutfitFrame.EquipCurrentSet:SetPoint("TOPLEFT", 160, -40)
Wardrobe.UI.OutfitFrame.EquipCurrentSet:SetText('穿上')
Wardrobe.UI.OutfitFrame.EquipCurrentSet:SetSize(70, 22)
Wardrobe.UI.OutfitFrame.EquipCurrentSet:SetScript("OnClick", function() Wardrobe.IterateSet(Wardrobe.Vars.SelectedOutfit) end)

Wardrobe.UI.OutfitFrame.OutfitDropDown = CreateFrame("FRAME", "GHC_PlayerRoleDropdown", Wardrobe_Outfitframe, "UIDropDownMenuTemplate")
Wardrobe.UI.OutfitFrame.OutfitDropDown:SetPoint("TOPLEFT", -5, -40)
Wardrobe.UI.OutfitFrame.OutfitDropDown.displayMode = nil --"MENU"
UIDropDownMenu_SetWidth(Wardrobe.UI.OutfitFrame.OutfitDropDown, 125)
UIDropDownMenu_SetText(Wardrobe.UI.OutfitFrame.OutfitDropDown, '選擇套裝')
function Wardrobe.UI.OutfitFrame.OutfitDropDown_Init()
	UIDropDownMenu_Initialize(Wardrobe.UI.OutfitFrame.OutfitDropDown, function(self, level, menuList)
		local info = UIDropDownMenu_CreateInfo()
        for k, outfit in ipairs(WardrobeDb[UnitGUID('player')].Outfits) do
            info.text = outfit.Name
            info.arg1 = nil
            info.arg2 = nil						
            info.func = function()
                Wardrobe.Vars.SelectedOutfit = outfit.Name
                UIDropDownMenu_SetText(Wardrobe.UI.OutfitFrame.OutfitDropDown, outfit.Name)
                Wardrobe.UpdateOutfitFrame()
                Wardrobe.UpdateQuickPanel()
                --Wardrobe.EquipCurrentSet()
            end
            info.isNotRadio = true
            --info.hasArrow = true
            --info.menuList = class.MenuList
            UIDropDownMenu_AddButton(info)
        end
	end)
end

Wardrobe.UI.HelmCheckbox = CreateFrame("CheckButton", 'WardrobeUIHelmCheckbox', Wardrobe_Outfitframe, "ChatConfigCheckButtonTemplate")
Wardrobe.UI.HelmCheckbox:SetPoint('TOPLEFT', 10, -70)
WardrobeUIHelmCheckboxText:SetText('頭盔')
WardrobeUIHelmCheckboxText:SetSize(50, 20)
Wardrobe.UI.HelmCheckbox:SetScript('OnClick', function(self) ShowHelm(self:GetChecked()) Wardrobe.EditCurrentOutfit(Wardrobe.Vars.SelectedOutfit, 'helm', self:GetChecked()) end)
Wardrobe.UI.HelmCheckbox.tooltip = '這個套裝要顯示頭盔'

Wardrobe.UI.CloakCheckbox = CreateFrame("CheckButton", 'WardrobeUICloakCheckbox', Wardrobe_Outfitframe, "ChatConfigCheckButtonTemplate")
Wardrobe.UI.CloakCheckbox:SetPoint('TOPLEFT', 10, -92)
WardrobeUICloakCheckboxText:SetText('披風')
WardrobeUICloakCheckboxText:SetSize(50, 20)
Wardrobe.UI.CloakCheckbox:SetScript('OnClick', function(self) ShowCloak(self:GetChecked()) Wardrobe.EditCurrentOutfit(Wardrobe.Vars.SelectedOutfit, 'cloak', self:GetChecked()) end)
Wardrobe.UI.CloakCheckbox.tooltip = '這個套裝要顯示披風'

Wardrobe.UI.OutfitIsOnHUDCheckbox = CreateFrame("CheckButton", 'WardrobeUIOutfitIsOnHUDCheckbox', Wardrobe_Outfitframe, "ChatConfigCheckButtonTemplate")
Wardrobe.UI.OutfitIsOnHUDCheckbox:SetPoint('TOPLEFT', 170, -92)
WardrobeUIOutfitIsOnHUDCheckboxText:SetText('按鈕')
WardrobeUIOutfitIsOnHUDCheckboxText:SetSize(120, 40)
Wardrobe.UI.OutfitIsOnHUDCheckbox:SetScript('OnClick', function(self) 
    if not Wardrobe.Vars.SelectedOutfit then return end -- 暫時修正
	Wardrobe.EditCurrentOutfit(Wardrobe.Vars.SelectedOutfit, 'quickPanel', self:GetChecked())
	if self:GetChecked() == true then
        Wardrobe.AddToQuickPanel(Wardrobe.Vars.SelectedOutfit)
        if WardrobeDb[UnitGUID('player')].OutfitSettings ~= nil then
            if WardrobeDb[UnitGUID('player')].OutfitSettings[Wardrobe.Vars.SelectedOutfit] ~= nil then
                if WardrobeDb[UnitGUID('player')].OutfitSettings[Wardrobe.Vars.SelectedOutfit]['icon'] ~= nil then
                    Wardrobe.UI.IconTexture:SetTexture(tonumber(WardrobeDb[UnitGUID('player')].OutfitSettings[Wardrobe.Vars.SelectedOutfit]['icon']))
                end
            end
        end
    else
        Wardrobe.RemoveFromQuickPanel(Wardrobe.Vars.SelectedOutfit)
    end
    Wardrobe.UpdateQuickPanel()
end)
Wardrobe.UI.OutfitIsOnHUDCheckbox.tooltip = '在快速換裝按鈕面板中顯示此套裝'

Wardrobe.UI.OutfitFrame.IconPickerButton = CreateFrame("BUTTON", "Wardrobe_EquipCurrentSet", Wardrobe_Outfitframe, "UIPanelButtonTemplate")
Wardrobe.UI.OutfitFrame.IconPickerButton:SetPoint("TOPLEFT", 160, -70)
Wardrobe.UI.OutfitFrame.IconPickerButton:SetText('圖示')
Wardrobe.UI.OutfitFrame.IconPickerButton:SetSize(70, 22)
Wardrobe.UI.OutfitFrame.IconPickerButton:SetScript("OnClick", function() if Wardrobe.UI.IconPickerFrame:IsVisible() then Wardrobe.UI.IconPickerFrame:Hide() else Wardrobe.UI.IconPickerFrame:Show() end end)

Wardrobe.UI.IconPickerFrame = CreateFrame("FRAME", "Wardrobe_IconPickerFrame", Wardrobe_Outfitframe, BackdropTemplateMixin and "BackdropTemplate" or nil)
Wardrobe.UI.IconPickerFrame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "interface/dialogframe/ui-dialogbox-border", tile = true, tileSize = 16, edgeSize = 20, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
Wardrobe.UI.IconPickerFrame:SetBackdropColor(0, 0, 0, 0.9)
Wardrobe.UI.IconPickerFrame:SetSize(290, 288)
Wardrobe.UI.IconPickerFrame:SetPoint("TOPLEFT", 250, 0)
Wardrobe.UI.IconPickerFrame:Hide()

Wardrobe.UI.OutfitFrame.CustomIconPickerButton = CreateFrame("BUTTON", "Wardrobe_EquipCurrentSet", Wardrobe.UI.IconPickerFrame, "UIPanelButtonTemplate")
Wardrobe.UI.OutfitFrame.CustomIconPickerButton:SetPoint("TOPRIGHT", -10, -10)
Wardrobe.UI.OutfitFrame.CustomIconPickerButton:SetText('自訂')
Wardrobe.UI.OutfitFrame.CustomIconPickerButton:SetSize(70, 22)
Wardrobe.UI.OutfitFrame.CustomIconPickerButton:SetScript("OnClick", function() StaticPopup_Show("Wardrobe_CustomIconDialog") end)

Wardrobe.UI.IconPickerTextures = {}
function Wardrobe.DrawIconPickerIcons()
    local test = 236575
    local k = 1
    for i = 1, 8 do
        for j = 1, 8 do
            local f = CreateFrame("FRAME", tostring("$parent_IconFrame_"..i..'_'..j), Wardrobe.UI.IconPickerFrame)
            f:SetSize(30, 30)
            f:SetPoint("TOPLEFT", ((j - 1) * 30) + 10, (((i - 1) * 30) + 40) * -1 )
            f.t = f:CreateTexture("$parent_Texture", "ARTWORK")
            --f.t:SetAllPoints(f)
            f.t:SetPoint("TOPLEFT", 1, -1)
            f.t:SetPoint("BOTTOMRIGHT", -1, 1)

            ---use this to find new icons            
            --f.t:SetTexture(tonumber(test) +  k)
            --f.textureID = tonumber(test) +  k

            ---use this in release
            f.t:SetTexture(Wardrobe.DB.IconFileIDs[k])
            f.textureID = Wardrobe.DB.IconFileIDs[k]

            f:SetScript("OnMouseDown", function(self) 

                Wardrobe.SetIcon(self.textureID)
                --[==[
                Wardrobe.UI.IconTexture:SetTexture(self.textureID) 
                if WardrobeDb[UnitGUID('player')] ~= nil then
                    if WardrobeDb[UnitGUID('player')].QuickPanelOutfits ~= nil then
                        if WardrobeDb[UnitGUID('player')].QuickPanelOutfits[Wardrobe.Vars.SelectedOutfit] ~= nil then
                            WardrobeDb[UnitGUID('player')].QuickPanelOutfits[Wardrobe.Vars.SelectedOutfit] = { Name = Wardrobe.Vars.SelectedOutfit, Icon = self.textureID }
                        end
                    end
                    if WardrobeDb[UnitGUID('player')].OutfitSettings ~= nil then
                        if WardrobeDb[UnitGUID('player')].OutfitSettings[Wardrobe.Vars.SelectedOutfit] ~= nil then
                            WardrobeDb[UnitGUID('player')].OutfitSettings[Wardrobe.Vars.SelectedOutfit]['icon'] = self.textureID
                        end
                    end
                end
                Wardrobe.UpdateQuickPanel()

                Wardrobe.UI.IconPickerFrame:Hide()
                ]==]--
            end)

            Wardrobe.UI.IconPickerTextures[k] = f
            k = k + 1
        end
    end
end

Wardrobe.UI.IconTexture = Wardrobe.UI.OutfitFrame:CreateTexture("$parent_SetIconTexture", "ARTWORK")
Wardrobe.UI.IconTexture:SetSize(40,40)
Wardrobe.UI.IconTexture:SetPoint("TOPLEFT", 110, -71) -- 圖示位置

Wardrobe.DrawIconPickerIcons()

Wardrobe.UI.QuickPanelConfig = {
    outfitButtonSize = 30.0,
    outfitIconSize = 30.0,
    outfitButtonMargin = 10.0,
    tooltipOffsetX = 30.0,
    tooltipOffsetY = 30.0,
}

Wardrobe.UI.QuickPanel = CreateFrame("FRAME", "WardrobeQuickPanel", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
Wardrobe.UI.QuickPanel:SetPoint("CENTER", 0, 0)
Wardrobe.UI.QuickPanel:SetSize(tonumber((Wardrobe.UI.QuickPanelConfig.outfitButtonMargin * 2) + Wardrobe.UI.QuickPanelConfig.outfitButtonSize), tonumber((Wardrobe.UI.QuickPanelConfig.outfitButtonMargin * 2) + Wardrobe.UI.QuickPanelConfig.outfitButtonSize))
Wardrobe.UI.QuickPanel:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Dialogframe/UI-Dialogbox-Border", tile = true, tileSize = 16, edgeSize = 20, insets = { left = 4, right = 4, top = 4, bottom = 4 }}); -- 快速換裝面板背景
Wardrobe.UI.QuickPanel:SetBackdropColor(0, 0, 0, 0.9)

Wardrobe.UI.QuickPanel.tooltip = CreateFrame("FRAME", "WardrobeQuickPanelTooltip", Wardrobe.UI.QuickPanel, "TooltipBorderedFrameTemplate")
Wardrobe.UI.QuickPanel.tooltip:SetSize(100, 30)
Wardrobe.UI.QuickPanel.tooltip:SetPoint("BOTTOMLEFT", Wardrobe.UI.QuickPanelConfig.outfitButtonSize, Wardrobe.UI.QuickPanelConfig.outfitButtonSize)
Wardrobe.UI.QuickPanel.tooltip.SetName = Wardrobe.UI.QuickPanel.tooltip:CreateFontString(nil, "OVERLAY", "GameFontNormal_NoShadow")
Wardrobe.UI.QuickPanel.tooltip.SetName:SetPoint("CENTER", 0, 0)
Wardrobe.UI.QuickPanel.tooltip.SetName:SetFont(STANDARD_TEXT_FONT, 13)
Wardrobe.UI.QuickPanel.tooltip.SetName:SetTextColor(1,1,1,1)
Wardrobe.UI.QuickPanel.tooltip.SetName:SetText('套裝名稱')
Wardrobe.UI.QuickPanel.tooltip:Hide()

Wardrobe.MakeFrameMovable(Wardrobe.UI.QuickPanel)

function Wardrobe.CreateQuickPanelButton(set, xPosIter, setIcon)
    local f = CreateFrame("FRAME", tostring("WardrobeQuickPanelButton_"..(xPosIter-1)), Wardrobe.UI.QuickPanel)
    f:SetSize(Wardrobe.UI.QuickPanelConfig.outfitButtonSize, Wardrobe.UI.QuickPanelConfig.outfitButtonSize)
    --f.border = f:CreateTexture("$parent_BorderTexture", "BACKGROUND")
    --f.border:SetAllPoints(f)
    --f.border:SetColorTexture(0,0,0,0)
    f.icon = f:CreateTexture("$parent_IconTexture", "ARTWORK")
    f.icon:SetPoint("CENTER", 0, 0)
    f.icon:SetSize(Wardrobe.UI.QuickPanelConfig.outfitIconSize, Wardrobe.UI.QuickPanelConfig.outfitIconSize)
    if setIcon == nil then
        f.icon:SetTexture(130773)
    else
        f.icon:SetTexture(setIcon)
    end

    f.set = set

    xPosIter = xPosIter - 1
    local xPos = tonumber(Wardrobe.UI.QuickPanelConfig.outfitButtonMargin + (xPosIter * (Wardrobe.UI.QuickPanelConfig.outfitButtonSize + Wardrobe.UI.QuickPanelConfig.outfitButtonMargin)))

    f:SetPoint("LEFT", xPos, 0)

    f:SetScript("OnEnter", function(self)
        --self.border:SetColorTexture(Wardrobe.DB.ClassColours[string.upper(UnitClass('player'))].r, Wardrobe.DB.ClassColours[string.upper(UnitClass('player'))].g, Wardrobe.DB.ClassColours[string.upper(UnitClass('player'))].b, 0.85)
        f.icon:SetAlpha(0.65)
        Wardrobe.UI.QuickPanel.tooltip.SetName:SetText(self.set)
        Wardrobe.UI.QuickPanel.tooltip:SetParent(self)
        Wardrobe.UI.QuickPanel.tooltip:SetPoint("TOPLEFT", Wardrobe.UI.QuickPanelConfig.tooltipOffsetX, Wardrobe.UI.QuickPanelConfig.tooltipOffsetY)
        Wardrobe.UI.QuickPanel.tooltip:SetSize(Wardrobe.UI.QuickPanel.tooltip.SetName:GetWidth() + 20, Wardrobe.UI.QuickPanel.tooltip.SetName:GetHeight() + 5)
        Wardrobe.UI.QuickPanel.tooltip:Show()
    end)
    f:SetScript("OnLeave", function(self) 
        --self.border:SetColorTexture(0,0,0,0)
        f.icon:SetAlpha(1.0)
        Wardrobe.UI.QuickPanel.tooltip:Hide()
    end)
    f:SetScript("OnMouseDown", function(self)
        Wardrobe.IterateSet(self.set)
    end)

    return f
    --Wardrobe.QuickPanelButtons[xPosIter] = f
end

function Wardrobe.SetIcon(texture)
    Wardrobe.UI.IconTexture:SetTexture(texture) 
    if WardrobeDb[UnitGUID('player')] ~= nil then
        if WardrobeDb[UnitGUID('player')].QuickPanelOutfits ~= nil then
            if WardrobeDb[UnitGUID('player')].QuickPanelOutfits[Wardrobe.Vars.SelectedOutfit] ~= nil then
                WardrobeDb[UnitGUID('player')].QuickPanelOutfits[Wardrobe.Vars.SelectedOutfit] = { Name = Wardrobe.Vars.SelectedOutfit, Icon = texture }
            end
        end
        if WardrobeDb[UnitGUID('player')].OutfitSettings ~= nil then
            if WardrobeDb[UnitGUID('player')].OutfitSettings[Wardrobe.Vars.SelectedOutfit] ~= nil then
                WardrobeDb[UnitGUID('player')].OutfitSettings[Wardrobe.Vars.SelectedOutfit]['icon'] = texture
            end
        end
    end
    Wardrobe.UpdateQuickPanel()

    Wardrobe.UI.IconPickerFrame:Hide()
end

function Wardrobe.UpdateOutfitFrame()
	if WardrobeDb[UnitGUID('player')] ~= nil then
        if WardrobeDb[UnitGUID('player')].OutfitSettings ~= nil then
            --update character wardrobe extension panel
            if WardrobeDb[UnitGUID('player')].OutfitSettings[Wardrobe.Vars.SelectedOutfit] ~= nil then
                Wardrobe.UI.HelmCheckbox:SetChecked(WardrobeDb[UnitGUID('player')].OutfitSettings[Wardrobe.Vars.SelectedOutfit]['helm'])
                Wardrobe.UI.CloakCheckbox:SetChecked(WardrobeDb[UnitGUID('player')].OutfitSettings[Wardrobe.Vars.SelectedOutfit]['cloak'])
                Wardrobe.UI.OutfitIsOnHUDCheckbox:SetChecked(WardrobeDb[UnitGUID('player')].OutfitSettings[Wardrobe.Vars.SelectedOutfit]['quickPanel'])
                Wardrobe.UI.IconTexture:SetTexture(WardrobeDb[UnitGUID('player')].OutfitSettings[Wardrobe.Vars.SelectedOutfit]['icon'])
            end
        end
    end
end

function Wardrobe.AddToQuickPanel(set)
    if WardrobeDb[UnitGUID('player')] ~= nil then
        if WardrobeDb[UnitGUID('player')].QuickPanelOutfits ~= nil then
            WardrobeDb[UnitGUID('player')].QuickPanelOutfits[set] = { Name = set, Icon = 130773 }
        end
    end
end

function Wardrobe.RemoveFromQuickPanel(set)
	if WardrobeDb[UnitGUID('player')] ~= nil then
        if WardrobeDb[UnitGUID('player')].QuickPanelOutfits ~= nil then
            WardrobeDb[UnitGUID('player')].QuickPanelOutfits[set] = {}
            WardrobeDb[UnitGUID('player')].QuickPanelOutfits[set] = nil
        end
    end
end

function Wardrobe.UpdateQuickPanel()
    local qpCount = 0
    if Wardrobe.QuickPanelButtons ~= nil then
        for k, f in ipairs(Wardrobe.QuickPanelButtons) do
            f:Hide()
            --f.set = nil
            --f.icon = nil
        end
    end
    if WardrobeDb[UnitGUID('player')] ~= nil then
        if WardrobeDb[UnitGUID('player')].QuickPanelOutfits ~= nil then
            local k = 1
            for n, outfit in pairs(WardrobeDb[UnitGUID('player')].QuickPanelOutfits) do
                if Wardrobe.QuickPanelButtons[k] == nil then
                    Wardrobe.QuickPanelButtons[k] = Wardrobe.CreateQuickPanelButton(outfit.Name, k, tonumber(outfit.Icon))
                    --Wardrobe.CreateQuickPanelButton(outfit.Name, k, outfit.Icon)
                else
                    local xPos = tonumber(Wardrobe.UI.QuickPanelConfig.outfitButtonMargin + ((k-1) * (Wardrobe.UI.QuickPanelConfig.outfitButtonSize + Wardrobe.UI.QuickPanelConfig.outfitButtonMargin)))
                    Wardrobe.QuickPanelButtons[k]:SetPoint("LEFT", xPos, 0)
                    Wardrobe.QuickPanelButtons[k].set = outfit.Name
                    --Wardrobe.QuickPanelButtons[k].set = outfitName
                    --Wardrobe.QuickPanelButtons[k].icon:SetTexture(tonumber(outfit.Icon))
                    Wardrobe.QuickPanelButtons[k]:Show()
                end
                if WardrobeDb[UnitGUID('player')].OutfitSettings ~= nil then
                    if WardrobeDb[UnitGUID('player')].OutfitSettings[outfit.Name] ~= nil then
                        if WardrobeDb[UnitGUID('player')].OutfitSettings[outfit.Name]['icon'] ~= nil then
                            Wardrobe.QuickPanelButtons[k].icon:SetTexture(tonumber(WardrobeDb[UnitGUID('player')].OutfitSettings[outfit.Name]['icon']))
                        end
                    end
                end
                local width = tonumber(Wardrobe.UI.QuickPanelConfig.outfitButtonMargin + (k * (Wardrobe.UI.QuickPanelConfig.outfitButtonSize + Wardrobe.UI.QuickPanelConfig.outfitButtonMargin)))
                Wardrobe.UI.QuickPanel:SetSize(width, Wardrobe.UI.QuickPanelConfig.outfitButtonSize + Wardrobe.UI.QuickPanelConfig.outfitButtonMargin + Wardrobe.UI.QuickPanelConfig.outfitButtonMargin)
                k = k + 1
                qpCount = qpCount + 1
            end
        end
    end
    if qpCount == 0 then
        Wardrobe.UI.QuickPanel:Hide()
    else
        Wardrobe.UI.QuickPanel:Show()
    end
end

--- returns info about the outfit and what changes TODO: keep testing to make this perfect, counts seem 1 out ?
function Wardrobe.GetSetItemData(outfit)
    local toRemove, toAdd, toSwap, toKeep, totalSetItems = 0, 0, 0, 0, 0
    if WardrobeDb[UnitGUID('player')] ~= nil then
        for slot, item in pairs(outfit) do
            if slot ~= 'Name' then
                local slotId, textureName = GetInventorySlotInfo(slot)
                if item ~= 'empty' then
                    totalSetItems = totalSetItems + 1
                end
                local slotItemId = GetInventoryItemID("player", slotId)

                if slotItemId == item then -- slot and outfit match so no change
                    toKeep = toKeep + 1
                    Wardrobe.DebugMessage('match '..slotItemId..' '..item)
                elseif slotItemId == nil and item ~= 'empty' then --slot is empty and outfit has item so we add
                    toAdd = toAdd + 1
                    Wardrobe.DebugMessage('slot empty but outfit not add'..item)
                elseif slotItemId ~= nil and item == 'empty' then -- slot has item and outfit is empty so remove
                    toRemove = toRemove + 1
                    Wardrobe.DebugMessage('slot not empty but outfit is '..slotItemId..' '..item)
                elseif slotItemId ~= nil and item ~= 'empty' and slotItemId ~= item then
                    toSwap = toSwap + 1 --slot has item and outfit has item but dont match so its swap
                    Wardrobe.DebugMessage('slot and outfit need swap '..slotItemId..' '..item)
                end
            end
        end
    end
    return toRemove, toAdd, toSwap, toKeep, totalSetItems
end

--- old function ?
function Wardrobe.GetEmptyBagSlotCount()
    Wardrobe.Vars.EmptyBagSpace = 0
	for bag = 4, 0, -1 do
        for slot = 1, GetContainerNumSlots(bag) do
            --local item = GetContainerItemID(bag, slot)
            local link = GetContainerItemLink(bag, slot)
            if link == nil then
                Wardrobe.Vars.EmptyBagSpace = Wardrobe.Vars.EmptyBagSpace + 1
            end
        end
    end
    return Wardrobe.Vars.EmptyBagSpace
end

--- scans character bags and creates a table of ID's for bags with empty slots, each empty slot will cause its bag ID to be entered into table
function Wardrobe.MapBagSlots()
    Wardrobe.Vars.BagSpaceTable = {}
	for bag = 4, 0, -1 do
        for slot = 1, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            if link == nil then
                Wardrobe.DebugMessage('found slot in bag '..bag)
                table.insert(Wardrobe.Vars.BagSpaceTable, bag)
            end
        end
    end
    if Wardrobe.Vars.Debug == true then
        for k, v in ipairs(Wardrobe.Vars.BagSpaceTable) do
            if v > 0 then
                local bagLink = GetInventoryItemLink('player', v + 19)
                Wardrobe.DebugMessage('empty slot found in bag '..bagLink)
            else
                Wardrobe.DebugMessage('empty slot found in bag backpack')
            end
        end
        Wardrobe.DebugMessage('total empty slots '..(#Wardrobe.Vars.BagSpaceTable))
    end
end

--- TODO: test this function to be used in enable wardrobe to move items into bank
function Wardrobe.MapBankBagSlots()
    Wardrobe.Vars.BankBagSpaceTable = {}
	for bag = BANK_CONTAINER, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
        for slot = 1, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            if link == nil then
                Wardrobe.DebugMessage('found slot in bag '..bag)
                table.insert(Wardrobe.Vars.BagSpaceTable, bag)
            end
        end
    end
    if Wardrobe.Vars.Debug == true then
        for k, v in ipairs(Wardrobe.Vars.BankBagSpaceTable) do
            if v > 0 then
                local bagLink = GetInventoryItemLink('player', v + 19)
                Wardrobe.DebugMessage('empty slot found in bag '..bagLink)
            else
                Wardrobe.DebugMessage('empty slot found in bag backpack')
            end
        end
        Wardrobe.DebugMessage('total empty slots '..(#Wardrobe.Vars.BagSpaceTable))
    end
end

--- returns true or false if backpack has an empty slot, old function no longer used
function Wardrobe.EmptyBackpackSlot()
	local bag = 0
    for slot = 1, GetContainerNumSlots(bag) do
        local item = GetContainerItemID(bag, slot)
        if item == nil then
            return true
        end
    end
end

--- will unequip items and put in character bags regardless of available slots @outfit=table of outfit items, @slot=string of inv slot(key used in outfit table), @itemID=interger id of item(value used in outfit table), @i=iter count used in bag checks
---TODO: can the slot and itemID be removed if the outfit table is passed in OR if outfit table is only used for name in debug just pass in name?
function Wardrobe.UnequipSlot(outfit, slot, itemID, i)
    local slotId, textureName = GetInventorySlotInfo(slot)
    local itemLink = select(2, GetItemInfo(itemID))
    if Wardrobe.Vars.BagSpaceTable[i] > 0 then
        PickupInventoryItem(slotId)
        local bagID = Wardrobe.Vars.BagSpaceTable[i] + 19
        local bagLink = GetInventoryItemLink('player', bagID)
        PutItemInBag(bagID)
        Wardrobe.DebugMessage(tostring(outfit.Name..':'..slot..'=empty, moving item into bag '..(bagLink or 'nil')))
    elseif Wardrobe.Vars.BagSpaceTable[i] == 0 then
        PickupInventoryItem(slotId)
        PutItemInBackpack()
        Wardrobe.DebugMessage(tostring(outfit.Name..':'..slot..'=empty, moving item into bag backpack'))
    else
        Wardrobe.DebugMessage('no available bag space for items after checking bags') --work on this and add method to stop swap?
    end
end

--- taken from gamepedia, will auto equip items from the bank TODO: create a custom function to move items into bags and use the better EquipItemByName api
function Wardrobe.EquipItemByID(id)
	for bag = BANK_CONTAINER, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
		for slot = 1,GetContainerNumSlots(bag) do
            local item = GetContainerItemID(bag, slot)
            if item and item == id then
				if CursorHasItem() or CursorHasMoney() or CursorHasSpell() then ClearCursor() end
				PickupContainerItem(bag, slot)
				AutoEquipCursorItem()
				return true
			end
		end
	end
end

function Wardrobe.IterateSet(set)
	if not set then Wardrobe.PrintMessage('請先選擇套裝或建立新的套裝'); return end -- 暫時修正
    Wardrobe.MapBagSlots()
    Wardrobe.DebugMessage('iterate set '..set)
    if WardrobeDb[UnitGUID('player')] ~= nil then
        WardrobeDb[UnitGUID('player')].CurrentOutfit = set
        for k, outfit in ipairs(WardrobeDb[UnitGUID('player')].Outfits) do
            if outfit.Name == set then

                --apply settings
                if WardrobeDb[UnitGUID('player')] ~= nil then
                    if WardrobeDb[UnitGUID('player')].OutfitSettings ~= nil then
                        if WardrobeDb[UnitGUID('player')].OutfitSettings[set] ~= nil then
                            ShowHelm(WardrobeDb[UnitGUID('player')].OutfitSettings[set]['helm'])
                            ShowCloak(WardrobeDb[UnitGUID('player')].OutfitSettings[set]['cloak'])
                        end
                    end
                end



                local toRemove, toAdd, toSwap, toKeep, total = Wardrobe.GetSetItemData(outfit)
                Wardrobe.DebugMessage('remove', toRemove, 'add', toAdd, 'swap', toSwap, 'keep', toKeep, 'total', total)

                if CursorHasItem() or CursorHasMoney() or CursorHasSpell() then ClearCursor() end
                local i = 1
                for slot, itemID in pairs(outfit) do
                    if slot ~= 'Name' then
                        local slotId, textureName = GetInventorySlotInfo(slot)
                        if itemID == 'empty' then --unequip slot
                            if i <= (#Wardrobe.Vars.BagSpaceTable - 1) then
                                Wardrobe.DebugMessage('bag table i value '..Wardrobe.Vars.BagSpaceTable[i])
                                local slotLink = GetInventoryItemLink('player', slotId)
                                if slotLink then
                                    Wardrobe.UnequipSlot(outfit, slot, itemID, i)
                                    i = i + 1
                                end
                            end
                            
                        end

                        if itemID ~= 'empty' then --equip slot, either add or swap
                            local itemLink = select(2, GetItemInfo(itemID))
                            if Wardrobe.Vars.BankOpen == true then
                                Wardrobe.EquipItemByID(itemID)
                                Wardrobe.DebugMessage('bank frame open equipping '..itemLink)
                            else
                                EquipItemByName(itemID, slotId)
                                Wardrobe.DebugMessage('equipping '..itemLink)
                            end

                        end

                    end
                  
                    
                    
                    --Wardrobe.HandleSlot(outfit, slot, itemID)
                    --local t = C_Timer.After(i * 0.25, function() Wardrobe.HandleSlot(outfit, slot, itemID, i) end)
                    
                    --[==[
                    if slot ~= 'Name' then
                        local slotId, textureName = GetInventorySlotInfo(slot)
                        local itemLink = select(2, GetItemInfo(itemID))
                        if itemID == 'empty' then                        
                            if Wardrobe.GetEmptyBagSlot() ~= nil then
                                PickupInventoryItem(slotId)
                                local bagID = Wardrobe.GetEmptyBagSlot() + 19
                                local bagLink = GetInventoryItemLink('player', bagID)
                                PutItemInBag(bagID)
                                Wardrobe.DebugMessage(tostring(outfit.Name..':'..slot..'=empty, moving item into bag '..bagLink))
                            elseif Wardrobe.GetEmptyBackpackSlot() ~= nil then
                                PickupInventoryItem(slotId)
                                PutItemInBackpack()
                                Wardrobe.DebugMessage(tostring(outfit.Name..':'..slot..'=empty, moving item into bag backpack'))
                            else
                                Wardrobe.DebugMessage('no available bag space for items') --work on this and add method to stop swap?
                            end
                        else
                            if Wardrobe.Vars.BankOpen == true then
                                Wardrobe.EquipItemByID(itemID)
                            else
                                EquipItemByName(itemID, slotId)
                            end
                            Wardrobe.DebugMessage('equipping '..itemLink)
                        end
                    end
                    ]==]--

                end
                Wardrobe.Vars.CurrentlyEquippedOutfit = set
            end
        end
    end
end



function Wardrobe.LoadCharacter()
    if WardrobeDb[UnitGUID('player')] == nil then
        WardrobeDb[UnitGUID('player')] = { Outfits = {}, OutfitSettings = {}, QuickPanelSettings = {}, CurrentOutfit = nil }
    else
        --Wardrobe.FixDb()
        Wardrobe.CreateOutfitSettingsDb()
        Wardrobe.CreateQuickPanelDb()
    end

    Wardrobe.UI.OutfitFrame.OutfitDropDown_Init()
    if WardrobeDb[UnitGUID('player')].CurrentOutfit ~= nil then
        Wardrobe.Vars.SelectedOutfit = WardrobeDb[UnitGUID('player')].CurrentOutfit
        UIDropDownMenu_SetText(Wardrobe.UI.OutfitFrame.OutfitDropDown, WardrobeDb[UnitGUID('player')].CurrentOutfit)
    end
    Wardrobe.UpdateQuickPanel()
    Wardrobe.UpdateOutfitFrame()
end

function Wardrobe.CreateNewOutfit(outfitName)
    if WardrobeDb[UnitGUID('player')] ~= nil then
        local add = true
        for k, outfit in ipairs(WardrobeDb[UnitGUID('player')].Outfits) do
            if outfit.Name == outfitName then
                add = false
                Wardrobe.PrintMessage('套裝已經存在，請選擇新的名稱!')
            end
        end
        if add == true then
            table.insert(WardrobeDb[UnitGUID('player')].Outfits, { Name = outfitName, } )
            Wardrobe.Vars.SelectedOutfit = outfitName
            UIDropDownMenu_SetText(Wardrobe.UI.OutfitFrame.OutfitDropDown, outfitName)
            Wardrobe.PrintMessage('已建立 '..outfitName)
        end
    end
end

function Wardrobe.DeleteCurrentSet()
    if WardrobeDb[UnitGUID('player')] ~= nil then
        for k, outfit in ipairs(WardrobeDb[UnitGUID('player')].Outfits) do
            if outfit.Name == Wardrobe.Vars.SelectedOutfit then
                Wardrobe.PrintMessage('已刪除 '..outfit.Name)
                table.remove(WardrobeDb[UnitGUID('player')].Outfits, k) --change this as its a terrible idea - create a better remove function
                UIDropDownMenu_SetText(Wardrobe.UI.OutfitFrame.OutfitDropDown, '')
				Wardrobe.RemoveFromQuickPanel(Wardrobe.Vars.SelectedOutfit) -- 暫時修正，刪除套裝時也要從快速面板移除。
				Wardrobe.UpdateQuickPanel()
				Wardrobe.Vars.SelectedOutfit = nil
				--[[
				Wardrobe.UI.IconTexture:Hide()
				Wardrobe.UI.OutfitFrame.SaveCurrentlyEquippedButton:Disable()
				Wardrobe.UI.OutfitFrame.DeleteCurrentSet:Disable()
				Wardrobe.UI.OutfitFrame.EquipCurrentSet:Disable()
				Wardrobe.UI.OutfitIsOnHUDCheckbox:Disable()
				Wardrobe.UI.OutfitFrame.IconPickerButton:Disable()
				--]]
            end
        end
    end
end

function Wardrobe.SaveCurrentOutfit()
    if not Wardrobe.Vars.SelectedOutfit then Wardrobe.PrintMessage('請先選擇套裝或建立新的套裝'); return end -- 暫時修正
	if WardrobeDb[UnitGUID('player')] ~= nil then
        for k, outfit in ipairs(WardrobeDb[UnitGUID('player')].Outfits) do
            if outfit.Name == Wardrobe.Vars.SelectedOutfit then
                for i = 1, 19 do
                    local itemId = GetInventoryItemID("player", i)
                    if itemId then
                        outfit[Wardrobe.DB.InvSlots[i]] = itemId
                    else
                        outfit[Wardrobe.DB.InvSlots[i]] = 'empty'
                    end
                end
                Wardrobe.PrintMessage('已將目前的套裝儲存到 '..outfit.Name)
            end
        end
    end
end

--- updates the outfit setting @name=outfit name, @setting=string for setting, @value=seting value
function Wardrobe.EditCurrentOutfit(name, setting, value)
    --print(name, setting, value)
    if not name then return end -- 暫時修正
	if WardrobeDb[UnitGUID('player')] ~= nil then
        if WardrobeDb[UnitGUID('player')].OutfitSettings ~= nil then
            if WardrobeDb[UnitGUID('player')].OutfitSettings[name] ~= nil then
                WardrobeDb[UnitGUID('player')].OutfitSettings[name][setting] = value
            else
                WardrobeDb[UnitGUID('player')].OutfitSettings[name] = {}
                WardrobeDb[UnitGUID('player')].OutfitSettings[name][setting] = value
            end
        end
    end
end

function Wardrobe.CreateQuickPanelDb()
    if WardrobeDb[UnitGUID('player')] ~= nil then
        if WardrobeDb[UnitGUID('player')].QuickPanelOutfits == nil then
            WardrobeDb[UnitGUID('player')].QuickPanelOutfits = {}
        end
    end
end

--- create a db to contain outfit settings, this keeps the outfit item data clean
function Wardrobe.CreateOutfitSettingsDb()
    if WardrobeDb[UnitGUID('player')] ~= nil then
        if WardrobeDb[UnitGUID('player')].Outfits ~= nil then
            for k, outfit in ipairs(WardrobeDb[UnitGUID('player')].Outfits) do
                if WardrobeDb[UnitGUID('player')].OutfitSettings == nil then
                    WardrobeDb[UnitGUID('player')].OutfitSettings = {}
                    WardrobeDb[UnitGUID('player')].OutfitSettings[outfit.Name] = { helm = true, cloak = true, quickPanel = false, quickPanelPos = -1 }
                end
            end
        end
    end
end

---first version used INVSLOT_HEAD rather than HEADSLOT so this should update any old databases, can be removed in future
function Wardrobe.FixDb()
    if WardrobeDb[UnitGUID('player')] ~= nil then
        for k, outfit in ipairs(WardrobeDb[UnitGUID('player')].Outfits) do
            for slot, itemId in pairs(outfit) do
                local newSlot = nil
                if string.find(slot, 'INVSLOT') then
                    if string.find(slot, '1') then
                        local oneZero = tostring(string.sub(slot, 1, -2)..'0')
                        newSlot = tostring(string.sub(oneZero, 9)..'SLOT')
                    elseif string.find(slot, '2') then
                        local twoOne = tostring(string.sub(slot, 1, -2)..'1')
                        newSlot = tostring(string.sub(twoOne, 9)..'SLOT')
                    elseif string.find(slot, 'OFFHAND') then
                        newSlot = 'SECONDARYHANDSLOT'
                    elseif string.find(slot, '_HAND') then
                        newSlot = 'HANDSSLOT'
                    elseif string.find(slot, 'BODY') then
                        newSlot = 'SHIRTSLOT'
                    else
                        newSlot = tostring(string.sub(slot, 9)..'SLOT')
                    end
                    outfit[newSlot] = itemId
                    outfit[slot] = nil
                end
            end
        end
    end
end

function Wardrobe.OnEvent(self, event, ...)

    if event == "ADDON_LOADED" and select(1, ...) == 'Wardrobe' then
        if WardrobeDb == nil then
            WardrobeDb = {}
        end
        C_Timer.After(1, function() Wardrobe.LoadCharacter() end)
    end

    if event == 'BANKFRAME_OPENED' then
        Wardrobe.Vars.BankOpen = true
    end
    if event == 'BANKFRAME_CLOSED' then
        Wardrobe.Vars.BankOpen = false
    end

    if event == "PLAYER_LOGOUT" then

    end

end

Wardrobe.EventFrame:SetScript("OnEvent", Wardrobe.OnEvent)
