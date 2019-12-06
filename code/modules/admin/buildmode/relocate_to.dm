/datum/build_mode/relocate_to
	name = "Relocate To"
	icon_state = "buildmode9"
	var/atom/movable/to_relocate

/datum/build_mode/relocate_to/Destroy()
	ClearRelocator()
	. = ..()

/datum/build_mode/relocate_to/Help()
	to_chat(user, "<span class='notice'>***********************************************************</span>")
	to_chat(user, "<span class='notice'>Left Click on Movable Atom = Select object to be relocated</span>")
	to_chat(user, "<span class='notice'>Right Click on Turf        = Destination to be relocated to</span>")
	to_chat(user, "<span class='notice'>***********************************************************</span>")

/datum/build_mode/relocate_to/OnClick(var/atom/A, var/list/parameters)
	if(parameters["left"])
		if(istype(A, /atom/movable))
			SetRelocator(A)
	else if(parameters["right"])
		if(to_relocate)
			var/destination_turf = get_turf(A)
			if(destination_turf)
				to_relocate.forceMove(destination_turf)
				Log("Relocated '[log_info_line(to_relocate)]' to '[log_info_line(destination_turf)]'")
			else
				to_chat(user, "<span class='warning'>Unable to locate destination turf.</span>")
		else
			to_chat(user, "<span class='warning'>You have nothing selected to relocate.</span>")

/datum/build_mode/relocate_to/proc/SetRelocator(var/new_relocator)
	if(to_relocate == new_relocator)
		return
	ClearRelocator()

	to_relocate = new_relocator
	GLOB.destroyed_event.register(to_relocate, src, /datum/build_mode/relocate_to/proc/ClearRelocator)
	to_chat(user, "<span class='notice'>Will now be relocating \the [to_relocate].</span>")

/datum/build_mode/relocate_to/proc/ClearRelocator(var/feedback)
	if(!to_relocate)
		return

	GLOB.destroyed_event.unregister(to_relocate, src, /datum/build_mode/relocate_to/proc/ClearRelocator)
	to_relocate = null
	if(feedback)
		Warn("The selected relocation object was deleted.")
