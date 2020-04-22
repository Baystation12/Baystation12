
/obj/effect/overmap/ship/kigyar_pirates
	name = "Kig-Yar Raider"
	desc = "A few references to this vessel's ship-signature are present within outer-colony trading databases."

	icon = 'maps/kig_yar_pirates/pirate.dmi'
	icon_state = "ship"
	fore_dir = EAST
	vessel_mass = 3

	faction = "Covenant"

	//THIS MUST BE SET TO START AND END OUTSIDE THE SHIP OR ELSE THE MISSLES SPONTANEOUSLY APPEAR INSIDE THE HULL
	map_bounds = list(27,68,79,32) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

//overmap weapons//
/obj/machinery/overmap_weapon_console/deck_gun_control/local/cov_pulse_turret/kig_yar_pirate
	deck_gun_area = /area/kigyar_pirate/pulse_lasers

/obj/effect/overmap/ship/kigyar_missionary
	name = "Kig-Yar Missionary Vessel"
	desc = "A few references to this vessel's ship-signature are present within outer-colony trading databases."

	icon = 'maps/kig_yar_pirates/missionary.dmi'
	icon_state = "ship"
	fore_dir = EAST
	vessel_mass = 3

	//THIS MUST BE SET TO START AND END OUTSIDE THE SHIP OR ELSE THE MISSLES SPONTANEOUSLY APPEAR INSIDE THE HULL
	map_bounds = list(31,98,118,58) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)