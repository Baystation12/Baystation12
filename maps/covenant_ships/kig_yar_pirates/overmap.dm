
/obj/effect/overmap/ship/kigyar_pirates
	name = "Unknown Vessel"
	desc = "The sillhouette of this ship matches no known ship signatures"

	icon = 'maps/covenant_ships/kig_yar_pirates/pirate.dmi'
	icon_state = "ship"
	fore_dir = WEST

	map_bounds = list(34,60,65,41) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

/obj/effect/overmap/ship/kigyar_pirates/New()
	. = ..()
	GLOB.processing_objects += src

/obj/effect/overmap/ship/kigyar_pirates/process()
	. = ..()
	if(is_still())
		animate(src,alpha = 127,time = 2 SECONDS) //Hard to see if sat still.
	else
		animate(src,alpha = 255, time = 2 SECONDS)

//overmap weapons//
/obj/machinery/overmap_weapon_console/deck_gun_control/local/cov_pulse_turret/kig_yar_pirate
	deck_gun_area = /area/kigyar_pirate/pulse_lasers

