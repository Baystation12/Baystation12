/obj/effect/overmap/ship/CCV_comet
	name = "Civilian Vessel"
	desc = "A Civilian vessel with a traditional cargo-hauler design."

	icon = 'maps/first_contact/freighter.dmi'
	icon_state = "ship"
	fore_dir = WEST

	map_bounds = list(102,160,154,117)

/obj/effect/overmap/ship/CCV_star
	name = "Civilian Vessel"
	desc = "A Civilian vessel with a traditional cargo-hauler design."

	icon = 'maps/first_contact/freighter.dmi'
	icon_state = "ship"
	fore_dir = WEST
	vessel_mass = 5


	map_bounds = list(102,160,154,117) //Aah standardised designs.

/obj/effect/overmap/ship/CCV_sbs
	name = "CCV Slow But Steady"
	desc = "A cargo freighter with a safer, isolated design."

	icon = 'maps/first_contact/slowbutsteady.dmi'
	icon_state = "ship"
	fore_dir = WEST
	vessel_mass = 4


	map_bounds = list(7,49,73,27)

/obj/effect/overmap/ship/unsc_corvette
	name = "URFS Thorn"
	desc = "A standard contruction-model corvette. Seems to have taken some battle damage."

	icon = 'maps/first_contact/corvette.dmi'
	icon_state = "ship"
	fore_dir = WEST
	vessel_mass = 2.75

	map_bounds = list(2,76,76,26)

/obj/effect/overmap/ship/CCV_deliverance
	name = "CCV Deliverance"
	desc = "An unarmed medical freighter with a safer, isolated design and a traditional white paintjob."

	icon = 'maps/first_contact/deliverance.dmi'
	icon_state = "ship"
	fore_dir = WEST
	vessel_mass = 5

	map_bounds = list(9,52,70,25)

/obj/effect/overmap/ship/unsc_frigate
	name = "UNSC Heavens Above"
	desc = "A frigate in service of the UNSC"

	fore_dir = EAST

	icon = 'maps/unsc_frigate/frigate.dmi'
	icon_state = "base"

	pixel_x = -32
	pixel_y = -32

	map_bounds = list(23,165,232,91) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

/obj/effect/landmark/dropship_land_point/frigate_hangar
	name = "UNSC Frigate Hangar"
	faction = "unsc"

/obj/effect/landmark/dropship_land_point/frigate_hangar/north
	name = "UNSC Frigate Hangar - North"

/obj/effect/landmark/dropship_land_point/frigate_hangar/south
	name = "UNSC Frigate Hangar - South"

/obj/machinery/overmap_weapon_console/deck_gun_control/local/comet
	deck_gun_area = /area/om_ships/comet

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control/comet
	deck_gun_area = /area/om_ships/comet/cometrockets


