
/obj/effect/overmap/ship/kigyar_pirates
	name = "Unknown Vessel"
	desc = "The sillhouette of this ship matches no known ship signatures"

	icon = 'maps/covenant_ships/kig_yar_pirates/pirate.dmi'
	icon_state = "ship"

/obj/effect/overmap/ship/kigyar_pirates/New()
	. = ..()
	GLOB.processing_objects += src

/obj/effect/overmap/ship/kigyar_pirates/process()
	. = ..()
	if(is_still())
		animate(src,alpha = 10) //Hard to see if sat still.
	else
		animate(src,alpha = 255)
