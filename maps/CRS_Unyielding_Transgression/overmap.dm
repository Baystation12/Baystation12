
/obj/effect/overmap/ship/covenant_light_cruiser
	name = "CRS Unyielding Transgression"
	desc = "The silhouette of this ship matches no known ship signatures"

	icon = 'CRSlightcruiser.dmi'
	icon_state = "ship"
	fore_dir = WEST
	vessel_mass = 5

	faction = "Covenant"
	flagship = 1

	//THIS MUST BE SET TO START AND END OUTSIDE THE SHIP OR ELSE THE MISSLES SPONTANEOUSLY APPEAR INSIDE THE HULL
	map_bounds = list(2,114,139,44) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

	parent_area_type = /area/covenant_light_cruiser

	ship_max_speed = 2

//overmap weapons//
/obj/machinery/overmap_weapon_console/deck_gun_control/local/cov_pulse_turretport/covenant_light_cruiser
	deck_gun_area = /area/covenant_light_cruiser/pulse_lasersport

/obj/machinery/overmap_weapon_console/deck_gun_control/local/cov_pulse_turretstarboard/covenant_light_cruiser
	deck_gun_area = /area/covenant_light_cruiser/pulse_lasersstarboard

/obj/machinery/overmap_weapon_console/deck_gun_control/local/plastorp_control/covenant_light_cruiser_starboard
	deck_gun_area = /area/covenant_light_cruiser/plastorpsstarboard

/obj/machinery/overmap_weapon_console/deck_gun_control/local/plastorp_control/covenant_light_cruiser_port
	deck_gun_area = /area/covenant_light_cruiser/plastorpsport