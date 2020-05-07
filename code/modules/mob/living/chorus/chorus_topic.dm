/mob/living/chorus/OnSelfTopic(var/href_list)
	if(href_list["form"])
		var/turf/T = get_turf(eyeobj)
		if(T.density || istype(T,/turf/space) || istype(T, /turf/simulated/open))
			to_chat(src, "<span class='warning'><font size=2>You cannot spawn at that location</font></span>")
			return TOPIC_HANDLED
		var/type = locate(href_list["form"]) in subtypesof(/datum/chorus_form)
		if(type)
			forceMove(T)
			chorus_net.remove_source(eyeobj)
			set_form(new type)
		return TOPIC_HANDLED
	if(href_list["jump"])
		var/atom/a = locate(href_list["jump"])
		var/follow = 0
		if(href_list["follow"])
			follow = 1
		if(a)
			if(follow)
				follow_follower(a)
			else
				eyeobj.EyeMove(get_turf(a))
		return TOPIC_HANDLED
	if(href_list["selected"])
		var/datum/chorus_building/cb = form.get_building_by_type(href_list["selected"])
		if(cb)
			set_selected_building(cb)
		return TOPIC_HANDLED
	return ..()