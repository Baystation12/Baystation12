// Provides remote access to a controller (since they must be unique).
/obj/machinery/dummy_airlock_controller
	name = "airlock control terminal"
	icon = 'icons/obj/doors/airlock_machines.dmi'
	icon_state = "airlock_control_off"
	layer = ABOVE_OBJ_LAYER

	var/datum/topic_state/remote/remote_state
	var/obj/machinery/embedded_controller/radio/airlock/master_controller

	proc/mirror_master_preserve_position()
		if(!master_controller) return
		var/old_px = pixel_x
		var/old_py = pixel_y
		var/old_dir = dir
		var/matrix/old_tf = transform
		var/old_sx = step_x
		var/old_sy = step_y
		appearance = master_controller
		pixel_x   = old_px
		pixel_y   = old_py
		dir       = old_dir
		transform = old_tf
		step_x    = old_sx
		step_y    = old_sy

/obj/machinery/dummy_airlock_controller/Process()
	if(master_controller)
		mirror_master_preserve_position()
	. = ..()

/obj/machinery/dummy_airlock_controller/Initialize()
	. = ..()
	if(id_tag)
		if(SSmachines && istype(SSmachines.machinery, /list))
			for (var/obj/machinery/embedded_controller/radio/airlock/_master in SSmachines.machinery)
				if(_master.id_tag == id_tag)
					master_controller = _master
					master_controller.dummy_terminals += src
					break
		if(!master_controller)
			for (var/obj/machinery/embedded_controller/radio/airlock/_master in world)
				if(_master.id_tag == id_tag)
					master_controller = _master
					master_controller.dummy_terminals += src
					break

	if(!master_controller)
		qdel(src)
	else
		remote_state = new /datum/topic_state/remote(src, master_controller)
		mirror_master_preserve_position()

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
		mirror_master_preserve_position()
		return master_controller.ui_interact(user, state = remote_state)

/obj/machinery/dummy_airlock_controller/powered(chan = -1, area/check_area = null)
	if(master_controller)
		var/area/A = get_area(master_controller)
		return master_controller.powered(chan, A)
	return ..()