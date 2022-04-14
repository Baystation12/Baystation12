var/global/list/limb_icon_cache = list()

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
	s_base = ""
	h_col = list(human.r_hair, human.g_hair, human.b_hair)
	if(BP_IS_ROBOTIC(src) && !(human.species.appearance_flags & HAS_BASE_SKIN_COLOURS))
		var/datum/robolimb/franchise = all_robolimbs[model]
		if(!(franchise && franchise.skintone))
			return
	if(species && human.species && species.name != human.species.name)
		return
	if(!isnull(human.s_tone) && (human.species.appearance_flags & HAS_A_SKIN_TONE))
		s_tone = human.s_tone
	if(!isnull(human.s_base) && (human.species.appearance_flags & HAS_BASE_SKIN_COLOURS))
		s_base = human.s_base
	if(human.species.appearance_flags & HAS_SKIN_COLOR)
		s_col = list(human.r_skin, human.g_skin, human.b_skin)

/obj/item/organ/external/proc/sync_colour_to_dna()
	s_tone = null
	s_col = null
	s_base = dna.s_base
	h_col = list(dna.GetUIValue(DNA_UI_HAIR_R),dna.GetUIValue(DNA_UI_HAIR_G),dna.GetUIValue(DNA_UI_HAIR_B))
	if(BP_IS_ROBOTIC(src))
		var/datum/robolimb/franchise = all_robolimbs[model]
		if(!(franchise && franchise.skintone))
			return
	if(!isnull(dna.GetUIValue(DNA_UI_SKIN_TONE)) && (species.appearance_flags & HAS_A_SKIN_TONE))
		s_tone = dna.GetUIValue(DNA_UI_SKIN_TONE)
	if(species.appearance_flags & HAS_SKIN_COLOR)
		s_col = list(dna.GetUIValue(DNA_UI_SKIN_R), dna.GetUIValue(DNA_UI_SKIN_G), dna.GetUIValue(DNA_UI_SKIN_B))

/obj/item/organ/external/head/sync_colour_to_human(var/mob/living/carbon/human/human)
	..()
	var/obj/item/organ/internal/eyes/eyes = owner.internal_organs_by_name[BP_EYES]
	if(eyes) eyes.update_colour()

/obj/item/organ/external/head/removed()
	update_icon(1)
	if(owner)
		SetName("[owner.real_name]'s head")
		addtimer(CALLBACK(owner, /mob/living/carbon/human/proc/update_hair), 1, TIMER_UNIQUE)
	..()

	var/list/sorted = list()
	for(var/E in markings)
		var/datum/sprite_accessory/marking/M = E
		if (M.draw_target == MARKING_TARGET_SKIN)
			var/color = markings[E]
			var/icon/I = icon(M.icon, "[M.icon_state]-[organ_tag]")
			I.Blend(color, M.blend)
			icon_cache_key += "[M.name][color]"
			ADD_SORTED(sorted, list(list(M.draw_order, I, M)), /proc/cmp_marking_order)
	for (var/entry in sorted)
		overlays |= entry[2]
		mob_icon.Blend(entry[2], entry[3]["layer_blend"])

/obj/item/organ/external/var/icon_cache_key
/obj/item/organ/external/on_update_icon(var/regenerate = 0)
	var/gender = "_m"
	if(!(limb_flags & ORGAN_FLAG_GENDERED_ICON))
		gender = null
	else if (dna && dna.GetUIState(DNA_UI_GENDER))
		gender = "_f"
	else if(owner && owner.gender == FEMALE)
		gender = "_f"

	icon_state = "[icon_name][gender]"
	if(species.base_skin_colours && !isnull(species.base_skin_colours[s_base]))
		icon_state += species.base_skin_colours[s_base]

	icon_cache_key = "[icon_state]_[species ? species.name : SPECIES_HUMAN]"

	if(force_icon)
		icon = force_icon
	else if (BP_IS_ROBOTIC(src))
		icon = 'icons/mob/human_races/cyberlimbs/robotic.dmi'
	else if (!dna)
		icon = 'icons/mob/human_races/species/human/body.dmi'
	else if (status & ORGAN_MUTATED)
		icon = species.deform
	else if (owner && (MUTATION_SKELETON in owner.mutations))
		icon = 'icons/mob/human_races/species/human/skeleton.dmi'
	else
		icon = species.get_icobase(owner)

	mob_icon = apply_colouration(new/icon(icon, icon_state))

	var/list/sorted = list()
	for(var/E in markings)
		var/datum/sprite_accessory/marking/M = E
		if (M.draw_target == MARKING_TARGET_SKIN)
			var/color = markings[E]
			var/icon/I = icon(M.icon, "[M.icon_state]-[organ_tag]")
			I.Blend(color, M.blend)
			icon_cache_key += "[M.name][color]"
			ADD_SORTED(sorted, list(list(M.draw_order, I, M)), /proc/cmp_marking_order)
	for (var/entry in sorted)
		overlays |= entry[2]
		mob_icon.Blend(entry[2], entry[3]["layer_blend"])

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

/obj/item/organ/external/proc/get_icon()
	update_icon()
	return mob_icon

// Returns an image for use by the human health dolly HUD element.
// If the limb is in pain, it will be used as a minimum damage
// amount to represent the obfuscation of being in agonizing pain.

// Global scope, used in code below.
var/global/list/flesh_hud_colours = list("#00ff00","#aaff00","#ffff00","#ffaa00","#ff0000","#aa0000","#660000")
var/global/list/robot_hud_colours = list("#ffffff","#cccccc","#aaaaaa","#888888","#666666","#444444","#222222","#000000")

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
		temp.pixel_x = owner.default_pixel_x
		temp.pixel_y = owner.default_pixel_y
		hud_damage_image = image(null)
		hud_damage_image.overlays += temp

	// Calculate the required color index.
	var/dam_state = min(1,((brute_dam+burn_dam)/max(1,max_damage)))
	var/min_dam_state = min(1,(get_pain()/max(1,max_damage)))
	if(min_dam_state && dam_state < min_dam_state)
		dam_state = min_dam_state
	// Apply colour and return product.
	var/list/hud_colours = !BP_IS_ROBOTIC(src) ? flesh_hud_colours : robot_hud_colours
	hud_damage_image.color = hud_colours[max(1,min(Ceil(dam_state*hud_colours.len),hud_colours.len))]
	return hud_damage_image

/obj/item/organ/external/proc/apply_colouration(var/icon/applying)

	if(species.limbs_are_nonsolid)
		applying.MapColors("#4d4d4d","#969696","#1c1c1c", "#000000")
		if(species && species.get_bodytype(owner) != SPECIES_HUMAN)
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
	if(species.appearance_flags & HAS_SKIN_COLOR)
		if(s_col && s_col.len >= 3)
			applying.Blend(rgb(s_col[1], s_col[2], s_col[3]), s_col_blend)
			icon_cache_key += "_color_[s_col[1]]_[s_col[2]]_[s_col[3]]_[s_col_blend]"

	return applying

/obj/item/organ/external/proc/bandage_level()
	if(damage_state_text() == "00") 
		return 0
	if(!is_bandaged())
		return 0
	if(burn_dam + brute_dam == 0)
		. = 0
	else if (burn_dam + brute_dam < (max_damage * 0.25 / 2))
		. = 1
	else if (burn_dam + brute_dam < (max_damage * 0.75 / 2))
		. = 2
	else
		. = 3