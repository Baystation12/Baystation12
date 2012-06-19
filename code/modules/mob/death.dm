//This is the proc for gibbing a mob. Cannot gib ghosts.
//added different sort of gibs and animations. N
/mob/proc/gib()
	death(1)
	var/atom/movable/overlay/animation = null
	monkeyizing = 1
	canmove = 0
	icon = null
	invisibility = 101

	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'mob.dmi'
	animation.master = src

//	flick("gibbed-m", animation)
	gibs(loc, viruses, dna)

	spawn(15)
		if(animation)	del(animation)
		if(src)			del(src)


//This is the proc for turning a mob into ash. Mostly a copy of gib code (above).
//Originally created for wizard disintegrate. I've removed the virus code since it's irrelevant here.
//Dusting robots does not eject the MMI, so it's a bit more powerful than gib() /N
/mob/proc/dust()
	death(1)
	var/atom/movable/overlay/animation = null
	monkeyizing = 1
	canmove = 0
	icon = null
	invisibility = 101

	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'mob.dmi'
	animation.master = src

//	flick("dust-m", animation)
	new /obj/effect/decal/ash(loc)

	spawn(15)
		if(animation)	del(animation)
		if(src)			del(src)


/mob/proc/death(gibbed)
	timeofdeath = world.time
	var/log_file = file("[time2text(world.timeofday, "statistics/DD-MM-YYYY.txt")]")
	log_file << "Death | \The [get_area(src)] | [bruteloss], [oxyloss], [toxloss], [fireloss][attack_log && attack_log.len? " | [attack_log[attack_log.len]]" : ""]"
	if(client)
		client.onDeath()

	var/cancel = 0
	for(var/mob/M in world)
		if(M.client && (M.stat != DEAD))
			cancel = 1
			break
	if(!cancel)
		world << "<B>Everyone is dead! Resetting in 30 seconds!</B>"

		spawn(300)
			for(var/mob/M in world)
				if(M.client && (M.stat != DEAD))
					world << "Aborting world restart!"
					return

			feedback_set_details("end_error","no live players")

			if(blackbox)
				blackbox.save_all_data_to_sql()

			sleep(50)

			log_game("Rebooting because of no live players")
			world.Reboot()
			return

	return ..(gibbed)
