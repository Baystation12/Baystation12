/obj/structure/diona_gestalt/relaymove(var/mob/user, var/direction)
	if(nymphs[user]) step(src, direction) // ANARCHY! DEMOCRACY! ANARCHY! DEMOCRACY!

// Naaaa na na na na naa naa https://www.youtube.com/watch?v=iMH49ieL4es
/obj/structure/diona_gestalt/Bump(var/atom/movable/AM, var/yes) // what a useful argname, thanks oldcoders
	. = ..()
	if(AM && valid_things_to_roll_up[AM.type] && AM.Adjacent(src))
		forceMove(get_turf(AM))
		take_nymph(AM)

/obj/structure/diona_gestalt/Bumped(var/atom/A)
	. = ..()
	if(istype(A, /mob/living/carbon/alien/diona) && A.Adjacent(src))
		take_nymph(A)
