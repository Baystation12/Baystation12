/// Shows information about active NTNet relays
/datum/terminal_command/relays
	name = "relays"
	man_entry = list(
		"Format: relays",
		"Gives information about the active relays found on the network.",
		"NOTICE: Requires network operator or admin access."
	)
	pattern = "^relays$"
	req_access = list(list(access_network, access_network_admin))
	skill_needed = SKILL_EXPERT

/datum/terminal_command/relays/proper_input_entered(text, mob/user, datum/terminal/terminal)
	. = list("[name]: Number of relays found: [ntnet_global.relays.len]")
	for(var/obj/machinery/ntnet_relay/R in ntnet_global.relays)
		. += "Quantum relay ([R.uid]) status: [(R.operable() ? "Reachable" : "Unreachable")]"
		if(R.operable())
			if(!!R.get_component_of_type(/obj/item/stock_parts/computer/hard_drive/portable))
				. += "LOG BACKUP STORAGE DEVICE PRESENT"
			var/area/A = get_area(R)
			. += "Triangulating signal... estimated location: [(A ? sanitize(A.name) : "Unknown")]"
		. += ""
