/obj/item/integrated_circuit
	name = "integrated circuit"
	desc = "It's a tiny chip!  This one doesn't seem to do much, however."
	icon = 'icons/obj/assemblies/electronic_components.dmi'
	icon_state = "template"
	w_class = ITEM_SIZE_TINY
	matter = list()				// To be filled later
	var/obj/item/device/electronic_assembly/assembly // Reference to the assembly holding this circuit, if any.
	var/extended_desc
	var/list/inputs
	var/list/inputs_default// Assoc list which will fill a pin with data upon creation.  e.g. "2" = 0 will set input pin 2 to equal 0 instead of null.
	var/list/outputs
	var/list/outputs_default// Ditto, for output.
	var/list/activators
	var/next_use = 0 				// Uses world.time
	var/complexity = 1 				// This acts as a limitation on building machines, more resource-intensive components cost more 'space'.
	var/size = 1					// This acts as a limitation on building machines, bigger components cost more 'space'. -1 for size 0
	var/cooldown_per_use = 1		// Circuits are limited in how many times they can be work()'d by this variable.
	var/ext_cooldown = 0			// Circuits are limited in how many times they can be work()'d with external world by this variable.
	var/power_draw_per_use = 0 		// How much power is drawn when work()'d.
	var/power_draw_idle = 0			// How much power is drawn when doing nothing.
	var/spawn_flags					// Used for world initializing, see the #defines above.
	var/action_flags = 0			// Used for telling circuits that can do certain actions from other circuits.
	var/category_text = "NO CATEGORY THIS IS A BUG"	// To show up on circuit printer, and perhaps other places.
	var/removable = TRUE 			// Determines if a circuit is removable from the assembly.
	var/displayed_name = ""

/*
	Integrated circuits are essentially modular machines.  Each circuit has a specific function, and combining them inside Electronic Assemblies allows
a creative player the means to solve many problems.  Circuits are held inside an electronic assembly, and are wired using special tools.
*/

/obj/item/integrated_circuit/examine(mob/user)
	. = ..()
	external_examine(user)

/obj/item/integrated_circuit/ShiftClick(mob/living/user)
	if(istype(user))
		interact(user)
	else
		..()

// This should be used when someone is examining while the case is opened.
/obj/item/integrated_circuit/proc/internal_examine(mob/user)
	any_examine(user)
	interact(user)

// This should be used when someone is examining from an 'outside' perspective, e.g. reading a screen or LED.
/obj/item/integrated_circuit/proc/external_examine(mob/user)
	any_examine(user)

/obj/item/integrated_circuit/proc/any_examine(mob/user)
	return

/obj/item/integrated_circuit/proc/attackby_react(var/atom/movable/A,mob/user)
	return

/obj/item/integrated_circuit/proc/sense(var/atom/movable/A,mob/user,prox)
	return

/obj/item/integrated_circuit/proc/OnICTopic(href_list, user)
	return

/obj/item/integrated_circuit/proc/get_topic_data(var/mob/user)
	return

/obj/item/integrated_circuit/proc/check_interactivity(mob/user)
	if(assembly)
		return assembly.check_interactivity(user)
	else
		return CanUseTopic(user)

/obj/item/integrated_circuit/Initialize()
	displayed_name = name
	setup_io(inputs, /datum/integrated_io, inputs_default, IC_INPUT)
	inputs_default = null
	setup_io(outputs, /datum/integrated_io, outputs_default, IC_OUTPUT)
	outputs_default = null
	setup_io(activators, /datum/integrated_io/activate, null, IC_ACTIVATOR)
	if(!matter[MATERIAL_STEEL])
		matter[MATERIAL_STEEL] = w_class * SScircuit.cost_multiplier // Default cost.
	. = ..()

/obj/item/integrated_circuit/proc/on_data_written() //Override this for special behaviour when new data gets pushed to the circuit.
	return

/obj/item/integrated_circuit/Destroy()
	QDEL_NULL_LIST(inputs)
	QDEL_NULL_LIST(outputs)
	QDEL_NULL_LIST(activators)
	SScircuit_components.dequeue_component(src)
	. = ..()

