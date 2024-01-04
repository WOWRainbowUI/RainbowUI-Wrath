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