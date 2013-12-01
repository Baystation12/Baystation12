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

	var/brute_resist    // Physical damage reduction.
	var/burn_resist     // Burn damage reduction.

	var/flags = 0       // Various specific features.

	var/list/abilities = list()	// For species-derived or admin-given powers

/datum/species/human
	name = "Human"
	language = "Sol Common"
	primitive = /mob/living/carbon/monkey

	flags = HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR

	/*abilities = list(
		/client/proc/test_ability,
		)*/

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

	flags = WHITELISTED | HAS_LIPS | HAS_UNDERWEAR | HAS_TAIL

	/*abilities = list(
		/client/proc/test_ability,
		/client/proc/unathi_ability
		)*/

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

	flags = WHITELISTED | HAS_LIPS | HAS_UNDERWEAR | HAS_TAIL

	/*abilities = list(
		/client/proc/test_ability,
		/client/proc/tajaran_ability
		)*/

/datum/species/skrell
	name = "Skrell"
	icobase = 'icons/mob/human_races/r_skrell.dmi'
	deform = 'icons/mob/human_races/r_def_skrell.dmi'
	language = "Skrellian"
	primitive = /mob/living/carbon/monkey/skrell

	flags = WHITELISTED | HAS_LIPS | HAS_UNDERWEAR

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

	flags = NO_SCAN

/datum/species/diona
	name = "Diona"
	icobase = 'icons/mob/human_races/r_plant.dmi'
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

	flags = WHITELISTED | NO_BREATHE | REQUIRE_LIGHT | NON_GENDERED | NO_SCAN | IS_PLANT | RAD_ABSORB
