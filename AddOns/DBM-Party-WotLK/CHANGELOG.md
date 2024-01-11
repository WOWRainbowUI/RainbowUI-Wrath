# <DBM Mod> Dungeons (Vanilla)

## [r114](https://github.com/DeadlyBossMods/DBM-Dungeons/tree/r114) (2024-01-09)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-Dungeons/compare/r113...r114) [Previous Releases](https://github.com/DeadlyBossMods/DBM-Dungeons/releases)

- several micro timer adjustments, especially in dawn  
    And Added Iridikon fight start RP  
- Use correct event  
- Update dropdowns with groupings  
- fixed a bug where venom burst could spam if multiple went on you in a short period of time  
- Fix naming convention  
- fix up Corroding Volley with updated language, which apparently is kickable and wowhead guide was wrong that it can only be stunned  
- update remaining 33 instances of tank defensive warnings to now use threat and role api for determining tank instead of relying on option defaults (it now defaults to on for all). This fixes following  
     - Going forward, if you import a profile with new defaults from a dps to a tank character, you won't lose out on these tank alerts  
     - If your tank dies, you will get an alert for the spell if you're next on threat.  
     - If you are two tanking (such as dungeon carries), only the relevant tank will get alert.  
     - If you're being bold and tanking in a dps spec, you'll still get warned.  
- change acid barrage alert. Closes https://github.com/DeadlyBossMods/DBM-Dungeons/issues/160  
- improve bladestorm announce on timelost battle by user request  
- Revert someof combat to RP timer changes, since I reworked and restored object and I do still want distinction of combat auto starts from rp "this doesn't auto engage" timers  
