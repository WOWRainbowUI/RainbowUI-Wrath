local L = LibStub("AceLocale-3.0"):NewLocale("Breakables", "zhTW")
if not L then return end

L["Are you sure you want to clear the ignore list?"] = "是否確定要清空忽略清單?"
L["Are you sure you want to remove this item from the ignore list?"] = "是否確定要將此項物品移出忽略清單?"
L["Breakables"] = "快速分解物品"
L["Breakables "] = "專業-分解"
L["Button grow direction"] = "按鈕延伸方向"
L["Button scale"] = "按鈕縮放大小"
L["Clear ignore list"] = "清空忽略清單"
L["Click to open Breakables options."] = "點一下開啟快速分解物品的設定選項。"
L["Down"] = "下"
L["Font size"] = "文字大小"
L["Hide bar"] = "隱藏分解快捷列"
L["Hide during combat"] = "戰鬥中隱藏"
L["Hide during pet battles"] = "寵物對戰期間隱藏"
L["Hide Eq. Mgr items"] = "隱藏套裝設定物品"
L["Hide if no breakables"] = "沒有物品可分解時隱藏"
L["Hide Tabards"] = "隱藏外袍"
L["Hold shift and left-click to drag the Breakables bar around."] = "按住 Shift+滑鼠左鍵拖曳移動分解快捷列的位置。"
L["How many breakable buttons to display next to the profession button at maximum"] = "專業按鈕旁最多顯示幾個可分解物品按鈕。"
L["If checked, a lockbox that is too high level for the player to pick will still be shown in the list, otherwise it will be hidden."] = "勾選後，等級太高而玩家無法選擇的寶箱仍會顯示在列表中，否則將被隱藏。"
L["Ignore Enchanting skill level"] = "無視附魔技能等級"
L["Ignore list"] = "忽略清單"
L["Items that have been right-clicked to exclude from the breakable list. Un-check the box to remove the item from the ignore list."] = "這是曾被點右鍵從可分解清單中排除的物品，取消勾選可以將物品移出忽略清單。"
L["Left"] = "左"
L["Max number to display"] = "最多顯示"
L["Reset"] = "重置"
L["Reset placement"] = "重置位置"
L["Resets where the buttons are placed on the screen to the default location."] = "將按鈕在螢幕上的放置處重置為預設位置。"
L["Right"] = "右"
L["Settings"] = "設定"
L["Show high-level lockboxes"] = "顯示高等級寶箱"
L["Show soulbound items"] = "顯示靈魂綁定物品"
L["Show tooltip on breakables"] = "顯示可分解物品浮動提示資訊"
L["Show tooltip on profession"] = "在專業技能上顯示浮動提示資訊"
L["This controls which direction the breakable buttons grow toward."] = "設定可分解按鈕增長時延伸的分向。"
L["This sets the size of the text that shows how many items you have to break."] = "設定有多少個物品需要分解的文字大小。"
L[ [=[This will add the chosen item to the ignore list so it no longer appears as breakable. Items can be removed from the ignore list in the Breakables settings.

Would you like to ignore this item?]=] ] = "將選擇的物品加入忽略清單，不再顯示為可分解。在設定選項中可以將它從忽略清單中移除。\n\n是否要忽略此物品?"
L["This will completely hide the breakables bar whether you have anything to break down or not. Note that you can toggle this in a macro using the /breakables command as well."] = "完全隱藏分解快捷列，不論是否有東西可供分解。可以輸入 /breakables 或將它寫成巨集來切換顯示/隱藏分解快捷列。"
L["This will scale the size of each button up or down."] = "縮放每個按鈕的大小。"
L["Up"] = "上"
L["Welcome"] = [=[感謝使用 |cff33ff99Breakables|r! 請輸入 |cffffff78/brk|r 或 |cffffff78/breakables|r 開啟設定選項。

請按住 Shift 鍵拖曳專業按鈕來移動分解快捷列。你可以直接點一下任何可分解物品的按鈕來分解它，而不用先點擊專業按鈕。右鍵點擊可分解物品的按鈕，會將該物品加入忽略清單，便不會再出現。可以從設定選項管理忽略清單。

有任何功能需求或問題，請 email |cff33ff99breakables@parnic.com|r 或造訪 |cffffff78curse.com|r 或 |cffffff78wowinterface.com|r 網頁並留言。
]=]
L["Whether or not items should be shown when Breakables thinks you don't have the appropriate skill level to disenchant it."] = "當Breakables認為您沒有適當的技能等級來分解物品時，是否應該顯示物品。"
L["Whether or not to display soulbound items as breakables."] = "是否要顯示靈魂綁定的物品，視為可供分解的物品。"
L["Whether or not to hide items that are part of an equipment set in the game's equipment manager."] = "是否要隱藏裝備管理員的套裝設定中所包含的物品。"
L["Whether or not to hide tabards from the disenchantable items list."] = "是否要在可分解的物品清單中隱藏外袍。"
L["Whether or not to hide the action bar if no breakables are present in your bags"] = "背包中沒有可供分解的物品時，是否要隱藏分解快捷列。"
L["Whether or not to hide the breakables bar when you enter a pet battle."] = "進入寵物對戰時是否隱藏breakables條。"
L["Whether or not to hide the breakables bar when you enter combat and show it again when leaving combat."] = "進入戰鬥時是否要隱藏分解快捷列，離開戰鬥後會再次顯示出來。"
L["Whether or not to show an item tooltip when hovering over a breakable item button."] = "滑鼠停留在可分解的物品按鈕上時是否要顯示浮動提示資訊。"
L["Whether or not to show an item tooltip when hovering over a profession button on the Breakables bar."] = "滑鼠停留在 Breakables 的專業按鈕上時是否要顯示浮動提示資訊。"
L["You can click on this button to break this item without having to click on the profession button first."] = "直接點一下這個按鈕來分解此項物品，不用先點擊專業按鈕。"
L["You can right-click on this button to ignore this item. Items can be unignored from the options screen."] = "在按鈕上點右鍵忽略此項物品，在設定選項裡面可以取消忽略。"

