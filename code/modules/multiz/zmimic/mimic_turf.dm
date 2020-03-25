/turf
	// Reference to any open turf that might be above us to speed up atom Entered() updates.
	var/tmp/turf/above
	var/tmp/turf/below
	var/tmp/atom/movable/openspace/turf_overlay/bound_overlay
	var/tmp/atom/movable/openspace/multiplier/shadower		// Overlay used to multiply color of all OO overlays at once.
	var/tmp/z_queued = 0	// How many times this turf is currently queued - multiple queue occurrences are allowed to ensure update consistency
	var/tmp/z_eventually_space = FALSE
	var/z_flags = 0

/turf/Entered(atom/movable/thing, turf/oldLoc)
	. = ..()
	if (thing.bound_overlay || thing.no_z_overlay || !TURF_IS_MIMICING(above))
		return
	above.update_mimic()

/turf/update_above()
	if (TURF_IS_MIMICING(above))
		above.update_mimic()

/turf/proc/update_mimic()
	if (!(z_flags & ZM_MIMIC_BELOW))
		return

	if (below)
		z_queued += 1
		SSzcopy.queued_turfs += src

// Enables Z-mimic for a turf that didn't already have it enabled.
/turf/proc/enable_zmimic(additional_flags = 0)
	if (z_flags & ZM_MIMIC_BELOW)
		return FALSE

	z_flags |= ZM_MIMIC_BELOW | additional_flags
	setup_zmimic(FALSE)
	return TRUE

// Disables Z-mimic for a turf.
/turf/proc/disable_zmimic()
	if (!(z_flags & ZM_MIMIC_BELOW))
		return FALSE

	z_flags &= ~ZM_MIMIC_BELOW
	cleanup_zmimic()

// Sets up Z-mimic for this turf. You shouldn't call this directly 99% of the time.
/turf/proc/setup_zmimic(mapload)
	if (shadower)
		CRASH("Attempt to enable Z-mimic on already-enabled turf!")
	shadower = new(src)
	SSzcopy.openspace_turfs += 1
	var/turf/under = GetBelow(src)
	if (under)
		below = under
		below.above = src

	update_mimic(!mapload)	// Only recursively update if the map isn't loading.

// Cleans up Z-mimic objects for this turf. You shouldn't call this directly 99% of the time.
/turf/proc/cleanup_zmimic()
	SSzcopy.openspace_turfs -= 1
	// Don't remove ourselves from the queue, the subsystem will explode. We'll naturally fall out of the queue.
	z_queued = 0

	QDEL_NULL(shadower)

	for (var/atom/movable/openspace/overlay/OO in src)
		OO.owning_turf_changed()

	if (above)
		above.update_mimic()

	if (below)
		below.above = null
		below = null

// Movable for mimicing turfs that don't allow appearance mutation.
/atom/movable/openspace/turf_overlay
	plane = OPENTURF_MAX_PLANE

/atom/movable/openspace/turf_overlay/attackby(obj/item/W, mob/user)
	loc.attackby(W, user)

/atom/movable/openspace/turf_overlay/attack_hand(mob/user as mob)
	loc.attack_hand(user)

/atom/movable/openspace/turf_overlay/attack_generic(mob/user as mob)
	loc.attack_generic(user)

/atom/movable/openspace/turf_overlay/examine(mob/examiner)
	. = loc.examine(examiner)
