/datum/pipe
	var/name = null						//item's name
	var/desc = null						//item description
	var/item_name = null				//original item's name, in case it gets modified.
	var/item_id = "id"					//ID for easy reference. All lowercase, alpha numeric, no symbols.
	var/build_path = /obj/item/pipe		//path of the object that's being created
	var/category = null					//Allows for easy sorting in the menu.
	var/sort_string = "ZZZZ"			//Allows for nudging items to where you want them to appear.
	var/pipe_type = 0					//What sort of pipe this is
	var/connect_types = 0				//what sort of connection this has
	var/pipe_color = PIPE_COLOR_GREY	//what color the pipe should be by default
	var/icon_state = "simple"
	var/dir = 2
/datum/pipe/New()
	..()
	item_name = name
	//AssemblePipeInfo()

//These procs are used in subtypes for assigning names and descriptions dynamically
/datum/pipe/proc/AssemblePipeInfo()
	AssemblePipeName()
	AssemblePipeDesc()

/datum/pipe/proc/AssemblePipeName()
	if(!name && build_path)					//Get name from build path if posible
		var/atom/movable/A = build_path
		name = initial(A.name)
		item_name = name

/datum/pipe/proc/AssemblePipeDesc()
	if(!desc)								//Try to make up a nice description if we don't have one
		desc = "\a [item_name]."

/datum/pipe/proc/Fabricate(var/newloc)
	return new build_path(newloc)

/datum/pipe/pipe_dispenser/simple/straight
	name = "pipe fitting"
	desc = "a straight pipe segment."
	item_id = "straightpipe"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SIMPLE_STRAIGHT
	connect_types = CONNECT_TYPE_REGULAR
	pipe_color = PIPE_COLOR_GREY

/datum/pipe/pipe_dispenser/simple/bent
	name = "bent pipe fitting"
	desc = "a bent pipe segment"
	item_id = "bentpipe"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SIMPLE_BENT
	connect_types = CONNECT_TYPE_REGULAR
	pipe_color = PIPE_COLOR_GREY
	dir = 10

/datum/pipe/pipe_dispenser/simple/manifold
	name = "pipe manifold fitting"
	desc = "a pipe manifold segment"
	item_id = "simplepipemanifold"
	build_path = /obj/item/pipe
	pipe_type = PIPE_MANIFOLD
	connect_types = CONNECT_TYPE_REGULAR
	pipe_color = PIPE_COLOR_GREY
	icon_state = "manifold"

/datum/pipe/pipe_dispenser/simple/manifold4w
	name = "four-way pipe manifold fitting"
	desc = "a four-way pipe manifold segment"
	item_id = "simplepipemanifold4w"
	build_path = /obj/item/pipe
	pipe_type = PIPE_MANIFOLD4W
	connect_types = CONNECT_TYPE_REGULAR
	pipe_color = PIPE_COLOR_GREY
	icon_state = "manifold4w"

/datum/pipe/pipe_dispenser/simple/cap
	name = "pipe cap fitting"
	desc = "a pipe cap for a regular pipe."
	item_id = "simplepipecap"
	build_path = /obj/item/pipe
	pipe_type = PIPE_CAP
	connect_types = CONNECT_TYPE_REGULAR
	pipe_color = PIPE_COLOR_GREY
	icon_state = "cap"

/datum/pipe/pipe_dispenser/supply/straight
	name = "supply pipe fitting"
	desc = "a straight supply pipe segment."
	item_id = "straightsupplypipe"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SUPPLY_STRAIGHT
	connect_types = CONNECT_TYPE_SUPPLY
	pipe_color = PIPE_COLOR_BLUE

/datum/pipe/pipe_dispenser/scrubber/straight
	name = "scrubber pipe fitting"
	desc = "a straight scrubber pipe segment"
	item_id = "straightscrubberpipe"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SCRUBBERS_STRAIGHT
	connect_types = CONNECT_TYPE_SCRUBBER
	pipe_color = PIPE_COLOR_RED

/datum/pipe/pipe_dispenser/fuel/straight
	name = "fuel pipe fitting"
	desc = "a striaght fuel pipe segment"
	item_id = "straightfuelpipe"
	build_path = /obj/item/pipe
	pipe_type = PIPE_FUEL_STRAIGHT
	connect_types = CONNECT_TYPE_FUEL
	pipe_color = PIPE_COLOR_ORANGE

/datum/pipe/pipe_dispenser/device/meter
	name = "meter"
	desc = "a meter that monitors pressure and temperature on the attached pipe."
	item_id = "pipemeter"
	build_path = /obj/item/pipe_meter
	pipe_type = null
	pipe_color = null
	connect_types = null
	icon_state = "meter"

/datum/pipe/pipe_dispenser/he/straight
	name = "heat exchanger pipe fitting"
	desc = "a heat exchanger pipe segment"
	item_id = "hepipestraight"
	build_path = /obj/item/pipe
	pipe_type = PIPE_HEAT_EXCHANGE
	pipe_color = PIPE_COLOR_GREY
	connect_types = CONNECT_TYPE_HE
	icon_state = "he"
