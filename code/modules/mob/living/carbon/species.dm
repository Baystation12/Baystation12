/*
	Datum-based species. Should make for much cleaner and easier to maintain mutantrace code.
*/

/datum/species
	var/name                     // Species name.

	var/icobase = 'icons/mob/human_races/r_human.dmi'    // Normal icon set.
	var/deform = 'icons/mob/human_races/r_def_human.dmi' // Mutated icon set.
	var/eyes = "eyes_s"                                  // Icon for eyes.

	var/primitive                // Lesser form, if any (ie. monkey for humans)
	var/tail                     // Name of tail image in species effects icon file.
	var/language                 // Default racial language, if any.
	var/attack_verb = "punch"    // Empty hand hurt intent verb.
	var/punch_damage = 0		 // Extra empty hand attack damage.
	var/mutantrace               // Safeguard due to old code.

	var/breath_type = "oxygen"   // Non-oxygen gas breathed, if any.

	var/cold_level_1 = 260  // Cold damage level 1 below this point.
	var/cold_level_2 = 200  // Cold damage level 2 below this point.
	var/cold_level_3 = 120  // Cold damage level 3 below this point.

	var/heat_level_1 = 360  // Heat damage level 1 above this point.
	var/heat_level_2 = 400  // Heat damage level 2 above this point.
	var/heat_level_3 = 1000 // Heat damage level 2 above this point.

	var/darksight = 2
	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE   // Dangerously high pressure.
	var/warning_high_pressure = WARNING_HIGH_PRESSURE // High pressure warning.
	var/warning_low_pressure = WARNING_LOW_PRESSURE   // Low pressure warning.
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE     // Dangerously low pressure.

	var/brute_mod = null    // Physical damage reduction/malus.
	var/burn_mod = null     // Burn damage reduction/malus.

	var/flags = 0       // Various specific features.

	var/list/abilities = list()	// For species-derived or admin-given powers

	var/blood_color = "#A10808" //Red.
	var/flesh_color = "#FFC896" //Pink.

/datum/species/proc/create_organs(var/mob/living/carbon/human/H) //Handles creation of mob organs.
	//This is a basic humanoid limb setup.
	H.organs = list()
	H.organs_by_name["chest"] = new/datum/organ/external/chest()
	H.organs_by_name["groin"] = new/datum/organ/external/groin(H.organs_by_name["chest"])
	H.organs_by_name["head"] = new/datum/organ/external/head(H.organs_by_name["chest"])
	H.organs_by_name["l_arm"] = new/datum/organ/external/l_arm(H.organs_by_name["chest"])
	H.organs_by_name["r_arm"] = new/datum/organ/external/r_arm(H.organs_by_name["chest"])
	H.organs_by_name["r_leg"] = new/datum/organ/external/r_leg(H.organs_by_name["groin"])
	H.organs_by_name["l_leg"] = new/datum/organ/external/l_leg(H.organs_by_name["groin"])
	H.organs_by_name["l_hand"] = new/datum/organ/external/l_hand(H.organs_by_name["l_arm"])
	H.organs_by_name["r_hand"] = new/datum/organ/external/r_hand(H.organs_by_name["r_arm"])
	H.organs_by_name["l_foot"] = new/datum/organ/external/l_foot(H.organs_by_name["l_leg"])
	H.organs_by_name["r_foot"] = new/datum/organ/external/r_foot(H.organs_by_name["r_leg"])

	H.internal_organs = list()
	H.internal_organs_by_name["heart"] = new/datum/organ/internal/heart(H)
	H.internal_organs_by_name["lungs"] = new/datum/organ/internal/lungs(H)
	H.internal_organs_by_name["liver"] = new/datum/organ/internal/liver(H)
	H.internal_organs_by_name["kidney"] = new/datum/organ/internal/kidney(H)
	H.internal_organs_by_name["brain"] = new/datum/organ/internal/brain(H)
	H.internal_organs_by_name["eyes"] = new/datum/organ/internal/eyes(H)

	for(var/name in H.organs_by_name)
		H.organs += H.organs_by_name[name]

	for(var/datum/organ/external/O in H.organs)
		O.owner = H

	if(flags & IS_SYNTHETIC)
		for(var/datum/organ/external/E in H.organs)
			if(E.status & ORGAN_CUT_AWAY || E.status & ORGAN_DESTROYED) continue
			E.status |= ORGAN_ROBOT
		for(var/datum/organ/internal/I in H.internal_organs)
			I.mechanize()

	return

/datum/species/proc/handle_post_spawn(var/mob/living/carbon/human/H) //Handles anything not already covered by basic species assignment.
	return

/datum/species/proc/handle_death(var/mob/living/carbon/human/H) //Handles any species-specific death events (such as dionaea nymph spawns).
	if(flags & IS_SYNTHETIC)
		//H.make_jittery(200) //S-s-s-s-sytem f-f-ai-i-i-i-i-lure-ure-ure-ure
		H.h_style = ""
		spawn(100)
			//H.is_jittery = 0
			//H.jitteriness = 0
			H.update_hair()
	return

/datum/species/human
	name = "Human"
	language = "Sol Common"
	primitive = /mob/living/carbon/monkey

	flags = HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR

	//If you wanted to add a species-level ability:
	/*abilities = list(/client/proc/test_ability)*/

