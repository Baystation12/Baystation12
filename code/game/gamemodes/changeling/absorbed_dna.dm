/datum/absorbed_dna
	var/name
	var/gender
	var/datum/dna/dna
	var/speciesName
	var/list/languages
	var/list/flavour_texts

/datum/absorbed_dna/New(mob/living/carbon/human/persona)
	..()
	name = persona.real_name
	gender = persona.gender
	dna = persona.dna
	speciesName = persona.species.name
	languages = persona.languages.Copy()
	flavour_texts = persona.flavor_texts.Copy()
