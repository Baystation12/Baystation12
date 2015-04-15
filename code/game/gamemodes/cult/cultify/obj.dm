/obj/proc/cultify()
	qdel(src)

/obj/effect/decal/cleanable/blood/cultify()
	return

/obj/effect/decal/remains/cultify()
	return

/obj/effect/overlay/cultify()
	return

/obj/item/device/flashlight/lamp/cultify()
	new /obj/structure/cult/pylon(loc)
	..()

/obj/item/stack/sheet/wood/cultify()
	return

/obj/item/weapon/book/cultify()
	new /obj/item/weapon/book/tome(loc)
	..()

/obj/item/weapon/claymore/cultify()
	new /obj/item/weapon/melee/cultblade(loc)
	..()

/obj/item/weapon/storage/backpack/cultify()
	new /obj/item/weapon/storage/backpack/cultpack(loc)
	..()

/obj/item/weapon/storage/backpack/cultpack/cultify()
	return

/obj/item/weapon/table_parts/cultify()
	new /obj/item/weapon/table_parts/wood(loc)
	..()

/obj/item/weapon/table_parts/wood/cultify()
	return

/obj/machinery/cultify()
	// We keep the number of cultified machines down by only converting those that are dense
	// The alternative is to keep a separate file of exceptions.
	if(density)
		var/list/random_structure = list(
			/obj/structure/cult/talisman,
			/obj/structure/cult/forge,
			/obj/structure/cult/tome
			)
		var/I = pick(random_structure)
		new I(loc)
	..()

/obj/machinery/atmospherics/cultify()
	if(src.invisibility != INVISIBILITY_MAXIMUM)
		src.invisibility = INVISIBILITY_MAXIMUM
		density = 0

/obj/machinery/cooking/cultify()
	new /obj/structure/cult/talisman(loc)
	qdel(src)

/obj/machinery/computer/cultify()
	new /obj/structure/cult/tome(loc)
	qdel(src)

/obj/machinery/door/cultify()
	new /obj/structure/mineral_door/wood(loc)
	icon_state = "null"
	density = 0
	c_animation = new /atom/movable/overlay(src.loc)
	c_animation.name = "cultification"
	c_animation.density = 0
	c_animation.anchored = 1
	c_animation.icon = 'icons/effects/effects.dmi'
	c_animation.layer = 5
	c_animation.master = src.loc
	c_animation.icon_state = "breakdoor"
	flick("cultification",c_animation)
	spawn(10)
		del(c_animation)
		qdel(src)

/obj/machinery/door/firedoor/cultify()
	qdel(src)

/obj/machinery/light/cultify()
	new /obj/structure/cult/pylon(loc)
	qdel(src)

/obj/machinery/mech_sensor/cultify()
	qdel(src)

/obj/machinery/power/apc/cultify()
	if(src.invisibility != INVISIBILITY_MAXIMUM)
		src.invisibility = INVISIBILITY_MAXIMUM

/obj/machinery/vending/cultify()
	new /obj/structure/cult/forge(loc)
	qdel(src)

/obj/structure/bed/chair/cultify()
	var/obj/structure/bed/chair/wood/wings/I = new(loc)
	I.dir = dir
	..()

/obj/structure/bed/chair/wood/cultify()
	return

/obj/structure/bookcase/cultify()
	return

/obj/structure/grille/cultify()
	new /obj/structure/grille/cult(get_turf(src))
	..()

/obj/structure/grille/cult/cultify()
	return

/obj/structure/mineral_door/cultify()
	new /obj/structure/mineral_door/wood(loc)
	..()

/obj/structure/mineral_door/wood/cultify()
	return

/obj/machinery/singularity/cultify()
	var/dist = max((current_size - 2), 1)
	explosion(get_turf(src), dist, dist * 2, dist * 4)
	qdel(src)

/obj/structure/shuttle/engine/heater/cultify()
	new /obj/structure/cult/pylon(loc)
	..()

/obj/structure/shuttle/engine/propulsion/cultify()
	var/turf/T = get_turf(src)
	if(T)
		T.ChangeTurf(/turf/simulated/wall/cult)
	..()

/obj/structure/stool/cultify()
	var/obj/structure/bed/chair/wood/wings/I = new(loc)
	I.dir = dir
	..()

/obj/structure/table/cultify()
	new /obj/structure/table/woodentable(loc)
	..()

/obj/structure/table/woodentable/cultify()
	return
