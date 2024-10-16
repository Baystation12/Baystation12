/datum/absorbed_dna
	var/name
	var/datum/dna/dna
	var/speciesName
	var/list/languages
	var/gender
	var/pronouns
	var/list/flavour_texts
	var/list/genMods
	var/list/descriptors
	var/list/icon_render_details
/datum/absorbed_dna/New(newName, newDNA, newSpecies, newLanguages, newGender , newPronouns, list/newFlavour, list/New_icon_render_keys, list/newBuild)
	..()
	name = newName
	dna = newDNA
	speciesName = newSpecies
	languages = newLanguages
	gender = newGender
	pronouns = newPronouns
	flavour_texts = newFlavour ? newFlavour.Copy() : null
	icon_render_details = New_icon_render_keys ? New_icon_render_keys : list()
	//defaults to average height and build if none set
	descriptors = newBuild ? newBuild.Copy() : null
