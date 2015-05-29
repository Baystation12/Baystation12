//This file contain all pipe based basiss. No many, no more!

/obj/machinery/atmospherics/pipe

	var/datum/gas_mixture/air_temporary //used when reconstructing a pipeline that broke
	var/datum/pipeline/parent

	var/volume = 0
	force = 20

	layer = 2.4 //under wires with their 2.44
	use_power = 0

	can_buckle = 1
	buckle_require_restraints = 1
	buckle_lying = -1

	volume = ATMOS_DEFAULT_VOLUME_PIPE

	dir = SOUTH

	var/minimum_temperature_difference = 300
	var/thermal_conductivity = 0 //WALL_HEAT_TRANSFER_COEFFICIENT No

	var/maximum_pressure = 70*ONE_ATMOSPHERE
	var/fatigue_pressure = 55*ONE_ATMOSPHERE
	var/alert_pressure = 80*ONE_ATMOSPHERE

	level = 2

/obj/machinery/atmospherics/pipe/simple
	icon = 'icons/atmos/pipes.dmi'
	icon_state = ""
	var/pipe_icon = "" //what kind of pipe it is and from which dmi is the icon manager getting its icons, "" for simple pipes, "hepipe" for HE pipes, "hejunction" for HE junctions
	name = "pipe"
	desc = "A one meter section of regular pipe"

	volume = ATMOS_DEFAULT_VOLUME_PIPE

	dir = SOUTH
	init_dirs = SOUTH|NORTH

	minimum_temperature_difference = 300
	thermal_conductivity = 0 //WALL_HEAT_TRANSFER_COEFFICIENT No

	maximum_pressure = 70*ONE_ATMOSPHERE
	fatigue_pressure = 55*ONE_ATMOSPHERE
	alert_pressure = 55*ONE_ATMOSPHERE

	level = 1

/obj/machinery/atmospherics/pipe/simple/visible
	icon_state = "intact"
	level = 2

/obj/machinery/atmospherics/pipe/simple/visible/scrubbers
	name = "Scrubbers pipe"
	desc = "A one meter section of scrubbers pipe"
	icon_state = "intact-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 2.38
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/visible/supply
	name = "Air supply pipe"
	desc = "A one meter section of supply pipe"
	icon_state = "intact-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 2.39
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/simple/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/simple/visible/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/simple/visible/purple
	color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/simple/visible/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/visible/blue
	color = PIPE_COLOR_BLUE


/obj/machinery/atmospherics/pipe/simple/hidden
	icon_state = "intact"
	level = 1
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/machinery/atmospherics/pipe/simple/hidden/scrubbers
	name = "Scrubbers pipe"
	desc = "A one meter section of scrubbers pipe"
	icon_state = "intact-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 2.38
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/hidden/supply
	name = "Air supply pipe"
	desc = "A one meter section of supply pipe"
	icon_state = "intact-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 2.39
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/simple/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/simple/hidden/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/simple/hidden/purple
	color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/simple/hidden/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/insulated
	icon = 'icons/obj/atmospherics/red_pipe.dmi'
	icon_state = "intact"

	minimum_temperature_difference = 10000
	thermal_conductivity = 0
	maximum_pressure = 1000*ONE_ATMOSPHERE
	fatigue_pressure = 900*ONE_ATMOSPHERE
	alert_pressure = 900*ONE_ATMOSPHERE

	level = 2

//------------
/obj/machinery/atmospherics/pipe/bent
	icon = 'icons/atmos/pipes.dmi'
	icon_state = ""
	var/pipe_icon = "" //what kind of pipe it is and from which dmi is the icon manager getting its icons, "" for bent pipes, "hepipe" for HE pipes, "hejunction" for HE junctions
	name = "pipe"
	desc = "A one meter section of regular pipe"

	volume = ATMOS_DEFAULT_VOLUME_PIPE

	dir = 2
	init_dirs = 1|8

	minimum_temperature_difference = 300
	thermal_conductivity = 0 //WALL_HEAT_TRANSFER_COEFFICIENT No

	maximum_pressure = 70*ONE_ATMOSPHERE
	fatigue_pressure = 55*ONE_ATMOSPHERE
	alert_pressure = 55*ONE_ATMOSPHERE

	level = 1

/obj/machinery/atmospherics/pipe/bent/visible
	icon_state = "bent"
	level = 2

