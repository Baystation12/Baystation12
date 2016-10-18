#define IC_TOPIC_UNHANDLED 0
#define IC_TOPIC_HANDLED 1
#define IC_TOPIC_REFRESH 2

#define IC_INPUT "input"
#define IC_OUTPUT "output"
#define IC_ACTIVATOR "activator"

#define DATA_CHANNEL "data channel"
#define PULSE_CHANNEL "pulse channel"

/obj/item/integrated_circuit
	name = "integrated circuit"
	desc = "It's a tiny chip!  This one doesn't seem to do much, however."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "template"
	w_class = ITEM_SIZE_TINY
	var/extended_desc = null
	var/list/inputs = list()
	var/list/outputs = list()
	var/list/activators = list()
	var/next_use = 0 //Uses world.time
	var/complexity = 1 //This acts as a limitation on building machines, more resource-intensive components cost more 'space'.
	var/size = 1       //This acts as a limitation on building machines, physically larger units take up more actual space.
	var/cooldown_per_use = 1 SECOND
	var/category = /obj/item/integrated_circuit // Used by the toolsets to filter out category types

/obj/item/integrated_circuit/examine(mob/user, var/assembly_examine = FALSE)
	if(assembly_examine)
		return

	..()

	to_chat(user, "This board has [inputs.len] input pin\s and [outputs.len] output pin\s.")
	for(var/datum/integrated_io/input/I in inputs)
		if(I.linked.len)
			to_chat(user, "The [I] is connected to [I.get_linked_to_desc()].")
	for(var/datum/integrated_io/output/O in outputs)
		if(O.linked.len)
			to_chat(user, "The [O] is connected to [O.get_linked_to_desc()].")
	for(var/datum/integrated_io/activate/A in activators)
		if(A.linked.len)
			to_chat(user, "The [A] is connected to [A.get_linked_to_desc()].")

	interact(user)

/obj/item/integrated_circuit/New()
	setup_io(inputs, /datum/integrated_io/input)
	setup_io(outputs, /datum/integrated_io/output)
	setup_io(activators, /datum/integrated_io/activate)
	..()

/obj/item/integrated_circuit/ex_act(severity)
	..(max(1, severity - 1)) // Circuits are weak

/obj/item/integrated_circuit/proc/setup_io(var/list/io_list, var/io_type)
	var/list/io_list_copy = io_list.Copy()
	io_list.Cut()
	for(var/io_entry in io_list_copy)
		io_list.Add(new io_type(src, io_entry, io_list_copy[io_entry]))

/obj/item/integrated_circuit/Destroy()
	for(var/datum/integrated_io/I in inputs)
		qdel(I)
	for(var/datum/integrated_io/O in outputs)
		qdel(O)
	for(var/datum/integrated_io/A in activators)
		qdel(A)
	. = ..()

/obj/item/integrated_circuit/nano_host()
	if(istype(src.loc, /obj/item/device/electronic_assembly))
		return loc
	return ..()

/obj/item/integrated_circuit/proc/on_data_written() //Override this for special behaviour when new data gets pushed to the circuit.
	return

/obj/item/integrated_circuit/emp_act(severity)
	for(var/datum/integrated_io/io in inputs + outputs + activators)
		io.scramble()

/obj/item/integrated_circuit/verb/rename_component()
	set name = "Rename Circuit"
	set category = "Object"
	set desc = "Rename your circuit, useful to stay organized."

	var/mob/M = usr
	var/input = sanitizeSafe(input("What do you want to name the circuit?", "Rename", src.name) as null|text, MAX_NAME_LEN)
	if(src && input && input != name && CanInteract(M, physical_state))
		to_chat(M, "<span class='notice'>The circuit '[src.name]' is now labeled '[input]'.</span>")
		name = input
		interact(M)

/obj/item/integrated_circuit/proc/get_pin_ref(var/pin_type, var/pin_number)
	switch(pin_type)
		if(IC_INPUT)
			if(pin_number > inputs.len)
				return null
			return inputs[pin_number]
		if(IC_OUTPUT)
			if(pin_number > outputs.len)
				return null
			return outputs[pin_number]
		if(IC_ACTIVATOR)
			if(pin_number > activators.len)
				return null
			return activators[pin_number]
	return null

