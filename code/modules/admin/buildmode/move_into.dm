/datum/build_mode/move_into
	name = "Move Into"
	icon_state = "buildmode7"

	var/atom/destination

/datum/build_mode/move_into/Destroy()
	ClearDestination()
	. = ..()

/datum/build_mode/move_into/Help()
	to_chat(user, SPAN_NOTICE("***********************************************************"))
	to_chat(user, SPAN_NOTICE("Left Click                  = Select destination"))
	to_chat(user, SPAN_NOTICE("Right Click on Movable Atom = Move target into destination"))
	to_chat(user, SPAN_NOTICE("***********************************************************"))

/datum/build_mode/move_into/OnClick(atom/movable/A, list/parameters)
	if(parameters["left"])
		SetDestination(A)
	if(parameters["right"])
		if(!destination)
			to_chat(user, SPAN_WARNING("No target destination."))
		else if(!ismovable(A))
			to_chat(user, SPAN_WARNING("\The [A] must be of type /atom/movable."))
		else
			to_chat(user, SPAN_NOTICE("Moved \the [A] into \the [destination]."))
			Log("Moved '[log_info_line(A)]' into '[log_info_line(destination)]'.")
			A.forceMove(destination)

/datum/build_mode/move_into/proc/SetDestination(atom/A)
	if(A == destination)
		return
	ClearDestination()

	destination = A
	GLOB.destroyed_event.register(destination, src, TYPE_PROC_REF(/datum/build_mode/move_into, ClearDestination))
	to_chat(user, SPAN_NOTICE("Will now move targets into \the [destination]."))

/datum/build_mode/move_into/proc/ClearDestination(feedback)
	if(!destination)
		return

	GLOB.destroyed_event.unregister(destination, src, TYPE_PROC_REF(/datum/build_mode/move_into, ClearDestination))
	destination = null
	if(feedback)
		Warn("The selected destination was deleted.")
