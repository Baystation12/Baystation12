/datum/species/human
	name = SPECIES_HUMAN
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
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE_NORMAL | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	sexybits_location = BP_GROIN

/datum/species/human/get_bodytype(var/mob/living/carbon/human/H)
	return SPECIES_HUMAN

/datum/species/human/handle_npc(var/mob/living/carbon/human/H)
	if(H.stat != CONSCIOUS)
		return

	if(H.get_shock() && H.shock_stage < 40 && prob(3))
		H.emote(pick("moan","groan"))

	if(H.shock_stage > 10 && prob(3))
		H.emote(pick("cry","whimper"))

	if(H.shock_stage >= 40 && prob(3))
		H.emote("scream")

	if(!H.restrained() && H.lying && H.shock_stage >= 60 && prob(3))
		H.custom_emote("thrashes in agony")

	if(!H.restrained() && H.shock_stage < 40 && prob(3))
		var/maxdam = 0
		var/obj/item/organ/external/damaged_organ = null
		for(var/obj/item/organ/external/E in H.organs)
			if(!E.can_feel_pain()) continue
			var/dam = E.get_damage()
			// make the choice of the organ depend on damage,
			// but also sometimes use one of the less damaged ones
			if(dam > maxdam && (maxdam == 0 || prob(50)) )
				damaged_organ = E
				maxdam = dam
		var/datum/gender/T = gender_datums[H.get_gender()]
		if(damaged_organ)
			if(damaged_organ.status & ORGAN_BLEEDING)
				H.custom_emote("clutches [T.his] [damaged_organ.name], trying to stop the blood.")
			else if(damaged_organ.status & ORGAN_BROKEN)
				H.custom_emote("holds [T.his] [damaged_organ.name] carefully.")
			else if(damaged_organ.burn_dam > damaged_organ.brute_dam && damaged_organ.organ_tag != BP_HEAD)
				H.custom_emote("blows on [T.his] [damaged_organ.name] carefully.")
			else
				H.custom_emote("rubs [T.his] [damaged_organ.name] carefully.")

		for(var/obj/item/organ/I in H.internal_organs)
			if((I.status & ORGAN_DEAD) || I.robotic >= ORGAN_ROBOT) continue
			if(I.damage > 2) if(prob(2))
				var/obj/item/organ/external/parent = H.get_organ(I.parent_organ)
				H.custom_emote("clutches [T.his] [parent.name]!")

/datum/species/human/get_ssd(var/mob/living/carbon/human/H)
	if(H.stat == CONSCIOUS)
		return "staring blankly, not reacting to your presence"
	return ..()

/datum/species/unathi
	name = SPECIES_UNATHI
	name_plural = SPECIES_UNATHI
	icobase = 'icons/mob/human_races/r_lizard.dmi'
	deform = 'icons/mob/human_races/r_def_lizard.dmi'
	tail = "sogtail"
	tail_animation = 'icons/mob/species/unathi/tail.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/tail, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	primitive_form = "Stok"
	darksight = 3
	gluttonous = GLUT_TINY
	strength = STR_HIGH
	slowdown = 0.5
	brute_mod = 0.8
	blood_volume = 800
	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_UNATHI)
	name_language = LANGUAGE_UNATHI
	health_hud_intensity = 2
	hunger_factor = DEFAULT_HUNGER_FACTOR * 3

	min_age = 18
	max_age = 260

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

	flesh_color = "#34af10"

	reagent_tag = IS_UNATHI
	base_color = "#066000"
	blood_color = "#f24b2e"

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

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

	inherent_verbs = list(
		/mob/living/carbon/human/proc/diona_heal_toggle
		)

/datum/species/unathi/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)

