/datum/extension/interactive/ntos
	base_type = /datum/extension/interactive/ntos
	expected_type = /atom/movable
	flags = EXTENSION_FLAG_IMMEDIATE

	/// Whether the computer is turned on
	var/on = FALSE
	/// A currently active program running on the computer.
	var/datum/computer_file/program/active_program = null
	/// Purely for screen visuals. Tracks the last program that was interacted with.
	var/datum/computer_file/program/last_interacted_program = null
	/// All programs currently running, background or active, including small programs.
	var/list/running_programs = list()
	/// Extra programs currently ative in secondary windows.
	var/list/running_program_windows = list()
	/// The processing size being used by all programs.
	var/processing_size = 0

	/// dmi where the screen overlays are kept, defaults to holder's icon if unset
	var/screen_icon_file
	/// Icon state overlay when the computer is turned on, but no program is loaded that would override the screen.
	var/menu_icon = "menu"
	var/screensaver_icon = "standby"

	/// Cached NTNet status for outgoing connections to avoid checking entire proxy chain every time
	var/ntnet_status
	/// Cached NTNet network tag for outgoing connections to avoid checking entire proxy chain every time
	var/network_tag

	// Used for deciding if various tray icons need to be updated
	var/last_battery_percent
	var/last_world_time
	var/list/last_header_icons

	/// Pain and suffering. Sometimes computers are made to update, and you just have to sit through or risk damage by rebooting it
	var/receives_updates = TRUE
	var/updating = FALSE
	var/updates = 0
	var/update_progress = 0
	var/update_postshutdown

	/// Whether the OS can handle multiple windows open
	var/allow_multiple_windows = FALSE

	var/list/terminals

/datum/extension/interactive/ntos/Destroy()
	system_shutdown()
	. = ..()

/datum/extension/interactive/ntos/Process()
	if(on && !host_status())
		system_shutdown()
	if(!on)
		return

	// Clear the cached values
	ntnet_status = null
	network_tag = null

	if(updating)
		process_updates()
		return

	for(var/datum/computer_file/program/P in running_programs)
		if((P.requires_ntnet && !get_ntnet_status()) || (P.requires_ntnet_feature && !get_ntnet_capability(P.requires_ntnet_feature)))
			P.event_networkfailure(P != active_program)
		else if (LAZYLEN(P.required_parts) && !meets_part_requirements(P.required_parts))
			P.event_hardwarecrash(P != active_program)
		else
			P.process_tick()
	regular_ui_update()

/// Returns the status of the physical device the system is running on. Overridden by device subtypes.
/datum/extension/interactive/ntos/proc/host_status()
	return TRUE

/// Handles all cleanup when the system is shut down.
/datum/extension/interactive/ntos/proc/system_shutdown()
	for(var/datum/computer_file/program/P in running_programs)
		kill_program(P, TRUE)

	var/obj/item/stock_parts/computer/network_card/network_card = get_component(PART_NETWORK)
	if(network_card)
		ntnet_global.unregister(network_card.identification_id)

	on = FALSE
	ntnet_status = null
	network_tag = null

	if(updating)
		updating = FALSE
		updates = 0
		update_progress = 0
		var/obj/item/stock_parts/computer/hard_drive/hard_drive = get_component(PART_HDD)
		if(hard_drive)
			if(prob(10))
				hard_drive.visible_message(SPAN_WARNING("[src] emits some ominous clicks."))
				hard_drive.set_damage_malfunction()
			else if(prob(5))
				hard_drive.visible_message(SPAN_WARNING("[src] emits some ominous clicks."))
				hard_drive.set_damage_failure()
	update_host_icon()

/// Handles all setup when the system is booted up.
/datum/extension/interactive/ntos/proc/system_boot()
	on = TRUE

	var/obj/item/stock_parts/computer/network_card/network_card = get_component(PART_NETWORK)
	if(network_card)
		ntnet_global.register(network_card.identification_id, src)

	var/datum/computer_file/data/autorun = get_file("autorun")
	if(istype(autorun))
		run_program(autorun.stored_data, usr)

	update_host_icon(active_program)

