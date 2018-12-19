/obj/item/mech_equipment/mounted_system/taser
	icon_state = "mech_taser"
	holding_type = /obj/item/weapon/gun/energy/taser/carbine/mounted
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)

/obj/item/mech_equipment/mounted_system/taser/ion
	icon_state = "mech_ionrifle"
	holding_type = /obj/item/weapon/gun/energy/ionrifle/mounted

/obj/item/weapon/gun/energy/taser/carbine/mounted
	use_external_power = TRUE
	has_safety = FALSE

/obj/item/weapon/gun/energy/ionrifle/mounted
	use_external_power = TRUE
	has_safety = FALSE

/obj/item/weapon/gun/energy/get_hardpoint_maptext()
	var/obj/item/mech_equipment/mounted_system/MS = loc
	if(istype(MS) && MS.owner.body && MS.owner.body && MS.owner.get_cell())
		return "[MS.owner.get_cell().charge]/[MS.owner.get_cell().maxcharge]"
	return null

/obj/item/weapon/gun/energy/get_hardpoint_status_value()
	var/obj/item/mech_equipment/mounted_system/MS = loc
	if(istype(MS) && MS.owner.body && MS.owner.body && MS.owner.get_cell())
		return MS.owner.get_cell().charge/MS.owner.get_cell().maxcharge
	return null
