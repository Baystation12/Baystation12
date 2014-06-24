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
		if(!state)
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
	var/concentration = 1
	var/con_lock = 0
	var/target_pressure = 0
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

var/global/list/pipe_colors = list("Grey" = null, "Red" = PIPE_COLOR_RED, "Blue" = PIPE_COLOR_BLUE, "Cyan" = PIPE_COLOR_CYAN, "Green" = PIPE_COLOR_GREEN, "Yellow" = PIPE_COLOR_YELLOW, "Purple" = PIPE_COLOR_PURPLE)

/proc/dout(var/string)
	world << "<B>\blue DEBUG: [string]<B>"

/proc/dir_name(var/dir = 0)
	switch(dir)
		if(NORTH)
			return "North"
		if(SOUTH)
			return "South"
		if(EAST)
			return "East"
		if(WEST)
			return "West"
		else
			return "None"

/proc/dir_flag(var/dir = "None")
	switch(dir)
		if("North")
			return NORTH
		if("South")
			return SOUTH
		if("East")
			return EAST
		if("West")
			return WEST
		else
			return 0