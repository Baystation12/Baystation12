/obj/item/frame
	name = "frame"
	desc = "Used for building machines."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire_bitem"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	var/build_machine_type
	var/refund_amt = 2
	var/refund_type = /obj/item/stack/material/steel
	var/reverse = 0 //if resulting object faces opposite its dir (like light fixtures)

/obj/item/frame/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isWrench(W))
		new refund_type( get_turf(src.loc), refund_amt)
		qdel(src)
		return
	..()

/obj/item/frame/proc/try_build(turf/on_wall)
	if(!build_machine_type)
		return

	if (get_dist(on_wall,usr)>1)
		return

	var/ndir
	if(reverse)
		ndir = get_dir(usr,on_wall)
	else
		ndir = get_dir(on_wall,usr)

	if (!(ndir in GLOB.cardinal))
		return

	var/turf/loc = get_turf(usr)
	var/area/A = loc.loc
	if (!istype(loc, /turf/simulated/floor))
		to_chat(usr, "<span class='danger'>\The [src] cannot be placed on this spot.</span>")
		return
	if ((A.requires_power == 0 || A.name == "Space") && !isLightFrame())
		to_chat(usr, "<span class='danger'>\The [src] cannot be placed in this area.</span>")
		return

	if(gotwallitem(loc, ndir))
		to_chat(usr, "<span class='danger'>There's already an item on this wall!</span>")
		return

	new build_machine_type(loc, ndir, src)
	qdel(src)

/obj/item/frame/proc/isLightFrame()
	return FALSE

/obj/item/frame/fire_alarm
	name = "fire alarm frame"
	desc = "Used for building fire alarms."
	build_machine_type = /obj/machinery/firealarm

/obj/item/frame/air_alarm
	name = "air alarm frame"
	icon_state = "alarm_bitem"
	desc = "Used for building air alarms."
	build_machine_type = /obj/machinery/alarm

/obj/item/frame/light
	name = "light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-item"
	build_machine_type = /obj/machinery/light_construct
	reverse = 1

/obj/item/frame/light/isLightFrame()
	return TRUE

/obj/item/frame/light/small
	name = "small light fixture frame"
	icon_state = "bulb-construct-item"
	refund_amt = 1
	build_machine_type = /obj/machinery/light_construct/small

/obj/item/frame/light/small/red
	build_machine_type = /obj/machinery/light_construct/small/red

/obj/item/frame/light/small/emergency
	build_machine_type = /obj/machinery/light_construct/small/emergency

/obj/item/frame/light/spot
	name = "spotlight fixture frame"
	build_machine_type = /obj/machinery/light_construct/spot
	refund_amt = 4

/obj/item/frame/light/nav
	name = "navigation light fixture frame"
	build_machine_type = /obj/machinery/light_construct/nav
	refund_amt = 4

/obj/item/frame/newscaster
	name = "newscaster frame"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "newscaster_off"
	desc = "Used for building newscasters."
	build_machine_type = /obj/machinery/newscaster
	refund_type = /obj/item/stack/material/plastic

/obj/item/frame/newscaster/sec
	name = "security newscaster frame"
	build_machine_type = /obj/machinery/newscaster/security_unit

/obj/item/frame/status_display
	name = "status display frame"
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	desc = "Used for building status displays."
	build_machine_type = /obj/machinery/status_display
	refund_type = /obj/item/stack/material/plastic

/obj/item/frame/status_display/supply
	name = "supply status display frame"
	build_machine_type = /obj/machinery/status_display/supply_display

/obj/item/frame/status_display/ai
	name = "AI status display frame"
	build_machine_type = /obj/machinery/ai_status_display