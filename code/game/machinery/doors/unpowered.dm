/obj/machinery/door/unpowered
	var/locked = 0
	autoset_access = FALSE
	health_resistances = DAMAGE_RESIST_PHYSICAL

/obj/machinery/door/unpowered/Bumped(atom/AM)
	if(src.locked)
		return
	..()
	return

/obj/machinery/door/unpowered/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(locked)
		return TRUE
	return ..()

/obj/machinery/door/unpowered/emag_act()
	return -1

/obj/machinery/door/unpowered/shuttle
	icon = 'icons/turf/shuttle.dmi'
	name = "door"
	icon_state = "door1"
	opacity = 1
	density = TRUE