/datum/species/unathi/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.in_stasis || H.stat == DEAD)
		return
	if(H.nutrition < 50)
		H.adjustToxLoss(2,0)
		return
	if(!H.innate_heal)
		return

	//Heals normal damage.
	if(H.getBruteLoss())
		H.adjustBruteLoss(-2 * config.organ_regeneration_multiplier)	//Heal brute better than other ouchies.
		H.nutrition -= 1
	if(H.getFireLoss())
		H.adjustFireLoss(-1 * config.organ_regeneration_multiplier)
		H.nutrition -= 1
	if(H.getToxLoss())
		H.adjustToxLoss(-1 * config.organ_regeneration_multiplier)
		H.nutrition -= 1

	if(prob(5) && H.nutrition > 150 && !H.getBruteLoss() && !H.getFireLoss())
		var/obj/item/organ/external/head/D = H.organs_by_name["head"]
		if (D.disfigured)
			D.disfigured = 0
			H.nutrition -= 20

	if(H.nutrition <= 100)
		return

	for(var/bpart in shuffle(H.internal_organs_by_name - BP_BRAIN))

		var/obj/item/organ/internal/regen_organ = H.internal_organs_by_name[bpart]

		if(regen_organ.robotic >= ORGAN_ROBOT)
			continue
		if(istype(regen_organ))
			if(regen_organ.damage > 0 && !(regen_organ.status & ORGAN_DEAD))
				regen_organ.damage = max(regen_organ.damage - 5, 0)
				H.nutrition -= 5
				if(prob(5))
					to_chat(H, "<span class='warning'>You feel a soothing sensation as your [regen_organ] mends...</span>")

	if(prob(2) && H.nutrition > 150)
		for(var/limb_type in has_limbs)
			var/obj/item/organ/external/E = H.organs_by_name[limb_type]
			if(E && !E.vital && !E.is_usable())
				E.removed()
				qdel(E)
				E= null
			if(!E)
				var/list/organ_data = has_limbs[limb_type]
				var/limb_path = organ_data["path"]
				var/obj/item/organ/O = new limb_path(H)
				organ_data["descriptor"] = O.name
				to_chat(H, "<span class='danger'>With a shower of fresh blood, a new [O.name] forms.</span>")
				H.visible_message("<span class='danger'>With a shower of fresh blood, a length of biomass shoots from [H], forming a new [O.name]</span>")
				H.nutrition -= 50
				var/datum/reagent/blood/B = locate(/datum/reagent/blood) in H.vessel.reagent_list
				blood_splatter(H,B,1)
				H.update_body()
				return
			else
				for(var/datum/wound/W in E.wounds)
					if(W.wound_damage() == 0 && prob(50))
						E.wounds -= W

/datum/species/tajaran
	name = SPECIES_TAJARA
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
	secondary_langs = list(LANGUAGE_SIIK_TAJR)
	additional_langs = list(LANGUAGE_SIIK_MAAS)
	name_language = LANGUAGE_SIIK_MAAS
	health_hud_intensity = 1.75

	min_age = 19
	max_age = 140

	blurb = "The Tajaran are a species of furred mammalian bipeds hailing from the chilly planet of Ahdomai \
	in the Zamsiin-lr system. They are a naturally superstitious species, with the new generations growing up with tales \
	of the heroic struggles of their forebears against the Overseers. This spirit has led them forward to the \
	reconstruction and advancement of their society to what they are today. Their pride for the struggles they \
	went through is heavily tied to their spiritual beliefs. Recent discoveries have jumpstarted the progression \
	of highly advanced cybernetic technology, causing a culture shock within Tajaran society."

	cold_level_1 = 200 //Default 260
	cold_level_2 = 140 //Default 200
	cold_level_3 = 80  //Default 120

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 800 //Default 1000

	primitive_form = "Farwa"

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#afa59e"
	base_color = "#333333"
	blood_color = "#862a51"

	reagent_tag = IS_TAJARA

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	heat_discomfort_level = 292
	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)
	cold_discomfort_level = 275

	sexybits_location = BP_GROIN

/datum/species/tajaran/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/tajblind(H),slot_glasses)

