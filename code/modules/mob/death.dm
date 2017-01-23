//This is the proc for gibbing a mob. Cannot gib ghosts.
//added different sort of gibs and animations. N
/mob/proc/gib(anim="gibbed-m",do_gibs)
	death(1)
	transforming = 1
	canmove = 0
	icon = null
	invisibility = 101
	update_canmove()
	remove_from_dead_mob_list()

	var/atom/movable/overlay/animation = null
	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src

	flick(anim, animation)
	if(do_gibs) gibs(loc, dna)

	spawn(15)
		if(animation)	qdel(animation)
		if(src)			qdel(src)

//This is the proc for turning a mob into ash. Mostly a copy of gib code (above).
//Originally created for wizard disintegrate. I've removed the virus code since it's irrelevant here.
//Dusting robots does not eject the MMI, so it's a bit more powerful than gib() /N
/mob/proc/dust(anim="dust-m",remains=/obj/effect/decal/cleanable/ash)
	death(1)
	var/atom/movable/overlay/animation = null
	transforming = 1
	canmove = 0
	icon = null
	invisibility = 101

	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src

	flick(anim, animation)
	new remains(loc)

	remove_from_dead_mob_list()
	spawn(15)
		if(animation)	qdel(animation)
		if(src)			qdel(src)


/mob/proc/death(gibbed,deathmessage="seizes up and falls limp...")

	if(stat == DEAD)
		return 0

	facing_dir = null

	if(!gibbed && deathmessage != "no message") // This is gross, but reliable. Only brains use it.
		src.visible_message("<b>\The [src.name]</b> [deathmessage]")

	set_stat(DEAD)
	reset_plane_and_layer()
	update_canmove()

	dizziness = 0
	jitteriness = 0

	set_sight(sight|SEE_TURFS|SEE_MOBS|SEE_OBJS)
	set_see_in_dark(8)
	set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)

	drop_r_hand()
	drop_l_hand()

	//TODO:  Change death state to health_dead for all these icon files.  This is a stop gap.

	if(healths)
		healths.overlays = null // This is specific to humans but the relevant code is here; shouldn't mess with other mobs.
		if("health7" in icon_states(healths.icon))
			healths.icon_state = "health7"
		else
			healths.icon_state = "health6"
			log_debug("[src] ([src.type]) died but does not have a valid health7 icon_state (using health6 instead). report this error to Ccomp5950 or your nearest Developer")

	timeofdeath = world.time
	if(mind) mind.store_memory("Time of death: [stationtime2text()]", 0)
	switch_from_living_to_dead_mob_list()

	updateicon()

	if(ticker && ticker.mode)
		ticker.mode.check_win()
	to_chat(src,"<span class='deadsay'>You are dead.</span>")
	return 1
