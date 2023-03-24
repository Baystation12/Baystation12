var/list/datum/absorbed_dna/hivemind_bank = list()

/mob/proc/changeling_hiveupload()
	set category = "Changeling"
	set name = "Hive Channel (10)"
	set desc = "Allows you to channel DNA in the airwaves to allow other changelings to absorb it."

	var/datum/changeling/changeling = changeling_power(10,1)
	if(!changeling)	return

	var/list/names = list()
	for(var/datum/absorbed_dna/DNA in changeling.absorbed_dna)
		var/valid = 1
		for(var/datum/absorbed_dna/DNB in hivemind_bank)
			if(DNA.name == DNB.name)
				valid = 0
				break
		if(valid)
			names += DNA.name

	if(names.len <= 0)
		to_chat(src, SPAN_LING("The airwaves already have all of our DNA."))
		return

	var/S = input("Select a DNA to channel: ", "Channel DNA", null) as null|anything in names
	if(!S)	return

	var/datum/absorbed_dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	var/datum/species/spec = all_species[chosen_dna.speciesName]

	if(spec?.species_flags & SPECIES_FLAG_NEED_DIRECT_ABSORB)
		to_chat(src, SPAN_LING("That species must be absorbed directly."))
		return

	changeling.chem_charges -= 10
	hivemind_bank += chosen_dna
	to_chat(src, SPAN_LING("We channel the DNA of [S] to the air."))
	return 1

/mob/proc/changeling_hivedownload()
	set category = "Changeling"
	set name = "Hive Absorb (20)"
	set desc = "Allows you to absorb DNA that is being channeled in the airwaves."

	var/datum/changeling/changeling = changeling_power(20,1)
	if(!changeling)	return

	var/list/names = list()
	for(var/datum/absorbed_dna/DNA in hivemind_bank)
		if(!(changeling.GetDNA(DNA.name)))
			names[DNA.name] = DNA

	if(names.len <= 0)
		to_chat(src, SPAN_LING("There's no new DNA to absorb from the air."))
		return

	var/S = input("Select a DNA absorb from the air: ", "Absorb DNA", null) as null|anything in names
	if(!S)	return
	var/datum/dna/chosen_dna = names[S]
	if(!chosen_dna)
		return

	changeling.chem_charges -= 20
	absorbDNA(chosen_dna)
	to_chat(src, SPAN_LING("We absorb the DNA of [S] from the air."))
	return 1
