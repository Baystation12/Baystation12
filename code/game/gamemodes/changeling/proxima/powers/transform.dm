//Change our DNA to that of somebody we've absorbed.
/mob/proc/changeling_transform()
	set category = "Changeling"
	set name = "Transform (30)"

	var/datum/changeling/changeling = changeling_power(30,1,0)
	if(!changeling)	return

	var/list/names = list()
	for(var/datum/absorbed_dna/DNA in changeling.absorbed_dna)
		names += "[DNA.name]"

	var/S = input("Select the target DNA: ", "Target DNA", null) as null|anything in names
	if(!S)	return

	var/datum/absorbed_dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	changeling.chem_charges -= 30
	changeling.geneticdamage = 30

	var/S_name = chosen_dna.speciesName
	var/datum/species/S_dat = all_species[S_name]
	var/changeTime = 2 SECONDS
	if(mob_size != S_dat.mob_size)
		src.visible_message(SPAN_WARNING("[src]'s body begins to twist, their mass changing rapidly!"))
		changeTime = 8 SECONDS
	else
		src.visible_message(SPAN_WARNING("[src]'s body begins to twist, changing rapidly!"))

	if(!do_after(src, changeTime))
		to_chat(src, SPAN_LING("We fail to change shape."))
		return
	handle_changeling_transform(chosen_dna)

	src.verbs -= /mob/proc/changeling_transform
	spawn(10)
		src.verbs += /mob/proc/changeling_transform

	changeling_update_languages(changeling.absorbed_languages)
	return 1
