/datum/build_mode/throw_at
	name = "Throw At"
	icon_state = "buildmode4"
	var/atom/movable/to_throw

/datum/build_mode/throw_at/Destroy()
	ClearThrowable()
	. = ..()

/datum/build_mode/throw_at/Help()
	to_chat(user, SPAN_NOTICE("***********************************************************"))
	to_chat(user, SPAN_NOTICE("Left Click on Movable Atom = Select object to be thrown"))
	to_chat(user, SPAN_NOTICE("Right Click on Atom        = Throw at the target"))
	to_chat(user, SPAN_NOTICE("***********************************************************"))

/datum/build_mode/throw_at/OnClick(atom/A, list/parameters)
	if(parameters["left"])
		if(istype(A, /atom/movable))
			SetThrowable(A)
	else if(parameters["right"])
		if(to_throw)
			if(!isturf(to_throw.loc))
				to_chat(user, SPAN_WARNING("\The [to_throw] is currently not on a turf and cannot be thrown."))
			else
				to_throw.throw_at(A, 10, 1)
				Log("Threw '[log_info_line(to_throw)]' at '[log_info_line(A)]'")
		else
			to_chat(user, SPAN_WARNING("You have nothing selected to throw."))

/datum/build_mode/throw_at/proc/SetThrowable(new_throwable)
	if(to_throw == new_throwable)
		return
	ClearThrowable()

	to_throw = new_throwable
	GLOB.destroyed_event.register(to_throw, src, /datum/build_mode/throw_at/proc/ClearThrowable)
	to_chat(user, SPAN_NOTICE("Will now be throwing \the [to_throw]."))

/datum/build_mode/throw_at/proc/ClearThrowable(feedback)
	if(!to_throw)
		return

	GLOB.destroyed_event.unregister(to_throw, src, /datum/build_mode/throw_at/proc/ClearThrowable)
	to_throw = null
	if(feedback)
		Warn("The selected throwing object was deleted.")
