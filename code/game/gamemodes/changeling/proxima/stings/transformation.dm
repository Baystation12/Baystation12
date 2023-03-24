/datum/stings/transformation
	name = "Transformation DNA Sting (30)"
	desc = "Sting a target to transform them."
	icon_state = "sting_transform"
	chemical_cost = 30
	no_lesser = 1
	visible = 1

/datum/stings/transformation/can_sting(user, mob/living/carbon/human/T)
	. = ..()
	if((MUTATION_HUSK in T.mutations) || (T.species.species_flags & SPECIES_FLAG_NO_SCAN))
		to_chat(user, SPAN_LING("Мы не можем подобрать химикаты для преобразования этого существа!"))
		return 0
	if(T.species.species_flags & SPECIES_FLAG_NEED_DIRECT_ABSORB)
		to_chat(user, SPAN_LING("Это жало будет неэффективно против подобного генома."))
		return
	if(islesserform(T))
		to_chat(user, SPAN_LING("Это жало будет неэффективно против подобного генома."))
		return 0

/datum/stings/transformation/sting_action(mob/user, mob/living/T)
	. = ..()
	var/datum/changeling/changeling = user.mind.changeling
	if(!changeling) return 0
	var/list/names = list()
	for(var/datum/absorbed_dna/DNA in changeling.absorbed_dna)
		names += "[DNA.name]"

	var/S = input(user, "Select the target DNA", "Target DNA", "") as null|anything in names
	if(!S) //canceled
		return 0
	if(!user.loc.Adjacent(user, T) //too far
		return 0

	var/datum/absorbed_dna/chosen_dna = changeling.GetDNA(S)
	var/datum/absorbed_dna/old_dna = changeling.GetDNA(T)
	if(!chosen_dna)
		return 0
//	addtimer(CALLBACK(T, /mob/proc/handle_changeling_transform, old_dna), 15 SECONDS)
	T.handle_changeling_transform(chosen_dna)
	spawn(20 SECONDS)
		T.handle_changeling_transform(old_dna)
	SSstatistics.add_field_details("changeling_powers","BS")
