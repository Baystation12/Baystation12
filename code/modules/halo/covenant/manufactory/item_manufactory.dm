
/obj/machinery/item_manufacturer
	name = "Jiralhanae weapon manufactory"
	desc = "A crude noisy machine combining crucible, forge and stamp press."
	icon = 'code/modules/halo/covenant/manufactory/machines.dmi'
	icon_state = "alien-pad-idle"
	var/icon_state_idle = "alien-pad-idle"
	var/icon_state_active = "alien-pad"
	anchored = 1
	density = 1

	use_power = 0
	idle_power_usage = 0
	active_power_usage = 1
	var/obj/structure/plasma_battery/battery

	var/list/building_queue = list()
	var/list/building_queue_interact = list()
	var/start_build_time = 0

	var/list/known_designs = list()
	var/list/designs_ui = list()
	var/list/stored_materials

	var/detected_materials = "None"
	var/detected_components = "None"
	var/list/busy_noises = list("clangs!","bangs!","whines!","grinds!","whirrs!")
	var/list/design_type_parents = list(/datum/craft_blueprint/brute_weapon)

/obj/machinery/item_manufacturer/covenant
	name = "weapon assembly forge"
	desc = "An advanced nanofabricator."
	icon_state = "console"
	icon_state_idle = "console"
	icon_state_active = "console-active"
	busy_noises = list("whirrs!")
	design_type_parents = list(/datum/craft_blueprint/cov_weapon)

/obj/machinery/item_manufacturer/component
	name = "component assembly forge"
	desc = "An advanced nanofabricator."
	icon_state = "console"
	icon_state_idle = "console"
	icon_state_active = "console-active"
	busy_noises = list("whirrs!")
	design_type_parents = list(/datum/craft_blueprint/cov_component)

/obj/machinery/item_manufacturer/armour
	name = "armour assembly forge"
	design_type_parents = list(/datum/craft_blueprint/brute_clothing)

/obj/machinery/item_manufacturer/armour/boulderclan
	design_type_parents = list(/datum/craft_blueprint/brute_clothing, /datum/craft_blueprint/brute_clothing_boulder)

/obj/machinery/item_manufacturer/armour/ramclan
	design_type_parents = list(/datum/craft_blueprint/brute_clothing, /datum/craft_blueprint/brute_clothing_ram)

/obj/machinery/item_manufacturer/tools
	name = "tool manufacturer"
	icon_state = "experiment-open"
	icon_state_idle = "experiment-open"
	icon_state_active = "experiment"
	design_type_parents = list(/datum/craft_blueprint/cov_tool)

/obj/machinery/item_manufacturer/New()
	. = ..()
	//just know all relevant designs for now
	for(var/type_parent in design_type_parents)
		for(var/curtype in typesof(type_parent) - type_parent)
			add_design(new curtype())

/obj/machinery/item_manufacturer/process()
	if(building_queue.len && anchored)
		//chat spam i know... this machine is meant to be loud and crude
		if(busy_noises.len)
			src.visible_message("<span class='info'>[src] [pick(busy_noises)]</span>")
		var/datum/craft_blueprint/building = building_queue[1]
		if(world.time > start_build_time + building.time SECONDS)
			//finish building
			building_queue.Cut(1,2)
			building_queue_interact.Cut(1,2)
			var/obj/item/new_item = new building.build_path(src.loc)
			src.visible_message("<span class='notice'>[src] finishes manufacturing [new_item].</span>")

			//setup for the next item or reset
			if(building_queue.len)
				building = building_queue[1]
				start_build_time = world.time
			else
				icon_state = icon_state_idle

/obj/machinery/item_manufacturer/proc/add_design(var/datum/craft_blueprint/new_design)
	known_designs[new_design.name] = new_design
	var/req_materials = ""
	for(var/cur_material in new_design.materials)
		req_materials += "[cur_material] ([new_design.materials[cur_material]]), "
	for(var/cur_component in new_design.components)
		req_materials += "[cur_component], "
	designs_ui.Add(list(list("name" = new_design.name, "req_materials" = req_materials)))

