//Seperated as this code relies on outer colonies GM to work, and throws type-errors when the GM isn't loaded.//
/obj/effect/overmap/unsc_cassius_moon/Destroy()
	var/datum/game_mode/outer_colonies/gm = ticker.mode
	if(istype(gm))
		gm.allow_scan = 1
		GLOB.global_announcer.autosay("Our Moonbase has fallen! Reinforcements will take take longer to arrive. Regroup at the ONI base, and get ready to strike out at covenant scanning devices.", "HIGHCOMM SIGINT", RADIO_FLEET, LANGUAGE_ENGLISH)
		GLOB.global_announcer.autosay("The human defences are down! Their reinforcements are delayed! Plant the holy scanners, and locate the relic! Do not be distracted by the humans' groundside fortifications!", "Covenant Overwatch", RADIO_COV, LANGUAGE_SANGHEILI)

		GLOB.UNSC.fleet_spawn_at += 45 MINUTES

		//unlock some new job slots after a short delay
		spawn(30)
			GLOB.UNSC.unlock_special_job()
			GLOB.UNSC.unlock_special_job()
			GLOB.COVENANT.unlock_special_job()
			GLOB.COVENANT.unlock_special_job()

		//this is janky, i really should fix spawns instead
		//its necessary because the AI initial spawn is on the ODP
		//without the ODP the AI will spawn somewhere random like the Cov ship
		var/datum/job/ai_job = job_master.occupations_by_type[/datum/job/unsc_ai]
		ai_job.total_positions = 0

	. = ..()