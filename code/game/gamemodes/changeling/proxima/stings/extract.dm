/datum/stings/extract_dna
	name = "Extract DNA Sting (40)"
	desc = "Sting a target to extract their DNA."
	icon_state = "sting_extract"
	chemical_cost = 40

/datum/stings/extract_dna/can_sting(user, mob/living/carbon/human/T)
	. = ..()
	if((MUTATION_HUSK in T.mutations) || (T.species.species_flags & SPECIES_FLAG_NO_SCAN))
		to_chat(user, SPAN_LING("Мы не можем извлечь ДНКа этого существа!"))
		return 0
	if(T.species.species_flags & SPECIES_FLAG_NEED_DIRECT_ABSORB)
		to_chat(user, SPAN_LING("ДНКа этого вида слишком сложно и должно быть поглощено напрямую."))
		return
	if(islesserform(T))
		to_chat(user, SPAN_LING("ДНКа этого существа слишком приметивен, чтобы быть совместимым с нашим."))
		return 0
	if(T.stat == DEAD)
		to_chat(user, SPAN_LING("Мы можем извлекать геном только из живых жертв"))
		return 0

/datum/stings/extract_dna/sting_action(mob/user, mob/living/carbon/human/T)
	. = ..()
	var/datum/absorbed_dna/newDNA = new(T.real_name, T.dna, T.species.name, T.languages)
	user.absorbDNA(newDNA)
