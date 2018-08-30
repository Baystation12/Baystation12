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
	var/icon = 'icons/obj/pipe-item.dmi'
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
	dir = 5

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

/datum/pipe/pipe_dispenser/simple/down
	name = "downward pipe fitting"
	desc = "a downward pipe."
	item_id = "simplepipedown"
	build_path = /obj/item/pipe
	pipe_type = PIPE_DOWN
	connect_types = CONNECT_TYPE_REGULAR
	pipe_color = PIPE_COLOR_GREY
	icon = 'icons/obj/structures.dmi'
	icon_state = "down"

/datum/pipe/pipe_dispenser/simple/up
	name = "upward pipe fitting"
	desc = "an upward pipe."
	item_id = "simplepipeup"
	build_path = /obj/item/pipe
	pipe_type = PIPE_UP
	connect_types = CONNECT_TYPE_REGULAR
	pipe_color = PIPE_COLOR_GREY
	icon = 'icons/obj/structures.dmi'
	icon_state = "up"


/datum/pipe/pipe_dispenser/supply/straight
	name = "supply pipe fitting"
	desc = "a straight supply pipe segment."
	item_id = "straightsupplypipe"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SUPPLY_STRAIGHT
	connect_types = CONNECT_TYPE_SUPPLY
	pipe_color = PIPE_COLOR_BLUE

/datum/pipe/pipe_dispenser/supply/bent
	name = "bent supply pipe fitting"
	desc = "a bent supply pipe segment"
	item_id = "bentsupplypipe"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SUPPLY_BENT
	connect_types = CONNECT_TYPE_SUPPLY
	pipe_color = PIPE_COLOR_BLUE
	dir = 5

/datum/pipe/pipe_dispenser/supply/manifold
	name = "supply pipe manifold fitting"
	desc = "a supply pipe manifold segment"
	item_id = "supplypipemanifold"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SUPPLY_MANIFOLD
	connect_types = CONNECT_TYPE_SUPPLY
	pipe_color = PIPE_COLOR_BLUE
	icon_state = "manifold"

/datum/pipe/pipe_dispenser/supply/manifold4w
	name = "four-way supply pipe manifold fitting"
	desc = "a four-way supply pipe manifold segment"
	item_id = "supplypipemanifold4w"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SUPPLY_MANIFOLD4W
	connect_types = CONNECT_TYPE_SUPPLY
	pipe_color = PIPE_COLOR_BLUE
	icon_state = "manifold4w"

/datum/pipe/pipe_dispenser/supply/cap
	name = "supply pipe cap fitting"
	desc = "a pipe cap for a regular pipe."
	item_id = "supplypipecap"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SUPPLY_CAP
	connect_types = CONNECT_TYPE_SUPPLY
	pipe_color = PIPE_COLOR_BLUE
	icon_state = "cap"

/datum/pipe/pipe_dispenser/scrubber/straight
	name = "scrubber pipe fitting"
	desc = "a straight scrubber pipe segment"
	item_id = "straightscrubberpipe"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SCRUBBERS_STRAIGHT
	connect_types = CONNECT_TYPE_SCRUBBER
	pipe_color = PIPE_COLOR_RED

/datum/pipe/pipe_dispenser/scrubber/bent
	name = "bent scrubber pipe fitting"
	desc = "a bent scrubber pipe segment"
	item_id = "bentscrubberpipe"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SCRUBBERS_BENT
	connect_types = CONNECT_TYPE_SCRUBBER
	pipe_color = PIPE_COLOR_RED
	dir = 5

/datum/pipe/pipe_dispenser/scrubber/manifold
	name = "scrubber pipe manifold fitting"
	desc = "a scrubber pipe manifold segment"
	item_id = "scrubberpipemanifold"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SCRUBBERS_MANIFOLD
	connect_types = CONNECT_TYPE_SCRUBBER
	pipe_color = PIPE_COLOR_RED
	icon_state = "manifold"

/datum/pipe/pipe_dispenser/scrubber/manifold4w
	name = "four-way supply pipe manifold fitting"
	desc = "a four-way scrubber pipe manifold segment"
	item_id = "supplypipemanifold4w"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SCRUBBERS_MANIFOLD4W
	connect_types = CONNECT_TYPE_SCRUBBER
	pipe_color = PIPE_COLOR_RED
	icon_state = "manifold4w"

/datum/pipe/pipe_dispenser/scrubber/cap
	name = "scrubber pipe cap fitting"
	desc = "a pipe cap for a scrubber pipe."
	item_id = "scrubberpipecap"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SCRUBBERS_CAP
	connect_types = CONNECT_TYPE_SCRUBBER
	pipe_color = PIPE_COLOR_RED
	icon_state = "cap"

