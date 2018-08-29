/datum/pipe
	var/name = null				//item's name
	var/desc = null				//item description
	var/item_name = null		//original item's name, in case it gets modified.
	var/item_id = "id"			//ID for easy reference. All lowercase, alpha numeric, no symbols.
	var/build_type = null		//For this set, it's whether it is built at PIPE_DISPENSER or DISPOSAL_DISPENSER
	var/build_path = null		//path of the object that's being created
	var/category = null			//Allows for easy sorting in the menu.
	var/sort_string = "ZZZZ"	//Allows for nudging items to where you want them to appear.
	var/pipe_type = 0			//What sort of pipe this is
	var/connect_types = 0		//what sort of connection this has
	var/pipe_color = 0			//what color the pipe should be by default

/datum/pipe/New()
	..()
	item_name = name
	//AssemblePipeInfo()

//These procs are used in subtypes for assigning names and descriptions dynamically
/datum/pipe/proc/AssemblePipeInfo()
	AssemblePipeName()
	AssemblePipeDesc()
	return

/datum/pipe/proc/AssemblePipeName()
	if(!name && build_path)					//Get name from build path if posible
		var/atom/movable/A = build_path
		name = initial(A.name)
		item_name = name
	return

/datum/pipe/proc/AssemblePipeDesc()
	if(!desc)								//Try to make up a nice description if we don't have one
		desc = "\a [item_name]."
	return

/datum/pipe/proc/Fabricate(var/newloc)
	return new build_path(newloc)

/datum/pipe/straight
	name = "\improper pipe fitting"
	desc = "a straight pipe segment."
	item_id = "straightpipe"
	//build_type = PIPE_DISPENSER
	build_path = /obj/item/pipe
	pipe_type = 0
	connect_types = CONNECT_TYPE_REGULAR
	pipe_color = null

/datum/pipe/straight/supply
	name = "\improper supply pipe fitting"
	desc = "a straight supply pipe segment."
	item_id = "straightsupplypipe"
	//build_type = PIPE_DISPENSER
	build_path = /obj/item/pipe

	pipe_type = 29
	connect_types = CONNECT_TYPE_SUPPLY
	pipe_color = PIPE_COLOR_BLUE

/datum/pipe/straight/scrubber
	name = "\improper scrubber pipe fitting"
	desc = "a straight scrubber pipe segment"
	item_id = "straightscrubberpipe"
	//build_type = PIPE_DISPENSER
	build_path = /obj/machinery/atmospherics/pipe/simple/visible/scrubbers

/datum/pipe/straight/fuel
	name = "\improper fuel pipe fitting"
	desc = "a striaght fuel pipe segment"
	item_id = "straightfuelpipe"
	//build_type = PIPE_DISPENSER
	build_path = /obj/machinery/atmospherics/pipe/simple/visible/fuel