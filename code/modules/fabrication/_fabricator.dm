/datum/fabricator_build_order
	var/datum/fabricator_recipe/target_recipe
	var/multiplier = 1
	var/remaining_time = 0
	var/list/earmarked_materials = list()

/datum/fabricator_build_order/Destroy()
	target_recipe = null
	. = ..()

/obj/machinery/fabricator
	name = "autolathe"
	desc = "It produces items using metal, glass, plastic, and aluminium. It has a built in shredder that can recycle most items, although any materials it cannot use will be wasted."
	icon = 'icons/obj/machines/fabricators/autolathe.dmi'
	icon_state = "autolathe"
	density = 1
	anchored = 1
	idle_power_usage = 10
	active_power_usage = 2000
	clicksound = "keyboard"
	clickvol = 30
	uncreated_component_parts = null
	stat_immune = 0
	

	wires =           /datum/wires/fabricator
	base_type =       /obj/machinery/fabricator
	construct_state = /decl/machine_construction/default/panel_closed

	var/list/material_overlays = list()
	var/base_icon_state = "autolathe"
	var/image/panel_image

	var/list/queued_orders = list()
	var/datum/fabricator_build_order/currently_building

	var/fabricator_class = FABRICATOR_CLASS_GENERAL
	var/list/stored_material
	var/list/storage_capacity
	var/list/base_storage_capacity = list(
		MATERIAL_STEEL =     25000,
		MATERIAL_ALUMINIUM = 25000,
		MATERIAL_GLASS =     12500,
		MATERIAL_PLASTIC =   12500
	)

	var/show_category = "All"
	var/fab_status_flags = 0
	var/mat_efficiency = 1.1
	var/build_time_multiplier = 1

/obj/machinery/fabricator/Destroy()
	QDEL_NULL(currently_building)
	QDEL_NULL_LIST(queued_orders)
	. = ..()
	
/obj/machinery/fabricator/Initialize()
	panel_image = image(icon, "[base_icon_state]_panel")
	. = ..()
	stored_material = list()
	for(var/mat in base_storage_capacity)
		stored_material[mat] = 0

