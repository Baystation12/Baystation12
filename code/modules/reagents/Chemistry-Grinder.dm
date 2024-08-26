/obj/machinery/reagentgrinder
	name = "reagent grinder"
	desc = "An industrial reagent grinder with heavy carbide cutting blades."
	icon = 'icons/obj/machines/kitchen.dmi'
	icon_state = "rgrinder"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	anchored = TRUE
	idle_power_usage = 5
	active_power_usage = 100
	obj_flags = OBJ_FLAG_ANCHORABLE
	construct_state = /singleton/machine_construction/default/panel_closed
	machine_name = "reagent grinder"
	machine_desc = "An industrial grinder with durable blades that shreds objects into their component reagents."

	var/skill = SKILL_CHEMISTRY
	var/grind_sound = 'sound/machines/grinder.ogg'
	var/list/items = list()
	var/max_items = 10
	var/max_item_size = ITEM_SIZE_HUGE
	var/list/banned_items = list()
	var/list/storage_types = list(
		/obj/item/storage/pill_bottle,
		/obj/item/storage/sheetsnatcher,
		/obj/item/storage/plants
	)
	var/list/allowed_containers = list(
		/obj/item/reagent_containers/glass/beaker
	)
	var/list/banned_containers = list(
		/obj/item/reagent_containers/glass/beaker/bowl,
		/obj/item/reagent_containers/glass/beaker/vial
	)
	var/grind_time = 6 SECONDS
	var/obj/item/reagent_containers/container
	var/grinding


/obj/machinery/reagentgrinder/proc/detach(mob/user)
	if (!container)
		return
	if (user)
		user.put_in_hands(container)
	else
		container.dropInto(get_turf(src))
	container = null
	update_icon()


/obj/machinery/reagentgrinder/proc/eject()
	for (var/obj/item/I in items)
		I.dropInto(get_turf(src))
	items.Cut()


/obj/machinery/reagentgrinder/proc/reset_machine(mob/user)
	grinding = FALSE
	update_icon()
	if (user)
		interact(user)


/obj/machinery/reagentgrinder/proc/grind(mob/user)
	if (grinding)
		return
	power_change()
	if (inoperable())
		return
	if (!container?.reagents || container.reagents.total_volume >= container.reagents.maximum_volume)
		return
	playsound(src, grind_sound, 75, 1)
	grinding = TRUE
	update_icon()

	addtimer(new Callback(src, .proc/reset_machine, user), grind_time)
	var/skill_multiplier = CLAMP01(0.5 + (user.get_skill_value(skill) - 1) * 0.167)
	for (var/obj/item/I in items)
		if (container.reagents.total_volume >= container.reagents.maximum_volume)
			break
		if (I.reagents?.total_volume)
			I.reagents.trans_to(container, I.reagents.total_volume, skill_multiplier)
			I.reagents.clear_reagents()
		var/material/M = I.get_material()
		if (length(M?.chem_products))
			if (isstack(I))
				var/sheet_volume = 0
				for (var/chem in M.chem_products)
					sheet_volume += M.chem_products[chem] * skill_multiplier
				var/obj/item/stack/material/S = I
				var/used_sheets = min(ceil((container.reagents.maximum_volume - container.reagents.total_volume) / sheet_volume), S.get_amount())
				var/used_all = used_sheets == S.get_amount()
				S.use(used_sheets)
				for (var/chem in M.chem_products)
					container.reagents.add_reagent(chem, used_sheets * M.chem_products[chem] * skill_multiplier)
				if (!used_all)
					break
			else
				for (var/chem in M.chem_products)
					container.reagents.add_reagent(chem, M.chem_products[chem] * skill_multiplier)
		items -= I
		qdel(I)


/obj/machinery/reagentgrinder/proc/grindable(obj/item/I)
	if (I.reagents?.total_volume)
		return TRUE
	var/material/M = I.get_material()
	if (length(M?.chem_products))
		return TRUE
	return FALSE


/obj/machinery/reagentgrinder/on_update_icon()
	if (grinding)
		icon_state = "[initial(icon_state)]_grinding"
	else if (container)
		icon_state = "[initial(icon_state)]_beaker"
	else
		icon_state = "[initial(icon_state)]"


