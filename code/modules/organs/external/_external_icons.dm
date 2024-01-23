var/global/list/limb_icon_cache = list()

/// Layer for bodyparts that should appear behind every other bodypart - Mostly, legs when facing WEST or EAST
#define BODYPARTS_LOW_LAYER -2

/obj/item/organ/external/set_dir()
	return

/obj/item/organ/external/proc/compile_icon()
	ClearOverlays()
	update_icon()

/obj/item/organ/external/proc/sync_colour_to_human(mob/living/carbon/human/human)
	skin_tone = null
	s_col = null
	base_skin = ""
	h_col = rgb2num(human.head_hair_color)
	if(BP_IS_ROBOTIC(src) && !(human.species.appearance_flags & SPECIES_APPEARANCE_HAS_BASE_SKIN_COLOURS))
		var/datum/robolimb/franchise = all_robolimbs[model]
		if(!(franchise && franchise.skintone))
			return
	if(species && human.species && species.name != human.species.name)
		return
	if(!isnull(human.skin_tone) && (human.species.appearance_flags & SPECIES_APPEARANCE_HAS_A_SKIN_TONE))
		skin_tone = human.skin_tone
	if(!isnull(human.base_skin) && (human.species.appearance_flags & SPECIES_APPEARANCE_HAS_BASE_SKIN_COLOURS))
		base_skin = human.base_skin
	if(human.species.appearance_flags & SPECIES_APPEARANCE_HAS_SKIN_COLOR)
		s_col = rgb2num(human.skin_color)

/obj/item/organ/external/proc/sync_colour_to_dna()
	skin_tone = null
	s_col = null
	base_skin = dna.base_skin
	h_col = list(dna.GetUIValue(DNA_UI_HAIR_R),dna.GetUIValue(DNA_UI_HAIR_G),dna.GetUIValue(DNA_UI_HAIR_B))
	if(BP_IS_ROBOTIC(src))
		var/datum/robolimb/franchise = all_robolimbs[model]
		if(!(franchise && franchise.skintone))
			return
	if(!isnull(dna.GetUIValue(DNA_UI_SKIN_TONE)) && (species.appearance_flags & SPECIES_APPEARANCE_HAS_A_SKIN_TONE))
		skin_tone = dna.GetUIValue(DNA_UI_SKIN_TONE)
	if(species.appearance_flags & SPECIES_APPEARANCE_HAS_SKIN_COLOR)
		s_col = list(dna.GetUIValue(DNA_UI_SKIN_R), dna.GetUIValue(DNA_UI_SKIN_G), dna.GetUIValue(DNA_UI_SKIN_B))

/obj/item/organ/external/head/sync_colour_to_human(mob/living/carbon/human/human)
	..()
	var/obj/item/organ/internal/eyes/eyes = owner.internal_organs_by_name[BP_EYES]
	if(eyes) eyes.update_colour()

/obj/item/organ/external/head/removed()
	update_icon(1)
	if(owner)
		SetName("[owner.real_name]'s head")
		addtimer(new Callback(owner, /mob/living/carbon/human/proc/update_hair), 1, TIMER_UNIQUE)
	..()

/obj/item/organ/external/proc/get_icon_key()
	RETURN_TYPE(/list)
	. = list()

	var/gender = "_m"
	if(!(limb_flags & ORGAN_FLAG_GENDERED_ICON))
		gender = null
	else if (dna && dna.GetUIState(DNA_UI_GENDER))
		gender = "_f"
	else if(owner && owner.gender == FEMALE)
		gender = "_f"

	. += "[gender]-"
	. += "[organ_tag]-"
	. += "[species.get_race_key(owner)]"

	if(species.base_skin_colours && !isnull(species.base_skin_colours[base_skin]))
		. += "-[species.base_skin_colours[base_skin]]"

	if(force_icon)
		. += "[force_icon]"
	else if (BP_IS_ROBOTIC(src))
		. += "robot"
	else if (status & ORGAN_MUTATED)
		. += "deformed"
	else if (owner && (MUTATION_SKELETON in owner.mutations))
		. += "skeleton"
	else if (owner && (MUTATION_HUSK in owner.mutations))
		. += "husk"

	//Colour, maybe simplify this one day and actually calculate it once
	if(status & ORGAN_DEAD)
		. += "_dead"

	if(skin_tone)
		. += "_tone_[skin_tone]"

	if(species.appearance_flags & SPECIES_APPEARANCE_HAS_SKIN_COLOR)
		if(s_col && length(s_col) >= 3)
			. += "_color_[s_col[1]]_[s_col[2]]_[s_col[3]]_[s_col_blend]"

	for(var/E in markings)
		var/datum/sprite_accessory/marking/M = E
		if (M.draw_target == MARKING_TARGET_SKIN)
			. += "-[M.name][markings[E]]"

	if(body_hair && islist(h_col) && length(h_col) >= 3)
		. += "[body_hair]-[icon_name]-[h_col[1]][h_col[2]][h_col[3]]"

	if(model)
		. += "_model_[model]"

	if(is_stump())
		. += "-stump"

	return .

