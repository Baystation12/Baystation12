
/proc/play_jump_sound(var/turf/overmap_turf, var/sound, var/do_jump_alert = FALSE)
	var/list/mobs_to_sendsound = list()
	for(var/obj/effect/overmap/om in range(SLIPSPACE_JUMPSOUND_RANGE, overmap_turf))
		mobs_to_sendsound |= GLOB.mobs_in_sectors[om]

	var/list/dirlist = list("north","south","n/a","east","northeast","southeast","n/a","west","northwest","southwest")
	for(var/mob/m in mobs_to_sendsound)
		//play a sound
		playsound(m,sound,100)

		//should we also tell them a ship is incoming
		if(do_jump_alert)
			var/dir_to_ship = get_dir(map_sectors["[m.z]"],overmap_turf)
			if(dir_to_ship != 0)
				to_chat(m,"<span class = 'danger'>ALERT: Slipspace rupture detected to the [dirlist[dir_to_ship]]</span>")
/*
/proc/send_jump_alert(var/turf/overmap_turf)
	var/list/mobs_to_alert = list()
	for(var/obj/effect/overmap/om in range(SLIPSPACE_JUMP_ALERT_RANGE, overmap_turf))
		mobs_to_alert |= GLOB.mobs_in_sectors[om]

	for(var/mob/m in mobs_to_alert)
		var/dir_to_ship = get_dir(map_sectors["[m.z]"],overmap_turf)
		if(dir_to_ship != 0)
			to_chat(m,"<span class = 'danger'>ALERT: Slipspace rupture detected to the [dirlist[dir_to_ship]]</span>")
*/
/*
/obj/effect/overmap/proc/do_slipspace_exit_effects(var/exit_loc,var/sound)
	var/obj/effect/overmap/ship/om_ship = src
	if(istype(om_ship))
		om_ship.speed = list(0,0)

	var/headingdir = dir
	var/turf/T = exit_loc
	//Below code should flip the dirs.
	T = get_step(T,headingdir)
	headingdir = get_dir(T,exit_loc)
	T = exit_loc
	for(var/i=0, i<SLIPSPACE_PORTAL_DIST, i++)
		T = get_step(T,headingdir)
	new /obj/effect/slipspace_rupture(T)
	if(sound)
		play_jump_sound(exit_loc,sound)
	send_jump_alert(exit_loc)
	loc = T
	walk_to(src,exit_loc,0,1,0)
	spawn(SLIPSPACE_PORTAL_DIST)
		walk(src,0)
*/
/*
/obj/effect/overmap/proc/do_slipspace_enter_effects(var/sound)
	//BELOW CODE STOLEN FROM CAEL'S IMPLEMENTATION OF THE SLIPSPACE EFFECTS, MODIFIED.//
	var/obj/effect/overmap/ship/om_ship = src
	if(istype(om_ship))
		om_ship.speed = list(0,0)
		om_ship.break_umbilicals()
	//animate the slipspacejump
	var/headingdir = dir
	var/turf/T = loc
	for(var/i=0, i<SLIPSPACE_PORTAL_DIST, i++)
		T = get_step(T,headingdir)
	new /obj/effect/slipspace_rupture(T)
	if(sound)
		play_jump_sound(T,sound)
	//rapidly move into the portal
	walk_to(src,T,0,1,0)
	spawn(SLIPSPACE_PORTAL_DIST)
		loc = null
		walk_to(src,null)
*/
/obj/effect/overmap/proc/slipspace_to_location(var/turf/location,var/target_status,var/sound)
	//do_slipspace_exit_effects(location,sound)
	if(!isnull(target_status))
		slipspace_status = 0

/obj/effect/overmap/proc/slipspace_to_nullspace(var/target_status,sound)
	//do_slipspace_enter_effects(sound)
	if(!isnull(target_status))
		slipspace_status = target_status
