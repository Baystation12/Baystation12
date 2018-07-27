/obj/item/mech_component/sensors
	name = "head"
	pixel_y = -18
	icon_state = "loader_head"
	gender = NEUTER

	var/sight_flags = 0
	var/obj/item/robot_parts/robot_component/radio/radio
	var/obj/item/robot_parts/robot_component/camera
	var/obj/item/mech_component/control_module/software
	has_hardpoints = list(HARDPOINT_HEAD)

/obj/item/mech_component/sensors/Destroy()
	if(camera)
		qdel(camera)
		camera = null
	if(radio)
		qdel(radio)
		radio = null
	if(software)
		qdel(software)
		software = null
	. = ..()

/obj/item/mech_component/sensors/show_missing_parts(var/mob/user)
	if(!radio)
		to_chat(user, "<span class='warning'>It is missing a radio.</span>")
	if(!camera)
		to_chat(user, "<span class='warning'>It is missing a camera.</span>")
	if(!software)
		to_chat(user, "<span class='warning'>It is missing a software control module.</span>")

/obj/item/mech_component/sensors/prebuild()
	radio = new(src)
	camera = new(src)

/obj/item/mech_component/sensors/update_components()
	radio = locate() in src
	camera = locate() in src
	software = locate() in src

/obj/item/mech_component/sensors/ready_to_install()
	return (radio && camera)

/obj/item/mech_component/sensors/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/mech_component/control_module))
		if(software)
			to_chat(user, "<span class='warning'>\The [src] already has a control modules installed.</span>")
			return
		if(install_component(thing, user)) software = thing
	else if(istype(thing,/obj/item/robot_parts/robot_component/radio))
		if(radio)
			to_chat(user, "<span class='warning'>\The [src] already has a radio installed.</span>")
			return
		if(install_component(thing, user)) radio = thing
	else if(istype(thing,/obj/item/robot_parts/robot_component/camera))
		if(camera)
			to_chat(user, "<span class='warning'>\The [src] already has a camera installed.</span>")
			return
		if(install_component(thing, user)) camera = thing
	else
		return ..()

/obj/item/mech_component/control_module
	name = "exosuit control module"
	var/list/installed_software = list()
	var/max_installed_software = 2
	icon_state = "internals"
	icon = 'icons/mecha/mech_part_items.dmi'
	pixel_x = 0

/obj/item/mech_component/control_module/attackby(var/obj/item/thing, var/mob/user)

	if(istype(thing, /obj/item/circuitboard/exosystem))
		install_software(thing, user)
		return

	if(isScrewdriver(thing))
		var/result = ..()
		update_software()
		return result
	else
		return ..()

/obj/item/mech_component/control_module/proc/install_software(var/obj/item/circuitboard/exosystem/software, var/mob/user)
	if(installed_software.len >= max_installed_software)
		if(user)
			to_chat(user, "<span class='warning'>\The [src] can only hold [max_installed_software] software modules.</span>")
		return
	if(user)
		to_chat(user, "<span class='notice'>You load \the [software] into \the [src]'s memory.</span>")
		user.unEquip(software)
	software.forceMove(src)
	update_software()

/obj/item/mech_component/control_module/proc/update_software()
	installed_software = list()
	for(var/obj/item/circuitboard/exosystem/program in contents)
		installed_software |= program.contains_software
