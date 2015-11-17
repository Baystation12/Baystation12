/datum/expansion/multitool/cryo/get_interact_window(var/obj/item/device/multitool/M, var/mob/user)
	return buffer(M)

/datum/expansion/multitool/cryo/receive_buffer(var/obj/item/device/multitool/M, var/atom/buffer, var/mob/user)
	var/obj/machinery/clonepod/P = M.get_buffer(/obj/machinery/clonepod)
	var/obj/machinery/computer/cloning/C = holder

	if(!P)
		user << "<span class='warning'>No valid connection data in \the [M] buffer.</span>"
		return MT_NOACTION

	var/is_connected = (P in C.pods)
	if(!is_connected)
		if(C.connect_pod(P))
			user << "<span class='notice'>You connect \the [P] to \the [C].</span>"
		else
			user << "<span class='warning'>You failed to connect \the [P] to \the [C].</span>"
		return MT_REFRESH

	if(C.release_pod(P))
		user << "<span class='notice'>You disconnect \the [P] from \the [C].</span>"
	else
		user << "<span class='notice'>You failed to disconnect \the [P] from \the [C].</span>"
	return MT_REFRESH
