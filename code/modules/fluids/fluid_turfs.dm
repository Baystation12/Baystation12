#define OCEAN_SPREAD_DEPTH 1000
var/image/ocean_overlay

/turf/unsimulated/ocean
	name = "seafloor"
	desc = "Silty."
	density = 0
	opacity = 0
	var/sleeping = 0
	icon = 'icons/turf/desert.dmi'
	icon_state = "desert"
	var/isolated

/turf/unsimulated/ocean/New()
	..()
	processing_turfs |= src
	overlays.Cut()
	if(prob(20))
		overlays |= get_mining_overlay("asteroid[rand(0,9)]")
	if(!ocean_overlay)
		ocean_overlay = image('icons/effects/liquid.dmi', "deep_still")
		ocean_overlay.color = "#66D1FF"
		ocean_overlay.alpha = FLUID_MAX_ALPHA
		ocean_overlay.layer = 4.9
	overlays |= ocean_overlay

/turf/unsimulated/ocean/Destroy()
	processing_turfs -= src
	..()

/turf/unsimulated/ocean/proc/can_spread_into(var/turf/simulated/target, var/flow_dir)
	for(var/obj/O in target)
		if(!O.can_liquid_pass(flow_dir))
			return 0
	return 1

/turf/unsimulated/ocean/proc/refresh()
	sleeping = 0
	processing_turfs |= src

/turf/unsimulated/ocean/process()
	sleeping = 1
	if(!isolated)
		var/list/blocked_dirs = list()
		for(var/obj/structure/window/W in src)
			blocked_dirs |= W.dir
		for(var/obj/machinery/door/window/D in src)
			blocked_dirs |= D.dir

		for(var/turf/simulated/T in range(1,src))
			if(T.density)
				continue
			var/flowdir = get_dir(src,T)
			if(flowdir in blocked_dirs)
				continue
			if(!can_spread_into(T, flowdir))
				continue
			var/obj/effect/fluid/F = locate(/obj/effect/fluid) in T
			if(!F)
				F = PoolOrNew(/obj/effect/fluid, T)
				new_fluids |= F
			F.set_depth(OCEAN_SPREAD_DEPTH)
			sleeping = 0
	if(sleeping)
		processing_turfs -= src

/turf/unsimulated/ocean/is_ocean()
	return 1

#undef OCEAN_SPREAD_DEPTH