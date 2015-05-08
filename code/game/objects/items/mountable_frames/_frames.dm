#define MOUNTREQ_SIMFLOOR 1
#define MOUNTREQ_NOSPACE 2

/obj/item/mounted/frame
	name = "mountable frame"
	desc = "Place it on a wall."
	var/sheets_refunded = 2
	var/list/mount_reqs = 0 //can contain simfloor, nospace. Used in try_build to see if conditions are needed, then met

/obj/item/mounted/frame/attackby(obj/item/weapon/W, mob/user)
	..()
	if (istype(W, /obj/item/weapon/wrench) && sheets_refunded)
		var/obj/item/stack/sheet/metal/M = PoolOrNew(/obj/item/stack/sheet/metal, get_turf(src))
		M.amount = sheets_refunded
		qdel(src)

/obj/item/mounted/frame/try_build(turf/on_wall, mob/user)
	if(..()) //if we pass the parent tests
		var/turf/turf_loc = get_turf(user)
		var/area/A = get_area(user)

		if ((src.mount_reqs & MOUNTREQ_SIMFLOOR) && !istype(turf_loc, /turf/simulated/floor))
			user << "<span class='notice'>[src] cannot be placed on this spot.</span>"
			return
		if ((src.mount_reqs & MOUNTREQ_NOSPACE) && (A.requires_power == 0 || A.type == /area/space))
			user << "<span class='notice'>[src] cannot be placed in this area.</span>"
			return
		return 1
