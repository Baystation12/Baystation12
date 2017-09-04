/mob/living/deity/Topic(var/href, var/list/href_list)
	if(..())
		return 1
	if(href_list["form"])
		var/type = text2path(href_list["form"])
		set_form(type)
		return 1
	if(href_list["intent"] && href_list["modifier"])
		var/choice = input(src, "Set [href_list["intent"]]:[href_list["modifier"]] to:", "Phenomenas", null) as null|anything in phenomenas
		if(choice && phenomenas[choice])
			var/datum/phenomena/P = phenomenas[choice]
			remove_phenomena_from_intent(P)
			set_phenomena(P, href_list["intent"], href_list["modifier"])
			configure_phenomenas()
		return 1
	if(href_list["jump"])
		var/atom/a = locate(href_list["jump"])
		if(a)
			if(following)
				stop_follow()
			eyeobj.setLoc(get_turf(a))
			to_chat(src, "<span class='notice'>Jumping to \the [a]</span>")
		return 1