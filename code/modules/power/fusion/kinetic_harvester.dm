/obj/machinery/kinetic_harvester
	name = "kinetic harvester"
	desc = "A complicated mechanism for harvesting rapidly moving particles from a fusion toroid and condensing them into a usable form."
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_IDLE
	icon = 'icons/obj/machines/kinetic_harvester.dmi'
	icon_state = "harvester"
	var/initial_id_tag
	var/list/stored =     list()
	var/list/harvesting = list()
	var/obj/machinery/power/fusion_core/harvest_from
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

/obj/machinery/kinetic_harvester/Initialize()
	set_extension(src, /datum/extension/local_network_member)
	if(initial_id_tag)
		var/datum/extension/local_network_member/lanm = get_extension(src, /datum/extension/local_network_member)
		lanm.set_tag(null, initial_id_tag)
	find_core()
	queue_icon_update()
	. = ..()

/obj/machinery/kinetic_harvester/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/kinetic_harvester/use_tool(obj/item/thing, mob/living/user, list/click_params)
	if(isMultitool(thing))
		var/datum/extension/local_network_member/lanm = get_extension(src, /datum/extension/local_network_member)
		if(lanm.get_new_tag(user))
			find_core()
		return TRUE

	return ..()

/obj/machinery/kinetic_harvester/proc/find_core()
	harvest_from = null
	var/datum/extension/local_network_member/lanm = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/lan = lanm.get_local_network()

	if(lan)
		var/list/fusion_cores = lan.get_devices(/obj/machinery/power/fusion_core)
		if(fusion_cores && length(fusion_cores))
			harvest_from = fusion_cores[1]
	return harvest_from

/obj/machinery/kinetic_harvester/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)

	if(!harvest_from && !find_core())
		to_chat(user, SPAN_WARNING("This machine cannot locate a fusion core. Please ensure the machine is correctly configured to share a fusion plant network."))
		return

	var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/plant = fusion.get_local_network()
	var/list/data = list()

	data["id"] = plant ? plant.id_tag : "unset"
	data["status"] = (use_power >= POWER_USE_ACTIVE)
	data["materials"] = list()
	for(var/mat in stored)
		var/material/material = SSmaterials.get_material_by_name(mat)
		if(material)
			var/sheets = floor(stored[mat]/(material.units_per_sheet * 1.5))
			data["materials"] += list(list("material" = mat, "rawamount" = stored[mat], "amount" = sheets, "harvest" = harvesting[mat]))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "kinetic_harvester.tmpl", name, 400, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/kinetic_harvester/Process()
	if(harvest_from && get_dist(src, harvest_from) > 10)
		harvest_from = null

	if(use_power >= POWER_USE_ACTIVE)
		if(harvest_from && harvest_from.owned_field)
			for(var/mat in harvest_from.owned_field.reactants)
				if(SSmaterials.materials_by_name[mat] && !stored[mat])
					stored[mat] = 0
			for(var/mat in harvesting)
				if(!SSmaterials.materials_by_name[mat] || !harvest_from.owned_field.reactants[mat])
					harvesting -= mat
				else
					var/harvest = min(harvest_from.owned_field.reactants[mat], rand(100,200))
					harvest_from.owned_field.reactants[mat] -= harvest
					if(harvest_from.owned_field.reactants[mat] <= 0)
						harvest_from.owned_field.reactants -= mat
					stored[mat] += harvest
		else
			harvesting.Cut()

/obj/machinery/kinetic_harvester/on_update_icon()
	ClearOverlays()
	if(panel_open)
		AddOverlays("[icon_state]_panel")
	if(is_powered())
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights"))
		AddOverlays("[icon_state]_lights")
	if(use_power == POWER_USE_ACTIVE)
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights_working"))
		AddOverlays("[icon_state]_lights_working")

/obj/machinery/kinetic_harvester/OnTopic(mob/user, href_list, datum/topic_state/state)
	if(href_list["remove_mat"])
		var/mat = href_list["remove_mat"]
		var/material/material = SSmaterials.get_material_by_name(mat)
		if(material)
			var/sheet_cost = (material.units_per_sheet * 1.5)
			var/sheets = floor(stored[mat]/sheet_cost)
			if(sheets > 0)
				material.place_sheet(loc, sheets)
				stored[mat] -= sheets * sheet_cost
				if(stored[mat] <= 0)
					stored -= mat
				return TOPIC_REFRESH

	if(href_list["toggle_power"])
		use_power = (use_power >= POWER_USE_ACTIVE ? POWER_USE_IDLE : POWER_USE_ACTIVE)
		queue_icon_update()
		return TOPIC_REFRESH

	if(href_list["toggle_harvest"])
		var/mat = href_list["toggle_harvest"]
		if(harvesting[mat])
			harvesting -= mat
		else
			harvesting[mat] = TRUE
			if(!(mat in stored))
				stored[mat] = 0
		return TOPIC_REFRESH
