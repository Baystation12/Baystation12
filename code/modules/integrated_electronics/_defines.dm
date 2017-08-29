#define IC_TOPIC_UNHANDLED 0
#define IC_TOPIC_HANDLED 1
#define IC_TOPIC_REFRESH 2

#define IC_INPUT "input"
#define IC_OUTPUT "output"
#define IC_ACTIVATOR "activator"

#define DATA_CHANNEL "data channel"
#define PULSE_CHANNEL "pulse channel"

#define get_assembly(X) get_holder_of_type(X, /obj/item/device/electronic_assembly)

/obj/item/integrated_circuit
	name = "integrated circuit"
	desc = "It's a tiny chip!  This one doesn't seem to do much, however."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "template"
	w_class = ITEM_SIZE_TINY
	matter = list(DEFAULT_WALL_MATERIAL = 10)
	var/extended_desc = null
	var/list/inputs = list()
	var/list/outputs = list()
	var/list/activators = list()
	var/next_use = 0 //Uses world.time
	var/removable = 1 //Whether this part can be removed from the assembly it is in.
	var/complexity = 1 //This acts as a limitation on building machines, more resource-intensive components cost more 'space'.
	var/size = 1       //This acts as a limitation on building machines, physically larger units take up more actual space.
	var/cooldown_per_use = 1 SECOND
	var/category = /obj/item/integrated_circuit // Used by the toolsets to filter out category types

	var/dist_check = /decl/dist_check/adjacent // Means to check if this unit is within range of referenced atoms

/obj/item/integrated_circuit/examine(mob/user)
	. = ..()
	external_examine(user)

/obj/item/integrated_circuit/proc/external_examine(mob/user)
	any_examine(user)

/obj/item/integrated_circuit/proc/internal_examine(mob/user)
	to_chat(user, "This board has [inputs.len] input pin\s, [outputs.len] output pin\s and [activators.len] activation pin\s.")
	for(var/datum/integrated_io/input/I in inputs)
		if(I.linked.len)
			to_chat(user, "The '[I]' is connected to [I.get_linked_to_desc()].")
	for(var/datum/integrated_io/output/O in outputs)
		if(O.linked.len)
			to_chat(user, "The '[O]' is connected to [O.get_linked_to_desc()].")
	for(var/datum/integrated_io/activate/A in activators)
		if(A.linked.len)
			to_chat(user, "The '[A]' is connected to [A.get_linked_to_desc()].")
	any_examine(user)
	interact(user)

/obj/item/integrated_circuit/proc/any_examine(mob/user)
	return

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
		io.scramble(severity)

/obj/item/integrated_circuit/verb/rename_component()
	set name = "Rename Circuit"
	set category = "Object"
	set desc = "Rename your circuit, useful to stay organized."

	var/mob/M = usr
	var/input = sanitizeSafe(input("What do you want to name the circuit?", "Rename", src.name) as null|text, MAX_NAME_LEN)
	if(src && input && input != name && CanInteract(M, GLOB.physical_state))
		to_chat(M, "<span class='notice'>The circuit '[src.name]' is now labeled '[input]'.</span>")
		name = input
		interact(M)

/obj/item/integrated_circuit/proc/activate_pin(var/pin_number)
	var/datum/integrated_io/activate/A = activators[pin_number]
	A.activate()

/obj/item/integrated_circuit/proc/set_pin_data(var/pin_type, var/pin_number, var/new_data)
	var/datum/integrated_io/pin = get_pin_ref(pin_type, pin_number)
	return pin.write_data_to_pin(new_data)

/obj/item/integrated_circuit/proc/get_pin_data(var/pin_type, var/pin_number)
	var/datum/integrated_io/pin = get_pin_ref(pin_type, pin_number)
	return pin.get_data()

/obj/item/integrated_circuit/proc/get_pin_data_as_type(var/pin_type, var/pin_number, var/as_type)
	var/datum/integrated_io/pin = get_pin_ref(pin_type, pin_number)
	return pin.data_as_type(as_type)

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
	if(!CanInteract(user, GLOB.physical_state))
		return

	var/HTML = list()
	HTML += "<html><head><title>[src.name]</title></head><body>"
	HTML += "<div align='center'>"
	HTML += "<table border='1' style='undefined;table-layout: fixed; width: 424px'>"

	HTML += "<br><a href='?src=\ref[src];refresh=1'>\[Refresh\]</a>  |  "
	HTML += "<a href='?src=\ref[src];rename=1'>\[Rename\]</a>  |  "
	if(removable)
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

/obj/item/integrated_circuit/proc/is_in_open_assembly()
	var/obj/item/device/electronic_assembly/assembly = get_assembly(loc)
	return assembly  && assembly.opened

