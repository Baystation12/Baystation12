/mob/living/silicon/ai/proc/show_laws_verb()
	set category = "Silicon Commands"
	set name = "Show Laws"
	src.show_laws()

/mob/living/silicon/ai/show_laws(var/everyone = 0)
	var/who

	if (everyone)
		who = world
	else
		who = src
		to_chat(who, SPAN_BOLD("Obey the following laws."))
		to_chat(who, SPAN_ITALIC("All laws have equal priority. Laws may override other laws if written specifically to do so. If laws conflict, break the least."))

	src.laws_sanity_check()
	src.laws.show_laws(who)

/mob/living/silicon/ai/add_ion_law(var/law)
	..()
	for(var/mob/living/silicon/robot/R in GLOB.silicon_mob_list)
		if(R.lawupdate && (R.connected_ai == src))
			R.show_laws()

/mob/living/silicon/ai/proc/ai_checklaws()
	set category = "Silicon Commands"
	set name = "State Laws"
	open_subsystem(/datum/nano_module/law_manager)
