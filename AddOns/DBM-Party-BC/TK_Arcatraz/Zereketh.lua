local mod = DBM:NewMod(548, "DBM-Party-BC", 15, 254)
local L = mod:GetLocalizedStrings()

mod:SetRevision("20231010191435")
mod:SetCreatureID(20870)
mod:SetEncounterID(1916)
mod:SetModelID(19882)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 36127 39005",
	"SPELL_CAST_SUCCESS 36119 30533",
	"SPELL_AURA_APPLIED 39367 32863",
	"SPELL_AURA_REMOVED 39367 32863"
)

local warnVoid      = mod:NewSpellAnnounce(36119, 3)
local warnSoC      = mod:NewTargetNoFilterAnnounce(39367, 3, nil, "Healer")

local specwarnNova	= mod:NewSpecialWarningSpell(39005, nil, nil, nil, 2, 2)
local specWarnGTFO	= mod:NewSpecialWarningGTFO(36121, nil, nil, nil, 1, 8)

local timerSoC      = mod:NewTargetTimer(18, 39367, nil, "Healer", 2, 3)

function mod:OnCombatStart(delay)
	if not self:IsTrivial() then
		self:RegisterShortTermEvents(
			"SPELL_DAMAGE 36121 39004",
			"SPELL_MISSED 36121 39004"
		)
	end
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(36127, 39005) then
		specwarnNova:Show()
		specwarnNova:Play("aesoon")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(36119, 30533) then
		warnVoid:Show()
	end
end

do
	local player = UnitGUID("player")

	function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
		if (spellId == 36121 or spellId == 39004) and destGUID == player and self:AntiSpam(4, 1) then--Flame Crash
			specWarnGTFO:Show(spellName)
			specWarnGTFO:Play("watchfeet")
		end
	end
	mod.SPELL_MISSED = mod.SPELL_DAMAGE
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(39367, 32863) then
		warnSoC:Show(args.destName)
		timerSoC:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(39367, 32863) then
		timerSoC:Stop(args.destName)
	end
end