/datum/job/assistant
	title = "Assistant"
	department = "Civilian"
	department_flag = CIV
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#515151"
	economic_modifier = 1
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	alt_titles = list("Technical Assistant" = /decl/hierarchy/outfit/job/assistant/eng,
	"Medical Intern" = /decl/hierarchy/outfit/job/assistant/med,
	"Research Assistant" = /decl/hierarchy/outfit/job/assistant/sci,
	"Security Cadet" = /decl/hierarchy/outfit/job/assistant/sec,
	"Visitor" = /decl/hierarchy/outfit/job/assistant/visitor,
	"Resident" = /decl/hierarchy/outfit/job/assistant/resident,
	"Colonist" = /decl/hierarchy/outfit/job/assistant/colonist)
	outfit_type = /decl/hierarchy/outfit/job/assistant

/datum/job/assistant/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()