/obj/machinery/atmospherics/pipe/bent/visible/scrubbers
	name = "Scrubbers pipe"
	desc = "A one meter section of scrubbers pipe"
	icon_state = "bent-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 2.38
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/bent/visible/supply
	name = "Air supply pipe"
	desc = "A one meter section of supply pipe"
	icon_state = "bent-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 2.39
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/bent/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/bent/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/bent/visible/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/bent/visible/purple
	color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/bent/visible/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/bent/visible/blue
	color = PIPE_COLOR_BLUE


/obj/machinery/atmospherics/pipe/bent/hidden
	icon_state = "bent"
	level = 1
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/machinery/atmospherics/pipe/bent/hidden/scrubbers
	name = "Scrubbers pipe"
	desc = "A one meter section of scrubbers pipe"
	icon_state = "bent-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 2.38
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/bent/hidden/supply
	name = "Air supply pipe"
	desc = "A one meter section of supply pipe"
	icon_state = "bent-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 2.39
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/bent/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/bent/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/bent/hidden/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/bent/hidden/purple
	color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/bent/hidden/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/bent/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/bent/insulated
	icon = 'icons/obj/atmospherics/red_pipe.dmi'
	icon_state = "bent"

	minimum_temperature_difference = 10000
	thermal_conductivity = 0
	maximum_pressure = 1000*ONE_ATMOSPHERE
	fatigue_pressure = 900*ONE_ATMOSPHERE
	alert_pressure = 900*ONE_ATMOSPHERE

	level = 2


/obj/machinery/atmospherics/pipe/manifold
	icon = 'icons/atmos/manifold.dmi'
	icon_state = ""
	name = "pipe manifold"
	desc = "A manifold composed of regular pipes"

	volume = ATMOS_DEFAULT_VOLUME_PIPE * 1.5

	dir = 2
	init_dirs = 2|4|8

	level = 1
	layer = 2.4 //under wires with their 2.44


/obj/machinery/atmospherics/pipe/manifold/visible
	icon_state = "map"
	level = 2

/obj/machinery/atmospherics/pipe/manifold/visible/scrubbers
	name="Scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 2.38
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/visible/supply
	name="Air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 2.39
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/visible/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold/visible/purple
	color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/manifold/visible/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/visible/blue
	color = PIPE_COLOR_BLUE


/obj/machinery/atmospherics/pipe/manifold/hidden
	icon_state = "map"
	level = 1
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/machinery/atmospherics/pipe/manifold/hidden/scrubbers
	name="Scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 2.38
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/hidden/supply
	name="Air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 2.39
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/hidden/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold/hidden/purple
	color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/manifold/hidden/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w
	icon = 'icons/atmos/manifold.dmi'
	icon_state = ""
	name = "4-way pipe manifold"
	desc = "A manifold composed of regular pipes"

	volume = ATMOS_DEFAULT_VOLUME_PIPE * 2

	dir = SOUTH
	init_dirs = NORTH|SOUTH|EAST|WEST

	level = 1
	layer = 2.4 //under wires with their 2.44


/obj/machinery/atmospherics/pipe/manifold4w/visible
	icon_state = "map_4way"
	level = 2

/obj/machinery/atmospherics/pipe/manifold4w/visible/scrubbers
	name="4-way scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map_4way-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 2.38
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/visible/supply
	name="4-way air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map_4way-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 2.39
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold4w/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold4w/visible/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold4w/visible/purple
	color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/manifold4w/visible/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/visible/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w/hidden
	icon_state = "map_4way"
	level = 1
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/machinery/atmospherics/pipe/manifold4w/hidden/scrubbers
	name="4-way scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map_4way-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 2.38
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/hidden/supply
	name="4-way air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map_4way-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 2.39
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold4w/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold4w/hidden/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold4w/hidden/purple
	color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/manifold4w/hidden/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/cap
	name = "pipe endcap"
	desc = "An endcap for pipes"
	icon = 'icons/atmos/pipes.dmi'
	icon_state = ""
	level = 2
	layer = 2.4 //under wires with their 2.44

	volume = 35

	dir = SOUTH
	init_dirs = SOUTH


/obj/machinery/atmospherics/pipe/cap/visible
	level = 2
	icon_state = "cap"

/obj/machinery/atmospherics/pipe/cap/visible/scrubbers
	name = "scrubbers pipe endcap"
	desc = "An endcap for scrubbers pipes"
	icon_state = "cap-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 2.38
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/cap/visible/supply
	name = "supply pipe endcap"
	desc = "An endcap for supply pipes"
	icon_state = "cap-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 2.39
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/cap/hidden
	level = 1
	icon_state = "cap"
	alpha = 128

