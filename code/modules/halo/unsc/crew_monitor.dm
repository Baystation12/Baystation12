
/obj/item/modular_computer/console/unsc/crew
	name = "Crew monitoring computer"

/obj/item/modular_computer/console/unsc/crew/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/suit_sensors/unsc())
	set_autorun("sensormonitor_unsc")

/datum/computer_file/program/suit_sensors/unsc
	filename = "sensormonitor_unsc"
	nanomodule_path = /datum/nano_module/crew_monitor/unsc
	required_access = access_unsc
	available_on_ntnet = FALSE

/datum/nano_module/crew_monitor/unsc
	faction_name = "UNSC"
