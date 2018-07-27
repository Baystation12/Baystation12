/obj/item/mech_component/propulsion
	name = "legs"
	pixel_y = 12
	icon_state = "loader_legs"
	var/move_delay = 5
	var/obj/item/robot_parts/robot_component/actuator/motivator

/obj/item/mech_component/propulsion/Destroy()
	if(motivator)
		qdel(motivator)
		motivator = null
	. = ..()

/obj/item/mech_component/propulsion/show_missing_parts(var/mob/user)
	if(!motivator)
		to_chat(user, "<span class='warning'>It is missing an actuator.</span>")

/obj/item/mech_component/propulsion/ready_to_install()
	return motivator

/obj/item/mech_component/propulsion/update_components()
	motivator = locate() in src

/obj/item/mech_component/propulsion/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing,/obj/item/robot_parts/robot_component/actuator))
		if(motivator)
			to_chat(user, "<span class='warning'>\The [src] already has an actuator installed.</span>")
			return
		if(install_component(thing, user)) motivator = thing
	else
		return ..()

/obj/item/mech_component/propulsion/prebuild()
	motivator = new(src)

/obj/item/mech_component/propulsion/proc/can_move_on(var/turf/location, var/turf/target_loc)
	if(!istype(location))
		return 1 // Inside something, assume you can get out.
	if(!istype(target_loc))
		return 0 // What are you even doing.
	return 1