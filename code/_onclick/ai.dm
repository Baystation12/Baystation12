/*
	AI ClickOn()

	Note currently ai restrained() returns 0 in all cases,
	therefore restrained code has been removed

	The AI can double click to move the camera (this was already true but is cleaner),
	or double click a mob to track them.

	Note that AI have no need for the adjacency proc, and so this proc is a lot cleaner.
*/
/mob/living/silicon/ai/DblClickOn(var/atom/A, params)
	if(control_disabled || stat) return

	if(ismob(A))
		ai_actual_track(A)
	else
		A.move_camera_by_click()


/mob/living/silicon/ai/ClickOn(var/atom/A, params)
	if(world.time <= next_click)
		return
	next_click = world.time + 1

	if(stat)
		return

	if(stunned > 0)
		to_chat(src,"<span class = 'warning'>You are stunned and cannot act!</span>")
		return

	if(prepped_command && prepped_command.is_target_valid(A))
		if(prepped_command.working)
			to_chat(src,"<span class = 'notice'>You are already sending a command.</span>")
			return
		prepped_command.working = 1
		to_chat(src,"<span class = 'notice'>Sending command \[[prepped_command.name]\] [prepped_command.requires_target ? "to [A.name]" : ""]</span>")
		if(prepped_command.do_alert)
			do_network_alert("Datastream intercept: [name] is preparing \[[prepped_command.name]\][prepped_command.requires_target ? ", targeting [A.name] at [A.loc.loc.name]" : ""].")
		if(do_after(src,prepped_command.command_delay,eyeobj,needhand = 0,same_direction = 1))
			if(prepped_command)
				prepped_command.send_command(A)
				to_chat(src,"<span class = 'notice'>Prepared command \[[prepped_command.name]\] [prepped_command.requires_target ? "sent to [A.name]." : ""]</span>")
			else
				to_chat(src,"<span class = 'notice'>ERROR: Command has been nulled.</span>")

		if(prepped_command) //Some commands auto-clear once sent.
			prepped_command.working = 0


	if(A.ai_access_level > 0 && check_access_level(A) < A.ai_access_level)
		to_chat(src,"<span class = 'notice'>Insufficient access level in local area to access this machinery.</span>")
		return

	if(console_operating)
		if(!istype(A,/turf/unsimulated/map) && !istype(A,/obj/effect/overmap))
			cancel_camera()
			console_operating = null
		else
			console_operating.fire(A,src)

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A)
		return
	if(modifiers["middle"])
		MiddleClickOn(A)
		return
	if(modifiers["shift"])
		ShiftClickOn(A)
		return
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return

	face_atom(A) // change direction to face what you clicked on

	if(control_disabled || !canClick())
		return

	if(multitool_mode && isobj(A))
		var/obj/O = A
		var/datum/extension/interactive/multitool/MT = get_extension(O, /datum/extension/interactive/multitool)
		if(MT)
			MT.interact(aiMulti, src)
			return

	if(aiCamera.in_camera_mode)
		aiCamera.camera_mode_off()
		aiCamera.captureimage(A, usr)
		return

	/*
		AI restrained() currently does nothing
	if(restrained())
		RestrainedClickOn(A)
	else
	*/
	A.add_hiddenprint(src)
	if(A.ai_access_cost > 0)
		if(spend_cpu(ai_access_cost))
			A.attack_ai(src)
	else
		A.attack_ai(src)

/*
	AI has no need for the UnarmedAttack() and RangedAttack() procs,
	because the AI code is not generic;	attack_ai() is used instead.
	The below is only really for safety, or you can alter the way
	it functions and re-insert it above.
*/
/mob/living/silicon/ai/UnarmedAttack(atom/A)
	A.attack_ai(src)
/mob/living/silicon/ai/RangedAttack(atom/A)
	A.attack_ai(src)

/atom/proc/attack_ai(mob/user as mob)
	return

/*
	Since the AI handles shift, ctrl, and alt-click differently
	than anything else in the game, atoms have separate procs
	for AI shift, ctrl, and alt clicking.
*/

/mob/living/silicon/ai/ShiftClickOn(var/atom/A)
	if(!control_disabled && A.AIShiftClick(src))
		return
	..()

/mob/living/silicon/ai/CtrlClickOn(var/atom/A)
	if(!control_disabled && A.AICtrlClick(src))
		return
	..()

/mob/living/silicon/ai/AltClickOn(var/atom/A)
	if(!control_disabled && A.AIAltClick(src))
		return
	..()

/mob/living/silicon/ai/MiddleClickOn(var/atom/A)
	if(!control_disabled && A.AIMiddleClick(src))
		return
	..()

/*
	The following criminally helpful code is just the previous code cleaned up;
	I have no idea why it was in atoms.dm instead of respective files.
*/

/atom/proc/AICtrlShiftClick()
	return

/atom/proc/AIShiftClick()
	return

/obj/machinery/door/airlock/AIShiftClick()  // Opens and closes doors!
	if(density)
		Topic(src, list("command"="open", "activate" = "1"))
	else
		Topic(src, list("command"="open", "activate" = "0"))
	return 1

/atom/proc/AICtrlClick()
	return

/obj/machinery/door/airlock/AICtrlClick() // Bolts doors
	if(locked)
		Topic(src, list("command"="bolts", "activate" = "0"))
	else
		Topic(src, list("command"="bolts", "activate" = "1"))
	return 1

/obj/machinery/power/apc/AICtrlClick() // turns off/on APCs.
	Topic(src, list("breaker"="1"))
	return 1

/obj/machinery/turretid/AICtrlClick() //turns off/on Turrets
	Topic(src, list("command"="enable", "value"="[!enabled]"))
	return 1

/atom/proc/AIAltClick(var/atom/A)
	return AltClick(A)

/obj/machinery/door/airlock/AIAltClick() // Electrifies doors.
	if(!electrified_until)
		// permanent shock
		Topic(src, list("command"="electrify_permanently", "activate" = "1"))
	else
		// disable/6 is not in Topic; disable/5 disables both temporary and permanent shock
		Topic(src, list("command"="electrify_permanently", "activate" = "0"))
	return 1

/obj/machinery/turretid/AIAltClick() //toggles lethal on turrets
	Topic(src, list("command"="lethal", "value"="[!lethal]"))
	return 1

/obj/machinery/teleport/station/AIAltClick()
	testfire()

/atom/proc/AIMiddleClick(var/mob/living/silicon/user)
	return 0

/obj/machinery/door/airlock/AIMiddleClick() // Toggles door bolt lights.

	if(..())
		return

	if(!src.lights)
		Topic(src, list("command"="lights", "activate" = "1"))
	else
		Topic(src, list("command"="lights", "activate" = "0"))
	return 1

//
// Override AdjacentQuick for AltClicking
//

/mob/living/silicon/ai/TurfAdjacent(var/turf/T)
	return (our_visualnet && our_visualnet.is_turf_visible(T))

/mob/living/silicon/ai/face_atom(var/atom/A)
	if(eyeobj)
		eyeobj.face_atom(A)
