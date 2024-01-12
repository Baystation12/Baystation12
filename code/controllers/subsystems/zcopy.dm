#define SHADOWER_DARKENING_FACTOR 0.8	// The multiplication factor for openturf shadower darkness. Lighting will be multiplied by this.
#define SHADOWER_DARKENING_COLOR "#00000033"	// The above, but as an RGB string for lighting-less turfs.
//Bay can't do multiplicative lighting for zmimic currently so we change alpha, this does mean full lit turfs need a different colour. TODO: Take another look at zmimic render setup

SUBSYSTEM_DEF(zcopy)
	name = "Z-Copy"
	wait = 1
	init_order = SS_INIT_ZCOPY
	priority = SS_PRIORITY_ZCOPY
	runlevels = RUNLEVELS_PREGAME | RUNLEVELS_GAME

	var/list/queued_turfs = list()
	var/qt_idex = 1
	var/list/queued_overlays = list()
	var/qo_idex = 1

	var/openspace_overlays = 0
	var/openspace_turfs = 0

	var/multiqueue_skips_turf = 0
	var/multiqueue_skips_object = 0

	// Caches for fixup.
	var/list/fixup_cache = list()
	var/list/fixup_known_good = list()

	// Fixup stats.
	var/fixup_miss = 0
	var/fixup_noop = 0
	var/fixup_hit = 0

	// Highest Z level in a given Z-group for absolute layering.
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

		else if (istype(A, /atom/movable/openspace/mimic))
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

		else if (istype(A, /atom/movable/openspace/mimic))
			qdel(A)
			num_deleted += 1

		CHECK_TICK

	log_debug("SSzcopy: deleted [num_deleted] overlays, and queued [num_turfs] turfs for update.")

	enable()

/datum/controller/subsystem/zcopy/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..({"\
		Mx: [json_encode(zlev_maximums)]\n\
		Queues: \
		Turfs [length(queued_turfs) - (qt_idex - 1)] \
		Overlays [length(queued_overlays) - (qo_idex - 1)]\n\
		Open Turfs: \
		Turfs [openspace_turfs] \
		Overlays [openspace_overlays]\n\
		Skips: \
		Turfs [multiqueue_skips_turf] \
		Objects [multiqueue_skips_object]\
		Fixups: \
		Hits [fixup_hit] \
		Miss [fixup_miss]\
		No Operation [fixup_noop]\
	"})

