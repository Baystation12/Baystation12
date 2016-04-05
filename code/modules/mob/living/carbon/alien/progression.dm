/mob/living/carbon/alien/proc/update_progression()
	if(amount_grown < max_grown)
		amount_grown++
	return

/mob/living/carbon/alien/proc/confirm_evolution()
	return

/mob/living/carbon/alien/proc/show_evolution_blurb()
	return

/spell/evolve
	name = "Evolve"
	desc = "Moult your skin and become an adult."
	spell_flags = 0
	charge_max = 0
	custom_stat = 1

/spell/evolve/get_stat()
	if(!istype(holder,/mob/living/carbon/alien))
		return "Free"
	var/mob/living/carbon/alien/A = holder
	return "[A.amount_grown]/[A.max_grown]"

/spell/evolve/choose_targets()
	if(!istype(holder,/mob/living/carbon/alien))
		var/mob/M = holder
		M.remove_spell(src)
		return null
	var/mob/living/carbon/alien/A = holder
	if(!A.adult_form)
		A.remove_spell(src)
		A << "<span class='warning'>You don't have an evolved form!</span>"
		return null
	if(A.amount_grown < A.max_grown)
		holder << "<span class='warning'>You are not fully grown.</span>"
		return null
	return list(holder)

/spell/evolve/cast(var/list/targets, var/mob/user)
	var/mob/living/carbon/alien/A = targets[1]
	var/new_species = A.confirm_evolution()
	if(!new_species)
		return
	var/mob/living/carbon/human/adult = new A.adult_form(get_turf(A))
	adult.set_species(new_species)
	A.show_evolution_blurb()
	for (var/obj/item/W in A.contents)
		A.drop_from_inventory(W)
	if(A.mind)
		A.mind.transfer_to(adult)
	else
		adult.key = A.key
	for(var/datum/language/L in A.languages)
		adult.add_language(L.name)
	qdel(A)

/spell/evolve/larva
	hud_state = "alien_evolve_larva"

/spell/evolve/nymph
	hud_state = "alien_evolve_nymph"