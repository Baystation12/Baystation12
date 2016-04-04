/datum/power/changeling/transform
	name = "Transform"
	desc = "We take on the apperance and voice of one we have absorbed."
	genomecost = 0
	verbpath = /mob/proc/changeling_transform

//Change our DNA to that of somebody we've absorbed.
/mob/proc/changeling_transform()
	set category = "Changeling"
	set name = "Transform (5)"

	var/datum/changeling/changeling = changeling_power(5,1,0)
	if(!changeling)	return

	var/list/names = list()
	for(var/datum/absorbed_dna/DNA in changeling.absorbed_dna)
		names += "[DNA.name]"

	var/S = input("Select the target DNA: ", "Target DNA", null) as null|anything in names
	if(!S)	return

	var/datum/absorbed_dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	changeling.chem_charges -= 5
	src.visible_message("<span class='warning'>[src] transforms!</span>")
	changeling.geneticdamage = 5

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/newSpecies = chosen_dna.speciesName
		H.set_species(newSpecies,1)

	src.dna = chosen_dna.dna.Clone()
	src.dna.b_type = "AB+" //This is needed to avoid blood rejection bugs.  The fact that the blood type might not match up w/ records could be a *FEATURE* too.
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.b_type = "AB+" //For some reason we have two blood types on the mob.
		for(var/flavor in H.flavor_texts) //Nulls out flavor text, so we don't keep our previous mob's flavor.
			flavor = null
	src.real_name = chosen_dna.name
	src.flavor_text = ""
	src.UpdateAppearance()
	domutcheck(src, null)
	changeling_update_languages(changeling.absorbed_languages)

	src.verbs -= /mob/proc/changeling_transform
	spawn(10)
		src.verbs += /mob/proc/changeling_transform
		src.regenerate_icons()

	feedback_add_details("changeling_powers","TR")

	return 1
