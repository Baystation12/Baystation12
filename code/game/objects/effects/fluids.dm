/obj/effect/fluid
	name = ""
	icon = 'icons/effects/liquids.dmi'
	anchored = TRUE
	simulated = FALSE
	opacity = 0
	mouse_opacity = 0
	layer = FLY_LAYER
	alpha = 0
	color = COLOR_OCEAN

	var/fluid_amount = 0
	var/turf/start_loc
	var/list/equalizing_fluids = list()
	var/equalize_avg_depth = 0
	var/equalize_avg_temp = 0
	var/flow_amount = 0

/obj/effect/fluid/ex_act()
	return

/obj/effect/fluid/airlock_crush()
	qdel(src)

/obj/effect/fluid/Initialize()
	. = ..()
	start_loc = get_turf(src)
	if(!istype(start_loc) || start_loc.flooded)
		qdel(src)
		return
	var/turf/simulated/T = start_loc
	if(istype(T))
		T.unwet_floor(FALSE)
	forceMove(start_loc)
	update_icon()

/obj/effect/fluid/Destroy()
	if(start_loc)
		var/turf/simulated/T = start_loc
		if(istype(T))
			T.wet_floor()
		start_loc = null
	if(islist(equalizing_fluids))
		equalizing_fluids.Cut()
	REMOVE_ACTIVE_FLUID(src)
	. = ..()

/obj/effect/fluid/on_update_icon()

	overlays.Cut()

	if(fluid_amount > FLUID_OVER_MOB_HEAD)
		layer = DEEP_FLUID_LAYER
	else
		layer = SHALLOW_FLUID_LAYER

	if(fluid_amount > FLUID_DEEP)
		alpha = FLUID_MAX_ALPHA
	else
		alpha = min(FLUID_MAX_ALPHA,max(FLUID_MIN_ALPHA,ceil(255*(fluid_amount/FLUID_DEEP))))

	if(fluid_amount > FLUID_DELETING && fluid_amount <= FLUID_EVAPORATION_POINT)
		APPLY_FLUID_OVERLAY("shallow_still")
	else if(fluid_amount > FLUID_EVAPORATION_POINT && fluid_amount < FLUID_SHALLOW)
		APPLY_FLUID_OVERLAY("mid_still")
	else if(fluid_amount >= FLUID_SHALLOW && fluid_amount < (FLUID_DEEP*2))
		APPLY_FLUID_OVERLAY("deep_still")
	else if(fluid_amount >= (FLUID_DEEP*2))
		APPLY_FLUID_OVERLAY("ocean")

// Map helper.
/obj/effect/fluid_mapped
	name = "mapped flooded area"
	alpha = 125
	icon_state = "shallow_still"
	color = COLOR_OCEAN

	var/fluid_amount = FLUID_MAX_DEPTH

/obj/effect/fluid_mapped/Initialize()
	..()
	var/turf/T = get_turf(src)
	if(istype(T))
		var/obj/effect/fluid/F = locate() in T
		if(!F) F = new(T)
		SET_FLUID_DEPTH(F, fluid_amount)
	return INITIALIZE_HINT_QDEL

// Permaflood overlay.
/obj/effect/flood
	name = ""
	mouse_opacity = 0
	layer = DEEP_FLUID_LAYER
	color = COLOR_OCEAN
	icon = 'icons/effects/liquids.dmi'
	icon_state = "ocean"
	alpha = FLUID_MAX_ALPHA
	simulated = FALSE
	density = FALSE
	opacity = 0
	anchored = TRUE

/obj/effect/flood/ex_act()
	return

/obj/effect/flood/New()
	..()
	verbs.Cut()
