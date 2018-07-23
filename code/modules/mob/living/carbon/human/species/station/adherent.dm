/datum/species/adherent
	name = SPECIES_ADHERENT
	name_plural = "Adherents"

	blurb = "The Vigil is a relatively loose association of machine-servitors, Adherents, \
	built by an extinct culture. They are devoted to the memory of their long-dead creators, \
	whose home system and burgeoning stellar empire was scoured to bedrock by a solar flare. \
	Physically, they are large, floating squidlike machines made of a crystalline composite."

	language =                LANGUAGE_ADHERENT
	default_language =        LANGUAGE_ADHERENT
	additional_langs =        list(LANGUAGE_GALCOM)
	genders =                 list(PLURAL)
	cyborg_noun =             null

	icon_template =           'icons/mob/human_races/species/adherent/template.dmi'
	icobase =                 'icons/mob/human_races/species/adherent/body.dmi'
	deform =                  'icons/mob/human_races/species/adherent/body.dmi'
	preview_icon =            'icons/mob/human_races/species/adherent/preview.dmi'
	damage_overlays =         'icons/mob/human_races/species/adherent/damage_overlay.dmi'
	damage_mask =             'icons/mob/human_races/species/adherent/damage_mask.dmi'
	blood_mask =              'icons/mob/human_races/species/adherent/blood_mask.dmi'

	rarity_value =            6
	min_age =                 8000
	max_age =                 12000
	antaghud_offset_y =       14
	warning_low_pressure =    50
	hazard_low_pressure =     -1
	strength =                STR_HIGH

	cold_level_1 = SYNTH_COLD_LEVEL_1
	cold_level_2 = SYNTH_COLD_LEVEL_2
	cold_level_3 = SYNTH_COLD_LEVEL_3

	heat_level_1 = SYNTH_HEAT_LEVEL_1
	heat_level_2 = SYNTH_HEAT_LEVEL_2
	heat_level_3 = SYNTH_HEAT_LEVEL_3

	species_flags = SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_POISON | SPECIES_FLAG_NO_MINOR_CUT
	spawn_flags =   SPECIES_IS_WHITELISTED | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_NO_LACE

	appearance_flags = HAS_EYE_COLOR
	blood_color = "#2de00d"
	flesh_color = "#90edeb"
	virus_immune = 1
	slowdown = -1
	hud_type = /datum/hud_data/adherent

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/crystal),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/crystal),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/crystal),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/crystal),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/crystal),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/crystal),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/crystal),
		BP_L_LEG =  list("path" = /obj/item/organ/external/tendril),
		BP_R_LEG =  list("path" = /obj/item/organ/external/tendril/two),
		BP_L_FOOT = list("path" = /obj/item/organ/external/tendril/three),
		BP_R_FOOT = list("path" = /obj/item/organ/external/tendril/four)
	)

	has_organ = list(
		BP_BRAIN = /obj/item/organ/internal/brain/adherent,
		BP_EYES =  /obj/item/organ/internal/eyes/adherent,
		BP_JETS =  /obj/item/organ/internal/powered/jets,
		BP_FLOAT = /obj/item/organ/internal/powered/float,
		BP_CELL =  /obj/item/organ/internal/cell/adherent
		)

	move_trail = /obj/effect/decal/cleanable/blood/tracks/snake
	prone_overlay_offset = list(-8, 0)

	var/list/original_name_cache = list()