/obj/item/integrated_circuit/interact(mob/user)
	if(!CanInteract(user, physical_state))
		return

	var/HTML = list()
	HTML += "<html><head><title>[src.name]</title></head><body>"
	HTML += "<div align='center'>"
	HTML += "<table border='1' style='undefined;table-layout: fixed; width: 424px'>"

	HTML += "<br><a href='?src=\ref[src];refresh=1'>\[Refresh\]</a>  |  "
	HTML += "<a href='?src=\ref[src];rename=1'>\[Rename\]</a>  |  "
	HTML += "<a href='?src=\ref[src];remove=1'>\[Remove\]</a><br>"

	HTML += "<colgroup>"
	HTML += "<col style='width: 121px'>"
	HTML += "<col style='width: 181px'>"
	HTML += "<col style='width: 122px'>"
	HTML += "</colgroup>"

	var/column_width = 3
	var/row_height = max(inputs.len, outputs.len, 1)

	for(var/i = 1 to row_height)
		HTML += "<tr>"
		for(var/j = 1 to column_width)
			var/datum/integrated_io/io = null
			var/words = list()
			var/height = 1
			switch(j)
				if(1)
					io = get_pin_ref(IC_INPUT, i)
					if(io)
						if(io.linked.len)
							words += "<a href=?src=\ref[src];wire=1;pin=\ref[io]><b>[io.name] [io.display_data()]</b></a><br>"
							for(var/datum/integrated_io/linked in io.linked)
								words += "<a href=?src=\ref[src];wire=1;pin=\ref[io]>\[[linked.name]\]</a> \
								@ <a href=?src=\ref[linked.holder];examine=1;>[linked.holder]</a><br>"
						else
							words += "<a href=?src=\ref[src];wire=1;pin=\ref[io]>[io.name] [io.display_data()]</a><br>"
							for(var/datum/integrated_io/linked in io.linked)
								words += "<a href=?src=\ref[src];wire=1;pin=\ref[io]>\[[linked.name]\]</a> \
								@ <a href=?src=\ref[linked.holder];examine=1;>[linked.holder]</a><br>"
						if(outputs.len > inputs.len)
							height = 1
				if(2)
					if(i == 1)
						words += "[src.name]<br><br>[src.desc]"
						height = row_height
					else
						continue
				if(3)
					io = get_pin_ref(IC_OUTPUT, i)
					if(io)
						if(io.linked.len)
							words += "<a href=?src=\ref[src];wire=1;pin=\ref[io]><b>[io.name] [io.display_data()]</b></a><br>"
							for(var/datum/integrated_io/linked in io.linked)
								words += "<a href=?src=\ref[src];wire=1;pin=\ref[io]>\[[linked.name]\]</a> \
								@ <a href=?src=\ref[linked.holder];examine=1;user=\ref[user]>[linked.holder]</a><br>"
						else
							words += "<a href=?src=\ref[src];wire=1;pin=\ref[io]>[io.name] [io.display_data()]</a><br>"
							for(var/datum/integrated_io/linked in io.linked)
								words += "<a href=?src=\ref[src];wire=1;pin=\ref[io]>\[[linked.name]\]</a> \
								@ <a href=?src=\ref[linked.holder];examine=1;>[linked.holder]</a><br>"
						if(inputs.len > outputs.len)
							height = 1
			HTML += "<td align='center' rowspan='[height]'>[jointext(words, null)]</td>"
		HTML += "</tr>"

	for(var/activator in activators)
		var/datum/integrated_io/io = activator
		var/words = list()
		if(io.linked.len)
			words += "<a href=?src=\ref[src];wire=1;pin=\ref[io]><font color='FF0000'><b>[io.name]</b></font></a><br>"
			for(var/datum/integrated_io/linked in io.linked)
				words += "<a href=?src=\ref[src];wire=1;pin=\ref[io]>\[[linked.name]\]</a> \
				@ <a href=?src[src];examine=1;user=\ref[user]>[linked.holder]</a><br>"
		else
			words += "<a href=?src=\ref[src];wire=1;pin=\ref[io]><font color='FF0000'>[io.name]</font></a><br>"
			for(var/datum/integrated_io/linked in io.linked)
				words += "<a href=?src=\ref[src];wire=1;pin=\ref[io]>\[[linked.name]\]</a> \
				@ <a href=?src=\ref[linked.holder];examine=1;>[linked.holder]</a><br>"
		HTML += "<tr>"
		HTML += "<td colspan='3' align='center'>[jointext(words, null)]</td>"
		HTML += "</tr>"

	HTML += "</table>"
	HTML += "</div>"

	HTML += "<br><font color='0000FF'>Complexity: [complexity]</font>"
	HTML += "<br><font color='0000FF'>Size: [size]</font>"
	HTML += "<br><font color='0000FF'>[extended_desc]</font>"

	HTML += "</body></html>"
	user << browse(jointext(HTML, null), "window=circuit-\ref[src];size=600x350;border=1;can_resize=1;can_close=1;can_minimize=1")

	onclose(user, "circuit-\ref[src]")