/obj/machinery/item_manufacturer/proc/attempt_build_design(var/design_name, var/mob/living/user)
	//get the design
	var/datum/craft_blueprint/chosen_design = known_designs[design_name]

	//check for materials
	if(locate_materials(chosen_design, 0))
		to_chat(user, "<span class='notice'>[src] begins manufacturing [design_name].</span>")
		//consume materials
		locate_materials(chosen_design, 1)
		if(!building_queue.len)
			icon_state = icon_state_active
			start_build_time = world.time
		building_queue.Add(chosen_design)
		building_queue_interact.Add(chosen_design.name)
		. = 1
	else
		to_chat(user, "<span class='warning'>Insufficient ingredients to manufacture [design_name].</span>")

/obj/machinery/item_manufacturer/proc/locate_materials(var/datum/craft_blueprint/chosen_design, var/consume_mats = 0)

	var/list/materials_to_locate = chosen_design.materials.Copy()
	var/list/components_to_locate = chosen_design.components.Copy()

	//loop over the adjacent loading trays
	for(var/obj/structure/closet/tray in range(src,1))
		if(tray.opened)
			continue

		//check for any materials loaded
		for(var/obj/item/I in tray)

			//materials
			if(istype(I, /obj/item/stack/material))
				var/obj/item/stack/material/M = I
				var/amount_needed = materials_to_locate[M.default_type]
				//check if we need it
				if(amount_needed > 0)

					//subtract the needed amount
					var/amount_to_subtract = min(M.amount, amount_needed)
					amount_needed -= amount_to_subtract
					materials_to_locate[M.default_type] = amount_needed

					if(consume_mats)
						M.amount -= amount_to_subtract
						if(M.amount <= 0)
							qdel(M)

					//remove it from the list if we got enough
					if(amount_needed <= 0)
						materials_to_locate -= M.default_type

			else
				//components
				for(var/component_name in components_to_locate)
					if(I.type == components_to_locate[component_name])
						if(consume_mats)
							qdel(I)
						components_to_locate -= component_name

	if(consume_mats)
		scan_for_materials()

	//if there is anything left, we didnt find enough
	if(materials_to_locate.len || components_to_locate.len)
		return 0

	return 1

/obj/machinery/item_manufacturer/proc/scan_for_materials()

	var/list/found_materials = list()
	//loop over the adjacent loading trays
	for(var/obj/structure/closet/tray in range(src,1))
		if(tray.opened)
			continue

		//check for any materials loaded
		for(var/obj/item/I in tray)
			var/amount = found_materials[I.name]
			if(!amount)
				amount = 0
			if(istype(I, /obj/item/stack/material))
				var/obj/item/stack/material/M = I
				amount += M.amount
			else
				amount += 1
			found_materials[I.name] = amount

	if(found_materials.len)
		detected_materials = ""
		for(var/cur_material in found_materials)
			detected_materials += "[cur_material] ([found_materials[cur_material]]) "
	else
		detected_materials = "None"

//see code\game\machinery\machinery.dm
/obj/machinery/item_manufacturer/auto_use_power()
	if(!battery)
		update_battery()
	if(!battery)
		return 0

	if(src.use_power == 1)
		. = use_power(idle_power_usage)
	else if(src.use_power >= 2)
		. = use_power(active_power_usage)

/obj/machinery/item_manufacturer/proc/update_battery()
	battery = null
	for(var/obj/structure/plasma_battery/check_battery in range(1, src))
		if(check_battery.charge > 0)
			battery = check_battery
			return 1

	return 0

/obj/machinery/item_manufacturer/use_power(var/amount)
	if(!battery)
		update_battery()

	if(battery)
		. = battery.drain_plasma(amount)

		if(!.)
			update_battery()