/datum/species/adherent/New()
	equip_adjust = list(
		"[slot_l_hand_str]" = list(NORTH = list("x" = 0, "y" = 14), EAST = list("x" = 0, "y" = 14), SOUTH = list("x" = 0, "y" = 14), WEST = list("x" = 0, "y" = 14)),
		"[slot_r_hand_str]" = list(NORTH = list("x" = 0, "y" = 14), EAST = list("x" = 0, "y" = 14), SOUTH = list("x" = 0, "y" = 14), WEST = list("x" = 0, "y" = 14)),
		"[slot_back_str]" =   list(NORTH = list("x" = 0, "y" = 14), EAST = list("x" = 0, "y" = 14), SOUTH = list("x" = 0, "y" = 14), WEST = list("x" = 0, "y" = 14)),
		"[slot_belt_str]" =   list(NORTH = list("x" = 0, "y" = 14), EAST = list("x" = 0, "y" = 14), SOUTH = list("x" = 0, "y" = 14), WEST = list("x" = 0, "y" = 14)),
		"[slot_head_str]" =   list(NORTH = list("x" = 0, "y" = 14), EAST = list("x" = 0, "y" = 14), SOUTH = list("x" = 0, "y" = 14), WEST = list("x" = 0, "y" = 14)),
		"[slot_l_ear_str]" =  list(NORTH = list("x" = 0, "y" = 14), EAST = list("x" = 0, "y" = 14), SOUTH = list("x" = 0, "y" = 14), WEST = list("x" = 0, "y" = 14)),
		"[slot_r_ear_str]" =  list(NORTH = list("x" = 0, "y" = 14), EAST = list("x" = 0, "y" = 14), SOUTH = list("x" = 0, "y" = 14), WEST = list("x" = 0, "y" = 14))
	)
	..()

/datum/species/adherent/proc/sync_ident_to_role(var/mob/living/carbon/human/H)
	if(H)
		if(!original_name_cache[H]) original_name_cache[H] = H.real_name
		H.real_name = (H.job ? "[H.job] Unit [original_name_cache[H]]" : original_name_cache[H])
		if(H.mind) H.mind.name = H.real_name
		H.SetName(H.real_name)

/datum/species/adherent/handle_post_spawn(var/mob/living/carbon/human/H)
	. = ..()
	if(H) addtimer(CALLBACK(src, .proc/sync_ident_to_role, H), 3 SECONDS)

/datum/species/adherent/get_random_name(var/gender)
	return "[uppertext("[pick(GLOB.full_alphabet)][pick(GLOB.full_alphabet)]-[pick(GLOB.full_alphabet)] [rand(1000,9999)]")]"

/datum/species/adherent/can_overcome_gravity(var/mob/living/carbon/human/H)
	. = FALSE
	if(H && H.stat == CONSCIOUS)
		for(var/obj/item/organ/internal/powered/float/float in H.internal_organs)
			if(istype(float) && float.active && float.is_usable())
				. = TRUE
				break

/datum/species/adherent/can_fall(var/mob/living/carbon/human/H)
	. = !can_overcome_gravity(H)

/datum/species/adherent/handle_fall_special(var/mob/living/carbon/human/H, var/turf/landing)

	if(can_overcome_gravity(H))
		if(istype(landing, /turf/simulated/open))
			H.visible_message("\The [H] descends from \the [landing].", "You descend regally.")
		else
			H.visible_message("\The [H] floats gracefully down from \the [landing].", "You land gently on \the [landing].")

/datum/species/adherent/get_blood_name()
	return "coolant"

/datum/species/adherent/skills_from_age(age)
	switch(age)
		if(0 to 1000)    . = -4
		if(1000 to 2000) . =  0
		if(2000 to 8000) . =  4
		else             . =  8

/datum/species/adherent/sanitize_name(name)
	return sanitizeName(name, allow_numbers=TRUE)

/datum/species/adherent/get_additional_examine_text(var/mob/living/carbon/human/H)
	if(can_overcome_gravity(H)) return "\nThey are floating on a cloud of shimmering distortion."

/datum/hud_data/adherent
	has_internals = FALSE
	gear = list(
		"l_ear" = list("loc" = ui_iclothing, "name" = "Aux Port", "slot" = slot_l_ear,   "state" = "ears", "toggle" = 1),
		"head" =  list("loc" = ui_glasses,   "name" = "Hat",      "slot" = slot_head,    "state" = "hair", "toggle" = 1),
		"back" =  list("loc" = ui_back,      "name" = "Back",     "slot" = slot_back,    "state" = "back"),
		"id" =    list("loc" = ui_id,        "name" = "ID",       "slot" = slot_wear_id, "state" = "id"),
		"belt" =  list("loc" = ui_belt,      "name" = "Belt",     "slot" = slot_belt,    "state" = "belt")
	)

/datum/species/adherent/post_organ_rejuvenate(var/obj/item/organ/org)
	org.status |= (ORGAN_BRITTLE|ORGAN_CRYSTAL|ORGAN_ROBOTIC)
