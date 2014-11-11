/mob/living/carbon/alien/verb/evolve()

	set name = "Evolve"
	set desc = "Evolve into your adult form."
	set category = "Abilities"

	if(stat != CONSCIOUS)
		return

	if(!adult_form)
		verbs -= /mob/living/carbon/alien/verb/evolve
		return

	if(handcuffed || legcuffed)
		src << "\red You cannot evolve when you are cuffed."
		return

	if(amount_grown < max_grown)
		src << "\red You are not fully grown."
		return

	// confirm_evolution() handles choices and other specific requirements.
	var/new_species = confirm_evolution()
	if(!new_species || !adult_form )
		return

	var/mob/living/carbon/human/adult = new adult_form(get_turf(src))
	adult.set_species(new_species)
	show_evolution_blurb()

	if(mind)
		mind.transfer_to(adult)
	else
		adult.key = src.key

	for (var/obj/item/W in src.contents)
		src.drop_from_inventory(W)

	for(var/datum/language/L in languages)
		adult.add_language(L.name)
	del(src)

/mob/living/carbon/alien/proc/update_progression()
	return

/mob/living/carbon/alien/proc/confirm_evolution()
	return

/mob/living/carbon/alien/proc/show_evolution_blurb()
	return