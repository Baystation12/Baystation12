#define OPENTURF_MAX_PLANE -70
#define OPENTURF_MAX_DEPTH 10		// The maxiumum number of planes deep we'll go before we just dump everything on the same plane.
#define SHADOWER_DARKENING_FACTOR 0.6	// The multiplication factor for openturf shadower darkness. Lighting will be multiplied by this.

SUBSYSTEM_DEF(zcopy)
	name = "Z-Copy"
	wait = 1
	init_order = SS_INIT_ZCOPY
	priority = SS_PRIORITY_ZCOPY
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/queued_turfs = list()
	var/qt_idex = 1
	var/list/queued_overlays = list()
	var/qo_idex = 1

	var/openspace_overlays = 0
	var/openspace_turfs = 0

// for admin proc-call
/datum/controller/subsystem/zcopy/proc/update_all()
	disable()
	log_debug("SSzcopy: update_all() invoked.")

	var/turf/T 	// putting the declaration up here totally speeds it up, right?
	var/num_upd = 0
	var/num_del = 0
	var/num_amupd = 0
	for (var/atom/A in world)
		if (isturf(A))
			T = A
			if (T.z_flags & ZM_MIMIC_BELOW)
				T.update_mimic()
				num_upd += 1

		else if (istype(A, /atom/movable/openspace/overlay))
			var/turf/Tloc = A.loc
			if (TURF_IS_MIMICING(Tloc))
				Tloc.update_mimic()
				num_amupd += 1
			else
				qdel(A)
				num_del += 1

		CHECK_TICK

	log_debug("SSzcopy: [num_upd + num_amupd] turf updates queued ([num_upd] direct, [num_amupd] indirect), [num_del] orphans destroyed.")

	enable()

// for admin proc-call
/datum/controller/subsystem/zcopy/proc/hard_reset()
	disable()
	log_debug("SSzcopy: hard_reset() invoked.")
	var/num_deleted = 0
	var/num_turfs = 0

	var/turf/T
	for (var/atom/A in world)
		if (isturf(A))
			T = A
			if (T.z_flags & ZM_MIMIC_BELOW)
				T.update_mimic()
				num_turfs += 1

		else if (istype(A, /atom/movable/openspace/overlay))
			qdel(A)
			num_deleted += 1

		CHECK_TICK

	log_debug("SSzcopy: deleted [num_deleted] overlays, and queued [num_turfs] turfs for update.")

	enable()

/datum/controller/subsystem/zcopy/stat_entry()
	..("Q:{T:[queued_turfs.len - (qt_idex - 1)]|O:[queued_overlays.len - (qo_idex - 1)]} T:{T:[openspace_turfs]|O:[openspace_overlays]}")

/datum/controller/subsystem/zcopy/Initialize(timeofday)
	// Flush the queue.
	fire(FALSE, TRUE)
	return ..()

