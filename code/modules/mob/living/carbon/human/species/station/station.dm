/datum/species/human
	name = "Human"
	name_plural = "Humans"
	primitive_form = "Monkey"
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	blurb = "Humanity originated in the Sol system, and over the last five centuries has spread \
	colonies across a wide swathe of space. They hold a wide range of forms and creeds.<br/><br/> \
	While the central Sol government maintains control of its far-flung people, powerful corporate \
	interests, rampant cyber and bio-augmentation and secretive factions make life on most human \
	worlds tumultous at best."
	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_SOL_COMMON)
	name_language = null // Use the first-name last-name generator rather than a language scrambler
	min_age = 17
	max_age = 100
	gluttonous = GLUT_TINY

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

/datum/species/human/get_bodytype(var/mob/living/carbon/human/H)
	return "Human"

/datum/species/unathi
	name = "Unathi"
	name_plural = "Unathi"
	icobase = 'icons/mob/human_races/r_lizard.dmi'
	deform = 'icons/mob/human_races/r_def_lizard.dmi'
	tail = "sogtail"
	tail_animation = 'icons/mob/species/unathi/tail.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	primitive_form = "Stok"
	darksight = 3
	gluttonous = GLUT_TINY
	slowdown = 0.5
	brute_mod = 0.8
	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_UNATHI)
	name_language = LANGUAGE_UNATHI
	health_hud_intensity = 2

	min_age = 18
	max_age = 60

	blurb = "A heavily reptillian species, Unathi (or 'Sinta as they call themselves) hail from the \
	Uuosa-Eso system, which roughly translates to 'burning mother'.<br/><br/>Coming from a harsh, radioactive \
	desert planet, they mostly hold ideals of honesty, virtue, martial combat and bravery above all \
	else, frequently even their own lives. They prefer warmer temperatures than most species and \
	their native tongue is a heavy hissing laungage called Sinta'Unathi."

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#34AF10"

	reagent_tag = IS_UNATHI
	base_color = "#066000"
	blood_color = "#ea9e2c"

	heat_discomfort_level = 295
	heat_discomfort_strings = list(
		"You feel soothingly warm.",
		"You feel the heat sink into your bones.",
		"You feel warm enough to take a nap."
		)

	cold_discomfort_level = 292
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You feel sluggish and cold.",
		"Your scales bristle against the cold."
		)
	breathing_sound = 'sound/voice/lizard.ogg'

/datum/species/unathi/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)

/datum/species/tajaran
	name = "Tajara"
	name_plural = "Tajaran"
	icobase = 'icons/mob/human_races/r_tajaran.dmi'
	deform = 'icons/mob/human_races/r_def_tajaran.dmi'
	tail = "tajtail"
	tail_animation = 'icons/mob/species/tajaran/tail.dmi'
	default_h_style = "Tajaran Ears"
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	darksight = 8
	slowdown = -0.5
	brute_mod = 1.15
	burn_mod =  1.15
	gluttonous = GLUT_TINY
	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_SIIK_MAAS, LANGUAGE_SIIK_TAJR)
	name_language = LANGUAGE_SIIK_MAAS
	health_hud_intensity = 1.75

	min_age = 17
	max_age = 80

	blurb = "The Tajaran race is a species of feline-like bipeds hailing from the planet of Ahdomai in the \
	S'randarr system. They have been brought up into the space age by the Humans and Skrell, and have been \
	influenced heavily by their long history of Slavemaster rule. They have a structured, clan-influenced way \
	of family and politics. They prefer colder environments, and speak a variety of languages, mostly Siik'Maas, \
	using unique inflections their mouths form."

	cold_level_1 = 200 //Default 260
	cold_level_2 = 140 //Default 200
	cold_level_3 = 80  //Default 120

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 800 //Default 1000

	primitive_form = "Farwa"

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#333333"
	blood_color = "#862A51"

	reagent_tag = IS_TAJARA

	heat_discomfort_level = 292
	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)
	cold_discomfort_level = 275

/datum/species/tajaran/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)

