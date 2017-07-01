//Stand-in until this is made more lore-friendly.
/datum/species/xenos
	name = "Xenophage"
	name_plural = "Xenophages"

	default_language = "Xenophage"
	language = "Hivemind"
	unarmed_types = list(/datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/strong)
	hud_type = /datum/hud_data/alien
	rarity_value = 3
	health_hud_intensity = 1

	icon_template = 'icons/mob/human_races/xenos/r_xenos_drone.dmi'
	use_eye_icon = 'icons/mob/human_races/xenos/r_xenos_drone.dmi'
	has_floating_eyes = TRUE

	// temp until someone who isn't me makes some for this icon set
	damage_overlays = null
	damage_mask =     null
	blood_mask =      null
	// end temp

	pixel_offset_x = -16
	has_fine_manipulation = 0
	siemens_coefficient = 0
	gluttonous = GLUT_ANYTHING
	stomach_capacity = MOB_MEDIUM

	brute_mod = 0.25 // Hardened carapace.
	burn_mod = 1.1    // Weak to fire.

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	flags = NO_SCAN | NO_PAIN | NO_SLIP | NO_POISON | NO_EMBED
	appearance_flags = HAS_EYE_COLOR | HAS_SKIN_COLOR

	spawn_flags = SPECIES_IS_RESTRICTED

	reagent_tag = IS_XENOS

	blood_color = "#05EE05"
	flesh_color = "#282846"
	base_color =  "#00060c"

	gibbed_anim = "gibbed-a"
	dusted_anim = "dust-a"
	death_message = "lets out a waning guttural screech, green blood bubbling from its maw."
	death_sound = 'sound/voice/hiss6.ogg'

	speech_sounds = list('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
	speech_chance = 100

	breath_type = null
	poison_type = null

	vision_flags = SEE_SELF|SEE_MOBS

	has_organ = list(
		BP_EYES =     /obj/item/organ/internal/eyes/xenos,
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_BRAIN =    /obj/item/organ/internal/brain/xeno,
		BP_PLASMA =   /obj/item/organ/internal/xenos/plasmavessel,
		BP_HIVE =     /obj/item/organ/internal/xenos/hivenode,
		BP_NUTRIENT = /obj/item/organ/internal/diona/nutrients
		)

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/unbreakable),
		"groin" =  list("path" = /obj/item/organ/external/groin/unbreakable),
		"head" =   list("path" = /obj/item/organ/external/head/unbreakable/xeno),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/unbreakable),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/unbreakable),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/unbreakable),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/unbreakable),
		"l_hand" = list("path" = /obj/item/organ/external/hand/unbreakable),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/unbreakable),
		"l_foot" = list("path" = /obj/item/organ/external/foot/unbreakable),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/unbreakable)
		)

	bump_flag = ALIEN
	swap_flags = ~HEAVY
	push_flags = (~HEAVY) ^ ROBOT

	var/alien_number = 0
	var/caste_name = "creature" // Used to update alien name.
	var/weeds_heal_rate = 3     // Health regen on weeds.
	var/weeds_plasma_rate = 5   // Plasma regen on weeds.

	genders = list(NEUTER)

/datum/species/xenos/handle_post_spawn(var/mob/living/carbon/human/H)
	..(H)


/datum/species/xenos/get_bodytype(var/mob/living/carbon/H)
	return "Xenophage"

/datum/species/xenos/get_random_name()
	return "alien [caste_name] ([alien_number])"

/datum/species/xenos/can_understand(var/mob/other)

	if(istype(other,/mob/living/carbon/alien/larva))
		return 1

	return 0

/datum/species/xenos/hug(var/mob/living/carbon/human/H,var/mob/living/target)
	H.visible_message("<span class='notice'>[H] caresses [target] with countless prickling, needle-like legs.</span>", \
					"<span class='notice'>You caress [target] with countless prickling, needle-like legs.</span>")

/datum/species/xenos/handle_post_spawn(var/mob/living/carbon/human/H)

	if(H.mind)
		H.mind.assigned_role = "Alien"
		H.mind.special_role = "Alien"

	alien_number++ //Keep track of how many aliens we've had so far.
	H.real_name = "alien [caste_name] ([alien_number])"
	H.name = H.real_name

	..()

