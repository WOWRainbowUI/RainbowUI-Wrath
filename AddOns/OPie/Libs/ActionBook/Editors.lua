local _, T = ...

local AB = T.ActionBook:compatible(2, 36)
assert(AB and 1, "Incompatible library bundle")
local L = T.ActionBook.L
local MODERN = select(4,GetBuildInfo()) >= 8e4

local RegisterSimpleOptionsPanel do
	local optionsForHandle, curHandle, curHandleID = {}
	local f, fButtons = CreateFrame("Frame"), {}
	f:Hide()
	local function callSave()
		local p = f:GetParent()
		if p and type(p.OnActionChanged) == "function" then
			p:OnActionChanged(curHandle)
		elseif p and type(p.SaveAction) == "function" then -- DEPRECATED [2303]
			p:SaveAction()
		end
	end
	local function updateCheckButtonHitRect(self)
		local b = self:GetParent()
		b:SetHitRectInsets(0, -self:GetStringWidth()-5, 4, 4)
	end
	for i=1,3 do
		local e = CreateFrame("CheckButton", nil, f, MODERN and "UICheckButtonTemplate" or "InterfaceOptionsCheckButtonTemplate")
		if MODERN then
			e:SetSize(24, 24)
			e.Text:SetPoint("LEFT", e, "RIGHT", 2, 1)
			e.Text:SetFontObject(GameFontHighlightLeft)
		end
		hooksecurefunc(e.Text, "SetText", updateCheckButtonHitRect)
		e:SetMotionScriptsWhileDisabled(1)
		e:SetScript("OnClick", callSave)
		fButtons[i] = e
	end

	local function IsOwned(self, host)
		return curHandle == self and f:GetParent() == host
	end
	local function Release(self, host)
		if IsOwned(self, host) then
			curHandle, curHandleID = nil
			f:SetParent(nil)
			f:ClearAllPoints()
			f:Hide()
		end
	end
	local function SetAction(self, host, actionTable)
		local opts, op = optionsForHandle[self], f:GetParent()
		assert(actionTable[1] == opts[0], "Invalid editor")
		if curHandle and op and (op ~= host or self ~= curHandle) and type(op.OnEditorRelease) == "function" then
			securecall(op.OnEditorRelease, op, curHandle)
		end
		f:SetParent(nil)
		f:ClearAllPoints()
		f:SetAllPoints(host)
		f:SetParent(host)
		curHandle, curHandleID = self, actionTable[2]
		local ofsX = host.optionsColumnOffset
		ofsX = type(ofsX) == "number" and ofsX or 2
		local getState = opts.getOptionState
		for i=1,#opts do
			local w, oi, isChecked = fButtons[i], opts[i], false
			w.Text:SetText(opts[oi])
			w:SetPoint("TOPLEFT", ofsX, 23-21*i)
			if getState then
				isChecked = getState(actionTable, oi)
			elseif actionTable[opts[i]] ~= nil then
				isChecked = not not actionTable[oi]
			end
			w:SetChecked(isChecked)
			w:Show()
		end
		for i=#opts+1,#fButtons do
			fButtons[i]:Hide()
		end
		f:Show()
	end
	local function GetAction(self, into)
		local opts = optionsForHandle[self]
		into[1], into[2] = opts[0], curHandleID
		for i=1,#opts do
			into[opts[i]] = fButtons[i]:GetChecked() or nil
		end
		if opts.saveState then
			opts.saveState(into)
		end
	end
	function RegisterSimpleOptionsPanel(atype, opts)
		local r = {IsOwned=IsOwned, Release=Release, SetAction=SetAction, GetAction=GetAction}
		optionsForHandle[r], opts[0] = opts, atype
		AB:RegisterEditorPanel(atype, r)
	end
end

RegisterSimpleOptionsPanel("item", {"byName", "forceShow", "onlyEquipped",
	byName=L"Also use items with the same name",
	forceShow=L"Show a placeholder when unavailable",
	onlyEquipped=L"Only show when equipped"
})
RegisterSimpleOptionsPanel("macro", {"forceShow",
	forceShow=L"Show a placeholder when unavailable",
})
if MODERN then
	RegisterSimpleOptionsPanel("extrabutton", {"forceShow",
		forceShow=L"Show a placeholder when unavailable",
	})
	RegisterSimpleOptionsPanel("toy", {"forceShow",
		forceShow=L"Show a placeholder when unavailable",
	})
else
	RegisterSimpleOptionsPanel("spell", {"upRank",
		upRank=L"Use the highest known rank",
		getOptionState=function(actionTable, _optKey)
			return actionTable[3] ~= "lock-rank"
		end,
		saveState=function(intoTable)
			intoTable[3], intoTable.upRank = not intoTable.upRank and "lock-rank" or nil
		end,
	})
end


AB.HUM.CreateSimpleEditorPanel = RegisterSimpleOptionsPanel