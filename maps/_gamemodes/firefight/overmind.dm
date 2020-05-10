
/datum/npc_overmind/firefight
	overmind_active = 1
	comms_channel = null

/datum/npc_overmind/firefight/process_casualty_report(var/datum/npc_report/report)
	constructor_troops -= report.reporter_mob
	combat_troops -= report.reporter_mob
	support_troops -= report.reporter_mob
	other_troops -= report.reporter_mob

/datum/npc_overmind/firefight/New()
	. = ..()
	GLOB.processing_objects.Add(src)
