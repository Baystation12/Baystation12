
/obj/item/modular_computer/console/covenant/crew
	name = "Crew monitoring console"

/obj/item/modular_computer/console/covenant/crew/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/suit_sensors/covenant())
	set_autorun("sensormonitor_covenant")

/datum/computer_file/program/suit_sensors/covenant
	filename = "sensormonitor_covenant"
	nanomodule_path = /datum/nano_module/crew_monitor/covenant
	required_access = access_covenant
	available_on_ntnet = FALSE
	program_icon_state = "covie_console_overlay"
	camera_icon_state = "covie_console_overlay"

/datum/nano_module/crew_monitor/covenant
	faction_name = "Covenant"

/datum/nano_module/crew_monitor/covenant/apply_styling(datum/nanoui/ui)
	ui.set_layout_key("covenant")
