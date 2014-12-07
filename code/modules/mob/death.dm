//This is the proc for gibbing a mob. Cannot gib ghosts.
//added different sort of gibs and animations. N
/mob/proc/gib(var/anim,var/do_gibs)
	death(1)
	var/atom/movable/overlay/animation = null
	monkeyizing = 1
	canmove = 0
	icon = null
	invisibility = 101

	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src

	update_canmove()

	flick((anim ? anim : "gibbed-m"), animation)
	if(do_gibs)
		gibs(loc, viruses, dna)

	dead_mob_list -= src
	spawn(15)
		if(animation)	del(animation)
		if(src)			del(src)

//This is the proc for turning a mob into ash. Mostly a copy of gib code (above).
//Originally created for wizard disintegrate. I've removed the virus code since it's irrelevant here.
//Dusting robots does not eject the MMI, so it's a bit more powerful than gib() /N
/mob/proc/dust(var/anim,var/remains)
	death(1)
	var/atom/movable/overlay/animation = null
	monkeyizing = 1
	canmove = 0
	icon = null
	invisibility = 101

	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src

	flick(anim ? anim : "dust-m", animation)
	if(remains)
		new remains(loc)
	else
		new /obj/effect/decal/cleanable/ash(loc)

	dead_mob_list -= src
	spawn(15)
		if(animation)	del(animation)
		if(src)			del(src)


/mob/proc/death(gibbed,deathmessage)

	if(stat == DEAD)
		return 0

	if(!gibbed)
		src.visible_message("<b>\The [src.name]</b> [deathmessage ? deathmessage : "seizes up and falls limp..."]")

	stat = DEAD

	update_canmove()

	dizziness = 0
	jitteriness = 0

	layer = MOB_LAYER

	if(blind && client)
		blind.layer = 0

	sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_LEVEL_TWO

	drop_r_hand()
	drop_l_hand()

	if(healths)
		healths.icon_state = "health6"

	timeofdeath = world.time
	if(mind) mind.store_memory("Time of death: [worldtime2text()]", 0)
	living_mob_list -= src
	dead_mob_list |= src

	updateicon()

	if(ticker && ticker.mode)
		ticker.mode.check_win()


	return 1
