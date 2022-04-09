/// Pings a remote device, showing the entire chain of proxy devices traversed to reach that device
/datum/terminal_command/ping
	name = "ping"
	man_entry = list(
		"Format: ping \[nid\]",
		"Checks connection to the given nid (number), or directly to NTNet relay if no nid is given."
	)
	pattern = "^ping"
	skill_needed = SKILL_ADEPT

/datum/terminal_command/ping/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/arguments = get_arguments(text)
	if(isnull(arguments) || arguments.len > 1)
		return syntax_error()
	var/obj/item/stock_parts/computer/network_card/origin_nc = terminal.computer.get_component(PART_NETWORK)
	if(!origin_nc || !origin_nc.check_functionality())
		return "[name]: Could not find valid network interface."
	var/nid
	if(arguments.len == 1)
		nid = text2num(arguments[1])
		if(!nid)
			return "[name]: Error; invalid network id."

	. = list("[name]: Establishing route to [(nid ? "NID [nid]" : "NTNet service provider")]")
	var/list/route = origin_nc.get_route()
	for(var/i = 1; i <= route.len; i++)
		var/obj/item/stock_parts/computer/network_card/C = route[i]
		if(!istype(C))
			. += "Error; connection aborted"
			return
		var/result = "proxy NID [C.proxy_id]... success."
		if(i == route.len)
			if(C.proxy_id)
				result = "proxy NID [C.proxy_id]... failed. Target device not responding."
			else
				if(nid)
					result = "target NID [nid]... failed. Target device not responding."
					var/datum/extension/interactive/ntos/comp = ntnet_global.get_os_by_nid(nid)
					if(comp && comp.get_ntnet_status_incoming())
						result = "target NID [nid]... success."
				else
					result = "NTNet service provider... success"
		. += "NID [C.identification_id] connecting to [result]"
