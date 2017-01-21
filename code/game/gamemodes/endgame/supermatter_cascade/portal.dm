/*** EXIT PORTAL ***/

/obj/singularity/narsie/large/exit
	name = "Bluespace Rift"
	desc = "NO TIME TO EXPLAIN, JUMP IN!"
	icon = 'icons/obj/rift.dmi'
	icon_state = "rift"

	move_self = 0
	announce=0
	cause_hell=0

	layer=LIGHTING_LAYER+2 // ITS SO BRIGHT

	consume_range = 6

/obj/singularity/narsie/large/exit/New()
	..()
	processing_objects.Add(src)

/obj/singularity/narsie/large/exit/update_icon()
	overlays = 0

/obj/singularity/narsie/large/exit/process()
	for(var/mob/M in player_list)
		if(M.client)
			M.see_rift(src)
	eat()

/obj/singularity/narsie/large/exit/acquire(var/mob/food)
	return

/obj/singularity/narsie/large/exit/consume(const/atom/A)
	if(!(A.singuloCanEat()))
		return 0

	if (istype(A, /mob/living/))
		var/mob/living/L = A
		if(L.buckled && istype(L.buckled,/obj/structure/bed/))
			var/turf/O = L.buckled
			do_teleport(O, pick(endgame_safespawns))
			L.forceMove(O.loc)
		else
			do_teleport(L, pick(endgame_safespawns)) //dead-on precision

	else if (istype(A, /obj/mecha/))
		do_teleport(A, pick(endgame_safespawns)) //dead-on precision

	else if (isturf(A))
		var/turf/T = A
		var/dist = get_dist(T, src)
		if (dist <= consume_range && T.density)
			T.set_density(0)

		for (var/atom/movable/AM in T.contents)
			if (AM == src) // This is the snowflake.
				continue

			if (dist <= consume_range)
				consume(AM)
				continue

			if (dist > consume_range)
				if(!(AM.singuloCanEat()))
					continue

				if (101 == AM.invisibility)
					continue

				spawn (0)
					AM.singularity_pull(src, src.current_size)


/mob
	//thou shall always be able to see the rift
	var/image/riftimage = null

/mob/proc/see_rift(var/obj/singularity/narsie/large/exit/R)
	var/turf/T_mob = get_turf(src)
	if((R.z == T_mob.z) && (get_dist(R,T_mob) <= (R.consume_range+10)) && !(R in view(T_mob)))
		if(!riftimage)
			riftimage = image('icons/obj/rift.dmi',T_mob,"rift",LIGHTING_LAYER+2,1)
			riftimage.mouse_opacity = 0

		var/new_x = 32 * (R.x - T_mob.x) + R.pixel_x
		var/new_y = 32 * (R.y - T_mob.y) + R.pixel_y
		riftimage.pixel_x = new_x
		riftimage.pixel_y = new_y
		riftimage.loc = T_mob

		src << riftimage

	else
		qdel_null(riftimage)
