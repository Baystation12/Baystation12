#define SOLAR_FLARE_STEP 5
/datum/event/solar_storm
	startWhen				= 1
	announceWhen			= 1
	var/const/rad_interval 	= 5  	//Same interval period as radiation storms.
	var/const/temp_incr     = 100
	var/const/fire_loss     = 40
	var/base_solar_gen_rate
	var/list/solar_flames = list()
	var/list/turfs_to_light = list()
	var/image/fire


/datum/event/solar_storm/setup()
	endWhen = startWhen + rand(30,90) + rand(30,90) //2-6 minute duration

/datum/event/solar_storm/announce()
	command_announcement.Announce("A solar storm has been detected approaching the [location_name()]. Please halt all EVA activites immediately and take shelter from the storm.", "[location_name()] Sensor Array", zlevels = affecting_z)
	adjust_solar_output(1.5)

/datum/event/solar_storm/proc/adjust_solar_output(var/mult = 1)
	if(isnull(base_solar_gen_rate)) base_solar_gen_rate = solar_gen_rate
	solar_gen_rate = mult * base_solar_gen_rate


/datum/event/solar_storm/start()
	command_announcement.Announce("The solar storm has reached the [location_name()]. Please refain from EVA and remain inside until it has passed.", "[location_name()] Sensor Array", zlevels = affecting_z)
	adjust_solar_output(5)
	fire = image('icons/effects/fire.dmi', src, "2")
	var/fire_color = heat2color(5800) //Kelvin. That's our sun's surface temp. A bit too crispy,though.
	fire.color =  fire_color
	fire.plane = EFFECTS_BELOW_LIGHTING_PLANE
	fire.layer = FIRE_LAYER
	fire.blend_mode = BLEND_DEFAULT
	fire.mouse_opacity = 2
	for(var/area/A in world) //I will regret this.
		if(A.area_flags & AREA_FLAG_EXTERNAL)
			var/turf/simulated/wall/S
			var/turf/unsimulated/wall/U
			var/turf/simulated/floor/F
			var/turf/unsimulated/floor/UN
			var/turf/T
			turfs_to_light += get_area_turfs(A)

			for(T in turfs_to_light)
				if(!(T.x % SOLAR_FLARE_STEP == 0) && !(T.y % SOLAR_FLARE_STEP == 0)) //Would it not be faster to -construct- this list via the step?
					turfs_to_light -= T

			for(S in turfs_to_light) //Skip walls.
				turfs_to_light -= S // Doesn't work.
			for(U in turfs_to_light) //Skip walls.
				turfs_to_light -= U // Doesn't work.
			for(var/turf/space/SP in turfs_to_light)//Skip space.
				turfs_to_light -= SP

			if(F in A.contents || UN in A.contents)
				fire.blend_mode = BLEND_ADD //This doesn't appear to work

			fire.dir = pick(GLOB.cardinal)
			A.underlays += fire
			solar_flames += A
			CHECK_TICK
			for(T in turfs_to_light)
				CHECK_TICK
				T.set_light(1, round(SOLAR_FLARE_STEP/2, 1), SOLAR_FLARE_STEP, 5 , l_color = fire_color)


/datum/event/solar_storm/tick()
	if(activeFor % rad_interval == 0)
		radiate()

/datum/event/solar_storm/proc/radiate()
	// Note: Too complicated to be worth trying to use the radiation system for this.  Its only in space anyway, so we make an exception in this case.
	for(var/mob/living/L in GLOB.living_mob_list_)
		var/turf/T = get_turf(L)
		if(!T || !(T.z in GLOB.using_map.player_levels))
			continue

		if(!get_area(T) in solar_flames)	//Make sure you're in an external area -- GET THAT ASS INSIDE NOW.
			continue

		//Apply some heat or burn damage from the sun.
		if(istype(L, /mob/living/carbon/human))
			L.bodytemperature += temp_incr
		else
			L.adjustFireLoss(fire_loss)


/datum/event/solar_storm/end()
	command_announcement.Announce("The solar storm has passed the [location_name()]. It is now safe to resume EVA activities. ", "[location_name()] Sensor Array", zlevels = affecting_z)
	adjust_solar_output()
	for(var/area/A in solar_flames) //This doesn't work if the controller hangs?
		A.overlays -= fire
		solar_flames -= A
		CHECK_TICK
	for(var/turf/T in turfs_to_light)
		T.set_light(0)
		CHECK_TICK
	qdel(fire)


//For a false alarm scenario.
/datum/event/solar_storm/syndicate/adjust_solar_output()
	return

/datum/event/solar_storm/syndicate/radiate()
	return
