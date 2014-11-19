//Stand-in until this is made more lore-friendly.
/datum/species/xenos
	name = "Xenomorph"
	name_plural = "Xenomorphs"

	default_language = "Xenomorph"
	language = "Hivemind"
	unarmed_type = /datum/unarmed_attack/claws/strong
	secondary_unarmed_type = /datum/unarmed_attack/bite/strong
	hud_type = /datum/hud_data/alien
	rarity_value = 3

	has_fine_manipulation = 0
	insulated = 1
	gluttonous = 2

	eyes = "blank_eyes"

	brute_mod = 0.5 // Hardened carapace.
	burn_mod = 2    // Weak to fire.

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	flags = NO_BREATHE | NO_SCAN | NO_PAIN | NO_SLIP | NO_POISON

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

	has_organ = list(
		"heart" =           /datum/organ/internal/heart,
		"brain" =           /datum/organ/internal/brain/xeno,
		"plasma vessel" =   /datum/organ/internal/xenos/plasmavessel,
		"hive node" =       /datum/organ/internal/xenos/hivenode,
		"nutrient vessel" = /datum/organ/internal/diona/nutrients
		)

	var/alien_number = 0
	var/caste_name = "creature" // Used to update alien name.
	var/weeds_heal_rate = 1     // Health regen on weeds.
	var/weeds_plasma_rate = 5   // Plasma regen on weeds.

/datum/species/xenos/can_understand(var/mob/other)

	if(istype(other,/mob/living/carbon/alien/larva))
		return 1

	return 0

/datum/species/xenos/hug(var/mob/living/carbon/human/H,var/mob/living/target)
	H.visible_message("<span class='notice'>[H] caresses [target] with its scythe-like arm.</span>", \
					"<span class='notice'>You caress [target] with your scythe-like arm.</span>")

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

	if(environment.gas["phoron"] > 0 || locate(/obj/effect/alien/weeds) in T)
		if(H.health >= H.maxHealth - H.getCloneLoss())
			var/datum/organ/internal/xenos/plasmavessel/P = H.internal_organs_by_name["plasma vessel"]
			P.stored_plasma += weeds_plasma_rate
			P.stored_plasma = min(max(P.stored_plasma,0),P.max_plasma)
		else
			H.adjustBruteLoss(-weeds_heal_rate)
			H.adjustFireLoss(-weeds_heal_rate)
			H.adjustOxyLoss(-weeds_heal_rate)
			H.adjustToxLoss(-weeds_heal_rate)
	..()


/datum/species/xenos/handle_login_special(var/mob/living/carbon/human/H)
	H.AddInfectionImages()
	..()

/datum/species/xenos/handle_logout_special(var/mob/living/carbon/human/H)
	H.RemoveInfectionImages()
	..()

/datum/species/xenos/drone
	name = "Xenomorph Drone"
	caste_name = "drone"
	weeds_plasma_rate = 15
	slowdown = 2
	tail = "xenos_drone_tail"
	rarity_value = 5

	icobase = 'icons/mob/human_races/xenos/r_xenos_drone.dmi'
	deform =  'icons/mob/human_races/xenos/r_xenos_drone.dmi'

	has_organ = list(
		"heart" =           /datum/organ/internal/heart,
		"brain" =           /datum/organ/internal/brain/xeno,
		"plasma vessel" =   /datum/organ/internal/xenos/plasmavessel/queen,
		"acid gland" =      /datum/organ/internal/xenos/acidgland,
		"hive node" =       /datum/organ/internal/xenos/hivenode,
		"resin spinner" =   /datum/organ/internal/xenos/resinspinner,
		"nutrient vessel" = /datum/organ/internal/diona/nutrients
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

	name = "Xenomorph Hunter"
	weeds_plasma_rate = 5
	caste_name = "hunter"
	slowdown = -1
	total_health = 150
	tail = "xenos_hunter_tail"

	icobase = 'icons/mob/human_races/xenos/r_xenos_hunter.dmi'
	deform =  'icons/mob/human_races/xenos/r_xenos_hunter.dmi'

	has_organ = list(
		"heart" =           /datum/organ/internal/heart,
		"brain" =           /datum/organ/internal/brain/xeno,
		"plasma vessel" =   /datum/organ/internal/xenos/plasmavessel/hunter,
		"hive node" =       /datum/organ/internal/xenos/hivenode,
		"nutrient vessel" = /datum/organ/internal/diona/nutrients
		)

	inherent_verbs = list(
		/mob/living/proc/ventcrawl,
		/mob/living/carbon/human/proc/tackle,
		/mob/living/carbon/human/proc/gut,
		/mob/living/carbon/human/proc/leap,
		/mob/living/carbon/human/proc/psychic_whisper,
		/mob/living/carbon/human/proc/regurgitate
		)

/datum/species/xenos/sentinel
	name = "Xenomorph Sentinel"
	weeds_plasma_rate = 10
	caste_name = "sentinel"
	slowdown = 1
	total_health = 125
	tail = "xenos_sentinel_tail"

	icobase = 'icons/mob/human_races/xenos/r_xenos_sentinel.dmi'
	deform =  'icons/mob/human_races/xenos/r_xenos_sentinel.dmi'

	has_organ = list(
		"heart" =           /datum/organ/internal/heart,
		"brain" =           /datum/organ/internal/brain/xeno,
		"plasma vessel" =   /datum/organ/internal/xenos/plasmavessel/sentinel,
		"acid gland" =      /datum/organ/internal/xenos/acidgland,
		"hive node" =       /datum/organ/internal/xenos/hivenode,
		"nutrient vessel" = /datum/organ/internal/diona/nutrients
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

	name = "Xenomorph Queen"
	total_health = 250
	weeds_heal_rate = 5
	weeds_plasma_rate = 20
	caste_name = "queen"
	slowdown = 5
	tail = "xenos_queen_tail"
	rarity_value = 10

	icobase = 'icons/mob/human_races/xenos/r_xenos_queen.dmi'
	deform =  'icons/mob/human_races/xenos/r_xenos_queen.dmi'

	has_organ = list(
		"heart" =           /datum/organ/internal/heart,
		"brain" =           /datum/organ/internal/brain/xeno,
		"egg sac" =         /datum/organ/internal/xenos/eggsac,
		"plasma vessel" =   /datum/organ/internal/xenos/plasmavessel/queen,
		"acid gland" =      /datum/organ/internal/xenos/acidgland,
		"hive node" =       /datum/organ/internal/xenos/hivenode,
		"resin spinner" =   /datum/organ/internal/xenos/resinspinner,
		"nutrient vessel" = /datum/organ/internal/diona/nutrients
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
		/mob/living/carbon/human/proc/resin
		)

	//maxHealth = 250
	//health = 250

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
		"o_clothing" =   list("loc" = ui_belt,      "slot" = slot_wear_suit, "state" = "equip",  "dir" = SOUTH),
		"head" =         list("loc" = ui_id,        "slot" = slot_head,      "state" = "hair"),
		"storage1" =     list("loc" = ui_storage1,  "slot" = slot_l_store,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "slot" = slot_r_store,   "state" = "pocket"),
		)