/obj/machinery/atmospherics/pipe/cap/hidden/scrubbers
	name = "scrubbers pipe endcap"
	desc = "An endcap for scrubbers pipes"
	icon_state = "cap-f-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 2.38
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/cap/hidden/supply
	name = "supply pipe endcap"
	desc = "An endcap for supply pipes"
	icon_state = "cap-f-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 2.39
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE


/obj/machinery/atmospherics/pipe/tank
	icon = 'icons/atmos/tank.dmi'
	icon_state = "air_map"

	name = "Pressure Tank"
	desc = "A large vessel containing pressurized gas."

	volume = 10000 //in liters, 1 meters by 1 meters by 2 meters ~tweaked it a little to simulate a pressure tank without needing to recode them yet
	var/start_pressure = 25*ONE_ATMOSPHERE

	level = 1
	dir = SOUTH
	init_dirs = SOUTH
	density = 1


/obj/machinery/atmospherics/pipe/tank/air
	name = "Pressure Tank (Air)"
	icon_state = "air_map"


/obj/machinery/atmospherics/pipe/tank/oxygen
	name = "Pressure Tank (Oxygen)"
	icon_state = "o2_map"


/obj/machinery/atmospherics/pipe/tank/nitrogen
	name = "Pressure Tank (Nitrogen)"
	icon_state = "n2_map"


/obj/machinery/atmospherics/pipe/tank/carbon_dioxide
	name = "Pressure Tank (Carbon Dioxide)"
	icon_state = "co2_map"


/obj/machinery/atmospherics/pipe/tank/phoron
	name = "Pressure Tank (Phoron)"
	icon_state = "phoron_map"


/obj/machinery/atmospherics/pipe/tank/nitrous_oxide
	name = "Pressure Tank (Nitrous Oxide)"
	icon_state = "n2o_map"


/obj/machinery/atmospherics/pipe/vent
	icon = 'icons/obj/atmospherics/pipe_vent.dmi'
	icon_state = "intact"

	name = "Vent"
	desc = "A large air vent"

	level = 1

	volume = 250

	dir = SOUTH
	init_dirs = SOUTH

	var/build_killswitch = 1


/obj/machinery/atmospherics/pipe/vent/high_volume
	name = "Larger vent"
	volume = 1000


/obj/machinery/atmospherics/pipe/passive_vent
	icon = 'icons/atmos/vent_pump.dmi'
	icon_state = "map_vent"
	name = "Vent"
	desc = "A large air vent"

	level = 1

	dir = SOUTH
	init_dirs = SOUTH


	use_power = 0
	var/welded = 0


/obj/machinery/atmospherics/pipe/universal
	name="Universal pipe adapter"
	desc = "An adapter for regular, supply and scrubbers pipes"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER
	icon = 'icons/atmos/pipes.dmi'
	icon_state = "map_universal"

	volume = ATMOS_DEFAULT_VOLUME_PIPE*3

	dir = SOUTH
	init_dirs = SOUTH|NORTH

	minimum_temperature_difference = 300
	thermal_conductivity = 0 //WALL_HEAT_TRANSFER_COEFFICIENT No

	maximum_pressure = 70*ONE_ATMOSPHERE
	fatigue_pressure = 55*ONE_ATMOSPHERE
	alert_pressure = 55*ONE_ATMOSPHERE

	level = 1


/obj/machinery/atmospherics/pipe/universal/visible
	icon_state = "intact"
	level = 2


/obj/machinery/atmospherics/pipe/universal/hidden
	icon_state = "intact"
	level = 1
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game


obj/machinery/atmospherics/pipe/simple/heat_exchanging
	icon = 'icons/atmos/heat.dmi'
	icon_state = "intact"
	pipe_icon = "hepipe"
	color = "#404040"
	level = 2
	connect_types = CONNECT_TYPE_HE
	layer = 2.41
	var/initialize_directions_he
	var/surface = 2	//surface area in m^2
	var/icon_temperature = T20C //stop small changes in temperature causing an icon refresh

	minimum_temperature_difference = 20
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT

	buckle_lying = 1

obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction
	icon = 'icons/atmos/junction.dmi'
	icon_state = "intact"
	pipe_icon = "hejunction"
	level = 2
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_HE
	minimum_temperature_difference = 300
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT

obj/machinery/atmospherics/pipe/simple/heat_exchanging/bent
	icon_state = "bent"