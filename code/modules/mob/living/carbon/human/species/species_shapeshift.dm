// This is something of an intermediary species used for species that
// need to emulate the appearance of another race. Currently it is only
// used for slimes but it may be useful for changelings later.
var/list/wrapped_species_by_ref = list()

/datum/species/shapeshifter

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_gender
		)

	var/list/valid_transform_species = list()
	var/monochromatic
	var/default_form = SPECIES_HUMAN

/datum/species/shapeshifter/get_valid_shapeshifter_forms(var/mob/living/carbon/human/H)
	return valid_transform_species

/datum/species/shapeshifter/get_icobase(var/mob/living/carbon/human/H, var/get_deform)
	if(!H) return ..(null, get_deform)
	var/datum/species/S = all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_icobase(H, get_deform)

/datum/species/shapeshifter/get_race_key(var/mob/living/carbon/human/H)
	return "[..()]-[wrapped_species_by_ref["\ref[H]"]]"

/datum/species/shapeshifter/get_bodytype(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_bodytype(H)

/datum/species/shapeshifter/get_blood_mask(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_blood_mask(H)

/datum/species/shapeshifter/get_damage_mask(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_damage_mask(H)

/datum/species/shapeshifter/get_damage_overlays(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_damage_overlays(H)

/datum/species/shapeshifter/get_tail(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_tail(H)

/datum/species/shapeshifter/get_tail_animation(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_tail_animation(H)

/datum/species/shapeshifter/get_tail_hair(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_tail_hair(H)

/datum/species/shapeshifter/handle_pre_spawn(var/mob/living/carbon/human/H)
	..()
	wrapped_species_by_ref["\ref[H]"] = default_form

/datum/species/shapeshifter/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	if(monochromatic)
		H.r_hair =   H.r_skin
		H.g_hair =   H.g_skin
		H.b_hair =   H.b_skin
		H.r_facial = H.r_skin
		H.g_facial = H.g_skin
		H.b_facial = H.b_skin

	for(var/obj/item/organ/external/E in H.organs)
		E.sync_colour_to_human(H)

// Verbs follow.
/mob/living/carbon/human/proc/shapeshifter_select_hair()

	set name = "Select Hair"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10

	var/list/valid_hairstyles = list()
	var/list/valid_facialhairstyles = list()
	for(var/hairstyle in hair_styles_list)
		var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if(!(species.get_bodytype(src) in S.species_allowed))
			continue
		valid_hairstyles += hairstyle
	for(var/facialhairstyle in facial_hair_styles_list)
		var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if(!(species.get_bodytype(src) in S.species_allowed))
			continue
		valid_facialhairstyles += facialhairstyle


	visible_message("<span class='notice'>\The [src]'s form contorts subtly.</span>")
	if(valid_hairstyles.len)
		var/new_hair = input("Select a hairstyle.", "Shapeshifter Hair") as null|anything in valid_hairstyles
		change_hair(new_hair ? new_hair : "Bald")
	if(valid_facialhairstyles.len)
		var/new_hair = input("Select a facial hair style.", "Shapeshifter Hair") as null|anything in valid_facialhairstyles
		change_facial_hair(new_hair ? new_hair : "Shaved")

/mob/living/carbon/human/proc/shapeshifter_select_gender()

	set name = "Select Gender"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_gender = input("Please select a gender.", "Shapeshifter Gender") as null|anything in list(FEMALE, MALE, NEUTER, PLURAL)
	if(!new_gender)
		return

	visible_message("<span class='notice'>\The [src]'s form contorts subtly.</span>")
	change_gender(new_gender)

/mob/living/carbon/human/proc/shapeshifter_select_shape()

	set name = "Select Body Shape"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_species = input("Please select a species to emulate.", "Shapeshifter Body") as null|anything in species.get_valid_shapeshifter_forms(src)
	if(!new_species || !all_species[new_species] || wrapped_species_by_ref["\ref[src]"] == new_species)
		return

	wrapped_species_by_ref["\ref[src]"] = new_species
	visible_message("<span class='notice'>\The [src] shifts and contorts, taking the form of \a ["\improper [new_species]"]!</span>")
	regenerate_icons()

/mob/living/carbon/human/proc/shapeshifter_select_colour()

	set name = "Select Body Colour"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_skin = input("Please select a new body color.", "Shapeshifter Colour") as color
	if(!new_skin)
		return
	shapeshifter_set_colour(new_skin)

/mob/living/carbon/human/proc/shapeshifter_set_colour(var/new_skin)

	r_skin =   hex2num(copytext(new_skin, 2, 4))
	g_skin =   hex2num(copytext(new_skin, 4, 6))
	b_skin =   hex2num(copytext(new_skin, 6, 8))

	var/datum/species/shapeshifter/S = species
	if(S.monochromatic)
		r_hair =   r_skin
		g_hair =   g_skin
		b_hair =   b_skin
		r_facial = r_skin
		g_facial = g_skin
		b_facial = b_skin

	for(var/obj/item/organ/external/E in organs)
		E.sync_colour_to_human(src)

	regenerate_icons()
