//TODO: Generalize some kind of power pool so that other races can use it.
//Stand-in until this is made more lore-friendly.
/datum/species/xenos
	name = "Xenomorph"
	language = "Hivemind"
	unarmed_type = /datum/unarmed_attack/claws/strong
	secondary_unarmed_type = /datum/unarmed_attack/bite/strong

	eyes = "blank_eyes"

	brute_mod = 0.5 // Hardened carapace.
	burn_mod = 2    // Weak to fire.

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	flags = IS_WHITELISTED | NO_BREATHE | NO_SCAN | NO_PAIN | RAD_ABSORB | NO_SLIP | NO_POISON

	reagent_tag = IS_XENOS

	blood_color = "#05EE05"
	flesh_color = "#282846"
	gibbed_anim = "gibbed-a"
	dusted_anim = "dust-a"
	death_message = "lets out a waning guttural screech, green blood bubbling from its maw."
	death_sound = 'sound/voice/hiss6.ogg'

	breath_type = null
	poison_type = null

	var/alien_number = 0
	var/caste_name = "creature" // Used to update alien name.
	var/weeds_heal_rate = 1     // Health regen on weeds.
	var/weeds_plasma_rate = 5   // Plasma regen on weeds.
	var/maximum_plasma = 500    // Power storage.
	var/spawn_plasma = 200      // Power at spawn.

/datum/species/xenos/handle_post_spawn(var/mob/living/carbon/human/H)

	if(H.has_brain_worms()) //TODO: HANDLE THIS.
		return 0

	var/mob/living/carbon/human/alien/A = H

	// A lot of alien abilities rely on the alien's internal vars/procs.
	if(!istype(A)) // Create a new mob and shunt over the key. The new mob will call this proc again.
		A = new(get_turf(H))
		A.set_species(name)
		for(var/obj/item/W in H)
			H.drop_from_inventory(W)

		if(H.mind)
			H.mind.transfer_to(A)
		else
			A.key = H.key
		del(H)
		return

	if(A.mind)
		A.mind.assigned_role = "Alien"
		A.mind.special_role = "Alien"

	alien_number++ //Keep track of how many aliens we've had so far.
	A.real_name = "alien [caste_name] ([alien_number])"
	A.name = A.real_name

	if(spawn_plasma)
		A.stored_plasma = spawn_plasma

	..()

/datum/species/xenos/handle_environment_special(var/mob/living/carbon/human/H)

	if(!H.loc)
		return

	if(locate(/obj/effect/alien/weeds) in H.loc)
		if(H.health >= H.maxHealth - H.getCloneLoss())
			H.adjustToxLoss(weeds_plasma_rate)
		else
			H.adjustBruteLoss(-weeds_heal_rate)
			H.adjustFireLoss(-weeds_heal_rate)
			H.adjustOxyLoss(-weeds_heal_rate)

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

	icobase = 'icons/mob/human_races/xenos/r_xenos_drone.dmi'
	deform =  'icons/mob/human_races/xenos/r_xenos_drone.dmi'

	inherent_verbs = list(
		/mob/living/carbon/human/proc/regurgitate,
		/mob/living/carbon/human/alien/proc/plant,
		/mob/living/carbon/human/alien/proc/transfer_plasma,
		/mob/living/carbon/human/alien/proc/evolve,
		/mob/living/carbon/human/alien/proc/resin,
		/mob/living/carbon/human/alien/proc/corrosive_acid
		)

/datum/species/xenos/drone/handle_post_spawn(var/mob/living/carbon/human/H)

	var/mob/living/carbon/human/alien/A = H
	if(!istype(A))
		return ..()
	..()

/datum/species/xenos/hunter

	name = "Xenomorph Hunter"
	maximum_plasma = 150
	spawn_plasma = 100
	weeds_plasma_rate = 5
	caste_name = "hunter"
	slowdown = -1
	total_health = 150
	tail = "xenos_hunter_tail"

	icobase = 'icons/mob/human_races/xenos/r_xenos_hunter.dmi'
	deform =  'icons/mob/human_races/xenos/r_xenos_hunter.dmi'

	inherent_verbs = list(
		/mob/living/carbon/human/proc/gut,
		/mob/living/carbon/human/proc/leap,
		/mob/living/carbon/human/proc/psychic_whisper,
		/mob/living/carbon/human/proc/regurgitate
		)

/datum/species/xenos/sentinel
	name = "Xenomorph Sentinel"
	maximum_plasma = 250
	spawn_plasma = 100
	weeds_plasma_rate = 10
	caste_name = "sentinel"
	slowdown = 1
	total_health = 125
	tail = "xenos_sentinel_tail"

	icobase = 'icons/mob/human_races/xenos/r_xenos_sentinel.dmi'
	deform =  'icons/mob/human_races/xenos/r_xenos_sentinel.dmi'

	inherent_verbs = list(
		/mob/living/carbon/human/proc/regurgitate,
		/mob/living/carbon/human/alien/proc/transfer_plasma,
		/mob/living/carbon/human/alien/proc/corrosive_acid,
		/mob/living/carbon/human/alien/proc/neurotoxin
		)


/datum/species/xenos/queen

	name = "Xenomorph Queen"
	weeds_heal_rate = 5
	weeds_plasma_rate = 20
	caste_name = "queen"
	slowdown = 5
	tail = "xenos_queen_tail"

	icobase = 'icons/mob/human_races/xenos/r_xenos_queen.dmi'
	deform =  'icons/mob/human_races/xenos/r_xenos_queen.dmi'

	inherent_verbs = list(
		/mob/living/carbon/human/proc/psychic_whisper,
		/mob/living/carbon/human/proc/regurgitate,
		/mob/living/carbon/human/alien/proc/lay_egg,
		/mob/living/carbon/human/alien/proc/plant,
		/mob/living/carbon/human/alien/proc/transfer_plasma,
		/mob/living/carbon/human/alien/proc/corrosive_acid,
		/mob/living/carbon/human/alien/proc/neurotoxin,
		/mob/living/carbon/human/alien/proc/resin
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