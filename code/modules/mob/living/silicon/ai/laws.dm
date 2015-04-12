/mob/living/silicon/ai/proc/show_laws_verb()
	set category = "AI Commands"
	set name = "Show Laws"
	src.show_laws()

/mob/living/silicon/ai/show_laws(var/everyone = 0)
	var/who

	if (everyone)
		who = world
	else
		who = src
		who << "<b>Obey these laws:</b>"

	src.laws_sanity_check()
	src.laws.show_laws(who)

/mob/living/silicon/ai/proc/add_ion_law(var/law)
	src.laws_sanity_check()
	src.laws.add_ion_law(law)
	for(var/mob/living/silicon/robot/R in mob_list)
		if(R.lawupdate && (R.connected_ai == src))
			R.show_laws()

/mob/living/silicon/ai/proc/ai_checklaws()
	set category = "AI Commands"
	set name = "State Laws"
	checklaws()
