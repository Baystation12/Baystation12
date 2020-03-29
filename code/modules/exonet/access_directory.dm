/obj/machinery/exonet/access_directory
	name = "EXONET Access Controller"
	desc = "A very complex machine that manages the security for an EXONET system. Looks fragile."
	active_power_usage = 4 KILOWATTS
	ui_template = "exonet_access_directory.tmpl"

	// These are program stateful variables.
	var/file_server				// What file_server we're viewing. This is a net_tag or other.
	var/editing_user			// If we're editing a user, it's assigned here.
	var/awaiting_cortical_scan	// If this is true, we're waiting for someone to touch the stupid interface so that'll add a new user record.
	var/last_scan				// The UID of the person last scanned by this machine. Do not deserialize this. It's worthless.

/obj/machinery/exonet/access_directory/on_update_icon()
	if(operable())
		icon_state = "bus"
	else
		icon_state = "bus_off"

/obj/machinery/exonet/access_directory/proc/do_cortical_scan(var/mob/M)
	// Do a scan on the mob. Pick up their cortical stack.
	// Make a new access record for them, and then change modes into editing user mode.

/obj/machinery/exonet/access_directory/build_ui_data()
	. = ..()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	if(!file_server)
		var/list/mainframes = exonet.get_mainframes()
		if(mainframes.len <= 0)
			.["error"] = "NETWORK ERROR: No mainframes are available for storing security records."
			return .
		file_server = exonet.get_network_tag(mainframes[1])

	.["file_server"] = file_server
	.["editing_user"] = editing_user
	.["awaiting_cortical_scan"] = awaiting_cortical_scan
	if(awaiting_cortical_scan)
		return .

	// Let's build some data.
	var/obj/machinery/exonet/mainframe/mainframe = exonet.get_device_by_tag(file_server)
	if(!mainframe || !mainframe.operable())
		.["error"] = "NETWORK ERROR: Mainframe is offline."
		return .
	if(editing_user)
		.["user_id"] = editing_user
		var/list/grants = list()
		// We're editing a user, so we only need to build a subset of data.
		for(var/datum/computer_file/data/access_record/AR in mainframe.stored_files)
			if(AR.user_id != editing_user)
				continue
			.["desired_name"]	= AR.desired_name
			.["grant_count"] 	= AR.get_valid_grants().len
			.["size"] 			= AR.size
			// Oh hey here's the record we're looking for.
			for(var/datum/computer_file/data/grant_record/GR in AR.get_valid_grants())
				grants.Add(list(
					"name" = GR.stored_data
				))
		.["grants"] = grants
	else
		// We're looking at all records. Or lack thereof.
		var/list/users = list()
		for(var/datum/computer_file/data/access_record/AR in mainframe.stored_files)
			users.Add(list(
				"desired_name" = AR.desired_name,
				"user_id" = AR.user_id,
				"grant_count" = AR.get_valid_grants().len,
				"size" = AR.size
			))
		.["users"] = users