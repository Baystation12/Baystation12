
#define COLONY_GLASSED_AMOUNT_REQUIRED 5 //5 projector hit for glassing to count.

/* COVENANT */

/datum/objective/protect/covenant_leader
	short_text = "Protect Covenant leader"
	explanation_text = "Protect the Covenant Commander. Their loss is a terrible setback to the Great Journey."
	lose_points = 50
	slipspace_affected = 1

/datum/objective/protect/covenant_leader/find_target()
	target = GLOB.COVENANT.get_commander()
	if(target)
		explanation_text = "Protect [target.current.real_name], the [target.assigned_role]."
	return target

/datum/objective/protect/protect_cov_leader/check_completion()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0
	return ..()

/datum/objective/destroy_ship/covenant
	short_text = "Destroy the human warship"
	explanation_text = "The human weapons are crude but occasionally effective. Eliminate the warship in the area."
	slipspace_affected = 1

/datum/objective/destroy_ship/covenant/find_target()
	target_ship = GLOB.UNSC.get_flagship()
	return target_ship

/datum/objective/destroy_ship/covenant_odp
	short_text = "Destroy the human defence platform"
	explanation_text = "We require safe access to the human worlds. Take out the defence platform!"
	slipspace_affected = 1

/datum/objective/destroy_ship/covenant_odp/find_target()
	target_ship = GLOB.UNSC.get_base()
	return target_ship

/datum/objective/protect_ship/covenant
	short_text = "Protect Covenant ship"
	explanation_text = "Your ship is your only route back to Covenant space. Do not allow it to be destroyed."
	slipspace_affected = 1

/datum/objective/protect_ship/covenant/find_target()
	target_ship = GLOB.COVENANT.get_flagship()
	return target_ship

/datum/objective/retrieve/steal_ai
	short_text = "Capture human construct"
	explanation_text = "These humans store tactical and navigational data in their intelligent constructs. What a prize!"
	points_per_item = 150
	win_points = 150
	slipspace_affected = 1

/datum/objective/retrieve/steal_ai/find_target()
	delivery_areas = GLOB.COVENANT.get_objective_delivery_areas()
	return delivery_areas.len

/datum/objective/retrieve/steal_ai/update_points()
	items_retrieved = 0
	win_points = 0
	for(var/area/cur_area in delivery_areas)
		for(var/mob/living/silicon/ai/A in cur_area)
			items_retrieved += 1
			win_points += points_per_item

/datum/objective/retrieve/artifact
	short_text = "Retrieve the Forerunner artifact"
	explanation_text = "The humans are hiding a Forerunner artifact somewhere in this system. Locate it and bring it to High Charity."
	slipspace_affected = 1

/datum/objective/retrieve/artifact/find_target()
	delivery_areas = GLOB.COVENANT.get_objective_delivery_areas()
	return delivery_areas.len

/datum/objective/retrieve/artifact/update_points()
	items_retrieved = 0
	win_points = 0
	for(var/area/cur_area in delivery_areas)
		for(var/obj/machinery/artifact/A in cur_area)
			items_retrieved += 1
			win_points += points_per_item

/datum/objective/retrieve/nav_data
	short_text = "Steal navigation datachips from the humans"
	explanation_text = "We must locate the hideout of these humans! Retrieve as many nav data chips you can for examination."
	points_per_item = 30
	win_points = 120
	slipspace_affected = 1

/datum/objective/retrieve/nav_data/update_points()
	items_retrieved = 0
	win_points = 0
	for(var/area/cur_area in delivery_areas)
		for(var/obj/item/nav_data_chip/C in cur_area)
			if(C.chip_faction == "covenant")
				continue
			items_retrieved += 1
			if(istype(C, /obj/item/nav_data_chip/fragmented))
				//award partial points for fragments
				var/obj/item/nav_data_chip/fragmented/F = C
				win_points += points_per_item * (F.fragments_have / F.fragments_required)
			else
				//award full points for the chip
				win_points += points_per_item

/datum/objective/retrieve/nav_data/find_target()
	delivery_areas = GLOB.COVENANT.get_objective_delivery_areas()
	return delivery_areas.len

/datum/objective/glass_colony
	short_text = "Glass the human colony"
	explanation_text = "These humans cannot be allowed to live. The surface of their worlds must burn until they are glass!"
	win_points = 100
	slipspace_affected = 1

/datum/objective/glass_colony/check_completion()
	var/obj/effect/overmap/human_colony = GLOB.HUMAN_CIV.get_base()
	if(human_colony && human_colony.glassed >= COLONY_GLASSED_AMOUNT_REQUIRED)
		return 1
	return 0

/datum/objective/colony_capture/cov
	short_text = "Capture the human colony"
	explanation_text = "Holding the human colony will give us time to search it for artifacts."

#undef COLONY_GLASSED_AMOUNT_REQUIRED
