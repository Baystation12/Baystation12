/*
Destructive Analyzer

It is used to destroy hand-held objects and advance technological research. Controls are in the linked R&D console.

Note: Must be placed within 3 tiles of the R&D Console
*/

/obj/machinery/r_n_d/destructive_analyzer
	name = "destructive analyzer"
	desc = "Accessed by a connected core fabricator console, it destroys and analyzes items and materials, recycling materials to any connected protolathe, and progressing the learning matrix of the connected core fabricator console."
	icon_state = "d_analyzer"
	icon = 'icons/obj/machines/research/destructive_analyzer.dmi'
	var/obj/item/loaded_item = null
	var/decon_mod = 0

	idle_power_usage = 30
	active_power_usage = 2500
	construct_state = /singleton/machine_construction/default/panel_closed

	machine_name = "destructive analyzer"
	machine_desc = "Breaks down objects into their component parts, gaining new information in the process. Part of an R&D network."

/obj/machinery/r_n_d/destructive_analyzer/RefreshParts()
	var/T = 0
	for(var/obj/item/stock_parts/S in src)
		T += S.rating
	decon_mod = min(T * 0.1, 3)
	..()

/obj/machinery/r_n_d/destructive_analyzer/on_update_icon()
	ClearOverlays()
	if(panel_open)
		AddOverlays("d_analyzer_panel")
	if(is_powered())
		if(loaded_item)
			AddOverlays(emissive_appearance(icon, "d_analyzer_lights_item"))
		else
			AddOverlays(emissive_appearance(icon, "[icon_state]_lights"))

/obj/machinery/r_n_d/destructive_analyzer/state_transition(singleton/machine_construction/default/new_state)
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

/obj/machinery/r_n_d/destructive_analyzer/use_tool(obj/item/O, mob/living/user, list/click_params)
	if(busy)
		to_chat(user, SPAN_NOTICE("\The [src] is busy right now."))
		return TRUE
	if((. = ..()))
		return
	if(loaded_item)
		to_chat(user, SPAN_NOTICE("There is something already loaded into \the [src]."))
		return TRUE
	if(panel_open)
		to_chat(user, SPAN_NOTICE("You can't load \the [src] while it's opened."))
		return TRUE
	if(!linked_console)
		to_chat(user, SPAN_NOTICE("\The [src] must be linked to an R&D console first."))
		return TRUE
	if(!loaded_item)
		if(isrobot(user)) //Don't put your module items in there!
			return FALSE
		if(!O.origin_tech)
			to_chat(user, SPAN_NOTICE("This doesn't seem to have a tech origin."))
			return TRUE
		if(length(O.origin_tech) == 0 || O.holographic)
			to_chat(user, SPAN_NOTICE("You cannot deconstruct this item."))
			return TRUE
		if(!user.unEquip(O, src))
			return TRUE
		busy = 1
		loaded_item = O
		to_chat(user, SPAN_NOTICE("You add \the [O] to \the [src]."))
		icon_state = "d_analyzer_entry"
		spawn(10)
			update_icon()
			busy = 0

			if (linked_console.quick_deconstruct)
				linked_console.deconstruct(weakref(user))

		return TRUE
