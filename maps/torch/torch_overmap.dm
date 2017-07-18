/obj/effect/overmap/ship/torch
	name = "SEV Torch"
	fore_dir = WEST
	vessel_mass = 800
	default_delay = 12 SECONDS
	landing_areas = list(/area/aquila_hangar/start, /area/calypso_hangar/start, /area/guppy_hangar/start,
						 /area/aquila_hangar/fourthdeck, /area/calypso_hangar/fourthdeck, /area/guppy_hangar/fourthdeck,
						 /area/aquila_hangar/thirddeck, /area/calypso_hangar/thirddeck, /area/guppy_hangar/thirddeck,
						 /area/aquila_hangar/seconddeck, /area/calypso_hangar/seconddeck, /area/guppy_hangar/seconddeck,
						 /area/aquila_hangar/firstdeck, /area/calypso_hangar/firstdeck, /area/guppy_hangar/firstdeck,
						 /area/aquila_hangar/bridge, /area/calypso_hangar/bridge, /area/guppy_hangar/bridge)

/obj/effect/overmap/sector/cluster
	name = "asteroid cluster"
	desc = "Large group of asteroids. Mineral content detected."
	icon_state = "sector"


	landing_areas = list(/area/aquila_hangar/mining, /area/calypso_hangar/mining, /area/guppy_hangar/mining)

/obj/effect/overmap/sector/derelict
	name = "debris field"
	desc = "A large field of miscellanious debris."
	icon_state = "object"


	landing_areas = list(/area/aquila_hangar/salvage, /area/calypso_hangar/salvage, /area/guppy_hangar/salvage)

/obj/effect/overmap/sector/away
	name = "faint signal"
	desc = "Faint signal detected, originating from the site's surface."
	icon_state = "sector"


	landing_areas = list(/area/aquila_hangar/away, /area/calypso_hangar/away)

/obj/machinery/computer/shuttle_control/explore/aquila
	name = "aquila control console"
	shuttle_area = /area/aquila_hangar/start
	shuttle_tag = "Aquila"
	req_access = list(access_aquila_helm)

/obj/machinery/computer/shuttle_control/explore/calypso
	name = "calypso control console"
	shuttle_area = /area/calypso_hangar/start
	shuttle_tag = "Calypso"
	req_access = list(access_calypso_helm)

/obj/machinery/computer/shuttle_control/explore/guppy
	name = "guppy control console"
	shuttle_area = /area/guppy_hangar/start
	shuttle_tag = "Guppy"
	req_access = list(access_guppy_helm)