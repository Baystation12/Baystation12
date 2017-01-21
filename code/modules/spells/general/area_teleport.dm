/spell/area_teleport
	name = "Teleport"
	desc = "This spell teleports you to a type of area of your selection."
	feedback = "TP"
	school = "abjuration"
	charge_max = 600
	spell_flags = NEEDSCLOTHES
	invocation = "SCYAR NILA"
	invocation_type = SpI_SHOUT
	cooldown_min = 200 //100 deciseconds reduction per rank

	smoke_spread = 1
	smoke_amt = 5

	var/randomise_selection = 0 //if it lets the usr choose the teleport loc or picks it from the list
	var/invocation_area = 1 //if the invocation appends the selected area

	cast_sound = 'sound/effects/teleport.ogg'

	hud_state = "wiz_tele"

/spell/area_teleport/before_cast()
	return

/spell/area_teleport/choose_targets()
	var/area/thearea
	if(!randomise_selection)
		thearea = input("Area to teleport to", "Teleport") as null|anything in teleportlocs
		if(!thearea) return
	else
		thearea = pick(teleportlocs)
	return list(teleportlocs[thearea])

/spell/area_teleport/cast(area/thearea, mob/user)
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
	while(L.len)
		attempt = pick(L)
		success = user.Move(attempt)
		if(!success)
			L.Remove(attempt)
		else
			break

	if(!success)
		user.loc = pick(L)

	return

/spell/area_teleport/after_cast()
	return

/spell/area_teleport/invocation(mob/user, area/chosenarea)
	if(!istype(chosenarea))
		return //can't have that, can we
	if(!invocation_area || !chosenarea)
		..()
	else
		invocation += "[uppertext(chosenarea.name)]"
		..()
	return
