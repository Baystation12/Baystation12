
/obj/item/organ/external/head
	organ_tag = BP_HEAD
	icon_name = "head"
	name = "head"
	slot_flags = SLOT_BELT
	max_damage = 75
	min_broken_damage = 35
	w_class = ITEM_SIZE_NORMAL
	body_part = HEAD
	vital = 1
	parent_organ = BP_CHEST
	joint = "jaw"
	amputation_point = "neck"
	gendered_icon = 1
	encased = "skull"
	artery_name = "cartoid artery"

	var/can_intake_reagents = 1
	var/eye_icon = "eyes_s"
	var/has_lips

/obj/item/organ/external/head/get_agony_multiplier()
	return (owner && owner.headcheck(organ_tag)) ? 1.50 : 1

/obj/item/organ/external/head/robotize(var/company, var/skip_prosthetics, var/keep_organs)
	if(company)
		var/datum/robolimb/R = all_robolimbs[company]
		if(R)
			can_intake_reagents = R.can_eat
			eye_icon = R.use_eye_icon
	. = ..(company, skip_prosthetics, 1)
	has_lips = null

/obj/item/organ/external/head/removed()
	if(owner)
		name = "[owner.real_name]'s head"
		owner.drop_from_inventory(owner.glasses)
		owner.drop_from_inventory(owner.head)
		owner.drop_from_inventory(owner.l_ear)
		owner.drop_from_inventory(owner.r_ear)
		owner.drop_from_inventory(owner.wear_mask)
		spawn(1)
			owner.update_hair()
	..()

/obj/item/organ/external/head/take_damage(brute, burn, damage_flags, used_weapon = null)
	. = ..()
	if (!disfigured)
		if (brute_dam > 40)
			if (prob(50))
				disfigure("brute")
		if (burn_dam > 40)
			disfigure("burn")

/obj/item/organ/external/head/no_eyes
	eye_icon = "blank_eyes"

/obj/item/organ/external/head/update_icon()

	..()

	if(owner)
		if(eye_icon)
			var/icon/eyes_icon = new/icon('icons/mob/human_face.dmi', eye_icon)
			var/obj/item/organ/internal/eyes/eyes = owner.internal_organs_by_name[owner.species.vision_organ ? owner.species.vision_organ : BP_EYES]
			if(eyes)
				eyes_icon.Blend(rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3]), ICON_ADD)
			else
				eyes_icon.Blend(rgb(128,0,0), ICON_ADD)
			mob_icon.Blend(eyes_icon, ICON_OVERLAY)
			overlays |= eyes_icon

		if(owner.lip_style && robotic < ORGAN_ROBOT && (species && (species.appearance_flags & HAS_LIPS)))
			var/icon/lip_icon = new/icon('icons/mob/human_face.dmi', "lips_[owner.lip_style]_s")
			overlays |= lip_icon
			mob_icon.Blend(lip_icon, ICON_OVERLAY)

		overlays |= get_hair_icon()

	return mob_icon

/obj/item/organ/external/head/proc/get_hair_icon()
	var/image/res = image('icons/mob/human_face.dmi',"bald_s")
	if(owner.f_style)
		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[owner.f_style]
		if(facial_hair_style && facial_hair_style.species_allowed && (species.get_bodytype(owner) in facial_hair_style.species_allowed))
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_colouration)
				facial_s.Blend(rgb(owner.r_facial, owner.g_facial, owner.b_facial), ICON_ADD)
			res.overlays |= facial_s

	if(owner.h_style)
		var/style = owner.h_style
		var/datum/sprite_accessory/hair/hair_style = hair_styles_list[style]
		if(owner.head && (owner.head.flags_inv & BLOCKHEADHAIR))
			if(!hair_style.veryshort)
				hair_style = hair_styles_list["Short Hair"]
		if(hair_style && (species.get_bodytype(owner) in hair_style.species_allowed))
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration && islist(h_col) && h_col.len >= 3)
				hair_s.Blend(rgb(h_col[1], h_col[2], h_col[3]), ICON_ADD)
			res.overlays |= hair_s
	return res