/datum/species/xenos/handle_environment_special(var/mob/living/carbon/human/H)

	var/turf/T = H.loc
	if(!T) return
	var/datum/gas_mixture/environment = T.return_air()
	if(!environment) return

	var/obj/effect/plant/plant = locate() in T
	if((environment.gas["phoron"] > 0 || (plant && plant.seed && plant.seed.name == "xenomorph")) && !regenerate(H))
		var/obj/item/organ/internal/xenos/plasmavessel/P = H.internal_organs_by_name["plasma vessel"]
		P.stored_plasma += weeds_plasma_rate
		P.stored_plasma = min(max(P.stored_plasma,0),P.max_plasma)
	..()

/datum/species/xenos/proc/regenerate(var/mob/living/carbon/human/H)
	var/heal_rate = weeds_heal_rate
	var/mend_prob = 10
	if (!H.resting)
		heal_rate = weeds_heal_rate / 3
		mend_prob = 1

	//first heal damages
	if (H.getBruteLoss() || H.getFireLoss() || H.getOxyLoss() || H.getToxLoss())
		H.adjustBruteLoss(-heal_rate)
		H.adjustFireLoss(-heal_rate)
		H.adjustOxyLoss(-heal_rate)
		H.adjustToxLoss(-heal_rate)
		if (prob(5))
			to_chat(H, "<span class='alium'>You feel a soothing sensation come over you...</span>")
		return 1

	//next internal organs
	for(var/obj/item/organ/I in H.internal_organs)
		if(I.damage > 0)
			I.damage = max(I.damage - heal_rate, 0)
			if (prob(5))
				to_chat(H, "<span class='alium'>You feel a soothing sensation within your [I.parent_organ]...</span>")
			return 1

	//next mend broken bones, approx 10 ticks each
	for(var/obj/item/organ/external/E in H.bad_external_organs)
		if (E.status & ORGAN_BROKEN)
			if (prob(mend_prob))
				if (E.mend_fracture())
					to_chat(H, "<span class='alium'>You feel something mend itself inside your [E.name].</span>")
			return 1

	return 0

/datum/species/xenos/drone
	name = "Xenophage Drone"
	caste_name = "drone"
	weeds_plasma_rate = 15
	slowdown = 1
	rarity_value = 5
	base_color = "#000d1a"
	icobase = 'icons/mob/human_races/xenos/r_xenos_drone.dmi'
	deform =  'icons/mob/human_races/xenos/r_xenos_drone.dmi'

	has_organ = list(
		BP_EYES =     /obj/item/organ/internal/eyes/xenos,
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_BRAIN =    /obj/item/organ/internal/brain/xeno,
		BP_PLASMA =   /obj/item/organ/internal/xenos/plasmavessel/queen,
		BP_ACID =     /obj/item/organ/internal/xenos/acidgland,
		BP_HIVE =     /obj/item/organ/internal/xenos/hivenode,
		BP_RESIN =    /obj/item/organ/internal/xenos/resinspinner,
		BP_NUTRIENT = /obj/item/organ/internal/diona/nutrients
		)

	inherent_verbs = list(
		/mob/living/proc/ventcrawl,
		/mob/living/carbon/human/proc/regurgitate,
		/mob/living/carbon/human/proc/plant,
		/mob/living/carbon/human/proc/transfer_plasma,
		/mob/living/carbon/human/proc/evolve,
		/mob/living/carbon/human/proc/resin,
		/mob/living/carbon/human/proc/corrosive_acid
		)

/datum/species/xenos/drone/handle_post_spawn(var/mob/living/carbon/human/H)

	var/mob/living/carbon/human/A = H
	if(!istype(A))
		return ..()
	..()

/datum/species/xenos/hunter

	name = "Xenophage Hunter"
	weeds_plasma_rate = 5
	caste_name = "hunter"
	slowdown = -2
	total_health = 300
	base_color = "#001a33"

	icobase = 'icons/mob/human_races/xenos/r_xenos_hunter.dmi'
	deform =  'icons/mob/human_races/xenos/r_xenos_hunter.dmi'

	has_organ = list(
		BP_EYES =     /obj/item/organ/internal/eyes/xenos,
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_BRAIN =    /obj/item/organ/internal/brain/xeno,
		BP_PLASMA =   /obj/item/organ/internal/xenos/plasmavessel/hunter,
		BP_HIVE =     /obj/item/organ/internal/xenos/hivenode,
		BP_NUTRIENT = /obj/item/organ/internal/diona/nutrients
		)

	inherent_verbs = list(
		/mob/living/proc/ventcrawl,
		/mob/living/carbon/human/proc/pry_open,
		/mob/living/carbon/human/proc/tackle,
		/mob/living/carbon/human/proc/gut,
		/mob/living/carbon/human/proc/leap,
		/mob/living/carbon/human/proc/psychic_whisper,
		/mob/living/carbon/human/proc/regurgitate
		)

