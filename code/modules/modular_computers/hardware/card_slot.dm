/obj/item/stock_parts/computer/card_slot
	name = "RFID card slot"
	desc = "Slot that allows this computer to write data on RFID cards. Necessary for some programs to run properly."
	power_usage = 10 //W
	critical = FALSE
	icon_state = "cardreader"
	hardware_size = 1
	origin_tech = list(TECH_DATA = 2)
	usage_flags = PROGRAM_ALL & ~PROGRAM_PDA
	external_slot = TRUE
	var/can_write = TRUE
	var/can_broadcast = FALSE

	var/obj/item/card/id/stored_card = null

/obj/item/stock_parts/computer/card_slot/diagnostics()
	. = ..()
	. += "[name] status: [stored_card ? "Card Inserted" : "Card Not Present"]\n"
	if(stored_card)
		. += "Testing card read...\n"
		if( damage >= damage_failure )
			. += "...FAILURE!\n"
		else
			var/read_string_stability
			if(check_functionality())
				read_string_stability = 100
			else
				read_string_stability = 100 - malfunction_probability
			. += "Registered Name: [stars(stored_card.registered_name, read_string_stability)]\n"
			. += "Registered Assignment: [stars(stored_card.assignment, read_string_stability)]\n"
			. += "Registered Rank: [stars(stored_card.rank, read_string_stability)]\n"
			. += "Access Addresses Enabled: \n"
			var/list/access_list = stored_card.GetAccess()
			if(!access_list) // "NONE" for empty list
				. += "NONE"
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
				. += jointext(list_of_accesses, ", ") + "\n" // Should append a proper, comma separated list.

/obj/item/stock_parts/computer/card_slot/proc/verb_eject_id()
	set name = "Remove ID"
	set category = "Object"
	set src in view(1)

	if(!CanPhysicallyInteract(usr))
		to_chat(usr, "<span class='warning'>You can't reach it.</span>")
		return

	var/obj/item/stock_parts/computer/card_slot/device = src
	if (!istype(device))
		device = locate() in src

	if(!device.stored_card)
		if(usr)
			to_chat(usr, "There is no card in \the [src]")
		return

	device.eject_id(usr)

/obj/item/stock_parts/computer/card_slot/proc/eject_id(mob/user)
	if(!stored_card)
		return FALSE

	if(user)
		to_chat(user, "You remove [stored_card] from [src].")
		user.put_in_hands(stored_card)
	else
		dropInto(loc)
	stored_card = null

	var/datum/extension/interactive/ntos/os = get_extension(loc, /datum/extension/interactive/ntos)
	if(os)
		os.event_idremoved()
	loc.verbs -= /obj/item/stock_parts/computer/card_slot/proc/verb_eject_id
	return TRUE

/obj/item/stock_parts/computer/card_slot/proc/insert_id(obj/item/card/id/I, mob/user)
	if(!istype(I))
		return FALSE

	if(stored_card)
		to_chat(user, "You try to insert [I] into [src], but its ID card slot is occupied.")
		return FALSE

	if(user && !user.unEquip(I, src))
		return FALSE

	stored_card = I
	to_chat(user, "You insert [I] into [src].")
	if(isobj(loc))
		loc.verbs |= /obj/item/stock_parts/computer/card_slot/proc/verb_eject_id
	return TRUE

/obj/item/stock_parts/computer/card_slot/attackby(obj/item/card/id/I, mob/living/user)
	if(!istype(I))
		return ..()
	insert_id(I, user)
	return TRUE

/obj/item/stock_parts/computer/card_slot/broadcaster // read only
	name = "RFID card broadcaster"
	desc = "Reads and broadcasts the RFID signal of an inserted card."
	can_write = FALSE
	can_broadcast = TRUE

	usage_flags = PROGRAM_PDA

/obj/item/stock_parts/computer/card_slot/Destroy()
	if (loc)
		loc.verbs -= /obj/item/stock_parts/computer/card_slot/proc/verb_eject_id
	if(stored_card)
		QDEL_NULL(stored_card)
	return ..()