/obj/item/integrated_circuit/Topic(href, href_list, state = GLOB.physical_state)
	if(..())
		return 1
	var/pin = locate(href_list["pin"]) in inputs + outputs + activators

	var/obj/held_item = usr.get_active_hand()
	if(href_list["wire"] && is_in_open_assembly())
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

	else if(href_list["examine"] && is_in_open_assembly())
		internal_examine(usr)
		. = 1

	else if(href_list["rename"] && is_in_open_assembly())
		rename_component(usr)
		. = IC_TOPIC_REFRESH

	else if(href_list["remove"] && is_in_open_assembly())
		if(istype(held_item, /obj/item/weapon/screwdriver))
			disconnect_all()
			dropInto(loc)
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
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
	var/data = null
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

/datum/integrated_io/proc/link_io(var/datum/integrated_io/io, var/mob/user)
	if(src == io)
		to_chat(user, "<span class='warning'>Wiring \the [io.holder]'s [io.name] into itself is rather pointless.</span>")
		return FALSE

	if(io_type != io.io_type)
		to_chat(user, "<span class='warning'>Those two types of channels are incompatable. The first is \a [io_type], while the second is \a [io.io_type].</span>")
		return FALSE

	var/io_assembly = get_assembly(io.holder.loc)
	if(!io_assembly) // Separating null assembly and same assembly checks to be extra sure wiring cannot happen in weird situations
		to_chat(user, "<span class='warning'>\The [io.holder] must be in an assembly for wiring to be possible.</span>")
		return FALSE

	if((holder != io.holder) && get_assembly(holder.loc) != get_assembly(io.holder.loc)) // This test is only necessary if we belong to different holders
		to_chat(user, "<span class='warning'>The circuits must be in the same assembly for wiring to be possible.</span>")
		return FALSE

	if(io in linked) // NOTE: We don't return here on failure, make sure to add any additional checks above this line
		to_chat(user, "<span class='warning'>These pins are already wired.</span>")
		. = FALSE
	else
		. = TRUE

	linked |= io
	io.linked |= src // We still link them to each other just ensure we're in a consistent state

/datum/integrated_io/proc/data_as_type(var/as_type)
	var/output = resolve_weakref()
	return istype(output, as_type) ? output : null

/datum/integrated_io/proc/get_data()
	if(isnull(data))
		return
	if(isweakref(data))
		return resolve_weakref()
	return data

/datum/integrated_io/proc/display_data()
	if(isnull(data))
		return "(null)" // Empty data means nothing to show.
	if(istext(data))
		return "(\"[data]\")" // Wraps the 'string' in escaped quotes, so that people know it's a 'string'.
	if(isweakref(data))
		var/atom/A = resolve_weakref()
		return A ? "([A.name] \[Ref\])" : "(out of range)" // For refs, we want just the name displayed. Both actually out of range and deleted refs are displayed as OoR
	return "([data])" // Nothing special needed for numbers or other stuff.

/datum/integrated_io/activate/display_data()
	return "(\[pulse\])"

/datum/integrated_io/proc/resolve_weakref()
	var/weakref/wref = data
	if(!istype(wref))
		return
	var/atom/resolved = wref.resolve()
	if(!resolved)
		return

	var/decl/dist_check/dc = GLOB.decl_repository.get_decl(holder.dist_check)
	return dc.within_dist(get_turf(holder.loc), resolved) && resolved

/datum/integrated_io/proc/scramble()
	if(isnull(data))
		return
	if(isnum(data))
		write_data_to_pin(rand(-10000, 10000))
	if(istext(data))
		write_data_to_pin("ERROR")

/datum/integrated_io/activate/scramble(var/severity)
	if(prob(99/severity))
		activate()

/datum/integrated_io/proc/write_data_to_pin(var/new_data)
	if(io_type != DATA_CHANNEL)
		return FALSE

	if(isnull(new_data) || isnum(new_data) || istext(new_data) || isweakref(new_data)) // Anything else is a type we don't want.
		data = new_data
		holder.on_data_written()
		return TRUE
	return FALSE

/datum/integrated_io/output/write_data_to_pin(var/new_data)
	. = ..()
	if(.)
		push_data()

/datum/integrated_io/input/proc/pull_data()
	for(var/datum/integrated_io/io in linked)
		write_data_to_pin(io.data)

/datum/integrated_io/output/proc/push_data()
	for(var/datum/integrated_io/io in linked)
		io.write_data_to_pin(data)

/datum/integrated_io/activate/proc/activate()
	for(var/datum/integrated_io/io in linked)
		io.holder.check_then_do_work(io)

/datum/integrated_io/proc/get_linked_to_desc()
	if(linked.len)
		return "the [english_list(linked)]"
	return "nothing"

/datum/integrated_io/proc/disconnect()
	data = null
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

/obj/item/integrated_circuit/proc/pull_data()
	for(var/datum/integrated_io/input/I in inputs)
		I.pull_data()

/obj/item/integrated_circuit/proc/push_data()
	for(var/datum/integrated_io/output/O in outputs)
		O.push_data()

/obj/item/integrated_circuit/proc/activate()
	for(var/datum/integrated_io/activate/A in activators)
		A.activate()

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

/datum/encrypted_ic_data
	var/name = "encrypted data"
	var/data
