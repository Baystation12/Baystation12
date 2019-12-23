
/obj/effect/overmap/ship/npc_ship/shipyard
	name = "Shipyard"
	desc = "A shipyard equpped with a variety of repair equipment. Repairs ships."

	icon = 'code/modules/halo/icons/overmap/32x32 Overmap Space Station.dmi'
	icon_state = "Static Station"

	anchored = 1

	ship_name_list = list()

	messages_on_hit = list("Automated Shipyard taking fire!")

	messages_on_death = list("All systems critical. Escape pods are away.")

	available_ship_requests = newlist(/datum/npc_ship_request/shipyard_repair)

	var/list/templates_available = list() //FORMAT: ship typepath = base mapfile path, omitting .dmm. Multi-z entries should be placed in order of high to low.

	var/next_repair_at = 0

/obj/effect/overmap/ship/npc_ship/shipyard/New()
	. = ..()
	GLOB.overmap_tiles_uncontrolled -= range(14,src)

/obj/effect/overmap/ship/npc_ship/shipyard/pick_target_loc()
	target_loc = loc

//PLACEHOLDER TYPEPATHS//
/obj/effect/overmap/ship/unsclightbrigade
/obj/effect/overmap/ship/covenant_light_cruiser
/obj/effect/overmap/ship/oni_aegis

/obj/effect/overmap/ship/npc_ship/shipyard/unsc
	icons_pickfrom_list = list()
	templates_available = list(/obj/effect/overmap/ship/unsclightbrigade = "maps/UNSC_Halberd_Class/UNSC_Light_Brigade")

	faction = "UNSC"
	radio_channel = "SHIPCOM"

/obj/effect/overmap/ship/npc_ship/shipyard/unsc/generate_ship_name()
	name = "Shipyard [pick("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "Kilo", "Lima", "Mike", "Sierra", "Tango", "Uniform", "Whiskey", "X-ray", "Zulu", "kappa","sigma","antaeres","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")]-[rand(100,999)]"

/obj/effect/overmap/ship/npc_ship/shipyard/cov
	icons_pickfrom_list = list()
	icon = 'code/modules/halo/icons/overmap/faction_misc.dmi'
	icon_state = "cov_defenseplatform"

	faction = "Covenant"
	radio_language = "Sangheili"
	radio_channel = "BattleNet"

	templates_available = list(/obj/effect/overmap/ship/covenant_light_cruiser = "maps/CRS_Unyielding_Transgression/CRS_Unyielding_Transgression")

	available_ship_requests = newlist(/datum/npc_ship_request/shipyard_repair/insecure/cov)

/obj/effect/overmap/ship/npc_ship/shipyard/cov/generate_ship_name()
	name = "Shipyard"

