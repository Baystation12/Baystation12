/obj/item/mech_component/propulsion
	name = "legs"
	pixel_y = 12
	icon_state = "loader_legs"
	var/move_delay = 5
	var/turn_delay = 5
	var/obj/item/robot_parts/robot_component/actuator/motivator
	power_use = 50
	var/max_fall_damage = 30

/obj/item/mech_component/propulsion/Destroy()
	QDEL_NULL(motivator)
	. = ..()

/obj/item/mech_component/propulsion/show_missing_parts(var/mob/user)
	if(!motivator)
		to_chat(user, SPAN_WARNING("It is missing an actuator."))

/obj/item/mech_component/propulsion/ready_to_install()
	return motivator

/obj/item/mech_component/propulsion/update_components()
	motivator = locate() in src

/obj/item/mech_component/propulsion/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing,/obj/item/robot_parts/robot_component/actuator))
		if(motivator)
			to_chat(user, SPAN_WARNING("\The [src] already has an actuator installed."))
			return
		if(install_component(thing, user)) motivator = thing
	else
		return ..()

/obj/item/mech_component/propulsion/prebuild()
	motivator = new(src)

/obj/item/mech_component/propulsion/proc/can_move_on(var/turf/location, var/turf/target_loc)
	if(!location) //Unsure on how that'd even work
		return 0
	if(!istype(location))
		return 1 // Inside something, assume you can get out.
	if(!istype(target_loc))
		return 0 // What are you even doing.
	return 1

/obj/item/mech_component/propulsion/get_damage_string()
	if(!motivator || !motivator.is_functional())
		return SPAN_DANGER("disabled")
	return ..()

/obj/item/mech_component/propulsion/return_diagnostics(mob/user)
	..()
	if(motivator)
		to_chat(user, SPAN_NOTICE(" Actuator Integrity: <b>[round((((motivator.max_dam - motivator.total_dam) / motivator.max_dam)) * 100)]%</b>"))
	else
		to_chat(user, SPAN_WARNING(" Actuator Missing or Non-functional."))

//Expand here if the legs increase, reduce or otherwise affect fall damage for exosuit
/obj/item/mech_component/propulsion/proc/handle_vehicle_fall()
	if(max_fall_damage > 0)
		var/mob/living/exosuit/E = loc
		if(istype(E)) //route it through exosuit for proper handling
			E.apply_damage(rand(0, max_fall_damage), BRUTE, BP_R_LEG) //Any leg is good, will damage us correctly