/datum/species/unathi
	name = "Unathi"
	icobase = 'icons/mob/human_races/r_lizard.dmi'
	deform = 'icons/mob/human_races/r_def_lizard.dmi'
	language = "Sinta'unathi"
	tail = "sogtail"
	attack_verb = "scratch"
	punch_damage = 5
	primitive = /mob/living/carbon/monkey/unathi
	darksight = 3

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

	flags = IS_WHITELISTED | HAS_LIPS | HAS_UNDERWEAR | HAS_TAIL | HAS_SKIN_COLOR

	flesh_color = "#34AF10"

/datum/species/tajaran
	name = "Tajaran"
	icobase = 'icons/mob/human_races/r_tajaran.dmi'
	deform = 'icons/mob/human_races/r_def_tajaran.dmi'
	language = "Siik'tajr"
	tail = "tajtail"
	attack_verb = "scratch"
	punch_damage = 5
	darksight = 8

	cold_level_1 = 200 //Default 260
	cold_level_2 = 140 //Default 200
	cold_level_3 = 80 //Default 120

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 800 //Default 1000

	primitive = /mob/living/carbon/monkey/tajara

	flags = IS_WHITELISTED | HAS_LIPS | HAS_UNDERWEAR | HAS_TAIL | HAS_SKIN_COLOR

	flesh_color = "#AFA59E"

/datum/species/skrell
	name = "Skrell"
	icobase = 'icons/mob/human_races/r_skrell.dmi'
	deform = 'icons/mob/human_races/r_def_skrell.dmi'
	language = "Skrellian"
	primitive = /mob/living/carbon/monkey/skrell

	flags = IS_WHITELISTED | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR

	flesh_color = "#8CD7A3"

/datum/species/vox
	name = "Vox"
	icobase = 'icons/mob/human_races/r_vox.dmi'
	deform = 'icons/mob/human_races/r_def_vox.dmi'
	language = "Vox-pidgin"

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	eyes = "vox_eyes_s"
	breath_type = "nitrogen"

	flags = NO_SCAN | NO_BLOOD

	blood_color = "#2299FC"
	flesh_color = "#808D11"

/datum/species/vox/armalis
	name = "Vox Armalis"
	icobase = 'icons/mob/human_races/r_armalis.dmi'
	deform = 'icons/mob/human_races/r_armalis.dmi'
	language = "Vox-pidgin"

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	brute_mod = 0.2
	burn_mod = 0.2

	eyes = "blank_eyes"
	breath_type = "nitrogen"

	flags = NO_SCAN | NO_BLOOD | HAS_TAIL | NO_PAIN | IS_WHITELISTED

	blood_color = "#2299FC"
	flesh_color = "#808D11"

	tail = "armalis_tail"

/datum/species/vox/armalis/handle_post_spawn(var/mob/living/carbon/human/H)
	H.verbs += /mob/living/carbon/human/proc/gut
	..()

/datum/species/vox/handle_post_spawn(var/mob/living/carbon/human/H)

	H.verbs += /mob/living/carbon/human/proc/leap

	var/datum/organ/external/affected = H.get_organ("head")

	//To avoid duplicates.
	for(var/obj/item/weapon/implant/cortical/imp in H.contents)
		affected.implants -= imp
		del(imp)

	var/obj/item/weapon/implant/cortical/I = new(H)
	I.imp_in = H
	I.implanted = 1
	affected.implants += I
	I.part = affected

	if(ticker.mode && ( istype( ticker.mode,/datum/game_mode/heist ) ) )
		var/datum/game_mode/heist/M = ticker.mode
		M.cortical_stacks += I
		M.raiders[H.mind] = I

	return ..()

/datum/species/diona
	name = "Diona"
	icobase = 'icons/mob/human_races/r_diona.dmi'
	deform = 'icons/mob/human_races/r_def_plant.dmi'
	language = "Rootspeak"
	attack_verb = "slash"
	punch_damage = 5
	primitive = /mob/living/carbon/monkey/diona

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	flags = IS_WHITELISTED | NO_BREATHE | REQUIRE_LIGHT | NO_SCAN | IS_PLANT | RAD_ABSORB | NO_BLOOD | IS_SLOW | NO_PAIN

	blood_color = "#004400"
	flesh_color = "#907E4A"

/datum/species/diona/handle_post_spawn(var/mob/living/carbon/human/H)
	H.gender = NEUTER

	return ..()

/datum/species/diona/handle_death(var/mob/living/carbon/human/H)

	var/mob/living/carbon/monkey/diona/S = new(get_turf(H))

	if(H.mind)
		H.mind.transfer_to(S)
		S.key = H

	for(var/mob/living/carbon/monkey/diona/D in H.contents)
		if(D.client)
			D.loc = H.loc
		else
			del(D)

	H.visible_message("\red[H] splits apart with a wet slithering noise!")

/datum/species/machine
	name = "Machine"
	icobase = 'icons/mob/human_races/r_machine.dmi'
	deform = 'icons/mob/human_races/r_machine.dmi'
	language = "Tradeband"
	punch_damage = 2

	eyes = "blank_eyes"
	brute_mod = 0.5
	burn_mod = 1

	warning_low_pressure = 50
	hazard_low_pressure = 10

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	flags = IS_WHITELISTED | NO_BREATHE | NO_SCAN | NO_BLOOD | NO_PAIN | IS_SYNTHETIC

	blood_color = "#1F181F"
	flesh_color = "#575757"
