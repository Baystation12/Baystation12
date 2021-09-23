/datum/event/meteor_wave
	startWhen		= 30	// About one minute early warning
	endWhen 		= 60	// Adjusted automatically in tick()
	has_skybox_image = TRUE
	var/alarmWhen   = 30
	var/next_meteor = 40
	var/waves = 1
	var/start_side
	var/next_meteor_lower = 10
	var/next_meteor_upper = 20

/datum/event/meteor_wave/get_skybox_image()
	return overlay_image('icons/skybox/rockbox.dmi', "rockbox", COLOR_ASTEROID_ROCK, RESET_COLOR)

/datum/event/meteor_wave/setup()
	waves = 0
	for(var/n in 1 to severity)
		waves += rand(5,15)

	start_side = pick(GLOB.cardinal)
	endWhen = worst_case_end()

/datum/event/meteor_wave/announce()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce(replacetext_char(GLOB.using_map.meteor_detected_message, "%STATION_NAME%", location_name()), "[location_name()] Sensor Array", new_sound = GLOB.using_map.meteor_detected_sound, zlevels = affecting_z)
		else
			command_announcement.Announce("The [location_name()] is now in a meteor shower.", "[location_name()] Sensor Array", zlevels = affecting_z)

/datum/event/meteor_wave/tick()
	// Begin sending the alarm signals to shield diffusers so the field is already regenerated (if it exists) by the time actual meteors start flying around.
	if(alarmWhen < activeFor)
		for(var/obj/machinery/shield_diffuser/SD in SSmachines.machinery)
			if(isStationLevel(SD.z))
				SD.meteor_alarm(10)

	if(waves && activeFor >= next_meteor)
		send_wave()

/datum/event/meteor_wave/proc/worst_case_end()
	return activeFor + ((30 / severity) * waves) + 30

/datum/event/meteor_wave/proc/send_wave()
	var/pick_side = prob(80) ? start_side : (prob(50) ? turn(start_side, 90) : turn(start_side, -90))
	spawn() spawn_meteors(get_wave_size(), get_meteors(), pick_side, pick(affecting_z))
	next_meteor += rand(next_meteor_lower, next_meteor_upper) / severity
	waves--
	endWhen = worst_case_end()

/datum/event/meteor_wave/proc/get_wave_size()
	return severity * rand(2,4)

/datum/event/meteor_wave/end()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("The [location_name()] has cleared the meteor storm.", "[location_name()] Sensor Array", zlevels = affecting_z)
		else
			command_announcement.Announce("The [location_name()] has cleared the meteor shower", "[location_name()] Sensor Array", zlevels = affecting_z)

/datum/event/meteor_wave/proc/get_meteors()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			return meteors_major
		if(EVENT_LEVEL_MODERATE)
			return meteors_moderate
		else
			return meteors_minor

/var/list/meteors_minor = list(
	/obj/effect/meteor/medium     = 80,
	/obj/effect/meteor/dust       = 30,
	/obj/effect/meteor/irradiated = 30,
	/obj/effect/meteor/big        = 30,
	/obj/effect/meteor/flaming    = 10,
	/obj/effect/meteor/golden     = 10,
	/obj/effect/meteor/silver     = 10,
)

/var/list/meteors_moderate = list(
	/obj/effect/meteor/medium     = 80,
	/obj/effect/meteor/big        = 30,
	/obj/effect/meteor/dust       = 30,
	/obj/effect/meteor/irradiated = 30,
	/obj/effect/meteor/flaming    = 10,
	/obj/effect/meteor/golden     = 10,
	/obj/effect/meteor/silver     = 10,
	/obj/effect/meteor/emp        = 10,
)

/var/list/meteors_major = list(
	/obj/effect/meteor/medium     = 80,
	/obj/effect/meteor/big        = 30,
	/obj/effect/meteor/dust       = 30,
	/obj/effect/meteor/irradiated = 30,
	/obj/effect/meteor/emp        = 30,
	/obj/effect/meteor/flaming    = 10,
	/obj/effect/meteor/golden     = 10,
	/obj/effect/meteor/silver     = 10,
	/obj/effect/meteor/tunguska   = 1,
)

/datum/event/meteor_wave/overmap
	next_meteor_lower = 5
	next_meteor_upper = 10
	next_meteor = 0
	var/obj/effect/overmap/visitable/ship/victim

/datum/event/meteor_wave/overmap/Destroy()
	victim = null
	. = ..()

/datum/event/meteor_wave/overmap/tick()
	if(!victim)
		return
	if (victim.is_still() || victim.get_helm_skill() >= SKILL_ADEPT) //Unless you're standing or good at your job..
		start_side = pick(GLOB.cardinal)
	else //..Meteors mostly fly in your face
		start_side = prob(90) ? victim.fore_dir : pick(GLOB.cardinal)
	..()

/datum/event/meteor_wave/overmap/get_wave_size()
	. = ..()
	if (!victim)
		return
	var/skill = victim.get_helm_skill()
	var/speed = victim.get_speed()
	if (skill < SKILL_EXPERT)
		if(victim.is_still() || speed < SHIP_SPEED_SLOW) //Standing still or being slow means less shit flies your way
			. = round(. * 0.7)
		if(speed > SHIP_SPEED_FAST) //Sanic stahp
			. *= 2
	if (skill == SKILL_EXPERT)
		if (victim.is_still())
			. = round(. * 0.2)
		if (speed < SHIP_SPEED_SLOW)
			. = round(. * 0.5)
		if (speed > SHIP_SPEED_SLOW && speed < SHIP_SPEED_FAST)
			. = round(. * 0.7)
		if (speed > SHIP_SPEED_FAST)
			. = round(. * 1.2)
	if (skill > SKILL_EXPERT)
		if (victim.is_still())
			. = round(. * 0.1)
		if (speed < SHIP_SPEED_SLOW)
			. = round(. * 0.2)
		if (speed > SHIP_SPEED_SLOW && speed < SHIP_SPEED_FAST)
			. = round(. * 0.5)

	//Smol ship evasion
	if(victim.vessel_size < SHIP_SIZE_LARGE && speed < SHIP_SPEED_FAST)
		var/skill_needed = SKILL_PROF
		if(speed < SHIP_SPEED_SLOW)
			skill_needed = SKILL_ADEPT
		if(victim.vessel_size < SHIP_SIZE_SMALL)
			skill_needed = skill_needed - 1
		if(skill >= max(skill_needed, victim.skill_needed))
			return 0