/obj/machinery/reagentgrinder/use_tool(obj/item/I, mob/living/user, list/click_params)
	if((. = ..()))
		detach()
		eject()
		return

	if (is_type_in_list(I, allowed_containers) && !is_type_in_list(I, banned_containers))
		if (container)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [container]."))
		else if (user.unEquip(I, src))
			container = I
			update_icon()
			updateDialog()
		return TRUE

	if (is_type_in_list(I, storage_types))
		var/obj/item/storage/S = I
		if (!length(S.contents))
			to_chat(user, SPAN_WARNING("\The [S] is empty."))
		else if (length(items) >= max_items)
			to_chat(user, SPAN_WARNING("\The item hopper on \the [src] is full."))
		else
			var/list/removed = list()
			for (var/obj/item/G in S)
				if (G.w_class > max_item_size || is_type_in_list(G, banned_items))
					continue
				if (!grindable(G))
					continue
				S.remove_from_storage(G, src, 1)
				removed += G
				items += G
				if (length(items) >= max_items)
					break
			if (length(removed))
				S.finish_bulk_removal()
				var/full = length(items) >= max_items
				user.visible_message(
					"\The [user] empties things from \the [S] into \the [src].",
					"You empty [english_list(removed)] from \the [S] into \the [src][full ? ", filling it to capacity" : ""]."
				)
				updateDialog()
			else
				to_chat(user, SPAN_WARNING("Nothing more in \the [S] will go into \the [src]."))
		return TRUE

	if (I.w_class > max_item_size)
		to_chat(user, SPAN_WARNING("\The [I] is too large for \the [src]."))
		return TRUE

	if (length(items) >= max_items)
		to_chat(user, SPAN_WARNING("\The [src] is full."))
		return TRUE

	if (is_type_in_list(I, banned_items) || !grindable(I))
		to_chat(user, SPAN_WARNING("\The [src] cannot grind \the [I]."))
		return TRUE

	if (user.unEquip(I, src))
		items += I
		updateUsrDialog()
		return TRUE

/obj/machinery/reagentgrinder/interface_interact(mob/user)
	interact(user)
	return TRUE


/obj/machinery/reagentgrinder/interact(mob/user)
	if (inoperable())
		return
	user.set_machine(src)
	var/window = list()
	if (grinding)
		window += "Working, please wait..."
	else
		window += "<b>Processing Hopper</b>"
		if (!length(items))
			window += " (empty)"
		else
			window += "<br><a href='?src=\ref[src];action=grind'>(grind)</a> <a href='?src=\ref[src];action=eject'>(eject)</a><br>"
			for (var/obj/item/I in items)
				window += "<br>\An [I]"
				if (isstack(I))
					var/obj/item/stack/material/S = I
					window += " ([S.get_amount()])"
		window += "<br><br><b>Chemical Container</b>"
		if (!container)
			window += " (not attached)"
		else
			window += " (\an [container], [Percent(container.reagents.total_volume, container.reagents.maximum_volume, 1)]% full)"
			window += "<br><a href='?src=\ref[src];action=detach'>(detach)</a><br>"
			for (var/datum/reagent/R in container.reagents.reagent_list)
				window += "<br>[R.volume] - [R.name]"

	window = strip_improper("<head><meta charset='utf-8'><title>[name]</title></head><tt>[JOINTEXT(window)]</tt>")
	var/datum/browser/popup = new(user, "reagentgrinder", "Reagent Grinder")
	popup.set_content(window)
	popup.open()
	onclose(user, "reagentgrinder")


/obj/machinery/reagentgrinder/OnTopic(user, href_list)
	if (user && href_list && href_list["action"])
		switch (href_list["action"])
			if ("grind")
				grind(user)
			if ("eject")
				eject()
			if ("detach")
				detach(user)
		interact(user)
		return TOPIC_REFRESH


/obj/machinery/reagentgrinder/AltClick(mob/user)
	if(CanDefaultInteract(user))
		detach(user)
		return TRUE
	return ..()


/obj/machinery/reagentgrinder/CtrlClick(mob/user)
	if(anchored && CanDefaultInteract(user))
		grind(user)
		return TRUE
	return ..()


/obj/machinery/reagentgrinder/CtrlAltClick(mob/user)
	if(CanDefaultInteract(user))
		eject(user)
		return TRUE
	return ..()


/obj/machinery/reagentgrinder/RefreshParts()
	..()


/obj/machinery/reagentgrinder/juicer
	name = "blender"
	desc = "A high-speed combination blender/juicer."
	icon_state = "juicer"
	density = FALSE
	anchored = FALSE
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_CAN_TABLE
	grind_sound = 'sound/machines/juicer.ogg'
	max_item_size = ITEM_SIZE_NORMAL
	skill = SKILL_COOKING
	banned_items = list(
		/obj/item/stack/material
	)
	storage_types = list(
		/obj/item/storage/pill_bottle,
		/obj/item/storage/plants
	)
	allowed_containers = list(
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/food/drinks/shaker
	)
	machine_name = "blender"
	machine_desc = "Blends or juices food placed inside it - useful for things like flour. Can't process raw material sheets."
