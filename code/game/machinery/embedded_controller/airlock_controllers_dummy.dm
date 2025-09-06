// Provides remote access to a controller (since they must be unique).
/obj/machinery/dummy_airlock_controller
	name = "airlock control terminal"
	icon = 'icons/obj/doors/airlock_machines.dmi'
	icon_state = "airlock_control_off"
	layer = ABOVE_OBJ_LAYER

	var/datum/topic_state/remote/remote_state
	var/obj/machinery/embedded_controller/radio/airlock/master_controller

	var/init_px
	var/init_py
	var/matrix/init_tf

	var/const/LINK_DELAY = 50

/obj/machinery/dummy_airlock_controller/Initialize()
	init_px = pixel_x
	init_py = pixel_y
	init_tf = transform
	. = ..()

	if (id_tag)
		spawn(LINK_DELAY)
			link_to_master()

/obj/machinery/dummy_airlock_controller/LateInitialize()
	. = ..()
	if (!master_controller && id_tag)
		link_to_master()

/obj/machinery/dummy_airlock_controller/proc/link_to_master()
	if (master_controller || !id_tag)
		return

	for (var/obj/machinery/embedded_controller/radio/airlock/M in SSmachines.machinery)
		if (M.id_tag == id_tag)
			master_controller = M
			break

	if (!master_controller)
		for (var/obj/machinery/embedded_controller/radio/airlock/M in world)
			if (M.id_tag == id_tag)
				master_controller = M
				break

	if (master_controller)
		master_controller.dummy_terminals += src
		if (!remote_state)
			remote_state = new /datum/topic_state/remote(src, master_controller)
		update_visual()
		return

/obj/machinery/dummy_airlock_controller/proc/update_visual()
	if (!master_controller) return

	var/px = init_px
	var/py = init_py
	var/matrix/tf = init_tf

	appearance = master_controller

	pixel_x = px
	pixel_y = py
	transform = tf

/obj/machinery/dummy_airlock_controller/Process()
	if (master_controller)
		update_visual()
	. = ..()

/obj/machinery/dummy_airlock_controller/interface_interact(mob/user)
	open_remote_ui(user)
	return TRUE

/obj/machinery/dummy_airlock_controller/proc/open_remote_ui(mob/user)
	if (master_controller)
		update_visual()
		return master_controller.ui_interact(user, state = remote_state)

/obj/machinery/dummy_airlock_controller/powered(chan = -1, area/check_area = null)
	if (master_controller)
		var/area/A = get_area(master_controller)
		return master_controller.powered(chan, A)
	return ..()

/obj/machinery/dummy_airlock_controller/Destroy()
	if (master_controller)
		master_controller.dummy_terminals -= src
	if (remote_state)
		qdel(remote_state)
		remote_state = null
	return ..()
