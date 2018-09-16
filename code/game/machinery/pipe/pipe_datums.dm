#define PIPE_NORMAL	2
#define PIPE_BENT	5

/datum/pipe
	var/name = "pipe"							//item's name
	var/desc = "a pipe"							//item description
	var/build_path = /obj/item/pipe				//path of the object that's being created
	var/category = "general"					//Allows for easy sorting in the menu.
	var/pipe_type = PIPE_SIMPLE_STRAIGHT		//What sort of pipe this is
	var/connect_types = CONNECT_TYPE_REGULAR	//what sort of connection this has
	var/pipe_color = PIPE_COLOR_WHITE			//what color the pipe should be by default
	var/build_icon_state = "simple"				//Which icon state to use when creating a new pipe item.
	var/build_icon = 'icons/obj/pipe-item.dmi'	//Which file the icon is located at.
	var/dir = PIPE_NORMAL						//Bent or not?
	var/colorable = TRUE						//Can this pipe be colored?

//==========
//Procedures
//==========

/datum/pipe/New()
	..()
	AssemblePipeInfo()

//These procs are used in subtypes for assigning names and descriptions dynamically
/datum/pipe/proc/AssemblePipeInfo()
	AssemblePipeName()
	AssemblePipeDesc()

/datum/pipe/proc/AssemblePipeName()
	if(!name && build_path)					//Get name from build path if posible
		var/atom/movable/A = build_path
		name = initial(A.name)

/datum/pipe/proc/AssemblePipeDesc()
	if(!desc)								//Try to make up a nice description if we don't have one
		desc = "\a [name]."

/datum/pipe/proc/Build(var/datum/pipe/D, var/PipeColor = PIPE_COLOR_GREY, var/loc)
	if(D.build_path)
		var/obj/item/pipe/new_item = new build_path(loc)
		if(D.pipe_type != null)
			new_item.pipe_type = D.pipe_type
		if(D.connect_types != null)
			new_item.connect_types = D.connect_types
		if(D.colorable)
			new_item.color = PipeColor
		else if (D.pipe_color != null)
			new_item.color = D.pipe_color
		new_item.name = D.name
		new_item.desc = D.desc
		new_item.dir = D.dir
		new_item.icon = D.build_icon
		new_item.icon_state = D.build_icon_state

//=============
//List of Pipes
//=============

/datum/pipe/pipe_dispenser/simple
	category = "Regular Pipes"
	colorable = TRUE
	connect_types = CONNECT_TYPE_REGULAR
	pipe_color = PIPE_COLOR_GREY

/datum/pipe/pipe_dispenser/simple/straight
	name = "a pipe fitting"
	desc = "a straight pipe segment."
	build_path = /obj/item/pipe
	pipe_type = PIPE_SIMPLE_STRAIGHT

/datum/pipe/pipe_dispenser/simple/bent
	name = "bent pipe fitting"
	desc = "a bent pipe segment"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SIMPLE_BENT
	dir = 5

/datum/pipe/pipe_dispenser/simple/manifold
	name = "pipe manifold fitting"
	desc = "a pipe manifold segment"
	build_path = /obj/item/pipe
	pipe_type = PIPE_MANIFOLD
	build_icon_state = "manifold"

/datum/pipe/pipe_dispenser/simple/manifold4w
	name = "four-way pipe manifold fitting"
	desc = "a four-way pipe manifold segment"
	build_path = /obj/item/pipe
	pipe_type = PIPE_MANIFOLD4W
	build_icon_state = "manifold4w"

/datum/pipe/pipe_dispenser/simple/cap
	name = "pipe cap fitting"
	desc = "a pipe cap for a regular pipe."
	build_path = /obj/item/pipe
	pipe_type = PIPE_CAP
	build_icon_state = "cap"

/datum/pipe/pipe_dispenser/simple/down
	name = "downward pipe fitting"
	desc = "a downward pipe."
	build_path = /obj/item/pipe
	pipe_type = PIPE_DOWN
	build_icon = 'icons/obj/structures.dmi'
	build_icon_state = "down"