/datum/controller/subsystem/zcopy/Initialize(start_uptime)
	calculate_zstack_limits()
	// Flush the queue.
	fire(FALSE, TRUE)

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
				log_ss("zcopy", "Found Z-Stack: [start_zlev] -> [z] = [z - start_zlev + 1] zl")
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

	while (qt_idex <= length(curr_turfs))
		var/turf/T = curr_turfs[qt_idex]
		curr_turfs[qt_idex] = null
		qt_idex += 1

		if (!isturf(T) || !(T.z_flags & ZM_MIMIC_BELOW) || !T.z_queued)
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		// If we're not at our most recent queue position, don't bother -- we're updating again later anyways.
		if (T.z_queued > 1)
			T.z_queued -= 1
			multiqueue_skips_turf += 1
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		// Z-Turf on the bottom-most level, just fake-copy space.
		// If this is ever true, that turf should always pass this condition, so don't bother cleaning up beyond the Destroy() hook.
		if (!T.below)	// Z-turf on the bottom-most level, just fake-copy space.
			flush_z_state(T)
			if(T.z_flags & ZM_MIMIC_BASETURF)
				simple_appearance_copy(T, get_base_turf_by_area(T), OPENTURF_MAX_PLANE)
			else
				simple_appearance_copy(T, SSskybox.space_appearance_cache[(((T.x + T.y) ^ ~(T.x * T.y) + T.z) % 25) + 1])

			T.z_generation += 1
			T.z_queued -= 1

			if (T.above)
				T.above.update_mimic()

			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		if (!T.shadower)	// If we don't have a shadower yet, something has gone horribly wrong.
			WARNING("Turf [T] at [T.x],[T.y],[T.z] was queued, but had no shadower.")
			continue

		T.z_generation += 1

		// Get the bottom-most turf, the one we want to mimic.
		var/turf/Td = T
		while (Td.below)
			Td = Td.below

		// Debug checking for #32286 - https://github.com/Baystation12/Baystation12/issues/32286
		if (Td.z > length(zlev_maximums))
			crash_with("zcopy hit a z-level not included in zlev_maximums: [Td.z] - Maximum z-level: [length(zlev_maximums)] - Source turf: [Td] ([Td.type]) in [get_area(Td)] ([Td.x], [Td.y], [Td.z]).")
			continue // Prevents the subsystem from halting on the next line

		// Depth must be the depth of the *visible* turf, not self.
		var/turf_depth
		turf_depth = T.z_depth = zlev_maximums[Td.z] - Td.z

		var/t_target = OPENTURF_MAX_PLANE - turf_depth	// This is where the turf (but not the copied atoms) gets put.

		// Turf is set to mimic baseturf, handle that and bail.
		if (T.z_flags & ZM_MIMIC_BASETURF)
			flush_z_state(T)
			simple_appearance_copy(T, get_base_turf_by_area(T), t_target)

			if (T.above)
				T.above.update_mimic()

			T.z_queued -= 1

			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		// If we previously were MZ_MIMIC_BASETURF, there might be an orphaned proxy.
		else if (T.mimic_underlay)
			QDEL_NULL(T.mimic_underlay)

		// Handle space parallax & starlight.
		if (T.below.z_eventually_space)
			T.z_eventually_space = TRUE
			if ((T.below.z_flags & ZM_MIMIC_OVERWRITE) || T.below.type == /turf/space)
				t_target = SPACE_PLANE

		if (T.z_flags & ZM_MIMIC_OVERWRITE)
			// This openturf doesn't care about its icon, so we can just overwrite it.
			if (T.below.mimic_proxy)
				QDEL_NULL(T.below.mimic_proxy)
			T.appearance = T.below
			T.name = initial(T.name)
			T.desc = initial(T.desc)
			T.gender = initial(T.gender)
			T.opacity = FALSE
			T.plane = t_target
		else
			// Some openturfs have icons, so we can't overwrite their appearance.
			if (!T.below.mimic_proxy)
				T.below.mimic_proxy = new(T)
			var/atom/movable/openspace/turf_proxy/TO = T.below.mimic_proxy
			TO.appearance = Td
			TO.name = T.name
			TO.gender = T.gender	// Need to grab this too so PLURAL works properly in examine.
			TO.opacity = FALSE
			TO.plane = t_target
			TO.mouse_opacity = initial(TO.mouse_opacity)

		T.queue_ao(isnull(T.ao_neighbors_mimic))	// If ao_neighbors hasn't been set yet, we need to do a rebuild

		// Explicitly copy turf delegates so they show up properly on below levels.
		//   I think it's possible to get this to work without discrete delegate copy objects, but I'd rather this just work.
		if ((T.below.z_flags & (ZM_MIMIC_BELOW|ZM_MIMIC_OVERWRITE)) == ZM_MIMIC_BELOW)
			// Below is a delegate, gotta explicitly copy it for recursive copy.
			if (!T.below.mimic_above_copy)
				T.below.mimic_above_copy = new(T)
			var/atom/movable/openspace/turf_mimic/DC = T.below.mimic_above_copy
			DC.appearance = T.below
			DC.mouse_opacity = initial(DC.mouse_opacity)
			DC.plane = OPENTURF_MAX_PLANE - turf_depth - 1

		else if (T.below.mimic_above_copy)
			QDEL_NULL(T.below.mimic_above_copy)

		// Handle below atoms.

		// Add everything below us to the update queue.
		for (var/thing in T.below)
			var/atom/movable/object = thing
			if (QDELETED(object) || (object.z_flags & ZMM_IGNORE) || object.loc != T.below || object.loc != T.below || object.invisibility == INVISIBILITY_ABSTRACT)
				// Don't queue deleted stuff, stuff that's not visible, blacklisted stuff, or stuff that's centered on another tile but intersects ours.
				continue

			// Special case: these are merged into the shadower to reduce memory usage.
			if (object.type == /atom/movable/lighting_overlay)
				T.shadower.copy_lighting(object)
				continue

			if (!object.bound_overlay)	// Generate a new overlay if the atom doesn't already have one.
				object.bound_overlay = new(T)
				object.bound_overlay.associated_atom = object

			var/override_depth
			var/original_type = object.type
			var/original_z = object.z
			var/have_performed_fixup = FALSE

			switch (object.type)
				// Layering for recursive mimic needs to be inherited.
				if (/atom/movable/openspace/mimic)
					var/atom/movable/openspace/mimic/OOO = object
					original_type = OOO.mimiced_type
					override_depth = OOO.override_depth
					original_z = OOO.original_z
					have_performed_fixup = OOO.have_performed_fixup

				if (/atom/movable/openspace/turf_proxy, /atom/movable/openspace/turf_mimic)
					// If we're a turf overlay (the mimic for a non-OVERWRITE turf), we need to make sure copies of us respect space parallax too
					if (T.z_eventually_space)
						// Yes, this is an awful hack; I don't want to add yet another override_* var.
						override_depth = OPENTURF_MAX_PLANE - SPACE_PLANE

				if (/atom/movable/openspace/turf_mimic)
					original_z += 1

			var/atom/movable/openspace/mimic/OO = object.bound_overlay

			// If the OO was queued for destruction but was claimed by another OT, stop the destruction timer.
			if (OO.destruction_timer)
				deltimer(OO.destruction_timer)
				OO.destruction_timer = null

			OO.depth = override_depth || min(zlev_maximums[T.z] - original_z, OPENTURF_MAX_DEPTH)

			// These types need to be pushed a layer down for bigturfs to function correctly.
			switch (original_type)
				if (/atom/movable/openspace/multiplier, /atom/movable/openspace/turf_mimic, /atom/movable/openspace/turf_proxy)
					if (OO.depth < OPENTURF_MAX_DEPTH)
						OO.depth += 1

			OO.mimiced_type = original_type
			OO.override_depth = override_depth
			OO.original_z = original_z
			OO.have_performed_fixup ||= have_performed_fixup

			// Multi-queue to maintain ordering of updates to these
			//   queueing it multiple times will result in only the most recent
			//   actually processing.
			OO.queued += 1
			queued_overlays += OO

		T.z_queued -= 1
		if (T.above)
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

	while (qo_idex <= length(curr_ov))
		var/atom/movable/openspace/mimic/OO = curr_ov[qo_idex]
		curr_ov[qo_idex] = null
		qo_idex += 1

		if (QDELETED(OO) || !OO.queued)
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

		// Don't update unless we're at the most recent queue occurrence.
		if (OO.queued > 1)
			OO.queued -= 1
			multiqueue_skips_object += 1
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		// Actually update the overlay.
		if (OO.dir != OO.associated_atom.dir)
			OO.set_dir(OO.associated_atom.dir)

		OO.appearance = OO.associated_atom
		OO.z_flags = OO.associated_atom.z_flags
		OO.plane = OPENTURF_MAX_PLANE - OO.depth

		OO.opacity = FALSE
		OO.queued = 0

		// If an atom has explicit plane sets on its overlays/underlays, we need to replace the appearance so they can be mangled to work with our planing.
		if (OO.z_flags & ZMM_MANGLE_PLANES)
			var/new_appearance = fixup_appearance_planes(OO.appearance)
			if (new_appearance)
				OO.appearance = new_appearance
				OO.have_performed_fixup = TRUE

		if (OO.bound_overlay)	// If we have a bound overlay, queue it too.
			OO.update_above()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (qo_idex > 1)
		curr_ov.Cut(1, qo_idex)
		qo_idex = 1

