
/turf
	var/image/obscured
	var/image/dim

/turf/proc/visibilityChanged()
	cameraNetwork.updateVisibility(src)

/turf/New()
	..()
	cameraNetwork.updateVisibility(src)

/obj/machinery/door/update_nearby_tiles(need_rebuild)
	. = ..(need_rebuild)
	cameraNetwork.updateVisibility(loc)

/obj/machinery/camera/New()
	..()
	cameraNetwork.addViewpoint(src)

/obj/machinery/camera/Del()
	cameraNetwork.removeViewpoint(src)
	..()

/obj/machinery/camera/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	. = ..(W, user)
	if(istype(W, /obj/item/weapon/wirecutters))
		if(status)
			cameraNetwork.addViewpoint(src)
		else
			cameraNetwork.removeViewpoint(src)

/proc/checkcameravis(atom/A)
	for(var/obj/machinery/camera/C in view(A,7))
		if(!C.status || C.stat == 2)
			continue
		return 1
	return 0
