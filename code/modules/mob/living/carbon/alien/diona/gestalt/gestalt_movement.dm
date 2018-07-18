/obj/structure/diona_gestalt/relaymove(var/mob/user, var/direction)
	if(nymphs[user]) step(src, direction) // ANARCHY! DEMOCRACY! ANARCHY! DEMOCRACY!

// Naaaa na na na na naa naa https://www.youtube.com/watch?v=iMH49ieL4es
/obj/structure/diona_gestalt/Bump(var/atom/movable/AM, var/yes) // what a useful argname, thanks oldcoders
	. = ..()
	if(AM && valid_things_to_roll_up[AM.type] && AM.Adjacent(src))
		var/turf/stepping = AM.loc
		take_nymph(AM)
		if(stepping)
			step_towards(src, stepping)
	else if(istype(AM, /obj/structure/diona_gestalt) && AM != src) // Combine!?
		var/obj/structure/diona_gestalt/gestalt = AM
		if(LAZYLEN(gestalt.nymphs))
			for(var/nimp in gestalt.nymphs)
				take_nymph(nimp, silent = TRUE)
			gestalt.nymphs.Cut()
		var/gestalt_loc = gestalt.loc
		qdel(gestalt)
		visible_message("<span class='notice'>The nascent gestalts combine together!</span>") // Combine!
		step_towards(src, gestalt_loc)

/obj/structure/diona_gestalt/Bumped(var/atom/A)
	. = ..()
	if(istype(A, /mob/living/carbon/alien/diona) && A.Adjacent(src)) // Combine...
		take_nymph(A)
