--[[
 Skillet: A tradeskill window replacement.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]--

local L = LibStub("AceLocale-3.0"):NewLocale("Skillet", "enUS", true, true)
if not L then return end

L[" days"] = true
L["About"] = true
L["ABOUTDESC"] = "Prints info about Skillet"
L["Add Recipe to Ignored List"] = true
L["Add to Ignore Materials"] = true
L["alts"] = true
L["Appearance"] = true
L["APPEARANCEDESC"] = "Options that control how Skillet is displayed"
L["Auction"] = true
L["Bank"] = true
L["bank"] = true
L["Blizzard"] = true
L["Buy Reagents"] = true
L["buyable"] = true
L["Buyout"] = true
L["By Difficulty"] = true
L["By Item Level"] = true
L["By Level"] = true
L["By Name"] = true
L["By Quality"] = true
L["By Skill Level"] = true
L["can be created by crafting reagents"] = true
L["can be created from reagents in your inventory"] = true
L["can be created from reagents on all characters"] = true
L["can be created from reagents on other characters"] = true
L["can be created with reagents bought at vendor"] = true
L["Changing profession to"] = true
L["CLAMPTOSCREENDESC"] = "Force frames to remain on screen"
L["CLAMPTOSCREENNAME"] = "Clamp frames to screen"
L["Clear"] = true
L["Click"] = true
L["click here to add a note"] = true
L["Click to toggle favorite"] = true
L["Collapse all groups"] = true
L["Config"] = true
L["CONFIGDESC"] = "Opens a config window for Skillet"
L["CONFIRMQUEUECLEARDESC"] = "Use Alt-left-click instead of left-click to clear the queue"
L["CONFIRMQUEUECLEARNAME"] = "Use Alt-click to clear queue"
L["Conflict with the addon TradeSkillMaster"] = true
L["Copy"] = true
L["Cost"] = true
L["Could not find bag space for"] = true
L["craftable"] = true
L["CRAFTBUTTONSDESC"] = "Include Craft buttons in frame"
L["CRAFTBUTTONSNAME"] = "Include Craft buttons"
L["Crafted By"] = "Crafted by"
L["Create"] = true
L["Create All"] = true
L["Cut"] = true
L["DBMarket"] = true
L["Delete"] = true
L["DISPLAYITEMLEVELDESC"] = "If the item to be crafted has an item level, that level will be displayed along with the recipe"
L["DISPLAYITEMLEVELNAME"] = "Display item level"
L["DISPLAYREQUIREDLEVELDESC"] = "If the item to be crafted requires a minimum level to use, that level will be displayed along with the recipe"
L["DISPLAYREQUIREDLEVELNAME"] = "Display required level"
L["DISPLAYSHOPPINGLIST"] = "Display shopping list at:"
L["DISPLAYSHOPPINGLISTATAUCTIONDESC"] = "Display a shopping list of the items that are needed to craft queued recipes but are not in your bags"
L["DISPLAYSHOPPINGLISTATAUCTIONNAME"] = "Display shopping list at auctions"
L["DISPLAYSHOPPINGLISTATBANKDESC"] = "Display a shopping list of the items that are needed to craft queued recipes but are not in your bags"
L["DISPLAYSHOPPINGLISTATBANKNAME"] = "Display shopping list at banks"
L["DISPLAYSHOPPINGLISTATGUILDBANKDESC"] = "Display a shopping list of the items that are needed to craft queued recipes but are not in your bags"
L["DISPLAYSHOPPINGLISTATGUILDBANKNAME"] = "Display shopping list at guild banks"
L["DISPLAYSHOPPINGLISTATMERCHANTDESC"] = "Display a shopping list of the items that are needed to craft queued recipes but are not in your bags"
L["DISPLAYSHOPPINGLISTATMERCHANTNAME"] = "Display Shopping List at Merchants"
L["Draenor Engineering"] = true
L["Empty Group"] = true
L["Enabled"] = true
L["Enchant"] = true
L["ENCHANTSCROLLSDESC"] = "Use the enchant scroll item for links"
L["ENCHANTSCROLLSNAME"] = "Use enchant scrolls"
L["ENHANCHEDRECIPEDISPLAYDESC"] = "When enabled, recipe names will have one or more '+' characters appeneded to their name to inidcate the difficulty of the recipe."
L["ENHANCHEDRECIPEDISPLAYNAME"] = "Show recipe difficulty as text"
L["Expand all groups"] = true
L["Features"] = true
L["FEATURESDESC"] = "Optional behavior that can be enabled and disabled"
L["Filter"] = true
L["Filter recipes by source"] = true
L["Flat"] = true
L["Flush All Data"] = true
L["Flush Player Data"] = true
L["Flush Recipe Data"] = true
L["FLUSHALLDATADESC"] = "Flush all Skillet data"
L["FLUSHPLAYERDATADESC"] = "Flush this character's data"
L["FLUSHRECIPEDATADESC"] = "Flush Skillet recipe data"
L["From Selection"] = true
L["Glyph "] = true
L["Gold earned"] = true
L["Grouping"] = true
L["Guild bank"] = true
L["has cooldown of"] = true
L["have"] = true
L["Hide trivial"] = true
L["Hide uncraftable"] = true
L["HIDEBLIZZARDFRAMEDESC"] = "Hide Blizzard TradeSkill frame when showing Skillet frame"
L["HIDEBLIZZARDFRAMENAME"] = "Hide Blizzard Frame"
L["HIGHERVELLUMDESC"] = "Use a higher level of vellum when correct vellum is unavailable."
L["HIGHERVELLUMNAME"] = "Use higher vellum"
L["Ignore"] = true
L["Ignore on hand"] = true
L["IGNOREBANKEDREAGENTSDESC"] = "Ignore banked reagents when queuing craftable reagents"
L["IGNOREBANKEDREAGENTSNAME"] = "Ignore banked reagents"
L["IGNORECHANGEDESC"] = "Ignore first profession change"
L["IGNORECHANGENAME"] = "Ignore first profession change"
L["IGNORECLEARDESC"] = "Clear all entries from the Ignored Materials list."
L["Ignored List"] = true
L["Ignored Materials Clear"] = true
L["Ignored Materials List"] = true
L["IGNORELISTDESC"] = "Open the Ignored Materials list frame."
L["IGNOREQUEUEDREAGENTSDESC"] = "Ignore queued reagents"
L["IGNOREQUEUEDREAGENTSNAME"] = "Ignore queued reagents"
L["Illusions"] = true
L["in your bank"] = true
L["in your inventory"] = true
L["Include alts"] = true
L["Include bank"] = true
L["Include guild"] = true
L["INCLUDEREAGENTSDESC"] = "Add reagent names to the item text that is searched."
L["INCLUDEREAGENTSNAME"] = "Include Reagents in Search"
L["INTERRUPTCLEARDESC"] = "Moving, jumping, closing the frame, or clicking the Pause button clears the in progress queue entry"
L["INTERRUPTCLEARNAME"] = "Spell interrupt clears queue entry"
L["inventory"] = true
L["Inventory"] = true
L["INVENTORYDESC"] = "Inventory Information"
L["InvSlot"] = true
L["is now disabled"] = true
L["is now enabled"] = true
L["Learned"] = true
L["Left-Click to toggle"] = true
L["Library"] = true
L["Link Recipe"] = true
L["LINKCRAFTABLEREAGENTSDESC"] = "If you can create a reagent needed for the current recipe, clicking the reagent will take you to its recipe."
L["LINKCRAFTABLEREAGENTSNAME"] = "Make reagents clickable"
L["Load"] = true
L["Lock/Unlock"] = true
L["Market"] = true
L["Merchant"] = true
L["Merge items"] = true
L["Most Sold"] = true
L["Move Down"] = true
L["Move to Bottom"] = true
L["Move to Top"] = true
L["Move Up"] = true
L["need"] = true
L["New"] = true
L["New Group"] = true
L["No Data"] = true
L["No headers, try again"] = true
L["No such queue saved"] = true
L["None"] = true
L["not yet cached"] = true
L["Notes"] = true
L["Number of items to queue/create"] = true
L["Options"] = true
L["Order by item"] = true
L["Paste"] = true
L["Pause"] = true
L["Percent"] = true
L["Plugins"] = true
L["Press"] = true
L["Press Okay to continue changing professions"] = true
L["Press Process to continue"] = true
L["Process"] = true
L["Profit"] = true
L["Purchased"] = true
L["Queue"] = true
L["Queue All"] = true
L["Queue is empty"] = true
L["Queue is not empty. Overwrite?"] = true
L["Queue with this name already exsists. Overwrite?"] = true
L["QUEUECRAFTABLEREAGENTSDESC"] = "If you can create a reagent needed for the current recipe, and don't have enough, then that reagent will be added to the queue"
L["QUEUECRAFTABLEREAGENTSNAME"] = "Queue craftable reagents"
L["QUEUECRAFTSDESC"] = "Allow enchants to be queued which adds needed reagents to the shopping list. Enchants cannot be processed from the queue and will be removed."
L["QUEUECRAFTSNAME"] = "Queue enchant reagents"
L["QUEUEGLYPHREAGENTSDESC"] = "If you can create a reagent needed for the current recipe, and don't have enough, then that reagent will be added to the queue. This option is separate for Glyphs only."
L["QUEUEGLYPHREAGENTSNAME"] = "Queue reagents for Glyphs"
L["QUEUEONLYVIEWDESC"] = "Show Standalone Queue Window only when set, show both Standalone Queue Window and Skillet Window when clear."
L["QUEUEONLYVIEWNAME"] = "Only show Standalone Queue"
L["Queues"] = true
L["QUEUETOOLSDESC"] = "Add missing tools to shopping list"
L["QUEUETOOLSNAME"] = "Queue tools"
L["reagent id seems corrupt!"] = true
L["Reagents"] = true
L["reagents in inventory"] = true
L["Really delete this queue?"] = true
L["Remove Favorite"] = true
L["Remove Recipe from Ignored List"] = true
L["Rename"] = true
L["Rename Group"] = true
L["Request to queue %s items.\\n Are you sure?"] = true
L["Rescan"] = true
L["Reset"] = true
L["Reset Recipe Filter"] = true
L["RESETDESC"] = "Reset Skillet position"
L["RESETRECIPEFILTERDESC"] = "Reset Recipe Filter"
L["Retrieve"] = true
L["Right-Click for filtering options"] = true
L["Sales for "] = true
L["Sales Rate"] = true
L["Same faction"] = true
L["Save"] = true
L["Scale"] = true
L["SCALEDESC"] = "Scale of the tradeskill window (default 1.0)"
L["SCALETOOLTIPDESC"] = "Set scale of skill and reagent tooltips to match recipe tooltip (global uiscale)."
L["SCALETOOLTIPNAME"] = "Scale All Tooltips"
L["Scan completed"] = true
L["Scanning tradeskill"] = true
L["Search"] = true
L["Select All"] = true
L["Select None"] = true
L["Select skill difficulty threshold"] = true
L["Selected Addon"] = true
L["Selection"] = true
L["Sells for "] = true
L["Set Favorite"] = true
L["shift-click to link"] = true
L["Shopping Clear"] = true
L["Shopping List"] = true
L["SHOPPINGCLEARDESC"] = "Clear the shopping list"
L["SHOPPINGLISTDESC"] = "Display the shopping list"
L["Show favorite recipes only. Click on a star on the left side of a recipe to set favorite."] = true
L["Show News"] = true
L["Show news when a new version is released"] = true
L["SHOWBANKALTCOUNTSDESC"] = "When calculating and displaying craftable item counts, include items from your bank and from your other characters"
L["SHOWBANKALTCOUNTSNAME"] = "Include bank and alt character contents"
L["SHOWCRAFTCOUNTSDESC"] = "Show the number of times you can craft a recipe, not the total number of items producable"
L["SHOWCRAFTCOUNTSNAME"] = "Show craftable counts"
L["SHOWCRAFTERSTOOLTIPDESC"] = "Display the alternate characters that can craft an item in the item's tooltip"
L["SHOWCRAFTERSTOOLTIPNAME"] = "Show crafters in tooltips"
L["SHOWDETAILEDRECIPETOOLTIPDESC"] = "Displays a tooltip when hovering over recipes in the left hand panel"
L["SHOWDETAILEDRECIPETOOLTIPNAME"] = "Display tooltip for recipes"
L["SHOWFULLTOOLTIPDESC"] = "Display all informations about an item to be crafted. If you turn it off you will only see compressed tooltip (hold Ctrl to show full tooltip)"
L["SHOWFULLTOOLTIPNAME"] = "Use standard tooltips"
L["SHOWITEMNOTESTOOLTIPDESC"] = "Adds notes you provide for an item to the tool tip for that item"
L["SHOWITEMNOTESTOOLTIPNAME"] = "Add user specified notes to tooltip"
L["SHOWITEMTOOLTIPDESC"] = "Display craftable item tooltip, instead of a recipe tooltip."
L["SHOWITEMTOOLTIPNAME"] = "Display item tooltip when possible"
L["SHOWMAXUPGRADEDESC"] = "When set, show upgradable recipes as \"(current/maximum)\". When not set, show as \"(current)\""
L["SHOWMAXUPGRADENAME"] = "Show upgradable recipes as (current/max)"
L["SHOWRECIPESOURCEFORLEARNEDDESC"] = "Show Recipe Source for Learned Recipes"
L["SHOWRECIPESOURCEFORLEARNEDNAME"] = "Show Recipe Source for Learned Recipes "
L["Skillet Trade Skills"] = "Skillet-Classic"
L["Skipping"] = true
L["Sold amount"] = true
L["SORTASC"] = "Sort the recipe list from highest (top) to lowest (bottom)"
L["SORTDESC"] = "Sort the recipe list from lowest (top) to highest (bottom)"
L["Sorting"] = true
L["SOUNDONEMPTYQUEUEDESC"] = "Play a sound when the queue is empty"
L["SOUNDONEMPTYQUEUENAME"] = "Sound on Empty Queue"
L["Source:"] = true
L["STANDBYDESC"] = "Toggle standby mode on/off"
L["STANDBYNAME"] = "standby"
L["Start"] = true
L["Stop"] = true
L["SubClass"] = true
L["Suffix"] = true
L["SUPPORTCRAFTINGDESC"] = "Include support for Crafting professions (requires a /reload)"
L["SUPPORTCRAFTINGNAME"] = "Support Crafting"
L["Supported Addons"] = true
L["SUPPORTEDADDONSDESC"] = "Supported add ons that can or are being used to track inventory"
L["This merchant sells reagents you need!"] = true
L["TOOLTIPSCALEDESC"] = "Scales the recipe list, detail item and reagent tooltips"
L["Total Cost:"] = true
L["Total spent"] = true
L["TRADEBUTTONSDESC"] = "Include TradeSkill buttons in frame"
L["TRADEBUTTONSNAME"] = "Include TradeSkill buttons"
L["TradeSkillMaster must be in 'WOW UI' mode to use Skillet-Classic"] = ""
L["Trained"] = true
L["TRANSPARAENCYDESC"] = "Transparency of the main trade skill window"
L["Transparency"] = true
L["Unknown"] = true
L["Unlearned"] = true
L["Use Action Bar button to change professions"] = true
L["USEALTCURRVENDITEMSDESC"] = "Vendor items bought with alternate currencies are considered vendor supplied."
L["USEALTCURRVENDITEMSNAME"] = "Use vendor items bought with alternate currencies"
L["USEBANKASALTDESC"] = "Use the contents of the bank as if it was another alternate."
L["USEBANKASALTNAME"] = "Use bank as another alt"
L["USEBLIZZARDFORFOLLOWERSDESC"] = "Use the Blizzard UI for garrison follower tradeskills"
L["USEBLIZZARDFORFOLLOWERSNAME"] = "Use Blizzard UI for followers"
L["USEGUILDBANKASALTDESC"] = "Use the contents of the guildbank as if it was another alternate."
L["USEGUILDBANKASALTNAME"] = "Use guildbank as another alt"
L["Using Bank for"] = true
L["Using Reagent Bank for"] = true
L["VENDORAUTOBUYDESC"] = "If you have queued recipes and talk to a vendor that sells something needed for those recipes, it will be automatically purchased."
L["VENDORAUTOBUYNAME"] = "Automatically buy reagents"
L["VENDORBUYBUTTONDESC"] = "Display a button when talking to vendors that will allow you to buy the needed reagents for all queued recipes."
L["VENDORBUYBUTTONNAME"] = "Show reagent purchase button at vendors"
L["View Crafters"] = true

-- 自行加入
L["Skillet-Classic"] = true
L["Skillet"] = true
L["Profiles"] = true
L["Skillet-Classic: Ignored Recipes"] = true
L["used in queued skills:"] = true
L["created from queued skills:"] = true
L["scan incomplete..."] = true
L[" not available for alts"] = true
L["|r/ Chance:"] = true
L["in shopping list:"] = true
L["to craft "] = true
L[" you need:"] = true
L["Tooltip Scale"] = true
L["   Profit:\n"] = true
L["   Profit percentage:\n"] = true
L["By Suffix"] = true
L["Skillet-Classic News"] = true
L["Always"] = true
L["Once per Account"] = true
L["Once per Player"] = true
L["Never"] = true
L["InvertShiftKey"] = true
L["Invert sense of shift to open the Blizzard frames"] = true