/obj/item/organ/external/head
	organ_tag = BP_HEAD
	icon_name = "head"
	name = "head"
	slot_flags = SLOT_BELT
	max_damage = 75
	min_broken_damage = 35
	w_class = ITEM_SIZE_NORMAL
	cavity_max_w_class = ITEM_SIZE_SMALL
	body_part = HEAD
	parent_organ = BP_CHEST
	joint = "jaw"
	amputation_point = "neck"
	encased = "skull"
	artery_name = "carotid artery"
	cavity_name = "cranial"

	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_GENDERED_ICON | ORGAN_FLAG_HEALS_OVERKILL | ORGAN_FLAG_CAN_BREAK

	var/draw_eyes = TRUE
	var/glowing_eyes = FALSE
	var/can_intake_reagents = 1
	var/has_lips = 1
	var/forehead_graffiti
	var/graffiti_style

/obj/item/organ/external/head/proc/get_eye_overlay()
	if(glowing_eyes)
		var/obj/item/organ/internal/eyes/eyes = owner.internal_organs_by_name[owner.species.vision_organ ? owner.species.vision_organ : BP_EYES]
		if(eyes)
			return eyes.get_special_overlay()

/obj/item/organ/external/head/proc/get_eyes()
	var/obj/item/organ/internal/eyes/eyes = owner.internal_organs_by_name[owner.species.vision_organ ? owner.species.vision_organ : BP_EYES]
	if(eyes)
		return eyes.get_onhead_icon()

/obj/item/organ/external/head/examine(mob/user)
	. = ..()

	if(forehead_graffiti && graffiti_style)
		to_chat(user, "<span class='notice'>It has \"[forehead_graffiti]\" written on it in [graffiti_style]!</span>")

/obj/item/organ/external/head/proc/write_on(var/mob/penman, var/style)
	var/head_name = name
	var/atom/target = src
	if(owner)
		head_name = "[owner]'s [name]"
		target = owner

	if(forehead_graffiti)
		to_chat(penman, "<span class='notice'>There is no room left to write on [head_name]!</span>")
		return

	var/graffiti = sanitizeSafe(input(penman, "Enter a message to write on [head_name]:") as text|null, MAX_NAME_LEN)
	if(graffiti)
		if(!target.Adjacent(penman))
			to_chat(penman, "<span class='notice'>[head_name] is too far away.</span>")
			return

		if(owner && owner.check_head_coverage())
			to_chat(penman, "<span class='notice'>[head_name] is covered up.</span>")
			return

		penman.visible_message("<span class='warning'>[penman] begins writing something on [head_name]!</span>", "You begin writing something on [head_name].")

		if(do_after(penman, 3 SECONDS, target, DO_PUBLIC_UNIQUE))
			if(owner && owner.check_head_coverage())
				to_chat(penman, "<span class='notice'>[head_name] is covered up.</span>")
				return

			penman.visible_message("<span class='warning'>[penman] writes something on [head_name]!</span>", "You write something on [head_name].")
			forehead_graffiti = graffiti
			graffiti_style = style

/obj/item/organ/external/head/get_agony_multiplier()
	return (owner && owner.headcheck(organ_tag)) ? 1.50 : 1

/obj/item/organ/external/head/robotize(var/company, var/skip_prosthetics, var/keep_organs)
	if(company)
		var/datum/robolimb/R = all_robolimbs[company]
		if(R)
			can_intake_reagents = R.can_eat
			draw_eyes = R.has_eyes
	. = ..(company, skip_prosthetics, 1)
	has_lips = null

/obj/item/organ/external/head/take_external_damage(brute, burn, damage_flags, used_weapon = null)
	. = ..()
	if (!(status & ORGAN_DISFIGURED))
		if (brute_dam > 40)
			if (prob(50))
				disfigure(INJURY_TYPE_BRUISE)
		if (burn_dam > 40)
			disfigure(INJURY_TYPE_BURN)