/datum/controller/subsystem/zcopy/proc/flush_z_state(turf/T)
	if (T.below) // Z-Mimic turfs aren't necessarily above another turf.
		if (T.below.mimic_above_copy)
			QDEL_NULL(T.below.mimic_above_copy)
		if (T.below.mimic_proxy)
			QDEL_NULL(T.below.mimic_proxy)
	QDEL_NULL(T.mimic_underlay)
	for (var/atom/movable/openspace/mimic/OO in T)
		qdel(OO)

/datum/controller/subsystem/zcopy/proc/simple_appearance_copy(turf/T, new_appearance, target_plane)
	if (T.z_flags & ZM_MIMIC_OVERWRITE)
		T.appearance = new_appearance
		T.name = initial(T.name)
		T.desc = initial(T.desc)
		T.gender = initial(T.gender)
		if (T.plane == 0 && target_plane)
			T.plane = target_plane
	else
		// Some openturfs have icons, so we can't overwrite their appearance.
		if (!T.mimic_underlay)
			T.mimic_underlay = new(T)
		var/atom/movable/openspace/turf_proxy/TO = T.mimic_underlay
		TO.appearance = new_appearance
		TO.name = T.name
		TO.gender = T.gender // Need to grab this too so PLURAL works properly in examine.
		TO.mouse_opacity = initial(TO.mouse_opacity)
		if (TO.plane == 0 && target_plane)
			TO.plane = target_plane

