
/obj/structure/stairs_decorative
	name = "Steps"
	desc = "A small set of steps."

	icon = 'code/modules/halo/structures/stairs_decorative.dmi'
	icon_state = "stairs"

	anchored = 1
	density = 0


/obj/structure/stairs_decorative/north
	dir = NORTH
	bound_height = 64
	bound_y = -32
	pixel_y = -32

/obj/structure/stairs_decorative/south
	dir = SOUTH
	bound_height = 64

/obj/structure/stairs_decorative/east
	dir = EAST
	bound_width = 64
	bound_x = -32
	pixel_x = -32

/obj/structure/stairs_decorative/west
	dir = WEST
	bound_width = 64