/// Attempts to kill a program. Assumes that usr is directly accessing the device.
/datum/extension/interactive/ntos/proc/kill_program(datum/computer_file/program/P, forced = FALSE)
	kill_program_remote(P, forced, usr)

/// Attempts to kill a program.
/datum/extension/interactive/ntos/proc/kill_program_remote(datum/computer_file/program/P, forced = FALSE, mob/user = null)
	if(!P)
		return

	if (!forced && GET_FLAGS(P.usage_flags, PROGRAM_NO_KILL))
		minimize_program(P, user)
		return

	P.on_shutdown(forced)
	running_programs -= P
	close_extra_window(P)
	if(active_program == P)
		active_program = null
		if(ismob(user))
			ui_interact(user) // Re-open the UI on this computer. It should show the main screen now.
		update_host_icon()
	else if (LAZYLEN(running_program_windows))
		update_host_icon(running_program_windows[1])

/datum/extension/interactive/ntos/proc/window_closed(datum/computer_file/program/program, mob/user = null)
	if(!program)
		return
	if ((program in running_program_windows) && CanUseTopic(user) > STATUS_CLOSE)
		minimize_program(program, user)

/datum/extension/interactive/ntos/proc/close_extra_window(datum/computer_file/program/program)
	SSnano.close_uis(program.NM ? program.NM : program)
	running_program_windows.Remove(program)

/datum/extension/interactive/ntos/proc/close_extra_windows()
	for (var/datum/computer_file/program/program in running_program_windows)
		SSnano.close_uis(program.NM ? program.NM : program)
	running_program_windows = list()

/// Attempts to start the named program in the foreground. Assumes that usr is directly accessing the device. Returns the program on success, otherwise null.
/datum/extension/interactive/ntos/proc/run_program(filename, mob/user)
	var/datum/computer_file/program/P = run_program_remote(filename, user, 1)
	if(!istype(P))
		return

	activate_program(P, user)
	return P

/// Attempts to start the named program in an extra window. Assumes that usr is directly accessing the device. Returns the program on success, otherwise null.
/datum/extension/interactive/ntos/proc/run_program_new_window(filename, mob/user)
	if (!allow_multiple_windows)
		return
	var/datum/computer_file/program/program = run_program_remote(filename, user, 1)
	if (!istype(program))
		return
	return activate_program_new_window(program, user)

/// Attempts to start the named program in the background. Returns the program on success, otherwise null.
/datum/extension/interactive/ntos/proc/run_program_remote(filename, mob/user = null, loud = 0)
	var/datum/computer_file/program/P = get_file(filename)

	if (!istype(P))
		loud && show_error(user, "I/O ERROR - Unable to run [filename]")
		return
	if (!P.is_supported_by_hardware(get_hardware_flag()))
		loud && show_error(user, "Hardware Error - Incompatible software")
		return
	if (P.requires_ntnet && !get_ntnet_status(P.requires_ntnet_feature))
		loud && show_error(user, "Unable to establish a working network connection. Please try again later. If problem persists, please contact your system administrator.")
		return
	if (P.required_parts && !meets_part_requirements(P.required_parts))
		loud && show_error(user, "Hardware Error - device is missing necessary components. Please verify installed parts.")
		return

	if (P in running_programs)
		return P

	var/processing_total = 0
	for (var/datum/computer_file/program/program in running_programs)
		processing_total += program.processing_size
	if ((processing_total + P.processing_size) > get_program_capacity() && P.processing_size)
		loud && show_error(user, "Kernel Error - Insufficient CPU resources available to allocate.")
		return
	if (!P.can_run(user, loud))
		return

	P.on_startup(user, src)
	running_programs |= P
	return P

/// Make a program the currently active one if it is running. Returns the program on success, otherwise null.
/datum/extension/interactive/ntos/proc/activate_program(datum/computer_file/program/program, mob/user = null)
	if(!istype(program))
		return
	if((program in running_programs) && program != active_program && program.program_state != PROGRAM_STATE_KILLED)
		minimize_program(program, user)
		program.program_state = PROGRAM_STATE_ACTIVE
		active_program = program
		update_host_icon(program)
		return program

