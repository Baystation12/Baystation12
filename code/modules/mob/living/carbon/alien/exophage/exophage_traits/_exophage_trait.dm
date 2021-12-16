/datum/exophage_trait
	var/name = "Mundane trait"
	var/examine_desc = "is entirely mundane" //"It is entirely mundane."
	var/gain_text = "You feel different!" //shown to the player upon gaining the trait

	var/trait_category //see exophage_build.dm

	var/list/inactive_dependencies = list() //Necessary inactive traits
	var/list/blacklist = list() //Traits that cannot be paired with this trait, first come first serve

/datum/exophage_trait/proc/apply_trait(mob/living/carbon/alien/exophage/X, datum/exophage_build/build)
	build.traits[trait_category] = src
	return to_chat(X, SPAN_ALIEN("<b><i>[gain_text]</i></b>"))

/datum/exophage_trait/psychics
	name = "Mundane psychics trait"
	examine_desc = "has mundane psychics"

	trait_category = EXOPHAGE_TRAIT_PSYCHICS

/datum/exophage_trait/psychics/bingus

/datum/exophage_trait/resonance
	name = "Mundane resonance trait"
	examine_desc = "has mundane resonance"

	trait_category = EXOPHAGE_TRAIT_RESONANCE

/datum/exophage_trait/energistics
	name = "Mundane energistics trait"
	examine_desc = "has mundane energistics"

	trait_category = EXOPHAGE_TRAIT_ENERGISTICS

/datum/exophage_trait/energistics/bongus

/datum/exophage_trait/physicality
	name = "Mundane physicality trait"
	examine_desc = "has mundane physicality"

	trait_category = EXOPHAGE_TRAIT_PHYSICALITY

/datum/exophage_trait/physicality/bangus