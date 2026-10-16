#define MAX_AMBIENT_GROUP_INDEX MAX_FLAG_INDEX


SUBSYSTEM_DEF(ambient_lighting)
	name = "Ambient Lighting"
	wait = 1
	priority = SS_PRIORITY_LIGHTING
	init_order = SS_INIT_AMBIENT_LIGHT
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_GAME

	/// Bitfield of free ambience group indices / channels
	var/static/free_group_flags = FLAGS_ON

	/// Sparse list of ambient group instances
	var/static/list/datum/ambient_group/groups = new (MAX_AMBIENT_GROUP_INDEX)

	/// The number of ambient groups currently provisioned
	var/static/group_count = 0

	/// The index of the space ambient group, if one exists
	var/static/space_group_index = 0

	/// alist of overrides from z => ambient group index instead of the default rainbow one
	var/static/list/z_group_indices = list()

	/// Fifo queue of turfs that require an ambient lighting update
	var/static/list/turf/queue = list()


/datum/controller/subsystem/ambient_lighting/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..({"\
		Queue: [length(queue)] | \
		Groups: [group_count]/[MAX_AMBIENT_GROUP_INDEX] | \
		Space: [config.starlight ? (space_group_index < 0 ? "ERROR" : "OK") : "OFF"]\
	"})


/datum/controller/subsystem/ambient_lighting/Recover()
	queue = list()
	for (var/turf/turf)
		CLEAR_FLAGS(turf.turf_flags, TURF_AMBIENT_LIGHT_UPDATE_QUEUED)
		turf.ambient_active = FALSE


/datum/controller/subsystem/ambient_lighting/fire(resumed, no_mc_tick)
	var/queue_length = length(queue)
	if (!queue_length)
		return
	var/datum/ambient_group/space_group
	if (config.starlight)
		if (!space_group_index)
			space_group_index = create_group(SSskybox.background_color, config.starlight)
		else if (space_group_index > 0)
			space_group = groups[space_group_index]
	for (var/queue_index in 1 to queue_length)
		var/turf/turf = queue[queue_index]
		if (QDELETED(turf) || !GET_FLAGS(turf.turf_flags, TURF_AMBIENT_LIGHT_UPDATE_QUEUED))
			continue
		FLIP_FLAGS(turf.turf_flags, TURF_AMBIENT_LIGHT_UPDATE_QUEUED)
		if (turf.is_outside())
			var/needs_ambience = TURF_IS_DYNAMICALLY_LIT_UNSAFE(turf)
			if (!needs_ambience)
				for (var/turf/neighbour as anything in RANGE_TURFS(turf, 1))
					if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(neighbour))
						needs_ambience = TRUE
						break
			if (needs_ambience)
				var/obj/overmap/visitable/sector/exoplanet/exoplanet = map_sectors["[turf.z]"]
				var/z_group_index = z_group_indices["[turf.z]"]
				if (istype(exoplanet))
					if (exoplanet.ambient_group_index)
						groups[exoplanet.ambient_group_index]?.add_turf(turf)
				else if (z_group_index)
					groups[z_group_index]?.add_turf(turf)
				else
					space_group?.add_turf(turf)
		else if (turf.ambient_active && turf.ambient_group_flags)
			for (var/group_index in 1 to MAX_AMBIENT_GROUP_INDEX)
				groups[group_index]?.remove_turf(turf)
				if (!turf.ambient_group_flags)
					break
		if (no_mc_tick)
			if (queue_index % 100)
				continue
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, queue_index + 1)
			return
	LIST_RESIZE(queue, 0)


/// Set up an ambient group, returning its index or -1 if the pool is exhausted
/datum/controller/subsystem/ambient_lighting/proc/create_group(color, multiplier)
	if (free_group_flags)
		for (var/group_index in 1 to MAX_AMBIENT_GROUP_INDEX)
			if (!HAS_BIT(free_group_flags, group_index))
				continue
			CLEAR_BIT(free_group_flags, group_index)
			groups[group_index] = new /datum/ambient_group (color, multiplier, group_index)
			return group_index
	return -1


/// Removes turf from all ambient groups it is part of, if any
/datum/controller/subsystem/ambient_lighting/proc/clean_turf(turf/turf)
	if (!turf.ambient_group_flags)
		return
	for (var/datum/ambient_group/group as anything in groups)
		if (GET_FLAGS(turf.ambient_group_flags, group.group_flag))
			group.remove_turf(turf)
		if (!turf.ambient_group_flags)
			return