/// Create a new window for the program if it is running. Returns the program on success, otherwise null.
/datum/extension/interactive/ntos/proc/activate_program_new_window(datum/computer_file/program/program, mob/user = null)
	if(!istype(program))
		return
	if((program in running_programs) && !(program in running_program_windows) && program.program_state != PROGRAM_STATE_KILLED)
		minimize_program(program, user)
		program.program_state = PROGRAM_STATE_ACTIVE
		running_program_windows |= program
		update_host_icon(program)
		return program

/// Minimize the currently active program.
/datum/extension/interactive/ntos/proc/minimize_program(datum/computer_file/program/program_to_minimize, mob/user = null)
	if(active_program != program_to_minimize && !(program_to_minimize in running_program_windows))
		return
	program_to_minimize.program_state = PROGRAM_STATE_BACKGROUND // Should close any existing UIs
	SSnano.close_uis(program_to_minimize.NM ? program_to_minimize.NM : program_to_minimize)
	if (active_program == program_to_minimize)
		active_program = null
		update_host_icon()
	close_extra_window(program_to_minimize)
	if(istype(user))
		ui_interact(user) // Re-open the UI on this computer. It should show the main screen now.

/// Set a filename name that the system should attempt to run as a program when it boots up. Returns the autorun file on success, otherwise null.
/datum/extension/interactive/ntos/proc/set_autorun(filename)
	if(!filename)
		return delete_file("autorun")
	return update_data_file("autorun", "[filename]", replace_content = TRUE)

/// Returns the number number of programs this system can run at the same time.
/datum/extension/interactive/ntos/proc/get_program_capacity()
	var/obj/item/stock_parts/computer/processor_unit/C = get_component(PART_CPU)
	if(!istype(C))
		return 0
	return 1 + C.processing_power

/// Adds an entry to the NTNet log with this computer's identity, if the computer has a connection. Returns TRUE on success, otherwise FALSE.
/datum/extension/interactive/ntos/proc/add_log(text)
	if(!get_ntnet_status())
		return FALSE
	return ntnet_global.add_log(text, get_component(PART_NETWORK))

/datum/extension/interactive/ntos/proc/get_physical_host()
	var/atom/A = holder
	if(istype(A))
		return A

/datum/extension/interactive/ntos/proc/handle_updates(shutdown_after)
	updating = TRUE
	update_progress = 0
	update_postshutdown = shutdown_after

/// Used by camera monitor program
/datum/extension/interactive/ntos/proc/check_eye(mob/user)
	if(active_program)
		return active_program.check_eye(user)

/datum/extension/interactive/ntos/proc/process_updates()
	if(update_progress < updates)
		update_progress += rand(0, 2500)
		return

	//It's done.
	updating = FALSE
	update_host_icon(last_interacted_program, FALSE)
	updates = 0
	update_progress = 0

	if(update_postshutdown)
		system_shutdown()

/datum/extension/interactive/ntos/proc/event_powerfailure()
	for(var/datum/computer_file/program/P in running_programs)
		P.event_powerfailure(P != active_program)

/datum/extension/interactive/ntos/proc/event_idremoved()
	for(var/datum/computer_file/program/P in running_programs)
		P.event_idremoved(P != active_program)

/datum/extension/interactive/ntos/proc/has_terminal(mob/user)
	for(var/datum/terminal/terminal in terminals)
		if(terminal.get_user() == user)
			return terminal

/datum/extension/interactive/ntos/proc/open_terminal(mob/user)
	if(!on)
		return
	if(has_terminal(user))
		return
	LAZYADD(terminals, new /datum/terminal/(user, src))

/// Returns TRUE if the system is emagged, otherwise FALSE. Overriden by device subtypes.
/datum/extension/interactive/ntos/proc/emagged()
	return FALSE
