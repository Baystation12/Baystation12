// /program/ files are executable programs that do things.
/datum/computer_file/program
	filetype = "PRG"
	filename = "UnknownProgram"				// File name. FILE NAME MUST BE UNIQUE IF YOU WANT THE PROGRAM TO BE DOWNLOADABLE FROM NTNET!
	var/required_access = null				// List of required accesses to *run* the program.
	var/datum/nano_module/NM = null			// If the program uses NanoModule, put it here and it will be automagically opened. Otherwise implement ui_interact.
	var/nanomodule_path = null				// Path to nanomodule, make sure to set this if implementing new program.
	var/program_state = PROGRAM_STATE_KILLED// PROGRAM_STATE_KILLED or PROGRAM_STATE_BACKGROUND or PROGRAM_STATE_ACTIVE - specifies whether this program is running.
	var/obj/item/modular_computer/computer	// Device that runs this program.
	var/filedesc = "Unknown Program"		// User-friendly name of this program.
	var/extended_desc = "N/A"				// Short description of this program's function.
	var/program_icon_state = null			// Program-specific screen icon state
	var/requires_ntnet = 0					// Set to 1 for program to require nonstop NTNet connection to run. If NTNet connection is lost program crashes.
	var/requires_ntnet_feature = 0			// Optional, if above is set to 1 checks for specific function of NTNet (currently NTNET_SOFTWAREDOWNLOAD, NTNET_PEERTOPEER, NTNET_SYSTEMCONTROL and NTNET_COMMUNICATION)
	var/ntnet_status = 1					// NTNet status, updated every tick by computer running this program. Don't use this for checks if NTNet works, computers do that. Use this for calculations, etc.
	var/usage_flags = PROGRAM_ALL			// Bitflags (PROGRAM_CONSOLE, PROGRAM_LAPTOP, PROGRAM_TABLET combination) or PROGRAM_ALL
	var/network_destination = null			// Optional string that describes what NTNet server/system this program connects to. Used in default logging.
	var/available_on_ntnet = 1				// Whether the program can be downloaded from NTNet. Set to 0 to disable.
	var/available_on_syndinet = 0			// Whether the program can be downloaded from SyndiNet (accessible via emagging the computer). Set to 1 to enable.
	var/computer_emagged = 0				// Set to 1 if computer that's running us was emagged. Computer updates this every Process() tick
	var/ui_header = null					// Example: "something.gif" - a header image that will be rendered in computer's UI when this program is running at background. Images are taken from /nano/images/status_icons. Be careful not to use too large images!

/datum/computer_file/program/New(var/obj/item/modular_computer/comp = null)
	..()
	if(comp && istype(comp))
		computer = comp

/datum/computer_file/program/clone()
	var/datum/computer_file/program/temp = ..()
	temp.required_access = required_access
	temp.nanomodule_path = nanomodule_path
	temp.filedesc = filedesc
	temp.program_icon_state = program_icon_state
	temp.requires_ntnet = requires_ntnet
	temp.requires_ntnet_feature = requires_ntnet_feature
	temp.usage_flags = usage_flags
	return temp

// Relays icon update to the computer.
/datum/computer_file/program/proc/update_computer_icon()
	if(computer)
		computer.update_icon()

// Attempts to create a log in global ntnet datum. Returns 1 on success, 0 on fail.
/datum/computer_file/program/proc/generate_network_log(var/text)
	if(computer)
		return computer.add_log(text)
	return 0

/datum/computer_file/program/proc/is_supported_by_hardware(var/hardware_flag = 0, var/loud = 0, var/mob/user = null)
	if(!(hardware_flag & usage_flags))
		if(loud && computer && user)
			user << "<span class='danger'>\The [computer] flashes an \"Hardware Error - Incompatible software\" warning.</span>"
		return 0
	return 1

/datum/computer_file/program/proc/get_signal(var/specific_action = 0)
	if(computer)
		return computer.get_ntnet_status(specific_action)
	return 0

// Called by Process() on device that runs us, once every tick.
/datum/computer_file/program/proc/process_tick()
	return 1

// Check if the user can run program. Only humans can operate computer. Automatically called in run_program()
// User has to wear their ID or have it inhand for ID Scan to work.
// Can also be called manually, with optional parameter being access_to_check to scan the user's ID
/datum/computer_file/program/proc/can_run(var/mob/living/user, var/loud = 0, var/access_to_check)
	// Defaults to required_access
	if(!access_to_check)
		access_to_check = required_access
	if(!access_to_check) // No required_access, allow it.
		return 1

	var/obj/item/weapon/card/id/I = user.GetIdCard()
	if(!I)
		if(loud)
			user << "<span class='danger'>\The [computer] flashes an \"RFID Error - Unable to scan ID\" warning.</span>"
		return 0

	if(access_to_check in I.access)
		return 1
	else if(loud)
		user << "<span class='danger'>\The [computer] flashes an \"Access Denied\" warning.</span>"

// This attempts to retrieve header data for NanoUIs. If implementing completely new device of different type than existing ones
// always include the device here in this proc. This proc basically relays the request to whatever is running the program.
/datum/computer_file/program/proc/get_header_data()
	if(computer)
		return computer.get_header_data()
	return list()

// This is performed on program startup. May be overriden to add extra logic. Remember to include ..() call. Return 1 on success, 0 on failure.
// When implementing new program based device, use this to run the program.
/datum/computer_file/program/proc/run_program(var/mob/living/user)
	if(can_run(user, 1))
		if(nanomodule_path)
			NM = new nanomodule_path(computer, src)	// Computer is passed here as it's (probably!) physical object. Some UI's perform get_turf() and passing program datum wouldn't go well with this.
		if(requires_ntnet && network_destination)
			generate_network_log("Connection opened to [network_destination].")
		program_state = PROGRAM_STATE_ACTIVE
		return 1
	return 0

// Use this proc to kill the program. Designed to be implemented by each program if it requires on-quit logic, such as the NTNRC client.
/datum/computer_file/program/proc/kill_program(var/forced = 0)
	program_state = PROGRAM_STATE_KILLED
	if(network_destination)
		generate_network_log("Connection to [network_destination] closed.")
	if(NM)
		qdel(NM)
		NM = null
	return 1

// This is called every tick when the program is enabled. Ensure you do parent call if you override it. If parent returns 1 continue with UI initialisation.
// It returns 0 if it can't run or if NanoModule was used instead. I suggest using NanoModules where applicable.
/datum/computer_file/program/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(program_state != PROGRAM_STATE_ACTIVE) // Our program was closed. Close the ui if it exists.
		if(ui)
			ui.close()
		return computer.ui_interact(user)
	if(istype(NM))
		NM.ui_interact(user, ui_key, null, force_open)
		return 0
	return 1


// CONVENTIONS, READ THIS WHEN CREATING NEW PROGRAM AND OVERRIDING THIS PROC:
// Topic calls are automagically forwarded from NanoModule this program contains.
// Calls beginning with "PRG_" are reserved for programs handling.
// Calls beginning with "PC_" are reserved for computer handling (by whatever runs the program)
// ALWAYS INCLUDE PARENT CALL ..() OR DIE IN FIRE.
/datum/computer_file/program/Topic(href, href_list)
	if(..())
		return 1
	if(computer)
		return computer.Topic(href, href_list)
