/turf/unsimulated/wall/cult/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/nullrod))
		user.visible_message("<span class='notice'>\The [user] touches \the [src] with \the [I], and it shifts.</span>", "<span class='notice'>You touch \the [src] with \the [I], and it shifts.</span>")
		ChangeTurf(/turf/unsimulated/wall)
		return
	..()

/turf/simulated/wall/cult/attackby(obj/item/I, mob/user)
	if (istype(I, /obj/item/nullrod))
		user.visible_message(
			SPAN_NOTICE("\The [user] touches \the [src] with \the [I], and it shifts."),
			SPAN_NOTICE("You touch \the [src] with \the [I], and it shifts.")
		)
		decultify_wall()
		return
	..()

/turf/simulated/floor/cult/attackby(obj/item/I, mob/user)
	if (istype(I, /obj/item/nullrod))
		user.visible_message(
			SPAN_NOTICE("\The [user] touches \the [src] with \the [I], and it shifts."),
			SPAN_NOTICE("You touch \the [src] with \the [I], and it shifts.")
		)
		decultify_floor()
		return
	..()

/turf/proc/decultify_wall()
	var/turf/simulated/wall/cult/wall = src
	if (!istype(wall))
		return
	if (wall.reinf_material)
		ChangeTurf(/turf/simulated/wall/r_wall/prepainted)
	else
		ChangeTurf(/turf/simulated/wall/prepainted)

/turf/proc/decultify_floor()
	var/turf/simulated/floor/cult/floor = src
	if (!istype(floor))
		return
	else
		ChangeTurf(/turf/simulated/floor/plating)