/obj/machinery/fabricator/interact(mob/user)
	user.set_machine(src)

	var/list/dat = list()
	dat += "<center><h1>[capitalize(name)] Control Panel</h1><hr/>"

	if(is_functioning())

		// Material table.
		dat += "<table width = '100%'>"
		var/material_top = "<tr>"
		var/material_bottom = "<tr>"
		for(var/material in stored_material)
			material_top += "<td width = '25%' align = center><b>[material]</b></td>"
			material_bottom += "<td width = '25%' align = center>[stored_material[material]]<b>/[storage_capacity[material]]</b>"
			material_bottom += "<br><a href='?src=\ref[src];eject_mat=[material]'>Eject</a>"
			material_bottom += "</td>"
		dat += "[material_top]</tr>[material_bottom]</tr></table><hr>"

		// Build table.
		dat += "<h2>Current Builds</h2>"
		dat += "<table width = '100%'>"
		dat += "<tr>"
		dat += "<td><b>Build</b></td>"
		dat += "<td><b>Number</b></td>"
		dat += "<td><b>Status</b></td>"
		dat += "</tr>"
		if(currently_building)
			dat += "<tr>"
			dat += "<td>[currently_building.target_recipe.name]</td>"
			dat += "<td>x[currently_building.multiplier]</td>"
			dat += "<td>[100-round((currently_building.remaining_time/currently_building.target_recipe.build_time)*100)]%</td>"
			dat += "</tr>"
		else
			dat += "<tr>"
			dat += "<td colspan = 3>"
			dat += "<p><center>Nothing building.</center></p>"
			dat += "</td>"
			dat += "</tr>"
		if(length(queued_orders))
			for(var/datum/fabricator_build_order/order in queued_orders)
				dat += "<tr>"
				dat += "<td>[order.target_recipe.name]</td>"
				dat += "<td>x[order.multiplier]</td>"
				dat += "<td><a href ='?src=\ref[src];cancel=\ref[order]'>Cancel</a></td>"
				dat += "</tr>"
		else
			dat += "<tr><td colspan = 3>"
			dat += "<p><center>Nothing queued.</center></p>"
			dat += "</td></tr>"
		dat += "</table>"

		// Build controls.
		dat += "<h2>Printable Designs</h2><h3>Showing: <a href='?src=\ref[src];change_category=1'>[show_category]</a>.</h3></center><table width = '100%'>"
		for(var/datum/fabricator_recipe/R in SSfabrication.get_recipes(fabricator_class))
			if(R.hidden && !(fab_status_flags & FAB_HACKED) || (show_category != "All" && show_category != R.category))
				continue
			var/can_make = 1
			var/material_string = ""
			var/multiplier_string = ""
			var/max_sheets
			var/comma
			if(!R.resources || !R.resources.len)
				material_string = "No resources required.</td>"
			else
				//Make sure it's buildable and list requires resources.
				for(var/material in R.resources)
					var/sheets = round(stored_material[material]/round(R.resources[material]*mat_efficiency))
					if(isnull(max_sheets) || max_sheets > sheets)
						max_sheets = sheets
					if(!isnull(stored_material[material]) && stored_material[material] < round(R.resources[material]*mat_efficiency))
						can_make = 0
					if(!comma)
						comma = 1
					else
						material_string += ", "
					material_string += "[round(R.resources[material] * mat_efficiency)] [material]"
				material_string += ".<br></td>"
				//Build list of multipliers for sheets.
				if(ispath(R.path, /obj/item/stack))
					var/obj/item/stack/R_stack = R.path
					max_sheets = min(max_sheets, initial(R_stack.max_amount))
					//do not allow lathe to print more sheets than the max amount that can fit in one stack
					if(max_sheets && max_sheets > 0)
						multiplier_string  += "<br>"
						for(var/i = 5;i<max_sheets;i*=2) //5,10,20,40...
							multiplier_string  += "<a href='?src=\ref[src];make=\ref[R];multiplier=[i]'>\[x[i]\]</a>"
						multiplier_string += "<a href='?src=\ref[src];make=\ref[R];multiplier=[max_sheets]'>\[x[max_sheets]\]</a>"

			dat += "<tr><td width = 180>[R.hidden ? "<font color = 'red'>*</font>" : ""]<b>[can_make ? "<a href='?src=\ref[src];make=\ref[R];multiplier=1'>" : ""][R.name][can_make ? "</a>" : ""]</b>[R.hidden ? "<font color = 'red'>*</font>" : ""][multiplier_string]</td><td align = right>[material_string]</tr>"

		dat += "</table><hr>"

	var/datum/browser/popup = new(user, "fab_[base_icon_state]", "[capitalize(name)]", 450, 600)
	popup.set_content(jointext(dat, ""))
	popup.open()

/obj/machinery/fabricator/state_transition(var/decl/machine_construction/default/new_state)
	. = ..()
	if(istype(new_state))
		updateUsrDialog()

/obj/machinery/fabricator/components_are_accessible(path)
	return !(fab_status_flags & FAB_BUSY) && ..()

/obj/machinery/fabricator/cannot_transition_to(state_path)
	if(fab_status_flags & FAB_BUSY)
		return SPAN_NOTICE("You must wait for \the [src] to finish first.")
	return ..()

