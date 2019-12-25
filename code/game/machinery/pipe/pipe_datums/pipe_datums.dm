#define PIPE_STRAIGHT 2
#define PIPE_BENT     5

/datum/pipe/pipe_dispenser/simple
	category = "Regular Pipes"
	colorable = TRUE
	connect_types = CONNECT_TYPE_REGULAR
	pipe_color = PIPE_COLOR_GREY
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden
	pipe_class = PIPE_CLASS_BINARY

/datum/pipe/pipe_dispenser/simple/straight
	name = "a pipe fitting"
	desc = "a straight pipe segment."
	build_path = /obj/item/pipe
	rotate_class = PIPE_ROTATE_TWODIR

/datum/pipe/pipe_dispenser/simple/bent
	name = "bent pipe fitting"
	desc = "a bent pipe segment"
	build_path = /obj/item/pipe
	dir = PIPE_BENT
	rotate_class = PIPE_ROTATE_TWODIR

/datum/pipe/pipe_dispenser/simple/manifold
	name = "pipe manifold fitting"
	desc = "a pipe manifold segment"
	build_path = /obj/item/pipe
	build_icon_state = "manifold"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold/hidden
	pipe_class = PIPE_CLASS_TRINARY

/datum/pipe/pipe_dispenser/simple/manifold4w
	name = "four-way pipe manifold fitting"
	desc = "a four-way pipe manifold segment"
	build_path = /obj/item/pipe
	build_icon_state = "manifold4w"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold4w/hidden
	pipe_class = PIPE_CLASS_QUATERNARY
	rotate_class = PIPE_ROTATE_ONEDIR

/datum/pipe/pipe_dispenser/simple/cap
	name = "pipe cap fitting"
	desc = "a pipe cap for a regular pipe."
	build_path = /obj/item/pipe
	build_icon_state = "cap"
	constructed_path = /obj/machinery/atmospherics/pipe/cap/hidden
	pipe_class = PIPE_CLASS_UNARY

/datum/pipe/pipe_dispenser/simple/up
	name = "upward pipe fitting"
	desc = "an upward pipe."
	build_path = /obj/item/pipe
	build_icon = 'icons/obj/structures.dmi'
	build_icon_state = "up"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/up

/datum/pipe/pipe_dispenser/simple/down
	name = "downward pipe fitting"
	desc = "a downward pipe."
	build_path = /obj/item/pipe
	build_icon = 'icons/obj/structures.dmi'
	build_icon_state = "down"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/down

/datum/pipe/pipe_dispenser/supply
	category = "Supply Pipes"
	colorable = FALSE
	connect_types = CONNECT_TYPE_SUPPLY
	pipe_color = PIPE_COLOR_BLUE
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/supply
	pipe_class = PIPE_CLASS_BINARY

/datum/pipe/pipe_dispenser/supply/straight
	name = "supply pipe fitting"
	desc = "a straight supply pipe segment."
	build_path = /obj/item/pipe
	rotate_class = PIPE_ROTATE_TWODIR

/datum/pipe/pipe_dispenser/supply/bent
	name = "bent supply pipe fitting"
	desc = "a bent supply pipe segment"
	build_path = /obj/item/pipe
	dir = PIPE_BENT
	rotate_class = PIPE_ROTATE_TWODIR

/datum/pipe/pipe_dispenser/supply/manifold
	name = "supply pipe manifold fitting"
	desc = "a supply pipe manifold segment"
	build_path = /obj/item/pipe
	build_icon_state = "manifold"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold/hidden/supply
	pipe_class = PIPE_CLASS_TRINARY

/datum/pipe/pipe_dispenser/supply/manifold4w
	name = "four-way supply pipe manifold fitting"
	desc = "a four-way supply pipe manifold segment"
	build_path = /obj/item/pipe
	build_icon_state = "manifold4w"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold4w/hidden/supply
	pipe_class = PIPE_CLASS_QUATERNARY
	rotate_class = PIPE_ROTATE_ONEDIR

/datum/pipe/pipe_dispenser/supply/cap
	name = "supply pipe cap fitting"
	desc = "a pipe cap for a regular pipe."
	build_path = /obj/item/pipe
	build_icon_state = "cap"
	constructed_path = /obj/machinery/atmospherics/pipe/cap/hidden/supply
	pipe_class = PIPE_CLASS_UNARY

/datum/pipe/pipe_dispenser/supply/up
	name = "upward supply pipe fitting"
	desc = "an upward supply pipe segment."
	build_path = /obj/item/pipe
	build_icon = 'icons/obj/structures.dmi'
	build_icon_state = "up"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/up/supply

/datum/pipe/pipe_dispenser/supply/down
	name = "downward supply pipe fitting"
	desc = "a downward supply pipe segment."
	build_path = /obj/item/pipe
	build_icon = 'icons/obj/structures.dmi'
	build_icon_state = "down"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/down/supply

/datum/pipe/pipe_dispenser/scrubber
	category = "Scrubber Pipes"
	colorable = FALSE
	connect_types = CONNECT_TYPE_SCRUBBER
	pipe_color = PIPE_COLOR_RED
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/scrubbers
	pipe_class = PIPE_CLASS_BINARY

/datum/pipe/pipe_dispenser/scrubber/straight
	name = "scrubber pipe fitting"
	desc = "a straight scrubber pipe segment"
	build_path = /obj/item/pipe
	rotate_class = PIPE_ROTATE_TWODIR

/datum/pipe/pipe_dispenser/scrubber/bent
	name = "bent scrubber pipe fitting"
	desc = "a bent scrubber pipe segment"
	build_path = /obj/item/pipe
	rotate_class = PIPE_ROTATE_TWODIR
	dir = PIPE_BENT

