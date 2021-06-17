/obj/item/mech_equipment/mounted_system/rcd
	icon_state = "mech_rcd"
	holding_type = /obj/item/rcd/mounted
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_ENGINEERING)

/obj/item/rcd/mounted/get_hardpoint_maptext()
	var/obj/item/mech_equipment/mounted_system/MS = loc
	if(istype(MS) && MS.owner)
		var/obj/item/cell/C = MS.owner.get_cell()
		if(istype(C))
			return "[round(C.charge)]/[round(C.maxcharge)]"
	return null

/obj/item/rcd/mounted/get_hardpoint_status_value()
	var/obj/item/mech_equipment/mounted_system/MS = loc
	if(istype(MS) && MS.owner)
		var/obj/item/cell/C = MS.owner.get_cell()
		if(istype(C))
			return C.charge/C.maxcharge
	return null

/obj/item/extinguisher/mech
	max_water = 4000 //Good is gooder
	starting_water = 4000
	icon_state = "mech_exting"

/obj/item/extinguisher/mech/get_hardpoint_maptext()
	return "[reagents.total_volume]/[max_water]"

/obj/item/extinguisher/mech/get_hardpoint_status_value()
	return reagents.total_volume/max_water

/obj/item/mech_equipment/mounted_system/extinguisher
	icon_state = "mech_exting"
	holding_type = /obj/item/extinguisher/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_ENGINEERING)
