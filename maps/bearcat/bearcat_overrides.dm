
/datum/computer_file/program/merchant //wild capitalism
	required_access = null

/turf/simulated/floor
	name = "bare deck"

/turf/simulated/floor/tiled
	name = "deck"

/decl/flooring/tiling
	name = "deck"

/turf/simulated/wall/r_wall/hull
	color = COLOR_DARK_BROWN

/obj/machinery/door/airlock/hatch/autoname

/obj/machinery/door/airlock/hatch/autoname/Initialize()
	. = ..()
	var/area/A = get_area(src)
	SetName("hatch ([A.name])")

/obj/machinery/door/airlock/hatch/autoname/general
	stripe_color = COLOR_CIVIE_GREEN

/obj/machinery/door/airlock/hatch/autoname/maintenance
	stripe_color = COLOR_AMBER

/obj/machinery/door/airlock/hatch/autoname/command
	stripe_color = COLOR_COMMAND_BLUE

/obj/machinery/door/airlock/hatch/autoname/engineering
	stripe_color = COLOR_AMBER