/datum/absorbed_dna
	var/name
	var/datum/dna/dna
	var/speciesName
	var/list/languages
	var/list/flavour_texts

/datum/absorbed_dna/New(var/newName, var/newDNA, var/newSpecies, var/newLanguages, var/list/newFlavour)
	..()
	name = newName
	dna = newDNA
	speciesName = newSpecies
	languages = newLanguages
	flavour_texts = newFlavour ? newFlavour.Copy() : null

/datum/changeling/proc/GetDNA(var/dna_owner)
	for(var/datum/absorbed_dna/DNA in absorbed_dna)
		if(dna_owner == DNA.name)
			return DNA

/mob/proc/absorbDNA(var/datum/absorbed_dna/newDNA)
	var/datum/changeling/changeling = null
	if(src.mind?.changeling)
		changeling = src.mind.changeling
	if(!changeling)
		return

	for(var/language in newDNA.languages)
		changeling.absorbed_languages |= language

	changeling_update_languages(changeling.absorbed_languages)

	if(!changeling.GetDNA(newDNA.name)) // Don't duplicate - I wonder if it's possible for it to still be a different DNA? DNA code could use a rewrite
		changeling.absorbed_dna += newDNA
