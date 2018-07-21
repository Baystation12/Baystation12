/obj/item/organ/external/head/nabber
	name = "head"
	vital = 0
	has_lips = 0
	encased = "carapace"
	eye_icon_location = 'icons/mob/human_races/species/nabber/eyes.dmi'
	action_button_name = "Switch Stance" // Basically just a wrapper for switch stance verb, since GAS use it more than normals.
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_GENDERED_ICON | ORGAN_FLAG_CAN_BREAK

	var/last_cached_shield
	var/last_cached_cloak


/obj/item/organ/external/head/nabber/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "nabber-stance-[owner && owner.pulling_punches ? 1 : 0]"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/external/head/nabber/attack_self(var/mob/user)
	. = ..()
	if(.)
		owner.pull_punches()
		refresh_action_button()

/obj/item/organ/external/head/nabber/get_eye_cache_key()
	last_cached_shield = FALSE
	last_cached_cloak = FALSE
	if(owner)
		last_cached_cloak = owner.is_cloaked()
		var/obj/item/organ/internal/eyes/nabber/O = owner.internal_organs_by_name[BP_EYES]
		if(istype(O)) last_cached_shield = O.eyes_shielded
	. = ..()

/obj/item/organ/external/head/nabber/get_eye_overlay()
	var/icon/I = get_eyes()
	if(I)
		var/image/eye_overlay = image(I)
		if(last_cached_cloak)
			eye_overlay.alpha = 100
		if(last_cached_shield)
			eye_overlay.color = "#aaaaaa"
		return eye_overlay