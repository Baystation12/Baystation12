// Provides remote access to a controller (since they must be unique).
/obj/machinery/dummy_airlock_controller
	name = "airlock control terminal"
	icon = 'icons/obj/doors/airlock_machines.dmi'
	icon_state = "airlock_control_off"
	layer = ABOVE_OBJ_LAYER

	var/datum/topic_state/remote/remote_state
	var/obj/machinery/embedded_controller/radio/airlock/master_controller

	var/init_px = 0
	var/init_py = 0
	var/matrix/init_tf = null

	proc/update_visual()
		if(!master_controller)
			return
		appearance = master_controller
		pixel_x = init_px
		pixel_y = init_py
		if(init_tf)
			transform = init_tf

/obj/machinery/dummy_airlock_controller/Initialize()
	. = ..()
	init_px = pixel_x
	init_py = pixel_y
	init_tf = transform

	if(id_tag)
		for(var/obj/machinery/embedded_controller/radio/airlock/_m in SSmachines.get_machinery_of_type(/obj/machinery/embedded_controller/radio/airlock))
			if(_m.id_tag == id_tag)
				master_controller = _m
				master_controller.dummy_terminals += src
				break

	if(master_controller && !remote_state)
		remote_state = new /datum/topic_state/remote(src, master_controller)
	update_visual()

/obj/machinery/dummy_airlock_controller/Process()
	. = ..()
	if(!master_controller && id_tag)
		for(var/obj/machinery/embedded_controller/radio/airlock/_m in SSmachines.get_machinery_of_type(/obj/machinery/embedded_controller/radio/airlock))
			if(_m.id_tag == id_tag)
				master_controller = _m
				master_controller.dummy_terminals += src
				if(!remote_state)
					remote_state = new /datum/topic_state/remote(src, master_controller)
				update_visual()
				break
	else if(master_controller)
		update_visual()

/obj/machinery/dummy_airlock_controller/Destroy()
	if(master_controller)
		master_controller.dummy_terminals -= src
	if(remote_state)
		qdel(remote_state)
		remote_state = null
	return ..()

/obj/machinery/dummy_airlock_controller/interface_interact(mob/user)
	open_remote_ui(user)
	return TRUE

/obj/machinery/dummy_airlock_controller/proc/open_remote_ui(mob/user)
	if(master_controller)
		if(!remote_state)
			remote_state = new /datum/topic_state/remote(src, master_controller)
		update_visual()
		return master_controller.ui_interact(user, state = remote_state)
	return