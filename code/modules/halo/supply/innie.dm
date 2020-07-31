


/* MODULAR COMPUTER */

/obj/item/modular_computer/console/preset/innie_supply
	name = "Insurrection Supply Computer"

/obj/item/modular_computer/console/preset/innie_supply/install_default_hardware()
	..()
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)

/obj/item/modular_computer/console/preset/innie_supply/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/faction_supply/innie())
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/email_client())

	set_autorun("supply_innie")



/* MODULAR COMPUTER PROGRAM */

/datum/computer_file/program/faction_supply/innie
	filename = "supply_innie"
	nanomodule_path = /datum/nano_module/program/faction_supply/innie

/datum/nano_module/program/faction_supply/innie
	name = "Insurrection supply management program"
	faction_name = "Insurrection"
	shuttle_name = "Insurrection Supply Shuttle"
	req_access = access_innie_boss



/* SHUTTLE OFFSITE */

/area/shuttle/innie_offsite_supply
	name = "Insurrection Supply Offsite"
	icon_state = "shuttle2"
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/innie_offsite_supply
	name = "Insurrection Supply Offsite"
	landmark_tag = "innie_offsite_supply"
	base_area = /area/shuttle/innie_offsite_supply
	base_turf = /turf/simulated/floor/plating



/* SHUTTLE ONSITE */

/area/shuttle/innie_onsite_supply
	name = "Insurrection Supply Berth"
	icon_state = "shuttle"
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/innie_onsite_supply
	name = "Insurrection Supply Berth"
	landmark_tag = "innie_onsite_supply"
	base_area = /area/shuttle/innie_onsite_supply
	base_turf = /turf/simulated/floor/plating



/* SHUTTLE */

/area/shuttle/innie_shuttle_supply
	name = "Insurrection Supply Shuttle"
	icon_state = "shuttle3"
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/datum/shuttle/autodock/ferry/trade/innie
	name = "Insurrection Supply Shuttle"
	shuttle_area = /area/shuttle/innie_shuttle_supply
	waypoint_station = "innie_onsite_supply"
	waypoint_offsite = "innie_offsite_supply"
	spawn_trader_type = /mob/living/simple_animal/npc/colonist/weapon_smuggler

//todo: let it choose any account
/datum/shuttle/autodock/ferry/trade/innie/New()
	. = ..()
	money_account = GLOB.INNIE.money_account
