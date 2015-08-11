///////////////////////////////////////
//Contents: Ladders, Hatches, Stairs.//
///////////////////////////////////////

/obj/multiz
	icon = 'icons/obj/structures.dmi'
	density = 0
	opacity = 0
	anchored = 1

	CanPass(obj/mover, turf/source, height, airflow)
		return airflow || !density

/obj/multiz/ladder
	icon_state = "ladderdown"
	name = "ladder"
	desc = "A ladder.  You climb up and down it."

	var/d_state = 1
	var/obj/multiz/target

	New()
		. = ..()

	proc/connect()
		if(icon_state == "ladderdown") // the upper will connect to the lower
			d_state = 1
			var/turf/controllerlocation = locate(1, 1, z)
			for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
				if(controller.down)
					var/turf/below = locate(src.x, src.y, controller.down_target)
					for(var/obj/multiz/ladder/L in below)
						if(L.icon_state == "ladderup")
							target = L
							L.target = src
							d_state = 0
							break
		return

/*	ex_act(severity)
		switch(severity)
			if(1.0)
				if(icon_state == "ladderup" && prob(10))
					qdel(src)
			if(2.0)
				if(prob(50))
					qdel(src)
			if(3.0)
				qdel(src)
		return*/

	Destroy()
		spawn(1)
			if(target && icon_state == "ladderdown")
				qdel(target)
		return ..()

	attackby(obj/item/C as obj, mob/user as mob)
		(..)

// construction commented out for balance concerns
/*		if (!target && istype(C, /obj/item/stack/rods))
			var/turf/controllerlocation = locate(1, 1, z)
			var/found = 0
			var/obj/item/stack/rods/S = C
			if(S.amount < 2)
				user << "You dont have enough rods to finish the ladder."
				return
			for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
				if(controller.down)
					found = 1
					var/turf/below = locate(src.x, src.y, controller.down_target)
					var/blocked = 0
					for(var/atom/A in below.contents)
						if(A.density)
							blocked = 1
							break
					if(!blocked && !istype(below, /turf/simulated/wall))
						var/obj/multiz/ladder/X = new /obj/multiz/ladder(below)
						S.amount = S.amount - 2
						if(S.amount == 0) qdel(S)
						X.icon_state = "ladderup"
						connect()
						user << "You finish the ladder."
					else
						user << "The area below is blocked."
			if(!found)
				user << "You cant build a ladder down there."
			return

		else if  (icon_state == "ladderdown" && d_state == 0 && istype(C, /obj/item/weapon/wrench))
			user << "<span class='notice'>You start loosening the anchoring bolts which secure the ladder to the frame.</span>"
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)

			sleep(30)
			if(!user || !C)	return

			src.d_state = 1
			if(target)
				var/obj/item/stack/rods/R = PoolOrNew(/obj/item/stack/rods, target.loc)
				R.amount = 2
				qdel(Target)

				user << "<span class='notice'>You remove the bolts anchoring the ladder.</span>"
			return

		else if  (icon_state == "ladderdown" && d_state == 1 && istype(C, /obj/item/weapon/weldingtool) )
			var/obj/item/weapon/weldingtool/WT = C
			if( WT.remove_fuel(0,user) )

				user << "<span class='notice'>You begin to remove the ladder.</span>"
				playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)

				sleep(60)
				if(!user || !WT || !WT.isOn())	return

				var/obj/item/stack/material/steel/S = new /obj/item/stack/material/steel( src )
				S.amount = 2
				user << "<span class='notice'>You remove the ladder and close the hole.</span>"
				qdel(src)
			else
				user << "<span class='notice'>You need more welding fuel to complete this task.</span>"
			return

		else
			src.attack_hand(user)
			return*/
		src.attack_hand(user)
		return

	attack_hand(var/mob/M)
		if(!target || !istype(target.loc, /turf))
			M << "The ladder is incomplete and can't be climbed."
		else
			var/turf/T = target.loc
			var/blocked = 0
			for(var/atom/A in T.contents)
				if(A.density)
					blocked = 1
					break
			if(blocked || istype(T, /turf/simulated/wall))
				M << "Something is blocking the ladder."
			else
				M.visible_message("\blue \The [M] climbs [src.icon_state == "ladderup" ? "up" : "down"] \the [src]!", "You climb [src.icon_state == "ladderup"  ? "up" : "down"] \the [src]!", "You hear some grunting, and clanging of a metal ladder being used.")
				M.Move(target.loc)

