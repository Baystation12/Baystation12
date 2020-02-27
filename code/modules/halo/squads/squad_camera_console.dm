
/obj/item/squad_camera_control
	name = "Camera Controller"
	desc = "Interface for control of squad cameras."
	icon = 'code/modules/halo/squads/waypoint_manager.dmi'
	icon_state = "waypoint_manager"

	var/obj/machinery/squad_camera_console/spawner

/obj/item/squad_camera_control/New(var/spawner_console)
	. = ..()
	spawner = spawner_console

/obj/item/squad_camera_control/verb/switch_to_camera()
	set name = "Switch To Camera"
	set desc = "Switches to a specific camera"
	set category = "Object"

	set src in view(1)

	var/mob/living/u = usr
	if(!istype(u))
		return

	if(get_dist(spawner.loc,loc) > 1)
		qdel(src)
		return

	spawner.switch_to_camera(u)

/obj/item/squad_camera_control/attack_hand(var/mob/living/attacker)
	if(get_dist(spawner.loc,loc) > 1)
		qdel(src)
		return
	if(!istype(attacker))
		return
	if(attacker.machine != src)
		to_chat(attacker,"<span class = 'notice'>You need to be using [src] first.</span>")
		return
	spawner.switch_next_camera(attacker)

/obj/item/squad_camera_control/dropped(var/dropby)
	. = ..()
	if(!istype(loc,/mob/living))
		qdel(src)

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
	selected_device = null
	if(linked.linked_devices.len > 0)
		selected_device = get_next_camera()

/obj/machinery/squad_camera_console/proc/set_view_to(var/obj/selected_device,var/mob/u)
	var/obj/view_reset_to = selected_device
	if(!istype(selected_device.loc,/mob))
		view_reset_to = selected_device.loc
	u.reset_view(view_reset_to)

/obj/machinery/squad_camera_console/proc/switch_to_camera(var/mob/living/u)
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
	set_view_to(selected_device,u)

/obj/machinery/squad_camera_console/proc/switch_next_camera(var/mob/living/u)
	selected_device = get_next_camera()
	set_view_to(selected_device,u)

/obj/machinery/squad_camera_console/proc/place_holder_obj(var/mob/living/carbon/human/h)
	if(!istype(h))
		return
	if(locate(/obj/item/squad_camera_control) in h.contents)
		to_chat(h,"<span class = 'notice'>You're already controlling [src]</span>")
		return
	var/obj/new_obj = new /obj/item/squad_camera_control (src)
	h.put_in_hands(new_obj)

/obj/machinery/squad_camera_console/proc/remove_holder_obj(var/mob/living/carbon/human/h)
	if(!istype(h))
		return
	for(var/obj/item in h.contents)
		if(istype(item,/obj/item/squad_camera_control))
			h.drop_from_inventory(item)
			item.forceMove(loc)
			qdel(item)

/obj/machinery/squad_camera_console/attack_hand(var/mob/living/attacker)
	if(!istype(attacker))
		return
	if(isnull(linked) || linked.linked_devices.len == 0)
		to_chat(attacker,"<span class = 'notice'>The linked squad has no members. No cameras available to view.</span>")
		return
	if(!selected_device)
		selected_device = get_next_camera()
	attacker.machine = src
	set_view_to(selected_device,attacker)
	place_holder_obj(attacker)

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
	if(istype(user,/mob/living/silicon/ai))
		return 0
	if(get_dist(user,src) > 1)
		user.machine = null
		user.reset_view(null)
		remove_holder_obj(user)
		return -1
	return 0

/obj/machinery/squad_camera_console/covenant
	icon_state = "camera_console_cov"

	squad_manager_spawn = /obj/item/squad_manager/covenant