
/turf/unsimulated/floor/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"

/turf/unsimulated/floor/scorched
	name = "scorched rock"
	icon = 'icons/turf/jungle.dmi'
	icon_state = "scorched"

/turf/unsimulated/floor/thicksand
	name = "dense sand"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

/turf/unsimulated/floor/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"

/turf/unsimulated/floor/lava/Entered(atom/movable/Obj,atom/OldLoc)
	var/loseme = 0
	if(isliving(Obj))
		loseme = 1
		var/mob/living/M = Obj

		M.adjustFireLoss(10000)

	else if(isitem(Obj))
		loseme = 1

	if(loseme)
		for(var/obj/effect/decal/cleanable/ash/A in src)
			qdel(A)
		spawn(rand(25,75))
			if(Obj && Obj.loc == src)
				src.visible_message("\icon[Obj]<span class='danger'>[Obj] sinks under the surface of [src]!</span>")
				qdel(Obj)
