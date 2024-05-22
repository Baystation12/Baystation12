//This is the proc for gibbing a mob. Cannot gib ghosts.
//added different sort of gibs and animations. N
/mob/proc/gib(anim="gibbed-m",do_gibs)
	death(1)
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	icon = null
	set_invisibility(INVISIBILITY_ABSTRACT)
	UpdateLyingBuckledAndVerbStatus()
	remove_from_dead_mob_list()

	var/atom/movable/fake_overlay/animation = new(src)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'

	flick(anim, animation)
	if(do_gibs) gibs(loc, dna)

	addtimer(new Callback(src, PROC_REF(check_delete), animation), 15)

/mob/proc/check_delete(atom/movable/fake_overlay/animation)
	if(animation)	qdel(animation)
	if(src)			qdel(src)

//This is the proc for turning a mob into ash. Mostly a copy of gib code (above).
//Originally created for wizard disintegrate. I've removed the virus code since it's irrelevant here.
//Dusting robots does not eject the MMI, so it's a bit more powerful than gib() /N
/mob/proc/dust(anim="dust-m",remains=/obj/decal/cleanable/ash)
	death(1)

	if(stat == DEAD)
		ghostize(FALSE) //Ghosts the mob here so it keeps its sprite

	var/atom/movable/fake_overlay/animation = null
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	icon = null
	set_invisibility(INVISIBILITY_ABSTRACT)

	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src

	flick(anim, animation)
	new remains(loc)

	remove_from_dead_mob_list()
	addtimer(new Callback(src, PROC_REF(check_delete), animation), 15)


/mob/proc/death(gibbed,deathmessage="seizes up and falls limp...", show_dead_message = "You have died.")

	if(stat == DEAD)
		return 0

	facing_dir = null

	if(!gibbed && deathmessage != "no message") // This is gross, but reliable. Only brains use it.
		src.visible_message("<b>\The [src.name]</b> [deathmessage]")

	set_stat(DEAD)
	adjust_stamina(-100)
	reset_plane_and_layer()
	UpdateLyingBuckledAndVerbStatus()

	dizziness = 0
	jitteriness = 0

	set_sight(sight|SEE_TURFS|SEE_MOBS|SEE_OBJS)
	set_see_in_dark(8)
	set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)

	drop_r_hand()
	drop_l_hand()

	if (mind?.assigned_job && mind.assigned_job.department_flag && !player_is_antag(mind))
		GLOB.crew_death_count += 1

	//TODO:  Change death state to health_dead for all these icon files.  This is a stop gap.
	if(healths)
		healths.ClearOverlays()
		if("health7" in icon_states(healths.icon))
			healths.icon_state = "health7"
		else
			healths.icon_state = "health6"
			log_debug("[src] ([src.type]) died but does not have a valid health7 icon_state (using health6 instead). report this error to Ccomp5950 or your nearest Developer")

	timeofdeath = world.time
	if(mind)
		mind.StoreMemory("Time of death: [stationtime2text()]", /singleton/memory_options/system)
	switch_from_living_to_dead_mob_list()

	update_icon()

	if(SSticker.mode)
		SSticker.mode.check_win()
	to_chat(src,SPAN_CLASS("deadsay", "[show_dead_message]"))
	return 1
