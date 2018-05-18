
/obj/structure/dropship/pelican
	name = "D77-TC Pelican"
	desc = "A versatile aircraft used by the UNSC for medium-lift operations of personnel, vehicles and equipment. It can also be used as a support gunship."

	icon = 'code/modules/halo/shuttles/pelican.dmi'
	icon_state = "base"

	density = 1

	bound_height = 64
	bound_width = 64

	pixel_x = -64
	pixel_y = -64

	takeoff_overlay_icon_state = "thrust"
	takeoff_sound = 'code/modules/halo/shuttles/pelican_takeoff.ogg'

	max_occupants = 14

	enter_time = 3
	takeoff_time = 5

/obj/structure/dropship/overmap/pelican
	name = "D77-TC Pelican"
	desc = "A versatile aircraft used by the UNSC for medium-lift operations of personnel, vehicles and equipment. It can also be used as a support gunship."

	icon = 'code/modules/halo/shuttles/pelican.dmi'
	icon_state = "base"

	density = 1

	bound_height = 64
	bound_width = 64

	pixel_x = -64
	pixel_y = -64

	takeoff_overlay_icon_state = "thrust"
	takeoff_sound = 'code/modules/halo/shuttles/pelican_takeoff.ogg'

	max_occupants = 14

	enter_time = 3
	takeoff_time = 5

	overmap_range = 1

/obj/structure/dropship/pelican/civ
	desc = "A versatile aircraft usually used by the UNSC. This one has been modified to allow for fast transit between Civilian endpoints."
	faction = "Civilian"

/obj/structure/dropship/pelican/innie
	desc = "A versatile aircraft usually used by the UNSC. This one has been modified to allow for fast transit between Civilian endpoints. This one appears to have a red fist on the wings."
	faction = "innie"

/obj/structure/dropship/overmap/pelican/unsc
	faction = "unsc"
