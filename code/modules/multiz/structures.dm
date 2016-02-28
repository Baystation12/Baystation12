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

	var/obj/structure/ladder/target_up
	var/obj/structure/ladder/target_down

	initialize()
		// the upper will connect to the lower
		if(icon_state == "ladderup")
			return

		for(var/obj/structure/ladder/L in GetBelow(src))
			if(L.icon_state != "ladderdown")
				target_down = L
				L.target_up = src
				return

	Destroy()
		if(target_down && icon_state == "ladderdown")
			target_down.target_up = null
			qdel(target_down)
		return ..()

	attackby(obj/item/C as obj, mob/user as mob)
		. = ..()
		attack_hand(user)
		return

	attack_hand(var/mob/M)
		if((!target_up && !target_down) || (target_up && !istype(target_up.loc, /turf) || (target_down && !istype(target_down.loc,/turf))))
			M << "<span class='notice'>\The [src] is incomplete and can't be climbed.</span>"
			return
		var/obj/structure/ladder/target = target_up
		if(target_down)
			if(target_up)
				var/choice = alert(M,"Do you want to go up or down?", "Ladder", "Up", "Down", "Cancel")
				switch(choice)
					if("Up")
						target = target_up
					if("Down")
						target = target_down
					else
						return
			else
				target = target_down

		var/turf/T = target.loc
		for(var/atom/A in T)
			if(A.density)
				M << "<span class='notice'>\A [A] is blocking \the [src].</span>"
				return
		if(!istype(M,/mob/dead))
			M.visible_message("<span class='notice'>\A [M] climbs [target == target_up ? "up" : "down"] \a [src]!</span>",
			"You climb [target == target_down  ? "up" : "down"] \the [src]!",
			"You hear the grunting and clanging of a metal ladder being used.")
		M.Move(T)

	CanPass(obj/mover, turf/source, height, airflow)
		return airflow || !density

	attack_ghost(var/mob/M)
		attack_hand(M)
/obj/structure/stairs
	name = "Stairs"
	desc = "Stairs leading to another deck.  Not too useful if the gravity goes out."
	icon = 'icons/obj/stairs.dmi'
	density = 0
	opacity = 0
	anchored = 1

	initialize()
		for(var/turf/turf in locs)
			var/turf/simulated/open/above = GetAbove(turf)
			if(!above)
				warning("Stair created without level above: ([loc.x], [loc.y], [loc.z])")
				return qdel(src)
			if(!istype(above))
				above.ChangeTurf(/turf/simulated/open)

	Uncross(atom/movable/A)
		if(A.dir == dir)
			// This is hackish but whatever.
			var/turf/target = get_step(GetAbove(A), dir)
			var/turf/source = A.loc
			if(target.Enter(A, source))
				A.loc = target
				target.Entered(A, source)
			return 0
		return 1

	CanPass(obj/mover, turf/source, height, airflow)
		return airflow || !density

	// type paths to make mapping easier.
	north
		dir = NORTH
		bound_height = 64
		bound_y = -32
		pixel_y = -32

	south
		dir = SOUTH
		bound_height = 64

	east
		dir = EAST
		bound_width = 64
		bound_x = -32
		pixel_x = -32

	west
		dir = WEST
		bound_width = 64