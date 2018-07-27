/obj/item/mech_component/manipulators
	name = "arms"
	pixel_y = -12
	icon_state = "loader_arms"
	has_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)

	var/melee_damage = 10
	var/action_delay = 15
	var/obj/item/robot_parts/robot_component/actuator/motivator

/obj/item/mech_component/manipulators/Destroy()
	if(motivator)
		qdel(motivator)
		motivator = null
	. = ..()

/obj/item/mech_component/manipulators/show_missing_parts(var/mob/user)
	if(!motivator)
		to_chat(user, "<span class='warning'>It is missing an actuator.</span>")

/obj/item/mech_component/manipulators/ready_to_install()
	return motivator

/obj/item/mech_component/manipulators/prebuild()
	motivator = new(src)

/obj/item/mech_component/manipulators/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing,/obj/item/robot_parts/robot_component/actuator))
		if(motivator)
			to_chat(user, "<span class='warning'>\The [src] already has an actuator installed.</span>")
			return
		if(install_component(thing, user)) motivator = thing
	else
		return ..()

/obj/item/mech_component/manipulators/update_components()
	motivator = locate() in src