/datum/controller/subsystem/zcopy/fire(resumed = FALSE, no_mc_tick = FALSE)
	if (!resumed)
		qt_idex = 1
		qo_idex = 1

	MC_SPLIT_TICK_INIT(2)
	if (!no_mc_tick)
		MC_SPLIT_TICK

	var/list/curr_turfs = queued_turfs
	var/list/curr_ov = queued_overlays

	while (qt_idex <= curr_turfs.len)
		var/turf/T = curr_turfs[qt_idex]
		curr_turfs[qt_idex] = null
		qt_idex += 1

		if (!isturf(T) || !T.below || !(T.z_flags & ZM_MIMIC_BELOW))
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		if (!T.shadower)	// If we don't have a shadower yet, something has gone horribly wrong.
			WARNING("Turf [T] at [T.x],[T.y],[T.z] was queued, but had no shadower.")
			continue

		// Figure out how many z-levels down we are.
		var/depth = 0
		var/turf/Td = T

		while (Td.below)
			Td = Td.below
			depth += 1

		if (depth > OPENTURF_MAX_DEPTH)
			depth = OPENTURF_MAX_DEPTH

		var/t_target = OPENTURF_MAX_PLANE - depth	// this is where the openturf gets put

		// Handle space parallax.
		if (T.below.z_eventually_space)
			T.z_eventually_space = TRUE
			t_target = SPACE_PLANE

		if (!(T.z_flags & ZM_MIMIC_OVERWRITE))
			// Some openturfs have icons, so we can't overwrite their appearance.
			if (!T.below.bound_overlay)
				T.below.bound_overlay = new(T)
			var/atom/movable/openspace/turf_overlay/TO = T.below.bound_overlay
			TO.appearance = T.below
			TO.name = T.name
			TO.gender = T.gender	// Need to grab this too so PLURAL works properly in examine.
			TO.opacity = FALSE
			TO.plane = t_target
		else
			// This openturf doesn't care about its icon, so we can just overwrite it.
			if (T.below.bound_overlay)
				QDEL_NULL(T.below.bound_overlay)
			T.appearance = T.below
			T.name = initial(T.name)
			T.desc = initial(T.desc)
			T.gender = NEUTER
			T.opacity = FALSE
			T.plane = t_target

		T.queue_ao()

		// Add everything below us to the update queue.
		for (var/thing in T.below)
			var/atom/movable/object = thing
			if (QDELETED(object) || object.no_z_overlay || object.loc != T.below || object.invisibility == INVISIBILITY_ABSTRACT)
				// Don't queue deleted stuff, stuff that's not visible, blacklisted stuff, or stuff that's centered on another tile but intersects ours.
				continue

			// Special case: these are merged into the shadower to reduce memory usage.
			if (object.type == /atom/movable/lighting_overlay)
				// T.shadower.copy_lighting(object)
			else
				if (!object.bound_overlay)	// Generate a new overlay if the atom doesn't already have one.
					object.bound_overlay = new(T)
					object.bound_overlay.associated_atom = object

				var/target_depth = depth
				var/original_type = object.type
				if (object.type == /atom/movable/openspace/overlay)
					var/atom/movable/openspace/overlay/OOO = object
					target_depth = OOO.depth
					original_type = OOO.mimiced_type

				var/atom/movable/openspace/overlay/OO = object.bound_overlay

				// If the OO was queued for destruction but was claimed by another OT, stop the destruction timer.
				if (OO.destruction_timer)
					deltimer(OO.destruction_timer)
					OO.destruction_timer = null

				OO.depth = target_depth
				OO.mimiced_type = original_type

				if (!OO.queued)
					OO.queued = TRUE
					queued_overlays += OO

		T.z_queued -= 1
		if (!no_mc_tick && T.above)
			T.above.update_mimic()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (qt_idex > 1)
		curr_turfs.Cut(1, qt_idex)
		qt_idex = 1

	if (!no_mc_tick)
		MC_SPLIT_TICK

	while (qo_idex <= curr_ov.len)
		var/atom/movable/openspace/overlay/OO = curr_ov[qo_idex]
		curr_ov[qo_idex] = null
		qo_idex += 1

		if (QDELETED(OO))
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		if (QDELETED(OO.associated_atom))	// This shouldn't happen, but just in-case.
			qdel(OO)

			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		// Actually update the overlay.
		OO.dir = OO.associated_atom.dir
		OO.appearance = OO.associated_atom
		OO.plane = OPENTURF_MAX_PLANE - OO.depth

		OO.opacity = FALSE
		OO.queued = FALSE

		if (OO.bound_overlay)	// If we have a bound overlay, queue it too.
			OO.update_above()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (qo_idex > 1)
		curr_ov.Cut(1, qo_idex)
		qo_idex = 1

/client/proc/analyze_openturf(turf/T)
	set name = "Analyze Openturf"
	set desc = "Show the layering of an openturf and everything it's mimicking."
	set category = "Debug"

	if (!check_rights(R_DEBUG))
		return

	var/list/out = list(
		"<h1>Analysis of [T] at [T.x],[T.y],[T.z]</h1>",
		"<b>Queue occurrences:</b> [T.z_queued]",
		"<b>Above space:</b> [T.is_above_space() ? "Yes" : "No"]",
		"<b>Z Flags</b>: [english_list(bitfield2list(T.z_flags, global.mimic_defines), "(none)")]",
		"<b>Has Shadower:</b> [T.shadower ? "Yes" : "No"]",
		"<b>Below:</b> [!T.below ? "(nothing)" : "[T.below] at [T.below.x],[T.below.y],[T.below.z]"]",
		"<ul>"
	)

	var/list/found_oo = list(T)
	for (var/thing in T)
		if (istype(thing, /atom/movable/openspace))
			found_oo += thing

	var/turf/Td = T
	while (Td.below)
		Td = Td.below
		found_oo += Td

	sortTim(found_oo, /proc/cmp_planelayer)
	for (var/thing in found_oo)
		var/atom/A = thing
		if (istype(A, /atom/movable/openspace/overlay))
			var/atom/movable/openspace/overlay/OO = A
			var/atom/movable/AA = OO.associated_atom
			out += "<li>\icon[A] plane [A.plane], layer [A.layer], depth [OO.depth], associated Z-level [AA.z] - [OO.type] copying [AA] ([AA.type], eventually [OO.mimiced_type])</li>"
		else if (isturf(A))
			if (A == T)
				out += "<li>\icon[A] plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type]) - <font color='green'>SELF</font></li>"
			else	// foreign turfs - not visible here, but good for figuring out layering
				out += "<li>\icon[A] plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type]) - <font color='red'>FOREIGN</font></li>"
		else
			out += "<li>\icon[A] plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type])</li>"

	out += "</ul>"

	show_browser(usr, out.Join("<br>"), "size=980x580;window=openturfanalysis-\ref[T]")
