SUBSYSTEM_DEF(ambient_lighting) //A simple SS that handles updating ambient lights of away sites and such places
	name = "Ambient Lighting"
	wait = 1
	priority = SS_PRIORITY_LIGHTING
	init_order = SS_INIT_AMBIENT_LIGHT
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/queued = list()

	/// A bitmap of free ambience group indexes.
	var/ambient_group_free_bitmap = ~0
	var/list/ambient_groups[AMBIENT_GROUP_MAX_BITS]

/datum/ambient_group
	var/global_index
	var/list/member_turfs_by_z = list()
	var/apparent_r
	var/apparent_g
	var/apparent_b
	var/busy = FALSE

/datum/ambient_group/New(ncolor, nmultiplier, nindex)
	. = ..()
	set_color(ncolor, nmultiplier)
	global_index = nindex

/datum/ambient_group/Destroy()
	SSambient_lighting.ambient_groups[global_index] = null
	SSambient_lighting.ambient_group_free_bitmap |= FLAG(global_index)
	return ..()

/datum/ambient_group/proc/set_color(color, multiplier)
	var/list/new_parts = rgb2num(color)
	//Calculate delta from current to desired location
	var/dr = (new_parts[1] / 255) * multiplier - apparent_r
	var/dg = (new_parts[2] / 255) * multiplier - apparent_g
	var/db = (new_parts[3] / 255) * multiplier - apparent_b

	if (round(dr/4, LIGHTING_ROUND_VALUE) == 0 && round(dg/4, LIGHTING_ROUND_VALUE) == 0 && round(db/4, LIGHTING_ROUND_VALUE) == 0)
		// no-op
		return

	busy = TRUE

	// Doing it ordered by zlev should ensure that it looks vaguely coherent mid-update regardless of turf insertion order.
	for (var/zlev in 1 to member_turfs_by_z.len)
		for (var/turf/T as anything in member_turfs_by_z[zlev])
			T.add_ambient_light_raw(dr, dg, db)
			CHECK_TICK

	apparent_r += dr
	apparent_g += dg
	apparent_b += db

	busy = FALSE

/datum/ambient_group/proc/set_ambient_light(turf/T)
	set waitfor = FALSE

	UNTIL(!busy)
	T.add_ambient_light_raw(apparent_r, apparent_g, apparent_b)

/datum/ambient_group/proc/remove_ambient_light(turf/T)
	set waitfor = FALSE

	UNTIL(!busy)
	T.add_ambient_light_raw(-apparent_r, -apparent_g, -apparent_b)

/datum/ambient_group/proc/add_turf(turf/T)
	set waitfor = FALSE

	UNTIL(!busy)
	//Already existing
	if(T.ambient_bitflag & FLAG(global_index))
		return

	if (T.z > member_turfs_by_z)
		member_turfs_by_z.len = T.z

	LAZYADD(member_turfs_by_z[T.z], T)
	T.ambient_bitflag |= FLAG(global_index)
	set_ambient_light(T)

/datum/ambient_group/proc/remove_turf(turf/T)
	set waitfor = FALSE

	UNTIL(!busy)
	if(!(T.ambient_bitflag & FLAG(global_index)))
		return

	if (T.z > member_turfs_by_z.len)
		CRASH("Attempt to remove member turf with Z greater than local max -- this turf is not a member")

	remove_ambient_light(T)
	T.ambient_bitflag &= ~FLAG(global_index)
	member_turfs_by_z[T.z] -= T

/datum/controller/subsystem/ambient_lighting/proc/allocate_index()
	if (ambient_group_free_bitmap == 0)
		return -1 //Out of indices, no ambient light for you

	// Find the first free index in the bitmap.
	var/index = 1
	while (!(ambient_group_free_bitmap & FLAG(index)) && index < AMBIENT_GROUP_MAX_BITS)
		index += 1

	ambient_group_free_bitmap &= ~(1 << index)

	return index

/datum/controller/subsystem/ambient_lighting/proc/add_space_ambient_group()
	var/index = allocate_index() //It will always be 1, but we want to make sure bitmap is in a valid state

	ASSERT(index == SPACE_AMBIENT_GROUP)

	ambient_groups[index] = new /datum/ambient_group(SSskybox.background_color, config.starlight, index )

/datum/controller/subsystem/ambient_lighting/proc/create_ambient_group(color, multiplier)

	if(ambient_groups[SPACE_AMBIENT_GROUP] == null) //Something (probably a planet) wants to add an ambient group, add space first
		add_space_ambient_group()

	// Find the first free index in the bitmap.
	var/index = allocate_index()

	if(index <= 0)
		return index

	ambient_groups[index] = new /datum/ambient_group(color, multiplier, index)

	return index

/datum/controller/subsystem/ambient_lighting/proc/clean_turf(turf/target)
	if(target.ambient_bitflag != 0)
		for(var/datum/ambient_group/A in ambient_groups)
			if(target.ambient_bitflag & FLAG(A.global_index))
				A.remove_turf(target)
			if(!target.ambient_bitflag)
				return //Return early if flag is already clear

/datum/controller/subsystem/ambient_lighting/Initialize(start_timeofday)
	//Create space ambient group if nothing created it until now.
	add_space_ambient_group()

	fire(FALSE, TRUE)
	return ..()

/datum/controller/subsystem/ambient_lighting/fire(resumed = FALSE, no_mc_tick = FALSE)
	var/list/curr = queued
	var/starlight_enabled = config.starlight

	var/needs_ambience
	while (length(curr))
		var/turf/target = curr[length(curr)]
		LIST_DEC(curr)

		if(target && target.is_outside())
			needs_ambience = TURF_IS_DYNAMICALLY_LIT_UNSAFE(target)
			if (!needs_ambience)
				for (var/turf/T in RANGE_TURFS(target, 1))
					if(TURF_IS_DYNAMICALLY_LIT_UNSAFE(T))
						needs_ambience = TRUE
						break

			if (needs_ambience)
				var/obj/effect/overmap/visitable/sector/exoplanet/E = map_sectors["[target.z]"]
				if (istype(E))
					if(E.ambient_group_index > 0)
						var/datum/ambient_group/A = ambient_groups[E.ambient_group_index]
						A.add_turf(target)
				else
					if (starlight_enabled) //Assume we can light up exterior with space light generally
						var/datum/ambient_group/A = ambient_groups[SPACE_AMBIENT_GROUP]
						A.add_turf(target)
		else if (TURF_IS_AMBIENT_LIT_UNSAFE(target))
			//Remove from all groups
			if(target.ambient_bitflag != 0)
				for(var/datum/ambient_group/A in ambient_groups)
					A.remove_turf(target)
					if(!target.ambient_bitflag)
						break

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return
