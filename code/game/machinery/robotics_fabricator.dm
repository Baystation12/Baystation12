/obj/machinery/robotics_fabricator
	name = "Exosuit Fabricator"
	desc = "A machine used for construction of robotics and mechs."
	icon = 'icons/obj/robotics.dmi'
	icon_state = "fab-idle"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 20
	active_power_usage = 5000
	req_access = list(access_robotics)
	base_type = /obj/machinery/robotics_fabricator
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	machine_name = "exosuit fabricator"
	machine_desc = "A heavy-duty fabricator that can produce parts for exosuits and robots."

	var/speed = 1
	var/mat_efficiency = 1
	var/list/materials = list(MATERIAL_STEEL = 0, MATERIAL_ALUMINIUM = 0, MATERIAL_PLASTIC = 0, MATERIAL_GLASS = 0, MATERIAL_GOLD = 0, MATERIAL_SILVER = 0, MATERIAL_PHORON = 0, MATERIAL_URANIUM = 0, MATERIAL_DIAMOND = 0)
	var/res_max_amount = 200000

	var/datum/research/files
	var/list/datum/design/queue = list()
	var/progress = 0
	var/busy = 0

	var/list/categories = list()
	var/category = null
	var/manufacturer = null
	var/sync_message = ""

/obj/machinery/robotics_fabricator/Initialize()
	files = new /datum/research(src) //Setup the research data holder.
	manufacturer = basic_robolimb.company
	update_categories()
	. = ..()

/obj/machinery/robotics_fabricator/Process()
	if(stat)
		return
	if(busy)
		update_use_power(POWER_USE_ACTIVE)
		progress += speed
		check_build()
	else
		update_use_power(POWER_USE_IDLE)
	update_icon()

/obj/machinery/robotics_fabricator/on_update_icon()
	overlays.Cut()
	if(panel_open)
		icon_state = "fab-o"
	else
		icon_state = "fab-idle"
	if(busy)
		overlays += "fab-active"

/obj/machinery/robotics_fabricator/dismantle()
	for(var/f in materials)
		eject_materials(f, -1)
	..()

/obj/machinery/robotics_fabricator/RefreshParts()
	res_max_amount = 100000 * total_component_rating_of_type(/obj/item/stock_parts/matter_bin)

	var/T = clamp(total_component_rating_of_type(/obj/item/stock_parts/manipulator), 0, 4)
	mat_efficiency = 1 - (T - 1) / 4 // 1 -> 0.5

	T += total_component_rating_of_type(/obj/item/stock_parts/micro_laser)// Not resetting T is intended; speed is affected by both
	speed = T / 2 // 1 -> 3

/obj/machinery/robotics_fabricator/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/robotics_fabricator/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	var/datum/design/current = queue.len ? queue[1] : null
	if(current)
		data["current"] = current.name
	data["queue"] = get_queue_names()
	data["buildable"] = get_build_options()
	data["category"] = category
	data["categories"] = categories
	if(all_robolimbs)
		var/list/T = list()
		for(var/A in all_robolimbs)
			var/datum/robolimb/R = all_robolimbs[A]
			if(R.unavailable_at_fab || R.applies_to_part.len)
				continue
			T += list(list("id" = A, "company" = R.company))
		data["manufacturers"] = T
		data["manufacturer"] = manufacturer
	data["materials"] = get_materials()
	data["maxres"] = res_max_amount
	data["sync"] = sync_message
	if(current)
		data["builtperc"] = round((progress / current.time) * 100)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "mechfab.tmpl", "Exosuit Fabricator UI", 800, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/robotics_fabricator/Topic(href, href_list)
	if(..())
		return

	if(href_list["build"])
		add_to_queue(text2num(href_list["build"]))

	if(href_list["remove"])
		remove_from_queue(text2num(href_list["remove"]))

	if(href_list["category"])
		if(href_list["category"] in categories)
			category = href_list["category"]

	if(href_list["manufacturer"])
		if(href_list["manufacturer"] in all_robolimbs)
			manufacturer = href_list["manufacturer"]

	if(href_list["eject"])
		eject_materials(href_list["eject"], text2num(href_list["amount"]))

	if(href_list["sync"])
		sync()
	else
		sync_message = ""

	return 1

/obj/machinery/robotics_fabricator/components_are_accessible(path)
	return !busy && ..()

/obj/machinery/robotics_fabricator/cannot_transition_to(state_path)
	if(busy)
		return SPAN_NOTICE("\The [src] is busy. Please wait for completion of previous operation.")
	return ..()

/obj/machinery/robotics_fabricator/attackby(var/obj/item/I, var/mob/user)
	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>")
		return 1
	if(!istype(I, /obj/item/stack/material))
		return ..()

	var/obj/item/stack/material/stack = I
	var/material = stack.material.name
	var/stack_singular = "[stack.material.use_name] [stack.material.sheet_singular_name]" // eg "steel sheet", "wood plank"
	var/stack_plural = "[stack.material.use_name] [stack.material.sheet_plural_name]" // eg "steel sheets", "wood planks"
	var/amnt = stack.perunit

	if(stack.uses_charge)
		return

	if(!(material in materials))
		to_chat(user, "<span class=warning>\The [src] does not accept [stack_plural]!</span>")
		return

	if(materials[material] + amnt <= res_max_amount)
		if(stack && stack.can_use(1))
			var/count = 0
			overlays += "fab-load-metal"
			spawn(10)
				overlays -= "fab-load-metal"
			while(materials[material] + amnt <= res_max_amount && stack.amount >= 1)
				materials[material] += amnt
				stack.use(1)
				count++
			to_chat(user, "You insert [count] [count==1 ? stack_singular : stack_plural] into the fabricator.")// 0 steel sheets, 1 steel sheet, 2 steel sheets, etc

			update_busy()
	else
		to_chat(user, "The fabricator cannot hold more [stack_plural].")// use the plural form even if the given sheet is singular