/datum/pipe/pipe_dispenser/simple/up
	name = "upward pipe fitting"
	desc = "an upward pipe."
	build_path = /obj/item/pipe
	pipe_type = PIPE_UP
	build_icon = 'icons/obj/structures.dmi'
	build_icon_state = "up"

/datum/pipe/pipe_dispenser/supply
	category = "Supply Pipes"
	colorable = FALSE
	connect_types = CONNECT_TYPE_SUPPLY
	pipe_color = PIPE_COLOR_BLUE

/datum/pipe/pipe_dispenser/supply/straight
	name = "supply pipe fitting"
	desc = "a straight supply pipe segment."
	build_path = /obj/item/pipe
	pipe_type = PIPE_SUPPLY_STRAIGHT

/datum/pipe/pipe_dispenser/supply/bent
	name = "bent supply pipe fitting"
	desc = "a bent supply pipe segment"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SUPPLY_BENT
	dir = 5

/datum/pipe/pipe_dispenser/supply/manifold
	name = "supply pipe manifold fitting"
	desc = "a supply pipe manifold segment"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SUPPLY_MANIFOLD
	build_icon_state = "manifold"

/datum/pipe/pipe_dispenser/supply/manifold4w
	name = "four-way supply pipe manifold fitting"
	desc = "a four-way supply pipe manifold segment"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SUPPLY_MANIFOLD4W
	build_icon_state = "manifold4w"

/datum/pipe/pipe_dispenser/supply/cap
	name = "supply pipe cap fitting"
	desc = "a pipe cap for a regular pipe."
	build_path = /obj/item/pipe
	pipe_type = PIPE_SUPPLY_CAP
	build_icon_state = "cap"

/datum/pipe/pipe_dispenser/supply/up
	name = "upward supply pipe fitting"
	desc = "an upward supply pipe segment."
	build_path = /obj/item/pipe
	pipe_type = PIPE_SUPPLY_CAP
	build_icon = 'icons/obj/structures.dmi'
	build_icon_state = "up"

/datum/pipe/pipe_dispenser/supply/down
	name = "downward supply pipe fitting"
	desc = "a downward supply pipe segment."
	build_path = /obj/item/pipe
	pipe_type = PIPE_SUPPLY_CAP
	build_icon = 'icons/obj/structures.dmi'
	build_icon_state = "up"

/datum/pipe/pipe_dispenser/scrubber
	category = "Scrubber Pipes"
	colorable = FALSE
	connect_types = CONNECT_TYPE_SCRUBBER
	pipe_color = PIPE_COLOR_RED

/datum/pipe/pipe_dispenser/scrubber/straight
	name = "scrubber pipe fitting"
	desc = "a straight scrubber pipe segment"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SCRUBBERS_STRAIGHT

/datum/pipe/pipe_dispenser/scrubber/bent
	name = "bent scrubber pipe fitting"
	desc = "a bent scrubber pipe segment"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SCRUBBERS_BENT
	dir = 5

/datum/pipe/pipe_dispenser/scrubber/manifold
	name = "scrubber pipe manifold fitting"
	desc = "a scrubber pipe manifold segment"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SCRUBBERS_MANIFOLD
	build_icon_state = "manifold"

/datum/pipe/pipe_dispenser/scrubber/manifold4w
	name = "four-way supply pipe manifold fitting"
	desc = "a four-way scrubber pipe manifold segment"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SCRUBBERS_MANIFOLD4W
	build_icon_state = "manifold4w"

/datum/pipe/pipe_dispenser/scrubber/cap
	name = "scrubber pipe cap fitting"
	desc = "a pipe cap for a scrubber pipe."
	build_path = /obj/item/pipe
	pipe_type = PIPE_SCRUBBERS_CAP
	build_icon_state = "cap"

/datum/pipe/pipe_dispenser/fuel
	category = "Fuel Pipes"
	colorable = FALSE
	pipe_color = PIPE_COLOR_ORANGE
	connect_types = CONNECT_TYPE_FUEL

