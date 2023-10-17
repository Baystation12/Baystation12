/obj/item/pai_cable
	desc = "A flexible coated cable with a universal jack on one end."
	name = "data cable"
	icon = 'icons/obj/machines/power/power_local.dmi'
	icon_state = "wire1"
	var/obj/machinery/machine

/obj/item/pai_cable/use_before(obj/machinery/M as obj, mob/user as mob)
	. = FALSE
	if (istype(M, /obj/machinery/door) || istype(M, /obj/machinery/camera))
		if (!user.unEquip(src, M))
			return TRUE
		user.visible_message("[user] inserts [src] into a data port on [M].", "You insert [src] into a data port on [M].", "You hear the satisfying click of a wire jack fastening into place.")
		src.machine = M
		return TRUE
	else
		user.visible_message("[user] dumbly fumbles to find a place on [M] to plug in [src].", "There aren't any ports on [M] that match the jack belonging to [src].")
		return FALSE