/// Generate a new appearance from `appearance` with planes mangled to work with Z-Mimic. Do not pass a depth.
/datum/controller/subsystem/zcopy/proc/fixup_appearance_planes(appearance, depth = 0)

	// Adding this to guard against a reported runtime - supposed to be impossible, so cause is unclear.
	if(!appearance)
		return null

	if (fixup_known_good[appearance])
		fixup_hit += 1
		return null
	if (fixup_cache[appearance])
		fixup_hit += 1
		return fixup_cache[appearance]

	// If you have more than 4 layers of overlays within overlays, I dunno what to say.
	if (depth > 4)
		var/icon_name = "[appearance:icon]"
		WARNING("Fixup of appearance with icon [icon_name || "<unknown file>"] exceeded maximum recursion limit, bailing")
		return null

	var/plane_needs_fix = FALSE

	// Don't fixup the root object's plane.
	if (depth > 0)
		switch (appearance:plane)
			if (DEFAULT_PLANE, FLOAT_PLANE)
				// fine
			else
				plane_needs_fix = TRUE

	// Scan & fix overlays
	var/list/fixed_overlays
	if (appearance:overlays:len)
		var/mutated = FALSE
		var/fixed_appearance
		for (var/i in 1 to appearance:overlays:len)
			if ((fixed_appearance = .(appearance:overlays[i], depth + 1)))
				mutated = TRUE
				if (!fixed_overlays)
					fixed_overlays = new( length(appearance:overlays))
				fixed_overlays[i] = fixed_appearance

		if (mutated)
			for (var/i in 1 to length(fixed_overlays))
				if (fixed_overlays[i] == null)
					fixed_overlays[i] = appearance:overlays[i]

	// Scan & fix underlays
	var/list/fixed_underlays
	if (appearance:underlays:len)
		var/mutated = FALSE
		var/fixed_appearance
		for (var/i in 1 to appearance:underlays:len)
			if ((fixed_appearance = .(appearance:underlays[i], depth + 1)))
				mutated = TRUE
				if (!fixed_underlays)
					fixed_underlays = new( length(appearance:underlays))
				fixed_underlays[i] = fixed_appearance

		if (mutated)
			for (var/i in 1 to  length(fixed_overlays))
				if (fixed_underlays[i] == null)
					fixed_underlays[i] = appearance:underlays[i]

	// If we did nothing (no violations), don't bother creating a new appearance
	if (!plane_needs_fix && !fixed_overlays && !fixed_underlays)
		fixup_noop += 1
		fixup_known_good[appearance] = TRUE
		return null

	fixup_miss += 1

	var/mutable_appearance/MA = new(appearance)
	if (plane_needs_fix)
		MA.plane = depth == 0 ? DEFAULT_PLANE : FLOAT_PLANE
		MA.layer = FLY_LAYER	// probably fine

	if (fixed_overlays)
		MA.AddOverlays(fixed_overlays)

	if (fixed_underlays)
		MA.underlays = fixed_underlays

	fixup_cache[appearance] = MA.appearance

	return MA

