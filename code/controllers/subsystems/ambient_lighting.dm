SUBSYSTEM_DEF(ambient_lighting)
	name = "Ambient Lighting"
	wait = 1
	priority = SS_PRIORITY_LIGHTING
	init_order = SS_INIT_AMBIENT_LIGHT
	runlevels = RUNLEVELS_PREGAME | RUNLEVELS_GAME

	/// The generic ambient group. Used for non-planetary areas
	var/const/SPACE_AMBIENT_GROUP = 1

	/// The maximum number of ambient groups to keep track of. Hard limited at 24
	var/const/MAX_AMBIENT_GROUPS = 16

	/// The list of existing ambient groups
	var/static/list/datum/ambient_group/ambient_groups

	/// The next free ambient group index
	var/static/next_ambient_group_index

	/// List of turfs queued for ambient light evaluation
	var/static/list/queue


/datum/controller/subsystem/ambient_lighting/Recover()
	Initialize()


/datum/controller/subsystem/ambient_lighting/Initialize(start_timeofday)
	QDEL_NULL_LIST(ambient_groups)
	ambient_groups = list(
		new /datum/ambient_group (SSskybox.starlight_color, config.starlight, index)
	)
	next_ambient_group_index = 2
	queue = list()
	fire(FALSE, TRUE)


/datum/controller/subsystem/ambient_lighting/fire(resumed, no_mc_tick)
	var/cut_until = 1
	var/starlight = config.starlight
	var/needs_ambience
	for (var/turf/turf as anything in queue)
		++cut_until
		if (!turf)
			continue
		if (turf.is_outside())
			needs_ambience = turf.dynamic_lighting && turf.loc?:dynamic_lighting
			if (!needs_ambience)
				for (var/turf/near in RANGE_TURFS(turf, 1))
					needs_ambience = near.dynamic_lighting && near.loc?:dynamic_lighting
					if (needs_ambience)
						break
			if (!needs_ambience)
				continue
			var/obj/overmap/visitable/sector/exoplanet/exoplanet = map_sectors["[turf.z]"]
			if (istype(exoplanet))
				var/datum/ambient_group/group = exoplanet.ambient_group_index
				if (!group)
					continue
				group = ambient_groups[exoplanet.ambient_group_index]
				group.add_turf(turf)
			else if (starlight)
				var/datum/ambient_group/group = ambient_groups[SPACE_AMBIENT_GROUP]
				group.add_turf(turf)
		else if (turf.ambient_active && turf.ambient_bitflag)
			for (var/datum/ambient_group/group as anything in ambient_groups)
				group.remove_turf(turf)
				if (!turf.ambient_bitflag)
					break
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()


/// Attempts to create an ambient group. Returns the index of the group, or 0 if no more are allowed.
/datum/controller/subsystem/ambient_lighting/proc/create_ambient_group(color, multiplier)
	if (next_ambient_group_index > MAX_AMBIENT_GROUPS)
		return 0
	ambient_groups[next_ambient_group_index++] = new /datum/ambient_group (color, multiplier, index)
	return next_ambient_group_index - 1


/// Remove turf from all ambient groups
/datum/controller/subsystem/ambient_lighting/proc/clean_turf(turf/target)
	if (!target.ambient_bitflag)
		return
	for (var/i in 1 to length(ambient_groups))
		if (target.ambient_bitflag & FLAG(i))
			ambient_groups[i].remove_turf(target)
		if (!target.ambient_bitflag)
			return


/datum/ambient_group
	/// Index in SSambient_lighting.ambient_groups
	var/index
	var/list/member_turfs_by_z = list()
	/// Color data, do NOT modify manually
	var/apparent_r
	var/apparent_g
	var/apparent_b
	/// Prevent modification of member turfs or colour while an operation is taking place
	var/busy = FALSE


/datum/ambient_group/New(color, multiplier, index)
	set_color(color, multiplier)
	src.index = index


/datum/ambient_group/proc/set_color(color, multiplier)
	var/list/new_parts = rgb2num(color)
	var/dr = (new_parts[1] / 255) * multiplier - apparent_r
	var/dg = (new_parts[2] / 255) * multiplier - apparent_g
	var/db = (new_parts[3] / 255) * multiplier - apparent_b
	if (!round(dr / 4, LIGHTING_ROUND_VALUE) && !round(dg / 4, LIGHTING_ROUND_VALUE) && !round(db / 4, LIGHTING_ROUND_VALUE))
		return
	busy = TRUE
	for (var/list/turfs as anything in length(member_turfs_by_z))
		for (var/turf/turf as anything in turfs)
			turf.add_ambient_light_raw(dr, dg, db)
			CHECK_TICK
	apparent_r += dr
	apparent_g += dg
	apparent_b += db
	busy = FALSE


/// Adds the group's ambient light to turf, respecting the group's busy state
/datum/ambient_group/proc/set_ambient_light(turf/turf)
	set waitfor = FALSE
	while (busy)
		stoplag()
	turf.add_ambient_light_raw(apparent_r, apparent_g, apparent_b)


/// Removes the group's ambient light from turf, respecting the group's busy state
/datum/ambient_group/proc/remove_ambient_light(turf/turf)
	set waitfor = FALSE
	while (busy)
		stoplag()
	turf.add_ambient_light_raw(-apparent_r, -apparent_g, -apparent_b)


/// Adds turf to the ambient group and sets its ambient light
/datum/ambient_group/proc/add_turf(turf/turf)
	set waitfor = FALSE
	while (busy)
		stoplag()
	if (turf.ambient_bitflag & FLAG(index))
		return
	if (turf.z > length(member_turfs_by_z))
		member_turfs_by_z.len = T.z
	LAZYADD(member_turfs_by_z[T.z], T)
	T.ambient_bitflag |= FLAG(index)
	set_ambient_light(T)


/**
 * Removes turf from ambient group if it is part of it. Removes group's ambient light and flag from turf
 * - `T` turf - Turf to remove
 */
/datum/ambient_group/proc/remove_turf(turf/turf)
	set waitfor = FALSE
	while (busy)
		stoplag()
	if (!(turf.ambient_bitflag & FLAG(index)))
		return
	if (turf.z > length(member_turfs_by_z))
		CRASH("Attempt to remove member turf with Z greater than local max -- this turf is not a member")
	remove_ambient_light(turf)
	turf.ambient_bitflag &= ~FLAG(index)
	member_turfs_by_z[turf.z] -= turf
