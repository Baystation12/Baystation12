#define DATA_CHANNEL "data channel"
#define PULSE_CHANNEL "pulse channel"

/obj/item/integrated_circuit
	name = "integrated circuit"
	desc = "It's a tiny chip!  This one doesn't seem to do much, however."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "template"
	w_class = 1
	var/extended_desc = null
	var/list/inputs = list()
	var/list/outputs = list()
	var/list/activators = list()
	var/number_of_inputs = 0 //This is how many input pins are created
	var/number_of_outputs = 0 //Likewise for output
	var/number_of_activators = 0 //Guess
	var/list/input_names = list()
	var/list/output_names = list()
	var/list/activator_names = list()
	var/last_used = 0 //Uses world.time
	var/complexity = 1 //This acts as a limitation on building machines, more resource-intensive components cost more 'space'.
	var/cooldown_per_use = 2 SECONDS

/obj/item/integrated_circuit/examine(mob/user)
	..()
	user << "This board has [inputs.len] input [inputs.len != 1 ? "pins" : "pin"] and \
	[outputs.len] output [outputs.len != 1 ? "pins" : "pin"]."
	for(var/datum/integrated_io/input/I in inputs)
		if(I.linked.len)
			user << "\The [I.name] is connected to [I.get_linked_to_desc()]."
	for(var/datum/integrated_io/output/O in outputs)
		if(O.linked.len)
			user << "\The [O.name] is connected to [O.get_linked_to_desc()]."
	for(var/datum/integrated_io/activate/A in activators)
		if(A.linked.len)
			user << "\The [A.name] is connected to [A.get_linked_to_desc()]."

	interact(user)

/obj/item/integrated_circuit/New()
	..()
	var/i = 0
	if(number_of_inputs)
		for(i = number_of_inputs, i > 0, i--)
			inputs.Add(new /datum/integrated_io/input(src))

	if(number_of_outputs)
		for(i = number_of_outputs, i > 0, i--)
			outputs.Add(new /datum/integrated_io/output(src))

	if(number_of_activators)
		for(i = number_of_activators, i > 0, i--)
			activators.Add(new /datum/integrated_io/activate(src))

	apply_names_to_io()

/obj/item/integrated_circuit/proc/apply_names_to_io()
	var/i = 1
	if(input_names.len)
		for(var/datum/integrated_io/input/I in inputs)
			I.name = "[input_names[i]]"
			i++
	i = 1
	if(output_names.len)
		for(var/datum/integrated_io/output/O in outputs)
			O.name = "[output_names[i]]"
			i++

	i = 1
	if(activator_names.len)
		for(var/datum/integrated_io/activate/A in activators)
			A.name = "[activator_names[i]]"
			i++

/obj/item/integrated_circuit/proc/on_data_written() //Override this for special behaviour when new data gets pushed to the circuit.
	return

/obj/item/integrated_circuit/Destroy()
	for(var/datum/integrated_io/I in inputs)
		qdel(I)
	for(var/datum/integrated_io/O in outputs)
		qdel(O)
	for(var/datum/integrated_io/A in activators)
		qdel(A)
	..()

/obj/item/integrated_circuit/emp_act(severity)
	for(var/datum/integrated_io/io in inputs + outputs + activators)
		io.scramble()

/obj/item/integrated_circuit/verb/rename_component()
	set name = "Rename Circuit"
	set category = "Object"
	set desc = "Rename your circuit, useful to stay organized."

	var/mob/M = usr

	if(!M.canmove || M.stat || M.restrained())
		return

	var/input = sanitizeSafe(input("What do you want to name the circuit?", "Rename", src.name), MAX_NAME_LEN)

	if(src && input)
		M << "<span class='notice'>The circuit '[src.name]' is now labeled '[input]'.</span>"
		name = input

/obj/item/integrated_circuit/proc/get_pin_ref(var/pin_type, var/pin_number)
	switch(pin_type)
		if("input")
			if(pin_number > inputs.len)
				return null
			return inputs[pin_number]
		if("output")
			if(pin_number > outputs.len)
				return null
			return outputs[pin_number]
		if("activator")
			if(pin_number > activators.len)
				return null
			return activators[pin_number]
	return null

