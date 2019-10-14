
/obj/effect/overmap/ship/unsc_frigate
	name = "UNSC Heavens Above"
	desc = "A frigate in service of the UNSC"

	fore_dir = EAST

	icon = 'maps/first_contact/maps/UNSC_Heaven_Above/frigate.dmi'
	icon_state = "ship"

	pixel_x = -32
	pixel_y = -32
	vessel_mass = 12

	map_bounds = list(4,99,142,52) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)
	//map_bounds = list(23,165,232,91) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

/obj/effect/landmark/dropship_land_point/frigate_hangar
	name = "UNSC Frigate Hangar"
	faction = "unsc"

/obj/effect/landmark/dropship_land_point/frigate_hangar/north
	name = "UNSC Frigate Hangar - North"

/obj/effect/landmark/dropship_land_point/frigate_hangar/south
	name = "UNSC Frigate Hangar - South"

