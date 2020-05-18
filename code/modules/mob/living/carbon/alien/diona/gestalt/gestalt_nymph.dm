/mob/living/carbon/alien/diona/proc/gestalt_with(var/mob/living/carbon/alien/diona/chirp)
	if(!istype(chirp) || chirp == src || chirp.incapacitated() || incapacitated())
		return FALSE
	if(istype(chirp.loc, /obj/structure/diona_gestalt) || istype(loc, /obj/structure/diona_gestalt))
		return FALSE
	visible_message("<span class='notice'>\The [chirp] and \the [src] twine together in gestalt!</span>")
	var/obj/structure/diona_gestalt/blob = new(get_turf(src))
	blob.roll_up_atom(chirp, silent = TRUE)
	blob.roll_up_atom(src, silent = TRUE)
	return TRUE

/obj/structure/diona_gestalt/proc/roll_up_atom(var/mob/living/carbon/alien/diona/chirp, var/silent)
	if(!istype(chirp))
		return
	if(!silent)
		visible_message("<span class='notice'>\The [chirp] is engulfed by \the [src].</span>")
	if(istype(chirp, /mob/living/carbon/alien/diona))
		nymphs[chirp] = TRUE
		queue_icon_update()
	chirp.forceMove(src)

/obj/structure/diona_gestalt/proc/shed_atom(var/atom/movable/shedding, var/silent, var/forcefully)

	if(!shedding)
		var/list/options = contents - nymphs
		if(length(options))
			shedding = pick(options)
		else if(length(nymphs))
			shedding = pick(nymphs)

	if(shedding)
		var/update_nymphs = FALSE
		if(nymphs[shedding])
			nymphs -= shedding
			update_nymphs = TRUE
		shedding.dropInto(loc)
		if(!silent)
			visible_message(SPAN_DANGER("\The [shedding] splits away from \the [src]!"))
		if(forcefully) 
			shedding.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),rand(3,5))
		if(update_nymphs)
			check_nymphs()

// If there are less than two nymphs (or if none of the nymphs have players), it isn't a viable gestalt.
/obj/structure/diona_gestalt/proc/check_nymphs()
	if(LAZYLEN(nymphs.len) >= 2)
		for(var/nimp in nymphs)
			var/mob/living/carbon/alien/diona/chirp = nimp
			if(chirp.client)
				return
	visible_message("<span class='danger'>\The [src] has completely split apart!</span>")
	qdel(src)
