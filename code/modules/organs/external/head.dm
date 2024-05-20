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
	if(glowing_eyes && owner)
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
		to_chat(user, SPAN_NOTICE("It has \"[forehead_graffiti]\" written on it in [graffiti_style]!"))

/obj/item/organ/external/head/proc/write_on(mob/penman, style)
	var/head_name = name
	var/atom/target = src
	if(owner)
		head_name = "[owner]'s [name]"
		target = owner

	if(forehead_graffiti)
		to_chat(penman, SPAN_NOTICE("There is no room left to write on [head_name]!"))
		return

	var/graffiti = sanitizeSafe(input(penman, "Enter a message to write on [head_name]:") as text|null, MAX_NAME_LEN)
	if(graffiti)
		if(!target.Adjacent(penman))
			to_chat(penman, SPAN_NOTICE("[head_name] is too far away."))
			return

		if(owner && owner.check_head_coverage())
			to_chat(penman, SPAN_NOTICE("[head_name] is covered up."))
			return

		penman.visible_message(SPAN_WARNING("[penman] begins writing something on [head_name]!"), "You begin writing something on [head_name].")

		if(do_after(penman, 3 SECONDS, target, DO_PUBLIC_UNIQUE))
			if(owner && owner.check_head_coverage())
				to_chat(penman, SPAN_NOTICE("[head_name] is covered up."))
				return

			penman.visible_message(SPAN_WARNING("[penman] writes something on [head_name]!"), "You write something on [head_name].")
			forehead_graffiti = graffiti
			graffiti_style = style

/obj/item/organ/external/head/get_agony_multiplier()
	return (owner && owner.headcheck(organ_tag)) ? 1.50 : 1

/obj/item/organ/external/head/robotize(company, skip_prosthetics, keep_organs)
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

/obj/item/organ/external/head/get_icon_key()
	. = ..()

	if(owner?.makeup_style && !BP_IS_ROBOTIC(src) && (species && (species.appearance_flags & SPECIES_APPEARANCE_HAS_LIPS)))
		. += "[owner.makeup_style]"
	else
		. += "nolips"

	var/obj/item/organ/internal/eyes/eyes = owner.internal_organs_by_name[owner.species.vision_organ ? owner.species.vision_organ : BP_EYES]
	if(eyes)
		. += "[rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3])]"

/obj/item/organ/external/head/on_update_icon()
	..()

	if(owner)
		// Base eye icon.
		if(draw_eyes)
			var/icon/I = get_eyes()
			if(I)
				var/mutable_appearance/eye_appearance = mutable_appearance(I, flags = DEFAULT_APPEARANCE_FLAGS)
				mob_overlays |= eye_appearance

			// Floating eyes or other effects.
			var/image/eye_glow = get_eye_overlay()
			if(eye_glow)
				AddOverlays(eye_glow)

		if(owner.makeup_style && !BP_IS_ROBOTIC(src) && (species && (species.appearance_flags & SPECIES_APPEARANCE_HAS_LIPS)))
			var/mutable_appearance/lip_appearance = mutable_appearance('icons/mob/human_races/species/human/lips.dmi', "lips_[owner.makeup_style]_s",flags = DEFAULT_APPEARANCE_FLAGS)
			mob_overlays |= lip_appearance

	SetOverlays(mob_overlays)
	var/hair_icon = get_hair_icon()
	AddOverlays(hair_icon)

/obj/item/organ/external/head/proc/get_hair_icon()
	var/image/res = image(species.icon_template,"")
	if(owner?.facial_hair_style)
		var/datum/sprite_accessory/facial_hair_style = GLOB.facial_hair_styles_list[owner.facial_hair_style]
		if(facial_hair_style)
			if(!facial_hair_style.species_allowed || (species.get_bodytype(owner) in facial_hair_style.species_allowed))
				if(!facial_hair_style.subspecies_allowed || (species.name in facial_hair_style.subspecies_allowed))
					var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
					if(facial_hair_style.do_coloration & DO_COLORATION_USER)
						facial_s.Blend(owner.facial_hair_color, facial_hair_style.blend)
					res.AddOverlays(facial_s)

	if (owner?.head_hair_style)
		var/icon/HI
		var/datum/sprite_accessory/hair/H = GLOB.hair_styles_list[owner.head_hair_style]
		if ((owner.head?.flags_inv & BLOCKHEADHAIR) && !(H.flags & VERY_SHORT))
			H = GLOB.hair_styles_list["Short Hair"]
		if (H)
			if (!length(H.species_allowed) || (species.get_bodytype(owner) in H.species_allowed))
				if (!length(H.subspecies_allowed) || (species.name in H.subspecies_allowed))
					HI = icon(H.icon, "[H.icon_state]_s")
					if ((H.do_coloration & DO_COLORATION_USER) && length(h_col) >= 3)
						HI.Blend(rgb(h_col[1], h_col[2], h_col[3]), H.blend)
		if (HI)
			var/list/sorted_hair_markings = list()
			for (var/E in markings)
				var/datum/sprite_accessory/marking/M = E
				if (M.draw_target == MARKING_TARGET_HAIR)
					var/color = markings[E]
					var/icon/I = icon(M.icon, M.icon_state)
					if(istype(M, /datum/sprite_accessory/marking/hair_fade))
						I.Blend(HI, ICON_AND)
					I.Blend(color, M.blend)
					ADD_SORTED(sorted_hair_markings, list(list(M.draw_order, I)), GLOBAL_PROC_REF(cmp_marking_order))
			for (var/entry in sorted_hair_markings)
				HI.Blend(entry[2], ICON_OVERLAY)
			//TODO : Add emissive blocker here if hair should block it. Else, leave as is
			res.AddOverlays(HI)

	var/list/sorted_head_markings = list()
	for (var/E in markings)
		var/datum/sprite_accessory/marking/M = E
		if (M.draw_target == MARKING_TARGET_HEAD)
			var/color = markings[E]
			var/icon/I = icon(M.icon, M.icon_state)
			if ((M.do_coloration & DO_COLORATION_AUTO) && owner.head_hair_style)
				var/datum/sprite_accessory/hair/H = GLOB.hair_styles_list[owner.head_hair_style]
				if ((~H.flags & HAIR_BALD) && (M.do_coloration & DO_COLORATION_HAIR) && length(h_col) >= 3)
					I.MapColors(
						1,0,0,0,
						0,1,0,0,
						0,0,1,0,
						0,0,0,1,
						h_col[1] / 255, h_col[2] / 255, h_col[3] / 255, 0
					)
				else if (M.do_coloration & DO_COLORATION_SKIN)
					I.MapColors(
						1,0,0,0,
						0,1,0,0,
						0,0,1,0,
						0,0,0,1,
						(200 + skin_tone) / 255, (150 + skin_tone) / 255, (123 + skin_tone) / 255, 0
					)
			else
				var/list/rgb = rgb2num(color)
				I.MapColors(
					1,0,0,0,
					0,1,0,0,
					0,0,1,0,
					0,0,0,1,
					rgb[1] / 255, rgb[2] / 255, rgb[3] / 255, 0
				)
			ADD_SORTED(sorted_head_markings, list(list(M.draw_order, I)), GLOBAL_PROC_REF(cmp_marking_order))
	for (var/entry in sorted_head_markings)
		res.AddOverlays(entry[2])

	return res

/obj/item/organ/external/head/no_eyes
	draw_eyes = FALSE
