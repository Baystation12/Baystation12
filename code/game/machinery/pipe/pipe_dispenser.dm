/obj/machinery/pipedispenser
	name = "pipe dispenser"
	icon = 'icons/obj/machines/pipe_dispenser.dmi'
	icon_state = "pipe_d"
	density = TRUE
	anchored = FALSE
	stat_immune = MACHINE_STAT_NOSCREEN//Doesn't need screen, just input for the parts wanted
	obj_flags = OBJ_FLAG_ANCHORABLE

	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null

	idle_power_usage = 500
	power_channel = EQUIP
	use_power = POWER_USE_OFF

	machine_name = "pipe dispenser"
	machine_desc = "A semi-portable dispenser that uses compressed matter to create atmospherics pipes. Vital for repair or construction efforts."

	var/pipe_color = "white"

/obj/machinery/pipedispenser/Initialize()//for mapping purposes. Anchor them by map var edit if needed.
	. = ..()
	if(anchored)
		update_use_power(POWER_USE_IDLE)

/obj/machinery/pipedispenser/proc/get_console_data(list/pipe_categories, color_options = FALSE)
	. = list()
	. += "<table>"
	if(color_options)
		. += "<tr><td>Color</td><td><a href='?src=\ref[src];color=\ref[src]'>[SPAN_COLOR(pipe_color, pipe_color)]</a></td></tr>"
	for(var/category in pipe_categories)
		var/datum/pipe/cat = category
		. += "<tr><td>[SPAN_COLOR("#517087", "<strong>[initial(cat.category)]</strong>")]</td></tr>"
		for(var/datum/pipe/pipe in pipe_categories[category])
			var/line = "[pipe.name]</td>"
			. += "<tr><td>[line]<td><a href='?src=\ref[src];build=\ref[pipe]'>Dispense</a></td><td><a href='?src=\ref[src];buildfive=\ref[pipe]'>5x</a></td><td><a href='?src=\ref[src];buildten=\ref[pipe]'>10x</a></td></tr>"
	.+= "</table>"
	. = JOINTEXT(.)

/obj/machinery/pipedispenser/proc/build_quantity(datum/pipe/P, quantity)
	for(var/I = quantity;I > 0;I -= 1)
		P.Build(P, loc, pipe_colors[pipe_color])
		use_power_oneoff(500)

/obj/machinery/pipedispenser/Topic(href, href_list)
	if((. = ..()))
		return
	if(href_list["build"])
		var/datum/pipe/P = locate(href_list["build"])
		build_quantity(P, 1)
	if(href_list["buildfive"])
		var/datum/pipe/P = locate(href_list["buildfive"])
		build_quantity(P, 5)
	if(href_list["buildten"])
		var/datum/pipe/P = locate(href_list["buildten"])
		build_quantity(P, 10)
	if(href_list["color"])
		var/choice = input(usr, "What color do you want pipes to have?") as null|anything in pipe_colors
		if(!choice)
			return 1
		pipe_color = choice
		updateUsrDialog()

/obj/machinery/pipedispenser/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/pipedispenser/CanUseTopic(mob/user)
	if (!anchored)
		to_chat(user, "You need to anchor \the [src] to be able to operate it.")
		return STATUS_CLOSE
	return ..()

/obj/machinery/pipedispenser/interact(mob/user)
	var/datum/browser/popup = new (user, "Pipe List", "[src] Control Panel")
	popup.set_content(get_console_data(GLOB.all_pipe_datums_by_category, TRUE))
	popup.open()

/obj/machinery/pipedispenser/post_anchor_change()
	if (anchored)
		set_stat(MACHINE_STAT_MAINT, FALSE)
	else
		set_stat(MACHINE_STAT_MAINT, TRUE)
	..()

/obj/machinery/pipedispenser/use_tool(obj/item/W, mob/living/user, list/click_params)
	if (istype(W, /obj/item/pipe) || istype(W, /obj/item/machine_chassis))
		if(!user.unEquip(W))
			return TRUE
		to_chat(user, SPAN_NOTICE("You put \the [W] back into \the [src]."))
		qdel(W)
		return TRUE

	return ..()

/obj/machinery/pipedispenser/disposal
	name = "disposal pipe dispenser"
	icon = 'icons/obj/machines/pipe_dispenser.dmi'
	icon_state = "pipe_d"
	machine_name = "disposal pipe dispenser"
	machine_desc = "Similar to a normal pipe dispenser, but calibrated for the heavy, dense metal tubes used in disposals networks."

//Allow you to drag-drop disposal pipes into it
/obj/machinery/pipedispenser/disposal/MouseDrop_T(obj/structure/disposalconstruct/pipe as obj, mob/user as mob)
	if(!CanPhysicallyInteract(user))
		return

	if (!istype(pipe) || get_dist(src,pipe) > 1 )
		return

	if (pipe.anchored)
		return

	qdel(pipe)

/obj/machinery/pipedispenser/disposal/interact(mob/user)
	var/datum/browser/popup = new (user, "Disposal Pipe List", "[src] Control Panel")
	popup.set_content(get_console_data(GLOB.all_disposal_pipe_datums_by_category))
	popup.open()