/datum/pipe/pipe_dispenser/fuel/straight
	name = "fuel pipe fitting"
	desc = "a striaght fuel pipe segment"
	item_id = "straightfuelpipe"
	build_path = /obj/item/pipe
	pipe_type = PIPE_FUEL_STRAIGHT
	connect_types = CONNECT_TYPE_FUEL
	pipe_color = PIPE_COLOR_ORANGE

/datum/pipe/pipe_dispenser/fuel/bent
	name = "bent fuel pipe fitting"
	desc = "a bent fuel pipe segment"
	item_id = "bentfuelpipe"
	build_path = /obj/item/pipe
	pipe_type = PIPE_FUEL_BENT
	connect_types = CONNECT_TYPE_FUEL
	pipe_color = PIPE_COLOR_ORANGE
	dir = 5

/datum/pipe/pipe_dispenser/fuel/manifold
	name = "fuel pipe manifold fitting"
	desc = "a fuel pipe manifold segment"
	item_id = "fuelpipemanifold"
	build_path = /obj/item/pipe
	pipe_type = PIPE_FUEL_MANIFOLD
	connect_types = CONNECT_TYPE_FUEL
	pipe_color = PIPE_COLOR_ORANGE
	icon_state = "manifold"

/datum/pipe/pipe_dispenser/fuel/manifold4w
	name = "four-way supply pipe manifold fitting"
	desc = "a four-way fuel pipe manifold segment"
	item_id = "supplypipemanifold4w"
	build_path = /obj/item/pipe
	pipe_type = PIPE_FUEL_MANIFOLD4W
	connect_types = CONNECT_TYPE_FUEL
	pipe_color = PIPE_COLOR_ORANGE
	icon_state = "manifold4w"

/datum/pipe/pipe_dispenser/fuel/cap
	name = "fuel pipe cap fitting"
	desc = "a pipe cap for a fuel pipe."
	item_id = "fuelpipecap"
	build_path = /obj/item/pipe
	pipe_type = PIPE_FUEL_CAP
	connect_types = CONNECT_TYPE_FUEL
	pipe_color = PIPE_COLOR_ORANGE
	icon_state = "cap"

/datum/pipe/pipe_dispenser/he/straight
	name = "heat exchanger pipe fitting"
	desc = "a heat exchanger pipe segment"
	item_id = "hepipestraight"
	build_path = /obj/item/pipe
	pipe_type = PIPE_HE_STRAIGHT
	pipe_color = PIPE_COLOR_GREY
	connect_types = CONNECT_TYPE_HE
	icon_state = "he"

/datum/pipe/pipe_dispenser/he/bent
	name = "bent heat exchanger pipe fitting"
	desc = "a bent heat exchanger pipe segment"
	item_id = "benthepipe"
	build_path = /obj/item/pipe
	pipe_type = PIPE_HE_BENT
	connect_types = CONNECT_TYPE_HE
	icon_state = "he"
	dir = 5

/datum/pipe/pipe_dispenser/he/junction
	name = "heat exchanger junction"
	desc = "a heat exchanger junction"
	item_id = "hejunctionpipe"
	build_path = /obj/item/pipe
	pipe_type = PIPE_JUNCTION
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_HE
	icon_state = "junction"

/datum/pipe/pipe_dispenser/he/exchanger
	name = "heat exchanger"
	desc = "a heat exchanger"
	item_id = "heatexchanger"
	build_path = /obj/item/pipe
	pipe_type = PIPE_HEAT_EXCHANGE
	connect_types = CONNECT_TYPE_REGULAR
	icon_state = "heunary"

/datum/pipe/pipe_dispenser/device/universaladapter
	name = "universal pipe adapter"
	desc = "an adapter designed to fit any type of pipe."
	item_id = "universaladapter"
	build_path = /obj/item/pipe
	pipe_type = PIPE_UNIVERSAL
	pipe_color = PIPE_COLOR_GREY
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_FUEL|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_HE
	icon_state = "universal"

/datum/pipe/pipe_dispenser/device/connector
	name = "connector"
	desc = "a connector for canisters."
	item_id = "connector"
	build_path = /obj/item/pipe
	pipe_type = PIPE_CONNECTOR
	connect_types = CONNECT_TYPE_REGULAR
	pipe_color = PIPE_COLOR_GREY
	icon_state = "connector"

/datum/pipe/pipe_dispenser/device/unaryvent
	name = "unary vent"
	desc = "a unary vent"
	item_id = "unaryvent"
	build_path = /obj/item/pipe
	pipe_type = PIPE_UVENT
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_FUEL
	pipe_color = PIPE_COLOR_GREY
	icon_state = "uvent"

