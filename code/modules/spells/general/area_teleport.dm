/spell/area_teleport
	name = "Teleport"
	desc = "This spell teleports you to a type of area of your selection."
	feedback = "TP"
	school = "conjuration"
	charge_max = 600
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
		if(!thearea) return
	else
		thearea = pick(wizteleportlocs)
	return list(wizteleportlocs[thearea])

/spell/area_teleport/cast(area/thearea, mob/user)
	playsound(get_turf(user),cast_sound,50,1)
	var/turf/end = user.try_teleport(thearea)

	if(!end)
		to_chat(user, "The spell matrix was unable to locate a suitable teleport destination for an unknown reason. Sorry.")
		return
	if(user.incapacitated(INCAPACITATION_STUNNED | INCAPACITATION_FORCELYING | INCAPACITATION_KNOCKOUT))
		to_chat(user, "<span class='warning'>You can't cast this spell while incapacitated!</span>")
		return
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
