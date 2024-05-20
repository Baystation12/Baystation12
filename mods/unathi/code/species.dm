/datum/species/unathi/yeosa/New()
	if (/datum/unarmed_attack/bite/venom in unarmed_types)
		unarmed_types -= /datum/unarmed_attack/bite/venom
	unarmed_types += /datum/unarmed_attack/bite/venom/yeosa
	. = ..()
