/datum/event/solar_storm
	startWhen				= 45
	announceWhen			= 1
	var/const/rad_interval 	= 5  	//Same interval period as radiation storms.
	var/base_solar_gen_rate


/datum/event/solar_storm/setup()
	endWhen = startWhen + rand(30,90) + rand(30,90) //2-6 minute duration

/datum/event/solar_storm/announce()
	command_announcement.Announce("A solar storm has been detected approaching the [station_name()]. Please halt all EVA activites immediately and return to the interior of the station.", "[station_name()] Sensor Array", new_sound = 'sound/AI/radiation.ogg')
	adjust_solar_output(1.5)

/datum/event/solar_storm/proc/adjust_solar_output(var/mult = 1)
	if(isnull(base_solar_gen_rate)) base_solar_gen_rate = solar_gen_rate
	solar_gen_rate = mult * base_solar_gen_rate


/datum/event/solar_storm/start()
	command_announcement.Announce("The solar storm has reached the [station_name()]. Please refain from EVA and remain inside the station until it has passed.", "[station_name()] Sensor Array")
	adjust_solar_output(5)


/datum/event/solar_storm/tick()
	if(activeFor % rad_interval == 0)
		radiate()

/datum/event/solar_storm/proc/radiate()
	var/radiation_level = rand(15, 30)
	for(var/area/A in all_areas)
		if(!(A.z in using_map.player_levels))
			continue
		for(var/turf/T in A)
			if(!istype(T.loc,/area/space) && !istype(T,/turf/space))
				continue
			radiation_repository.irradiated_turfs[T] = radiation_level

/datum/event/solar_storm/end()
	command_announcement.Announce("The solar storm has passed the [station_name()]. It is now safe to resume EVA activities. Please report to medbay if you experience any unusual symptoms. ", "[station_name()] Sensor Array")
	adjust_solar_output()


//For a false alarm scenario.
/datum/event/solar_storm/syndicate/adjust_solar_output()
	return

/datum/event/solar_storm/syndicate/radiate()
	return