/obj/machinery/robotics_fabricator/emag_act(var/remaining_charges, var/mob/user)
	if (emagged)
		to_chat(user, SPAN_WARNING("No records in user DB."))
		return
	emagged = TRUE
	req_access.Cut()
	to_chat(user, SPAN_NOTICE("User DB truncated; defaulting to open access."))
	return 1

/obj/machinery/robotics_fabricator/proc/update_busy()
	if(queue.len)
		if(can_build(queue[1]))
			busy = 1
		else
			busy = 0
	else
		busy = 0

/obj/machinery/robotics_fabricator/proc/add_to_queue(var/index)
	var/datum/design/D = files.known_designs[index]
	queue += D
	update_busy()

/obj/machinery/robotics_fabricator/proc/remove_from_queue(var/index)
	if(index == 1)
		progress = 0
	if (length(queue) >= index)
		queue.Cut(index, index + 1)
	update_busy()

/obj/machinery/robotics_fabricator/proc/can_build(var/datum/design/D)
	for(var/M in D.materials)
		if(materials[M] <= D.materials[M] * mat_efficiency)
			return 0
	return 1

/obj/machinery/robotics_fabricator/proc/check_build()
	if(!queue.len)
		progress = 0
		return
	var/datum/design/D = queue[1]
	if(!can_build(D))
		progress = 0
		return
	if(D.time > progress)
		return
	for(var/M in D.materials)
		materials[M] = max(0, materials[M] - D.materials[M] * mat_efficiency)
	if(D.build_path)
		var/obj/new_item = D.Fabricate(loc, src)
		visible_message("\The [src] pings, indicating that \the [D] is complete.", "You hear a ping.")
		if(mat_efficiency != 1)
			if(new_item.matter && new_item.matter.len > 0)
				for(var/i in new_item.matter)
					new_item.matter[i] = new_item.matter[i] * mat_efficiency
	remove_from_queue(1)

/obj/machinery/robotics_fabricator/proc/get_queue_names()
	. = list()
	for(var/i = 2 to queue.len)
		var/datum/design/D = queue[i]
		. += D.name

/obj/machinery/robotics_fabricator/proc/get_build_options()
	. = list()
	for(var/i = 1 to files.known_designs.len)
		var/datum/design/D = files.known_designs[i]
		if(!D.build_path || !(D.build_type & MECHFAB))
			continue
		. += list(list("name" = D.name, "id" = i, "category" = D.category, "resourses" = get_design_resourses(D), "time" = get_design_time(D)))

/obj/machinery/robotics_fabricator/proc/get_design_resourses(var/datum/design/D)
	var/list/F = list()
	for(var/T in D.materials)
		F += "[capitalize(T)]: [D.materials[T] * mat_efficiency]"
	return english_list(F, and_text = ", ")

/obj/machinery/robotics_fabricator/proc/get_design_time(var/datum/design/D)
	if (speed == 0)
		return "INFINITE"

	return time2text(round(10 * D.time / speed), "mm:ss")

/obj/machinery/robotics_fabricator/proc/update_categories()
	categories = list()
	for(var/datum/design/D in files.known_designs)
		if(!D.build_path || !(D.build_type & MECHFAB))
			continue
		categories |= D.category
	if(!category || !(category in categories))
		category = categories[1]

/obj/machinery/robotics_fabricator/proc/get_materials()
	. = list()
	for(var/T in materials)
		. += list(list("mat" = capitalize(T), "amt" = materials[T]))

/obj/machinery/robotics_fabricator/proc/eject_materials(var/material, var/amount) // 0 amount = 0 means ejecting a full stack; -1 means eject everything
	var/recursive = amount == -1 ? 1 : 0
	material = lowertext(material)
	var/mattype
	switch(material)
		if(MATERIAL_STEEL)
			mattype = /obj/item/stack/material/steel
		if(MATERIAL_GLASS)
			mattype = /obj/item/stack/material/glass
		if(MATERIAL_ALUMINIUM)
			mattype = /obj/item/stack/material/aluminium
		if(MATERIAL_PLASTIC)
			mattype = /obj/item/stack/material/plastic
		if(MATERIAL_GOLD)
			mattype = /obj/item/stack/material/gold
		if(MATERIAL_SILVER)
			mattype = /obj/item/stack/material/silver
		if(MATERIAL_DIAMOND)
			mattype = /obj/item/stack/material/diamond
		if(MATERIAL_PHORON)
			mattype = /obj/item/stack/material/phoron
		if(MATERIAL_URANIUM)
			mattype = /obj/item/stack/material/uranium
		else
			return
	var/obj/item/stack/material/S = new mattype(loc)
	if(amount <= 0)
		amount = S.max_amount
	var/ejected = min(round(materials[material] / S.perunit), amount)
	S.amount = min(ejected, amount)
	if(S.amount <= 0)
		qdel(S)
		return
	materials[material] -= ejected * S.perunit
	if(recursive && materials[material] >= S.perunit)
		eject_materials(material, -1)
	update_busy()

/obj/machinery/robotics_fabricator/proc/sync()
	sync_message = "Error: no console found."
	for(var/obj/machinery/computer/rdconsole/RDC in get_area_all_atoms(get_area(src)))
		if(!RDC.sync)
			continue
		for(var/datum/tech/T in RDC.files.known_tech)
			files.AddTech2Known(T)
		for(var/datum/design/D in RDC.files.known_designs)
			files.AddDesign2Known(D)
		files.RefreshResearch()
		sync_message = "Sync complete."
	update_categories()