/datum/species/skrell
	name = SPECIES_SKRELL
	name_plural = SPECIES_SKRELL
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

	flesh_color = "#8cd7a3"
	blood_color = "#1d2cbf"
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
	name = SPECIES_DIONA
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
	strength = STR_VHIGH
	secondary_langs = list(LANGUAGE_ROOTGLOBAL)
	name_language = LANGUAGE_ROOTLOCAL
	spawns_with_stack = 0
	health_hud_intensity = 2
	hunger_factor = 3

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
		/mob/living/carbon/human/proc/diona_split_nymph,
		/mob/living/carbon/human/proc/diona_heal_toggle
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
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_NO_FBP_CHARGEN | SPECIES_NO_LACE

	blood_color = "#004400"
	flesh_color = "#907e4a"

	reagent_tag = IS_DIONA
	genders = list(PLURAL)

#define DIONA_LIMB_DEATH_COUNT 9
/datum/species/diona/handle_death_check(var/mob/living/carbon/human/H)
	var/lost_limb_count = has_limbs.len - H.organs.len
	if(lost_limb_count >= DIONA_LIMB_DEATH_COUNT)
		return TRUE
	for(var/thing in H.bad_external_organs)
		var/obj/item/organ/external/E = thing
		if(E && E.is_stump())
			lost_limb_count++
	return (lost_limb_count >= DIONA_LIMB_DEATH_COUNT)
#undef DIONA_LIMB_DEATH_COUNT

/datum/species/diona/can_understand(var/mob/other)
	var/mob/living/carbon/alien/diona/D = other
	if(istype(D))
		return 1
	return 0

/datum/species/diona/equip_survival_gear(var/mob/living/carbon/human/H)
	if(istype(H.get_equipped_item(slot_back), /obj/item/weapon/storage/backpack))
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/flare(H.back), slot_in_backpack)
	else
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/flare(H), slot_r_hand)

/datum/species/diona/handle_post_spawn(var/mob/living/carbon/human/H)
	H.gender = NEUTER
	return ..()

/datum/species/diona/handle_death(var/mob/living/carbon/human/H)

	if(H.isSynthetic())
		var/mob/living/carbon/alien/diona/S = new(get_turf(H))

		if(H.mind)
			H.mind.transfer_to(S)
		H.visible_message("<span class='danger'>\The [H] collapses into parts, revealing a solitary diona nymph at the core.</span>")
		return
	else
		H.diona_split_nymph()

/datum/species/diona/get_blood_name()
	return "sap"

/datum/species/diona/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.in_stasis || H.stat == DEAD)
		return
	if(H.nutrition < 10)
		H.take_overall_damage(2,0)
	else if (H.innate_heal)
		// Heals normal damage.
		if(H.getBruteLoss())
			H.adjustBruteLoss(-4)
			H.nutrition -= 2
		if(H.getFireLoss())
			H.adjustFireLoss(-4)
			H.nutrition -= 2

		if(prob(10) && H.nutrition > 200 && !H.getBruteLoss() && !H.getFireLoss())
			var/obj/item/organ/external/head/D = H.organs_by_name["head"]
			if (D.disfigured)
				D.disfigured = 0
				H.nutrition -= 20

		for(var/obj/item/organ/I in H.internal_organs)
			if(I.damage > 0)
				I.damage = max(I.damage - 2, 0)
				H.nutrition -= 2
				if (prob(5))
					to_chat(H, "<span class='warning'>You sense your nymphs shifting internally to regenerate your [I.name]...</span>")

		if (prob(10) && H.nutrition > 70)
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
					to_chat(H, "<span class='warning'>Some of your nymphs split and hurry to reform your [O.name].</span>")
					H.nutrition -= 60
					H.update_body()
				else
					for(var/datum/wound/W in E.wounds)
						if (W.wound_damage() == 0 && prob(50))
							E.wounds -= W
