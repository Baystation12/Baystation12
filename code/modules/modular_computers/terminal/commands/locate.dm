/// Get the location of targeted device
/datum/terminal_command/locate
	name = "locate"
	man_entry = list(
		"Format: locate nid",
		"Attempts to locate the device with the given nid by triangulating via relays.",
		"NOTICE: Requires network operator or admin access. Use by non-admins is logged."
	)
	pattern = "locate"
	req_access = list(list(access_network, access_network_admin))
	skill_needed = SKILL_PROF

/datum/terminal_command/locate/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/arguments = get_arguments(text)
	if(isnull(arguments) || arguments.len != 1)
		return syntax_error()
	if(!terminal.computer.get_ntnet_status())
		return network_error()
	var/nid = text2num(arguments[1])
	if(!nid)
		return "[name]: Error; invalid network id."
	if(!has_access(list(access_network_admin), user.GetAccess()))
		terminal.computer.add_log("'[name]' command executed against network id '[nid]'")
	var/datum/extension/interactive/ntos/T = ntnet_global.get_os_by_nid(nid)
	if(!istype(T) || !T.get_ntnet_status_incoming()) // Target device only need a direct connection to NTNet
		return "[name]: Error; can not locate target device. Try ping for diagnostics."
	var/area/A = get_area(T.get_physical_host())
	return "[name]: Searching ... estimated location: [(A ? sanitize(A.name) : "Unknown")]"
