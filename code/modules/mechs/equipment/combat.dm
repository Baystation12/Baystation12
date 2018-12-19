/obj/item/mech_equipment/mounted_system/taser
	name = "Mounted taser carbine"
	desc = "A dual fire mode taser system connected to the exosuit's targetting system"
	icon_state = "mech_taser"
	holding_type = /obj/item/weapon/gun/energy/taser/carbine/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)

/obj/item/mech_equipment/mounted_system/taser/ion
	name = "Mounted ion rifle"
	desc = "A exosuit mounted ion rifle. Handle with care"
	icon_state = "mech_ionrifle"
	holding_type = /obj/item/weapon/gun/energy/ionrifle/mounted/mech

/obj/item/mech_equipment/mounted_system/taser/laser
	name = "\improper CH-PS \"Immolator\" laser"
	desc = "A exosuit mounted ion rifle. Handle with care"
	icon_state = "mech_lasercarbine"
	holding_type = /obj/item/weapon/gun/energy/laser/mounted/mech

/obj/item/weapon/gun/energy/taser/carbine/mounted/mech
	use_external_power = TRUE
	has_safety = FALSE
	self_recharge = TRUE

/obj/item/weapon/gun/energy/ionrifle/mounted/mech
	use_external_power = TRUE
	has_safety = FALSE
	self_recharge = TRUE

/obj/item/weapon/gun/energy/laser/mounted/mech
	name = "\improper CH-PS \"Immolator\" laser"
	use_external_power = TRUE
	has_safety = FALSE
	self_recharge = TRUE

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
