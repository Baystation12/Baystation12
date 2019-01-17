/obj/machinery/kinetic_harvester
	name = "kinetic harvester"
	desc = "A complicated mechanism for harvesting rapidly moving particles from a fusion toroid and condensing them into a usable form."
	density = TRUE
	use_power = POWER_USE_IDLE
	icon = 'icons/obj/kinetic_harvester.dmi'
	icon_state = "off"

	var/initial_id_tag
	var/list/stored =     list()
	var/list/harvesting = list()
	var/obj/machinery/power/fusion_core/harvest_from
	var/conversion_efficiency = 30

/obj/machinery/kinetic_harvester/Initialize()
	set_extension(src, /datum/extension/fusion_plant_member, /datum/extension/fusion_plant_member)
	if(initial_id_tag)
		var/datum/extension/fusion_plant_member/fusion = get_extension(src, /datum/extension/fusion_plant_member)
		fusion.set_tag(null, initial_id_tag)
	find_core()
	queue_icon_update()
	. = ..()

/obj/machinery/kinetic_harvester/Destroy()
	var/datum/extension/fusion_plant_member/fusion = get_extension(src, /datum/extension/fusion_plant_member)
	if(fusion)
		var/datum/fusion_plant/plant = fusion.get_fusion_plant()
		if(plant)
			plant.remove_device(src)
	. = ..()

/obj/machinery/kinetic_harvester/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/kinetic_harvester/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/kinetic_harvester/attackby(var/obj/item/thing, var/mob/user)
	if(isMultitool(thing))
		var/datum/extension/fusion_plant_member/fusion = get_extension(src, /datum/extension/fusion_plant_member)
		if(fusion.get_new_tag(user))
			find_core()
		return
	return ..()

/obj/machinery/kinetic_harvester/proc/find_core()
	harvest_from = null
	var/datum/extension/fusion_plant_member/fusion = get_extension(src, /datum/extension/fusion_plant_member)
	var/datum/fusion_plant/plant = fusion.get_fusion_plant()
	if(plant)	
		for(var/thing in plant.fusion_cores)
			harvest_from = thing
			break
	return harvest_from

/obj/machinery/kinetic_harvester/interact(var/mob/user)

	if(stat & (BROKEN|NOPOWER))
		user.unset_machine()
		user << browse(null, "window=kinetic_harvester")
		return

	if (!istype(user, /mob/living/silicon) && get_dist(src, user) > 1)
		user.unset_machine()
		user << browse(null, "window=kinetic_harvester")
		return

	if(!harvest_from && !find_core())
		to_chat(user, SPAN_WARNING("This machine cannot locate a fusion core. Please check that one has been installed within ten meters of the machine."))
		return

	var/dat = "<B>Kinetic Harvester</B><BR>"
	dat += "Harvester is: <a href='?src=\ref[src];toggle_power=1'>[use_power >= POWER_USE_ACTIVE ? "on" : "off"]</a><br>"
	if(!harvest_from.owned_field)
		dat += SPAN_DANGER("Core is not currently active.")
		dat += "<br>"
	else
		dat += "<table width = '100%' align = 'center'>"
		dat += "<tr><td><b>Reactant</b></td><td><b>Field Amount</b></td><td><b>Stored Amount</b></td><td><b>Harvesting</b></td></tr>"

		for(var/mat in harvesting)
			if(!harvest_from.owned_field.reactants[mat])
				harvesting -= mat
			else if(isnull(stored[mat]))
				stored[mat] = 0

		for(var/mat in harvest_from.owned_field.reactants)
			if(SSmaterials.materials_by_name[mat] && isnull(stored[mat]))
				stored[mat] = 0

		for(var/mat in stored)
			dat += "<tr><td>[capitalize(mat)]</td><td>[harvest_from.owned_field.reactants[mat]]</td><td>[stored[mat]]</td><td><a href='?src=\ref[src];toggle_harvest=[mat]'>[harvesting[mat] ? "Enabled" : "Disabled"]</a></td></tr>"
		dat += "</table>"

	var/datum/browser/popup = new(user, "kinetic_harvester", "Kinetic Harvester", 800, 400, src)
	popup.set_content(dat)
	popup.open()
	user.set_machine(src)
	
/obj/machinery/kinetic_harvester/Process()

	if(harvest_from && get_dist(src, harvest_from) > 10)
		harvest_from = null

	if(use_power >= POWER_USE_ACTIVE)
		if(LAZYLEN(harvesting) && harvest_from && harvest_from.check_core_status() && harvest_from.owned_field)
			for(var/mat in harvesting)
				if(isnull(harvest_from.owned_field.reactants[mat]))
					harvesting -= mat
				else
					var/harvest = min(harvest_from.owned_field.reactants[mat], rand(1,5))
					harvest_from.owned_field.reactants[mat] -= harvest
					if(harvest_from.owned_field.reactants[mat] <= 0)
						harvest_from.owned_field.reactants -= mat
					if(!isnull(stored[mat]))
						stored[mat] += harvest
					else
						stored[mat] = harvest
					break
		for(var/mat in stored)
			if(SSmaterials.materials_by_name[mat])
				var/material/material = SSmaterials.get_material_by_name(mat)
				if(material && stored[mat]*conversion_efficiency >= material.units_per_sheet)
					material.place_sheet(loc)
					stored[mat] -= Floor(material.units_per_sheet/conversion_efficiency)
					if(stored[mat] <= 0)
						stored -= mat
					return

/obj/machinery/kinetic_harvester/on_update_icon()
	if(stat & (BROKEN|NOPOWER))
		icon_state = "broken"
	else if(use_power >= POWER_USE_ACTIVE)
		icon_state = "on"
	else
		icon_state = "off"

/obj/machinery/kinetic_harvester/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)
	if(!(stat & (BROKEN|NOPOWER)))

		if(href_list["toggle_power"])
			use_power = (use_power >= POWER_USE_ACTIVE ? POWER_USE_IDLE : POWER_USE_ACTIVE)
			queue_icon_update()
			updateUsrDialog()
			return TOPIC_REFRESH

		if(href_list["toggle_harvest"])
			var/mat = href_list["toggle_harvest"]
			if(harvesting[mat])
				harvesting -= mat
			else
				harvesting[mat] = TRUE
				if(!(mat in stored))
					stored[mat] = 0
			updateUsrDialog()
			return TOPIC_REFRESH
