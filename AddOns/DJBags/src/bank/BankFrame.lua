local ADDON_NAME, ADDON = ...
local Interactions = Enum.PlayerInteractionType

local bankFrame = {}
bankFrame.__index = bankFrame

function DJBagsRegisterBankFrame(self, bags)
	for k, v in pairs(bankFrame) do
		self[k] = v
	end

    ADDON.eventManager:Add('BANKFRAME_OPENED', self)
    ADDON.eventManager:Add('BANKFRAME_CLOSED', self)

    table.insert(UISpecialFrames, self:GetName())
    self:RegisterForDrag("LeftButton")
    self:SetScript("OnDragStart", function(self, ...)
        self:StartMoving()
    end)
    self:SetScript("OnDragStop", function(self, ...)
        self:StopMovingOrSizing(...)
    end)
    -- banking frames
	-- self:StopIf(_G, 'GuildBankFrame_LoadUI', self:Show('guild'))
	self:StopIf(_G, 'BankFrame_Open', self:Show('bank'))

	self:StopIf(PlayerInteractionFrameManager, 'ShowFrame', function(manager, type)
		return type == Interactions.Banker
	end)

	self:StopIf(PlayerInteractionFrameManager, 'HideFrame', function(manager, type)
		return type == Interactions.Banker
	end)
    self:SetScript('OnEvent', function(frame, event, ...) -- only way in classic
		if (event ~= 'BANKFRAME_OPENED' and event ~= 'BANKFRAME_CLOSED' ) then
			BankFrame_OnEvent(frame, event, ...)
		end
	end)
    self:SetUserPlaced(true)
end

function bankFrame:StopIf(domain, name, hook)
	local original = domain and domain[name]
	if original then
		domain[name] = function(...)
			if not hook(...) then
				return original(...)
			end
		end
	end
end

function bankFrame:BANKFRAME_OPENED()
	self:Show()
    DJBagsBag:Show()
end

function bankFrame:BANKFRAME_CLOSED()
	self:Hide()
end
