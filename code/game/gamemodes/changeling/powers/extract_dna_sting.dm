/datum/power/changeling/extractdna
	name = "Extract DNA"
	desc = "We stealthily sting a target and extract the DNA from them."
	helptext = "Will give you the DNA of your target, allowing you to transform into them. Does not count towards absorb objectives."
	ability_icon_state = "ling_sting_extract"
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
		return FALSE

	var/mob/living/carbon/human/T = changeling_sting(40, /mob/proc/changeling_extract_dna_sting)

	if(!T)
		return

	if(!istype(T) || T.isSynthetic())
		to_chat(src, "<span class='warning'>\The [T] is not compatible with our biology.</span>")
		return FALSE

	if(MUTATION_HUSK in T.mutations)
		to_chat(src, "<span class='warning'>This creature's DNA is ruined beyond useability!</span>")
		return FALSE

	admin_attack_log(src,T,"DNA extraction sting (changeling)")

	var/saved_dna = T.dna.Clone() /// Prevent transforming bugginess.
	var/datum/absorbed_dna/newDNA = new(T.real_name, saved_dna, T.species.name, T.languages, T.gender, T.pronouns, T.flavor_texts, T.icon_render_keys, T.descriptors )
	absorbDNA(newDNA)

	return TRUE
