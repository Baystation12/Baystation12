#define GRID_WIDTH 3

var/datum/controller/subsystem/parallax/SSparallax

/datum/controller/subsystem/parallax
	name = "Space Parallax"
	priority = 16
	flags = SS_NO_FIRE

	var/list/parallax_icon[(GRID_WIDTH**2)*3]
	var/parallax_initialized = 0

/datum/controller/subsystem/parallax/New()
	NEW_SS_GLOBAL(SSparallax)

/datum/controller/subsystem/parallax/Initialize(timeofday)
	create_global_parallax_icons()
	..(timeofday, TRUE)

#undef GRID_WIDTH