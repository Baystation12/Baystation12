#define OPENTURF_MAX_PLANE -70
#define OPENTURF_MAX_DEPTH 10		// The maxiumum number of planes deep we'll go before we just dump everything on the same plane.
#define SHADOWER_DARKENING_FACTOR 0.6	// The multiplication factor for openturf shadower darkness. Lighting will be multiplied by this.
#define SHADOWER_DARKENING_COLOR "#999999"	// The above, but as an RGB string for lighting-less turfs.

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

	// Highest Z level in a given Z-group for absolute layering used by FIX_BIGTURF.
	// zstm[zlev] = group_max
	var/list/zlev_maximums = list()

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
	calculate_zstack_limits()
	// Flush the queue.
	fire(FALSE, TRUE)
	return ..()

// If you add a new Zlevel or change Z-connections, call this.
/datum/controller/subsystem/zcopy/proc/calculate_zstack_limits()
	zlev_maximums = new(world.maxz)
	var/start_zlev = 1
	for (var/z in 1 to world.maxz)
		if (!HasAbove(z))
			for (var/member_zlev in start_zlev to z)
				zlev_maximums[member_zlev] = z
			if (z - start_zlev > OPENTURF_MAX_DEPTH)
				log_ss("zcopy", "WARNING: Z-levels [start_zlev] through [z] exceed maximum depth of [OPENTURF_MAX_DEPTH]; layering may behave strangely in this Z-stack.")
			else if (z - start_zlev > 1)
				log_ss("zcopy", "Found Z-Stack: [start_zlev] -> [z] = [z - start_zlev] zl")
			start_zlev = z + 1

	log_ss("zcopy", "Z-Level maximums: [json_encode(zlev_maximums)]")

/datum/controller/subsystem/zcopy/StartLoadingMap()
	suspend()

