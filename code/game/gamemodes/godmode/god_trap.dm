/obj/structure/deity/trap
	density = 0
	health = 1
	var/triggered = 0

/obj/structure/deity/trap/New()
	..()
	entered_event.register(get_turf(src),src,/obj/structure/deity/trap/proc/trigger)

/obj/structure/deity/trap/Destroy()
	entered_event.unregister(get_turf(src),src)
	return ..()

/obj/structure/deity/trap/Move()
	entered_event.unregister(get_turf(src),src)
	. = ..()
	entered_event.register(get_turf(src), src, /obj/structure/deity/trap/proc/trigger)

/obj/structure/deity/trap/attackby(obj/item/W as obj, mob/user as mob)
	trigger(user)
	return ..()

/obj/structure/deity/trap/bullet_act()
	return

/obj/structure/deity/trap/proc/trigger(var/atom/entered, var/atom/movable/enterer)
	if(triggered > world.time || !istype(enterer, /mob/living))
		return

	triggered = world.time + 30 SECONDS