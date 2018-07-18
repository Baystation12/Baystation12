/mob/living/carbon/alien/diona/attack_generic(var/mob/user, var/damage, var/attack_message)
	if(!gestalt_with(user)) . = ..()

/mob/living/carbon/alien/diona/proc/gestalt_with(var/mob/living/carbon/alien/diona/chirp)
	if(!istype(chirp) || chirp == src || istype(chirp.loc, /obj/structure/diona_gestalt) || istype(loc, /obj/structure/diona_gestalt))
		return FALSE
	visible_message("<span class='notice'>\The [chirp] and \the [src] twine together in gestalt!</span>")
	var/obj/structure/diona_gestalt/blob = new(get_turf(src))
	blob.take_nymph(chirp, silent = TRUE)
	blob.take_nymph(src, silent = TRUE)
	return TRUE

/obj/structure/diona_gestalt/proc/take_nymph(var/mob/living/carbon/alien/diona/chirp, var/silent)
	if(!silent)
		visible_message("<span class='notice'>\The [chirp] is engulfed by \the [src].</span>")
	nymphs[chirp] = TRUE
	chirp.forceMove(src)
	update_icon()

/obj/structure/diona_gestalt/proc/shed_nymph(var/mob/living/carbon/alien/diona/nymph, var/silent, var/forcefully)
	if(!nymph && nymphs && nymphs.len)
		nymph = pick(nymphs)
	if(nymph)
		nymphs -= nymph // unsure if pick_n_take() works on assoc lists.
		nymph.dropInto(loc)
		if(!silent)    visible_message("<span class='danger'>\The [nymph] is split away from \the [src]!</span>")
		if(forcefully) nymph.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),rand(3,5))
		check_nymphs()

/obj/structure/diona_gestalt/proc/check_nymphs()
	if(!nymphs || LAZYLEN(nymphs.len <= 1))
		visible_message("<span class='danger'>\The [src] has been completely torn apart!</span>")
		qdel(src)