/datum/pipe/pipe_dispenser/fuel/straight
	name = "fuel pipe fitting"
	desc = "a striaght fuel pipe segment"
	build_path = /obj/item/pipe
	pipe_type = PIPE_FUEL_STRAIGHT

/datum/pipe/pipe_dispenser/fuel/bent
	name = "bent fuel pipe fitting"
	desc = "a bent fuel pipe segment"
	build_path = /obj/item/pipe
	pipe_type = PIPE_FUEL_BENT
	dir = 5

/datum/pipe/pipe_dispenser/fuel/manifold
	name = "fuel pipe manifold fitting"
	desc = "a fuel pipe manifold segment"
	build_path = /obj/item/pipe
	pipe_type = PIPE_FUEL_MANIFOLD
	build_icon_state = "manifold"

/datum/pipe/pipe_dispenser/fuel/manifold4w
	name = "four-way supply pipe manifold fitting"
	desc = "a four-way fuel pipe manifold segment"
	build_path = /obj/item/pipe
	pipe_type = PIPE_FUEL_MANIFOLD4W
	build_icon_state = "manifold4w"

/datum/pipe/pipe_dispenser/fuel/cap
	name = "fuel pipe cap fitting"
	desc = "a pipe cap for a fuel pipe."
	build_path = /obj/item/pipe
	pipe_type = PIPE_FUEL_CAP
	build_icon_state = "cap"

/datum/pipe/pipe_dispenser/he
	category = "Heat Exchange Pipes"
	colorable = FALSE
	connect_types = CONNECT_TYPE_HE

/datum/pipe/pipe_dispenser/he/straight
	name = "heat exchanger pipe fitting"
	desc = "a heat exchanger pipe segment"
	build_path = /obj/item/pipe
	pipe_type = PIPE_HE_STRAIGHT
	build_icon_state = "he"

/datum/pipe/pipe_dispenser/he/bent
	name = "bent heat exchanger pipe fitting"
	desc = "a bent heat exchanger pipe segment"
	build_path = /obj/item/pipe
	pipe_type = PIPE_HE_BENT
	connect_types = CONNECT_TYPE_HE
	build_icon_state = "he"
	dir = 5

/datum/pipe/pipe_dispenser/he/junction
	name = "heat exchanger junction"
	desc = "a heat exchanger junction"
	build_path = /obj/item/pipe
	pipe_type = PIPE_JUNCTION
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_HE
	build_icon_state = "junction"

/datum/pipe/pipe_dispenser/he/exchanger
	name = "heat exchanger"
	desc = "a heat exchanger"
	build_path = /obj/item/pipe
	pipe_type = PIPE_HEAT_EXCHANGE
	connect_types = CONNECT_TYPE_REGULAR
	build_icon_state = "heunary"

/datum/pipe/pipe_dispenser/device
	category = "Devices"
	colorable = TRUE
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_FUEL|CONNECT_TYPE_SCRUBBER
	pipe_color = PIPE_COLOR_GREY

/datum/pipe/pipe_dispenser/device/universaladapter
	name = "universal pipe adapter"
	desc = "an adapter designed to fit any type of pipe."
	build_path = /obj/item/pipe
	pipe_type = PIPE_UNIVERSAL
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_FUEL|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_HE
	build_icon_state = "universal"

/datum/pipe/pipe_dispenser/device/connector
	name = "connector"
	desc = "a connector for canisters."
	build_path = /obj/item/pipe
	pipe_type = PIPE_CONNECTOR
	connect_types = CONNECT_TYPE_REGULAR
	build_icon_state = "connector"

/datum/pipe/pipe_dispenser/device/unaryvent
	name = "unary vent"
	desc = "a unary vent"
	build_path = /obj/item/pipe
	pipe_type = PIPE_UVENT
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_FUEL
	build_icon_state = "uvent"

/datum/pipe/pipe_dispenser/device/gaspump
	name = "gas pump"
	desc = "a pump. For gasses."
	build_path = /obj/item/pipe
	pipe_type = PIPE_PUMP
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL
	build_icon_state = "pump"

