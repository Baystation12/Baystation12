/spell/area_teleport
	name = "Teleport"
	desc = "This spell teleports you to a type of area of your selection."
	feedback = "TP"
	school = "conjuration"
	charge_max = 60 SECONDS
	spell_flags = NEEDSCLOTHES
	invocation = "Scyar Nila!"
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
		thearea = input("Area to teleport to", "Teleport") as null|anything in wizteleportlocs
		if(!thearea)
			return
	else
		thearea = pick(wizteleportlocs)
	return list(wizteleportlocs[thearea])

/spell/area_teleport/cast(area/thearea, mob/user)
	playsound(get_turf(user),cast_sound,50,1)
	var/turf/end = user.try_teleport(thearea)

	if(!end)
		to_chat(user, "The spell matrix was unable to locate a suitable teleport destination for an unknown reason. Sorry.")
		return
	return

/spell/area_teleport/check_valid_targets(list/targets)
	// Teleport should function across z's, so we make sure that happens
	// without this check, it only works for teleporting to areas you can see
	return targets && islist(targets) && targets.len > 0

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