/obj/item/integrated_circuit/interact(mob/user)
	if(get_dist(get_turf(src), user) > 1)
		user.unset_machine(src)
		return
	var/HTML = "<html><head><title>[src.name]</title></head><body>"
	HTML += "<div align='center'>"
	HTML += "<table border='1' style='undefined;table-layout: fixed; width: 424px'>"

	HTML += "<br><a href='?src=\ref[src];user=\ref[user]'>\[Refresh\]</a>  |  "
	HTML += "<a href='?src=\ref[src];user=\ref[user];rename=1'>\[Rename\]</a><br>"

	HTML += "<colgroup>"
	HTML += "<col style='width: 121px'>"
	HTML += "<col style='width: 181px'>"
	HTML += "<col style='width: 122px'>"
	HTML += "</colgroup>"

	var/column_width = 3
	var/row_height = max(inputs.len, outputs.len, 1)
	var/i
	var/j
	for(i = 1, i < row_height+1, i++)
		HTML += "<tr>"
		for(j = 1, j < column_width+1, j++)
			var/datum/integrated_io/io = null
			var/words = null
			var/height = 1
			switch(j)
				if(1)
					io = get_pin_ref("input",i)
					if(io)
						if(io.linked.len)
							words = "<a href=?src=\ref[src];wire=1;user=\ref[user];pin=\ref[io]><b>[io.name] [io.display_data()]</b></a><br>"
							for(var/datum/integrated_io/linked in io.linked)
								words += "<a href=?src=\ref[src];wire=1;user=\ref[user];pin=\ref[io]>\[[linked.name]\]</a> \
								@ <a href=?src=\ref[linked.holder];examine=1;user=\ref[user]>[linked.holder]</a><br>"
						else // "Click <a href=?src=\ref[src];action=start>here</a>!"
							words = "<a href=?src=\ref[src];wire=1;user=\ref[user];pin=\ref[io]>[io.name] [io.display_data()]</a><br>"
							for(var/datum/integrated_io/linked in io.linked)
								words += "<a href=?src=\ref[src];wire=1;user=\ref[user];pin=\ref[io]>\[[linked.name]\]</a> \
								@ <a href=?src=\ref[linked.holder];examine=1;user=\ref[user]>[linked.holder]</a><br>"
						if(outputs.len > inputs.len)
						//	height = Floor(outputs.len / inputs.len)
							height = 1 // Because of bugs, if there's more outputs than inputs, it causes the output side to be hidden.
						//world << "I wrote [words] at ([i],[j]).  Height = [height]."
				if(2)
					if(i == 1)
						words = "[src.name]<br><br>[src.desc]"
						height = row_height
						//world << "I wrote the center piece because i was equal to 1, at ([i],[j]).  Height = [height]."
					else
						continue
				if(3)
					io = get_pin_ref("output",i)
					if(io)
						if(io.linked.len)
							words = "<a href=?src=\ref[src];wire=1;user=\ref[user];pin=\ref[io]><b>[io.name] [io.display_data()]</b></a><br>"
							for(var/datum/integrated_io/linked in io.linked)
								words += "<a href=?src=\ref[src];wire=1;user=\ref[user];pin=\ref[io]>\[[linked.name]\]</a> \
								@ <a href=?src=\ref[linked.holder];examine=1;user=\ref[user]>[linked.holder]</a><br>"
						else
							words = "<a href=?src=\ref[src];wire=1;user=\ref[user];pin=\ref[io]>[io.name] [io.display_data()]</a><br>"
							for(var/datum/integrated_io/linked in io.linked)
								words += "<a href=?src=\ref[src];wire=1;user=\ref[user];pin=\ref[io]>\[[linked.name]\]</a> \
								@ <a href=?src=\ref[linked.holder];examine=1;user=\ref[user]>[linked.holder]</a><br>"
						if(inputs.len > outputs.len)
						//	height = Floor(inputs.len / outputs.len)
							height = 1 // See above.
						//world << "I wrote [words] at ([i],[j]).  Height = [height]."
			HTML += "<td align='center' rowspan='[height]'>[words]</td>"
			//HTML += "<td align='center'>[words]</td>"
			//world << "Writing to ([i],[j])."
		HTML += "</tr>"

	if(activators.len)
		for(i = 1, i < activators.len+1, i++)
			var/datum/integrated_io/io = null
			var/words = null
			io = get_pin_ref("activator",i)
			if(io)
				if(io.linked.len)
					words = "<a href=?src=\ref[src];wire=1;user=\ref[user];pin=\ref[io]><font color='FF0000'><b>[io.name]</b></font></a><br>"
					for(var/datum/integrated_io/linked in io.linked)
						words += "<a href=?src=\ref[src];wire=1;user=\ref[user];pin=\ref[io]>\[[linked.name]\]</a> \
						@ <a href=?src[src];examine=1;user=\ref[user]>[linked.holder]</a><br>"
				else // "Click <a href=?src=\ref[src];action=start>here</a>!"
					words = "<a href=?src=\ref[src];wire=1;user=\ref[user];pin=\ref[io]><font color='FF0000'>[io.name]</font></a><br>"
					for(var/datum/integrated_io/linked in io.linked)
						words += "<a href=?src=\ref[src];wire=1;user=\ref[user];pin=\ref[io]>\[[linked.name]\]</a> \
						@ <a href=?src=\ref[linked.holder];examine=1;user=\ref[user]>[linked.holder]</a><br>"
			HTML += "<tr>"
			HTML += "<td colspan='3' align='center'>[words]</td>"
			HTML += "</tr>"

	HTML += "</table>"
	HTML += "</div>"

	HTML += "<br><font color='0000FF'>Complexity: [complexity]</font>"
	HTML += "<br><font color='0000FF'>[extended_desc]</font>"

	HTML += "</body></html>"
	user << browse(HTML, "window=circuit-\ref[src];size=600x350;border=1;can_resize=1;can_close=1;can_minimize=1")

	//user << sanitize(HTML, "window=debug;size=400x400;border=1;can_resize=1;can_close=1;can_minimize=1")
	//world << sanitize(HTML)

	user.set_machine(src)
	onclose(user, "circuit-\ref[src]")