/obj/item/integrated_circuit/Topic(href, href_list, state = physical_state)
	if(..())
		return 1
	var/pin = locate(href_list["pin"]) in inputs + outputs + activators

	var/obj/held_item = usr.get_active_hand()
	if(href_list["wire"])
		if(istype(held_item, /obj/item/device/integrated_electronics/wirer))
			var/obj/item/device/integrated_electronics/wirer/wirer = held_item
			if(pin)
				wirer.wire(pin, usr)

		else if(istype(held_item, /obj/item/device/integrated_electronics/debugger))
			var/obj/item/device/integrated_electronics/debugger/debugger = held_item
			if(pin)
				debugger.write_data(pin, usr)
		else
			to_chat(usr, "<span class='warning'>You can't do a whole lot without the proper tools.</span>")
		. = 1

	else if(href_list["refresh"])
		interact(usr)
		. = 1

	else if(href_list["examine"])
		examine(usr)
		. = 1

	else if(href_list["rename"])
		rename_component(usr)
		. = IC_TOPIC_REFRESH

	else if(href_list["remove"])
		if(istype(held_item, /obj/item/weapon/screwdriver))
			disconnect_all()
			var/turf/T = get_turf(src)
			forceMove(T)
			playsound(T, 'sound/items/Crowbar.ogg', 50, 1)
			to_chat(usr, "<span class='notice'>You pop \the [src] out of the case, and slide it out.</span>")
		else
			to_chat(usr, "<span class='warning'>You need a screwdriver to remove components.</span>")
		interact_with_assembly(usr)
		. = IC_TOPIC_REFRESH

	else
		. = OnTopic(href_list, usr)

	if(. == IC_TOPIC_REFRESH)
		interact_with_assembly(usr)

/obj/item/integrated_circuit/proc/OnTopic(href_list, var/mob/user)
	return IC_TOPIC_UNHANDLED

/obj/item/integrated_circuit/proc/get_topic_data(mob/user)
	return list()

/obj/item/integrated_circuit/proc/interact_with_assembly(var/mob/user)
	var/obj/item/device/electronic_assembly/ea = loc
	if(!istype(ea))
		return
	ea.interact(user)
	if(ea.opened)
		interact(user)

/datum/integrated_io
	var/name = "input/output"
	var/obj/item/integrated_circuit/holder = null
	var/weakref/data = null
	var/list/linked = list()
	var/io_type = DATA_CHANNEL

/datum/integrated_io/New(var/newloc, var/name, var/data)
	..()
	src.name = name
	src.data = data
	holder = newloc
	if(!istype(holder))
		message_admins("ERROR: An integrated_io ([src.name]) spawned without a valid holder!  This is a bug.")

/datum/integrated_io/Destroy()
	disconnect()
	data = null
	holder = null
	. = ..()

