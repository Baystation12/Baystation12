#define AO_TURF_CHECK(T) (!T.density || !T.permit_ao)

/turf
	var/permit_ao = TRUE
	var/tmp/list/ao_overlays	// Current ambient occlusion overlays. Tracked so we can reverse them without dropping all priority overlays.
	var/tmp/ao_neighbors
	var/ao_queued = AO_UPDATE_NONE

/turf/Initialize(mapload)
	. = ..()
	if (mapload && permit_ao)
		queue_ao()

/turf/set_density(var/new_density)
	var/last_density = density
	..()
	if(density != last_density && permit_ao)
		regenerate_ao()

/turf/proc/regenerate_ao()
	for(var/turf/T in RANGE_TURFS(src, 1))
		if (T.permit_ao)
			T.queue_ao(TRUE)

/turf/proc/calculate_ao_neighbors()
	ao_neighbors = 0
	if (!permit_ao)
		return

	var/turf/T
	if (AO_TURF_CHECK(src))
		CALCULATE_NEIGHBORS(src, ao_neighbors, T, AO_TURF_CHECK(T))

/proc/make_ao_image(corner, i, px = 0, py = 0, pz = 0, pw = 0)
	var/list/cache = SSao.cache
	var/cstr = "[corner]"
	var/key = "[cstr]-[i]-[px]/[py]/[pz]/[pw]"

	var/image/I = image('icons/turf/flooring/shadows.dmi', cstr, dir = 1 << (i-1))
	I.alpha = WALL_AO_ALPHA
	I.blend_mode = BLEND_OVERLAY
	I.appearance_flags = RESET_ALPHA|RESET_COLOR|TILE_BOUND
	I.layer = AO_LAYER
	I.plane = ABOVE_TURF_PLANE
	// If there's an offset, counteract it.
	if (px || py || pz || pw)
		I.pixel_x = -px
		I.pixel_y = -py
		I.pixel_z = -pz
		I.pixel_w = -pw

	. = cache[key] = I

/turf/proc/queue_ao(rebuild = TRUE)
	SSao.queue |= src
	var/new_level = rebuild ? AO_UPDATE_REBUILD : AO_UPDATE_OVERLAY
	if (ao_queued < new_level)
		ao_queued = new_level

#define PROCESS_AO_CORNER(AO_LIST, NEIGHBORS, CORNER_INDEX, CDIR) \
	corner = 0; \
	if (NEIGHBORS & (1 << CDIR)) { \
		corner |= 2; \
	} \
	if (NEIGHBORS & (1 << turn(CDIR, 45))) { \
		corner |= 1; \
	} \
	if (NEIGHBORS & (1 << turn(CDIR, -45))) { \
		corner |= 4; \
	} \
	if (corner != 7) {	/* 7 is the 'no shadows' state, no reason to add overlays for it. */ \
		var/image/I = cache["[corner]-[CORNER_INDEX]-[pixel_x]/[pixel_y]/[pixel_z]/[pixel_w]"]; \
		if (!I) { \
			I = make_ao_image(corner, CORNER_INDEX, pixel_x, pixel_y, pixel_z, pixel_w)	/* this will also add the image to the cache. */ \
		} \
		LAZYADD(AO_LIST, I); \
	}

/turf/proc/update_ao()
	if(ao_overlays)
		overlays -= ao_overlays
		ao_overlays.Cut()
	if(AO_TURF_CHECK(src))
		if(permit_ao && ao_neighbors != AO_ALL_NEIGHBORS)
			var/list/cache = SSao.cache
			var/corner
			PROCESS_AO_CORNER(ao_overlays, ao_neighbors, 1, NORTHWEST)
			PROCESS_AO_CORNER(ao_overlays, ao_neighbors, 2, SOUTHEAST)
			PROCESS_AO_CORNER(ao_overlays, ao_neighbors, 3, NORTHEAST)
			PROCESS_AO_CORNER(ao_overlays, ao_neighbors, 4, SOUTHWEST)
		UNSETEMPTY(ao_overlays)
		if(ao_overlays)
			overlays |= ao_overlays

#undef PROCESS_AO_CORNER

/turf/ChangeTurf()
	var/old_density = density
	var/old_permit_ao = permit_ao
	. = ..()
	if(density != old_density || permit_ao != old_permit_ao)
		regenerate_ao()