/obj/item/organ/external/head/on_update_icon()

	..()

	if(owner)
		// Base eye icon.
		if(draw_eyes)
			var/icon/I = get_eyes()
			if(I)
				overlays |= I
				mob_icon.Blend(I, ICON_OVERLAY)

			// Floating eyes or other effects.
			var/image/eye_glow = get_eye_overlay()
			if(eye_glow) overlays |= eye_glow

		if(owner.lip_style && !BP_IS_ROBOTIC(src) && (species && (species.appearance_flags & HAS_LIPS)))
			var/icon/lip_icon = new/icon('icons/mob/human_races/species/human/lips.dmi', "lips_[owner.lip_style]_s")
			overlays |= lip_icon
			mob_icon.Blend(lip_icon, ICON_OVERLAY)

		overlays |= get_hair_icon()

	return mob_icon


/obj/item/organ/external/head/proc/get_hair_icon()
	var/list/accessories = list()
	var/datum/sprite_accessory/facial_hair/face_accessory = GLOB.facial_hair_styles_list[owner.f_style]
	var/icon/face_icon
	if (face_accessory && !face_accessory.species_allowed || (species.get_bodytype(owner) in face_accessory.species_allowed))
		face_icon = new (face_accessory.icon, "[face_accessory.icon_state]_s")
		if (face_accessory.do_coloration & DO_COLORATION_USER)
			face_icon.MapColors(
				1,0,0,0,  0,1,0,0,  0,0,1,0,  0,0,0,1,
				owner.r_facial / 255, owner.g_facial / 255, owner.b_facial / 255, 0
			)
		accessories += list(list(face_accessory.draw_order, face_icon))
	var/datum/sprite_accessory/hair/head_accessory = GLOB.hair_styles_list[owner.h_style]
	var/icon/head_icon
	if (head_accessory && !head_accessory.species_allowed || (species.get_bodytype(owner) in head_accessory.species_allowed))
		if ((owner.head?.flags_inv & BLOCKHEADHAIR) && !(head_accessory.flags & VERY_SHORT))
			head_accessory = species.get_default_hair()
		if (head_accessory)
			head_icon = new (head_accessory.icon, "[head_accessory.icon_state]_s")
			if ((head_accessory.do_coloration & DO_COLORATION_USER) && length(h_col) > 2)
				head_icon.MapColors(
					1,0,0,0,  0,1,0,0,  0,0,1,0,  0,0,0,1,
					h_col[1] / 255, h_col[2] / 255, h_col[3] / 255, 0
				)
			ADD_SORTED(accessories, list(list(head_accessory.draw_order, head_icon)), /proc/cmp_marking_order)
	for (var/datum/sprite_accessory/marking/marking as anything in markings)
		var/icon/marking_icon
		var/marking_color = markings[marking]
		if (marking.draw_target == MARKING_TARGET_HAIR)
			if (!head_icon)
				continue
			marking_icon = new (marking.icon, marking.icon_state)
			marking_icon.Blend(head_icon, ICON_AND)
			marking_icon.Blend(marking_color, ICON_MULTIPLY)
		else if (marking.draw_target == MARKING_TARGET_HEAD)
			marking_icon = new (marking.icon, marking.icon_state)
			var/list/rgba
			if (marking.do_coloration & DO_COLORATION_USER)
				rgba = rgb2num(marking_color)
			if (marking.do_coloration & DO_COLORATION_HAIR)
				if (head_icon && !(head_accessory.flags & HAIR_BALD) && length(h_col) > 2)
					rgba = h_col
			if ((marking.do_coloration & DO_COLORATION_SKIN) && !rgba) //intentional
				rgba = species.get_skin_tone_base()
				if (rgba)
					for (var/i = rgba.len to 1 step -1)
						rgba[i] += s_tone
			if (rgba)
				var/alpha = 0
				if (rgba.len > 3)
					alpha = rgba[4]
				marking_icon.MapColors(
					1,0,0,0,  0,1,0,0,  0,0,1,0,  0,0,0,1,
					rgba[1] / 255, rgba[2] / 255, rgba[3] / 255, alpha / 255
				)
		if (marking_icon)
			ADD_SORTED(accessories, list(list(marking.draw_order, marking_icon)), /proc/cmp_marking_order)
			icon_cache_key += "[marking.name][marking_color]"
	var/image/result = image(species.icon_template, "")
	for (var/list/entry as anything in accessories)
		result.overlays += entry[2]
	return result


/obj/item/organ/external/head/no_eyes
	draw_eyes = FALSE
