/obj/item/mecha_equipment/mounted_system/rcd
	icon_state = "mecha_rcd"
	holding_type = /obj/item/weapon/rcd/mounted
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_ENGINEERING)

/obj/item/weapon/rcd/mounted/get_hardpoint_maptext()
	var/obj/item/mecha_equipment/mounted_system/MS = loc
	if(istype(MS) && MS.owner.body && MS.owner.body && MS.owner.body.cell)
		return "[MS.owner.body.cell.charge]/[MS.owner.body.cell.maxcharge]"
	return null

/obj/item/weapon/rcd/mounted/get_hardpoint_status_value()
	var/obj/item/mecha_equipment/mounted_system/MS = loc
	if(istype(MS) && MS.owner.body && MS.owner.body && MS.owner.body.cell)
		return MS.owner.body.cell.charge/MS.owner.body.cell.maxcharge
	return null
