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

//Torch Job Loadouts

/decl/hierarchy/outfit/job/security/officer/contractor
	name = OUTFIT_JOB_NAME("Security contractor")
	l_ear = /obj/item/device/radio/headset/headset_sci
	glasses = null
	gloves = null
	id_type = /obj/item/weapon/card/id/torch/research/guard


//Torch ID Cards

/obj/item/weapon/card/id/torch/silver
	name = "identification card"
	desc = "A silver card belonging to heads of staff."
	icon_state = "silver"
	item_state = "silver_id"
	job_access_type = /datum/job/hop

/obj/item/weapon/card/id/torch/gold
	name = "identification card"
	desc = "A golden card belonging to the Commanding Officer."
	icon_state = "gold"
	item_state = "gold_id"
	job_access_type = /datum/job/captain

/obj/item/weapon/card/id/torch/captains_spare
	name = "captain's spare ID"
	desc = "The skipper's spare ID."
	icon_state = "gold"
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"
/obj/item/weapon/card/id/captains_spare/New()
	access = get_all_station_access()
	..()

// SolGov Crew and NT Contractors
/obj/item/weapon/card/id/torch
	name = "identification card"
	desc = "A card issued to SEV Torch crew."
	icon_state = "solgov"
	job_access_type = /datum/job/assistant

/obj/item/weapon/card/id/torch/medical
	desc = "A card issued to SEV Torch medical staff."
	job_access_type = /datum/job/doctor

/obj/item/weapon/card/id/torch/medical/chemist
	job_access_type = /datum/job/chemist

/obj/item/weapon/card/id/torch/medical/virologist
	desc = "A card issued to SEV Torch medical contractors."
	icon_state = "corporate"
	job_access_type = /datum/job/doctor

/obj/item/weapon/card/id/torch/medical/counselor
	job_access_type = /datum/job/psychiatrist

/obj/item/weapon/card/id/torch/medical/contractor
	desc = "A card issued to SEV Torch medical contractors."
	icon_state = "corporate"
	job_access_type = /datum/job/Paramedic

/obj/item/weapon/card/id/torch/silver/medical
	job_access_type = /datum/job/cmo

/obj/item/weapon/card/id/torch/security
	desc = "A card issued to SEV Torch security staff."
	job_access_type = /datum/job/officer

/obj/item/weapon/card/id/torch/security/brigofficer
	job_access_type = /datum/job/warden

/obj/item/weapon/card/id/torch/security/forensic
	job_access_type = /datum/job/detective

/obj/item/weapon/card/id/torch/silver/security
	job_access_type = /datum/job/hos

/obj/item/weapon/card/id/torch/engineering
	desc = "A card issued to SEV Torch engineering staff."
	job_access_type = /datum/job/engineer

/obj/item/weapon/card/id/torch/engineering/atmos
	job_access_type = /datum/job/atmos

/obj/item/weapon/card/id/torch/engineering/roboticist
	desc = "A card issued to SEV Torch engineering contractors."
	icon_state = "corporate"
	job_access_type = /datum/job/roboticist

/obj/item/weapon/card/id/torch/engineering/contractor
	desc = "A card issued to SEV Torch engineering contractors."
	icon_state = "corporate"
	job_access_type = /datum/job/engineer

/obj/item/weapon/card/id/torch/silver/engineering
	name = "identification card"
	job_access_type = /datum/job/chief_engineer

/obj/item/weapon/card/id/torch/supply
	desc = "A card issued to SEV Torch supply staff."
	job_access_type = /datum/job/cargo_tech

/obj/item/weapon/card/id/torch/supply/contractor
	desc = "A card issued to SEV Torch supply contractors."
	icon_state = "corporate"
	job_access_type = /datum/job/cargo_tech

/obj/item/weapon/card/id/torch/supply/deckofficer
	job_access_type = /datum/job/qm

/obj/item/weapon/card/id/torch/support
	desc = "A card issued to SEV Torch support staff."
	job_access_type = /datum/job/assistant

/obj/item/weapon/card/id/torch/support/janitor
	job_access_type = /datum/job/janitor

/obj/item/weapon/card/id/torch/support/chef
	job_access_type = /datum/job/chef

/obj/item/weapon/card/id/torch/support/contractor/bartender
	desc = "A card issued to SEV Torch support contractors."
	icon_state = "corporate"
	job_access_type = /datum/job/bartender

/obj/item/weapon/card/id/torch/representative
	job_access_type = /datum/job/lawyer

//NanoTrasen

/obj/item/weapon/card/id/torch/research
	name = "identification card"
	desc = "A card issued to NanoTrasen employees."
	icon_state = "corporate"
	job_access_type = /datum/job/assistant

/obj/item/weapon/card/id/torch/research/scientist
	name = "identification card"
	job_access_type = /datum/job/scientist

/obj/item/weapon/card/id/torch/research/xenobiologist
	job_access_type = /datum/job/xenobiologist

/obj/item/weapon/card/id/torch/silver/research
	job_access_type = /datum/job/rd

/obj/item/weapon/card/id/torch/research/mining
	job_access_type = /datum/job/mining

/obj/item/weapon/card/id/torch/research/guard
	job_access_type = /datum/job/scientist

/obj/item/weapon/card/id/torch/research/liaison
	job_access_type = /datum/job/lawyer

//Passengers

/obj/item/weapon/card/id/torch/passenger
	name = "identification card"
	desc = "A card issued to passengers."
	icon_state = "id"
	job_access_type = /datum/job/assistant





/obj/item/weapon/card/id/security/contractor
	job_access_type = /datum/job/contractor