/*	hatch
		icon_state = "hatchdown"
		name = "hatch"
		desc = "A hatch. You climb down it, and it will automatically seal against pressure loss behind you."
		top_icon_state = "hatchdown"
		var/top_icon_state_open = "hatchdown-open"
		var/top_icon_state_close = "hatchdown-close"

		bottom_icon_state = "ladderup"

		var/image/green_overlay
		var/image/red_overlay

		var/active = 0

		New()
			. = ..()
			red_overlay = image(icon, "red-ladderlight")
			green_overlay = image(icon, "green-ladderlight")

		attack_hand(var/mob/M)

			if(!target || !istype(target.loc, /turf))
				qdel(src)

			if(active)
				M << "That [src] is being used."
				return // It is a tiny airlock, only one at a time.

			active = 1
			var/obj/multiz/ladder/hatch/top_hatch = target
			var/obj/multiz/ladder/hatch/bottom_hatch = src
			if(icon_state == top_icon_state)
				top_hatch = src
				bottom_hatch = target

			flick(top_icon_state_open, top_hatch)
			bottom_hatch.overlays += green_overlay

			spawn(7)
				if(!target || !istype(target.loc, /turf))
					qdel(src)
				if(M.z == z && get_dist(src,M) <= 1)
					var/list/adjacent_to_me = global_adjacent_z_levels["[z]"]
					M.visible_message("\blue \The [M] scurries [target.z == adjacent_to_me["up"] ? "up" : "down"] \the [src]!", "You scramble [target.z == adjacent_to_me["up"] ? "up" : "down"] \the [src]!", "You hear some grunting, and a hatch sealing.")
					M.Move(target.loc)
				flick(top_icon_state_close,top_hatch)
				bottom_hatch.overlays -= green_overlay
				bottom_hatch.overlays += red_overlay

				spawn(7)
					top_hatch.icon_state = top_icon_state
					bottom_hatch.overlays -= red_overlay
					active = 0*/

/obj/multiz/stairs
	name = "Stairs"
	desc = "Stairs.  You walk up and down them."
	icon_state = "rampbottom"
	var/obj/multiz/stairs/connected
	var/turf/target
	var/turf/target2
	var/suggest_dir // try this dir first when finding stairs; this is the direction to walk *down* the stairs

	New()
		..()
		var/turf/cl= locate(1, 1, src.z)
		for(var/obj/effect/landmark/zcontroller/c in cl)
			if(c.up)
				var/turf/O = locate(src.x, src.y, c.up_target)
				if(istype(O, /turf/space))
					O.ChangeTurf(/turf/simulated/floor/open)

		spawn(1)
			var/turf/T
			if(suggest_dir)
				T = get_step(src.loc,suggest_dir)
				find_stair_connection(T, suggest_dir, 1)
			if(!target)
				for(var/dir in cardinal)
					T = get_step(src.loc,dir)
					find_stair_connection(T, dir)
					if(target)
						break

	Bumped(var/atom/movable/M)
		if(connected && target && istype(src, /obj/multiz/stairs) && locate(/obj/multiz/stairs) in M.loc)
			var/obj/multiz/stairs/Con = locate(/obj/multiz/stairs) in M.loc
			if(Con == src.connected) //make sure the atom enters from the approriate lower stairs tile
				M.Move(target)
		return

	proc/find_stair_connection(var/turf/T, var/dir, var/suggested=0)
		for(var/obj/multiz/stairs/S in T)
			if(S && S.icon_state == "rampbottom" && !S.connected)
				if(!S.suggest_dir || S.suggest_dir == dir) // it doesn't have a suggested direction, or it's the same direction as we're trying, so we connect to it
					initialise_stair_connection(src, S, dir)
				else if(!suggested) // we're trying directions, so it could be a reverse stair (i.e. we're the bottom stair rather than the top)
					var/inv_dir = 0
					switch(dir)
						if(1)
							inv_dir = 2
						if(2)
							inv_dir = 1
						if(4)
							inv_dir = 8
						if(8)
							inv_dir = 4
					if(S.suggest_dir == inv_dir)
						initialise_stair_connection(S, src, inv_dir)

	proc/initialise_stair_connection(var/obj/multiz/stairs/top, var/obj/multiz/stairs/bottom, var/dir)
		top.set_dir(dir)
		bottom.set_dir(dir)
		top.connected = bottom
		bottom.connected = top
		top.icon_state = "ramptop"
		top.density = 1
		var/turf/controllerlocation = locate(1, 1, top.z)
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			if(controller.up)
				var/turf/above = locate(top.x, top.y, controller.up_target)
				if(istype(above,/turf/space) || istype(above,/turf/simulated/floor/open))
					top.target = above
				var/turf/above2 = locate(bottom.x, bottom.y, controller.up_target)
				if(istype(above2, /turf/space) || istype(above,/turf/simulated/floor/open))
					top.target2 = above2
		return