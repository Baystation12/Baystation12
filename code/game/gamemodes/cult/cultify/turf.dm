/turf/proc/cultify()
	ChangeTurf(/turf/space)
	return

/turf/simulated/floor/cultify()
	//todo: flooring datum cultify check
	cultify_floor()

/turf/simulated/shuttle/wall/cultify()
	cultify_wall()

/turf/simulated/wall/cultify()
	cultify_wall()

/turf/simulated/wall/cult/cultify()
	return

/turf/unsimulated/wall/cult/cultify()
	return

/turf/unsimulated/beach/cultify()
	return

/turf/unsimulated/wall/cultify()
	cultify_wall()

/turf/simulated/floor/proc/cultify_floor()
	new /obj/structure/cult_floor(src)

/obj/structure/cult_floor
	name = "engraved floor"
	desc = "Unsettling whispers waver from the surface..."
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult"
	plane = ABOVE_TURF_PLANE
	layer = CULT_FLOOR_LAYER

	anchored = 1

/obj/structure/cult_floor/New()
	..()
	cult.add_cultiness(CULTINESS_PER_TURF)

/obj/structure/cult_floor/Destroy()
	cult.remove_cultiness(CULTINESS_PER_TURF)
	return ..()

/obj/structure/cult_floor/attackby(var/obj/item/I, var/mob/living/user)
	if(istype(I, /obj/item/weapon/nullrod))
		user.visible_message("<span class='notice'>[user] hits \the [src] with \the [I], and it fades.</span>", "<span class='notice'>You disrupt the vile magic with the deadening field of \the [I].</span>")
		animate(src, alpha = 0, time = 10)
		spawn(10)
			qdel(src)
		return
	if(istype(I, /obj/item/weapon/wrench))
		to_chat(user, "You try to unwrench \the [src], but you realize that you have no idea how to do it. You should try something else.") // Wrench was used previously, let's leave a hint for those who don't read changelogs
		return
	if(isflamesource(I))
		user.visible_message("<span class='notice'>[user] puts \the [I] to \the [src], and it starts to fade.</span>", "<span class='notice'>You put \the [I] to \the [src], and it starts to fade.</span>")
		animate(src, alpha = 0, time = 20)
		if(!do_after(user, 20, src))
			animate(src, alpha = 255, time = 1)
			return
		to_chat(user, "<span class='notice'>The writing fades completely.</span>")
		qdel(src)
		return

/turf/proc/cultify_wall()
	var/turf/simulated/wall/wall = src
	if(!istype(wall))
		return
	if(wall.reinf_material)
		ChangeTurf(/turf/simulated/wall/cult/reinf)
	else
		ChangeTurf(/turf/simulated/wall/cult)
	cult.add_cultiness(CULTINESS_PER_TURF)