/datum/species/skrell
	name = "Skrell"
	name_plural = "Skrell"
	icobase = 'icons/mob/human_races/r_skrell.dmi'
	deform = 'icons/mob/human_races/r_def_skrell.dmi'
	primitive_form = "Neaera"
	unarmed_types = list(/datum/unarmed_attack/punch)
	blurb = "An amphibious species, Skrell come from the star system known as Qerr'Vallis, which translates to 'Star of \
	the royals' or 'Light of the Crown'.<br/><br/>Skrell are a highly advanced and logical race who live under the rule \
	of the Qerr'Katish, a caste within their society which keeps the empire of the Skrell running smoothly. Skrell are \
	herbivores on the whole and tend to be co-operative with the other species of the galaxy, although they rarely reveal \
	the secrets of their empire to their allies."
	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_SKRELLIAN)
	name_language = null
	health_hud_intensity = 1.75

	min_age = 19
	max_age = 90

	darksight = 4

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR

	flesh_color = "#8CD7A3"
	blood_color = "#1D2CBF"
	base_color = "#006666"

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

	reagent_tag = IS_SKRELL

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/skrell),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

/datum/species/diona
	name = "Diona"
	name_plural = "Dionaea"
	icobase = 'icons/mob/human_races/r_diona.dmi'
	deform = 'icons/mob/human_races/r_def_plant.dmi'
	language = LANGUAGE_ROOTLOCAL
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/diona)
	//primitive_form = "Nymph"
	slowdown = 7
	rarity_value = 3
	hud_type = /datum/hud_data/diona
	siemens_coefficient = 0.3
	show_ssd = "completely quiescent"
	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_ROOTGLOBAL)
	name_language = LANGUAGE_ROOTLOCAL
	spawns_with_stack = 0
	health_hud_intensity = 2

	min_age = 1
	max_age = 300

	blurb = "Commonly referred to (erroneously) as 'plant people', the Dionaea are a strange space-dwelling collective \
	species hailing from Epsilon Ursae Minoris. Each 'diona' is a cluster of numerous cat-sized organisms called nymphs; \
	there is no effective upper limit to the number that can fuse in gestalt, and reports exist	of the Epsilon Ursae \
	Minoris primary being ringed with a cloud of singing space-station-sized entities.<br/><br/>The Dionaea coexist peacefully with \
	all known species, especially the Skrell. Their communal mind makes them slow to react, and they have difficulty understanding \
	even the simplest concepts of other minds. Their alien physiology allows them survive happily off a diet of nothing but light, \
	water and other radiation."

	has_organ = list(
		BP_NUTRIENT = /obj/item/organ/internal/diona/nutrients,
		BP_STRATA =   /obj/item/organ/internal/diona/strata,
		BP_RESPONSE = /obj/item/organ/internal/diona/node,
		BP_GBLADDER = /obj/item/organ/internal/diona/bladder,
		BP_POLYP =    /obj/item/organ/internal/diona/polyp,
		BP_ANCHOR =   /obj/item/organ/internal/diona/ligament
		)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/diona/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/diona/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/no_eyes/diona),
		BP_L_ARM =  list("path" = /obj/item/organ/external/diona/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/diona/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/diona/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/diona/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/diona/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/diona/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/diona/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/diona/foot/right)
		)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/diona_split_nymph
		)

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	body_temperature = T0C + 15		//make the plant people have a bit lower body temperature, why not

	flags = NO_SCAN | IS_PLANT | NO_PAIN | NO_SLIP
	appearance_flags = 0
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED

	blood_color = "#004400"
	flesh_color = "#907E4A"

	reagent_tag = IS_DIONA
	genders = list(PLURAL)

/datum/species/diona/can_understand(var/mob/other)
	var/mob/living/carbon/alien/diona/D = other
	if(istype(D))
		return 1
	return 0

/datum/species/diona/equip_survival_gear(var/mob/living/carbon/human/H)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/flare(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/flare(H.back), slot_in_backpack)

/datum/species/diona/handle_post_spawn(var/mob/living/carbon/human/H)
	H.gender = NEUTER
	return ..()

/datum/species/diona/handle_death(var/mob/living/carbon/human/H)
	H.diona_split_into_nymphs(0)

	var/mob/living/carbon/alien/diona/S = new(get_turf(H))

	if(H.mind)
		H.mind.transfer_to(S)

	if(H.isSynthetic())
		H.visible_message("<span class='danger'>\The [H] collapses into parts, revealing a solitary diona nymph at the core.</span>")
		return

	for(var/mob/living/carbon/alien/diona/D in H.contents)
		if(D.client)
			D.forceMove(get_turf(H))
		else
			qdel(D)

	H.visible_message("<span class='danger'>\The [H] splits apart with a wet slithering noise!</span>")
