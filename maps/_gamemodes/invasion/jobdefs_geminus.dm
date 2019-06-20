
/datum/map/geminus_city
	allowed_jobs = list(\
		/datum/job/researchdirector,\
		/datum/job/researcher,\
		/datum/job/ONIGUARD,\
		/datum/job/ONIGUARDS,\
		/datum/job/geminus_innie,\
		/datum/job/geminus_innie/officer,\
		/datum/job/geminus_innie/commander,\
		/datum/job/URF_commando,\
		/datum/job/URF_commando_officer,\
		/datum/job/unscbertels_co,\
		/datum/job/unscbertels_xo,\
		/datum/job/unsc_ship_iwo,\
		/datum/job/unscbertels_ship_crew,\
		/datum/job/unscbertels_medical_crew,\
		/datum/job/bertelsunsc_ship_marine,\
		/datum/job/unsc_ship_marineplatoon,\
		/datum/job/bertelsODST,\
		/datum/job/bertelsODSTO,\
		/datum/job/colonist,\
		/datum/job/colonist_mayor,\
		/datum/job/police,\
		/datum/job/police_chief,\
		/datum/job/colony_ai,\
		/datum/job/covenant/sangheili_minor,\
		/datum/job/covenant/sangheili_major,\
		/datum/job/covenant/sangheili_ultra,\
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

	allowed_spawns = list(\
		DEFAULT_SPAWNPOINT_ID,\
		"Geminus Innie",\
		"Listening Post Spawn",\
		"Colony Arrival Shuttle",\
		"UNSC Base Spawns",\
		"Covenant Base Spawns",\
		"Research Facility Spawn",\
		"Research Facility Director Spawn",\
		"Research Facility Security Spawn")

	default_spawn = DEFAULT_SPAWNPOINT_ID

	species_to_job_whitelist = list(\
		/datum/species/kig_yar = list(/datum/job/covenant/kigyarminor,/datum/job/covenant/kigyarmajor),\
		/datum/species/unggoy = list(/datum/job/covenant/unggoy_minor,/datum/job/covenant/unggoy_major),\
		/datum/species/sangheili = list(/datum/job/covenant/sangheili_minor,/datum/job/covenant/sangheili_major,/datum/job/covenant/sangheili_ultra,/datum/job/covenant/sangheili_honour_guard,/datum/job/covenant/sangheili_shipmaster),\
		/datum/species/kig_yar_skirmisher = list(/datum/job/covenant/skirmminor,/datum/job/covenant/skirmmajor,/datum/job/covenant/skirmmurmillo,/datum/job/covenant/skirmcommando),\
		/datum/species/spartan = list(),\
		/datum/species/brutes = list(),\
		/datum/species/sanshyuum = list(/datum/job/covenant/lesser_prophet),\
		)
