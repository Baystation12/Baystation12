#define NO_EAT 1
#define NO_BREATHE 2
#define NO_SLEEP 4
#define NO_SHOCK 8
#define CLOTHING_RESTRICTED 16
#define NON_GENDERED 32
#define NO_ORGANS 64
#define WHITELISTED 128
#define REQUIRE_LIGHT 256
#define ABHOR_LIGHT 512

/*
	Datum-based species and languages. Should make for much cleaner and easier to maintain mutantrace code.
*/

/datum/language
	var/name            // Fluff name of language if any.
	var/speech_verb     // 'says', 'hisses', 'farts'.
	var/colour          // Colour of strings in this language.
	var/key             // Character used to speak in language eg. :o for Unathi.

/datum/language/unathi
	name = "Sinta'unathi"
	speech_verb = "hisses"
	colour = "soghun"
	key = "o"

/datum/language/tajaran
	name = "Siik'mas"
	speech_verb = "mrowls"
	colour = "tajaran"
	key = "j"

/datum/language/skrell
	name = "Skrellex"
	speech_verb = "warbles"
	colour = "skrell"
	key = "k"

/datum/language/vox
	name = "Vox-pidgin"
	speech_verb = "shrieks"
	colour = "vox"
	key = "v"

/datum/species
	var/name                     // Species name.
	var/icobase                  // Icon file to generate icons from.
	var/deform                   // Icon file for deformities.
	var/primitive                // Lesser form, if any (ie. monkey for humans)
	var/datum/language/language  // Default racial language, if any.

	var/breath_type     // Non-oxygen gas breathed, if any.

	var/heat_min        // Freeze below this point.
	var/heat_max        // Overheat about this point.
	var/pressure_min    // Low-pressure brute below this point.
	var/pressure_max    // Crushing above this point.

	var/brute_resist    // Physical damage reduction.
	var/burn_resist     // Burn damage reduction.

	var/flags = 0       // Various specific features.

/datum/species/human
	name = "Human"
	icobase = 'icons/mob/human_races/r_human.dmi'
	deform = 'icons/mob/human_races/r_def_human.dmi'

/datum/species/unathi
	name = "Unathi"
	icobase = 'icons/mob/human_races/r_lizard.dmi'
	deform = 'icons/mob/human_races/r_def_lizard.dmi'
	language = new /datum/language/unathi

	flags = WHITELISTED

/datum/species/tajaran
	name = "Tajara"
	icobase = 'icons/mob/human_races/r_tajaran.dmi'
	deform = 'icons/mob/human_races/r_def_tajaran.dmi'
	language = new /datum/language/tajaran

	flags = WHITELISTED

/datum/species/skrell
	name = "Skrell"
	icobase = 'icons/mob/human_races/r_skrell.dmi'
	deform = 'icons/mob/human_races/r_def_skrell.dmi'
	language = new /datum/language/skrell

	flags = WHITELISTED

/datum/species/vox
	name = "Vox"
	icobase = 'icons/mob/human_races/r_vox.dmi'
	deform = 'icons/mob/human_races/r_def_vox.dmi'
	language = new /datum/language/vox

	breath_type = "nitrogen"

/datum/species/diona
	name = "Diona"
	icobase = 'icons/mob/human_races/r_plant.dmi'
	deform = 'icons/mob/human_races/r_def_plant.dmi'

	flags = NO_EAT | NO_BREATHE | REQUIRE_LIGHT | NON_GENDERED

/datum/species/shadow
	name = "Shadow"

	flags = ABHOR_LIGHT | NON_GENDERED