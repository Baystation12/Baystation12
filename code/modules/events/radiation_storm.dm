/datum/event/radiation_storm
	var/const/enterBelt		= 30
	var/const/radIntervall 	= 5	// Enough time between enter/leave belt for 10 hits, as per original implementation
	var/const/leaveBelt		= 80
	var/const/revokeAccess	= 165 //Hopefully long enough for radiation levels to dissipate.
	startWhen				= 2
	announceWhen			= 1
	endWhen					= revokeAccess
	has_skybox_image		= TRUE
	var/postStartTicks 		= 0

/datum/event/radiation_storm/syndicate
	has_skybox_image = FALSE

/datum/event/radiation_storm/get_skybox_image()
	if(prob(75)) // Sometimes, give no skybox image, to avoid metagaming it
		var/image/res = overlay_image('icons/skybox/radbox.dmi', "beam", null, RESET_COLOR)
		res.alpha = rand(40,80)
		return res

/datum/event/radiation_storm/announce()
	command_announcement.Announce("High levels of radiation detected in proximity of the [location_name()]. Please evacuate into one of the shielded maintenance tunnels.", "[location_name()] Sensor Array", new_sound = GLOB.using_map.radiation_detected_sound, zlevels = affecting_z)

/datum/event/radiation_storm/start()
	..()
	GLOB.using_map.make_maint_all_access(TRUE)

/datum/event/radiation_storm/tick()
	if(activeFor == enterBelt)
		command_announcement.Announce("The [location_name()] has entered the radiation belt. Please remain in a sheltered area until the all clear is given.", "[location_name()] Sensor Array", zlevels = affecting_z)
		if(prob(66))
			radiate()
		else
			postStartTicks -= rand(5,30)

	if(activeFor >= enterBelt && activeFor <= leaveBelt)
		postStartTicks++

	if(postStartTicks == radIntervall)
		postStartTicks = 0
		radiate()

	else if(activeFor == leaveBelt)
		command_announcement.Announce("The [location_name()] has passed the radiation belt. Please allow for up to one minute while radiation levels dissipate, and report to the infirmary if you experience any unusual symptoms. Maintenance will return to normal access parameters shortly.", "[location_name()] Sensor Array", zlevels = affecting_z)

/datum/event/radiation_storm/proc/radiate()
	var/radiation_level = rand(15, 35)
	for(var/z in affecting_z)
		SSradiation.z_radiate(locate(1, 1, z), radiation_level, 1)

	for(var/mob/living/carbon/C in GLOB.living_mob_list_)
		var/area/A = get_area(C)
		if(!A)
			continue
		if(A.area_flags & AREA_FLAG_RAD_SHIELDED)
			continue
		if(istype(C,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = C
			if(prob(5 * (1 - H.get_blocked_ratio(null, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED, armor_pen = radiation_level))))
				if (prob(75))
					randmutb(H) // Applies bad mutation
					domutcheck(H,null,MUTCHK_FORCED)
				else
					randmutg(H) // Applies good mutation
					domutcheck(H,null,MUTCHK_FORCED)

/datum/event/radiation_storm/end()
	GLOB.using_map.revoke_maint_all_access(TRUE)

/datum/event/radiation_storm/syndicate/radiate()
	return
