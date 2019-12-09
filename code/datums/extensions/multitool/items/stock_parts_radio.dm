
/datum/extension/interactive/multitool/radio
	var/weakref/machine

/datum/extension/interactive/multitool/radio/extension_status(mob/user)
	var/obj/item/weapon/stock_parts/radio/radio = holder
	if(radio.status & PART_STAT_INSTALLED)
		return STATUS_CLOSE
	return ..()	

/datum/extension/interactive/multitool/radio/interact(obj/item/device/multitool/M, mob/user)
	if(extension_status(user) != STATUS_INTERACTIVE)
		return
	var/obj/machinery/actual_machine = machine && machine.resolve()
	if(!actual_machine && !aquire_target(M, user))
		return
	return ..()

// Could use buffers, but am afraid of multitool interaction clashes.
/datum/extension/interactive/multitool/radio/proc/aquire_target(obj/item/device/multitool/M, mob/user)
	var/candidates = list()
	for(var/obj/machinery/new_machine in view(2, user))
		candidates += new_machine
	if(!length(candidates))
		to_chat(user, "You fail to import configuration settings from anything. Try standing near a machine.")
		return
	var/obj/machinery/input = input(user, "Which machine would you like to configure \the [holder] for?", "Machine Selection") as null|anything in candidates
	if(!istype(input) || (extension_status(user) != STATUS_INTERACTIVE))
		return
	machine = weakref(input)
	return input

/datum/extension/interactive/multitool/radio/get_interact_window(obj/item/device/multitool/M, mob/user)
	var/obj/item/weapon/stock_parts/radio/radio = holder
	var/list/dat = list()

	dat += "<a href='?src=\ref[src];unlink=1'>Unlink Machine</a><br>"
	var/obj/machinery/actual_machine = machine && machine.resolve()
	if(actual_machine && actual_machine.can_apply_preset_to(radio))
		dat += "<a href='?src=\ref[src];stockreset=1'>Reset to Machine Defaults</a><br>"
	dat += "<b>Configuration for \the [radio].</b><br>"
	dat += "Frequency: <a href='?src=\ref[src];frequency=1'>[radio.frequency || "none"]</a><br>"
	dat += "ID: <a href='?src=\ref[src];id_tag=1'>[radio.id_tag || "none"]</a><br>"
	dat += "Filter: <a href='?src=\ref[src];filter=1'>[radio.filter || "none"]</a><br>"
	dat += "Encryption key: <a href='?src=\ref[src];encryption=1'>[radio.encryption || "none"]</a><br>"
	return JOINTEXT(dat)

/datum/extension/interactive/multitool/radio/on_topic(href, href_list, user)
	var/obj/item/weapon/stock_parts/radio/radio = holder
	if(href_list["unlink"])
		machine = null
		return MT_CLOSE
	if(href_list["frequency"])
		var/new_frequency = input(user, "Select a new frequency:", "Frequency Selection", radio.frequency) as null|num
		if(!new_frequency || (extension_status(user) != STATUS_INTERACTIVE))
			return MT_NOACTION
		new_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
		if(new_frequency == radio.frequency)
			return MT_NOACTION
		radio.set_frequency(new_frequency, radio.filter)
		return MT_REFRESH
	if(href_list["id_tag"])
		var/new_id_tag = input(user, "Select a new ID:", "ID Selection", radio.id_tag) as null|text
		if(!new_id_tag || (extension_status(user) != STATUS_INTERACTIVE))
			return MT_NOACTION
		new_id_tag = sanitize(new_id_tag)
		if(new_id_tag == radio.id_tag)
			return MT_NOACTION
		radio.id_tag = new_id_tag
		return MT_REFRESH
	if(href_list["filter"])
		var/new_filter = input(user, "Select a new radio filter:", "Filter Selection", radio.filter) as null|anything in GLOB.all_selectable_radio_filters
		if(!new_filter || (extension_status(user) != STATUS_INTERACTIVE))
			return MT_NOACTION
		if(new_filter == radio.filter)
			return MT_NOACTION
		radio.set_frequency(radio.frequency, new_filter)
		return MT_REFRESH
	if(href_list["encryption"])
		var/new_encryption = input(user, "Select a new encryption key:", "Encryption Key Selection", radio.encryption) as null|num
		if(!new_encryption || (extension_status(user) != STATUS_INTERACTIVE))
			return MT_NOACTION
		new_encryption = sanitize_integer(new_encryption, 0, 999, radio.encryption)
		if(new_encryption == radio.encryption)
			return MT_NOACTION
		radio.encryption = new_encryption
		return MT_REFRESH
	if(href_list["stockreset"])
		var/obj/machinery/actual_machine = machine && machine.resolve()
		if(!actual_machine)
			return MT_CLOSE
		actual_machine.apply_preset_to(radio)
		return MT_REFRESH

