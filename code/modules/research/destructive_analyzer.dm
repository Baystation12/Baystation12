/*
Destructive Analyzer

It is used to destroy hand-held objects and advance technological research. Controls are in the linked R&D console.

Note: Must be placed within 3 tiles of the R&D Console
*/

/obj/machinery/r_n_d/destructive_analyzer
	name = "destructive analyzer"
	desc = "Accessed by a connected core fabricator console, it destroys and analyzes items and materials, recycling materials to any connected protolathe, and progressing the learning matrix of the connected core fabricator console."
	icon_state = "d_analyzer"
	var/obj/item/loaded_item = null
	var/decon_mod = 0

	idle_power_usage = 30
	active_power_usage = 2500
	construct_state = /decl/machine_construction/default/panel_closed

	machine_name = "destructive analyzer"
	machine_desc = "Breaks down objects into their component parts, gaining new information in the process. Part of an R&D network."

/obj/machinery/r_n_d/destructive_analyzer/RefreshParts()
	var/T = 0
	for(var/obj/item/stock_parts/S in src)
		T += S.rating
	decon_mod = min(T * 0.1, 3)
	..()

/obj/machinery/r_n_d/destructive_analyzer/on_update_icon()
	if(panel_open)
		icon_state = "d_analyzer_t"
	else if(loaded_item)
		icon_state = "d_analyzer_l"
	else
		icon_state = "d_analyzer"

/obj/machinery/r_n_d/destructive_analyzer/state_transition(var/decl/machine_construction/default/new_state)
	. = ..()
	if(istype(new_state) && linked_console)
		linked_console.linked_destroy = null
		linked_console = null

/obj/machinery/r_n_d/destructive_analyzer/components_are_accessible(path)
	return !busy && ..()

/obj/machinery/r_n_d/destructive_analyzer/cannot_transition_to(state_path)
	if(busy)
		return SPAN_NOTICE("\The [src] is busy. Please wait for completion of previous operation.")
	if(loaded_item)
		return SPAN_NOTICE("There is something already loaded into \the [src]. You must remove it first.")
	return ..()

/obj/machinery/r_n_d/destructive_analyzer/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy right now.</span>")
		return
	if(component_attackby(O, user))
		return TRUE
	if(loaded_item)
		to_chat(user, "<span class='notice'>There is something already loaded into \the [src].</span>")
		return 1
	if(panel_open)
		to_chat(user, "<span class='notice'>You can't load \the [src] while it's opened.</span>")
		return 1
	if(!linked_console)
		to_chat(user, "<span class='notice'>\The [src] must be linked to an R&D console first.</span>")
		return
	if(!loaded_item)
		if(isrobot(user)) //Don't put your module items in there!
			return
		if(!O.origin_tech)
			to_chat(user, "<span class='notice'>This doesn't seem to have a tech origin.</span>")
			return
		if(O.origin_tech.len == 0 || O.holographic)
			to_chat(user, "<span class='notice'>You cannot deconstruct this item.</span>")
			return
		if(!user.unEquip(O, src))
			return
		busy = 1
		loaded_item = O
		to_chat(user, "<span class='notice'>You add \the [O] to \the [src].</span>")
		flick("d_analyzer_la", src)
		spawn(10)
			update_icon()
			busy = 0

			if (linked_console.quick_deconstruct)
				linked_console.deconstruct(weakref(user))

		return 1
	return