#define FMT_DEPTH(X) (isnull(X) ? "(null)" : X)

// This is a dummy object used so overlays can be shown in the analyzer.
/atom/movable/openspace/debug

/atom/movable/openspace/debug/turf
	var/turf/parent
	var/computed_depth

/client/proc/analyze_openturf(turf/T)
	set name = "Analyze Openturf"
	set desc = "Show the layering of an openturf and everything it's mimicking."
	set category = "Debug"

	if (!check_rights(R_DEBUG))
		return

	var/real_update_count = 0
	var/claimed_update_count = T.z_queued
	var/list/tq = SSzcopy.queued_turfs.Copy()
	for (var/turf/Tu in tq)
		if (Tu == T)
			real_update_count += 1

		CHECK_TICK

	var/list/temp_objects = list()

	var/is_above_space = T.is_above_space()
	var/list/out = list(
		"<head><meta charset='utf-8'/></head><body>",
		"<h1>Analysis of [T] at [T.x],[T.y],[T.z]</h1>",
		"<b>Queue occurrences:</b> [T.z_queued]",
		"<b>Above space:</b> Apparent [T.z_eventually_space ? "Yes" : "No"], Actual [is_above_space ? "Yes" : "No"] - [T.z_eventually_space == is_above_space ? SPAN_COLOR("green", "OK") : SPAN_COLOR("red", "MISMATCH")]",
		"<b>Z Flags</b>: [english_list(bitfield2list(T.z_flags, GLOB.mimic_defines), "(none)")]",
		"<b>Has Shadower:</b> [T.shadower ? "Yes" : "No"]",
		"<b>Has turf proxy:</b> [T.mimic_proxy ? "Yes" : "No"]",
		"<b>Has above copy:</b> [T.mimic_above_copy ? "Yes" : "No"]",
		"<b>Has mimic underlay:</b> [T.mimic_underlay ? "Yes" : "No"]",
		"<b>Below:</b> [!T.below ? "(nothing)" : "[T.below] at [T.below.x],[T.below.y],[T.below.z]"]",
		"<b>Depth:</b> [FMT_DEPTH(T.z_depth)] [T.z_depth == OPENTURF_MAX_DEPTH ? "(max)" : ""]",
		"<b>Generation:</b> [T.z_generation]",
		"<b>Update count:</b> Claimed [claimed_update_count], Actual [real_update_count] - [claimed_update_count == real_update_count ? "<font color='green'>OK</font>" : "<font color='red'>MISMATCH</font>"]",
		"<ul>"
	)

	if (!T.below)
		out += "<h3>Using synthetic rendering (Not Z).<h3>"
	else if (T.z_flags & ZM_MIMIC_BASETURF)
		out += "<h3>Using synthetic rendering (BASETURF).</h3>"

	var/list/found_oo = list(T)
	var/turf/Tbelow = T
	while ((Tbelow = Tbelow.below))
		var/atom/movable/openspace/debug/turf/VTO = new
		VTO.computed_depth = SSzcopy.zlev_maximums[Tbelow.z] - Tbelow.z
		VTO.appearance = Tbelow
		VTO.parent = Tbelow
		VTO.plane = OPENTURF_MAX_PLANE - VTO.computed_depth
		found_oo += VTO
		temp_objects += VTO

	for (var/atom/movable/openspace/O in T)
		found_oo += O

	if (length(T.shadower.overlays))
		for (var/overlay in T.shadower.overlays)
			var/atom/movable/openspace/debug/D = new
			D.appearance = overlay
			if (D.plane < -10000)	// FLOAT_PLANE
				D.plane = T.shadower.plane
			found_oo += D
			temp_objects += D

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
			out += "<strong>Depth [d], plane [pl] — empty</strong>"
			continue

		out += "<strong>Depth [d], plane [pl]</strong>"
		SSzcopy.debug_fmt_planelist(atoms_list_list["[pl]"], out, T)

		// Flush the list so we can find orphans.
		atoms_list_list -= "[pl]"

	if (atoms_list_list["[SPACE_PLANE]"])	// Space parallax plane
		out += "<strong>Space parallax plane</strong> ([SPACE_PLANE])"
		SSzcopy.debug_fmt_planelist(atoms_list_list["[SPACE_PLANE]"], out, T)
		atoms_list_list -= "[SPACE_PLANE]"

	log_debug("atoms_list_list => [json_encode(atoms_list_list)]")
	for (var/key in atoms_list_list)
		out += "<strong style='color: red;'>Unknown plane: [key]</strong>"
		SSzcopy.debug_fmt_planelist(atoms_list_list[key], out, T)

		out += "<hr/>"

	out += "</body>"

	show_browser(usr, out.Join("<br>"), "size=980x580;window=openturfanalysis-\ref[T]")

	for (var/item in temp_objects)
		qdel(item)