/datum/controller/subsystem/zcopy/StopLoadingMap()
	wake()

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

		if (!isturf(T) || !T.below || !(T.z_flags & ZM_MIMIC_BELOW) || !T.z_queued)
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		// If we're not at our most recent queue position, don't bother -- we're updating again later anyways.
		if (T.z_queued > 1)
			T.z_queued -= 1
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				return
			continue

		if (!T.shadower)	// If we don't have a shadower yet, something has gone horribly wrong.
			WARNING("Turf [T] at [T.x],[T.y],[T.z] was queued, but had no shadower.")
			continue

		// Get the bottom-most turf, the one we want to mimic.
		var/turf/Td = T
		while (Td.below)
			Td = Td.below

		// Depth must be the depth of the *visible* turf, not self.
		var/turf_depth
		turf_depth = T.z_depth = zlev_maximums[Td.z] - Td.z

		var/t_target = OPENTURF_MAX_PLANE - turf_depth	// This is where the turf (but not the copied atoms) gets put.

		// Handle space parallax & starlight.
		if (T.below.z_eventually_space)
			T.z_eventually_space = TRUE
			t_target = SPACE_PLANE

		if (T.below.z_flags & ZM_FIX_BIGTURF)
			T.z_flags |= ZM_FIX_BIGTURF	// this flag is infectious

		if (T.z_flags & ZM_MIMIC_OVERWRITE)
			// This openturf doesn't care about its icon, so we can just overwrite it.
			if (T.below.bound_overlay)
				QDEL_NULL(T.below.bound_overlay)
			T.appearance = T.below
			T.name = initial(T.name)
			T.desc = initial(T.desc)
			T.gender = initial(T.gender)
			T.opacity = FALSE
			T.plane = t_target
		else
			// Some openturfs have icons, so we can't overwrite their appearance.
			if (!T.below.bound_overlay)
				T.below.bound_overlay = new(T)
			var/atom/movable/openspace/turf_delegate/TO = T.below.bound_overlay
			TO.appearance = Td
			TO.name = T.name
			TO.gender = T.gender	// Need to grab this too so PLURAL works properly in examine.
			TO.opacity = FALSE
			TO.plane = t_target
			TO.mouse_opacity = initial(TO.mouse_opacity)

		T.queue_ao(T.ao_neighbors_mimic == null)	// If ao_neighbors hasn't been set yet, we need to do a rebuild

		// Explicitly copy turf delegates so they show up properly on below levels.
		//   I think it's possible to get this to work without discrete delegate copy objects, but I'd rather this just work.
		if ((T.below.z_flags & (ZM_MIMIC_BELOW|ZM_MIMIC_OVERWRITE)) == ZM_MIMIC_BELOW)
			// Below is a delegate, gotta explicitly copy it for recursive copy.
			if (!T.below.z_delegate)
				T.below.z_delegate = new(T)
			var/atom/movable/openspace/delegate_copy/DC = T.below.z_delegate
			DC.appearance = T.below
			DC.mouse_opacity = initial(DC.mouse_opacity)
			DC.plane = OPENTURF_MAX_PLANE

		else if (T.below.z_delegate)
			QDEL_NULL(T.below.z_delegate)

		// Handle below atoms.

		// Add everything below us to the update queue.
		for (var/thing in T.below)
			var/atom/movable/object = thing
			if (QDELETED(object) || object.no_z_overlay || object.loc != T.below || object.invisibility == INVISIBILITY_ABSTRACT)
				// Don't queue deleted stuff, stuff that's not visible, blacklisted stuff, or stuff that's centered on another tile but intersects ours.
				continue

			// Special case: these are merged into the shadower to reduce memory usage.
			if (object.type == /atom/movable/lighting_overlay)
				// 	T.shadower.copy_lighting(object)
			else
				if (!object.bound_overlay)	// Generate a new overlay if the atom doesn't already have one.
					object.bound_overlay = new(T)
					object.bound_overlay.associated_atom = object

				var/override_depth
				var/original_type = object.type
				var/original_z = object.z
				switch (object.type)
					if (/atom/movable/openspace/overlay)
						var/atom/movable/openspace/overlay/OOO = object
						original_type = OOO.mimiced_type
						override_depth = OOO.override_depth
						original_z = OOO.original_z

					if (/atom/movable/openspace/turf_delegate, /atom/movable/openspace/delegate_copy)
						// If we're a turf overlay (the mimic for a non-OVERWRITE turf), we need to make sure copies of us respect space parallax too
						if (T.z_eventually_space)
							// Yes, this is an awful hack; I don't want to add yet another override_* var.
							override_depth = OPENTURF_MAX_PLANE - SPACE_PLANE

				if ((T.z_flags & ZM_FIX_BIGTURF) && original_type == /atom/movable/openspace/multiplier)
					override_depth = turf_depth

				var/atom/movable/openspace/overlay/OO = object.bound_overlay

				// If the OO was queued for destruction but was claimed by another OT, stop the destruction timer.
				if (OO.destruction_timer)
					deltimer(OO.destruction_timer)
					OO.destruction_timer = null

				OO.depth = override_depth || min(T.z - original_z, OPENTURF_MAX_DEPTH)
				OO.mimiced_type = original_type
				OO.override_depth = override_depth
				OO.original_z = original_z

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
		if (OO.dir != OO.associated_atom.dir)
			OO.set_dir(OO.associated_atom.dir)

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

#define FMT_DEPTH(X) (X == null ? "(null)" : X)

