/obj/structure/deity/trap
	density = FALSE
	health_max = 25
	var/triggered = 0

/obj/structure/deity/trap/New()
	..()
	GLOB.entered_event.register(get_turf(src),src,/obj/structure/deity/trap/proc/trigger)

/obj/structure/deity/trap/Destroy()
	GLOB.entered_event.unregister(get_turf(src),src)
	return ..()

/obj/structure/deity/trap/Move()
	GLOB.entered_event.unregister(get_turf(src),src)
	. = ..()
	GLOB.entered_event.register(get_turf(src), src, /obj/structure/deity/trap/proc/trigger)

/obj/structure/deity/trap/attackby(obj/item/W, mob/user)
	trigger(user)
	return ..()

/obj/structure/deity/trap/bullet_act()
	return

/obj/structure/deity/trap/proc/trigger(atom/entered, atom/movable/enterer)
	if(triggered > world.time || !istype(enterer, /mob/living))
		return

	triggered = world.time + 30 SECONDS