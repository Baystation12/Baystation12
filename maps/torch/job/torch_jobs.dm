/datum/map/torch
	species_to_job_whitelist = list(
		/datum/species/adherent = list(/datum/job/ai, /datum/job/cyborg, /datum/job/assistant, /datum/job/janitor, /datum/job/chef, /datum/job/bartender, /datum/job/cargo_tech,
										/datum/job/engineer, /datum/job/roboticist, /datum/job/chemist, /datum/job/scientist_assistant, /datum/job/scientist, /datum/job/nt_pilot,
										/datum/job/mining),
		/datum/species/nabber = list(/datum/job/ai, /datum/job/cyborg, /datum/job/janitor, /datum/job/scientist_assistant, /datum/job/chemist,
									 /datum/job/roboticist, /datum/job/cargo_tech, /datum/job/chef, /datum/job/engineer, /datum/job/doctor, /datum/job/bartender),
		/datum/species/vox = list(/datum/job/ai, /datum/job/cyborg),
		/datum/species/human/mule = list(/datum/job/ai, /datum/job/cyborg, /datum/job/merchant)
	)

#define HUMAN_ONLY_JOBS /datum/job/captain, /datum/job/hop, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos, /datum/job/representative, /datum/job/sea, /datum/job/pathfinder, /datum/job/rd
	species_to_job_blacklist = list(
		/datum/species/unathi  = list(HUMAN_ONLY_JOBS, /datum/job/liaison, /datum/job/warden), //Other jobs unavailable via branch restrictions,
		/datum/species/unathi/yeosa = list(HUMAN_ONLY_JOBS, /datum/job/liaison, /datum/job/warden),
		/datum/species/skrell  = list(HUMAN_ONLY_JOBS),
		/datum/species/machine = list(HUMAN_ONLY_JOBS, /datum/job/liaison, /datum/job/psychiatrist),
		/datum/species/diona   = list(HUMAN_ONLY_JOBS, /datum/job/officer, /datum/job/liaison, /datum/job/warden, /datum/job/doctor, /datum/job/medical_trainee),	//Other jobs unavailable via branch restrictions,
	)
#undef HUMAN_ONLY_JOBS

	allowed_jobs = list(/datum/job/captain, /datum/job/hop, /datum/job/rd, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos,
						/datum/job/liaison, /datum/job/representative, /datum/job/sea,
						/datum/job/bridgeofficer, /datum/job/pathfinder, /datum/job/nt_pilot, /datum/job/explorer,
						/datum/job/senior_engineer, /datum/job/engineer, /datum/job/roboticist, /datum/job/engineer_trainee,
						/datum/job/officer, /datum/job/warden, /datum/job/detective,
						/datum/job/senior_doctor, /datum/job/doctor, /datum/job/junior_doctor, /datum/job/chemist, /datum/job/medical_trainee,
						/datum/job/psychiatrist, /datum/job/chaplain,
						/datum/job/qm, /datum/job/cargo_tech, /datum/job/mining,
						/datum/job/janitor, /datum/job/chef, /datum/job/bartender,
						/datum/job/senior_scientist, /datum/job/scientist, /datum/job/scientist_assistant,
						/datum/job/cyborg,
						/datum/job/crew, /datum/job/assistant,
						/datum/job/merchant
						)

	access_modify_region = list(
		ACCESS_REGION_SECURITY = list(access_change_ids),
		ACCESS_REGION_MEDBAY = list(access_change_ids),
		ACCESS_REGION_RESEARCH = list(access_change_ids),
		ACCESS_REGION_ENGINEERING = list(access_change_ids),
		ACCESS_REGION_COMMAND = list(access_change_ids),
		ACCESS_REGION_GENERAL = list(access_change_ids),
		ACCESS_REGION_SUPPLY = list(access_change_ids),
		ACCESS_REGION_SERVICE = list(access_change_ids)
	)

/datum/map/torch/setup_job_lists()
	for(var/job_type in allowed_jobs)
		var/datum/job/job = SSjobs.get_by_path(job_type)
		// Most species are restricted from SCG security and command roles
		if(job && (job.department_flag & COM) && job.allowed_branches.len && !(/datum/mil_branch/civilian in job.allowed_branches))
			for(var/species_name in list(SPECIES_IPC, SPECIES_SKRELL, SPECIES_UNATHI))
				var/datum/species/S = all_species[species_name]
				var/species_blacklist = species_to_job_blacklist[S.type]
				if(!species_blacklist)
					species_blacklist = list()
					species_to_job_blacklist[S.type] = species_blacklist
				species_blacklist |= job.type

// Some jobs for nabber grades defined here due to map-specific job datums.
/decl/cultural_info/culture/nabber/New()
	LAZYADD(valid_jobs, /datum/job/scientist_assistant)
	..()

/decl/cultural_info/culture/nabber/b/New()
	LAZYADD(valid_jobs, /datum/job/cargo_tech)
	..()

/decl/cultural_info/culture/nabber/a/New()
	LAZYADD(valid_jobs, /datum/job/engineer)
	..()

/decl/cultural_info/culture/nabber/a/plus/New()
	LAZYADD(valid_jobs, /datum/job/doctor)
	..()

/datum/job
	allowed_branches = list(
		/datum/mil_branch/civilian
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
	)
	required_language = LANGUAGE_HUMAN_EURO

/datum/map/torch
	default_assistant_title = "Passenger"
