
/datum/game_mode/outer_colonies/revolution
	name = "Revolution"
	config_tag = "revolution"
	round_description = "In an outer colony on the edge of human space, a revolution is brewing."
	extended_round_description = "In an outer colony on the edge of human space, a revolution is brewing."
	required_players = 0
	factions = list(/datum/faction/unsc, /datum/faction/insurrection, /datum/faction/human_civ)
	disabled_jobs_types = list(\
		/datum/job/researchdirector,\
		/datum/job/researcher,\
		/datum/job/ONIGUARD,\
		/datum/job/ONIGUARDS,\
		/datum/job/soe_commando,\
		/datum/job/soe_commando_officer,\
		/datum/job/soe_commando_captain,\
		/datum/job/bertelsODST,\
		/datum/job/bertelsODSTO,\
		/datum/job/covenant/sangheili_minor,\
		/datum/job/covenant/sangheili_major,\
		/datum/job/covenant/sangheili_honour_guard,\
		/datum/job/covenant/sangheili_shipmaster,\
		/datum/job/covenant/lesser_prophet,\
		/datum/job/covenant/kigyarminor,\
		/datum/job/covenant/kigyarmajor,\
		/datum/job/covenant/unggoy_minor,\
		/datum/job/covenant/unggoy_major,\
		/datum/job/covenant/skirmminor,\
		/datum/job/covenant/skirmmajor,\
		/datum/job/covenant/skirmmurmillo)
