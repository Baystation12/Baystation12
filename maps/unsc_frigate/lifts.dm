
/area/turbolift/unscfrigate/lifts
	name = "lift_base"

/area/turbolift/unscfrigate/lifts/lift_1_ground
	name = "Deck 4"

/area/turbolift/unscfrigate/lifts/lift_1_second
	name = "Deck 3"

/area/turbolift/unscfrigate/lifts/lift_1_third
	name = "Deck 2"

/area/turbolift/unscfrigate/lifts/lift_1_fourth
	name = "Deck 1"

/area/turbolift/unscfrigate/lifts/lift_2_ground
	name = "Deck 4"

/area/turbolift/unscfrigate/lifts/lift_2_second
	name = "Deck 3"

/area/turbolift/unscfrigate/lifts/lift_2_third
	name = "Deck 2"

/area/turbolift/unscfrigate/lifts/lift_3_third
	name = "Deck 2"

/area/turbolift/unscfrigate/lifts/lift_3_fourth
	name = "Deck 1"

/obj/turbolift_map_holder/cargolift/unsc_frigate
	dir = SOUTH
	depth = 4
	lift_size_x = 3
	lift_size_y = 3
	floor_type = /turf/simulated/floor/tiled/dark
	wall_type = /turf/simulated/floor/tiled/dark

	areas_to_use = list(/area/turbolift/unscfrigate/lifts/lift_1_ground,/area/turbolift/unscfrigate/lifts/lift_1_second,/area/turbolift/unscfrigate/lifts/lift_1_third,/area/turbolift/unscfrigate/lifts/lift_1_fourth)

/obj/turbolift_map_holder/cargolift/unsc_frigate/back
	dir = SOUTH
	depth = 3
	lift_size_x = 3
	lift_size_y = 3

	areas_to_use = list(/area/turbolift/unscfrigate/lifts/lift_2_ground,/area/turbolift/unscfrigate/lifts/lift_2_second,/area/turbolift/unscfrigate/lifts/lift_2_third)

/obj/turbolift_map_holder/cargolift/unsc_frigate/front
	dir = WEST
	depth = 2
	lift_size_x = 3
	lift_size_y = 3

	areas_to_use = list(/area/turbolift/unscfrigate/lifts/lift_3_third,/area/turbolift/unscfrigate/lifts/lift_3_fourth)
