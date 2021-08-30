/obj/effect/overmap/visitable/ship/torch
	name = "SEV Torch"
	desc = "A frankensteined HNS Mako-class corvette, broadcasting SCGEC codes and the designation \"SEV Torch, HSC-4-13-X\"."
	fore_dir = WEST
	vessel_mass = 100000
	burn_delay = 2 SECONDS
	base = TRUE

	initial_restricted_waypoints = list(
		"Charon" = list("nav_hangar_calypso"), 	//can't have random shuttles popping inside the ship
		"Guppy" = list("nav_hangar_guppy"),
		"Aquila" = list("nav_hangar_aquila"),
		"Skrellian Scout" = list("nav_skrellscout_dock"), //restricts Skrell Scoutship specific docking waypoint on deck 4 portside
		"Skrellian Shuttle" = list("nav_skrellscoutsh_altdock"),
		"Rescue" = list("nav_ert_dock"), //restricts ERT Shuttle specific docking waypoint on deck 4 portside
		"ITV The Reclaimer" = list("nav_hangar_gantry_torch"), //gantry shuttles
		"ITV Vulcan" = list("nav_hangar_gantry_torch_two"),
		"ITV Spiritus" = list("nav_hangar_gantry_torch_three"),
		"SRV Venerable Catfish" = list("nav_verne_5"), //docking location for verne shuttle
		"Cyclopes" = list("nav_merc_dock")
	)

	initial_generic_waypoints = list(
		//start Bridge Deck
		"nav_merc_deck5",
		"nav_ninja_deck5",
		"nav_skipjack_deck5",
		"nav_ert_deck5",
		"nav_bridge_calypso",
		"nav_bridge_guppy",
		"nav_bridge_aquila",

		//start First Deck
		"nav_merc_deck1",
		"nav_ninja_deck1",
		"nav_skipjack_deck1",
		"nav_ert_deck4",
		"nav_deck4_calypso",
		"nav_deck4_guppy",
		"nav_deck4_aquila",

		//start Second Deck
		"nav_merc_deck2",
		"nav_ninja_deck2",
		"nav_skipjack_deck2",
		"nav_ert_deck3",
		"nav_deck3_calypso",
		"nav_deck3_guppy",
		"nav_deck3_aquila",

		//start Third Deck
		"nav_merc_deck3",
		"nav_ninja_deck3",
		"nav_skipjack_deck3",
		"nav_ert_deck2",
		"nav_deck2_calypso",
		"nav_deck2_guppy",
		"nav_deck2_aquila",

		//start Forth Deck
		"nav_merc_deck4",
		"nav_ninja_deck4",
		"nav_skipjack_deck4",
		"nav_ert_deck1",
		"nav_deck1_calypso",
		"nav_deck1_guppy",
		"nav_deck1_aquila",

		//start Hanger Deck
		"nav_merc_hanger",
		"nav_ninja_hanger",
		"nav_skipjack_hanger",
		"nav_ert_hanger",
	)

/obj/effect/overmap/visitable/ship/landable/exploration_shuttle
	name = "Charon"
	desc = "An SSE-U11 long range shuttle, broadcasting SCGEC codes and the callsign \"Torch-2 Charon\"."
	shuttle = "Charon"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = NORTH
	skill_needed = SKILL_BASIC
	vessel_size = SHIP_SIZE_SMALL

/obj/effect/overmap/visitable/ship/landable/aquila
	name = "Aquila"
	desc = "A PM-24 modular transport, broadcasting SCGEC codes and the callsign \"Torch-1 Aquila\"."
	shuttle = "Aquila"
	vessel_mass = 10000
	max_speed = 1/(1 SECONDS)
	burn_delay = 0.5 SECONDS //spammable, but expensive
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL

/obj/effect/overmap/visitable/ship/landable/guppy
	name = "Guppy"
	desc = "An SSE-U3 utility pod, broadcasting SCGEC codes and the callsign \"Torch-3 Guppy\"."
	shuttle = "Guppy"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	skill_needed = SKILL_BASIC
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/aquila
	name = "aquila control console"
	shuttle_tag = "Aquila"
	req_access = list(access_aquila_helm)

/obj/machinery/computer/shuttle_control/explore/exploration_shuttle
	name = "shuttle control console"
	shuttle_tag = "Charon"
	req_access = list(access_expedition_shuttle_helm)

/obj/machinery/computer/shuttle_control/explore/guppy
	name = "guppy control console"
	shuttle_tag = "Guppy"
	req_access = list(access_guppy_helm)

/obj/effect/overmap/visitable/ship/torch/Initialize()
	. = ..()

	var/obj/effect/overmap/visitable/sector/residue/R = new()
	R.forceMove(locate(src.x, src.y, GLOB.using_map.overmap_z))

	for(var/obj/machinery/computer/ship/helm/H in SSmachines.machinery)
		H.add_known_sector(R)

/obj/effect/overmap/visitable/sector/residue
	name = "Bluespace Residue"
	desc = "Trace radiation emanating from this sector is consistent with the aftermath of a bluespace jump."
	icon_state = "event"
	known = TRUE
