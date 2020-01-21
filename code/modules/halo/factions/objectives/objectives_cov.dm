
#define COLONY_GLASSED_AMOUNT_REQUIRED 5 //4 projector hit for glassing to count.

/* COVENANT */

/datum/objective/overmap/covenant_unsc_ship
	short_text = "Destroy the human warship"
	explanation_text = "The human weapons are crude but occasionally effective. Eliminate any warships in the area."
	target_faction_name = "UNSC"
	objective_type = 0
	win_points = 50
/*
/datum/objective/overmap/covenant_odp
	short_text = "Destroy the human defence platform"
	explanation_text = "We require safe access to the human worlds. Take out their defence platforms!"
	target_faction_name = "UNSC"
	objective_type = 0
	overmap_type = 0
	win_points = 50
*/
/datum/objective/overmap/covenant_ship
	short_text = "Protect Covenant ship"
	explanation_text = "Your ship is your only route back to Covenant space. Do not allow it to be destroyed."
	slipspace_affected = 1
	target_faction_name = "Covenant"
	lose_points = 150

/datum/objective/retrieve/steal_ai
	short_text = "Capture human construct"
	explanation_text = "These humans store tactical and navigational data in their intelligent constructs. What a prize!"
	points_per_item = 150
	win_points = 150
	slipspace_affected = 1

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
	points_per_item = 150
	win_points = 150

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
	points_per_item = 100
	win_points = 100
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
	win_points = 10
	slipspace_affected = 1

/datum/objective/glass_colony/check_completion()
	var/obj/effect/overmap/human_colony = GLOB.HUMAN_CIV.get_base()
	if(human_colony && human_colony.glassed >= COLONY_GLASSED_AMOUNT_REQUIRED)
		return 1
	return 0

/datum/objective/colony_capture/cov
	short_text = "Capture the human colony"
	explanation_text = "Holding the human colony will give us time to search it for artifacts."
	objective_faction = "Covenant"
	radio_frequency = "BattleNet"
	radio_language = "Sangheili"
	radio_name = "Ministry of Fervent Intercession"

#undef COLONY_GLASSED_AMOUNT_REQUIRED