// Yes, I know this proc is a bit of a mess. Feel free to clean it up.
/datum/controller/subsystem/zcopy/proc/debug_fmt_thing(atom/A, list/out, turf/original)
	if (istype(A, /atom/movable/openspace/mimic))
		var/atom/movable/openspace/mimic/OO = A
		var/atom/movable/AA = OO.associated_atom
		var/copied_type = AA.type == OO.mimiced_type ? "[AA.type] \[direct\]" : "[AA.type], eventually [OO.mimiced_type]"
		return "<li>\icon[A] <b>\[Mimic\]</b> plane [A.plane], layer [A.layer], depth [FMT_DEPTH(OO.depth)], associated Z-level [AA.z] - [OO.type] copying [AA] ([copied_type])</li>"
	else if (istype(A, /atom/movable/openspace/turf_mimic))
		var/atom/movable/openspace/turf_mimic/DC = A
		return "<li>\icon[A] <b>\[Turf Mimic\]</b> plane [A.plane], layer [A.layer], Z-level [A.z], delegate of \icon[DC.delegate] [DC.delegate] ([DC.delegate.type])</li>"
	else if (isturf(A))
		if (A == original)
			return "<li>\icon[A] <b>\[Turf\]</b> plane [A.plane], layer [A.layer], depth [FMT_DEPTH(A:z_depth)], Z-level [A.z] - [A] ([A.type]) - [SPAN_COLOR("green", "SELF")]</li>"
		else	// foreign turfs - not visible here, but sometimes good for figuring out layering -- showing these is currently not enabled
			return "<li>\icon[A] <b>\[Turf\]</b> <em>[SPAN_COLOR("#646464", "plane [A.plane], layer [A.layer], depth [FMT_DEPTH(A:z_depth)], Z-level [A.z] - [A] ([A.type])")]</em> - [SPAN_COLOR("red", "FOREIGN")]</em></li>"
	else if (A.type == /atom/movable/openspace/multiplier)
		return "<li>\icon[A] <b>\[Shadower\]</b> plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type])</li>"
	else if (A.type == /atom/movable/openspace/debug)	// These are fake objects that exist just to show the shadower's overlays in this list.
		return "<li>\icon[A] <b>\[Shadower True Overlay\]</b> plane [A.plane], layer [A.layer] - [SPAN_COLOR("grey", "VIRTUAL")]</li>"
	else if (A.type == /atom/movable/openspace/turf_proxy)
		return "<li>\icon[A] <b>\[Turf Proxy\]</b> plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type])</li>"
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
