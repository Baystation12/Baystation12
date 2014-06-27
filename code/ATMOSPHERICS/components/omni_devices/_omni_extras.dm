//--------------------------------------------
// Omni device port types
//--------------------------------------------
#define ATM_NONE	0
#define ATM_INPUT	1
#define ATM_OUTPUT	2

#define ATM_O2		3
#define ATM_N2		4
#define ATM_CO2		5
#define ATM_P		6	//Phoron
#define ATM_N2O		7

//--------------------------------------------
// Omni device cached icon list
//--------------------------------------------
var/global/list/omni_icons[]

/proc/gen_omni_icons()
	omni_icons = new()
	var/icon/omni = new('icons/obj/atmospherics/omni_devices.dmi')

	for(var/state in omni.IconStates())
		if(!state || findtext(state, "map"))
			continue

		var/image/I = image('icons/obj/atmospherics/omni_devices.dmi', icon_state = state)

		if(findtext(state, "pipe"))
			for(var/pipe_color in pipe_colors)
				I = image('icons/obj/atmospherics/omni_devices.dmi', icon_state = state)
				I.color = pipe_colors[pipe_color]
				var/cache_name = state
				if(I.color)
					cache_name += "_[pipe_colors[pipe_color]]"
				omni_icons[cache_name] = I
		else
			omni_icons[state] = I


//--------------------------------------------
// Omni port datum
//
// Used by omni devices to manage connections 
//  to other atmospheric objects.
//--------------------------------------------
/datum/omni_port
	var/obj/machinery/atmospherics/omni/master
	var/dir
	var/update = 1
	var/mode = 0
	var/concentration = 0
	var/con_lock = 0
	var/transfer_moles = 0
	var/datum/gas_mixture/air
	var/obj/machinery/atmospherics/node
	var/datum/pipe_network/network

/datum/omni_port/New(var/obj/machinery/atmospherics/omni/M, var/direction = NORTH)
	..()
	dir = direction
	if(istype(M))
		master = M
	air = new
	air.volume = 200

/datum/omni_port/proc/connect()
	if(node)
		return
	master.initialize()
	master.build_network()
	if(node)
		node.initialize()
		node.build_network()

/datum/omni_port/proc/disconnect()
	if(node)
		node.disconnect(master)
		master.disconnect(node)


//--------------------------------------------
// Need to find somewhere else for these
//--------------------------------------------

#define PIPE_COLOR_RED		"#ff0000"
#define PIPE_COLOR_BLUE		"#0000ff"
#define PIPE_COLOR_CYAN		"#00ffff"
#define PIPE_COLOR_GREEN	"#00ff00"
#define PIPE_COLOR_YELLOW	"#ffcc00"
#define PIPE_COLOR_PURPLE	"#5c1ec0"

var/global/list/pipe_colors = list("grey" = null, "red" = PIPE_COLOR_RED, "blue" = PIPE_COLOR_BLUE, "cyan" = PIPE_COLOR_CYAN, "green" = PIPE_COLOR_GREEN, "yellow" = PIPE_COLOR_YELLOW, "purple" = PIPE_COLOR_PURPLE)


//returns a text string based on the direction flag input
// if capitalize is true, it will return the string capitalized
// otherwise it will return the direction string in lower case
/proc/dir_name(var/dir, var/capitalize = 0)
	var/string = null
	switch(dir)
		if(NORTH)
			string = "North"
		if(SOUTH)
			string = "South"
		if(EAST)
			string = "East"
		if(WEST)
			string = "West"
	
	if(!capitalize && string)
		string = lowertext(string)
	
	return string

//returns a direction flag based on the string passed to it
// case insensitive
/proc/dir_flag(var/dir)
	dir = lowertext(dir)
	switch(dir)
		if("north")
			return NORTH
		if("south")
			return SOUTH
		if("east")
			return EAST
		if("west")
			return WEST
		else
			return 0