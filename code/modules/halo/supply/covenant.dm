


/* MODULAR COMPUTER */

/obj/item/modular_computer/console/preset/covenant_supply
	name = "Covenant Supply Computer"
	icon = 'code/modules/halo/covenant/structures_machines/consoles.dmi'
	icon_state = "covie_console_off"
	icon_state_unpowered = "covie_console_off"
	icon_state_screensaver = "covie_console_overlay_on"
	icon_state_menu = "covie_console_overlay_on"

/obj/item/modular_computer/console/preset/covenant_supply/install_default_hardware()
	..()
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)

/obj/item/modular_computer/console/preset/covenant_supply/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/faction_supply/covenant())
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/email_client())

	set_autorun("supply_covenant")



/* MODULAR COMPUTER PROGRAM */

/datum/computer_file/program/faction_supply/covenant
	filename = "supply_covenant"
	nanomodule_path = /datum/nano_module/program/faction_supply/covenant
	program_icon_state = "covie_console_overlay"

/datum/nano_module/program/faction_supply/covenant
	name = "Covenant supply management program"
	faction_name = "Covenant"
	shuttle_name = "Covenant Supply Shuttle"
	req_access = access_covenant_cargo

/datum/nano_module/program/faction_supply/covenant/apply_styling(datum/nanoui/ui)
	ui.set_layout_key("covenant")


/* SHUTTLE OFFSITE */

/area/shuttle/covenant_offsite_supply
	name = "Covenant Supply Offsite"
	icon_state = "shuttle2"
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/covenant_offsite_supply
	name = "Covenant Supply Offsite"
	landmark_tag = "covenant_offsite_supply"
	base_area = /area/shuttle/covenant_offsite_supply
	base_turf = /turf/simulated/floor/plating



/* SHUTTLE ONSITE */

/area/shuttle/covenant_onsite_supply
	name = "Covenant Supply Berth"
	icon_state = "shuttle"
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/covenant_onsite_supply
	name = "Covenant Supply Berth"
	landmark_tag = "covenant_onsite_supply"
	base_area = /area/shuttle/covenant_onsite_supply
	base_turf = /turf/simulated/floor/plating



/* SHUTTLE */

/area/shuttle/covenant_shuttle_supply
	name = "Covenant Supply Shuttle"
	icon_state = "shuttle3"
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/datum/shuttle/autodock/ferry/trade/covenant
	name = "Covenant Supply Shuttle"
	shuttle_area = /area/shuttle/covenant_shuttle_supply
	waypoint_station = "covenant_onsite_supply"
	waypoint_offsite = "covenant_offsite_supply"

//todo: let it choose any account
/datum/shuttle/autodock/ferry/trade/covenant/New()
	. = ..()
	money_account = GLOB.COVENANT.money_account



/* SUPPLY ORDER */

/datum/nano_module/program/faction_supply/covenant/supply_order_flavour(var/datum/supply_order/O)
	O.destination = GLOB.COVENANT.get_hq_name()
	O.stamp_id = "paper_stamp-cent"
	O.order_title = "Covenant Resupply Shipment"
