#define EXOPHAGE_TRAIT_PSYCHICS		"psychics"
#define EXOPHAGE_TRAIT_RESONANCE	"resonance"
#define EXOPHAGE_TRAIT_ENERGISTICS	"energistics"
#define EXOPHAGE_TRAIT_PHYSICALITY	"physicality"

/datum/exophage_build
	var/title

	var/list/traits = list(
		EXOPHAGE_TRAIT_PSYCHICS = /datum/exophage_trait/psychics,
		EXOPHAGE_TRAIT_RESONANCE = /datum/exophage_trait/resonance,
		EXOPHAGE_TRAIT_ENERGISTICS = /datum/exophage_trait/energistics,
		EXOPHAGE_TRAIT_PHYSICALITY = /datum/exophage_trait/physicality
	)

	var/datum/exophage_build/parent //Who made this build's holder, only used during build generation

//See _exophage.dm:27
/datum/exophage_build/New(mob/living/carbon/alien/exophage/X, datum/exophage_build/inheritance)
	if(inheritance)
		parent = inheritance

/datum/exophage_build/proc/generate_build(mob/living/carbon/alien/exophage/X)
//	generate_color()
	generate_traits(X)

/datum/exophage_build/proc/generate_traits(mob/living/carbon/alien/exophage/X)
	new_trait = new()
	new_trait.apply_trait(X, src)

//Generated at X.Login(), assuming it isn't a drone
/datum/exophage_build/proc/generate_title(mob/living/carbon/alien/exophage/X)
	if(X.client) //Since it already checks for !title in X.Login(), why check again?
		var/proper_title = input(X, "Choose a name for your build!", "Exophage Build", title) in GLOB.greek_letters
		title = "\improper [proper_title]-[X.instance_num]"
	return