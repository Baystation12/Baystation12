/datum/map/torch
	allowed_jobs = list(/datum/job/captain, /datum/job/hop, /datum/job/chef, /datum/job/qm, /datum/job/cargo_tech,
						/datum/job/janitor, /datum/job/lawyer,
						/datum/job/chief_engineer, /datum/job/engineer,
						/datum/job/ai, /datum/job/cyborg,
						/datum/job/hos, /datum/job/warden, /datum/job/detective, /datum/job/officer,
						/datum/job/cmo, /datum/job/doctor, /datum/job/chemist, /datum/job/chaplain,
						/datum/job/rd, /datum/job/scientist, /datum/job/mining, /datum/job/contractor
						)

/datum/job/captain
	title = "Commanding Officer"
	alt_titles = list("Captain (Fleet)", "Commander", "Colonel", "Lieutenant Colonel")

/datum/job/hop
	title = "Executive Officer"
	alt_titles = list("Lieutenant Commander", "Major")

/datum/job/rd
	supervisors = "NanoTrasen"
	access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue, access_mining, access_mining_station,
			            access_tox_storage, access_teleporter, access_sec_doors,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue, access_mining, access_mining_station,
			            access_tox_storage, access_teleporter, access_sec_doors,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network)

/datum/job/lawyer
	title = "SolGov Representative"

/datum/job/warden
	title = "Brig Officer"

/datum/job/detective
	title = "Forensic Technician"
	alt_titles = list()

/datum/job/officer
	title = "Master at Arms"
	total_positions = 2
	spawn_positions = 2

/datum/job/qm
	title = "Deck Officer"

/datum/job/cargo_tech
	title = "Deck Technician"

/datum/job/chemist
	total_positions = 1
	spawn_positions = 1

/datum/job/chaplain
	department = "Medical"
	department_flag = MED
	supervisors = "the chief medical officer"
	selection_color = "#013d3b"
	alt_titles = list("Psychologist", "Psychiatrist", "Counselor")
	access = list(access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels, access_medical, access_medical_equip, access_surgery, access_chemistry, access_virology, access_genetics, access_psychiatrist)
	minimal_access = list(access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels, access_medical, access_medical_equip, access_surgery, access_chemistry, access_virology, access_genetics, access_psychiatrist)

/datum/job/scientist
	total_positions = 4
	spawn_positions = 4
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch)

/datum/job/mining
	title = "Prospector"
	department = "Science"
	department_flag = SCI
	selection_color = "#633d63"
	supervisors = "the research director"
	alt_titles = list("Scavanger", "Shaft Miner")
	total_positions = 4
	spawn_positions = 4

/datum/job/contractor
	title = "Security Contractor"
	department = "Science"
	department_flag = SCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the research director"
	selection_color = "#633d63"
	economic_modifier = 4
	minimal_player_age = 5
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks,
	              access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks,
	              access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch)
	outfit_type = /decl/hierarchy/outfit/job/security/officer/contractor

/decl/hierarchy/outfit/job/security/officer/contractor
	name = OUTFIT_JOB_NAME("Security contractor")
	l_ear = /obj/item/device/radio/headset/headset_sci
	glasses = null
	gloves = null
	id_type = /obj/item/weapon/card/id/security/contractor

/obj/item/weapon/card/id/security/contractor
	job_access_type = /datum/job/contractor
