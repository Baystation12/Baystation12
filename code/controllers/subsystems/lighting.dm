SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = LIGHTING_INTERVAL
	priority = SS_PRIORITY_LIGHTING
	init_order = SS_INIT_LIGHTING
	runlevels = RUNLEVELS_PREGAME | RUNLEVELS_GAME

	var/total_lighting_overlays = 0
	var/total_lighting_sources = 0
	var/total_ambient_turfs = 0
	var/total_lighting_corners = 0

	/// lighting sources  queued for update.
	var/list/light_queue   = list()
	var/lq_idex = 1
	/// lighting corners  queued for update.
	var/list/corner_queue  = list()
	var/cq_idex = 1
	/// lighting overlays queued for update.
	var/list/overlay_queue = list()
	var/oq_idex = 1

	// - Performance and analytics data
	var/processed_lights = 0
	var/processed_corners = 0
	var/processed_overlays = 0

	var/total_ss_updates = 0
	var/total_instant_updates = 0

#ifdef USE_INTELLIGENT_LIGHTING_UPDATES
	var/force_queued = TRUE
	var/force_override = FALSE	// For admins.
#endif

/datum/controller/subsystem/lighting/UpdateStat(time)
	var/list/out = list(
#ifdef USE_INTELLIGENT_LIGHTING_UPDATES
		"IUR: [total_ss_updates ? round(total_instant_updates/(total_instant_updates+total_ss_updates)*100, 0.1) : "NaN"]%\n",
#endif
		"\tT:{L:[total_lighting_sources] C:[total_lighting_corners] O:[total_lighting_overlays] A:[total_ambient_turfs]}\n",
		"\tP:{L:[length(light_queue) - (lq_idex - 1)]|C:[length(corner_queue) - (cq_idex - 1)]|O:[length(overlay_queue) - (oq_idex - 1)]}\n",
		"\tL:{L:[processed_lights]|C:[processed_corners]|O:[processed_overlays]}\n"
	)
	..(out.Join())

#ifdef USE_INTELLIGENT_LIGHTING_UPDATES

/hook/roundstart/proc/lighting_init_roundstart()
	SSlighting.handle_roundstart()
	return TRUE

/datum/controller/subsystem/lighting/proc/handle_roundstart()
	force_queued = FALSE
	total_ss_updates = 0
	total_instant_updates = 0

#endif
/// Generate overlays for all Zlevels and then fire normally
/datum/controller/subsystem/lighting/Initialize(timeofday)
	var/overlaycount = 0
	var/starttime = uptime()

	// Generate overlays.
	for (var/zlevel = 1 to world.maxz)
		overlaycount += InitializeZlev(zlevel)

	admin_notice(SPAN_DANGER("Created [overlaycount] lighting overlays in [(uptime() - starttime)/10] seconds."), R_DEBUG)

	starttime = uptime()
	// Tick once to clear most lights.
	fire(FALSE, TRUE)

	admin_notice(SPAN_DANGER("Processed [processed_lights] light sources."), R_DEBUG)
	admin_notice(SPAN_DANGER("Processed [processed_corners] light corners."), R_DEBUG)
	admin_notice(SPAN_DANGER("Processed [processed_overlays] light overlays."), R_DEBUG)
	admin_notice(SPAN_DANGER("Lighting pre-bake completed in [(uptime() - starttime)/10] seconds."), R_DEBUG)

	log_ss("lighting", "NOv:[overlaycount] L:[processed_lights] C:[processed_corners] O:[processed_overlays]")

	..()

/**
 * Go over turfs thay may be dynamically lit and add a lighting overlay if they don't have one. Then do the same for turfs that may be ambient lit.
 *
 * **Parameters**:
 * - `zlev` int - z-level index
 */
/datum/controller/subsystem/lighting/proc/InitializeZlev(zlev)
	for (var/thing in Z_ALL_TURFS(zlev))
		var/turf/T = thing
		if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(T) && !T.lighting_overlay)	// Can't assume that one hasn't already been created on bay/neb.
			new /atom/movable/lighting_overlay(T)
			. += 1
			if(TURF_IS_AMBIENT_LIT_UNSAFE(T))
				T.generate_missing_corners()	// Forcibly generate corners.

		CHECK_TICK

/// Initialize a set of turfs (for example as part of loading a map template) It's safe to pass a list of non-turfs to this list - it'll only check turfs.
/datum/controller/subsystem/lighting/proc/InitializeTurfs(list/targets)
	for (var/turf/T in (targets || world))
		if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(T))
			T.lighting_build_overlay()

		// If this isn't here, BYOND will set-background us.
		CHECK_TICK

/**
 * Go over light queue and update corners as needed
 * Go over light corner queue and update overlays as needed
 * Go over overlay queue and update as needed
 */
/datum/controller/subsystem/lighting/fire(resumed = FALSE, no_mc_tick = FALSE)
	if (!resumed)
		processed_lights = 0
		processed_corners = 0
		processed_overlays = 0

	MC_SPLIT_TICK_INIT(3)
	if (!no_mc_tick)
		MC_SPLIT_TICK

	var/list/curr_lights = light_queue
	var/list/curr_corners = corner_queue
	var/list/curr_overlays = overlay_queue

	while (lq_idex <= length(curr_lights))
		var/datum/light_source/L = curr_lights[lq_idex++]

		if (L.needs_update != LIGHTING_NO_UPDATE)
			total_ss_updates += 1
			L.update_corners()

			L.needs_update = LIGHTING_NO_UPDATE

			processed_lights++

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (lq_idex > 1)
		curr_lights.Cut(1, lq_idex)
		lq_idex = 1

	if (!no_mc_tick)
		MC_SPLIT_TICK

	while (cq_idex <= length(curr_corners))
		var/datum/lighting_corner/C = curr_corners[cq_idex++]

		if (C.needs_update)
			C.update_overlays()

			C.needs_update = FALSE

			processed_corners++

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (cq_idex > 1)
		curr_corners.Cut(1, cq_idex)
		cq_idex = 1

	if (!no_mc_tick)
		MC_SPLIT_TICK

	while (oq_idex <= length(curr_overlays))
		var/atom/movable/lighting_overlay/O = curr_overlays[oq_idex++]

		if (!QDELETED(O) && O.needs_update)
			O.update_overlay()
			O.needs_update = FALSE

			processed_overlays++

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (oq_idex > 1)
		curr_overlays.Cut(1, oq_idex)
		oq_idex = 1

/datum/controller/subsystem/lighting/Recover()
	total_lighting_corners = SSlighting.total_lighting_corners
	total_lighting_overlays = SSlighting.total_lighting_overlays
	total_lighting_sources = SSlighting.total_lighting_sources

	light_queue = SSlighting.light_queue
	corner_queue = SSlighting.corner_queue
	overlay_queue = SSlighting.overlay_queue

	lq_idex = SSlighting.lq_idex
	cq_idex = SSlighting.cq_idex
	oq_idex = SSlighting.oq_idex

	if (lq_idex > 1)
		light_queue.Cut(1, lq_idex)
		lq_idex = 1

	if (cq_idex > 1)
		corner_queue.Cut(1, cq_idex)
		cq_idex = 1

	if (oq_idex > 1)
		overlay_queue.Cut(1, oq_idex)
		oq_idex = 1