// Helper.
/datum/extension/interactive/multitool/radio/proc/event_list_to_selection_table(table_tag, list/selected_events)
	. = list()
	. += "<table>"
	for(var/thing in selected_events)
		. += "<tr>"
		. += "<td><a href='?src=\ref[src];[table_tag]=1;remove=[thing]'>(-)</a></td>"
		. += "<td><a href='?src=\ref[src];[table_tag]=1;rename=[thing]'>[thing]</a></td>"
		var/decl/public_access/variable = selected_events[thing]
		. += "<td><a href='?src=\ref[src];[table_tag]=1;new_val=[thing]'>[variable.name]</a></td>"
		. += "<td><a href='?src=\ref[src];[table_tag]=1;desc=\ref[variable]'>(?)</a></td>"
		. += "</tr>"
	. += "<tr><td><a href='?src=\ref[src];[table_tag]=1;add=1'>(+)</a></td></tr>"
	. += "</table>"

/datum/extension/interactive/multitool/radio/proc/event_list_topic(list/selected_events, list/valid_events, mob/user, href_list)
	if(href_list["remove"])
		var/thing = href_list["remove"]
		LAZYREMOVE(selected_events, thing)
		return MT_REFRESH
	if(href_list["rename"])
		var/thing = href_list["rename"]
		if(selected_events && selected_events[thing])
			var/new_name = input(user, "Select a new message key for this item:", "Key Select", thing) as null|text
			new_name = sanitize(new_name)
			if(!new_name || (extension_status(user) != STATUS_INTERACTIVE))
				return MT_REFRESH
			if(!selected_events || !selected_events[thing])
				return MT_REFRESH
			selected_events[new_name] = selected_events[thing]
			selected_events -= thing
		return MT_REFRESH
	if(href_list["new_val"])
		var/thing = href_list["new_val"]
		var/decl/public_access/variable = selected_events && selected_events[thing]
		if(!variable || !LAZYLEN(valid_events))
			return MT_REFRESH
		var/valid_variables = list()
		for(var/path in valid_events)
			valid_variables += valid_events[path]
		var/new_var = input(user, "Select a new action for this item:", "Action Select", thing) as null|anything in valid_variables
		if(!new_var || (extension_status(user) != STATUS_INTERACTIVE))
			return MT_REFRESH
		if(!(selected_events && selected_events[thing] == variable))
			return MT_REFRESH
		selected_events[thing] = new_var
		return MT_REFRESH
	if(href_list["add"])
		if(!LAZYLEN(valid_events))
			return MT_REFRESH
		LAZYSET(selected_events, copytext(md5(num2text(rand(0, 1))), 1, 11), valid_events[pick(valid_events)]) // random key
		return MT_REFRESH
	if(href_list["desc"])
		var/decl/public_access/variable = locate(href_list["desc"])
		if(istype(variable))
			to_chat(user, variable.desc)
		return MT_NOACTION

/datum/extension/interactive/multitool/radio/transmitter/aquire_target()
	var/obj/machinery/actual_machine = ..()
	. = actual_machine
	if(!actual_machine)
		return
	var/obj/item/weapon/stock_parts/radio/transmitter/basic/radio = holder
	radio.sanitize_events(actual_machine, radio.transmit_on_change)
	radio.sanitize_events(actual_machine, radio.transmit_on_tick)

/datum/extension/interactive/multitool/radio/transmitter/get_interact_window(obj/item/device/multitool/M, mob/user)
	var/obj/item/weapon/stock_parts/radio/transmitter/basic/radio = holder
	var/list/dat = list()

	dat += "<b>Transmit on change:</b><br>"
	dat += event_list_to_selection_table("on_change", radio.transmit_on_change)
	dat += "<br>"
	dat += "<b>Transmit every tick:</b><br>"
	dat += event_list_to_selection_table("on_tick", radio.transmit_on_tick)
	return ..() + JOINTEXT(dat)

