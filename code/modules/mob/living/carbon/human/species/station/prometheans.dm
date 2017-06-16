var/datum/species/shapeshifter/promethean/prometheans

// Species definition follows.
/datum/species/shapeshifter/promethean

	name =             "Promethean"
	name_plural =      "Prometheans"
	blurb =            "What has Science done?"
	show_ssd =         "totally quiescent"
	death_message =    "rapidly loses cohesion, splattering across the ground..."
	knockout_message = "collapses inwards, forming a disordered puddle of goo."
	remains_type = /obj/effect/decal/cleanable/ash

	blood_color = "#05FF9B"
	flesh_color = "#05FFFB"

	hunger_factor =    DEFAULT_HUNGER_FACTOR //todo
	reagent_tag =      IS_SLIME
	bump_flag =        SLIME
	swap_flags =       MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags =       MONKEY|SLIME|SIMPLE_ANIMAL
	flags =            NO_SCAN | NO_SLIP | NO_MINOR_CUT
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR | RADIATION_GLOWS
	spawn_flags =      SPECIES_IS_RESTRICTED

	breath_type = null
	poison_type = null

	gluttonous =          GLUT_TINY | GLUT_SMALLER | GLUT_ITEM_ANYTHING | GLUT_PROJECTILE_VOMIT
	virus_immune =        1
	blood_volume =        600
	min_age =             1
	max_age =             5
	brute_mod =           0.5
	burn_mod =            2
	oxy_mod =             0
	total_health =        120
	siemens_coefficient = -1
	rarity_value =        5

	unarmed_types = list(/datum/unarmed_attack/slime_glomp)
	has_organ =     list(BP_BRAIN = /obj/item/organ/internal/brain/slime) // Slime core.
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
	heat_discomfort_strings = list("You feel too warm.")
	cold_discomfort_strings = list("You feel too cool.")

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_gender
		)

	valid_transform_species = list(SPECIES_HUMAN, SPECIES_UNATHI, SPECIES_TAJARA, SPECIES_SKRELL, SPECIES_DIONA, "Monkey")
	monochromatic = 1

	var/heal_rate = 5 // Temp. Regen per tick.

/datum/species/shapeshifter/promethean/New()
	..()
	prometheans = src

/datum/species/shapeshifter/promethean/hug(var/mob/living/carbon/human/H,var/mob/living/target)
	var/datum/gender/G = gender_datums[target.gender]
	H.visible_message("<span class='notice'>\The [H] glomps [target] to make [G.him] feel better!</span>", \
					"<span class='notice'>You glomps [target] to make [G.him] feel better!</span>")
	H.apply_stored_shock_to(target)

/datum/species/shapeshifter/promethean/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		if(H)
			H.gib()

/datum/species/shapeshifter/promethean/handle_environment_special(var/mob/living/carbon/human/H)

	var/turf/T = H.loc
	if(istype(T))
		var/obj/effect/decal/cleanable/C = locate() in T
		if(C)
			if(H.nutrition < 300)
				H.nutrition += rand(10,20)
			qdel(C)

	// We need a handle_life() proc for this stuff.

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
		if(E && !E.is_usable())
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

/datum/species/shapeshifter/promethean/get_blood_colour(var/mob/living/carbon/human/H)
	return (H ? rgb(H.r_skin, H.g_skin, H.b_skin) : ..())

/datum/species/shapeshifter/promethean/get_flesh_colour(var/mob/living/carbon/human/H)
	return (H ? rgb(H.r_skin, H.g_skin, H.b_skin) : ..())

/datum/species/shapeshifter/promethean/get_additional_examine_text(var/mob/living/carbon/human/H)

	if(!stored_shock_by_ref["\ref[H]"])
		return
	var/datum/gender/G = gender_datums[H.gender]

	switch(stored_shock_by_ref["\ref[H]"])
		if(1 to 10)
			return "[G.He] [G.is] flickering gently with a little electrical activity."
		if(11 to 20)
			return "[G.He] [G.is] glowing gently with moderate levels of electrical activity.\n"
		if(21 to 35)
			return "<span class='warning'>[G.He] [G.is] glowing brightly with high levels of electrical activity.</span>"
		if(35 to INFINITY)
			return "<span class='danger'>[G.He] [G.is] radiating massive levels of electrical activity!</span>"
