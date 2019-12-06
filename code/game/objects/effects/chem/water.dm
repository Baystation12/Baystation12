/obj/effect/effect/water
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	mouse_opacity = 0
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GRILLE

/obj/effect/effect/water/New(loc)
	..()
	QDEL_IN(src, 15 SECONDS) // In case whatever made it forgets to delete it

/obj/effect/effect/water/proc/set_color() // Call it after you move reagents to it
	icon += reagents.get_color()

/obj/effect/effect/water/proc/set_up(var/turf/target, var/step_count = 5, var/delay = 5)
	if(!target)
		return
	for(var/i = 1 to step_count)
		if(!loc)
			return
		step_towards(src, target)
		var/turf/T = get_turf(src)
		if(T && reagents)
			var/list/splash_mobs = list()
			var/list/splash_others = list(T)
			for(var/atom/A in T)
				if(A.simulated)
					if(!ismob(A))
						splash_others += A
					else if(isliving(A))
						splash_mobs += A

			//each step splash 1/5 of the reagents on non-mobs
			//could determine the # of steps until target, but that would be complicated
			for(var/atom/A in splash_others)
				reagents.splash(A, (reagents.total_volume/step_count)/splash_others.len)
			for(var/mob/living/M in splash_mobs)
				reagents.splash(M, reagents.total_volume/splash_mobs.len)
			if(reagents.total_volume < 1)
				break
			if(T == get_turf(target))
				for(var/atom/A in splash_others)
					reagents.splash(A, reagents.total_volume/splash_others.len) //splash anything left
				break

		sleep(delay)
	sleep(10)
	qdel(src)

/obj/effect/effect/water/Move(turf/newloc)
	if(newloc.density)
		return 0
	. = ..()

/obj/effect/effect/water/Bump(atom/A)
	if(reagents)
		reagents.touch(A)
	return ..()

//Used by spraybottles.
/obj/effect/effect/water/chempuff
	name = "chemicals"
	icon = 'icons/obj/chempuff.dmi'
	icon_state = ""
