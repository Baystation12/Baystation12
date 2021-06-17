#define FLUID_EVAPORATION_POINT 3          // Depth a fluid begins self-deleting
#define FLUID_DELETING -1                  // Depth a fluid counts as qdel'd
#define FLUID_SHALLOW 200                  // Depth shallow icon is used
#define FLUID_OVER_MOB_HEAD 300
#define FLUID_DEEP 800                     // Depth deep icon is used
#define FLUID_MAX_DEPTH FLUID_DEEP*4       // Arbitrary max value for flooding.
#define FLUID_PUSH_THRESHOLD 20            // Amount of water flow needed to push items.

// Expects /turf for T.
#define ADD_ACTIVE_FLUID_SOURCE(T)    SSfluids.water_sources[T] = TRUE
#define REMOVE_ACTIVE_FLUID_SOURCE(T) SSfluids.water_sources -= T

// Expects /obj/effect/fluid for F.
#define ADD_ACTIVE_FLUID(F)           SSfluids.active_fluids[F] = TRUE
#define REMOVE_ACTIVE_FLUID(F)        SSfluids.active_fluids -= F

// Expects /obj/effect/fluid for F, int for amt.
#define LOSE_FLUID(F, amt) \
	F:fluid_amount = max(-1, F:fluid_amount - amt); \
	ADD_ACTIVE_FLUID(F)
#define SET_FLUID_DEPTH(F, amt) \
	F:fluid_amount = min(FLUID_MAX_DEPTH, amt); \
	ADD_ACTIVE_FLUID(F)

// Expects turf for T,
#define UPDATE_FLUID_BLOCKED_DIRS(T) \
	if(isnull(T:fluid_blocked_dirs)) {\
		T:fluid_blocked_dirs = 0; \
		for(var/obj/structure/window/W in T) { \
			if(W.density) T:fluid_blocked_dirs |= W.dir; \
		} \
		for(var/obj/machinery/door/window/D in T) {\
			if(D.density) T:fluid_blocked_dirs |= D.dir; \
		} \
	}

// Expects turf for T, bool for dry_run.
#define FLOOD_TURF_NEIGHBORS(T, dry_run) \
	for(var/spread_dir in GLOB.cardinal) {\
		UPDATE_FLUID_BLOCKED_DIRS(T); \
		if(T:fluid_blocked_dirs & spread_dir) continue; \
		var/turf/next = get_step(T, spread_dir); \
		if(!istype(next) || next.flooded) continue; \
		UPDATE_FLUID_BLOCKED_DIRS(next); \
		if((next.fluid_blocked_dirs & GLOB.reverse_dir[spread_dir]) || !next.CanFluidPass(spread_dir)) continue; \
		flooded_a_neighbor = TRUE; \
		var/obj/effect/fluid/F = locate() in next; \
		if(!F && !dry_run) {\
			F = new /obj/effect/fluid(next); \
			var/datum/gas_mixture/GM = T:return_air(); \
			if(GM) F.temperature = GM.temperature; \
		} \
		if(F) { \
			if(F.fluid_amount >= FLUID_MAX_DEPTH) continue; \
			if(!dry_run) SET_FLUID_DEPTH(F, FLUID_MAX_DEPTH); \
		} \
	} \
	if(!flooded_a_neighbor) REMOVE_ACTIVE_FLUID_SOURCE(T);

// We share overlays for all fluid turfs to sync icon animation.
#define APPLY_FLUID_OVERLAY(img_state) \
	if(!SSfluids.fluid_images[img_state]) SSfluids.fluid_images[img_state] = image('icons/effects/liquids.dmi',img_state); \
	overlays += SSfluids.fluid_images[img_state];

#define FLUID_MAX_ALPHA 160
#define FLUID_MIN_ALPHA 45
