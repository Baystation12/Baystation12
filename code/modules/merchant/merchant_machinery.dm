/obj/machinery/merchant_pad
	name = "teleportation pad"
	desc = "Place things here to trade."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "pad"
	anchored = TRUE
	density = FALSE

/obj/machinery/merchant_pad/proc/get_target()
	var/turf/T = get_turf(src)
	for(var/a in T)
		if(a == src || (!istype(a,/obj) && !istype(a,/mob/living)) || istype(a,/obj/effect))
			continue
		return a

/obj/machinery/merchant_pad/proc/get_targets()
	. = list()
	var/turf/T = get_turf(src)
	for(var/a in T)
		if(a == src || (!istype(a,/obj) && !istype(a,/mob/living)) || istype(a,/obj/effect))
			continue
		. += a
