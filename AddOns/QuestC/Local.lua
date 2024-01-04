local addonName, addonTable = ...;
local L;
local locale = GetLocale();

if(locale == "zhTW") then
	L = {
		--QuestFrame
		ACCEPT = "接受",
		DECLINE = "拒絕",
		CONTINUE = "繼續",
		GOODBYE = "再見",
		THANK_YOU = "感謝",
		GIVE = "交付",
		REWARD = "選擇你的獎勵!",
		CONGRAT = "恭喜!",
	};


else
	L = {
		--QuestFrame
		ACCEPT = "Accept",
		DECLINE = "Decline",
		CONTINUE = "Continue",
		GOODBYE = "Goodbye",
		THANK_YOU = "Thank you",
		GIVE = "Give",
		REWARD = "Choose Your reward!",
		CONGRAT = "Congratulations!",
	};
end


addonTable["Locale"] = L;
