/datum/species/xenos
	name = "Xenophage"
	name_plural = "Xenophages"
	default_language = "Xenophage"
	language = "Hivemind"
	unarmed_types = list(/datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/strong)
	hud_type = /datum/hud_data/alien
	rarity_value = 3
	offset_x = -16

	icobase = 'icons/mob/human_races/xenos/r_xenophage.dmi'
	deform =  'icons/mob/human_races/xenos/r_xenophage.dmi'
	icon_template = 'icons/mob/human_races/xenos/r_xenophage.dmi'

	has_fine_manipulation = 0
	siemens_coefficient = 0
	gluttonous = 2

	eyes = "blank_eyes"
	has_floating_eyes = 1

	brute_mod = 0.5 // Hardened carapace.
	burn_mod = 2    // Weak to fire.

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	flags = CAN_JOIN | HAS_SKIN_COLOR | IS_WHITELISTED | NO_BREATHE | NO_SCAN | NO_PAIN | NO_SLIP | NO_POISON

	reagent_tag = IS_XENOS

	blood_color = "#05EE05"
	flesh_color = "#282846"
	gibbed_anim = "gibbed-a"
	dusted_anim = "dust-a"
	death_message = "lets out a waning guttural screech, green blood bubbling from its maw."
	death_sound = 'sound/voice/hiss6.ogg'

	speech_sounds = list('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
	speech_chance = 100

	breath_type = null
	poison_type = null

	vision_flags = SEE_MOBS

	has_organ = list(
		"heart" =           /obj/item/organ/heart,
		"brain" =           /obj/item/organ/brain/xeno,
		"egg sac" =         /obj/item/organ/xenos/eggsac,
		"plasma vessel" =   /obj/item/organ/xenos/plasmavessel/queen,
		"acid gland" =      /obj/item/organ/xenos/acidgland,
		"hive node" =       /obj/item/organ/xenos/hivenode,
		"resin spinner" =   /obj/item/organ/xenos/resinspinner,
		"nutrient vessel" = /obj/item/organ/diona/nutrients
		)

	inherent_verbs = list(
		/mob/living/proc/ventcrawl,
		/mob/living/carbon/human/proc/tackle,
		/mob/living/carbon/human/proc/psychic_whisper,
		/mob/living/carbon/human/proc/regurgitate,
		/mob/living/carbon/human/proc/lay_egg,
		/mob/living/carbon/human/proc/plant,
		/mob/living/carbon/human/proc/transfer_plasma,
		/mob/living/carbon/human/proc/corrosive_acid,
		/mob/living/carbon/human/proc/neurotoxin,
		/mob/living/carbon/human/proc/resin
		)

	// TODO: generalize limbs so that they can actually have a billion legs.
	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/unbreakable),
		"groin" =  list("path" = /obj/item/organ/external/groin/unbreakable),
		"head" =   list("path" = /obj/item/organ/external/head/unbreakable),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/unbreakable/insectoid),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/unbreakable/insectoid),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/unbreakable/insectoid),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/unbreakable/insectoid),
		"l_hand" = list("path" = /obj/item/organ/external/hand/unbreakable/insectoid),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/unbreakable/insectoid),
		"l_foot" = list("path" = /obj/item/organ/external/foot/unbreakable/insectoid),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/unbreakable/insectoid)
		)

	bump_flag = ALIEN
	swap_flags = ALLMOBS
	push_flags = ALLMOBS ^ ROBOT

	var/alien_number = 0
	var/weeds_heal_rate = 1     // Health regen on weeds.
	var/weeds_plasma_rate = 5   // Plasma regen on weeds.
	var/list/eye_overlays = list()
	var/list/bloodline_colour = list()

/datum/species/xenos/get_eyes(var/mob/living/carbon/human/H)
	var/eye_cache_key = "[bloodline_colour[H.ckey]]"
	if(!bloodline_colour[H.ckey])
		bloodline_colour[H.ckey] = "#FF00FF"
	if(isnull(eye_overlays[eye_cache_key]))
		var/image/I = image('icons/mob/human_races/xenos/r_xenophage.dmi',"eyes")
		I.color = bloodline_colour[H.ckey]
		I.layer = 15 // Should draw over darkness.
		eye_overlays[eye_cache_key] = I
	H.overlays |= eye_overlays[eye_cache_key]
	return

/datum/species/xenos/get_random_name()
	return "alien ([alien_number])"

/datum/species/xenos/can_understand(var/mob/other)

	if(istype(other,/mob/living/carbon/alien/larva))
		return 1

	return 0

/datum/species/xenos/hug(var/mob/living/carbon/human/H,var/mob/living/target)
	H.visible_message("<span class='notice'>[H] caresses [target] with a multitude of serrated claws.</span>", \
					"<span class='notice'>You caress [target] with a multitude of serrated claws.</span>")

/datum/species/xenos/handle_post_spawn(var/mob/living/carbon/human/H)
	if(H.mind)
		H.mind.assigned_role = "Alien"
		H.mind.special_role = "Alien"
	alien_number++ //Keep track of how many aliens we've had so far.
	H.real_name = "xenophage ([alien_number])"
	H.name = H.real_name
	..()

/datum/species/xenos/handle_environment_special(var/mob/living/carbon/human/H)

	var/turf/T = H.loc
	if(!T) return
	var/datum/gas_mixture/environment = T.return_air()
	if(!environment) return
	var/obj/effect/plant/plant = locate() in T
	if((environment.gas["phoron"] > 0 || (plant && plant.seed && plant.seed.name == "xenophage")) && !regenerate(H))
		var/obj/item/organ/xenos/plasmavessel/P = H.internal_organs_by_name["plasma vessel"]
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
			H << "<span class='alium'>You feel a soothing sensation come over you...</span>"
		return 1

	//next internal organs
	for(var/obj/item/organ/I in H.internal_organs)
		if(I.damage > 0)
			I.damage = max(I.damage - heal_rate, 0)
			if (prob(5))
				H << "<span class='alium'>You feel a soothing sensation within your [I.parent_organ]...</span>"
			return 1

	//next mend broken bones, approx 10 ticks each
	for(var/obj/item/organ/external/E in H.bad_external_organs)
		if (E.status & ORGAN_BROKEN)
			if (prob(mend_prob))
				if (E.mend_fracture())
					H << "<span class='alium'>You feel something mend itself inside your [E.name].</span>"
			return 1

	return 0

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