/datum/pipe/pipe_dispenser/scrubber/manifold
	name = "scrubber pipe manifold fitting"
	desc = "a scrubber pipe manifold segment"
	build_path = /obj/item/pipe
	build_icon_state = "manifold"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold/hidden/scrubbers
	pipe_class = PIPE_CLASS_TRINARY

/datum/pipe/pipe_dispenser/scrubber/manifold4w
	name = "four-way scrubber pipe manifold fitting"
	desc = "a four-way scrubber pipe manifold segment"
	build_path = /obj/item/pipe
	build_icon_state = "manifold4w"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold4w/hidden/scrubbers
	pipe_class = PIPE_CLASS_QUATERNARY
	rotate_class = PIPE_ROTATE_ONEDIR

/datum/pipe/pipe_dispenser/scrubber/cap
	name = "scrubber pipe cap fitting"
	desc = "a pipe cap for a scrubber pipe."
	build_path = /obj/item/pipe
	build_icon_state = "cap"
	constructed_path = /obj/machinery/atmospherics/pipe/cap/hidden/scrubbers

/datum/pipe/pipe_dispenser/scrubber/up
	name = "upward scrubber pipe fitting"
	desc = "an upward scrubber pipe segment."
	build_path = /obj/item/pipe
	build_icon = 'icons/obj/structures.dmi'
	build_icon_state = "up"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/up/scrubbers

/datum/pipe/pipe_dispenser/scrubber/down
	name = "downward scrubber pipe fitting"
	desc = "a downward scrubber pipe segment."
	build_path = /obj/item/pipe
	build_icon = 'icons/obj/structures.dmi'
	build_icon_state = "down"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/down/scrubbers

/datum/pipe/pipe_dispenser/fuel
	category = "Fuel Pipes"
	colorable = FALSE
	pipe_color = PIPE_COLOR_ORANGE
	connect_types = CONNECT_TYPE_FUEL
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/fuel
	pipe_class = PIPE_CLASS_BINARY

/datum/pipe/pipe_dispenser/fuel/straight
	name = "fuel pipe fitting"
	desc = "a striaght fuel pipe segment"
	build_path = /obj/item/pipe
	rotate_class = PIPE_ROTATE_TWODIR

/datum/pipe/pipe_dispenser/fuel/bent
	name = "bent fuel pipe fitting"
	desc = "a bent fuel pipe segment"
	build_path = /obj/item/pipe
	rotate_class = PIPE_ROTATE_TWODIR
	dir = PIPE_BENT

/datum/pipe/pipe_dispenser/fuel/manifold
	name = "fuel pipe manifold fitting"
	desc = "a fuel pipe manifold segment"
	build_path = /obj/item/pipe
	build_icon_state = "manifold"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold/hidden/fuel
	pipe_class = PIPE_CLASS_TRINARY

/datum/pipe/pipe_dispenser/fuel/manifold4w
	name = "four-way supply pipe manifold fitting"
	desc = "a four-way fuel pipe manifold segment"
	build_path = /obj/item/pipe
	build_icon_state = "manifold4w"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold4w/hidden/fuel
	pipe_class = PIPE_CLASS_QUATERNARY
	rotate_class = PIPE_ROTATE_ONEDIR

/datum/pipe/pipe_dispenser/fuel/cap
	name = "fuel pipe cap fitting"
	desc = "a pipe cap for a fuel pipe."
	build_path = /obj/item/pipe
	build_icon_state = "cap"
	constructed_path = /obj/machinery/atmospherics/pipe/cap/hidden/fuel
	pipe_class = PIPE_CLASS_UNARY

/datum/pipe/pipe_dispenser/fuel/up
	name = "upward fuel pipe fitting"
	desc = "an upward fuel pipe segment."
	build_path = /obj/item/pipe
	build_icon = 'icons/obj/structures.dmi'
	build_icon_state = "up"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/up/fuel

/datum/pipe/pipe_dispenser/fuel/down
	name = "downward fuel pipe fitting"
	desc = "a downward fuel pipe segment."
	build_path = /obj/item/pipe
	build_icon = 'icons/obj/structures.dmi'
	build_icon_state = "down"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/down/fuel

/datum/pipe/pipe_dispenser/he
	category = "Heat Exchange Pipes"
	colorable = FALSE
	connect_types = CONNECT_TYPE_HE
	constructed_path = /obj/machinery/atmospherics/pipe/simple/heat_exchanging
	pipe_class = PIPE_CLASS_BINARY

/datum/pipe/pipe_dispenser/he/straight
	name = "heat exchanger pipe fitting"
	desc = "a heat exchanger pipe segment"
	build_path = /obj/item/pipe
	build_icon_state = "he"
	rotate_class = PIPE_ROTATE_TWODIR

/datum/pipe/pipe_dispenser/he/bent
	name = "bent heat exchanger pipe fitting"
	desc = "a bent heat exchanger pipe segment"
	build_path = /obj/item/pipe
	connect_types = CONNECT_TYPE_HE
	rotate_class = PIPE_ROTATE_TWODIR
	build_icon_state = "he"
	dir = PIPE_BENT

/datum/pipe/pipe_dispenser/he/junction
	name = "heat exchanger junction"
	desc = "a heat exchanger junction"
	build_path = /obj/item/pipe
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_HE
	build_icon_state = "junction"
	constructed_path = /obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction

/datum/pipe/pipe_dispenser/he/exchanger
	name = "heat exchanger"
	desc = "a heat exchanger"
	build_path = /obj/item/pipe
	connect_types = CONNECT_TYPE_REGULAR
	build_icon_state = "heunary"
	constructed_path = /obj/machinery/atmospherics/unary/heat_exchanger
	pipe_class = PIPE_CLASS_UNARY

//Cleanup
#undef PIPE_STRAIGHT
#undef PIPE_BENT