/obj/item/integrated_circuit/emp_act(severity)
	for(var/k in 1 to LAZYLEN(inputs))
		var/datum/integrated_io/I = inputs[k]
		I.scramble()
	for(var/k in 1 to LAZYLEN(outputs))
		var/datum/integrated_io/O = outputs[k]
		O.scramble()
	for(var/k in 1 to LAZYLEN(activators))
		var/datum/integrated_io/activate/A = activators[k]
		A.scramble()


/obj/item/integrated_circuit/verb/rename_component()
	set name = "Rename Circuit"
	set category = "Object"
	set desc = "Rename your circuit, useful to stay organized."

	var/mob/M = usr
	if(!check_interactivity(M))
		return

	var/input = sanitizeName(input(M, "What do you want to name this?", "Rename", name) as null|text, allow_numbers = TRUE)
	if(check_interactivity(M))
		if(!input)
			input = name
		to_chat(M, "<span class='notice'>The circuit '[name]' is now labeled '[input]'.</span>")
		displayed_name = input

/obj/item/integrated_circuit/nano_host()
	if(istype(src.loc, /obj/item/device/electronic_assembly))
		return loc
	return ..()

/obj/item/integrated_circuit/interact(mob/user)
	. = ..()
	if(!check_interactivity(user))
		return

	var/window_height = 350
	var/window_width = 655

	var/table_edge_width = "30%"
	var/table_middle_width = "40%"
	var/list/HTML = list()
	HTML += "<html><head><title>[src.displayed_name]</title></head><body>"
	HTML += "<div align='center'>"
	HTML += "<table border='1' style='undefined;table-layout: fixed; width: 80%'>"

	if(assembly)
		HTML += "<a href='?src=\ref[src];return=1'>\[Return to Assembly\]</a><br>"

	HTML += "<a href='?src=\ref[src];refresh=1'>\[Refresh\]</a>  |  "
	HTML += "<a href='?src=\ref[src];rename=1'>\[Rename\]</a>  |  "
	HTML += "<a href='?src=\ref[src];scan=1'>\[Copy Ref\]</a>"
	if(assembly && removable)
		HTML += "  |  <a href='?src=\ref[assembly];component=\ref[src];remove=1'>\[Remove\]</a>"
	HTML += "<br>"

	HTML += "<colgroup>"
	HTML += "<col style='width: [table_edge_width]'>"
	HTML += "<col style='width: [table_middle_width]'>"
	HTML += "<col style='width: [table_edge_width]'>"
	HTML += "</colgroup>"

	var/column_width = 3
	var/row_height = max(LAZYLEN(inputs), LAZYLEN(outputs), 1)

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
						words += "<b><a href='?src=\ref[src];act=wire;pin=\ref[io]'>[io.display_pin_type()] [io.name]</a> \
						<a href='?src=\ref[src];act=data;pin=\ref[io]'>[io.display_data(io.data)]</a></b><br>"
						if(io.linked.len)
							for(var/k in 1 to io.linked.len)
								var/datum/integrated_io/linked = io.linked[k]
								words += "<a href='?src=\ref[src];act=unwire;pin=\ref[io];link=\ref[linked]'>[linked]</a> \
								@ <a href='?src=\ref[linked.holder]'>[linked.holder.displayed_name]</a><br>"

						if(LAZYLEN(outputs) > LAZYLEN(inputs))
							height = 1
				if(2)
					if(i == 1)
						words += "[src.displayed_name]<br>[src.name != src.displayed_name ? "([src.name])":""]<hr>[src.desc]"
						height = row_height
					else
						continue
				if(3)
					io = get_pin_ref(IC_OUTPUT, i)
					if(io)
						words += "<b><a href='?src=\ref[src];act=wire;pin=\ref[io]'>[io.display_pin_type()] [io.name]</a> \
						<a href='?src=\ref[src];act=data;pin=\ref[io]'>[io.display_data(io.data)]</a></b><br>"
						if(io.linked.len)
							for(var/k in 1 to io.linked.len)
								var/datum/integrated_io/linked = io.linked[k]
								words += "<a href='?src=\ref[src];act=unwire;pin=\ref[io];link=\ref[linked]'>[linked]</a> \
								@ <a href='?src=\ref[linked.holder]'>[linked.holder.displayed_name]</a><br>"

						if(LAZYLEN(inputs) > LAZYLEN(outputs))
							height = 1
			HTML += "<td align='center' rowspan='[height]'>[jointext(words, null)]</td>"
		HTML += "</tr>"

	for(var/i in 1 to LAZYLEN(activators))
		var/datum/integrated_io/io = activators[i]
		var/words = list()

		words += "<b><a href='?src=\ref[src];act=wire;pin=\ref[io]'><font color='FF0000'>[io]</font></a> "
		words += "<a href='?src=\ref[src];act=data;pin=\ref[io]'><font color='FF0000'>[io.data?"\<PULSE OUT\>":"\<PULSE IN\>"]</font></a></b><br>"
		if(io.linked.len)
			for(var/k in 1 to io.linked.len)
				var/datum/integrated_io/linked = io.linked[k]
				words += "<a href='?src=\ref[src];act=unwire;pin=\ref[io];link=\ref[linked]'><font color='FF0000'>[linked]</font></a> \
				@ <a href='?src=\ref[linked.holder]'><font color='FF0000'>[linked.holder.displayed_name]</font></a><br>"

		HTML += "<tr>"
		HTML += "<td colspan='3' align='center'>[jointext(words, null)]</td>"
		HTML += "</tr>"

	HTML += "</table>"
	HTML += "</div>"

	HTML += "<br><font color='0000AA'>Complexity: [complexity]</font>"
	HTML += "<br><font color='0000AA'>Cooldown per use: [cooldown_per_use/10] sec</font>"
	if(ext_cooldown)
		HTML += "<br><font color='0000AA'>External manipulation cooldown: [ext_cooldown/10] sec</font>"
	if(power_draw_idle)
		HTML += "<br><font color='0000AA'>Power Draw: [power_draw_idle] W (Idle)</font>"
	if(power_draw_per_use)
		HTML += "<br><font color='0000AA'>Power Draw: [power_draw_per_use] W (Active)</font>" // Borgcode says that powercells' checked_use() takes joules as input.
	HTML += "<br><font color='0000AA'>[extended_desc]</font>"

	HTML += "</body></html>"
	var/HTML_merged = jointext(HTML, null)
	if(assembly)
		show_browser(user, HTML_merged, "window=assembly-\ref[assembly];size=[window_width]x[window_height];border=1;can_resize=1;can_close=1;can_minimize=1")
	else
		show_browser(user, HTML_merged, "window=circuit-\ref[src];size=[window_width]x[window_height];border=1;can_resize=1;can_close=1;can_minimize=1")

	onclose(user, "assembly-\ref[src.assembly]")

