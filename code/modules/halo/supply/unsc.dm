


/* MODULAR COMPUTER */

/obj/item/modular_computer/console/unsc/supply
	name = "UNSC Supply Computer"

/obj/item/modular_computer/console/unsc/supply/install_default_hardware()
	..()
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)

/obj/item/modular_computer/console/unsc/supply/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/faction_supply/unsc())
	set_autorun("supply_unsc")



/* MODULAR COMPUTER PROGRAM */

/datum/computer_file/program/faction_supply/unsc
	filename = "supply_unsc"
	nanomodule_path = /datum/nano_module/program/faction_supply/unsc

/datum/nano_module/program/faction_supply/unsc
	name = "UNSC supply management program"
	faction_name = "UNSC"
	shuttle_name = "UNSC Supply Shuttle"
	req_access = access_unsc_cargo



/* SHUTTLE OFFSITE */

/area/shuttle/unsc_offsite_supply
	name = "UNSC Supply Offsite"
	icon_state = "shuttle2"
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/unsc_offsite_supply
	name = "UNSC Supply Offsite"
	landmark_tag = "unsc_offsite_supply"
	base_area = /area/shuttle/unsc_offsite_supply
	base_turf = /turf/simulated/floor/plating



/* SHUTTLE ONSITE */

/area/shuttle/unsc_onsite_supply
	name = "UNSC Supply Berth"
	icon_state = "shuttle"
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/unsc_onsite_supply
	name = "UNSC Supply Berth"
	landmark_tag = "unsc_onsite_supply"
	base_area = /area/shuttle/unsc_onsite_supply
	base_turf = /turf/simulated/floor/plating



/* SHUTTLE */

/area/shuttle/unsc_shuttle_supply
	name = "UNSC Supply Shuttle"
	icon_state = "shuttle3"
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/datum/shuttle/autodock/ferry/trade/unsc
	name = "UNSC Supply Shuttle"
	shuttle_area = /area/shuttle/unsc_shuttle_supply
	waypoint_station = "unsc_onsite_supply"
	waypoint_offsite = "unsc_offsite_supply"

//todo: let it choose any account
/datum/shuttle/autodock/ferry/trade/unsc/New()
	. = ..()
	money_account = GLOB.UNSC.money_account



/* SUPPLY ORDER */

/datum/nano_module/program/faction_supply/unsc/supply_order_flavour(var/datum/supply_order/O)
	O.destination = GLOB.UNSC.get_hq_name()
	O.stamp_id = "paper_stamp-cent"
	O.order_title = "UNSC Resupply Shipment"
