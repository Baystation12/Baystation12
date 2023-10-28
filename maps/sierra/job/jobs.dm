/datum/map/sierra
	species_to_job_whitelist = list(
		/datum/species/adherent = list(ADHERENT_JOBS),
		/datum/species/nabber = list(NABBER_JOBS),
		/datum/species/vox = list(SILICON_JOBS),
		/datum/species/human/mule = list(SILICON_JOBS)
	)

	species_to_job_blacklist = list(
		/datum/species/unathi = list(HUMAN_ONLY_JOBS),
		/datum/species/unathi/yeosa = list(HUMAN_ONLY_JOBS),
		/datum/species/tajaran = list(HUMAN_ONLY_JOBS),
		/datum/species/skrell = list(SKRELL_BLACKLISTED_JOBS),
		/datum/species/machine = list(MACHINE_BLACKLISTED_JOBS),
		/datum/species/diona = list(
			HUMAN_ONLY_JOBS, /datum/job/exploration_leader, /datum/job/explorer_pilot,
			/datum/job/officer, /datum/job/warden, /datum/job/detective,
			/datum/job/qm,
			/datum/job/senior_engineer, /datum/job/senior_doctor,
			/datum/job/senior_scientist, /datum/job/security_assistant
		)
	)

	// SIERRA TODO: Добавить на сьерру рякалок
	//	/datum/species/resomi = list(
	// 		HUMAN_ONLY_JOBS, /datum/job/officer, /datum/job/exploration_leader,
	// 		/datum/job/warden, /datum/job/chief_engineer, /datum/job/rd,
	// 		/datum/job/iaa, /datum/job/security_assistant
	// 	)

	allowed_jobs = list(
		/datum/job/captain, /datum/job/hop, /datum/job/rd, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos,
		/datum/job/iaa, /datum/job/adjutant,
		/datum/job/exploration_leader, /datum/job/explorer, /datum/job/explorer_pilot, /datum/job/explorer_medic, /datum/job/explorer_engineer,
		/datum/job/senior_engineer, /datum/job/engineer, /datum/job/infsys, /datum/job/engineer_trainee,
		/datum/job/warden, /datum/job/detective, /datum/job/officer, /datum/job/security_assistant,
		/datum/job/senior_doctor, /datum/job/doctor, /datum/job/doctor_trainee, /datum/job/chemist, /datum/job/psychiatrist,
		/datum/job/qm, /datum/job/cargo_tech,  /datum/job/cargo_assistant, /datum/job/mining,
		/datum/job/chief_steward, /datum/job/janitor, /datum/job/cook, /datum/job/bartender, /datum/job/steward, /datum/job/chaplain, /datum/job/actor,
		/datum/job/senior_scientist, /datum/job/scientist, /datum/job/roboticist, /datum/job/scientist_assistant,
		/datum/job/ai, /datum/job/cyborg,
		/datum/job/assistant
	)

	access_modify_region = list(
		ACCESS_REGION_SECURITY = list(access_hos, access_change_ids),
		ACCESS_REGION_MEDBAY = list(access_cmo, access_change_ids),
		ACCESS_REGION_RESEARCH = list(access_rd, access_change_ids),
		ACCESS_REGION_ENGINEERING = list(access_ce, access_change_ids),
		ACCESS_REGION_COMMAND = list(access_change_ids),
		ACCESS_REGION_GENERAL = list(access_hop, access_change_ids),
		ACCESS_REGION_SUPPLY = list(access_qm, access_change_ids),
	)

	// It will autoinit in New()
	synth_access = list(access_synth)

/datum/map/sierra/New()
	. = ..()
	synth_access += get_all_station_access()

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ GAS JOBS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// GRADE C
/singleton/cultural_info/culture/nabber
	valid_jobs = list(/datum/job/janitor)  // THIS IS GRADE C- TRUST ME ~ SidVeld


/singleton/cultural_info/culture/nabber/c
	valid_jobs = list(/datum/job/janitor, /datum/job/cargo_assistant)


/singleton/cultural_info/culture/nabber/c/plus
	valid_jobs = list(/datum/job/janitor,    /datum/job/cargo_assistant,
					  /datum/job/scientist_assistant)


// GRADE B
/singleton/cultural_info/culture/nabber/b/minus
	valid_jobs = list(/datum/job/janitor)


/singleton/cultural_info/culture/nabber/b
	valid_jobs = list(/datum/job/janitor,    /datum/job/cargo_assistant,
					  /datum/job/bartender,  /datum/job/cook, /datum/job/steward,
					  /datum/job/scientist_assistant)


/singleton/cultural_info/culture/nabber/b/plus
	valid_jobs = list(/datum/job/janitor,    /datum/job/cargo_assistant,
					  /datum/job/bartender,  /datum/job/cook, /datum/job/steward,
					  /datum/job/scientist_assistant)


// GRADE A
/singleton/cultural_info/culture/nabber/a/minus
	valid_jobs = list(/datum/job/scientist_assistant)


/singleton/cultural_info/culture/nabber/a
	valid_jobs = list(/datum/job/cargo_assistant,
					  /datum/job/bartender,  /datum/job/cook, /datum/job/steward,
					  /datum/job/chemist,    /datum/job/doctor_trainee,
					  /datum/job/roboticist, /datum/job/engineer_trainee,
					  /datum/job/scientist_assistant)



/singleton/cultural_info/culture/nabber/a/plus
	valid_jobs = list(/datum/job/cargo_assistant,
					  /datum/job/bartender,  /datum/job/cook, /datum/job/steward,
					  /datum/job/chemist,    /datum/job/doctor_trainee,
					  /datum/job/roboticist, /datum/job/engineer_trainee,
					  /datum/job/scientist_assistant)


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


/datum/job
	allowed_branches = list(
		/datum/mil_branch/civilian
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
	)
	required_language = LANGUAGE_HUMAN_EURO

/datum/map/sierra
	default_assistant_title = "Crewman"

#undef HUMAN_ONLY_JOBS
#undef SILICON_JOBS
#undef ADHERENT_JOBS
#undef NABBER_JOBS
#undef SKRELL_BLACKLISTED_JOBS
#undef MACHINE_BLACKLISTED_JOBS
