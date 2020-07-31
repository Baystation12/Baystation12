


/* MODULAR COMPUTER */

/obj/item/modular_computer/console/preset/oni_supply
	name = "ONI Supply Computer"

/obj/item/modular_computer/console/preset/oni_supply/install_default_hardware()
	..()
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)

/obj/item/modular_computer/console/preset/oni_supply/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/faction_supply/oni())
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/email_client())

	set_autorun("supply_oni")



/* MODULAR COMPUTER PROGRAM */

/datum/computer_file/program/faction_supply/oni
	filename = "supply_oni"
	nanomodule_path = /datum/nano_module/program/faction_supply/oni

/datum/nano_module/program/faction_supply/oni
	name = "ONI supply management program"
	faction_name = "ONI"
	shuttle_name = "ONI Supply Shuttle"
	req_access = access_unsc_cargo



/* SHUTTLE OFFSITE */

/area/shuttle/oni_offsite_supply
	name = "ONI Supply Offsite"
	icon_state = "shuttle2"
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/oni_offsite_supply
	name = "ONI Supply Offsite"
	landmark_tag = "oni_offsite_supply"
	base_area = /area/shuttle/oni_offsite_supply
	base_turf = /turf/simulated/floor/plating



/* SHUTTLE ONSITE */

/area/shuttle/oni_onsite_supply
	name = "ONI Supply Berth"
	icon_state = "shuttle"
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/oni_onsite_supply
	name = "ONI Supply Berth"
	landmark_tag = "oni_onsite_supply"
	base_area = /area/shuttle/oni_onsite_supply
	base_turf = /turf/simulated/floor/plating



/* SHUTTLE */

/area/shuttle/oni_shuttle_supply
	name = "ONI Supply Shuttle"
	icon_state = "shuttle3"
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/datum/shuttle/autodock/ferry/trade/oni
	name = "ONI Supply Shuttle"
	shuttle_area = /area/shuttle/oni_shuttle_supply
	waypoint_station = "oni_onsite_supply"
	waypoint_offsite = "oni_offsite_supply"

//todo: let it choose any account
/datum/shuttle/autodock/ferry/trade/oni/New()
	. = ..()
	money_account = GLOB.ONI.money_account
