/datum/map/torch
	species_to_job_whitelist = list(
		/datum/species/nabber = list(/datum/job/ai, /datum/job/cyborg, /datum/job/janitor, /datum/job/scientist_assistant, /datum/job/chemist,
									 /datum/job/roboticist, /datum/job/cargo_tech, /datum/job/chef, /datum/job/engineer, /datum/job/doctor, /datum/job/bartender),
		/datum/species/vox/ = list(/datum/job/ai, /datum/job/cyborg, /datum/job/merchant),
		/datum/species/vox/armalis = list(/datum/job/ai, /datum/job/cyborg, /datum/job/merchant),
		/datum/species/human/mule = list(/datum/job/ai, /datum/job/cyborg, /datum/job/merchant)
	)


#define HUMAN_ONLY_JOBS /datum/job/captain, /datum/job/hop, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos, /datum/job/representative, /datum/job/sea, /datum/job/pathfinder, /datum/job/rd
// ####### Port from Vesta
	species_to_job_blacklist = list(
		/datum/species/adherent = list(/datum/job/psiadvisor, /datum/job/liaison, /datum/job/bodyguard, /datum/job/representative, /datum/job/detective),
		/datum/species/machine = list(/datum/job/psiadvisor),
		/datum/species/shell = list(/datum/job/psiadvisor),
		/datum/species/diona   = list(/datum/job/captain, /datum/job/hop, /datum/job/hos, /datum/job/officer, /datum/job/warden, /datum/job/seccadet, /datum/job/sea, /datum/job/bodyguard, /datum/job/representative, /datum/job/squad_lead, /datum/job/combat_tech, /datum/job/grunt)
	)
#undef HUMAN_ONLY_JOBS

// ####### Port from Vesta
	allowed_jobs = list(/datum/job/captain, /datum/job/hop, /datum/job/rd, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos,
						/datum/job/liaison, /datum/job/bodyguard, /datum/job/representative, /datum/job/sea, /datum/job/sea/marine, /datum/job/psiadvisor,
						/datum/job/bridgeofficer, /datum/job/pathfinder, /datum/job/nt_pilot, /datum/job/explorer,
						/datum/job/senior_engineer, /datum/job/engineer, /datum/job/engineer_trainee,
						/datum/job/officer, /datum/job/warden, /datum/job/detective, /datum/job/seccadet,
						/datum/job/squad_lead, /datum/job/combat_tech, /datum/job/grunt,
						/datum/job/senior_doctor, /datum/job/biomech, /datum/job/doctor, /datum/job/chemist, /datum/job/medical_trainee,
						/datum/job/psychiatrist, /datum/job/chaplain,
						/datum/job/qm, /datum/job/cargo_tech, /datum/job/mining,
						/datum/job/janitor, /datum/job/chef, /datum/job/bartender,
						/datum/job/senior_scientist, /datum/job/scientist, /datum/job/roboticist, /datum/job/scientist_assistant,
						/datum/job/ai, /datum/job/cyborg,
						/datum/job/crew, /datum/job/assistant,
						/datum/job/merchant, /datum/job/symbiote
						)

	access_modify_region = list(
		ACCESS_REGION_SECURITY = list(access_change_ids),
		ACCESS_REGION_MEDBAY = list(access_change_ids),
		ACCESS_REGION_RESEARCH = list(access_change_ids),
		ACCESS_REGION_ENGINEERING = list(access_change_ids),
		ACCESS_REGION_COMMAND = list(access_change_ids),
		ACCESS_REGION_GENERAL = list(access_change_ids),
		ACCESS_REGION_SUPPLY = list(access_change_ids),
		ACCESS_REGION_NT = list(access_change_ids)
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

/datum/job/sea/marine		//We may want to move this out @r4iser
	title = "SMC Attache"
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/command/sea/marineattache
	minimum_character_age = list(SPECIES_HUMAN = 21,SPECIES_UNATHI = 21,SPECIES_SERGAL = 21, SPECIES_SKRELL = 21, SPECIES_PROMETHEAN = 21, SPECIES_YEOSA = 21, SPECIES_VASS = 21, SPECIES_TAJ = 21, SPECIES_CUSTOM = 21, SPECIES_AKULA = 21)
	allowed_branches = list(
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/marine_corps/e8_alt,
		/datum/mil_rank/marine_corps/e9,
		/datum/mil_rank/marine_corps/e9_alt,
		/datum/mil_rank/marine_corps/o1,
		/datum/mil_rank/marine_corps/o2,
		/datum/mil_rank/marine_corps/o3
	)
