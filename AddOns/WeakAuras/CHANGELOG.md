# [5.9.0](https://github.com/WeakAuras/WeakAuras2/tree/5.9.0) (2024-01-03)

[Full Changelog](https://github.com/WeakAuras/WeakAuras2/compare/5.8.7...5.9.0)

## Highlights

 - Add Currency Trigger
- Enable receiving WA links in whispers from guild mates
- Added Classic SoD Rune templates
- Bug Fixes 

## Commits

Boneshock (2):

- fix %powertype show selected first then primary power type
- Currency trigger: don't specify test on value block

InfusOnWoW (19):

- Classic Templates: Add missing race specific Priest spells
- Fix KR/TW/CN large number formatting for >= 100.000.000
- Classic: Remove LibClassicCasterino
- Classic: Remove LibClassicDurations
- Classic: Replace LibClassicSpellActionCount with GetSpellCount
- Classic: Show warning that SAY/YELL are restricted too
- Classic: Less special code in Combat Log Event trigger
- Enable Modern Blizzard Time Formatting on Classic
- BT2: Add a condition checking for caster's name/realm
- Item Type trigger: Add Equipment Slot option
- Remove unused table
- Max Quantity: Fix enable check
- BT2: Rename condition to less confussing name
- BT: Remove left over code from old buff trigger
- ApplyFrameLevel: Correctly handle auras without a subbackground
- Make FixGroupChildrenOrderForGroup not recurse into subgroups
- Options: Ignore newFeatureString for sorting
- Reputation: Handle collapsed headers, and use DropDown with Headers
- Currency Trigger: Fix collapsed currency headers

Jordi (2):

- Currency Trigger: support classic wrath, disable on classic era (#4755)
- Add Currency Trigger (#4672)

Nightwarden24 (5):

- Fix texture search in texture picker Since texture names may contain characters that have special meaning when used in patterns, it's better to use the find function with plain text search enabled rather than the match function
- Fix StopMotion thumbnail
- Set region size to flipbook tile size
- Make flipbook display proportional in texture picker
- Add new flipbooks and correct some others

RealityWinner (1):

- Use spellIds in classic

emptyrivers (1):

- batch BAG_UPDATE_COOLDOWN events (#4756)

mrbuds (16):

- BossMod triggers: following a change in bigwigs, rename Key into ID BigWigs change: https://github.com/BigWigsMods/BigWigs/commit/9c65fd38132f38eacc341c0be4e430abacb1d19c
- BossMod trigger: fix %message with bigwigs %text %name or %n worked, but tooltip advertise %message fixes #4785
- Classic SoD priest runes template
- Classic SoD rogue runes template
- Classic SoD paladin runes template
- add C_Seasons to luacheckrc
- Classic SoD warrior runes template
- Classic SoD shaman runes template
- Classic SoD druid runes template
- Classic SoD hunter runes template
- Classic Sod warlock runes template
- Classic SoD mage runes template
- Cast trigger: drop leftoverinternal events for unused LibClassicCasterino
- Classic Era CLEU extraSpellId is still stuck at 0
- Classic: Fix softtarget units with aura trigger
- Enable weakauras link received in whisper from guild mates

