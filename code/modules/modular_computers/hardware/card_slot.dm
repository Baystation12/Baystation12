/obj/item/weapon/computer_hardware/card_slot
	name = "RFID card slot"
	desc = "Slot that allows this computer to write data on RFID cards. Necessary for some programs to run properly."
	power_usage = 10 //W
	critical = 0
	icon_state = "cardreader"
	hardware_size = 1
	origin_tech = list(TECH_DATA = 2)
	usage_flags = PROGRAM_ALL & ~PROGRAM_PDA
	var/can_write = TRUE
	var/can_broadcast = FALSE

	var/obj/item/weapon/card/id/stored_card = null

/obj/item/weapon/computer_hardware/card_slot/diagnostics(var/mob/user)
	..()
	var/to_send = list()
	to_send += "[name] status: [stored_card ? "Card Inserted" : "Card Not Present"]\n"
	if(stored_card)
		to_send += "Testing card read...\n"
		if( damage >= damage_failure )
			to_send += "...FAILURE!\n"
		else
			var/read_string_stability
			if(check_functionality())
				read_string_stability = 100
			else
				read_string_stability = 100 - malfunction_probability
			to_send += "Registered Name: [stars(stored_card.registered_name, read_string_stability)]\n"
			to_send += "Registered Assignment: [stars(stored_card.assignment, read_string_stability)]\n"
			to_send += "Registered Rank: [stars(stored_card.rank, read_string_stability)]\n"
			to_send += "Access Addresses Enabled: \n"
			var/list/access_list = stored_card.GetAccess()
			if(!access_list) // "NONE" for empty list
				to_send += "NONE"
			else
				var/list_of_accesses = list()
				for(var/access_id in access_list)
					if(check_functionality()) // Read the access, or show "RD_ERR"
						var/datum/access/access_information = get_access_by_id(access_id)
						var/access_type = access_information.access_type
						if(access_type == ACCESS_TYPE_NONE || access_type == ACCESS_TYPE_SYNDICATE || access_type == ACCESS_TYPE_CENTCOM) // Don't elaborate on these access types.
							list_of_accesses += "UNKNOWN" // "UNKNOWN"
						else
							list_of_accesses += uppertext(access_information.desc)
					else
						list_of_accesses += "RD_ERR"
				to_send += jointext(list_of_accesses, ", ") + "\n" // Should append a proper, comma separated list.
	
	to_chat(user, JOINTEXT(to_send))
		

/obj/item/weapon/computer_hardware/card_slot/broadcaster // read only
	name = "RFID card broadcaster"
	desc = "Reads and broadcasts the RFID signal of an inserted card."
	can_write = FALSE
	can_broadcast = TRUE

	usage_flags = PROGRAM_PDA

/obj/item/weapon/computer_hardware/card_slot/Destroy()
	if(holder2 && (holder2.card_slot == src))
		holder2.card_slot = null
	if(stored_card)
		stored_card.dropInto(holder2 ? holder2.loc : loc)
	holder2 = null
	return ..()