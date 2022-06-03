// /program/ files are executable programs that do things. FILE NAME MUST BE UNIQUE IF YOU WANT THE PROGRAM TO BE DOWNLOADABLE FROM NTNET!
/datum/computer_file/program
	filename = "UnknownProgram"
	filetype = "PRG"

	/// List of required accesses to run/download the program.
	var/required_access = null
	/// Whether the program checks for required_access when run.
	var/requires_access_to_run = TRUE
	/// Whether the program checks for required_access when downloading.
	var/requires_access_to_download = TRUE

	/// If the program uses NanoModule, put it here and it will be automagically opened. Otherwise implement ui_interact.
	var/datum/nano_module/NM = null
	/// Path to nanomodule, make sure to set this if implementing new program.
	var/nanomodule_path = null
	/// One of `PROGRAM_STATE_*` - specifies whether this program is running.
	var/program_state = PROGRAM_STATE_KILLED
	/// OS that this program is running on.
	var/datum/extension/interactive/ntos/computer

	/// User-friendly name of this program.
	var/filedesc = "Unknown Program"
	/// Short description of this program's function.
	var/extended_desc = "N/A"
	/// Category that this program belongs to.
	var/category = PROG_MISC
	/// Bitflags (Any of `PROGRAM_*`) or PROGRAM_ALL
	var/usage_flags = PROGRAM_ALL & ~PROGRAM_PDA

	/// Program-specific screen icon state.
	var/program_icon_state = null
	/// Program-specific keyboard icon state.
	var/program_key_state = "standby_key"
	/// Icon to use for program's link in main menu.
	var/program_menu_icon = "newwin"
	/// Example: "something.gif" - a header image that will be rendered in computer's UI when this program is running at background. Images are taken from /nano/images/status_icons.
	var/ui_header = null

	/// Set to TRUE for program to require nonstop NTNet connection to run. If NTNet connection is lost program crashes.
	var/requires_ntnet = FALSE
	/// Optional, if above is set to TRUE, checks for specific function of NTNet (One of NTNET_*).
	var/requires_ntnet_feature = 0
	/// Optional string that describes what NTNet server/system this program connects to. Used in default logging.
	var/network_destination = null

	/// Whether the program can be downloaded from NTNet. Set to FALSE to disable.
	var/available_on_ntnet = TRUE
	/// Whether the program can be downloaded from SyndiNet (accessible via emagging the computer). Set to TRUE to enable.
	var/available_on_syndinet = FALSE
	/// Holder for skill value of current/recent operator for programs that tick.
	var/operator_skill = SKILL_MIN

/datum/computer_file/program/Destroy()
	if(computer && computer.active_program == src)
		computer.kill_program(src)
	computer = null
	. = ..()

/datum/computer_file/program/nano_host()
	return computer && computer.nano_host()

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

/// Relays icon update to the computer.
/datum/computer_file/program/proc/update_computer_icon()
	if(istype(computer))
		computer.update_host_icon()
		return

/datum/computer_file/program/proc/is_supported_by_hardware(var/hardware_flag)
	if(!(hardware_flag & usage_flags))
		return FALSE
	return TRUE

/// Called by Process() on device that runs us, once every tick. Remember to call ..() if overriding
/datum/computer_file/program/proc/process_tick()
	return

/// Attempts to create a log in global ntnet datum. Returns TRUE on success, FALSE on fail.
/datum/computer_file/program/proc/generate_network_log(text)
	if(computer)
		return computer.add_log(text)
	return FALSE

