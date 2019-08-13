/obj/machinery/fabricator
	name = "autolathe"
	desc = "It produces items using metal, glass, plastic, and aluminium. It has a built in shredder that can recycle most items, although any materials it cannot use will be wasted."
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

	var/datum/fabricator_recipe/currently_building
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
	var/build_time = 5 SECONDS

/obj/machinery/fabricator/Destroy()
	currently_building = null
	. = ..()
	
/obj/machinery/fabricator/Initialize()
	. = ..()
	stored_material = list()
	for(var/mat in base_storage_capacity)
		stored_material[mat] = 0

/obj/machinery/fabricator/interact(mob/user)
	user.set_machine(src)

	var/dat = "<center><h1>Autolathe Control Panel</h1><hr/>"

	if(!(fab_status_flags & FAB_DISABLED))
		dat += "<table width = '100%'>"
		var/material_top = "<tr>"
		var/material_bottom = "<tr>"

		for(var/material in stored_material)
			material_top += "<td width = '25%' align = center><b>[material]</b></td>"
			material_bottom += "<td width = '25%' align = center>[stored_material[material]]<b>/[storage_capacity[material]]</b></td>"

		dat += "[material_top]</tr>[material_bottom]</tr></table><hr>"
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
				if(R.is_stack)
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

	var/datum/browser/popup = new(user, "autolathenew", "Autholathe", 450, 600)
	popup.set_content(dat)
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

/obj/machinery/fabricator/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(fab_status_flags & FAB_BUSY)
		to_chat(user, SPAN_NOTICE("\The [src] is busy. Please wait for completion of previous operation."))
		return
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

	for(var/material in taking_matter)

		if(stored_material[material] >= storage_capacity[material])
			continue

		var/total_material = taking_matter[material]
		if(stored_material[material] + total_material > storage_capacity[material])
			total_material = storage_capacity[material] - stored_material[material]
		else
			space_left = TRUE // We filled it with a material, but it could have been filled further had we had more.

		stored_material[material] += total_material
		amount_used = max(ceil(amount_available * total_material/taking_matter[material]), amount_used) // Use only as many sheets as needed, rounding up

	if(!amount_used)
		to_chat(user, SPAN_WARNING("\The [src] is full. Please remove material from the autolathe in order to insert more."))
		return
	else if(!space_left)
		to_chat(user, SPAN_NOTICE("You fill \the [src] to capacity with \the [eating]."))
	else
		to_chat(user, SPAN_NOTICE("You fill \the [src] with \the [eating]."))

	flick("autolathe_o", src) // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

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

/obj/machinery/fabricator/CanUseTopic(user, href_list)
	if(fab_status_flags & FAB_BUSY)
		to_chat(user, SPAN_WARNING("\The [src] is busy. Please wait for completion of previous operation."))
		return min(STATUS_UPDATE, ..())
	return ..()

/obj/machinery/fabricator/OnTopic(user, href_list, state)
	set waitfor = 0
	if(href_list["change_category"])
		var/choice = input("Which category do you wish to display?") as null|anything in SSfabrication.get_categories(fabricator_class)|"All"
		if(!choice || !CanUseTopic(user, state))
			return TOPIC_HANDLED
		show_category = choice
		. = TOPIC_REFRESH

	else if(!(fab_status_flags & FAB_BUSY) && href_list["make"])
		. = TOPIC_REFRESH
		currently_building = locate(href_list["make"])
		if(!istype(currently_building) || !(currently_building in SSfabrication.get_recipes(fabricator_class)))
			currently_building = null
			return TOPIC_HANDLED

		var/multiplier = text2num(href_list["multiplier"])
		if(!currently_building.is_stack && multiplier != 1)
			return TOPIC_HANDLED
		multiplier = sanitize_integer(multiplier, 1, 100, 1)

		fab_status_flags |= FAB_BUSY
		update_use_power(POWER_USE_ACTIVE)

		//Check if we still have the materials.
		for(var/material in currently_building.resources)
			if(!isnull(stored_material[material]))
				if(stored_material[material] < round(currently_building.resources[material] * mat_efficiency) * multiplier)
					fab_status_flags &= ~FAB_BUSY
					return TOPIC_REFRESH

		//Consume materials.
		for(var/material in currently_building.resources)
			if(!isnull(stored_material[material]))
				stored_material[material] = max(0, stored_material[material] - round(currently_building.resources[material] * mat_efficiency) * multiplier)

		//Fancy autolathe animation.
		flick("autolathe_n", src)
		addtimer(CALLBACK(src, /obj/machinery/fabricator/proc/complete_build, multiplier, currently_building), build_time)

	if(. == TOPIC_REFRESH)
		interact(user)

/obj/machinery/fabricator/proc/complete_build(var/multiplier, var/building)

	if(QDELETED(src) || building != currently_building)
		return

	fab_status_flags &= ~FAB_BUSY
	update_use_power(POWER_USE_IDLE)

	if(currently_building)
		var/obj/item/I = new currently_building.recipe.path(loc)
		if(multiplier > 1 && istype(I, /obj/item/stack))
			var/obj/item/stack/S = I
			S.amount = multiplier
			S.update_icon()
		QDEL_NULL(currently_building)

/obj/machinery/fabricator/on_update_icon()
	icon_state = (panel_open ? "autolathe_t" : "autolathe")

//Updates overall lathe storage size.
/obj/machinery/fabricator/RefreshParts()
	..()
	var/mb_rating = Clamp(total_component_rating_of_type(/obj/item/weapon/stock_parts/matter_bin), 0, 10)
	var/man_rating = Clamp(total_component_rating_of_type(/obj/item/weapon/stock_parts/manipulator), 0.5, 3.5)
	storage_capacity = list()
	for(var/mat in base_storage_capacity)
		storage_capacity[mat] = mb_rating * base_storage_capacity[mat]
	build_time =     initial(build_time) / man_rating
	mat_efficiency = initial(mat_efficiency) - man_rating * 0.1// Normally, price is 1.25 the amount of material.

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
