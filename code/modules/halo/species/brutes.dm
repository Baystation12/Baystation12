/datum/species/brutes
	name = "Brute"
	name_plural = "Brutes"
	blurb = "The Jiralhanae (Latin, Servus ferox, translated to \"Wild Slave\"), \
		known by humans as Brutes, are the most recent members of the Covenant. \
		They are a large, bipedal, warlike species resembling apes that resent \
		the Sangheili for their respected position in the Covenant. They are organised\
		into tribes and packs, and in combat utilise crute brute force weaponry.\
		If they are hurt or angry eough, they can enter a beserk rage where they are \
		near immune to pain and damage."
	flesh_color = "#4A4A64"
	blood_color = "#A10808"
	icobase = 'code/modules/halo/icons/species/r_Augmented_Human.dmi' //The DMI needed modification to fit the usual format (see other species' dmis)
	deform = 'code/modules/halo/icons/species/r_Augmented_Human.dmi'
	icon_template = 'code/modules/halo/icons/species/r_Augmented_Human_template.dmi'
	default_language = "Sangheili"
	language = "Sangheili"
	flags = NO_MINOR_CUT
	total_health = 200 //Higher base health than spartans and sangheili
	radiation_mod = 0.6
	spawn_flags = SPECIES_IS_WHITELISTED
	brute_mod = 0.9

	ignore_equipment_slowdown = 1

/datum/species/brutes/equip_survival_gear(var/mob/living/carbon/human/H,var/extendedtank = 1)
	return
