var/list/limb_icon_cache = list()

/obj/item/organ/external/set_dir()
	return

/obj/item/organ/external/proc/compile_icon()
	overlays.Cut()
	 // This is a kludge, only one icon has more than one generation of children though.
	for(var/obj/item/organ/external/organ in contents)
		if(organ.children && organ.children.len)
			for(var/obj/item/organ/external/child in organ.children)
				overlays += child.mob_icon
		overlays += organ.mob_icon

/obj/item/organ/external/proc/sync_colour_to_human(var/mob/living/carbon/human/human)
	s_tone = null
	s_col = null
	h_col = list(human.r_hair, human.g_hair, human.b_hair)
	if(robotic >= ORGAN_ROBOT)
		var/datum/robolimb/franchise = all_robolimbs[model]
		if(!(franchise && franchise.skintone))
			return
	if(species && human.species && species.name != human.species.name)
		return
	if(!isnull(human.s_tone) && (human.species.appearance_flags & HAS_SKIN_TONE))
		s_tone = human.s_tone
	if(human.species.appearance_flags & HAS_SKIN_COLOR)
		s_col = list(human.r_skin, human.g_skin, human.b_skin)

/obj/item/organ/external/proc/sync_colour_to_dna()
	s_tone = null
	s_col = null
	h_col = list(dna.GetUIValue(DNA_UI_HAIR_R),dna.GetUIValue(DNA_UI_HAIR_G),dna.GetUIValue(DNA_UI_HAIR_B))
	if(robotic >= ORGAN_ROBOT)
		var/datum/robolimb/franchise = all_robolimbs[model]
		if(!(franchise && franchise.skintone))
			return
	if(!isnull(dna.GetUIValue(DNA_UI_SKIN_TONE)) && (species.appearance_flags & HAS_SKIN_TONE))
		s_tone = dna.GetUIValue(DNA_UI_SKIN_TONE)
	if(species.appearance_flags & HAS_SKIN_COLOR)
		s_col = list(dna.GetUIValue(DNA_UI_SKIN_R), dna.GetUIValue(DNA_UI_SKIN_G), dna.GetUIValue(DNA_UI_SKIN_B))

/obj/item/organ/external/head/sync_colour_to_human(var/mob/living/carbon/human/human)
	..()
	var/obj/item/organ/internal/eyes/eyes = owner.internal_organs_by_name[BP_EYES]
	if(eyes) eyes.update_colour()

/obj/item/organ/external/head/removed()
	update_icon(1)
	..()

/obj/item/organ/external/var/icon_cache_key
/obj/item/organ/external/update_icon(var/regenerate = 0)
	var/gender = "_m"
	if(!gendered_icon)
		gender = null
	else if (dna && dna.GetUIState(DNA_UI_GENDER))
		gender = "_f"
	else if(owner && owner.gender == FEMALE)
		gender = "_f"

	icon_state = "[icon_name][gender]"
	icon_cache_key = "[icon_state]_[species ? species.name : "Human"]"

	if(force_icon)
		icon = force_icon
	else if (!dna)
		icon = 'icons/mob/human_races/r_human.dmi'
	else if (robotic >= ORGAN_ROBOT)
		icon = 'icons/mob/human_races/robotic.dmi'
	else if (status & ORGAN_MUTATED)
		icon = species.deform
	else if (owner && (SKELETON in owner.mutations))
		icon = 'icons/mob/human_races/r_skeleton.dmi'
	else
		icon = species.get_icobase(owner)

	mob_icon = apply_colouration(new/icon(icon, icon_state))

	if(body_hair && islist(h_col) && h_col.len >= 3)
		var/cache_key = "[body_hair]-[icon_name]-[h_col[1]][h_col[2]][h_col[3]]"
		if(!limb_icon_cache[cache_key])
			var/icon/I = icon(species.get_icobase(owner), "[icon_name]_[body_hair]")
			I.Blend(rgb(h_col[1],h_col[2],h_col[3]), ICON_ADD)
			limb_icon_cache[cache_key] = I
		mob_icon.Blend(limb_icon_cache[cache_key], ICON_OVERLAY)

	if(model)
		icon_cache_key += "_model_[model]"
	dir = EAST
	icon = mob_icon

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


/obj/item/organ/external/proc/get_icon()
	update_icon()
	return mob_icon

// Returns an image for use by the human health dolly HUD element.
// If the limb is in pain, it will be used as a minimum damage
// amount to represent the obfuscation of being in agonizing pain.

// Global scope, used in code below.
var/list/flesh_hud_colours = list("#00FF00","#AAFF00","#FFFF00","#FFAA00","#FF0000","#AA0000","#660000")
var/list/robot_hud_colours = list("#FFFFFF","#CCCCCC","#AAAAAA","#888888","#666666","#444444","#222222","#000000")

/obj/item/organ/external/proc/get_damage_hud_image()

	// Generate the greyscale base icon and cache it for later.
	// icon_cache_key is set by any get_icon() calls that are made.
	// This looks convoluted, but it's this way to avoid icon proc calls.
	if(!hud_damage_image)
		var/cache_key = "dambase-[icon_cache_key]"
		if(!icon_cache_key || !limb_icon_cache[cache_key])
			limb_icon_cache[cache_key] = icon(get_icon(), null, SOUTH)
		var/image/temp = image(limb_icon_cache[cache_key])
		if(species)
			// Calculate the required colour matrix.
			var/r = 0.30 * species.health_hud_intensity
			var/g = 0.59 * species.health_hud_intensity
			var/b = 0.11 * species.health_hud_intensity
			temp.color = list(r, r, r, g, g, g, b, b, b)
		hud_damage_image = image(null)
		hud_damage_image.overlays += temp


	// Calculate the required color index.
	var/dam_state = min(1,((brute_dam+burn_dam)/max(1,max_damage)))
	var/min_dam_state = min(1,(get_pain()/max(1,max_damage)))
	if(min_dam_state && dam_state < min_dam_state)
		dam_state = min_dam_state
	// Apply colour and return product.
	var/list/hud_colours = (robotic < ORGAN_ROBOT) ? flesh_hud_colours : robot_hud_colours
	hud_damage_image.color = hud_colours[max(1,min(ceil(dam_state*hud_colours.len),hud_colours.len))]
	return hud_damage_image

/obj/item/organ/external/proc/apply_colouration(var/icon/applying)

	if(nonsolid)
		applying.MapColors("#4D4D4D","#969696","#1C1C1C", "#000000")
		if(species && species.get_bodytype(owner) != "Human")
			applying.SetIntensity(1.5)
		else
			applying.SetIntensity(0.7)
		applying += rgb(,,,180) // Makes the icon translucent, SO INTUITIVE TY BYOND

	else if(status & ORGAN_DEAD)
		icon_cache_key += "_dead"
		applying.ColorTone(rgb(10,50,0))
		applying.SetIntensity(0.7)

	if(s_tone)
		if(s_tone >= 0)
			applying.Blend(rgb(s_tone, s_tone, s_tone), ICON_ADD)
		else
			applying.Blend(rgb(-s_tone,  -s_tone,  -s_tone), ICON_SUBTRACT)
		icon_cache_key += "_tone_[s_tone]"
	else
		if(s_col && s_col.len >= 3)
			applying.Blend(rgb(s_col[1], s_col[2], s_col[3]), ICON_ADD)
			icon_cache_key += "_color_[s_col[1]]_[s_col[2]]_[s_col[3]]"

	return applying

