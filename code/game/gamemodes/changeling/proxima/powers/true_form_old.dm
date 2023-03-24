/mob/proc/horror_form()
	set category = "Changeling"
	set name = "Horror Form (50)"
	set desc = "Tear apart your human disguise, revealing your true form."

	var/datum/changeling/changeling = changeling_power(50,0,0)
	if(!changeling)	return 0
	src.mind.changeling.chem_charges -= 50

	var/mob/living/M = src

	M.visible_message(SPAN_DANGER("[M] writhes and contorts, their body expanding to inhuman proportions!"), \
						SPAN_LING("We begin our transformation to our true form!"))
	if(!do_after(src,60))
		M.visible_message(SPAN_DANGER("[M]'s transformation abruptly reverts itself!"), \
							SPAN_LING("Our transformation has been interrupted!"))
		return 0

	M.visible_message(SPAN_DANGER("[M] grows into an abomination and lets out an awful scream!"))
	playsound(loc, 'infinity/sound/effects/greaterling.ogg', 100, 1)

	var/mob/living/simple_animal/hostile/true_changeling/ling = new (get_turf(M))

	if(istype(M,/mob/living/carbon/human))
		for(var/obj/item/I in M.contents)
			if(isorgan(I))
				continue
			M.drop_from_inventory(I)

	if(M.mind)
		M.mind.transfer_to(ling)
	else
		ling.key = M.key
	var/atom/movable/overlay/effect = new /atom/movable/overlay(get_turf(M))
	effect.density = FALSE
	effect.anchored = TRUE
	effect.icon = 'icons/effects/effects.dmi'
	effect.layer = 3
	flick("summoning",effect)
	QDEL_IN(effect, 10)
	M.forceMove(ling) //move inside the new dude to hide him.
	M.status_flags |= GODMODE //dont want him to die or breathe or do ANYTHING
	addtimer(CALLBACK(src, .proc/revert_horror_form,ling), 10 MINUTES)

/mob/proc/revert_horror_form(var/mob/living/ling)
	if(QDELETED(ling))
		return
	src.status_flags &= ~GODMODE //no more godmode.
	if(ling.mind)
		ling.mind.transfer_to(src)
	else
		src.key = ling.key
	playsound(get_turf(src),'sound/effects/blobattack.ogg',50,1)
	src.forceMove(get_turf(ling))
