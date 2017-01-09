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

/obj/item/stack/material/wood/cultify()
	return

/obj/item/weapon/book/cultify()
	new /obj/item/weapon/book/tome(loc)
	..()

/obj/item/weapon/material/sword/cultify()
	new /obj/item/weapon/melee/cultblade(loc)
	..()

/obj/item/weapon/storage/backpack/cultify()
	new /obj/item/weapon/storage/backpack/cultpack(loc)
	..()

/obj/item/weapon/storage/backpack/cultpack/cultify()
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
		set_density(0)

/obj/machinery/cooker/cultify()
	new /obj/structure/cult/talisman(loc)
	qdel(src)

/obj/machinery/computer/cultify()
	new /obj/structure/cult/tome(loc)
	qdel(src)

/obj/machinery/door/airlock/external/cultify()
	new /obj/machinery/door/unpowered/simple/wood(loc)
	..()

/obj/machinery/door/cultify()
	if(invisibility != INVISIBILITY_MAXIMUM)
		invisibility = INVISIBILITY_MAXIMUM
		set_density(0)
		anim(target = src, a_icon = 'icons/effects/effects.dmi', a_icon_state = "breakdoor", sleeptime = 10)
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

/obj/machinery/door/unpowered/simple/cultify()
	new /obj/machinery/door/unpowered/simple/wood(loc)
	..()

/obj/machinery/door/unpowered/simple/wood/cultify()
	return

/obj/singularity/cultify()
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

/obj/structure/table/cultify()
	// Make it a wood-reinforced wooden table.
	// There are cult materials available, but it'd make the table non-deconstructable with how holotables work.
	// Could possibly use a new material var for holographic-ness?
	var/material/wood = get_material_by_name("wood")
	if(material == wood && reinforced == wood)
		return

	material = wood
	reinforced = wood
	update_desc()
	update_connections(1)
	update_icon()
	update_material()