/datum/pipe/pipe_dispenser/device/pressureregulator
	name = "pressure regulator"
	desc = "a device that regulates pressure."
	build_path = /obj/item/pipe
	pipe_type = PIPE_PASSIVE_GATE
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL
	build_icon_state = "passivegate"

/datum/pipe/pipe_dispenser/device/hpgaspump
	name = "high powered gas pump"
	desc = "a high powered pump. For gasses."
	build_path = /obj/item/pipe
	pipe_type = PIPE_VOLUME_PUMP
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL
	build_icon_state = "volumepump"

/datum/pipe/pipe_dispenser/device/scrubber
	name = "scrubber"
	desc = "scrubs out undesirable gasses"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SCRUBBER
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER
	build_icon_state = "scrubber"

/datum/pipe/pipe_dispenser/device/meter
	name = "meter"
	desc = "a meter that monitors pressure and temperature on the attached pipe."
	build_path = /obj/item/pipe_meter
	pipe_type = null
	pipe_color = null
	connect_types = null
	colorable = FALSE
	build_icon_state = "meter"

/datum/pipe/pipe_dispenser/device/omnimixer
	name = "omni gas mixer"
	desc = "a device that takes in two or three gasses and mixes them into a precise output."
	build_path = /obj/item/pipe
	pipe_type = PIPE_OMNI_MIXER
	connect_types = CONNECT_TYPE_REGULAR
	build_icon_state = "omni_mixer"

/datum/pipe/pipe_dispenser/device/omnifilter
	name = "omni gas filter"
	desc = "a device that filters out undesireable elements"
	build_path = /obj/item/pipe
	pipe_type = PIPE_OMNI_FILTER
	connect_types = CONNECT_TYPE_REGULAR
	build_icon_state = "omni_filter"

/datum/pipe/pipe_dispenser/device/manualvalve
	name = "manual valve"
	desc = "a valve that has to be manipulated by hand"
	build_path = /obj/item/pipe
	pipe_type = PIPE_MVALVE
	build_icon_state = "mvalve"

/datum/pipe/pipe_dispenser/device/digitalvalve
	name = "digital valve"
	desc = "a valve controlled electronically"
	build_path = /obj/item/pipe
	pipe_type = PIPE_DVALVE
	build_icon_state = "dvalve"

/datum/pipe/pipe_dispenser/device/autoshutoff
	name = "automatic shutoff valve"
	desc = "a valve that can automatically shut itself off"
	build_path = /obj/item/pipe
	pipe_type = PIPE_SVALVE
	build_icon_state = "svalve"

/datum/pipe/pipe_dispenser/device/mtvalve
	name = "manual t-valve"
	desc = "a three-way valve. T-shaped."
	build_path = /obj/item/pipe
	pipe_type = PIPE_MTVALVE
	build_icon_state = "mtvalve"

/datum/pipe/pipe_dispenser/device/mtvalvem
	name = "manual t-valve"
	desc = "a three-way valve. T-shaped."
	build_path = /obj/item/pipe
	pipe_type = PIPE_MTVALVEM
	build_icon_state = "mtvalvem"

/datum/pipe/pipe_dispenser/device/air_sensor
	name = "gas sensor"
	desc = "a sensor. It detects gasses."
	build_path = /obj/item/air_sensor
	pipe_type = null
	build_icon_state = "gsensor1"
	build_icon = 'icons/obj/stationobjs.dmi'
	pipe_color = null
	connect_types = null
	colorable = FALSE

/datum/pipe/pipe_dispenser/device/outlet_injector
	name = "air injector"
	desc = "Passively injects air into its surroundings. Has a valve attached to it that can control flow rate."
	build_icon = 'icons/atmos/injector.dmi'
	build_icon_state = "off"
	build_path = /obj/item/outlet_injector
	connect_types = null
	colorable = FALSE
	pipe_type = null
	pipe_color = null

//Cleanup
#undef PIPE_NORMAL
#undef PIPE_BENT