
/turf/unsimulated/proc/wet_floor(var/wet_val = 1, var/overwrite = FALSE)

/turf/unsimulated/floor/dirt/wet_floor(var/wet_val = 1, var/overwrite = FALSE)
	if(wet_val)
		ChangeTurf(/turf/unsimulated/floor/mud_dark)

/turf/unsimulated/floor/grass/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/shovel))
		src.visible_message("<span class='info'>[user] begins digging up [src]</span>")
		if(do_after(user, 30))
			ChangeTurf(/turf/unsimulated/floor/dirt)

/turf/unsimulated/floor/grass2/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/shovel))
		src.visible_message("<span class='info'>[user] begins digging up [src]</span>")
		if(do_after(user, 30))
			ChangeTurf(/turf/unsimulated/floor/dirt)


/obj/machinery/portable_atmospherics/hydroponics/soil/planet
	var/harvests_done = 0

/obj/machinery/portable_atmospherics/hydroponics/soil/planet/harvest(var/mob/user)
	if(prob(harvests_done * 10))
		var/turf/unsimulated/floor/mud_dark/M = get_turf(src)
		if(istype(M))
			M.ChangeTurf(/turf/unsimulated/floor/dirt)
		qdel(src)
	harvests_done++

/turf/unsimulated/floor/mud_dark/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/shovel))
		var/obj/machinery/portable_atmospherics/hydroponics/soil/S = locate() in src

		if(S)
			to_chat(user,"<span class='warning'>[src] has already been tilled.</span>")
		else
			src.visible_message("<span class='info'>[user] begins tilling [src]</span>")
			if(do_after(user, 30))
				new /obj/machinery/portable_atmospherics/hydroponics/soil/planet(src)

/turf/simulated/floor/transitfake
	name = "\proper space"
	icon = 'icons/turf/space.dmi'
	icon_state = "speedspace_ns_1"
	dynamic_lighting = 0
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/transitfake/New()
	icon_state = "speedspace_ns_[rand(1,15)]"
