/datum/power/changeling/transform
	name = "Transform"
	desc = "We take on the apperance and voice of one we have absorbed."
	genomecost = 0
	verbpath = /mob/proc/changeling_transform

/datum/power/changeling/change_species
	name = "Change Species"
	desc = "We take on the apperance of a species that we have absorbed."
	genomecost = 0
	verbpath = /mob/proc/changeling_change_species

//Change our DNA to that of somebody we've absorbed.
/mob/proc/changeling_transform()
	set category = "Changeling"
	set name = "Transform (5)"

	var/datum/changeling/changeling = changeling_power(5,1,0)
	if(!changeling)	return

	var/list/names = list()
	for(var/datum/dna/DNA in changeling.absorbed_dna)
		names += "[DNA.real_name]"

	var/S = input("Select the target DNA: ", "Target DNA", null) as null|anything in names
	if(!S)	return

	var/datum/dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	changeling.chem_charges -= 5
	src.visible_message("<span class='warning'>[src] transforms!</span>")
	changeling.geneticdamage = 5
	src.dna = chosen_dna.Clone()
	src.dna.b_type = "AB+" //This is needed to avoid blood rejection bugs.  The fact that the blood type might not match up w/ records could be a *FEATURE* too.
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.b_type = "AB+" //For some reason we have two blood types on the mob.
	src.real_name = chosen_dna.real_name
	src.flavor_text = ""
	src.UpdateAppearance()
	domutcheck(src, null)

	src.verbs -= /mob/proc/changeling_transform
	spawn(10)	src.verbs += /mob/proc/changeling_transform

	feedback_add_details("changeling_powers","TR")
	return 1

//Used to switch species based on the changeling datum.
/mob/proc/changeling_change_species()

	set category = "Changeling"
	set name = "Change Species (5)"

	var/mob/living/carbon/human/H = src
	if(!istype(H))
		src << "<span class='warning'>We may only use this power while in humanoid form.</span>"
		return

	var/datum/changeling/changeling = changeling_power(5,1,0)
	if(!changeling)	return

	if(changeling.absorbed_species.len < 2)
		src << "<span class='warning'>We do not know of any other species genomes to use.</span>"
		return

	var/S = input("Select the target species: ", "Target Species", null) as null|anything in changeling.absorbed_species
	if(!S)	return

	domutcheck(src, null)

	changeling.chem_charges -= 5
	changeling.geneticdamage = 5

	src.visible_message("<span class='warning'>[src] transforms!</span>")

	src.verbs -= /mob/proc/changeling_change_species
	H.set_species(S,1) //Until someone moves body colour into DNA, they're going to have to use the default.

	spawn(10)
		src.verbs += /mob/proc/changeling_change_species
		src.regenerate_icons()

	changeling_update_languages(changeling.absorbed_languages)
	feedback_add_details("changeling_powers","TR")

	return 1