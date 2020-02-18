
/obj/effect/overmap/sector/geminus_city
	name = "Geminus Colony"
	icon = 'maps/geminus_city/sector_icon.dmi'
	desc = "A temperate, lightly forested world with deposits of valuable ore and a large human colony."
	icon_state = "geminus"

	map_bounds = list(1,160,175,1)

	overmap_spawn_in_me = list()

	faction = "Human Colony"
	base = 1
	block_slipspace = 1

	parent_area_type = /area/planets/Geminus

/obj/effect/overmap/sector/geminus_city/LateInitialize()
	. = ..()
	GLOB.overmap_tiles_uncontrolled -= range(28,src)

/obj/structure/co_ord_console/vt9_gc
	icon = 'code/modules/halo/icons/machinery/computer.dmi'
	icon_state = "comm"
	known_locations = list(/obj/effect/overmap/sector/geminus_city = "Geminus City Colony")