/obj/item/integrated_circuit/Topic(href, href_list, state = GLOB.physical_state)
	if(..())
		return 1

	. = IC_TOPIC_HANDLED
	var/obj/held_item = usr.get_active_hand()
	if(href_list["pin"] && assembly)
		var/datum/integrated_io/pin = locate(href_list["pin"]) in inputs + outputs + activators
		if(pin)
			var/datum/integrated_io/linked
			var/success = TRUE
			if(href_list["link"])
				linked = locate(href_list["link"]) in pin.linked

			if(istype(held_item, /obj/item/device/integrated_electronics))
				pin.handle_wire(linked, held_item, href_list["act"], usr)
				. = IC_TOPIC_REFRESH
			else
				to_chat(usr, "<span class='warning'>You can't do a whole lot without the proper tools.</span>")
				success = FALSE
			if(success && assembly)
				assembly.add_allowed_scanner(usr.ckey)

	else if(href_list["scan"])
		if(istype(held_item, /obj/item/device/integrated_electronics/debugger))
			var/obj/item/device/integrated_electronics/debugger/D = held_item
			if(D.accepting_refs)
				D.afterattack(src, usr, TRUE)
				. = IC_TOPIC_REFRESH
			else
				to_chat(usr, "<span class='warning'>The debugger's 'ref scanner' needs to be on.</span>")
		else
			to_chat(usr, "<span class='warning'>You need a debugger set to 'ref' mode to do that.</span>")

	else if(href_list["refresh"])
		internal_examine(usr)
	else if(href_list["return"] && assembly)
		assembly.interact(usr)
	else if(href_list["examine"] && assembly)
		internal_examine(usr)

	else if(href_list["rename"])
		rename_component(usr)
		. = IC_TOPIC_REFRESH

	else if(href_list["remove"] && assembly)
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
		. = OnICTopic(href_list, usr)

	if(. == IC_TOPIC_REFRESH)
		interact_with_assembly(usr)

