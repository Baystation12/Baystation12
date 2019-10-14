GLOBAL_LIST_INIT(DEMOLITION_MANAGER_LIST, new)

/datum/demolition_manager
	var/list/structural_turfs = list()
	var/max_turfs = 0
	var/max_health = 0
	var/buckle_ratio = 0.5
	var/buckle_damage = 45
	var/is_processing = 0
	var/list/linked_areas = list()
	var/next_sound_time = 0
	var/sound_interval = 5 SECONDS
	var/target_destruction_timer = 180	//seconds
	var/time_last_process = 0
	var/overmap_z = 0		//this will be a random zlevel from one of the demo walls... doesnt matter which level because we only use it to get the overmap object

/datum/demolition_manager/proc/wall_added(var/turf/simulated/wall/r_wall/demo/new_wall)
	overmap_z = new_wall.z
	structural_turfs |= new_wall
	linked_areas |= get_area(new_wall)
	if(structural_turfs.len > max_turfs)
		max_turfs = structural_turfs.len
		max_health += new_wall.max_health()

/datum/demolition_manager/proc/wall_destroyed(var/turf/simulated/wall/r_wall/demo/destroyed_wall)
	structural_turfs -= destroyed_wall

	if(structural_turfs.len / max_turfs <= buckle_ratio)
		//calculate destruction rate
		var/remaining_wall_health = max_health * buckle_ratio
		buckle_damage = round(remaining_wall_health / target_destruction_timer)

		set_processing(1)

	log_and_message_admins("Structural turf for z[destroyed_wall.z] destroyed! [structural_turfs.len] out of [max_turfs] turfs left. [get_info_string()]")

	return 1

/datum/demolition_manager/proc/do_demolition()

	//grab some stuff
	var/obj/effect/overmap/O = map_sectors["[overmap_z]"]
	var/datum/faction/target_faction = O.my_faction

	//tell the admins
	log_and_message_admins("Demolishing [O] | [O.type] owned by [target_faction ? target_faction.name : "NULL"] and disabling their spawns")

	//rocks fall everyone dies
	O.demolished = 1

	//disable jobs
	for(var/datum/job/J in job_master.occupations)
		if(J.spawn_faction == target_faction.name)
			J.spawn_positions = 0
			J.total_positions = 0

	//tell anyone stupid enough to be hanging around
	play_mobs_sound('sound/effects/meteorimpact.ogg')
	to_chat(get_mobs_inside(), "<span class='warning'>The roof collapses all around you!</span>")

	spawn(0)
		spawn_debris()

/datum/demolition_manager/proc/spawn_debris()
	set background = 1

	for(var/area/A in linked_areas)
		for(var/obj/machinery/power/apc/apc in A)
			apc.overload_lighting(100)

		for(var/turf/simulated/floor/T in A)
			if(istype(T, /turf/simulated/floor/asteroid/planet))
				continue
			if(istype(T, /turf/simulated/floor/water))
				continue

			if(prob(75))
				var/obj/blocker = locate(/obj/machinery) in T
				if(!blocker)
					blocker = locate(/obj/structure) in T
				if(istype(blocker, /obj/structure/boulder))
					continue
				if(istype(blocker, /obj/machinery/light))
					blocker = null

				if(blocker && !blocker.pixel_x && !blocker.pixel_y)
					//no good way to check for wall mounted stuff
					if(prob(66))
						blocker.visible_message("\icon[blocker] <span class='warning'>[blocker] is crushed by a falling boulder as the roof collapses!</span>")
						qdel(blocker)
					else
						continue

				for(var/obj/item/I in T)
					qdel(I)
				for(var/mob/living/M in T)
					M.visible_message("\icon[M] <span class='warning'>[M] is crushed by a falling boulder as the roof collapses!</span>")
					M.apply_damage(300, def_zone = BP_HEAD)
					M.apply_damage(300, def_zone = BP_CHEST)
				playsound(T, 'sound/effects/bang.ogg', 100, 1)
				new /obj/structure/boulder(T)

/datum/demolition_manager/proc/check_demolition()
	if(!structural_turfs.len)
		return 1
	return 0

/datum/demolition_manager/proc/check_integrity_quick()
	if(structural_turfs.len && max_turfs)
		return structural_turfs.len/max_turfs
	return 0

/datum/demolition_manager/proc/check_integrity_exact()
	if(structural_turfs.len && max_health)
		var/health_left = 0
		for(var/turf/simulated/wall/demo_wall in structural_turfs)
			health_left += (demo_wall.max_health() - demo_wall.damage)
		return health_left/max_health

	return 0

/datum/demolition_manager/proc/get_info_string()
	var/integrity = check_integrity_exact()
	if(integrity)
		var/info_message = "Structural integrity: [round(100 * integrity)]%"
		if(check_buckling())
			var/health_left = integrity * max_health
			var/time_left = round(health_left / buckle_damage)		//this assumes 1 tick per second which is approximately correct
			info_message += " WARNING: Structure buckling from strain, collapse in approximately [time_left + 1] seconds."
		return info_message
	else
		return "This area has been subjected to a massive recent structural upheaval."

/datum/demolition_manager/proc/check_buckling()
	if(structural_turfs.len / max_turfs <= buckle_ratio)
		return 1
	return 0

/datum/demolition_manager/proc/get_mobs_inside()
	var/list/hearing_mobs = list()
	for(var/area/A in linked_areas)
		hearing_mobs += A.mobs_in_area
	return hearing_mobs

/datum/demolition_manager/proc/play_mobs_sound(var/soundin)
	var/sound/S = sound(soundin)
	S.frequency = get_rand_frequency()
	S.volume = 200

	to_chat(get_mobs_inside(), S)

/datum/demolition_manager/proc/process()
	if(!structural_turfs.len)
		set_processing(0)
		do_demolition()

	else if(structural_turfs.len / max_turfs <= buckle_ratio)
		var/turf/simulated/wall/r_wall/demo/structural_turf = pick(structural_turfs)

		//adjust the damage applied based on time passed
		var/delta_time = (world.time - time_last_process) / 10

		structural_turf.buckle(buckle_damage * delta_time)

	else
		set_processing(0)

	//destruction ambience
	if(world.time > next_sound_time)
		next_sound_time = world.time + sound_interval
		play_mobs_sound(pick(\
		'sound/ambience/shipclunk.ogg',\
		'sound/ambience/shipclunk2.ogg',\
		'sound/ambience/shipcreak.ogg',\
		'sound/ambience/shipcreak2.ogg'))
		var/chance = 100 * (1 - check_integrity_quick())
		if(prob(chance))
			to_chat(get_mobs_inside(), "<span class='notice'>The entire structure creaks and groans around you! It's not going to last much longer...</span>")

	time_last_process = world.time

/datum/demolition_manager/proc/set_processing(var/do_process = 1)
	if(do_process)
		if(!is_processing)
			is_processing = 1
			GLOB.processing_objects += src
			time_last_process = world.time
	else
		if(is_processing)
			is_processing = 0
			GLOB.processing_objects -= src
