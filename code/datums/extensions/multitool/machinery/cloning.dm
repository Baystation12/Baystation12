/datum/extension/interactive/multitool/cryo/get_interact_window(var/obj/item/device/multitool/M, var/mob/user)
	. += buffer(M)
	. += "<HR><b>Connected Cloning Pods:</b><br>"
	var/obj/machinery/computer/cloning/C = holder
	for(var/atom/cloning_pod in C.pods)
		. += "[cloning_pod.name]<br>"

/datum/extension/interactive/multitool/cryo/receive_buffer(var/obj/item/device/multitool/M, var/atom/buffer, var/mob/user)
	var/obj/machinery/clonepod/P = buffer
	var/obj/machinery/computer/cloning/C = holder

	if(!istype(P))
		to_chat(user, "<span class='warning'>No valid connection data in \the [M] buffer.</span>")
		return MT_NOACTION

	var/is_connected = (P in C.pods)
	if(!is_connected)
		if(C.connect_pod(P))
			to_chat(user, "<span class='notice'>You connect \the [P] to \the [C].</span>")
		else
			to_chat(user, "<span class='warning'>You failed to connect \the [P] to \the [C].</span>")
		return MT_REFRESH

	if(C.release_pod(P))
		to_chat(user, "<span class='notice'>You disconnect \the [P] from \the [C].</span>")
	else
		to_chat(user, "<span class='notice'>You failed to disconnect \the [P] from \the [C].</span>")
	return MT_REFRESH
