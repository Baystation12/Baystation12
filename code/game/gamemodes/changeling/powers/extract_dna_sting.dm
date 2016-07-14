/datum/power/changeling/extractdna
	name = "Extract DNA"
	desc = "We stealthily sting a target and extract the DNA from them."
	helptext = "Will give you the DNA of your target, allowing you to transform into them. Does not count towards absorb objectives."
	genomecost = 0
	allowduringlesserform = 1
	verbpath = /mob/proc/changeling_extract_dna_sting

/mob/proc/changeling_extract_dna_sting()
	set category = "Changeling"
	set name = "Extract DNA Sting (40)"
	set desc="Stealthily sting a target to extract their DNA."

	var/datum/changeling/changeling = null
	if(src.mind && src.mind.changeling)
		changeling = src.mind.changeling
	if(!changeling)
		return 0

	var/mob/living/carbon/human/T = changeling_sting(40, /mob/proc/changeling_extract_dna_sting)

	if(!T)
		return

	if(!istype(T) || T.isSynthetic())
		src << "<span class='warning'>\The [T] is not compatible with our biology.</span>"
		return 0

	if(T.species.flags & NO_SCAN)
		src << "<span class='warning'>We do not know how to parse this creature's DNA!</span>"
		return 0

	if(HUSK in T.mutations)
		src << "<span class='warning'>This creature's DNA is ruined beyond useability!</span>"
		return 0

	var/datum/absorbed_dna/newDNA = new(T)
	absorbDNA(newDNA)

	feedback_add_details("changeling_powers","ED")
	return 1

