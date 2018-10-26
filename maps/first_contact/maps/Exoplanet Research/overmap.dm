/obj/effect/overmap/sector/exo_research
	name = "VT9-042"
	icon = 'maps/first_contact/maps/Exoplanet Research/sector_icon.dmi'
	icon_state = "research"

	weapon_locations = list(1,150,150,1) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

/obj/effect/overmap/sector/exo_research/New()

	GLOB.processing_objects += src


/obj/effect/overmap/sector/exo_research/process()

	if(15<=hit)
		src.icon_state="bombed"