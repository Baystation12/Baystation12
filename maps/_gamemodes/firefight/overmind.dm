
/datum/npc_overmind/firefight
	overmind_active = 1
	comms_channel = null	//disable comms chatter by default

/datum/npc_overmind/firefight/process_casualty_report(var/datum/npc_report/report)
	constructor_troops -= report.reporter_mob
	combat_troops -= report.reporter_mob
	support_troops -= report.reporter_mob
	other_troops -= report.reporter_mob

/datum/npc_overmind/firefight/New()
	. = ..()
	GLOB.processing_objects.Add(src)

/datum/npc_overmind/firefight/create_taskpoint_assign()
	//intentionally left blank

/datum/npc_overmind/firefight/process_contact_report(var/datum/npc_report/report)
	//intentionally left blank
	//create_comms_message("Hostile Contact at [get_area(report.reporter_mob)]. Engaging.", report.reporter_mob)

/datum/npc_overmind/firefight/process_casualty_report(var/datum/npc_report/report)
	//intentionally left blank
	//create_comms_message("Taking casualties at [get_area(report.reporter_mob)].", report.reporter_mob)
