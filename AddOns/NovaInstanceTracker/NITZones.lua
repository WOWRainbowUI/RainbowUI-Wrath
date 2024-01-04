------------------------------------
---NovaInstance Tracker zones list--
------------------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("NovaInstanceTracker");

NIT.zones = {
	--Dungeons (Classic).
	[33] = {
		name = L["Shadowfang Keep"],
		type = "dungeon",
		expansion = "classic",
	},
	[48] = {
		name = L["Blackfathom Deeps"],
		type = "dungeon",
		expansion = "classic",
	},
	[230] = {
		name = L["Blackrock Depths"],
		type = "dungeon",
		expansion = "classic",
	},
	[229] = {
		name = L["Blackrock Spire"],
		type = "dungeon",
		expansion = "classic",
	},
	[429] = {
		name = L["Dire Maul"],
		type = "dungeon",
		expansion = "classic",
	},
	[90] = {
		name = L["Gnomeregan"],
		type = "dungeon",
		expansion = "classic",
	},
	[349] = {
		name = L["Maraudon"],
		type = "dungeon",
		expansion = "classic",
	},
	[389] = {
		name = L["Ragefire Chasm"],
		type = "dungeon",
		expansion = "classic",
	},
	[129] = {
		name = L["Razorfen Downs"],
		type = "dungeon",
		expansion = "classic",
	},
	[47] = {
		name = L["Razorfen Kraul"],
		type = "dungeon",
		expansion = "classic",
	},
	[1004] = {
		name = L["Scarlet Monastery"],
		type = "dungeon",
		expansion = "classic",
	},
	[1007] = {
		name = L["Scholomance"],
		type = "dungeon",
		expansion = "classic",
	},
	[329] = {
		name = L["Stratholme"],
		type = "dungeon",
		expansion = "classic",
	},
	[36] = {
		name = L["The Deadmines"],
		type = "dungeon",
		expansion = "classic",
	},
	[34] = {
		name = L["The Stockade"],
		type = "dungeon",
		expansion = "classic",
	},
	[109] = {
		name = L["The Temple of Atal'Hakkar"],
		type = "dungeon",
		expansion = "classic",
	},
	[70] = {
		name = L["Uldaman"],
		type = "dungeon",
		expansion = "classic",
	},
	[43] = {
		name = L["Wailing Caverns"],
		type = "dungeon",
		expansion = "classic",
	},
	[209] = {
		name = L["Zul'Farrak"],
		type = "dungeon",
		expansion = "classic",
	},
	--Raids (Classic).
	[249] = {
		name = L["Onyxia's Lair"],
		type = "raid",
		expansion = "classic",
		noLockout = true,
	},
	[309] = {
		name = L["Zul'gurub"],
		type = "raid",
		expansion = "classic",
	},
	[409] = {
		name = L["Molten Core"],
		type = "raid",
		expansion = "classic",
		noLockout = true,
	},
	[469] = {
		name = L["Blackwing Lair"],
		type = "raid",
		expansion = "classic",
		noLockout = true,
		maxPlayers = 40,
	},
	[509] = {
		name = L["Ruins of Ahn'Qiraj"],
		type = "raid",
		expansion = "classic",
	},
	[531] = {
		name = L["Temple of Ahn'Qiraj"],
		type = "raid",
		expansion = "classic",
		noLockout = true,
	},
	[533] = {
		name = L["Naxxramas"],
		type = "raid",
		expansion = "classic",
		noLockout = true,
	},
}

--Add expansions dungeons seperately so we can overwrite duplicate zoneids (like naxx) for later expansions.
if (NIT.expansionNum > 1) then
	--Dungeons (TBC).
	NIT.zones[558] = {
		name = L["Auchenai Crypts"],
		type = "dungeon",
		expansion = "tbc",
	};
	NIT.zones[543] = {
		name = L["Hellfire Ramparts"],
		type = "dungeon",
		expansion = "tbc",
	};
	NIT.zones[585] = {
		name = L["Magisters' Terrace"],
		type = "dungeon",
		expansion = "tbc",
	};
	NIT.zones[557] = {
		name = L["Mana-Tombs"],
		type = "dungeon",
		expansion = "tbc",
	};
	NIT.zones[560] = {
		name = L["Old Hillsbrad Foothills"],
		type = "dungeon",
		expansion = "tbc",
	};
	NIT.zones[556] = {
		name = L["Sethekk Halls"],
		type = "dungeon",
		expansion = "tbc",
	};
	NIT.zones[555] = {
		name = L["Shadow Labyrinth"],
		type = "dungeon",
		expansion = "tbc",
	};
	NIT.zones[552] = {
		name = L["The Arcatraz"],
		type = "dungeon",
		expansion = "tbc",
	};
	NIT.zones[269] = { --Is this low ID right?
		name = L["The Black Morass"],
		type = "dungeon",
		expansion = "tbc",
	};
	NIT.zones[542] = {
		name = L["The Blood Furnace"],
		type = "dungeon",
		expansion = "tbc",
	};
	NIT.zones[553] = {
		name = L["The Botanica"],
		type = "dungeon",
		expansion = "tbc",
	};
	NIT.zones[554] = {
		name = L["The Mechanar"],
		type = "dungeon",
		expansion = "tbc",
	};
	NIT.zones[540] = {
		name = L["The Shattered Halls"],
		type = "dungeon",
		expansion = "tbc",
	};
	NIT.zones[547] = {
		name = L["The Slave Pens"],
		type = "dungeon",
		expansion = "tbc",
	};
	NIT.zones[545] = {
		name = L["The Steamvault"],
		type = "dungeon",
		expansion = "tbc",
	};
	NIT.zones[546] = {
		name = L["The Underbog"],
		type = "dungeon",
		expansion = "tbc",
	};
	--Raids (TBC).
	NIT.zones[564] = {
		name = L["Black Temple"],
		type = "raid",
		expansion = "tbc",
		noLockout = true,
	};
	NIT.zones[565] = {
		name = L["Gruul's Lair"],
		type = "raid",
		expansion = "tbc",
		noLockout = true,
	};
	NIT.zones[534] = {
		name = L["Hyjal Summit"],
		type = "raid",
		expansion = "tbc",
		noLockout = true,
	};
	NIT.zones[532] = {
		name = L["Karazhan"],
		type = "raid",
		expansion = "tbc",
		noLockout = true, --Maybe has a lockout like 20m classic raids?
	};
	NIT.zones[544] = {
		name = L["Magtheridon's Lair"],
		type = "raid",
		expansion = "tbc",
		noLockout = true,
	};
	NIT.zones[548] = {
		name = L["Serpentshrine Cavern"],
		type = "raid",
		expansion = "tbc",
		noLockout = true,
	};
	NIT.zones[580] = {
		name = L["Sunwell Plateau"],
		type = "raid",
		expansion = "tbc",
		noLockout = true,
	};
	NIT.zones[550] = {
		name = L["Tempest Keep"],
		type = "raid",
		expansion = "tbc",
		noLockout = true,
	};
	NIT.zones[568] = {
		name = L["Zul'Aman"],
		type = "raid",
		expansion = "tbc",
		noLockout = true,
	};
