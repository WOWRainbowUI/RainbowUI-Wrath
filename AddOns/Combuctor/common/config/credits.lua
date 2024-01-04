--[[
	display.lua
		Automatic display settings menu
--]]

local CONFIG = ...
local ADDON, Addon = CONFIG:match('[^_]+'), _G[CONFIG:match('[^_]+')]
local PATRONS = {{},{title='Jenkins',people={'Gnare','Seventeen','Grumpyitis','Justin Hall','Debora S Ogormanw','Johnny Rabbit'}},{title='Ambassador',people={'Julia F','Lolari ','Rafael Lins','Mediocre Monk','Joanie Nelson','Dodgen','Nitro ','Guidez ','Ptsdthegamer','Denise Mckinlay','Frosted(mrp)','Burt Humburg','Adam Mann','Christie Hopkins','Kopernikus ','Bc Spear','Jury ','Oromisism','Jeff Stokes','Tigran Andrew','Jeffrey Jones','Swallow@area52','Peter Hollaubek','Daniel  Di Battis','Bobby Pagiazitis','Michael Kinasz','Lars Norberg','Sam Ramji','Dave Burlingame'}}} -- generated patron list

local Credits = LibStub('Sushi-3.1').CreditsGroup(Addon.GeneralOptions)
Credits:SetSubtitle(nil, 'http://www.patreon.com/jaliborc')
Credits:SetFooter('By João Cardoso and Jason Greer')
Credits:SetPeople(PATRONS)
