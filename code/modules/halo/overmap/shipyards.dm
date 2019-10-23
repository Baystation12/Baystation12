
/obj/effect/overmap/ship/npc_ship/shipyard
	name = "Shipyard"
	desc = "A shipyard equpped with a variety of repair equipment. Repairs ships."

	icon = 'code/modules/halo/icons/overmap/faction_misc.dmi'
	icon_state = "SMAC"

	ship_name_list = list()

	messages_on_hit = list("Automated Shipyard taking fire!")

	messages_on_death = list("All systems critical. Escape pods are away.")

	available_ship_requests = newlist(/datum/npc_ship_request/shipyard_repair)

	var/list/templates_available = list() //FORMAT: ship typepath = base mapfile path, omitting .dmm. Multi-z entries should be placed in order of high to low.

	var/next_repair_at = 0

/obj/effect/overmap/ship/npc_ship/shipyard/pick_target_loc()
	target_loc = loc

/obj/effect/overmap/ship/npc_ship/shipyard/unsc
	icons_pickfrom_list = list()
	templates_available = list(/obj/effect/overmap/ship/unscironwill = "maps/UNSC_Iron_Will/UNSC_Iron_Will")

	faction = "UNSC"
	radio_channel = "FLEETCOM"

/obj/effect/overmap/ship/npc_ship/shipyard/unsc/generate_ship_name()
	name = "Shipyard [pick("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "Kilo", "Lima", "Mike", "Sierra", "Tango", "Uniform", "Whiskey", "X-ray", "Zulu", "kappa","sigma","antaeres","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")]-[rand(100,999)]"

/obj/effect/overmap/ship/npc_ship/shipyard/cov
	icons_pickfrom_list = list()
	icon_state = "cov_defenseplatform"

	faction = "Covenant"
	radio_language = "Sangheili"
	radio_channel = "BattleNet"

	templates_available = list(/obj/effect/overmap/ship/covenant_corvette = "maps/Covenant Corvette/DAV_Vindicative_Infraction")

	available_ship_requests = newlist(/datum/npc_ship_request/shipyard_repair/cov)

/obj/effect/overmap/ship/npc_ship/shipyard/cov/generate_ship_name()
	name = "Shipyard"