/datum/integrated_io/nano_host()
	return holder

/datum/integrated_io/proc/link_io(var/datum/integrated_io/io)
	if(io_type != io.io_type)
		CRASH("Attempted to connect incompatible IO types: '[log_info_line(src)]' and '[log_info_line(io)]'")
	if(holder == io.holder)
		CRASH("Attempted two pins with the same holder: '[log_info_line(src)]' and '[log_info_line(io)]', belonging to '[log_info_line(holder)]'")

	linked |= io
	io.linked |= src

/datum/integrated_io/proc/data_as_type(var/as_type)
	if(!isweakref(data))
		return
	var/output = data.resolve()
	return istype(output, as_type) ? output : null

/datum/integrated_io/proc/display_data()
	if(isnull(data))
		return "(null)" // Empty data means nothing to show.
	if(istext(data))
		return "(\"[data]\")" // Wraps the 'string' in escaped quotes, so that people know it's a 'string'.
	if(isweakref(data))
		var/atom/A = data.resolve()
		return A ? "([A.name] \[Ref\])" : "(null)" // For refs, we want just the name displayed.
	return "([data])" // Nothing special needed for numbers or other stuff.

/datum/integrated_io/activate/display_data()
	return "(\[pulse\])"

/datum/integrated_io/proc/scramble()
	if(isnull(data))
		return
	if(isnum(data))
		write_data_to_pin(rand(-10000, 10000))
	if(istext(data))
		write_data_to_pin("ERROR")
	push_data()

/datum/integrated_io/activate/scramble()
	push_data()

/datum/integrated_io/proc/write_data_to_pin(var/new_data)
	if(isnull(new_data) || isnum(new_data) || istext(new_data) || isweakref(new_data)) // Anything else is a type we don't want.
		data = new_data
		holder.on_data_written()

/datum/integrated_io/proc/push_data()
	for(var/datum/integrated_io/io in linked)
		io.write_data_to_pin(data)

/datum/integrated_io/activate/push_data()
	for(var/datum/integrated_io/io in linked)
		io.holder.check_then_do_work(io)

/datum/integrated_io/proc/pull_data()
	for(var/datum/integrated_io/io in linked)
		write_data_to_pin(io.data)

/datum/integrated_io/proc/get_linked_to_desc()
	if(linked.len)
		return "the [english_list(linked)]"
	return "nothing"

/datum/integrated_io/proc/disconnect()
	//First we iterate over everything we are linked to.
	for(var/datum/integrated_io/their_io in linked)
		//While doing that, we iterate them as well, and disconnect ourselves from them.
		for(var/datum/integrated_io/their_linked_io in their_io.linked)
			if(their_linked_io == src)
				their_io.linked.Remove(src)
			else
				continue
		//Now that we're removed from them, we gotta remove them from us.
		src.linked.Remove(their_io)

/datum/integrated_io/input
	name = "input pin"

/datum/integrated_io/output
	name = "output pin"

/datum/integrated_io/activate
	name = "activation pin"
	io_type = PULSE_CHANNEL

/obj/item/integrated_circuit/proc/push_data()
	for(var/datum/integrated_io/output/O in outputs)
		O.push_data()

/obj/item/integrated_circuit/proc/pull_data()
	for(var/datum/integrated_io/input/I in inputs)
		I.push_data()

/obj/item/integrated_circuit/proc/check_then_do_work(var/datum/integrated_io/io)
	if(world.time < next_use) 	// All intergrated circuits have an internal cooldown, to protect from spam.
		return
	next_use = world.time + cooldown_per_use
	do_work(io)

/obj/item/integrated_circuit/proc/do_work(var/datum/integrated_io/io)
	return

/obj/item/integrated_circuit/proc/disconnect_all()
	for(var/datum/integrated_io/input/I in inputs)
		I.disconnect()
	for(var/datum/integrated_io/output/O in outputs)
		O.disconnect()
	for(var/datum/integrated_io/activate/A in activators)
		A.disconnect()
