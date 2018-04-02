/spell/portal_teleport
	name = "Create Portal"
	desc = "This spell creates a long lasting portal to an area of your selection."
	feedback = "TP"
	school = "conjuration"
	charge_max = 600
	spell_flags = NEEDSCLOTHES
	invocation = "Scyar Peranda!"
	invocation_type = SpI_SHOUT
	cooldown_min = 30 MINUTES //100 deciseconds reduction per rank

	smoke_spread = 1
	smoke_amt = 5

	var/list/select_areas = list()

	cast_sound = 'sound/effects/teleport.ogg'

	hud_state = "wiz_tele"

/spell/portal_teleport/before_cast()
	return

/spell/portal_teleport/choose_targets()
	var/area/thearea
	var/message = alert("Would you like to show station areas?",, "Yes", "No")
	switch(message)
		if("Yes")
			select_areas = stationlocs
		if("No")
			select_areas = (stationlocs) ^ (wizportallocs)

	thearea = input("Area to teleport to", "Teleport") as null|anything in select_areas
	if(!thearea) return

	return list(select_areas[thearea])

/spell/portal_teleport/cast(area/thearea, mob/user)
	playsound(get_turf(user),cast_sound,50,1)
	if(!istype(thearea))
		if(istype(thearea, /list))
			thearea = thearea[1]
	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea))
		if(!T.density)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L+=T

	if(!L.len)
		to_chat(user, "The spell matrix was unable to locate a suitable teleport destination for an unknown reason. Sorry.")
		return

	if(user && user.buckled)
		user.buckled = null

	var/attempt = null
	var/success = 0
	var/turf/start = get_turf(user)
	var/turf/end
	while(L.len)
		attempt = pick(L)
		success = user.Move(attempt)
		if(!success)
			L.Remove(attempt)
		else
			end = attempt
			break

	if(!success)
		end = pick(L)
		user.loc = end

	new /obj/effect/portal/wizard(start, end, 35 MINUTES)
	new /obj/effect/portal/wizard(end, start, 35 MINUTES)

	return

/spell/portal_teleport/after_cast()
	return

/spell/portal_teleport/invocation(mob/user, area/chosenarea)
	if(!chosenarea || !istype(chosenarea))
		..()
	else
		invocation += "[uppertext(chosenarea.name)]"
		..()
	return

/obj/effect/portal/wizard
	name = "dark anomaly"
	desc = "It pulls on the edges of reality as if trying to draw them in."
	icon = 'icons/obj/objects.dmi'
	icon_state = "bhole3"
