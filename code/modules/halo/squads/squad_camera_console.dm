
/obj/machinery/squad_camera_console
	name = "Squad Camera Console"
	desc = "A console that allows a user to access tactical HUD cameras. Advanced signal propagation technology ensures near-infinite range communication."
	density = 1
	anchored = 1

	icon = 'code/modules/halo/squads/camera_console.dmi'
	icon_state = "camera_console"

	var/datum/waypoint_controller/linked
	var/squad_manager_spawn = /obj/item/squad_manager
	var/obj/selected_device
	var/active_viewmod = 1.7

/obj/machinery/squad_camera_console/examine(var/mob/examiner)
	. = ..()
	if(linked)
		to_chat(examiner,"<span class = 'notice'>It is linked to the squad named: \"[linked.squad_name]\"</span>")

/obj/machinery/squad_camera_console/Initialize()
	. = ..()
	var/obj/item/squad_manager/new_manager = new squad_manager_spawn (loc)
	linked = new_manager.linked_controller
	overlays += icon(icon,"[icon_state]_overlay",dir)

/obj/machinery/squad_camera_console/attackby(var/obj/item/squad_manager/I, var/mob/living/user)
	if(!istype(I))
		. = ..()
		return
	to_chat(user,"<span class = 'notice'>You link your [I] to [src].</span>")
	linked = I.linked_controller
	if(linked.linked_devices.len > 0)
		selected_device = get_next_camera()

/obj/machinery/squad_camera_console/verb/switch_next_camera()
	set name = "Switch To Next Camera"
	set desc = "Switches to the next camera"
	set category = "Object"

	set src in view(1)

	var/mob/living/u = usr
	if(!istype(u))
		return

	if(u.machine != src)
		to_chat(u,"<span class = 'notice'>You need to be using [src] first.</span>")
		return

	selected_device = get_next_camera()
	u.reset_view(selected_device)

/obj/machinery/squad_camera_console/verb/switch_to_camera()
	set name = "Switch To Camera"
	set desc = "Switches to a specific camera"
	set category = "Object"

	set src in view(1)

	var/mob/living/u = usr
	if(!istype(u))
		return

	if(u.machine != src)
		to_chat(u,"<span class = 'notice'>You need to be using [src] first.</span>")
		return

	var/list/locs_choosefrom = list()
	for(var/obj/device in linked.linked_devices)
		locs_choosefrom += device.loc

	var/chosen = input(u,"Switch to which camera?","Camera Switch","Cancel") in locs_choosefrom + list("Cancel")
	if(chosen == "Cancel")
		return
	selected_device = linked.linked_devices[locs_choosefrom.Find(chosen)]
	u.reset_view(selected_device)

/obj/machinery/squad_camera_console/attack_hand(var/mob/living/attacker)
	if(!istype(attacker))
		return
	if(isnull(linked) || linked.linked_devices.len == 0)
		to_chat(attacker,"<span class = 'notice'>The linked squad has no members. No cameras available to view.</span>")
		return
	if(!selected_device)
		selected_device = get_next_camera()
	attacker.machine = src
	attacker.client.view = initial(attacker.client.view) * active_viewmod
	attacker.reset_view(selected_device)

/obj/machinery/squad_camera_console/proc/get_next_camera()
	var/our_camera_index = linked.linked_devices.Find(selected_device)
	if(isnull(our_camera_index))
		our_camera_index = 1
	else if(our_camera_index + 1 > linked.linked_devices.len)
		our_camera_index = 1
	else
		our_camera_index += 1
	return linked.linked_devices[our_camera_index]

/obj/machinery/squad_camera_console/check_eye(var/mob/user)
	if(get_dist(user,src) > 1)
		user.machine = null
		user.client.view = initial(user.client.view)
		user.reset_view(null)
		return -1
	return 0

/obj/machinery/squad_camera_console/covenant
	icon_state = "camera_console_cov"
