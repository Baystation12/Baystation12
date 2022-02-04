/obj/item/blueprints
	name = "blueprints"
	desc = "Blueprints..."
	icon = 'icons/obj/items.dmi'
	icon_state = "blueprints"
	attack_verb = list("attacked", "bapped", "hit")
	var/const/AREA_ERRNONE = 0
	var/const/AREA_STATION = 1
	var/const/AREA_SPACE =   2
	var/const/AREA_SPECIAL = 3

	var/const/BORDER_ERROR = 0
	var/const/BORDER_NONE = 1
	var/const/BORDER_BETWEEN =   2
	var/const/BORDER_2NDTILE = 3
	var/const/BORDER_SPACE = 4

	var/const/ROOM_ERR_LOLWAT = 0
	var/const/ROOM_ERR_SPACE = -1
	var/const/ROOM_ERR_TOOLARGE = -2

/obj/item/blueprints/Initialize()
	. = ..()
	desc = "Blueprints of \the [station_name()]. There is a \"Classified\" stamp and several coffee stains on it."

/obj/item/blueprints/attack_self(mob/M as mob)
	if (!istype(M,/mob/living/carbon/human))
		to_chat(M, "This stack of blue paper means nothing to you.")//monkeys cannot into projecting

		return
	interact()

/obj/item/blueprints/DefaultTopicState()
	return GLOB.physical_state

/obj/item/blueprints/OnTopic(user, href_list)
	switch(href_list["action"])
		if ("create_area")
			if (get_area_type()!=AREA_SPACE)
				interact()
				return
			create_area()
		if ("edit_area")
			if (get_area_type()!=AREA_STATION)
				interact()
				return
			edit_area()
		if ("delete_area")
			//skip the sanity checking, delete_area() does it anyway
			delete_area()

/obj/item/blueprints/proc/get_header()
	return "<h2>[station_name()] blueprints</h2><small>Property of [GLOB.using_map.company_name]. For heads of staff only. Store in high-secure storage.</small><hr>"

/obj/item/blueprints/interact()
	var/area/A = get_area(src)
	var/list/dat =  list(get_header())

	switch (get_area_type(A))
		if (AREA_SPACE)
			dat += "According \the [src], you are now <b>outside the facility</b>."
			dat += "<a href='?src=\ref[src];action=create_area'>Mark this place as new area.</a>"
		if (AREA_STATION)
			dat += "According \the [src], you are now in <b>\"[A.name]\"</b>."
			dat += "You may <a href='?src=\ref[src];action=edit_area'> move an amendment</a> to the drawing."
			if (A.apc)
				dat += "You can't erase this area, because it has an APC.</p>"
			else
				dat += "You <a href='?src=\ref[src];action=delete_area'>erase a part of it</a>.</p>"
		else
			dat += "This place isn't noted on \the [src]."
	var/datum/browser/popup = new(usr, "blueprints", name, 290, 300)
	popup.set_content(jointext(dat, "<br>"))
	popup.open()

/obj/item/blueprints/proc/get_area_type(var/area/A = get_area(src))
	if(istype(A, /area/space))
		return AREA_SPACE

	if(A.z in GLOB.using_map.station_levels)
		return AREA_STATION

	return AREA_SPECIAL

/obj/item/blueprints/proc/create_area()
//	log_debug("create_area")

	var/res = detect_room(get_turf(usr))
	if(!istype(res,/list))
		switch(res)
			if(ROOM_ERR_SPACE)
				to_chat(usr, "<span class='warning'>The new area must be completely airtight!</span>")
				return
			if(ROOM_ERR_TOOLARGE)
				to_chat(usr, "<span class='warning'>The new area too large!</span>")
				return
			else
				to_chat(usr, "<span class='warning'>Error! Please notify administration!</span>")
				return
	var/list/turf/turfs = res
	var/str = sanitizeSafe(input("New area name:","Blueprint Editing", ""), MAX_NAME_LEN)
	if(!str || !length(str)) //cancel
		return
	if(length(str) > 50)
		to_chat(usr, "<span class='warning'>Name too long.</span>")
		return
	var/area/A = new
	A.SetName(str)
	A.power_equip = 0
	A.power_light = 0
	A.power_environ = 0
	A.always_unpowered = 0
	for(var/T in turfs)
		ChangeArea(T, A)
	A.always_unpowered = 0
	interact()

/obj/item/blueprints/proc/edit_area()
	var/area/A = get_area(src)

	var/prevname = A.name
	var/str = sanitizeSafe(input("New area name:","Blueprint Editing", prevname), MAX_NAME_LEN)
	if(!str || !length(str) || str==prevname) //cancel
		return
	if(length(str) > 50)
		to_chat(usr, "<span class='warning'>Text too long.</span>")
		return
	set_area_machinery_title(A,str,prevname)
	A.SetName(str)
	to_chat(usr, "<span class='notice'>You set the area '[prevname]' title to '[str]'.</span>")
	interact()

