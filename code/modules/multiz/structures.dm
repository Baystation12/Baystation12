//////////////////////////////
//Contents: Ladders, Stairs.//
//////////////////////////////

/obj/structure/ladder
	name = "ladder"
	desc = "A ladder.  You can climb it up and down."
	icon_state = "ladderdown"
	icon = 'icons/obj/structures.dmi'
	density = 0
	opacity = 0
	anchored = 1

	var/obj/structure/ladder/target

	initialize()
		// the upper will connect to the lower
		if(icon_state == "ladderup")
			return

		for(var/obj/structure/ladder/L in GetBelow(src))
			if(L.icon_state == "ladderup")
				target = L
				L.target = src
				return

	Destroy()
		if(target && icon_state == "ladderdown")
			qdel(target)
		return ..()

	attackby(obj/item/C as obj, mob/user as mob)
		. = ..()
		attack_hand(user)
		return

	attack_hand(var/mob/M)
		if(!target || !istype(target.loc, /turf))
			M << "<span class='notice'>\The [src] is incomplete and can't be climbed.</span>"
			return

		var/turf/T = target.loc
		for(var/atom/A in T)
			if(A.density)
				M << "<span class='notice'>\A [A] is blocking \the [src].</span>"
				return

		M.visible_message("<span class='notice'>\A [M] climbs [icon_state == "ladderup" ? "up" : "down"] \a [src]!</span>",
			"You climb [icon_state == "ladderup"  ? "up" : "down"] \the [src]!",
			"You hear the grunting and clanging of a metal ladder being used.")
		M.Move(T)

	CanPass(obj/mover, turf/source, height, airflow)
		return airflow || !density

/obj/structure/stairs
	name = "Stairs"
	desc = "Stairs.  You walk up and down them."
	icon_state = "rampbottom"
	icon = 'icons/obj/structures.dmi'
	density = 0
	opacity = 0
	anchored = 1

	var/obj/structure/stairs/connected

	New()
		..()
		var/turf/above = GetAbove(src)
		if(istype(above, /turf/space))
			above.ChangeTurf(/turf/simulated/open)

	initialize()
		var/updown = icon_state == "rampbottom" ? UP : DOWN

		var/turf/T = get_step(src, dir | updown)
		connected = locate() in T
		ASSERT(connected)

	Uncross(var/atom/movable/M)
		if(connected && M.dir == dir)
			M.loc = connected.loc
		return 1

	CanPass(obj/mover, turf/source, height, airflow)
		return airflow || !density