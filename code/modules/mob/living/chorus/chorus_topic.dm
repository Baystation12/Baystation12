/mob/living/chorus/Topic(var/href, var/list/href_list)
	if(..())
		return 1
	if(href_list["form"])
		var/turf/T = get_turf(src)
		if(T.density || istype(T,/turf/space) || istype(T, /turf/simulated/open))
			to_chat(src, "<span class='warning'><font size=2>You cannot spawn at that location</font></span>")
			return 1
		var/type = locate(href_list["form"]) in subtypesof(/datum/chorus_form)
		if(type)
			set_form(new type)
		return 1
	if(href_list["jump"])
		var/atom/a = locate(href_list["jump"])
		var/follow = 0
		if(href_list["follow"])
			follow = 1
		if(a)
			if(following)
				stop_follow()
			eyeobj.setLoc(get_turf(a))
			if(follow)
				follow_follower(a)
			to_chat(src, "<span class='notice'>[follow ? "Following" : "Jumping to"] \the [a]</span>")
		return 1
	if(href_list["selected"])
		var/datum/chorus_building/cb = form.get_building_by_type(href_list["selected"])
		if(cb)
			set_selected_building(cb)
		return 1
	return 0