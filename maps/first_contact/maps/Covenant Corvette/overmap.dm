
/obj/effect/overmap/ship/covenant_corvette
	name = "SDV Vindicative Infraction"
	desc = "The sillhouette of this ship matches no known ship signatures"

	icon = 'maps/first_contact/maps/Covenant Corvette/Corvette2.dmi'
	icon_state = "ship"
	fore_dir = WEST
	vessel_mass = 3

	//THIS MUST BE SET TO START AND END OUTSIDE THE SHIP OR ELSE THE MISSLES SPONTANEOUSLY APPEAR INSIDE THE HULL
	map_bounds = list(25,102,144,50) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

/obj/effect/overmap/ship/covenant_corvette/New()
	. = ..()
	GLOB.processing_objects += src

/obj/effect/overmap/ship/covenant_corvette/process()
	. = ..()
	if(is_still())
		animate(src,alpha = 15,time = 2 SECONDS) //Hard to see if sat still.
	else
		animate(src,alpha = 255, time = 2 SECONDS)

//overmap weapons//
/obj/machinery/overmap_weapon_console/deck_gun_control/local/cov_pulse_turretport/kig_yar_corvette
	deck_gun_area = /area/covenant_corvette/pulse_lasersport

/obj/machinery/overmap_weapon_console/deck_gun_control/local/cov_pulse_turretstarboard/kig_yar_corvette
	deck_gun_area = /area/covenant_corvette/pulse_lasersstarboard