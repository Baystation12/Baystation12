//This job is left enabled to prevent conflict with other gamemodes, as removing it causes over 100 errors. Do not add it to the enabled jobs list.

#/datum/job/assistant
#	title = "Assistant"
#	department = "Civilian"
#	department_flag = CIV
#
#	total_positions = -1
#	spawn_positions = -1
#	supervisors = "absolutely everyone"
#	selection_color = "#515151"
#	economic_modifier = 1
#	access = list()			//See /datum/job/assistant/get_access()
#	minimal_access = list()	//See /datum/job/assistant/get_access()
#	alt_titles = list("Technical Assistant","Medical Intern","Research Assistant","Visitor")
#	outfit_type = /decl/hierarchy/outfit/job/assistant
#
#/datum/job/assistant/get_access()
#	if(config.assistant_maint)
#		return list(access_maint_tunnels)
#	else
#		return list()
#
