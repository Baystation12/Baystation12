
#define AUTOLIGHT_LIGHTINIT_CAP 500
#define AUTOLIGHT_LIGHTINIT_SLEEPTIME 10
/obj/daylight_mark
	opacity = 0
	mouse_opacity = 0
	invisibility = 61

/obj/daylight_mark/New()
	. = ..()
	set_light(8,8)

/obj/autolight_init
	var/targ_area = null
	var/light_type = /obj/daylight_mark

/obj/autolight_init/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/autolight_init/LateInitialize()
	var/area/found = locate(targ_area)
	var/ctr = 0
	for(var/turf/create_at in found.contents)
		var/create_light = 0
		for(var/t in trange(1,create_at))
			var/turf/adj_turf = t
			var/area/adj_turf_area = adj_turf.loc
			if(!istype(adj_turf_area,targ_area) && adj_turf_area.dynamic_lighting != 0)
				create_light = 1
			if(locate(light_type) in adj_turf.contents)
				create_light = 0
				break
		if(create_light)
			new light_type (create_at)
			ctr++
			if(ctr >= AUTOLIGHT_LIGHTINIT_CAP)
				ctr = 0
				sleep(AUTOLIGHT_LIGHTINIT_SLEEPTIME)
	qdel(src)

#undef AUTOLIGHT_LIGHTINIT_CAP
#undef AUTOLIGHT_LIGHTINIT_SLEEPTIME