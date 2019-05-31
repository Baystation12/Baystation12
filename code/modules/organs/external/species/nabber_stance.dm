/obj/item/organ/external/head/nabber
	name = "head"
	vital = 0
	has_lips = 0
	encased = "carapace"
	action_button_name = "Switch Stance" // Basically just a wrapper for switch stance verb, since GAS use it more than normals.
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_GENDERED_ICON | ORGAN_FLAG_CAN_BREAK

/obj/item/organ/external/head/nabber/get_eye_overlay()
	var/obj/item/organ/internal/eyes/eyes = owner.internal_organs_by_name[owner.species.vision_organ ? owner.species.vision_organ : BP_EYES]
	if(eyes)
		return eyes.get_special_overlay()

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
