// Provides remote access to a controller (since they must be unique).
/obj/machinery/dummy_airlock_controller
	name = "airlock control terminal"
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_standby"
	layer = ABOVE_OBJ_LAYER

	var/datum/topic_state/remote/remote_state
	var/obj/machinery/embedded_controller/radio/airlock/master_controller
	var/id_tag

/obj/machinery/dummy_airlock_controller/process()
	if(master_controller)
		appearance = master_controller
	. = ..()

/obj/machinery/dummy_airlock_controller/Initialize()
	. = ..()
	if(id_tag)
		for(var/obj/machinery/embedded_controller/radio/airlock/_master in GLOB.machines)
			if(_master.id_tag == id_tag)
				master_controller = _master
				master_controller.dummy_terminals += src
				break
	if(!master_controller)
		qdel(src)
	else
		remote_state = new /datum/topic_state/remote(src, master_controller)

/obj/machinery/dummy_airlock_controller/Destroy()
	if(master_controller)
		master_controller.dummy_terminals -= src
	if(remote_state)
		qdel(remote_state)
		remote_state = null
	return ..()

/obj/machinery/dummy_airlock_controller/attack_ai(var/mob/user)
	open_remote_ui(user)

/obj/machinery/dummy_airlock_controller/attack_hand(var/mob/user)
	open_remote_ui(user)

/obj/machinery/dummy_airlock_controller/proc/open_remote_ui(var/mob/user)
	if(master_controller)
		appearance = master_controller
		return master_controller.ui_interact(user, state = remote_state)

/obj/machinery/dummy_airlock_controller/powered(var/chan = -1, var/area/check_area = null)
	if(master_controller)
		var/area/A = get_area(master_controller)
		return master_controller.powered(chan, A)
	return ..()