/datum/job/ai
	title = "AI"
	department_flag = MSC
	faction = "Station"
	total_positions = 0 // Not used for AI, see is_position_available below and modules/mob/living/silicon/ai/latejoin.dm
	spawn_positions = 1
	selection_color = "#3f823f"
	supervisors = "your laws"
	req_admin_notify = 1
	minimal_player_age = 14
	account_allowed = 0
	economic_modifier = 0
	outfit_type = /decl/hierarchy/outfit/job/silicon/ai
	loadout_allowed = FALSE

/datum/job/ai/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	return 1

/datum/job/ai/is_position_available()
	return (empty_playable_ai_cores.len != 0)

/datum/job/cyborg
	title = "Cyborg"
	department_flag = MSC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "your laws and the AI"	//Nodrak
	selection_color = "#254c25"
	minimal_player_age = 7
	alt_titles = list("Android", "Robot")
	account_allowed = 0
	economic_modifier = 0
	loadout_allowed = FALSE
	outfit_type = /decl/hierarchy/outfit/job/silicon/cyborg

/datum/job/cyborg/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	return 1
