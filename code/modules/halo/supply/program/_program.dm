#define SCREEN_LOGIN 0
#define SCREEN_BROWSE 1
#define SCREEN_STATS 2
#define SCREEN_SHUTTLE 3
#define SCREEN_ORDERS 4

/datum/computer_file/program/faction_supply
	filename = "supply_generic"
	filedesc = "Supply Management"
	program_icon_state = "supply"
	nanomodule_path = /datum/nano_module/program/faction_supply
	extended_desc = "A management tool that allows for ordering of various supplies through the cargo system."
	size = 21
	requires_ntnet = 1
	requires_ntnet_feature = NTNET_COMMUNICATION
	available_on_ntnet = 0
	available_on_syndinet = 1

/datum/nano_module/program/faction_supply
	name = "Generic supply management program"
	var/screen = 0
	var/selected_category
	var/emagged = FALSE	// TODO: Implement synchronisation with modular computer framework.
	var/shuttle_name
	var/datum/shuttle/autodock/ferry/trade/my_shuttle
	var/faction_name
	var/datum/faction/my_faction
	var/list/req_access = list()
	var/datum/money_account/current_account

/datum/nano_module/program/faction_supply/New()
	. = ..()
	//locate our shuttle
	var/datum/shuttle/S = shuttle_controller.shuttles[shuttle_name]
	if(S)
		//only if we are on the same zlevel as it
		var/obj/host_device = nano_host()
		var/obj/effect/shuttle_landmark/L = S.current_location
		if(L.z == host_device.z)
			my_shuttle = S

	//locate our faction
	my_faction = GLOB.factions_by_name[faction_name]
	if(my_faction)
		current_account = my_faction.money_account