/obj/item/integrated_circuit/Topic(href, href_list[])
	var/mob/living/user = locate(href_list["user"]) in mob_list
	var/pin = locate(href_list["pin"]) in inputs + outputs + activators

	if(!user || !user.Adjacent(get_turf(src)) )
		return 1

	if(!user.canmove || user.stat || user.restrained())
		return

	if(href_list["wire"])
		if(ishuman(user) && Adjacent(user))
			var/mob/living/carbon/human/H = user
			var/obj/held_item = H.get_active_hand()

			if(istype(held_item, /obj/item/device/integrated_electronics/wirer))
				var/obj/item/device/integrated_electronics/wirer/wirer = held_item
				if(pin)
					wirer.wire(pin, user)

			else if(istype(held_item, /obj/item/device/integrated_electronics/debugger))
				var/obj/item/device/integrated_electronics/debugger/debugger = held_item
				if(pin)
					debugger.write_data(pin, user)

	//		if(istype(H.r_hand, /obj/item/device/integrated_electronics/wirer))
	//			wirer = H.r_hand
	//		else if(istype(H.l_hand, /obj/item/device/integrated_electronics/wirer))
	//			wirer = H.l_hand

	//		if(wirer && pin)
	//			wirer.wire(pin, user)
			else
				user << "<span class='warning'>You can't do a whole lot without tools.</span>"

	if(href_list["examine"])
		examine(user)

	if(href_list["rename"])
		rename_component(user)

	interact(user) // To refresh the UI.

/datum/integrated_io
	var/name = "input/output"
	var/obj/item/integrated_circuit/holder = null
	var/data = null
	var/list/linked = list()
	var/io_type = DATA_CHANNEL

/datum/integrated_io/New(var/newloc)
	..()
	holder = newloc
	if(!holder)
		message_admins("ERROR: An integrated_io ([src.name]) spawned without a holder!  This is a bug.")

/datum/integrated_io/Destroy()
	disconnect()
	holder = null
	..()

/datum/integrated_io/proc/display_data()
	if(isnull(data))
		return "(null)" // Empty data means nothing to show.
	if(istext(data))
		return "(\"[data]\")" // Wraps the 'string' in escaped quotes, so that people know it's a 'string'.
	if(istype(data, /atom))
		var/atom/A = data
		return "([A.name] \[Ref\])" // For refs, we want just the name displayed.
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
	if(isnull(new_data) || isnum(new_data) || istext(new_data) || istype(new_data, /atom/) ) // Anything else is a type we don't want.
		data = new_data
		holder.on_data_written()

/datum/integrated_io/proc/push_data()
	if(linked.len)
		for(var/datum/integrated_io/io in linked)
			io.write_data_to_pin(data)

/datum/integrated_io/activate/push_data()
	if(linked.len)
		for(var/datum/integrated_io/io in linked)
			io.holder.work()

/datum/integrated_io/proc/pull_data()
	if(linked.len)
		for(var/datum/integrated_io/io in linked)
			write_data_to_pin(io.data)

/datum/integrated_io/proc/get_linked_to_desc()
	if(linked.len)
		var/result = english_list(linked)
		return "the [result]"
	return "nothing"

/datum/integrated_io/proc/disconnect()
	if(linked.len)
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

/obj/item/integrated_circuit/proc/work(var/datum/integrated_io/io)
	if(last_used + cooldown_per_use > world.time) 	// All intergrated circuits have an internal cooldown, to protect from spam.
		return 0
	last_used = world.time
	return 1

/obj/item/integrated_circuit/proc/disconnect_all()
	for(var/datum/integrated_io/input/I in inputs)
		I.disconnect()
	for(var/datum/integrated_io/output/O in outputs)
		O.disconnect()
	for(var/datum/integrated_io/activate/A in activators)
		A.disconnect()