end

if (NIT.expansionNum > 2) then
	--Wrath dungeons.
	NIT.zones[619] = {
		name = L["Ahn'kahet: The Old Kingdom"],
		type = "dungeon",
		expansion = "wrath",
	};
	NIT.zones[601] = {
		name = L["Azjol-Nerub"],
		type = "dungeon",
		expansion = "wrath",
	};
	NIT.zones[600] = {
		name = L["Drak'Tharon Keep"],
		type = "dungeon",
		expansion = "wrath",
	};
	NIT.zones[604] = {
		name = L["Gundrak"],
		type = "dungeon",
		expansion = "wrath",
	};
	NIT.zones[602] = {
		name = L["Halls of Lightning"],
		type = "dungeon",
		expansion = "wrath",
	};
	NIT.zones[668] = {
		name = L["Halls of Reflection"],
		type = "dungeon",
		expansion = "wrath",
	};
	NIT.zones[599] = {
		name = L["Halls of Stone"],
		type = "dungeon",
		expansion = "wrath",
	};
	NIT.zones[658] = {
		name = L["Pit of Saron"],
		type = "dungeon",
		expansion = "wrath",
	};
	NIT.zones[595] = {
		name = L["The Culling of Stratholme"],
		type = "dungeon",
		expansion = "wrath",
	};
	NIT.zones[632] = {
		name = L["The Forge of Souls"],
		type = "dungeon",
		expansion = "wrath",
	};
	NIT.zones[576] = {
		name = L["The Nexus"],
		type = "dungeon",
		expansion = "wrath",
	};
	NIT.zones[578] = {
		name = L["The Oculus"],
		type = "dungeon",
		expansion = "wrath",
	};
	NIT.zones[608] = {
		name = L["The Violet Hold"],
		type = "dungeon",
		expansion = "wrath",
	};
	NIT.zones[650] = {
		name = L["Trial of the Champion"],
		type = "dungeon",
		expansion = "wrath",
	};
	NIT.zones[574] = {
		name = L["Utgarde Keep"],
		type = "dungeon",
		expansion = "wrath",
	};
	NIT.zones[575] = {
		name = L["Utgarde Pinnacle "],
		type = "dungeon",
		expansion = "wrath",
	};
	--Wrath raids.
	NIT.zones[533] = {
		name = L["Naxxramas"],
		type = "raid",
		expansion = "wrath",
		noLockout = true,
	};
	NIT.zones[615] = {
		name = L["The Obsidian Sanctum"],
		type = "raid",
		expansion = "wrath",
		noLockout = true,
	};
	NIT.zones[616] = {
		name = L["The Eye of Eternity"],
		type = "raid",
		expansion = "wrath",
		noLockout = true,
	};
	NIT.zones[624] = {
		name = L["Vault of Archavon"],
		type = "raid",
		expansion = "wrath",
		noLockout = true,
	};
	NIT.zones[603] = {
		name = L["Ulduar"],
		type = "raid",
		expansion = "wrath",
		noLockout = true,
	};
	NIT.zones[649] = {
		name = L["Trial of the Crusader"],
		type = "raid",
		expansion = "wrath",
		noLockout = true,
	};
	NIT.zones[631] = {
		name = L["Icecrown Citadel"],
		type = "raid",
		expansion = "wrath",
		noLockout = true,
	};
	NIT.zones[724] = {
		name = L["The Ruby Sanctum"],
		type = "raid",
		expansion = "wrath",
		noLockout = true,
	};
	NIT.zones[249] = {
		name = L["Onyxia's Lair"],
		type = "raid",
		expansion = "wrath",
		noLockout = true,
	};
end