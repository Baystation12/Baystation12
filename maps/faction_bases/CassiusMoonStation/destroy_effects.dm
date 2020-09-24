//Seperated as this code relies on outer colonies GM to work, and throws type-errors when the GM isn't loaded.//
/obj/effect/overmap/unsc_cassius_moon/Destroy()
	var/datum/game_mode/outer_colonies/gm = ticker.mode
	if(istype(gm))
		gm.allow_scan = 1

		//unlock some new job slots after a short delay
		spawn(30)
			GLOB.UNSC.unlock_special_job()
			GLOB.COVENANT.unlock_special_job()

		//this is janky, i really should fix spawns instead
		//its necessary because the AI initial spawn is on the ODP
		//without the ODP the AI will spawn somewhere random like the Cov ship
		var/datum/job/ai_job = job_master.occupations_by_type[/datum/job/unsc_ai]
		ai_job.total_positions = 0

	. = ..()