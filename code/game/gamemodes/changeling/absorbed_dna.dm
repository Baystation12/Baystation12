/datum/absorbed_dna
	var/name
	var/datum/dna/dna
	var/speciesName
	var/list/languages
	var/gender
	var/list/flavour_texts
	var/list/genMods

/datum/absorbed_dna/New(var/newName, var/newDNA, var/newSpecies, var/newLanguages, var/newGender, var/list/newFlavour, var/list/newGenMods)
	..()
	name = newName
	dna = newDNA
	speciesName = newSpecies
	languages = newLanguages
	gender = newGender
	flavour_texts = newFlavour ? newFlavour.Copy() : null
	genMods = newGenMods ? newGenMods.Copy() : null
