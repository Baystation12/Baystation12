/datum/absorbed_dna
	var/name
	var/datum/dna/dna
	var/speciesName
	var/list/languages

/datum/absorbed_dna/New(var/newName, var/newDNA, var/newSpecies, var/newLanguages)
	..()
	name = newName
	dna = newDNA
	speciesName = newSpecies
	languages = newLanguages
