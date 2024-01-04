local addon, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addon, "enUS", true)

if not L then return end

L["Dropdown.RegionPoint.BOTTOM.Desc"] = "Bottom - The centre-point of the bottom side of the rectangle"
L["Dropdown.RegionPoint.BOTTOMLEFT.Desc"] = "Bottom Left - The bottom left corner of the rectangle"
L["Dropdown.RegionPoint.BOTTOMRIGHT.Desc"] = "Bottom Right - The bottom right corner of the rectangle"
L["Dropdown.RegionPoint.CENTER.Desc"] = "Centre - The centre-point of the rectangle"
L["Dropdown.RegionPoint.LEFT.Desc"] = "Left - The centre-point of the left side of the rectangle"
L["Dropdown.RegionPoint.RIGHT.Desc"] = "Right - The centre-point of the right side of the rectangle"
L["Dropdown.RegionPoint.TOP.Desc"] = "Top - The centre-point of the top side of the rectangle"
L["Dropdown.RegionPoint.TOPLEFT.Desc"] = "Top Left - The top left corner of the rectangle"
L["Dropdown.RegionPoint.TOPRIGHT.Desc"] = "Top Right - The top right corner of the rectangle"
L["Dropdown.Texture.arrow_tip_green.Desc"] = "Green 3D arrow"
L["Dropdown.Texture.arrow_tip_red.Desc"] = "Red 3D arrow"
L["Dropdown.Texture.Arrows_Away.Desc"] = "Red Arrows Away From Nameplate"
L["Dropdown.Texture.Arrows_FocusAway.Desc"] = "Yellow Arrows Away From Nameplate"
L["Dropdown.Texture.Arrows_FocusTowards.Desc"] = "Yellow Arrows Towards Nameplate"
L["Dropdown.Texture.Arrows_FriendAway.Desc"] = "Green Arrows Away From Nameplate"
L["Dropdown.Texture.Arrows_FriendTowards.Desc"] = "Green Arrows Towards Nameplate"
L["Dropdown.Texture.Arrows_SelfAway.Desc"] = "Blue Arrows Away From Nameplate"
L["Dropdown.Texture.Arrows_SelfTowards.Desc"] = "Blue Arrows Towards Nameplate"
L["Dropdown.Texture.Arrows_Towards.Desc"] = "Red Arrows Towards Nameplate"
L["Dropdown.Texture.BlueArrow.Desc"] = "Blue arrow pointing downwards"
L["Dropdown.Texture.bluearrow1.Desc"] = "Abstract style blue arrow pointing downwards"
L["Dropdown.Texture.circles_target.Desc"] = "Red concentric circles in the style of a target"
L["Dropdown.Texture.gearsofwar.Desc"] = "Gears of War logo"
L["Dropdown.Texture.greenarrowtarget.Desc"] = "Neon green arrow with a red target"
L["Dropdown.Texture.Hunters_Mark.Desc"] = "Red Hunter's Mark Arrow"
L["Dropdown.Texture.malthael.Desc"] = "Malthael (Diablo) logo"
L["Dropdown.Texture.NeonGreenArrow.Desc"] = "Green version of the neon red arrow"
L["Dropdown.Texture.NeonRedArrow.Desc"] = "Neon version of the red arrow"
L["Dropdown.Texture.NeonReticule.Desc"] = "Neon version of the reticule"
L["Dropdown.Texture.NewRedArrow.Desc"] = "Red arrow pointing downwards"
L["Dropdown.Texture.NewSkull.Desc"] = "Skull with gas mask"
L["Dropdown.Texture.PaleRedChevronArrow.Desc"] = "Pale red version of the chevron"
L["Dropdown.Texture.PurpleArrow.Desc"] = "Abstract style purple arrow pointing downwards"
L["Dropdown.Texture.Q_FelFlamingSkull.Desc"] = "Fel green flaming skull"
L["Dropdown.Texture.Q_GreenGPS.Desc"] = "Green map pin/GPS symbol"
L["Dropdown.Texture.Q_GreenTarget.Desc"] = "Green target arrow"
L["Dropdown.Texture.Q_RedFlamingSkull.Desc"] = "Red flaming skull"
L["Dropdown.Texture.Q_RedGPS.Desc"] = "Red map pin/GPS symbol"
L["Dropdown.Texture.Q_RedTarget.Desc"] = "Red target arrow"
L["Dropdown.Texture.Q_ShadowFlamingSkull.Desc"] = "Shadow purple flaming skull"
L["Dropdown.Texture.Q_WhiteGPS.Desc"] = "White map pin/GPS symbol"
L["Dropdown.Texture.Q_WhiteTarget.Desc"] = "White target arrow"
L["Dropdown.Texture.red_star.Desc"] = "Red star with gold outline"
L["Dropdown.Texture.RedArrow.Desc"] = "Red arrow pointing downwards"
L["Dropdown.Texture.RedChevronArrow.Desc"] = "Red inverted triple chevron"
L["Dropdown.Texture.Reticule.Desc"] = "Red targeting reticule"
L["Dropdown.Texture.Shield.Desc"] = "Kite shield with sword and crossed spears/polearms"
L["Dropdown.Texture.skull.Desc"] = "Skull and crossbones"
L["Group.focus.friendly.Desc"] = "These options are used for friendly focuses"
L["Group.focus.hostile.Desc"] = "These options are used for hostile focuses"
L["Group.focus.Name"] = "Focus"
L["Group.focus.self.Desc"] = "These options are used when focusing yourself"
L["Group.friendly.Name"] = "Friendly"
L["Group.hostile.Name"] = "Hostile"
L["Group.indicators.Name"] = "Unit Indicator Options"
L["Group.mouseover.friendly.Desc"] = "These options are used for friendly mouseovers"
L["Group.mouseover.hostile.Desc"] = "These options are used for hostile mouseovers"
L["Group.mouseover.Name"] = "Mouseover"
L["Group.mouseover.self.Desc"] = "These options are used when mousing over yourself"
L["Group.self.Name"] = "Self"
L["Group.target.friendly.Desc"] = "These options are used for friendly targets"
L["Group.target.hostile.Desc"] = "These options are used for hostile targets"
L["Group.target.Name"] = "Target"
L["Group.target.self.Desc"] = "These options are used when targeting yourself"
L["Group.targettarget.friendly.Desc"] = "These options are used when your target's target is friendly to you"
L["Group.targettarget.hostile.Desc"] = "These options are used when your target's target is hostile to you"
L["Group.targettarget.Name"] = "Target of Target"
L["Group.targettarget.self.Desc"] = "These options are used when your target is targeting you"
L["Option.Unit.enable.Desc"] = "Enables/disables the indicator for this unit"
L["Option.Unit.enable.Name"] = "Enable"
L["Option.UnitReactionType.anchorPoint.Desc"] = "The point of the nameplate the texture should be anchored to"
L["Option.UnitReactionType.anchorPoint.Name"] = "Anchor Point"
L["Option.UnitReactionType.enable.Desc"] = "Enables/disables the indicator for this unit reaction type"
L["Option.UnitReactionType.enable.Name"] = "Enable"
L["Option.UnitReactionType.height.Desc"] = "The height of the texture"
L["Option.UnitReactionType.height.Name"] = "Texture Height"
L["Option.UnitReactionType.opacity.Desc"] = "The opacity of the texture. 1 is fully opaque, 0 is transparent."
L["Option.UnitReactionType.opacity.Name"] = "Texture Opacity"
L["Option.UnitReactionType.texture.Desc"] = "The texture to use for the indicator"
L["Option.UnitReactionType.texture.Name"] = "Texture"
L["Option.UnitReactionType.textureCustom.Desc"] = "The custom texture path to use for the indicator"
L["Option.UnitReactionType.textureCustom.Name"] = "Custom Texture"
L["Option.UnitReactionType.texturePoint.Desc"] = "The point of the texture that should be anchored to the nameplate"
L["Option.UnitReactionType.texturePoint.Name"] = "Texture Point"
L["Option.UnitReactionType.width.Desc"] = "The width of the texture"
L["Option.UnitReactionType.width.Name"] = "Texture Width"
L["Option.UnitReactionType.xOffset.Desc"] = "The x offset of the texture relative to the anchor point. Negative values move the texture left, positive values move the texture right."
L["Option.UnitReactionType.xOffset.Name"] = "X Offset"
L["Option.UnitReactionType.yOffset.Desc"] = "The y offset of the texture relative to the anchor point. Negative values move the texture down, positive values move the texture up."
L["Option.UnitReactionType.yOffset.Name"] = "Y Offset"
L["Usage.AnyNumber"] = "Must be a number"
L["Usage.FractionalNumber"] = "Must be a number between 0 and 1"
L["Usage.PositiveNumber"] = "Must be a positive number"

-- 自行加入
L["TargetNameplateIndicator"] = "TargetNameplateIndicator"
L["Target Nameplate Indicator"] = "Target Nameplate Indicator"
L["Dropdown.Texture.whitearrow1.Desc"] = "Abstract style white arrow pointing downwards"
L["Dropdown.Texture.greenarrow1.Desc"] = "Abstract style green arrow pointing downwards"
L["Dropdown.Texture.redarrow1.Desc"] = "Abstract style red arrow pointing downwards"
L["Dropdown.Texture.NeonWhiteArrow.Desc"] = "White version of the neon red arrow"
L["Custom"] = "Custom"

