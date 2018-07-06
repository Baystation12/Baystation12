/obj/item/organ/external/chest/nabber
	name = "thorax"
	encased = "carapace"

/obj/item/organ/external/groin/nabber
	name = "abdomen"
	icon_position = UNDER
	encased = "carapace"

/obj/item/organ/external/arm/nabber
	name = "left arm"
	amputation_point = "coxa"
	icon_position = LEFT
	encased = "carapace"

/obj/item/organ/external/arm/right/nabber
	name = "right arm"
	amputation_point = "coxa"
	icon_position = RIGHT
	encased = "carapace"

/obj/item/organ/external/leg/nabber
	name = "left tail side"
	icon_position = LEFT
	encased = "carapace"

/obj/item/organ/external/leg/right/nabber
	name = "right tail side"
	encased = "carapace"

/obj/item/organ/external/foot/nabber
	name = "left tail tip"
	icon_position = LEFT
	encased = "carapace"

/obj/item/organ/external/foot/right/nabber
	name = "right tail tip"
	icon_position = RIGHT
	encased = "carapace"

/obj/item/organ/external/hand/nabber
	name = "left grasper"
	icon_position = LEFT
	encased = "carapace"

/obj/item/organ/external/hand/right/nabber
	name = "right grasper"
	icon_position = RIGHT
	encased = "carapace"

/obj/item/organ/external/head/nabber
	name = "head"
	vital = 0
	can_heal_overkill = 0
	has_lips = 0
	encased = "carapace"
	eye_icon_location = 'icons/mob/human_races/species/nabber/eyes.dmi'

	var/last_cached_shield
	var/last_cached_cloak

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