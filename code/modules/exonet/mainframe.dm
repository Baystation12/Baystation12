// Relays don't handle any actual communication. Global NTNet datum does that, relays only tell the datum if it should or shouldn't work.
/obj/machinery/exonet/mainframe
	name = "EXONET Mainframe"
	desc = "A very complex mainframe capable of storing massive amounts of data. Looks fragile."
	use_power = POWER_USE_ACTIVE
	active_power_usage = 20000 //20kW
	idle_power_usage = 100
	icon_state = "bus"
	anchored = 1
	density = 1
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = list(
		/obj/item/weapon/stock_parts/computer/hard_drive/small,
		/obj/item/weapon/stock_parts/computer/hard_drive/small,
		/obj/item/weapon/stock_parts/computer/hard_drive/small,
		/obj/item/weapon/stock_parts/computer/hard_drive/small
	)
	var/list/initial_programs		// Optional variable for starting a mainframe with some programs in it.
	stat_immune = 0

	var/setting_max_log_count = 100

	var/max_capacity = 0
	var/used_capacity = 0
	var/list/stored_files = list()		// List of stored files on this mainframe. DO NOT MODIFY DIRECTLY!

/obj/machinery/exonet/mainframe/Initialize()
	if(initial_programs)
		for(var/initial_program in initial_programs)
			var/datum/computer_file/program/prog = new initial_program
			if(!prog || !istype(prog) || prog.filename == "UnknownProgram" || prog.filetype != "PRG")
				continue
			LAZYDISTINCTADD(stored_files, prog)
		initial_programs = null

/obj/machinery/exonet/mainframe/on_update_icon()
	if(operable())
		icon_state = "bus"
	else
		icon_state = "bus_off"

/obj/machinery/exonet/mainframe/proc/get_available_software()
	var/list/programs = list()
	for(var/datum/computer_file/program/prog in stored_files)
		LAZYDISTINCTADD(programs, prog)
	return programs

/obj/machinery/exonet/mainframe/proc/get_log_file()
	var/datum/computer_file/data/logfile/file = find_file_by_name("network_log")
	if(!file)
		file = new()
		file.filename = "network_log"
		store_file(file)
	return file

// Use this proc to add file to the drive. Returns 1 on success and 0 on failure. Contains necessary sanity checks.
/obj/machinery/exonet/mainframe/proc/store_file(var/datum/computer_file/F)
	if(!try_store_file(F))
		return 0
	F.holder = src
	stored_files.Add(F)
	recalculate_size()
	return 1

// Use this proc to remove file from the drive. Returns 1 on success and 0 on failure. Contains necessary sanity checks.
/obj/machinery/exonet/mainframe/proc/remove_file(var/datum/computer_file/F)
	if(!F || !istype(F))
		return 0

	if(!stored_files)
		return 0

	if(!operable())
		return 0

	if(F in stored_files)
		stored_files -= F
		F.holder = null
		recalculate_size()
		return 1
	else
		return 0

// Loops through all stored files and recalculates used_capacity and max_capacity of this mainframe.
/obj/machinery/exonet/mainframe/proc/recalculate_size()
	var/smin = 0
	var/drives = 0
	for(var/obj/item/weapon/stock_parts/computer/hard_drive/hdd in component_parts)
		drives++
		smin = min(smin, hdd.max_capacity)
	max_capacity = (drives - 1) * smin

	var/total_size = 0
	for(var/datum/computer_file/F in stored_files)
		total_size += F.size
	used_capacity = total_size

// Tries to find the file by filename. Returns null on failure
/obj/machinery/exonet/mainframe/proc/find_file_by_name(var/filename)
	if(!operable())
		return null

	if(!filename)
		return null

	if(!stored_files)
		return null

	for(var/datum/computer_file/F in stored_files)
		if(F.filename == filename)
			return F
	return null

// Checks whether we can store the file. We can only store unique files, so this checks whether we wouldn't get a duplicity by adding a file.
/obj/machinery/exonet/mainframe/proc/try_store_file(var/datum/computer_file/F)
	if(!F || !istype(F))
		return 0
	if(!can_store_file(F.size))
		return 0
	if(!operable())
		return 0
	if(!stored_files)
		return 0

	var/list/badchars = list("/","\\",":","*","?","\"","<",">","|","#", ".")
	for(var/char in badchars)
		if(findtext(F.filename, char))
			return 0

	// This file is already stored. Don't store it again.
	if(F in stored_files)
		return 0

	var/name = F.filename + "." + F.filetype
	for(var/datum/computer_file/file in stored_files)
		if((file.filename + "." + file.filetype) == name)
			return 0
	return 1

// Checks whether file can be stored on the hard drive.
/obj/machinery/exonet/mainframe/proc/can_store_file(var/size = 1)
	// In the unlikely event someone manages to create that many files.
	// BYOND is acting weird with numbers above 999 in loops (infinite loop prevention)
	if(stored_files.len >= 999)
		return 0
	if(used_capacity + size > max_capacity)
		return 0
	else
		return 1

/obj/machinery/exonet/mainframe/Destroy()
	stored_files = null
	return ..()