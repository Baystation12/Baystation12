#define NO_EAT 1
#define NO_BREATHE 2
#define NO_SLEEP 4
#define NO_SHOCK 8
#define NO_SCAN 16
#define NON_GENDERED 32
#define REQUIRE_LIGHT 64
#define WHITELISTED 128
#define HAS_SKIN_TONE 256
#define HAS_LIPS 512
#define HAS_UNDERWEAR 1024
#define HAS_TAIL 2048
#define IS_PLANT 4096

/*
	Datum-based species. Should make for much cleaner and easier to maintain mutantrace code.
*/

/datum/species
	var/name                     // Species name.

	var/icobase = 'icons/mob/human_races/r_human.dmi'    // Normal icon set.
	var/deform = 'icons/mob/human_races/r_def_human.dmi' // Mutated icon set.
	var/eyes = "eyes_s"                                  // Icon for eyes.

	var/tail                     // Name of tail image in species effects icon file.
	var/primitive                // Lesser form, if any (ie. monkey for humans)
	var/datum/language/language  // Default racial language, if any.
	var/attack_verb = "punch"    // Empty hand hurt intent verb.

	var/breath_type     // Non-oxygen gas breathed, if any.

	var/cold_level_1 = 260  // Cold damage level 1 below this point.
	var/cold_level_2 = 200  // Cold damage level 2 below this point.
	var/cold_level_3 = 120  // Cold damage level 3 below this point.

	var/heat_level_1 = 360  // Heat damage level 1 above this point.
	var/heat_level_2 = 400  // Heat damage level 2 above this point.
	var/heat_level_3 = 1000 // Heat damage level 2 above this point.

	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE   // Dangerously high pressure.
	var/warning_high_pressure = WARNING_HIGH_PRESSURE // High pressure warning.
	var/warning_low_pressure = WARNING_LOW_PRESSURE   // Low pressure warning.
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE     // Dangerously low pressure.

	var/brute_resist    // Physical damage reduction.
	var/burn_resist     // Burn damage reduction.

	var/flags = 0       // Various specific features.

/datum/species/human
	name = "Human"
	flags = HAS_LIPS | HAS_UNDERWEAR

/datum/species/unathi
	name = "Unathi"
	icobase = 'icons/mob/human_races/r_lizard.dmi'
	deform = 'icons/mob/human_races/r_def_lizard.dmi'
	language = new /datum/language/unathi
	tail = "sogtail"
	attack_verb = "scratch"

	flags = WHITELISTED | HAS_LIPS | HAS_UNDERWEAR | HAS_TAIL

/datum/species/tajaran
	name = "Tajara"
	icobase = 'icons/mob/human_races/r_tajaran.dmi'
	deform = 'icons/mob/human_races/r_def_tajaran.dmi'
	language = new /datum/language/tajaran
	tail = "tajtail"
	attack_verb = "scratch"

	flags = WHITELISTED | HAS_LIPS | HAS_UNDERWEAR | HAS_TAIL

/datum/species/skrell
	name = "Skrell"
	icobase = 'icons/mob/human_races/r_skrell.dmi'
	deform = 'icons/mob/human_races/r_def_skrell.dmi'
	language = new /datum/language/skrell

	flags = WHITELISTED | HAS_LIPS | HAS_UNDERWEAR

/datum/species/vox
	name = "Vox"
	icobase = 'icons/mob/human_races/r_vox.dmi'
	deform = 'icons/mob/human_races/r_def_vox.dmi'
	language = new /datum/language/vox

	eyes = "vox_eyes_s"
	breath_type = "nitrogen"

	flags = NO_SCAN

/datum/species/diona
	name = "Diona"
	icobase = 'icons/mob/human_races/r_plant.dmi'
	deform = 'icons/mob/human_races/r_def_plant.dmi'
	attack_verb = "slash"

	flags = NO_EAT | NO_BREATHE | REQUIRE_LIGHT | NON_GENDERED | NO_SCAN | IS_PLANT