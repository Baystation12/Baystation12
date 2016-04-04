/datum/absorbed_dna
	var/name
	var/datum/dna/dna
	var/speciesName
	var/list/languages

/datum/absorbed_dna/New(mob/living/carbon/human/persona)
	..()
	name = persona.real_name
	dna = persona.dna
	speciesName = persona.species.name
	languages = persona.languages.Copy()
