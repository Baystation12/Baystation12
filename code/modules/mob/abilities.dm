/*
Creature-level abilities.
*/

/var/global/list/ability_verbs = list(	)


/mob/living/carbon/human/slime/proc/slimepeople_ventcrawl()

	set category = "Ability"
	set name = "Ventcrawl (Slime People)"
	set desc = "The ability to crawl through vents if naked and not holding anything."

	if(istype(src,/mob/living/carbon/human/slime))
		var/mob/living/carbon/M = src
		// Check if the client has a mob and if the mob is valid and alive.
		if(M.stat==2)
			M << "\red You must be corporeal and alive to do that."
			return 0

		//Handcuff check.
		if(M.restrained())
			M << "\red You cannot do this while restrained."
			return 0

		if(M.handcuffed)
			M << "\red You cannot do this while cuffed."
			return 0

	handle_ventcrawl()
