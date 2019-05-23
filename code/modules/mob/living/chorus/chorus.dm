/mob/living/chorus
	name = "Chorus"
	desc = "An odd creature. Intent on one thing: domination."
	icon = 'icons/obj/cult_tall.dmi'
	icon_state = "hole"
	health = 200
	maxHealth = 200
	density = 0
	simulated = FALSE
	invisibility = 101
	universal_understand = TRUE
	see_in_dark = 15
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	var/phase = CHORUS_PHASE_OBSERVE
	var/datum/visualnet/chorus_net

/mob/living/chorus/Initialize()
	. = ..()
	chorus_net = new /datum/visualnet/cultnet()
	var/mob/observer/eye/eye = new /mob/observer/eye/cult(get_turf(src), chorus_net)
	eye.possess(src)
	forceMove(eye)
	chorus_net.add_source(src)

/mob/living/chorus/Destroy()
	eyeobj.release(src)
	qdel(eyeobj)
	qdel(chorus_net)
	. = ..()

/mob/living/chorus/update_sight()
	if(stat == DEAD)
		update_dead_sight()
	else
		update_living_sight()

/mob/living/chorus/proc/upgrade_to_egg(var/position)
	set name = "Plant"
	set category = "Godhood"

	if(phase != CHORUS_PHASE_OBSERVE || !form)
		return
	forceMove(position)
	simulated = TRUE
	density = 1
	invisibility = 0
	anchored = TRUE
	phase = CHORUS_PHASE_EGG