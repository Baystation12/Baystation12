/datum/sprite_accessory/marking
	species_allowed = null
	var/layer_blend = ICON_OVERLAY

	/// A list of body parts this marking covers, using BP_* defines
	var/body_parts = list()

	/// The draw target of this marking, using MARKING_TARGET_* defines
	var/draw_target = MARKING_TARGET_SKIN

	/// If set, automatically add BP_* to the icon state when building the icon
	var/use_organ_tag = TRUE

	/// A list of marking types to disallow while this marking is added
	var/list/disallows = list()

	/// If this marking targets skin tone, applies this as a color offset
	var/list/skin_tone_offset