/datum/extension/interactive/multitool/radio/transmitter/on_topic(href, href_list, user)
	. = ..()
	if(.)
		return
	var/obj/machinery/actual_machine = machine.resolve()
	if(!actual_machine)
		return MT_CLOSE
	var/obj/item/weapon/stock_parts/radio/transmitter/basic/radio = holder
	if(href_list["on_change"])
		return event_list_topic(radio.transmit_on_change, actual_machine.public_variables, user, href_list)
	if(href_list["on_tick"])
		return event_list_topic(radio.transmit_on_tick, actual_machine.public_variables, user, href_list)

/datum/extension/interactive/multitool/radio/event_transmitter/aquire_target()
	var/obj/machinery/actual_machine = ..()
	. = actual_machine
	if(!actual_machine)
		return
	var/obj/item/weapon/stock_parts/radio/transmitter/on_event/radio = holder
	if(!radio.is_valid_event(actual_machine, radio.event))
		radio.event = null
	radio.sanitize_events(actual_machine, radio.transmit_on_event)

/datum/extension/interactive/multitool/radio/event_transmitter/get_interact_window(obj/item/device/multitool/M, mob/user)
	var/obj/item/weapon/stock_parts/radio/transmitter/on_event/radio = holder
	var/list/dat = list()

	dat += "<b>Choose event:</b><br>"
	if(radio.event)
		dat += "<a href='?src=\ref[src];event=1;new_val=event'>[radio.event]</a>  (<a href='?src=\ref[src];event=1;desc=\ref[radio.event]'>?</a>)"
	else
		dat += "<a href='?src=\ref[src];event=1;add=1'>(+)</a>"
	dat += "<br>"
	dat += "<b>Transmit on event:</b><br>"
	dat += event_list_to_selection_table("on_event", radio.transmit_on_event)
	return ..() + JOINTEXT(dat)

/datum/extension/interactive/multitool/radio/event_transmitter/on_topic(href, href_list, user)
	. = ..()
	if(.)
		return
	var/obj/machinery/actual_machine = machine.resolve()
	if(!actual_machine)
		return MT_CLOSE
	var/obj/item/weapon/stock_parts/radio/transmitter/on_event/radio = holder

	if(href_list["on_event"])
		return event_list_topic(radio.transmit_on_event, actual_machine.public_variables, user, href_list)
	if(href_list["event"])
		var/list/E = list()
		if(radio.event)
			E["event"] = radio.event
		. = event_list_topic(E, actual_machine.public_variables, user, href_list)
		if(length(E))
			radio.event = E[E[1]]

/datum/extension/interactive/multitool/radio/receiver/aquire_target()
	var/obj/machinery/actual_machine = ..()
	. = actual_machine
	if(!actual_machine)
		return
	var/obj/item/weapon/stock_parts/radio/receiver/radio = holder
	radio.sanitize_events(actual_machine, radio.receive_and_call)
	radio.sanitize_events(actual_machine, radio.receive_and_write)

/datum/extension/interactive/multitool/radio/receiver/get_interact_window(obj/item/device/multitool/M, mob/user)
	var/obj/item/weapon/stock_parts/radio/receiver/radio = holder
	var/list/dat = list()

	dat += "<b>Transmit on change:</b><br>"
	dat += event_list_to_selection_table("call", radio.receive_and_call)
	dat += "<br>"
	dat += "<b>Transmit every tick:</b><br>"
	dat += event_list_to_selection_table("write", radio.receive_and_write)
	return ..() + JOINTEXT(dat)

/datum/extension/interactive/multitool/radio/receiver/on_topic(href, href_list, user)
	. = ..()
	if(.)
		return
	var/obj/machinery/actual_machine = machine.resolve()
	if(!actual_machine)
		return MT_CLOSE
	var/obj/item/weapon/stock_parts/radio/receiver/radio = holder
	if(href_list["call"])
		return event_list_topic(radio.receive_and_call, actual_machine.public_methods, user, href_list)
	if(href_list["write"])
		return event_list_topic(radio.receive_and_write, radio.sanitize_events(actual_machine.public_variables.Copy()), user, href_list)