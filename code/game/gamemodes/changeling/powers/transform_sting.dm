//Suggested to leave unchecked because this is why we can't have nice things.
/datum/power/changeling/transformation_sting
	name = "Transformation Sting"
	desc = "We silently sting a human, injecting a retrovirus that forces them to transform into another."
	helptext = "Does not provide a warning to others. The victim will transform much like a changeling would."
	genomecost = 3
	verbpath = /mob/proc/changeling_transformation_sting

/mob/proc/changeling_transformation_sting()
	set category = "Changeling"
	set name = "Transformation sting (40)"
	set desc="Sting target"

	var/datum/changeling/changeling = changeling_power(40)
	if(!changeling)
		return 0



	var/list/names = list()
	for(var/datum/dna/DNA in changeling.absorbed_dna)
		names += "[DNA.real_name]"

	var/S = input("Select the target DNA: ", "Target DNA", null) as null|anything in names
	if(!S)
		return

	var/datum/dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	var/mob/living/carbon/T = changeling_sting(40,/mob/proc/changeling_transformation_sting)
	if(!T)
		return 0
	if((HUSK in T.mutations) || (!ishuman(T) && !issmall(T)))
		src << "<span class='warning'>Our sting appears ineffective against its DNA.</span>"
		return 0
	T.visible_message("<span class='warning'>[T] transforms!</span>")
	T.dna = chosen_dna.Clone()
	T.real_name = chosen_dna.real_name
	T.UpdateAppearance()
	domutcheck(T, null)
	feedback_add_details("changeling_powers","TS")
	return 1