/datum/species/xenos/sentinel
	name = "Xenophage Sentinel"
	weeds_plasma_rate = 10
	caste_name = "sentinel"
	slowdown = 0
	base_color = "#00284d"
	total_health = 250
	icobase = 'icons/mob/human_races/xenos/r_xenos_sentinel.dmi'
	deform =  'icons/mob/human_races/xenos/r_xenos_sentinel.dmi'

	has_organ = list(
		BP_EYES =     /obj/item/organ/internal/eyes/xenos,
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_BRAIN =    /obj/item/organ/internal/brain/xeno,
		BP_PLASMA =   /obj/item/organ/internal/xenos/plasmavessel/sentinel,
		BP_ACID =     /obj/item/organ/internal/xenos/acidgland,
		BP_HIVE =     /obj/item/organ/internal/xenos/hivenode,
		BP_NUTRIENT = /obj/item/organ/internal/diona/nutrients
		)

	inherent_verbs = list(
		/mob/living/proc/ventcrawl,
		/mob/living/carbon/human/proc/tackle,
		/mob/living/carbon/human/proc/regurgitate,
		/mob/living/carbon/human/proc/transfer_plasma,
		/mob/living/carbon/human/proc/corrosive_acid,
		/mob/living/carbon/human/proc/neurotoxin
		)

/datum/species/xenos/queen

	name = "Xenophage Queen"
	total_health = 500
	weeds_heal_rate = 5
	weeds_plasma_rate = 20
	caste_name = "queen"
	slowdown = 4
	rarity_value = 10

	icobase = 'icons/mob/human_races/xenos/r_xenos_queen.dmi'
	deform =  'icons/mob/human_races/xenos/r_xenos_queen.dmi'

	has_organ = list(
		BP_EYES =     /obj/item/organ/internal/eyes/xenos,
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_BRAIN =    /obj/item/organ/internal/brain/xeno,
		BP_EGG =      /obj/item/organ/internal/xenos/eggsac,
		BP_PLASMA =   /obj/item/organ/internal/xenos/plasmavessel/queen,
		BP_ACID =     /obj/item/organ/internal/xenos/acidgland,
		BP_HIVE =     /obj/item/organ/internal/xenos/hivenode,
		BP_RESIN =    /obj/item/organ/internal/xenos/resinspinner,
		BP_NUTRIENT = /obj/item/organ/internal/diona/nutrients
		)

	inherent_verbs = list(
		/mob/living/proc/ventcrawl,
		/mob/living/carbon/human/proc/psychic_whisper,
		/mob/living/carbon/human/proc/regurgitate,
		/mob/living/carbon/human/proc/lay_egg,
		/mob/living/carbon/human/proc/plant,
		/mob/living/carbon/human/proc/transfer_plasma,
		/mob/living/carbon/human/proc/corrosive_acid,
		/mob/living/carbon/human/proc/neurotoxin,
		/mob/living/carbon/human/proc/resin,
		/mob/living/carbon/human/proc/xeno_infest
		)

	genders = list(FEMALE)

/datum/species/xenos/queen/handle_login_special(var/mob/living/carbon/human/H)
	..()
	// Make sure only one official queen exists at any point.
	if(!alien_queen_exists(1,H))
		H.real_name = "alien queen ([alien_number])"
		H.name = H.real_name
	else
		H.real_name = "alien princess ([alien_number])"
		H.name = H.real_name

/datum/hud_data/alien

	icon = 'icons/mob/screen1_alien.dmi'
	has_a_intent =  1
	has_m_intent =  1
	has_warnings =  1
	has_hands =     1
	has_drop =      1
	has_throw =     1
	has_resist =    1
	has_pressure =  0
	has_nutrition = 0
	has_bodytemp =  0
	has_internals = 0

	gear = list(
		"o_clothing" =   list("loc" = ui_belt,      "name" = "Suit",         "slot" = slot_wear_suit, "state" = "equip",  "dir" = SOUTH),
		"head" =         list("loc" = ui_id,        "name" = "Hat",          "slot" = slot_head,      "state" = "hair"),
		"storage1" =     list("loc" = ui_storage1,  "name" = "Left Pocket",  "slot" = slot_l_store,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "name" = "Right Pocket", "slot" = slot_r_store,   "state" = "pocket"),
		)