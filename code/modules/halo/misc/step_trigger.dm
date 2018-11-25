
/obj/step_trigger
	name = "Step Trigger"
	desc = "Spawns Shit"

	var/trigger_single_use = 1
	var/trigger_spawn_locations = list() //List of typepaths with associated list. /obj/etc = list(x,y)

/obj/step_trigger/proc/activate_trigger()
	if(trigger_single_use == -1)
		return
	if(trigger_single_use == 1)
		trigger_single_use = -1

	for(var/trigger_spawn_type in trigger_spawn_locations)
		var/list/all_type_locations = trigger_spawn_locations[trigger_spawn_type]
		for(var/spawn_location in all_type_locations)
			var/atom/to_spawn = new trigger_spawn_type (locate(spawn_location[1],spawn_location[2],z))
			do_special_modifications(to_spawn)

/obj/step_trigger/proc/do_special_modifications(var/atom/to_modify)
	return

/obj/step_trigger/sound_maker
	name = "Step Trigger (Sound Maker)"
	desc = "Creates sounds"

/obj/step_trigger/sound_maker/activate_trigger()
	if(trigger_single_use == -1)
		return
	if(trigger_single_use == 1)
		trigger_single_use = -1

	for(var/trigger_spawn_type in trigger_spawn_locations)
		var/list/all_type_locations = trigger_spawn_locations[trigger_spawn_type]
		for(var/spawn_location in all_type_locations)
			var/turf/spawn_loc_turf = locate(spawn_location[1],spawn_location[2],z)
			playsound(spawn_loc_turf, trigger_spawn_type, 100, 1, get_dist(loc,spawn_loc_turf))

