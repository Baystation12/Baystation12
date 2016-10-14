/datum/species/slime
	name = "Slime"
	name_plural = "slimes"
	mob_size = MOB_SMALL

	blurb = "< Slime lore here. > \
	Slimes are not permitted to be Captain, HoP, or HoS."

	icobase = 'icons/mob/human_races/r_slime.dmi'
	deform = 'icons/mob/human_races/r_slime.dmi'

	language = null //todo?
	num_alternate_languages = 3

	unarmed_types = list(/datum/unarmed_attack/slime_glomp)
	siemens_coefficient = -1
	darksight = 3
	brute_mod = 0.5
	burn_mod = 2
	virus_immune = 1

	health_hud_intensity = 2

	blood_color = "#05FF9B"
	flesh_color = "#05FFFB"

	remains_type = /obj/effect/decal/cleanable/ash
	death_message = "rapidly loses cohesion, splattering across the ground..."

	has_organ = list(
		BP_BRAIN = /obj/item/organ/internal/brain/slime
		)

	cold_discomfort_strings = list(
		"Your core feels uncomfortably cold."
		)
	heat_discomfort_strings = list(
		"Your core feels uncomfortably warm."
		)

	cold_level_1 = 260 //Default 260 - Lower is better
	cold_level_2 = 200 //Default 200
	cold_level_3 = 120 //Default 120

	heat_level_1 = 360 //Default 360 - Higher is better
	heat_level_2 = 400 //Default 400
	heat_level_3 = 1000 //Default 1000

	body_temperature =      310.15

	breath_type = null
	poison_type = null

	bump_flag = SLIME
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL

	gluttonous = GLUT_TINY
	stomach_capacity = MOB_SMALL

	flags = NO_SCAN | NO_SLIP | NO_EMBED
	appearance_flags = HAS_SKIN_COLOR | HAS_UNDERWEAR | HAS_EYE_COLOR | HAS_BIOMODS | RADIATION_GLOWS
	spawn_flags = CAN_JOIN

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/unbreakable/slime),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/unbreakable/slime),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/unbreakable/slime),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/unbreakable/slime),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/unbreakable/slime),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/unbreakable/slime),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/unbreakable/slime),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/unbreakable/slime),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/unbreakable/slime),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/unbreakable/slime),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unbreakable/slime)
		)

var/heal_rate = 5 // Temp. Regen per tick.

/datum/species/slime/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		if(H)
			H.gib()


/datum/species/slime/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		if(H)
			H.gib()

/datum/species/slime/handle_environment_special(var/mob/living/carbon/human/H)

	var/turf/T = H.loc
	if(istype(T))
		var/obj/effect/decal/cleanable/C = locate() in T
		if(C)
			qdel(C)
			//TODO: gain nutriment

	// Regenerate limbs and heal damage if we have any. Copied from Bay xenos code.

	// Theoretically the only internal organ a slime will have
	// is the slime core. but we might as well be thorough.
	for(var/obj/item/organ/I in H.internal_organs)
		if(I.damage > 0)
			I.damage = max(I.damage - heal_rate, 0)
			if (prob(5))
				H << "<span class='notice'>You feel a soothing sensation within your [I.name]...</span>"
			return 1

	// Replace completely missing limbs.
	for(var/limb_type in has_limbs)
		var/obj/item/organ/external/E = H.organs_by_name[limb_type]
		if(E && (E.is_stump() || (E.status & (ORGAN_DESTROYED|ORGAN_DEAD|ORGAN_MUTATED))))
			E.removed()
			qdel(E)
			E = null
		if(!E)
			var/list/organ_data = has_limbs[limb_type]
			var/limb_path = organ_data["path"]
			var/obj/item/organ/O = new limb_path(H)
			organ_data["descriptor"] = O.name
			H << "<span class='notice'>You feel a slithering sensation as your [O.name] reforms.</span>"
			H.update_body()
			return 1

	// Heal remaining damage.
	if (H.getBruteLoss() || H.getFireLoss() || H.getOxyLoss() || H.getToxLoss())
		H.adjustBruteLoss(-heal_rate)
		H.adjustFireLoss(-heal_rate)
		H.adjustOxyLoss(-heal_rate)
		H.adjustToxLoss(-heal_rate)
		return 1

/datum/species/slime/get_blood_colour(var/mob/living/carbon/human/H)
	return (H ? rgb(H.r_skin, H.g_skin, H.b_skin) : ..())

/datum/species/slime/get_flesh_colour(var/mob/living/carbon/human/H)
	return (H ? rgb(H.r_skin, H.g_skin, H.b_skin) : ..())