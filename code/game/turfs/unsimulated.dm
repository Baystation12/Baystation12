GLOBAL_LIST_INIT(impact_crater_images, list(image('code/modules/halo/icons/scrap/base.dmi',"crater_s"), image('code/modules/halo/icons/scrap/base.dmi',"crater_l")))

/turf/unsimulated
	name = "command"
	initial_gas = list("oxygen" = MOLES_O2STANDARD, "nitrogen" = MOLES_N2STANDARD)
	var/exploded

/turf/unsimulated/proc/can_build_cable(var/mob/user)
	return 0

/turf/unsimulated/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/stack/cable_coil) && can_build_cable(user))
		var/obj/item/stack/cable_coil/coil = thing
		coil.turf_place(src, user)
		return
	return ..()

/turf/unsimulated/floor/ex_act(severity)
	if(!exploded)
		exploded = 1
		//chuck an impact crater overlay on that turf
		var/image/I = pick(GLOB.impact_crater_images)
		I.pixel_x = rand(-16,16)
		I.pixel_y = rand(-16,16)
		src.overlays += I

/turf/unsimulated/floor/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	ex_act(1)