/obj/item/integrated_circuit/proc/interact_with_assembly(var/mob/user)
	if(assembly)
		assembly.interact(user)
		if(assembly.opened)
			interact(user)

/obj/item/integrated_circuit/proc/push_data()
	for(var/k in 1 to LAZYLEN(outputs))
		var/datum/integrated_io/O = outputs[k]
		O.push_data()

/obj/item/integrated_circuit/proc/pull_data()
	for(var/k in 1 to LAZYLEN(inputs))
		var/datum/integrated_io/I = inputs[k]
		I.push_data()

/obj/item/integrated_circuit/proc/draw_idle_power()
	if(assembly)
		return assembly.draw_power(power_draw_idle)

// Override this for special behaviour when there's no power left.
/obj/item/integrated_circuit/proc/power_fail()
	return

// Returns true if there's enough power to work().
/obj/item/integrated_circuit/proc/check_power()
	if(!assembly)
		return FALSE // Not in an assembly, therefore no power.
	if(assembly.draw_power(power_draw_per_use))
		return TRUE // Battery has enough.
	return FALSE // Not enough power.

/obj/item/integrated_circuit/proc/check_then_do_work(ord,var/ignore_power = FALSE)
	if(world.time < next_use) 	// All intergrated circuits have an internal cooldown, to protect from spam.
		return FALSE
	if(assembly && ext_cooldown && (world.time < assembly.ext_next_use)) 	// Some circuits have external cooldown, to protect from spam.
		return FALSE
	if(power_draw_per_use && !ignore_power)
		if(!check_power())
			power_fail()
			return FALSE
	next_use = world.time + cooldown_per_use
	if(assembly)
		assembly.ext_next_use = world.time + ext_cooldown
	do_work(ord)
	return TRUE

/obj/item/integrated_circuit/proc/do_work(ord)
	return

/obj/item/integrated_circuit/proc/disconnect_all()
	var/datum/integrated_io/I

	for(var/i in inputs)
		I = i
		I.disconnect_all()

	for(var/i in outputs)
		I = i
		I.disconnect_all()

	for(var/i in activators)
		I = i
		I.disconnect_all()

/obj/item/integrated_circuit/proc/get_object()
	// If the component is located in an assembly, let assembly determine it.
	if(assembly)
		return assembly.get_object()
	else
		return src	// If not, the component is acting on its own.


// Checks if the target object is reachable. Useful for various manipulators and manipulator-like objects.
/obj/item/integrated_circuit/proc/check_target(atom/target, exclude_contents = FALSE, exclude_components = FALSE, exclude_self = FALSE)
	if(!target)
		return FALSE

	var/atom/movable/acting_object = get_object()

	if(exclude_self && target == acting_object)
		return FALSE

	if(exclude_components && assembly)
		if(target in assembly.assembly_components)
			return FALSE

		if(target == assembly.battery)
			return FALSE

	if(target.Adjacent(acting_object) && isturf(target.loc))
		return TRUE

	if(!exclude_contents && (target in acting_object.GetAllContents()))
		return TRUE

	if(target in acting_object.loc)
		return TRUE

	return FALSE

/obj/item/integrated_circuit/proc/added_to_assembly(var/obj/item/device/electronic_assembly/assembly)
	return

/obj/item/integrated_circuit/proc/removed_from_assembly(var/obj/item/device/electronic_assembly/assembly)
	return