/obj/item/organ/external/on_update_icon(regenerate = 0)
	ClearOverlays()
	mob_overlays = list()

	var/husk_color_mod = rgb(96,88,80)
	var/husk = owner && (MUTATION_HUSK in owner.mutations)

	var/gender = "_m"
	if(!(limb_flags & ORGAN_FLAG_GENDERED_ICON))
		gender = null
	else if (dna && dna.GetUIState(DNA_UI_GENDER))
		gender = "_f"
	else if(owner && owner.gender == FEMALE)
		gender = "_f"


	var/chosen_icon = ""
	var/chosen_icon_state = ""

	chosen_icon_state = "[icon_name][gender]"
	if(species.base_skin_colours && !isnull(species.base_skin_colours[base_skin]))
		chosen_icon_state += species.base_skin_colours[base_skin]

	if(force_icon)
		chosen_icon = force_icon
	else if (BP_IS_ROBOTIC(src))
		chosen_icon = 'icons/mob/human_races/cyberlimbs/robotic.dmi'
	else if (!dna)
		chosen_icon = 'icons/mob/human_races/species/human/body.dmi'
	else if (status & ORGAN_MUTATED)
		chosen_icon = species.deform
	else if (owner && (MUTATION_SKELETON in owner.mutations))
		chosen_icon = 'icons/mob/human_races/species/human/skeleton.dmi'
	else
		chosen_icon = species.get_icobase(owner)

	var/icon/mob_icon = apply_colouration(new/icon(chosen_icon, chosen_icon_state))

	if (husk)
		mob_icon.ColorTone(husk_color_mod)

	//Handle husk overlay.
	if(husk)
		var/husk_icon = species.get_husk_icon(src)
		if(husk_icon)
			var/icon/mask = new/icon(chosen_icon)
			var/blood = species.get_blood_colour(owner)
			var/icon/husk_over = new(species.husk_icon,"")
			mask.MapColors(0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,0)
			husk_over.Blend(mask, ICON_ADD)
			husk_over.Blend(blood, ICON_MULTIPLY)
			mob_icon.Blend(husk_over, ICON_OVERLAY)

	var/list/sorted = list()
	for(var/E in markings)
		var/datum/sprite_accessory/marking/M = E
		if (M.draw_target == MARKING_TARGET_SKIN)
			var/color = markings[E]
			var/state = M.icon_state
			if (M.use_organ_tag)
				state = "[state]-[organ_tag]"
			var/icon/I = icon(M.icon, state)
			I.Blend(color, M.blend)
			ADD_SORTED(sorted, list(list(M.draw_order, I, M)), /proc/cmp_marking_order)

	for (var/entry in sorted) //Revisit this with blendmodes
		mob_icon.Blend(entry[2], entry[3]["layer_blend"])

	if(body_hair && islist(h_col) && length(h_col) >= 3)
		var/cache_key = "[body_hair]-[icon_name]-[h_col[1]][h_col[2]][h_col[3]]"
		if(!limb_icon_cache[cache_key])
			var/icon/I = icon(species.get_icobase(owner), "[icon_name]_[body_hair]")
			I.Blend(rgb(h_col[1],h_col[2],h_col[3]), ICON_ADD)
		mob_icon.Blend(limb_icon_cache[cache_key], ICON_OVERLAY)

	//Fix leg layering here
	//Alternatively you could use masks but it's about same amount of work
	//Note: This really only works because everything up until now was icon ops to build an icon we can work with
	// If we ever move to pure overlays for body hair / modifiers / cosmetic changes to a limb, look up daedalusdock's implementation
	if(icon_position & (LEFT | RIGHT))
		var/icon/under_icon = new('icons/mob/human.dmi',"blank")
		under_icon.Insert(new/icon(mob_icon,dir=NORTH),dir=NORTH)
		under_icon.Insert(new/icon(mob_icon,dir=SOUTH),dir=SOUTH)
		if(!(icon_position & LEFT))
			under_icon.Insert(new/icon(mob_icon,dir=EAST),dir=EAST)
		if(!(icon_position & RIGHT))
			under_icon.Insert(new/icon(mob_icon,dir=WEST),dir=WEST)
		//At this point, the icon has all the valid states for both left and right leg overlays
		var/mutable_appearance/upper_appearance = mutable_appearance(under_icon, chosen_icon_state, flags = DEFAULT_APPEARANCE_FLAGS)
		upper_appearance.layer = FLOAT_LAYER
		mob_overlays += upper_appearance

		if(icon_position & LEFT)
			under_icon.Insert(new/icon(mob_icon,dir=EAST),dir=EAST)
		if(icon_position & RIGHT)
			under_icon.Insert(new/icon(mob_icon,dir=WEST),dir=WEST)

		var/mutable_appearance/under_appearance = mutable_appearance(under_icon, chosen_icon_state, flags = DEFAULT_APPEARANCE_FLAGS)
		upper_appearance.layer = BODYPARTS_LOW_LAYER
		mob_overlays += under_appearance
	else
		var/mutable_appearance/limb_appearance = mutable_appearance(mob_icon, chosen_icon_state, flags = DEFAULT_APPEARANCE_FLAGS)
		if(icon_position & UNDER)
			limb_appearance.layer = BODYPARTS_LOW_LAYER
		mob_overlays += limb_appearance

	if(blocks_emissive)
		var/mutable_appearance/limb_em_block = emissive_blocker(chosen_icon, chosen_icon_state, FLOAT_LAYER)
		limb_em_block.dir = dir
		mob_overlays += limb_em_block

	AddOverlays(mob_overlays)

	dir = EAST
	icon = null

