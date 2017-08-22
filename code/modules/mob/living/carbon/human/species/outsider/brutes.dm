/datum/species/spartan
	name = "Brute"
	name_plural = "Brutes"
	blurb = ""//Not in chargen
	flesh_color = "#4A4A64"
	blood_color = "#A10808"
	icobase = 'code/modules/halo/icons/species/r_Augmented_Human.dmi' //The DMI needed modification to fit the usual format (see other species' dmis)
	deform = 'code/modules/halo/icons/species/r_Augmented_Human.dmi'
	icon_template = 'code/modules/halo/icons/species/r_Augmented_Human_template.dmi'
	default_language = "Sangheili"
	language = "Sangheili"
	total_health = 200 //Higher base health than spartans and sangheili
	radiation_mod = 0.6
	spawn_flags = SPECIES_IS_WHITELISTED
	brute_mod = 0.9