/obj/machinery/fabricator/attackby(var/obj/item/O, var/mob/user)

	if(component_attackby(O, user))
		return TRUE
	if(stat)
		return

	if(panel_open)
		//Don't eat multitools or wirecutters used on an open lathe.
		if(isMultitool(O) || isWirecutter(O))
			attack_hand(user)
			return

	if(O.loc != user && !(istype(O,/obj/item/stack)))
		return 0

	if(is_robot_module(O))
		return 0

	//Resources are being loaded.
	var/obj/item/eating = O
	var/list/taking_matter = eating.matter

	var/found_useful_mat
	if(LAZYLEN(taking_matter))
		for(var/material in taking_matter)
			if(base_storage_capacity[material] > 0)
				found_useful_mat = TRUE
				break

	if(!found_useful_mat)
		to_chat(user, SPAN_WARNING("\The [eating] does not contain any accessible useful materials and cannot be accepted."))
		return

	var/amount_available = 1
	if(istype(eating, /obj/item/stack))
		var/obj/item/stack/stack = eating
		amount_available = stack.get_amount()
	var/amount_used = 0    // Amount of material sheets used, if a stack, or whether the item was used, if not.
	var/space_left = FALSE

	var/mat_colour
	for(var/material in taking_matter)

		if(stored_material[material] >= storage_capacity[material])
			continue

		var/material/mat = SSmaterials.get_material_by_name(material)
		if(istype(mat) && !mat_colour)
			mat_colour = mat.icon_colour

		var/total_material = taking_matter[material]
		if(stored_material[material] + total_material > storage_capacity[material])
			total_material = storage_capacity[material] - stored_material[material]
		else
			space_left = TRUE // We filled it with a material, but it could have been filled further had we had more.

		stored_material[material] += total_material
		amount_used = max(ceil(amount_available * total_material/taking_matter[material]), amount_used) // Use only as many sheets as needed, rounding up

	if(!amount_used)
		to_chat(user, SPAN_WARNING("\The [src] is full. Please remove material from \the [src] in order to insert more."))
		return
	else if(!space_left)
		to_chat(user, SPAN_NOTICE("You fill \the [src] to capacity with \the [eating]."))
	else
		to_chat(user, SPAN_NOTICE("You fill \the [src] with \the [eating]."))

	var/image/adding_mat_overlay = image(icon, "[base_icon_state]_mat")
	adding_mat_overlay.color = mat_colour
	material_overlays += adding_mat_overlay
	update_icon()

	addtimer(CALLBACK(src, /obj/machinery/fabricator/proc/remove_mat_overlay, adding_mat_overlay), 1 SECOND)

	if(istype(eating,/obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(amount_used)
	else if(user.unEquip(O))
		qdel(O)

	updateUsrDialog()

/obj/machinery/fabricator/physical_attack_hand(mob/user)
	if(fab_status_flags & FAB_SHOCKED)
		shock(user, 50)
		return TRUE

/obj/machinery/fabricator/interface_interact(mob/user)
	if((fab_status_flags & FAB_DISABLED) && !panel_open)
		to_chat(user, SPAN_WARNING("\The [src] is disabled!"))
		return TRUE
	interact(user)
	return TRUE

/obj/machinery/fabricator/proc/try_queue_build(var/datum/fabricator_recipe/recipe, var/multiplier)

	// Do some basic sanity checking.
	if(!is_functioning() || !istype(recipe) || !(recipe in SSfabrication.get_recipes(fabricator_class)))
		return
	multiplier = sanitize_integer(multiplier, 1, 100, 1)
	if(!ispath(recipe, /obj/item/stack) && multiplier > 1)
		multiplier = 1

	// Check if sufficient resources exist.
	for(var/material in recipe.resources)
		if(stored_material[material] < round(recipe.resources[material] * mat_efficiency) * multiplier)
			return

	// Generate and track a new order.
	var/datum/fabricator_build_order/order = new
	order.remaining_time = recipe.build_time
	order.target_recipe =  recipe
	order.multiplier =     multiplier
	queued_orders +=       order

	// Remove/earmark resources.
	for(var/material in recipe.resources)
		var/removed_mat = round(recipe.resources[material] * mat_efficiency) * multiplier
		stored_material[material] = max(0, stored_material[material] - removed_mat)
		order.earmarked_materials[material] = removed_mat

	if(!currently_building)
		get_next_build()
	else
		start_building()

/obj/machinery/fabricator/proc/is_functioning()
	. = use_power != POWER_USE_OFF && !(stat & NOPOWER) && !(stat & BROKEN) && !(fab_status_flags & FAB_DISABLED)

/obj/machinery/fabricator/Process(var/wait)
	..()
	if(use_power == POWER_USE_ACTIVE && (fab_status_flags & FAB_BUSY))
		update_current_build(wait)

/obj/machinery/fabricator/proc/update_current_build(var/spend_time)

	if(!istype(currently_building) || !is_functioning())
		return

	// Decrement our current build timer.
	currently_building.remaining_time -= max(1, max(1, spend_time * build_time_multiplier))
	if(currently_building.remaining_time > 0)
		return

	// Print the item.
	if(ispath(currently_building.target_recipe.path, /obj/item/stack))
		new currently_building.target_recipe.path(get_turf(src), amount = currently_building.multiplier)
	else
		new currently_building.target_recipe.path(get_turf(src))
	QDEL_NULL(currently_building)
	get_next_build()
	update_icon()

/obj/machinery/fabricator/proc/start_building()
	if(!(fab_status_flags & FAB_BUSY) && is_functioning())
		fab_status_flags |= FAB_BUSY
		update_use_power(POWER_USE_ACTIVE)
		update_icon()

/obj/machinery/fabricator/proc/stop_building()
	if(fab_status_flags & FAB_BUSY)
		fab_status_flags &= ~FAB_BUSY
		update_use_power(POWER_USE_IDLE)
		update_icon()

/obj/machinery/fabricator/OnTopic(user, href_list, state)
	if(href_list["change_category"])
		var/choice = input("Which category do you wish to display?") as null|anything in SSfabrication.get_categories(fabricator_class)|"All"
		if(!choice || !CanUseTopic(user, state))
			return TOPIC_HANDLED
		show_category = choice
		. = TOPIC_REFRESH
	else if(href_list["make"])
		try_queue_build(locate(href_list["make"]), text2num(href_list["multiplier"]))
		. = TOPIC_REFRESH
	else if(href_list["cancel"])
		try_cancel_build(locate(href_list["cancel"]))
		. = TOPIC_REFRESH
	else if(href_list["eject_mat"])
		var/material/mat = SSmaterials.get_material_by_name(href_list["eject_mat"])
		if(mat && stored_material[mat.name] > mat.units_per_sheet && mat.stack_type)
			var/sheet_count = Floor(stored_material[mat.name]/mat.units_per_sheet)
			stored_material[mat.name] -= sheet_count * mat.units_per_sheet
			mat.place_sheet(get_turf(src), sheet_count)
			. = TOPIC_REFRESH

/obj/machinery/fabricator/proc/try_cancel_build(var/datum/fabricator_build_order/order)
	if(istype(order) && currently_building != order && is_functioning())
		if(order in queued_orders)
			// Refund some mats.
			for(var/mat in order.earmarked_materials)
				stored_material[mat] = min(stored_material[mat] + (order.earmarked_materials[mat] * 0.9), storage_capacity[mat])
			queued_orders -= order
		qdel(order)

/obj/machinery/fabricator/proc/get_next_build()
	currently_building = null
	if(length(queued_orders))
		currently_building = queued_orders[1]
		queued_orders -= currently_building
		start_building()
	else
		stop_building()
	updateUsrDialog()

/obj/machinery/fabricator/on_update_icon()
	overlays.Cut()
	if(stat & NOPOWER)
		icon_state = "[base_icon_state]_d"
	else if(currently_building)
		icon_state = "[base_icon_state]_p"
	else
		icon_state = base_icon_state

	var/list/new_overlays = material_overlays.Copy()
	if(panel_open)
		new_overlays += panel_image
	overlays = new_overlays

/obj/machinery/fabricator/proc/remove_mat_overlay(var/mat_overlay)
	material_overlays -= mat_overlay
	update_icon()

//Updates overall lathe storage size.
/obj/machinery/fabricator/RefreshParts()
	..()
	var/mb_rating = Clamp(total_component_rating_of_type(/obj/item/weapon/stock_parts/matter_bin), 0, 10)
	var/man_rating = Clamp(total_component_rating_of_type(/obj/item/weapon/stock_parts/manipulator), 0.5, 3.5)
	storage_capacity = list()
	for(var/mat in base_storage_capacity)
		storage_capacity[mat] = mb_rating * base_storage_capacity[mat]
	mat_efficiency = initial(mat_efficiency) - man_rating * 0.1// Normally, price is 1.25 the amount of material.
	build_time_multiplier = initial(build_time_multiplier) * man_rating

/obj/machinery/fabricator/dismantle()

	for(var/mat in stored_material)
		var/material/M = SSmaterials.get_material_by_name(mat)
		if(!istype(M))
			continue
		var/obj/item/stack/material/S = M.place_sheet(get_turf(src), 1, M.name)
		if(stored_material[mat] > S.perunit)
			S.amount = round(stored_material[mat] / S.perunit)
		else
			qdel(S)
	..()
	return 1