/obj/item/organ/external/proc/get_overlays()
	update_icon()
	return mob_overlays

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
		var/cache_key = "dambase-[json_encode(get_icon_key())]"
		if(!cache_key || !limb_icon_cache[cache_key])
			var/list/appearances = get_overlays()
			for(var/image/I as anything in appearances) //Mutable appearances are a type of image
				I.dir = SOUTH
				I.icon_state = null
				if(species)
				// Calculate the required colour matrix.
					var/r = 0.30 * species.health_hud_intensity
					var/g = 0.59 * species.health_hud_intensity
					var/b = 0.11 * species.health_hud_intensity
					I.color = list(r, r, r, g, g, g, b, b, b)
				I.pixel_x = owner.default_pixel_x
				I.pixel_y = owner.default_pixel_y
			limb_icon_cache[cache_key] = appearances
		var/list/appearances = limb_icon_cache[cache_key]
		hud_damage_image = image(null)
		hud_damage_image.AddOverlays(appearances)

	// Calculate the required color index.
	var/dam_state = min(1,((brute_dam+burn_dam)/max(1,max_damage)))
	var/min_dam_state = min(1,(get_pain()/max(1,max_damage)))
	if(min_dam_state && dam_state < min_dam_state)
		dam_state = min_dam_state
	// Apply colour and return product.
	var/list/hud_colours = !BP_IS_ROBOTIC(src) ? flesh_hud_colours : robot_hud_colours
	hud_damage_image.color = hud_colours[max(1,min(ceil(dam_state*length(hud_colours)),length(hud_colours)))]
	return hud_damage_image

/obj/item/organ/external/proc/apply_colouration(icon/applying)

	if(species.limbs_are_nonsolid)
		applying.MapColors("#4d4d4d","#969696","#1c1c1c", "#000000")
		if(species && species.get_bodytype(owner) != SPECIES_HUMAN)
			applying.SetIntensity(1.5)
		else
			applying.SetIntensity(0.7)
		applying += rgb(,,,180) // Makes the icon translucent, SO INTUITIVE TY BYOND

	else if(status & ORGAN_DEAD)
		applying.ColorTone(rgb(10,50,0))
		applying.SetIntensity(0.7)

	if(skin_tone)
		if(skin_tone >= 0)
			applying.Blend(rgb(skin_tone, skin_tone, skin_tone), ICON_ADD)
		else
			applying.Blend(rgb(-skin_tone,  -skin_tone,  -skin_tone), ICON_SUBTRACT)
	if(species.appearance_flags & SPECIES_APPEARANCE_HAS_SKIN_COLOR)
		if(s_col && length(s_col) >= 3)
			applying.Blend(rgb(s_col[1], s_col[2], s_col[3]), s_col_blend)

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
