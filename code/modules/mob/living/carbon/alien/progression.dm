/mob/living/carbon/alien/Stat()
	. = ..()
	if(. && statpanel("Status"))
		stat("Growth", "[round(amount_grown)]/[max_grown]")

/mob/living/carbon/alien/verb/evolve()

	set name = "Moult"
	set desc = "Moult your skin and become an adult."
	set category = "Abilities"

	if(stat != CONSCIOUS)
		return

	if(!adult_form)
		verbs -= /mob/living/carbon/alien/verb/evolve
		return

	if(handcuffed || legcuffed)
		to_chat(src, "<span class='warning'>You cannot evolve when you are cuffed.</span>")
		return

	if(amount_grown < max_grown)
		to_chat(src, "<span class='warning'>You are not fully grown.</span>")
		return

	// confirm_evolution() handles choices and other specific requirements.
	var/new_species = confirm_evolution()
	if(!new_species || !adult_form )
		return

	var/mob/living/carbon/human/adult = new adult_form(get_turf(src))
	adult.set_species(new_species)
	show_evolution_blurb()
	// TODO: drop a moulted skin. Ew.

	transfer_languages(src, adult)

	if(mind)
		mind.transfer_to(adult)
		if (can_namepick_as_adult)
			var/newname = sanitize(input(adult, "You have become an adult. Choose a name for yourself.", "Adult Name") as null|text, MAX_NAME_LEN)

			if(!newname)
				adult.fully_replace_character_name("[src.adult_name] ([instance_num])")
			else
				adult.fully_replace_character_name(newname)
	else
		adult.key = src.key

	for (var/obj/item/W in src.contents)
		src.drop_from_inventory(W)

	for(var/datum/language/L in languages)
		adult.add_language(L.name)
	qdel(src)

/mob/living/carbon/alien/proc/update_progression()
	if(amount_grown < max_grown)
		amount_grown++
	return

/mob/living/carbon/alien/proc/confirm_evolution()
	return

/mob/living/carbon/alien/proc/show_evolution_blurb()
	return