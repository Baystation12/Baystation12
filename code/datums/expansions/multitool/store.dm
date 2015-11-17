/datum/expansion/multitool/store
	var/can_load_connection

/datum/expansion/multitool/store/New(var/atom/holder, var/can_load_connection)
	..()
	src.can_load_connection = can_load_connection

/datum/expansion/multitool/store/CanUseTopic()
	if(can_load_connection && !call(src, can_load_connection)())
		return STATUS_CLOSE
	return ..()

/datum/expansion/multitool/store/interact(var/obj/item/device/multitool/M, var/mob/user)
	if(!CanUseTopic(user))
		return

	if(M.get_buffer() == holder)
		M.set_buffer(null)
		user << "<span class='warning'>You purge the connection data of \the [holder] from \the [M].</span>"
	else
		M.set_buffer(holder)
		user << "<span class='notice'>You load connection data from \the [holder] to \the [M].</span>"
