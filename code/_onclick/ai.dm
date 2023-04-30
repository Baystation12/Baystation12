/*
	AI ClickOn()

	Note currently ai restrained() returns 0 in all cases,
	therefore restrained code has been removed

	The AI can double click to move the camera (this was already true but is cleaner),
	or double click a mob to track them.

	Note that AI have no need for the adjacency proc, and so this proc is a lot cleaner.
*/
/mob/living/silicon/ai/DblClickOn(atom/A, params)
	if(control_disabled || stat) return

	if(ismob(A))
		ai_actual_track(A)
	else
		A.move_camera_by_click()


/mob/living/silicon/ai/ClickOn(atom/A, params)
	if(world.time <= next_click)
		return
	next_click = world.time + 1

	if(incapacitated())
		return

	var/list/modifiers = params2list(params)
	if (modifiers["ctrl"] && modifiers["alt"] && modifiers["shift"])
		if (!control_disabled && A.AICtrlAltShiftClick(src))
			return TRUE
		if (CtrlAltShiftClickOn(A))
			return TRUE
	else if (modifiers["ctrl"] && modifiers["alt"])
		if (!control_disabled && A.AICtrlAltClick(src))
			return TRUE
		if (CtrlAltClickOn(A))
			return TRUE
	else if (modifiers["shift"] && modifiers["ctrl"])
		if (!control_disabled && A.AICtrlShiftClick(src))
			return TRUE
		if (CtrlShiftClickOn(A))
			return TRUE
	else if (modifiers["shift"] && modifiers["alt"])
		if (!control_disabled && A.AIAltShiftClick(src))
			return TRUE
		if (AltShiftClickOn(A))
			return TRUE
	else if (modifiers["middle"])
		if (!control_disabled && A.AIMiddleClick(src))
			return TRUE
		if (MiddleClickOn(A))
			return TRUE
	else if (modifiers["shift"])
		if (!control_disabled && A.AIShiftClick(src))
			return TRUE
		if (ShiftClickOn(A))
			return TRUE
	else if (modifiers["alt"])
		if (!control_disabled && A.AIAltClick(src))
			return TRUE
		if (AltClickOn(A))
			return TRUE
	else if (modifiers["ctrl"])
		if (!control_disabled && A.AICtrlClick(src))
			return TRUE
		if (CtrlClickOn(A))
			return TRUE

	face_atom(A) // change direction to face what you clicked on

	if(control_disabled || !canClick())
		return

	if(multitool_mode && isobj(A))
		var/obj/O = A
		var/datum/extension/interactive/multitool/MT = get_extension(O, /datum/extension/interactive/multitool)
		if(MT)
			MT.interact(aiMulti, src)
			return

	if(silicon_camera.in_camera_mode)
		silicon_camera.camera_mode_off()
		silicon_camera.captureimage(A, usr)
		return

	/*
		AI restrained() currently does nothing
	if(restrained())
		RestrainedClickOn(A)
	else
	*/
	A.add_hiddenprint(src)
	A.attack_ai(src)

/*
	AI has no need for the UnarmedAttack() and RangedAttack() procs,
	because the AI code is not generic;	attack_ai() is used instead.
	The below is only really for safety, or you can alter the way
	it functions and re-insert it above.
*/
/mob/living/silicon/ai/UnarmedAttack(atom/A)
	A.attack_ai(src)

/mob/living/silicon/ai/RangedAttack(atom/A, params)
	A.attack_ai(src)
	return TRUE


/**
 * Called when an AI mob clicks on an atom.
 *
 * **Parameters**:
 * - `user` - The mob clicking on the atom.
 */
/atom/proc/attack_ai(mob/user as mob)
	return

/*
	The following criminally helpful code is just the previous code cleaned up;
	I have no idea why it was in atoms.dm instead of respective files.
*/

/atom/proc/AICtrlShiftClick()
	return FALSE

/obj/machinery/door/airlock/AICtrlShiftClick() // Electrifies doors.
	if(usr.incapacitated())
		return FALSE
	if(!electrified_until)
		// permanent shock
		Topic(src, list("command"="electrify_permanently", "activate" = "1"))
	else
		// disable/6 is not in Topic; disable/5 disables both temporary and permanent shock
		Topic(src, list("command"="electrify_permanently", "activate" = "0"))
	return TRUE

/atom/proc/AICtrlAltClick()
	return FALSE

/atom/proc/AIShiftClick()
	return FALSE

/obj/machinery/door/airlock/AIShiftClick()  // Opens and closes doors!
	if(usr.incapacitated())
		return FALSE
	if(density)
		Topic(src, list("command"="open", "activate" = "1"))
	else
		Topic(src, list("command"="open", "activate" = "0"))
	return TRUE

/atom/proc/AICtrlClick()
	return FALSE

/obj/machinery/door/airlock/AICtrlClick() // Bolts doors
	if(usr.incapacitated())
		return FALSE
	if(locked)
		Topic(src, list("command"="bolts", "activate" = "0"))
	else
		Topic(src, list("command"="bolts", "activate" = "1"))
	return TRUE

/obj/machinery/power/apc/AICtrlClick() // turns off/on APCs.
	if(usr.incapacitated())
		return FALSE
	Topic(src, list("breaker"="1"))
	return TRUE

/obj/machinery/turretid/AICtrlClick() //turns off/on Turrets
	if(usr.incapacitated())
		return FALSE
	Topic(src, list("command"="enable", "value"="[!enabled]"))
	return TRUE

/atom/proc/AIAltClick(atom/A)
	return FALSE

/obj/machinery/turretid/AIAltClick() //toggles lethal on turrets
	if(usr.incapacitated())
		return FALSE
	Topic(src, list("command"="lethal", "value"="[!lethal]"))
	return TRUE

/atom/proc/AIMiddleClick(mob/living/silicon/user)
	return FALSE

/obj/machinery/door/airlock/AIMiddleClick() // Toggles door bolt lights.
	if(usr.incapacitated())
		return FALSE
	if(..())
		return TRUE

	if(!src.lights)
		Topic(src, list("command"="lights", "activate" = "1"))
	else
		Topic(src, list("command"="lights", "activate" = "0"))
	return TRUE


/atom/proc/AIAltShiftClick(atom/A)
	return FALSE


/atom/proc/AICtrlAltShiftClick(atom/A)
	return FALSE


//
// Override AdjacentQuick for AltClicking
//

/mob/living/silicon/ai/TurfAdjacent(turf/T)
	return (cameranet && cameranet.is_turf_visible(T))

/mob/living/silicon/ai/face_atom(atom/A)
	if(eyeobj)
		eyeobj.face_atom(A)
