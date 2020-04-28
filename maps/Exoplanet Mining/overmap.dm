/obj/effect/overmap/sector/exo_mining
	name = "PYK-248"
	icon = 'maps/Exoplanet Mining/sector_icon.dmi'
	icon_state = "mining_asteroid"

/obj/effect/overmap/sector/exo_mining/LateInitialize()
	. = ..()
	GLOB.overmap_tiles_uncontrolled -= range(28,src)
