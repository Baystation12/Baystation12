
/datum/game_mode/outer_colonies/reclamation
	name = "Reclamation"
	config_tag = "reclamation"
	round_description = "The Covenant ransack the outer edges of human space for Forerunner artifacts."
	extended_round_description = "The Covenant ransack the outer edges of human space for Forerunner artifacts."
	required_players = 0
	end_conditions_required = 1
	factions = list(/datum/faction/unsc, /datum/faction/covenant)
	overmap_hide = list(/obj/effect/overmap/sector/exo_listen, /obj/effect/overmap/ship/soe_argentum)
	disabled_jobs_types = list(\
		/datum/job/soe_commando,\
		/datum/job/soe_commando_officer,\
		/datum/job/soe_commando_captain,\
		/datum/job/geminus_x52/researcher,\
		/datum/job/geminus_x52/research_director,\
		/datum/job/geminus_innie,\
		/datum/job/geminus_innie/officer,\
		/datum/job/geminus_innie/commander,\
		/datum/job/police,\
		/datum/job/police_chief)

/datum/game_mode/outer_colonies/reclamation/setup_objectives()
	. = ..()

	var/datum/objective/capture_innies/obj = locate() in GLOB.UNSC.all_objectives
	obj.fake = 1

	var/datum/objective/colony_capture/unsc/obj2 = locate() in GLOB.UNSC.all_objectives
	obj2.fake = 1

	var/datum/objective/overmap/unsc_innie_base/obj3 = locate() in GLOB.UNSC.all_objectives
	obj3.fake = 1
