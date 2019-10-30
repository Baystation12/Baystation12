
/datum/game_mode/outer_colonies/revolution
	name = "Revolution"
	config_tag = "revolution"
	round_description = "In an outer colony on the edge of human space, a revolution is brewing."
	extended_round_description = "In an outer colony on the edge of human space, a revolution is brewing."
	required_players = 0
	end_conditions_required = 1
	factions = list(/datum/faction/unsc, /datum/faction/insurrection)
	overmap_hide = list(/obj/effect/overmap/sector/exo_research, /obj/effect/overmap/sector/exo_listen, /obj/effect/overmap/ship/soe_argentum, /obj/effect/overmap/ship/covenant_light_cruiser)
	disabled_jobs_types = list(\
		/datum/job/researchdirector,\
		/datum/job/researcher,\
		/datum/job/ONIGUARD,\
		/datum/job/ONIGUARDS,\
		/datum/job/bertelsODST,\
		/datum/job/bertelsODSTO,\
		/datum/job/covenant/sangheili_minor,\
		/datum/job/covenant/sangheili_major,\
		/datum/job/covenant/sangheili_honour_guard,\
		/datum/job/covenant/sangheili_shipmaster,\
		/datum/job/covenant/sangheili_ultra,\
		/datum/job/covenant/lesser_prophet,\
		/datum/job/covenant/kigyarminor,\
		/datum/job/covenant/kigyarmajor,\
		/datum/job/covenant/unggoy_minor,\
		/datum/job/covenant/unggoy_major,\
		/datum/job/covenant/skirmminor,\
		/datum/job/covenant/skirmmajor,\
		/datum/job/covenant/skirmcommando,\
		/datum/job/covenant/skirmmurmillo)

/datum/game_mode/outer_colonies/revolution/setup_objectives()
	. = ..()

	var/datum/objective/retrieve/steal_ai/cole_protocol/obj = locate() in GLOB.UNSC.all_objectives
	obj.fake = 1

	var/datum/objective/retrieve/nav_data/cole_protocol/obj2 = locate() in GLOB.UNSC.all_objectives
	obj2.fake = 1

	var/datum/objective/overmap/unsc_cov_ship/obj3 = locate() in GLOB.UNSC.all_objectives
	obj3.fake = 1

	var/datum/objective/retrieve/artifact/unsc/obj4 = locate() in GLOB.UNSC.all_objectives
	obj4.fake = 1