/client/proc/analyze_openturf(turf/T)
	set name = "Analyze Openturf"
	set desc = "Show the layering of an openturf and everything it's mimicking."
	set category = "Debug"

	if (!check_rights(R_DEBUG))
		return

	var/list/out = list(
		"<head><meta charset='utf-8'/></head><body>",
		"<h1>Analysis of [T] at [T.x],[T.y],[T.z]</h1>",
		"<b>Queue occurrences:</b> [T.z_queued]",
		"<b>Above space:</b> Apparent [T.z_eventually_space ? "Yes" : "No"], Actual [T.is_above_space() ? "Yes" : "No"]",
		"<b>Z Flags</b>: [english_list(bitfield2list(T.z_flags, global.mimic_defines), "(none)")]",
		"<b>Has Shadower:</b> [T.shadower ? "Yes" : "No"]",
		"<b>Below:</b> [!T.below ? "(nothing)" : "[T.below] at [T.below.x],[T.below.y],[T.below.z]"]",
		"<b>Depth:</b> [FMT_DEPTH(T.z_depth)] [T.z_depth == OPENTURF_MAX_DEPTH ? "(max)" : ""]",
		"<ul>"
	)

	var/list/found_oo = list(T)
	for (var/atom/movable/openspace/O in T)
		found_oo += O

	sortTim(found_oo, /proc/cmp_planelayer)

	var/list/atoms_list_list = list()
	for (var/thing in found_oo)
		var/atom/A = thing
		var/pl = "[A.plane]"
		LAZYINITLIST(atoms_list_list[pl])
		atoms_list_list[pl] += A

	if (atoms_list_list["0"])
		out += "<strong>Non-Z</strong>"
		SSzcopy.debug_fmt_planelist(atoms_list_list["0"], out, T)

		atoms_list_list -= "0"

	for (var/d in 0 to OPENTURF_MAX_DEPTH)
		var/pl = OPENTURF_MAX_PLANE - d
		if (!atoms_list_list["[pl]"])
			out += "<strong>Depth [d], plane [pl] - empty</strong>"
			continue

		out += "<strong>Depth [d], plane [pl]</strong>"
		SSzcopy.debug_fmt_planelist(atoms_list_list["[pl]"], out, T)

		// Flush the list so we can find orphans.
		atoms_list_list -= "[pl]"

	log_debug("atoms_list_list => [json_encode(atoms_list_list)]")
	for (var/key in atoms_list_list)
		out += "<strong style='color: red;'>Unknown plane: [key]</strong>"
		SSzcopy.debug_fmt_planelist(atoms_list_list[key], out, T)

		out += "<hr/>"

	out += "</body>"

	show_browser(usr, out.Join("<br>"), "size=980x580;window=openturfanalysis-\ref[T]")

// Yes, I know this proc is a bit of a mess. Feel free to clean it up.
/datum/controller/subsystem/zcopy/proc/debug_fmt_thing(atom/A, list/out, turf/original)
	if (istype(A, /atom/movable/openspace/overlay))
		var/atom/movable/openspace/overlay/OO = A
		var/atom/movable/AA = OO.associated_atom
		var/copied_type = AA.type == OO.mimiced_type ? "[AA.type] \[direct\]" : "[AA.type], eventually [OO.mimiced_type]"
		return "<li>\icon[A] <b>\[Mimic\]</b> plane [A.plane], layer [A.layer], depth [FMT_DEPTH(OO.depth)], associated Z-level [AA.z] - [OO.type] copying [AA] ([copied_type])</li>"
	else if (istype(A, /atom/movable/openspace/delegate_copy))
		var/atom/movable/openspace/delegate_copy/DC = A
		return "<li>\icon[A] <b>\[Turf Delegate Copy\]</b> plane [A.plane], layer [A.layer], Z-level [A.z], delegate of \icon[DC.delegate] [DC.delegate] ([DC.delegate.type])</li>"
	else if (isturf(A))
		if (A == original)
			return "<li>\icon[A] <b>\[Turf\]</b> plane [A.plane], layer [A.layer], depth [FMT_DEPTH(A:z_depth)], Z-level [A.z] - [A] ([A.type]) - <font color='green'>SELF</font></li>"
		else	// foreign turfs - not visible here, but sometimes good for figuring out layering -- showing these is currently not enabled
			return "<li>\icon[A] <b>\[Turf\]</b> <em><font color='#646464'>plane [A.plane], layer [A.layer], depth [FMT_DEPTH(A:z_depth)], Z-level [A.z] - [A] ([A.type])</font></em> - <font color='red'>FOREIGN</font></em></li>"
	else if (A.type == /atom/movable/openspace/multiplier)
		return "<li>\icon[A] <b>\[Shadower\]</b> plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type])</li>"
	else if (A.type == /atom/movable/openspace/turf_delegate)
		return "<li>\icon[A] <b>\[Turf Delegate (Mimic)\]</b> plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type])</li>"
	else
		return "<li>\icon[A] <b>\[?\]</b>  plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type])</li>"

/datum/controller/subsystem/zcopy/proc/debug_fmt_planelist(list/things, list/out, turf/original)
	if (things)
		out += "<ul>"
		for (var/thing in things)
			out += debug_fmt_thing(thing, out, original)
		out += "</ul>"
	else
		out += "<em>No atoms.</em>"

#undef FMT_DEPTH
