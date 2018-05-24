/spell/portal_teleport
	name = "Create Portal"
	desc = "This spell creates a long lasting portal to an area of your selection."
	feedback = "TP"
	school = "conjuration"
	charge_max = 600
	spell_flags = NEEDSCLOTHES
	invocation = "Scyar Peranda!"
	invocation_type = SpI_SHOUT
	charge_max = 30 MINUTES
	cooldown_min = 25 MINUTES

	smoke_spread = 1
	smoke_amt = 5

	var/list/select_areas = list()

	cast_sound = 'sound/effects/teleport.ogg'

	hud_state = "wiz_tele"

/spell/portal_teleport/before_cast()
	return

/spell/portal_teleport/choose_targets()
	var/area/thearea
	var/message = alert("Would you like to show station areas?\nNote: it can take up to 5 minutes for the away sites to load in and show up.",, "Yes", "No")
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
	var/turf/start = get_turf(user)
	var/turf/end = user.try_teleport(thearea)

	if(!end)
		to_chat(user, "The spell matrix was unable to locate a suitable teleport destination for an unknown reason. Sorry.")
		return

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
