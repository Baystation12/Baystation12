/datum/exophage_trait/resonance/hivemind
	name = "Exophagic Link"
	examine_desc = "is able to transmit and recieve neural waves on the Exophagic Link"
	gain_text = "Your neurological core ripples as you gain access to the Exophagic Link!"

/datum/exophage_trait/resonance/hivemind/apply_trait(mob/living/carbon/alien/exophage/X, datum/exophage_build/build)
	. = ..()
	X.add_language(LANGUAGE_EXOPHAGE_LINK, TRUE)