
/obj/effect/overmap/ship/covenant_corvette
	name = "SDV Vindictive Infraction"
	desc = "The sillhouette of this ship matches no known ship signatures"

	icon = 'maps/first_contact/maps/Covenant Corvette/Corvette2.dmi'
	icon_state = "ship"
	fore_dir = WEST
	vessel_mass = 5

	faction = "Covenant"

	//THIS MUST BE SET TO START AND END OUTSIDE THE SHIP OR ELSE THE MISSLES SPONTANEOUSLY APPEAR INSIDE THE HULL
	map_bounds = list(25,102,144,50) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

//overmap weapons//
/obj/machinery/overmap_weapon_console/deck_gun_control/local/cov_pulse_turretport/kig_yar_corvette
	deck_gun_area = /area/covenant_corvette/pulse_lasersport

/obj/machinery/overmap_weapon_console/deck_gun_control/local/cov_pulse_turretstarboard/kig_yar_corvette
	deck_gun_area = /area/covenant_corvette/pulse_lasersstarboard

/obj/machinery/overmap_weapon_console/deck_gun_control/local/plastorp_control/cov_corvette
	deck_gun_area = /area/covenant_corvette/plastorps