/datum/pipe/pipe_dispenser/device/gaspump
	name = "gas pump"
	desc = "a pump. For gasses."
	item_id = "gaspump"
	build_path = /obj/item/pipe
	pipe_type = PIPE_PUMP
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL
	pipe_color = PIPE_COLOR_GREY
	icon_state = "pump"

/datum/pipe/pipe_dispenser/device/pressureregulator
	name = "pressure regulator"
	desc = "a device that regulates pressure."
	item_id = "pressureregulator"
	build_path = /obj/item/pipe
	pipe_type = PIPE_PASSIVE_GATE
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL
	pipe_color = PIPE_COLOR_GREY
	icon_state = "passivegate"

/datum/pipe/pipe_dispenser/device/hpgaspump
	name = "high powered gas pump"
	desc = "a high powered pump. For gasses."
	item_id = "hpgaspump"
	build_path = /obj/item/pipe
	pipe_type = PIPE_VOLUME_PUMP
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL
	pipe_color = PIPE_COLOR_GREY
	icon_state = "volumepump"

/datum/pipe/pipe_dispenser/device/scrubber
	name = "scrubber"
	desc = "scrubs out undesirable gasses"
	item_id = "scrubber"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SCRUBBER
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER
	pipe_color = PIPE_COLOR_GREY
	icon_state = "scrubber"

/datum/pipe/pipe_dispenser/device/meter
	name = "meter"
	desc = "a meter that monitors pressure and temperature on the attached pipe."
	item_id = "pipemeter"
	build_path = /obj/item/pipe_meter
	pipe_type = null
	pipe_color = null
	connect_types = null
	icon_state = "meter"

/datum/pipe/pipe_dispenser/device/omnimixer
	name = "omni gas mixer"
	desc = "a device that takes in two or three gasses and mixes them into a precise output."
	item_id = "omnimixer"
	build_path = /obj/item/pipe
	pipe_type = PIPE_OMNI_MIXER
	pipe_color = PIPE_COLOR_GREY
	connect_types = CONNECT_TYPE_REGULAR
	icon_state = "omni_mixer"

/datum/pipe/pipe_dispenser/device/omnifilter
	name = "omni gas filter"
	desc = "a device that filters out undesireable elements"
	item_id = "omnifilter"
	build_path = /obj/item/pipe
	pipe_type = PIPE_OMNI_FILTER
	pipe_color = PIPE_COLOR_GREY
	connect_types = CONNECT_TYPE_REGULAR
	icon_state = "omni_filter"

/datum/pipe/pipe_dispenser/device/manualvalve
	name = "manual valve"
	desc = "a valve that has to be manipulated by hand"
	item_id = "manualvalve"
	build_path = /obj/item/pipe
	pipe_type = PIPE_MVALVE
	pipe_color = PIPE_COLOR_GREY
	connect_types = CONNECT_TYPE_REGULAR
	icon_state = "mvalve"

/datum/pipe/pipe_dispenser/device/digitalvalve
	name = "digital valve"
	desc = "a valve controlled electronically"
	item_id = "digitalvalve"
	build_path = /obj/item/pipe
	pipe_type = PIPE_DVALVE
	pipe_color = PIPE_COLOR_GREY
	connect_types = CONNECT_TYPE_REGULAR
	icon_state = "dvalve"

/datum/pipe/pipe_dispenser/device/autoshutoff
	name = "automatic shutoff valve"
	desc = "a valve that can automatically shut itself off"
	item_id = "autoshutoff"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SVALVE
	pipe_color = PIPE_COLOR_GREY
	connect_types = CONNECT_TYPE_REGULAR
	icon_state = "svalve"

/datum/pipe/pipe_dispenser/device/tvalve
	name = "manual t-valve"
	desc = "a three-way valve. T-shaped."
	item_id = "tvalve"
	build_path = /obj/item/pipe
	pipe_type = PIPE_MTVALVE
	pipe_color = PIPE_COLOR_GREY
	connect_types = CONNECT_TYPE_REGULAR
	icon_state = "mtvalve"

/datum/pipe/pipe_dispenser/device/tvalvemirrored
	name = "manual t-valve"
	desc = "a three-way valve. T-shaped."
	item_id = "tvalvemirrored"
	build_path = /obj/item/pipe
	pipe_type = PIPE_MTVALVEM
	pipe_color = PIPE_COLOR_GREY
	connect_types = CONNECT_TYPE_REGULAR
	icon_state = "mtvalvem"