/obj/item/blueprints/proc/delete_area()
	var/area/A = get_area(src)
	if (get_area_type(A)!=AREA_STATION || A.apc) //let's just check this one last time, just in case
		interact()
		return
	to_chat(usr, "<span class='notice'>You scrub [A.name] off the blueprint.</span>")
	log_and_message_admins("deleted area [A.name] via station blueprints.")
	qdel(A)
	interact()

/obj/item/blueprints/proc/set_area_machinery_title(var/area/A,var/title,var/oldtitle)
	if (!oldtitle) // or replacetext_char goes to infinite loop
		return

	for(var/obj/machinery/alarm/M in A)
		M.SetName(replacetext_char(M.name,oldtitle,title))
	for(var/obj/machinery/power/apc/M in A)
		M.SetName(replacetext_char(M.name,oldtitle,title))
	for(var/obj/machinery/atmospherics/unary/vent_scrubber/M in A)
		M.SetName(replacetext_char(M.name,oldtitle,title))
	for(var/obj/machinery/atmospherics/unary/vent_pump/M in A)
		M.SetName(replacetext_char(M.name,oldtitle,title))
	for(var/obj/machinery/door/M in A)
		M.SetName(replacetext_char(M.name,oldtitle,title))
	//TODO: much much more. Unnamed airlocks, cameras, etc.

/obj/item/blueprints/proc/check_tile_is_border(var/turf/T2,var/dir)
	if (istype(T2, /turf/space))
		return BORDER_SPACE //omg hull breach we all going to die here
	if (istype(T2, /turf/simulated/shuttle))
		return BORDER_SPACE
	if (get_area_type(T2.loc)!=AREA_SPACE)
		return BORDER_BETWEEN
	if (istype(T2, /turf/simulated/wall))
		return BORDER_2NDTILE
	if (!istype(T2, /turf/simulated))
		return BORDER_BETWEEN

	for (var/obj/structure/window/W in T2)
		if(turn(dir,180) == W.dir)
			return BORDER_BETWEEN
		if (W.dir in list(NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST))
			return BORDER_2NDTILE
	for(var/obj/machinery/door/window/D in T2)
		if(turn(dir,180) == D.dir)
			return BORDER_BETWEEN
	if (locate(/obj/machinery/door) in T2)
		return BORDER_2NDTILE

	return BORDER_NONE

/obj/item/blueprints/proc/detect_room(var/turf/first)
	var/list/turf/found = new
	var/list/turf/pending = list(first)
	while(pending.len)
		if (found.len+pending.len > 300)
			return ROOM_ERR_TOOLARGE
		var/turf/T = pending[1] //why byond havent list::pop()?
		pending -= T
		for (var/dir in GLOB.cardinal)
			var/skip = 0
			for (var/obj/structure/window/W in T)
				if(dir == W.dir || (W.dir in list(NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST)))
					skip = 1; break
			if (skip) continue
			for(var/obj/machinery/door/window/D in T)
				if(dir == D.dir)
					skip = 1; break
			if (skip) continue

			var/turf/NT = get_step(T,dir)
			if (!isturf(NT) || (NT in found) || (NT in pending))
				continue

			switch(check_tile_is_border(NT,dir))
				if(BORDER_NONE)
					pending+=NT
				if(BORDER_BETWEEN)
					//do nothing, may be later i'll add 'rejected' list as optimization
				if(BORDER_2NDTILE)
					found+=NT //tile included to new area, but we dont seek more
				if(BORDER_SPACE)
					return ROOM_ERR_SPACE
		found+=T
	return found

//For use on exoplanets
/obj/item/blueprints/outpost
	name = "outpost blueprints"
	icon_state = "blueprints2"

/obj/item/blueprints/outpost/Initialize()
	. = ..()
	desc = "Blueprints for the daring souls wanting to establish a planetary outpost. Has some sketchy looking stains and what appears to be bite holes."

/obj/item/blueprints/outpost/get_header()
	return "<h2>Exoplanetary outpost blueprints</h2><small>Property of [GLOB.using_map.company_name].</small><hr>"

/obj/item/blueprints/outpost/check_tile_is_border(var/turf/T2,var/dir)
	if (istype(T2, /turf/unsimulated/floor/exoplanet/))
		return BORDER_SPACE
	. = ..()

/obj/item/blueprints/outpost/get_area_type(var/area/A = get_area(src))
	if(istype(A, /area/exoplanet))
		return AREA_SPACE
	var/obj/effect/overmap/visitable/sector/exoplanet/E = map_sectors["[z]"]
	if(istype(E))
		return AREA_STATION
	return AREA_SPECIAL