/// Check if the user can run program. Only humans can operate computer. Automatically called in run_program(). User has to wear their ID or have it inhand for ID Scan to work. Can also be called manually, with optional parameter being access_to_check to scan the user's ID
/datum/computer_file/program/proc/can_run(mob/living/user, loud = FALSE, access_to_check)
	if(!requires_access_to_run)
		return TRUE
	// Defaults to required_access
	if(!access_to_check)
		access_to_check = required_access
	if(!access_to_check) // No required_access, allow it.
		return TRUE

	// Admin override - allows operation of any computer as aghosted admin, as if you had any required access.
	if(isghost(user) && check_rights(R_ADMIN, 0, user))
		return TRUE

	if(!istype(user))
		return FALSE

	var/obj/item/card/id/I = user.GetIdCard()
	if(!I)
		if(loud)
			to_chat(user, "<span class='notice'>\The [computer] flashes an \"RFID Error - Unable to scan ID\" warning.</span>")
		return FALSE

	if(access_to_check in I.access)
		return TRUE
	else if(loud)
		to_chat(user, "<span class='notice'>\The [computer] flashes an \"Access Denied\" warning.</span>")

/// This attempts to retrieve header data for NanoUIs. If implementing completely new device of different type than existing ones, always include the device here in this proc. This proc basically relays the request to whatever is running the program.
/datum/computer_file/program/proc/get_header_data()
	if(computer)
		return computer.get_header_data()
	return list()

/// When implementing new program based device, use this to run the program. May be overriden to add extra logic. Remember to include ..() call.
/datum/computer_file/program/proc/on_startup(mob/living/user, datum/extension/interactive/ntos/new_host)
	program_state = PROGRAM_STATE_BACKGROUND
	computer = new_host
	if(nanomodule_path)
		NM = new nanomodule_path(src, new /datum/topic_manager/program(src), src)
		if(user)
			NM.using_access = user.GetAccess()
	if(requires_ntnet && network_destination)
		generate_network_log("Connection opened to [network_destination].")
	return TRUE

/// Use this proc to kill the program. Designed to be implemented by each program if it requires on-quit logic, such as the NTNRC client.
/datum/computer_file/program/proc/on_shutdown(forced = 0)
	program_state = PROGRAM_STATE_KILLED
	if(requires_ntnet && network_destination)
		generate_network_log("Connection to [network_destination] closed.")
	if(NM)
		qdel(NM)
		NM = null
	return TRUE

/// This is called every tick when the program is enabled. Ensure you do parent call if you override it. If parent returns TRUE continue with UI initialisation. It returns FALSE if it can't run or if NanoModule was used instead. I suggest using NanoModules where applicable.
/datum/computer_file/program/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(program_state != PROGRAM_STATE_ACTIVE) // Our program was closed. Close the ui if it exists.
		if(ui)
			ui.close()
		return computer.ui_interact(user)
	if(istype(NM))
		NM.ui_interact(user, ui_key, null, force_open)
		return FALSE
	return TRUE

/**
  * CONVENTIONS, READ THIS WHEN CREATING NEW PROGRAM AND OVERRIDING THIS PROC:
  * Topic calls are automatically forwarded from NanoModule this program contains.
  * Calls beginning with "PRG_" are reserved for programs handling.
  * Calls beginning with "PC_" are reserved for computer handling (by whatever runs the program)
  * ALWAYS INCLUDE PARENT CALL ..() AT THE TOP OF THE PROC OR DIE IN FIRE.
  * Return values should be one of TOPIC_*
  */
/datum/computer_file/program/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED
	if(computer)
		return computer.Topic(href, href_list)

/// Relays the call to nano module, if we have one
/datum/computer_file/program/proc/check_eye(var/mob/user)
	if(NM)
		return NM.check_eye(user)
	else
		return -1

/datum/nano_module/program
	available_to_ai = FALSE
	var/datum/computer_file/program/program = null	// Program-Based computer program that runs this nano module. Defaults to null.

/datum/nano_module/program/New(host, topic_manager, program)
	..()
	src.program = program

/datum/topic_manager/program
	var/datum/program

/datum/topic_manager/program/New(datum/program)
	..()
	src.program = program

/// Calls forwarded to PROGRAM itself should begin with "PRG_", calls forwarded to COMPUTER running the program should begin with "PC_"
/datum/topic_manager/program/Topic(href, href_list)
	return program && program.Topic(href, href_list)

/datum/computer_file/program/apply_visual(mob/M)
	if(NM)
		NM.apply_visual(M)

/datum/computer_file/program/remove_visual(mob/M)
	if(NM)
		NM.remove_visual(M)
