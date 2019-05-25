/area/turbolift/KS7535/lifts/lift_1_ground
	name = "Sublevel 1"
	requires_power= 0
	has_gravity = 1


/area/turbolift/KS7535/lifts/lift_1_second
	name = "Ground Level"
	requires_power= 0
	has_gravity = 1


/obj/turbolift_map_holder/cargolift/KS7535/front
	dir = SOUTH
	depth = 2
	lift_size_x = 4
	lift_size_y = 3

	areas_to_use = list(/area/turbolift/research/lifts/lift_1_ground,/area/turbolift/research/lifts/lift_1_second)