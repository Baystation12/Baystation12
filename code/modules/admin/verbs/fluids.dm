/datum/admins/proc/spawn_fluid_verb()
	set name = "Spawn Water"
	set desc = "Flood the turf you are standing on."
	set category = "Debug"

	if(!check_rights(R_SPAWN)) return
	var/mob/user = usr
	if(istype(user) && user.client)
		for(var/thing in trange(1, get_turf(user)))
			var/turf/T = thing
			T.add_fluid(2000, /datum/reagent/water)

/datum/admins/proc/jump_to_fluid_source()

	set name = "Jump To Fluid Source"
	set desc = "Jump to an active fluid source."
	set category = "Debug"

	if(!check_rights(R_SPAWN)) return
	var/mob/user = usr
	if(istype(user) && user.client)
		if(SSfluids.water_sources.len)
			user.forceMove(get_turf(pick(SSfluids.water_sources)))
		else
			to_chat(usr, "No active fluid sources.")

/datum/admins/proc/jump_to_fluid_active()

	set name = "Jump To Fluid Activity"
	set desc = "Jump to an active fluid overlay."
	set category = "Debug"

	if(!check_rights(R_SPAWN)) return
	var/mob/user = usr
	if(istype(user) && user.client)
		if(SSfluids.active_fluids.len)
			user.forceMove(get_turf(pick(SSfluids.active_fluids)))
		else
			to_chat(usr, "No active fluids.")

/turf/simulated/open/flooded
	name = "open water"
	flooded = TRUE

/turf/simulated/ocean/non_flooded
	flooded = FALSE

GLOBAL_LIST_INIT(submerged_levels, new)
/datum/admins/proc/submerge_map()
	set category = "Admin"
	set desc = "Submerge the map in an ocean."
	set name = "Submerge Map"

	if(!check_rights(R_ADMIN))
		return

	if(!usr.z)
		to_chat(usr, SPAN_WARNING("You must be on a valid z-level."))
		return

	var/list/flooding_levels = list(usr.z)
	if(alert("Do you wish to flood this z-level, or this entire z-sector?", null, "This level", "Connected levels") == "Connected levels")
		flooding_levels = GetConnectedZlevels(usr.z)
	for(var/submerge_z in flooding_levels)
		if(GLOB.submerged_levels["[submerge_z]"])
			flooding_levels -= "[submerge_z]"
	if(!length(flooding_levels))
		to_chat(usr, SPAN_WARNING("This part of the map has already been dropped into an ocean."))
		return

	if(alert("Are you sure you want to drop this section of the map into the ocean?", null, "No", "Yes") == "No")
		return

	to_world(SPAN_NOTICE("<b>[usr.key] fumbled and dropped the server into an ocean, please wait for the game to catch up.</b>"))

	sleep(10) // To ensure the message prints.

	SSfluids.suspend()
	SSao.suspend()
	SSicon_update.suspend()

	// Pre-flood turfs we aren't going to replace.
	for(var/submerge_z in flooding_levels)
		for(var/thing in block(locate(1, 1, submerge_z), locate(world.maxx, world.maxy, submerge_z)))
			var/turf/T = thing
			var/area/A = get_area(T)
			if(A && (A.area_flags & AREA_FLAG_EXTERNAL))
				if(A.base_turf)
					A.base_turf = /turf/simulated/ocean/non_flooded
				if(!istype(T, /turf/space))
					T.make_flooded()

	// Generate the sea floor on the highest z-level in the set.
	var/first_level = flooding_levels[1]
	for(var/check_level in flooding_levels)
		if(check_level < first_level)
			first_level = check_level
	flooding_levels -= first_level
	GLOB.submerged_levels["[first_level]"] = TRUE
	GLOB.using_map.base_turf_by_z["[first_level]"] = /turf/simulated/ocean
	new /datum/random_map/noise/seafloor/replace_space(null, 1, 1, first_level, world.maxx, world.maxy)

	// Generate open space for the remaining z-levels.
	for(var/submerge_z in flooding_levels)
		GLOB.submerged_levels["[submerge_z]"] = TRUE
		GLOB.using_map.base_turf_by_z["[submerge_z]"] = /turf/simulated/open
		for(var/thing in block(locate(1, 1, submerge_z), locate(world.maxx, world.maxy, submerge_z)))
			var/turf/T = thing
			var/area/A = get_area(T)
			if(A && (A.area_flags & AREA_FLAG_EXTERNAL))
				if(A.base_turf)
					A.base_turf = /turf/simulated/open
				if(istype(T, /turf/space))
					T.ChangeTurf(/turf/simulated/open/flooded)
				else if(istype(T, /turf/simulated/open))
					T.make_flooded()
				CHECK_TICK

	sleep(10)

	SSicon_update.wake()
	SSao.wake()
	SSfluids.wake()

	to_world(SPAN_NOTICE("<b>[usr.key] has finished dunking the server into the ocean.</b>"))