#define RANDOM_REAGENT list(/datum/reagent/bicaridine, /datum/reagent/kelotane, /datum/reagent/dermaline,\
							/datum/reagent/dylovene, /datum/reagent/dexalin, /datum/reagent/dexalinp,\
							/datum/reagent/tricordrazine, /datum/reagent/tramadol, /datum/reagent/synaptizine)

/datum/reagent/experimental //Father of all strange reagents
	name = "A001"
	taste_description = "slime"
	taste_mult = 2
	description = "An experimental reagent. Causes heavy mutations. Don't smoke."
	reagent_state = SOLID
	color = "#a8a8a8"

/datum/reagent/experimental/affect_touch(mob/living/carbon/M, removed)
	if(prob(33))
		affect_blood(M, removed)

/datum/reagent/experimental/affect_ingest(mob/living/carbon/M, removed)
	if(prob(67))
		affect_blood(M, removed)

/datum/reagent/experimental/affect_blood(mob/living/carbon/M, removed)

	if(M.isSynthetic())
		return

	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.species_flags & SPECIES_FLAG_NO_SCAN))
		return

	if(M.dna)
		if(prob(removed * 0.1)) // Approx. one mutation per 10 injected/20 ingested/30 touching units
			randmuti(M)
			if(prob(98))
				randmutb(M)
			else
				randmutg(M)
			domutcheck(M, null)
			M.UpdateAppearance()
	M.apply_damage(10 * removed, DAMAGE_RADIATION)

/datum/reagent/rsh2
	name = "A002"
	taste_description = "ash"
	taste_mult = 2
	description = "You don't know what's it... Where's your test subject?"
	reagent_state = SOLID
	color = "#a8a8a8"

/datum/reagent/rsh2/New()
	..()
	name = "ER-[rand(9999)]"

/datum/reagent/rsh2/affect_blood(mob/living/carbon/M, removed)
	M.gib()

/datum/reagent/rsh3
	name = "A003"
	taste_description = "flour"
	taste_mult = 2
	description = "You don't know what's it... Where's your test subject?"
	reagent_state = SOLID
	color = "#a8a8a8"

/datum/reagent/rsh3/New()
	..()
	name = "ER-[rand(9999)]"

/datum/reagent/rsh3/affect_blood(mob/living/carbon/human/M, removed)
	for(var/obj/item/organ/external/E in M.bad_external_organs)
		if(E.status & ORGAN_BROKEN && E.damage < E.min_broken_damage)
			E.mend_fracture()
			to_chat(M, "<span class='alium'>You feel something mend itself inside your [E.name].</span>")
		return 1


/datum/reagent/rsh4
	name = "A004"
	taste_description = "milk"
	taste_mult = 2
	description = "You don't know what's it... Where's your test subject?"
	reagent_state = SOLID
	color = "#a8a8a8"

/datum/reagent/rsh4/New()
	..()
	name = "ER-[rand(9999)]"

/datum/reagent/rsh4/affect_blood(mob/living/carbon/human/M, removed)
	if(M.gender != MALE)
		to_chat(M, SPAN_NOTICE("Я чувствую себя... Странно. Мягкое, приятное тепло распространяется по всему моему телу, особенно по груди, почему-то заставляя её становиться... Легче? Меня немного пугает ощущение того, как тепло распространяется по моему паху..."))
		M.gender = MALE
	else
		to_chat(M, SPAN_NOTICE("Я чувствую себя... Странно. Мягкое, приятное тепло распространяется по всему моему телу, особенно по груди, почему-то заставляя её тяжелеть... Меня немного пугает ощущение того, как тепло распространяется по моему паху..."))
		M.gender = FEMALE
	M.update_icon()
	remove_self(volume)
	return



/datum/chemical_reaction/rsh2
	result = /datum/reagent/rsh2
	required_reagents = list(/datum/reagent/experimental = 1)
	result_amount = 1

/datum/chemical_reaction/rsh2/New()
	var/random_amount = pick(1,3)
	required_reagents |= list(pick(RANDOM_REAGENT) = random_amount)
	result_amount += random_amount

/datum/chemical_reaction/rsh3
	result = /datum/reagent/rsh3
	required_reagents = list(/datum/reagent/experimental = 1, /datum/reagent/peridaxon = 1)
	result_amount = 2

/datum/chemical_reaction/rsh3/New()
	var/random_amount = pick(1,3)
	required_reagents |= list(pick(RANDOM_REAGENT) = random_amount)
	result_amount += random_amount

/datum/chemical_reaction/rsh4
	result = /datum/reagent/rsh4
	required_reagents = list(/datum/reagent/experimental = 1, /datum/reagent/paracetamol = 1)
	result_amount = 2

/datum/chemical_reaction/rsh4/New()
	var/random_amount = pick(1,3)
	required_reagents |= list(pick(RANDOM_REAGENT) = random_amount)
	result_amount += random_amount

#undef RANDOM_REAGENT