/datum/ambient_group
	/// The index of this group in SSambient_lighting.groups
	var/group_index

	/// The flag at position group_index; for turf.ambient_group_flags
	var/group_flag

	/** A sparse list(list(turf, ...),...). Inner list positions match world z levels and contain turfs
	of that z that are members of this group */
	var/list/member_turfs_by_z = list()

	/// Red channel illumination applied by this group. Do not modify directly - use group.set_color()
	var/apparent_r

	/// Green channel illumination applied by this group. Do not modify directly - use group.set_color()
	var/apparent_g

	/// Blue channel illumination applied by this group. Do not modify directly - use group.set_color()
	var/apparent_b

	/// Lock var. Prevents updates to group members while another update is already in progress
	var/busy = FALSE


/datum/ambient_group/Destroy()
	SSambient_lighting.groups[group_index] = null
	SSambient_lighting.free_group_flags |= group_flag
	--SSambient_lighting.group_count
	for (var/list/z_turfs in member_turfs_by_z)
		for (var/turf/turf as anything in z_turfs)
			CLEAR_FLAGS(turf.ambient_group_flags, group_flag)
	LAZYCLEARLIST(member_turfs_by_z)
	busy = FALSE
	return ..()


/datum/ambient_group/New(color, multiplier, index)
	group_index = index
	group_flag = RFLAG(index)
	++SSambient_lighting.group_count
	set_color(color, multiplier)


/datum/ambient_group/proc/set_color(color, multiplier)
	var/list/new_parts = rgb2num(color)
	var/delta_r = (new_parts[1] / 255) * multiplier - apparent_r
	var/delta_g = (new_parts[2] / 255) * multiplier - apparent_g
	var/delta_b = (new_parts[3] / 255) * multiplier - apparent_b
	if (delta_r / 4 < LIGHTING_ROUND_VALUE && delta_g / 4 < LIGHTING_ROUND_VALUE && delta_b / 4 < LIGHTING_ROUND_VALUE)
		return
	busy = TRUE
	for (var/list/z_turfs as anything in member_turfs_by_z)
		for (var/turf/turf as anything in z_turfs)
			turf.add_ambient_light_raw(delta_r, delta_g, delta_b)
			CHECK_TICK
	apparent_r += delta_r
	apparent_g += delta_g
	apparent_b += delta_b
	busy = FALSE


/// Adds group ambient light amounts to turf
/datum/ambient_group/proc/set_ambient_light(turf/turf)
	set waitfor = FALSE
	while (busy)
		stoplag()
	if (QDELETED(src))
		return
	turf.add_ambient_light_raw(apparent_r, apparent_g, apparent_b)


/// Removes group ambient light amounts from turf
/datum/ambient_group/proc/remove_ambient_light(turf/turf)
	set waitfor = FALSE
	while (busy)
		stoplag()
	if (QDELETED(src))
		return
	turf.add_ambient_light_raw(-apparent_r, -apparent_g, -apparent_b)


/// Adds turf to this group if not a member, setting flags and light
/datum/ambient_group/proc/add_turf(turf/turf)
	set waitfor = FALSE
	while (busy)
		stoplag()
	if (QDELETED(src))
		return
	if (GET_FLAGS(turf.ambient_group_flags, group_flag))
		return //Already a member
	var/turf_z = turf.z
	if (turf_z > length(member_turfs_by_z))
		LIST_RESIZE(member_turfs_by_z, turf_z)
	var/list/z_turfs = member_turfs_by_z[turf_z]
	if (!z_turfs)
		z_turfs = list()
		member_turfs_by_z[turf_z] = z_turfs
	z_turfs |= turf
	SET_FLAGS(turf.ambient_group_flags, group_flag)
	set_ambient_light(turf)


/// Removes turf from this group if a member, removing flags and light
/datum/ambient_group/proc/remove_turf(turf/turf)
	set waitfor = FALSE
	while (busy)
		stoplag()
	if (QDELETED(src))
		return
	if (!GET_FLAGS(turf.ambient_group_flags, group_flag))
		return
	if (turf.z > length(member_turfs_by_z))
		CRASH("Attempt to remove member turf with Z greater than local max -- this turf is not a member")
	remove_ambient_light(turf)
	CLEAR_FLAGS(turf.ambient_group_flags, group_flag)
	member_turfs_by_z[turf.z] -= turf


#undef MAX_AMBIENT_GROUP_INDEX
