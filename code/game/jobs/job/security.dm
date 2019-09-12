/datum/job/ds13chiefsecurityofficer
	title = "Chief Security Officer"
	head_position = 1
	department = "Security"
	department_flag = SEC|COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#8e2929"
	req_admin_notify = 1

	access = list(access_bridge, access_armory, access_security, access_maint_tunnels,
					access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/security/ds13chiefsecurityofficer

/datum/job/ds13seniorsecurityofficer
	title = "Senior Security Officer"
	department = "Security"
	department_flag = SEC
	total_positions = 1
	spawn_positions = 1
	supervisors = "the chief security officer"
	selection_color = "#601c1c"

	access = list(access_armory, access_security, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/security/ds13seniorsecurityofficer

/datum/job/ds13securityofficer
	title = "Security Officer"
	department = "Security"
	department_flag = SEC
	total_positions = 4
	spawn_positions = 4
	supervisors = "the chief security officer"
	selection_color = "#601c1c"

	access = list(access_security, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/security/ds13securityofficer

/datum/job/ds13psecsecuritychief //security chief for PSEC/colony security.
	title = "PSEC Security Chief"
	department = "Security"
	department_flag = SEC
	total_positions = 1
	spawn_positions = 1
	supervisors = "the CEC"
	selection_color = "#601c1c"

	access = list(access_security, access_mining, access_maint_tunnels) //PSEC HQ on the colony should require both access_security and access_mining_station.
	outfit_type = /decl/hierarchy/outfit/job/security/ds13PSECboss

/datum/job/ds13psecsecurityofficer //security officer that spawns on colony.
	title = "PSEC Security Officer"
	department = "Security"
	department_flag = SEC
	total_positions = 4
	spawn_positions = 4
	supervisors = "the PSEC Security Chief"
	selection_color = "#601c1c"

	access = list(access_security, access_mining, access_maint_tunnels) //PSEC HQ on the colony should require both access_security and access_mining_station.
	outfit_type = /decl/hierarchy/outfit/job/security/ds13PSECofficer


////////////////////////////////////////////////////////////////////////////////
////			DEFAULT ROLES BELOW HERE.									////
////			PLACEHOLDERS FOR GAMEMODES TO PREVENT ERRORS, ETC.			////
////////////////////////////////////////////////////////////////////////////////




/datum/job/hos
	title = "Head of Security"
	head_position = 1
	department = "Security"
	department_flag = SEC|COM

	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#8e2929"
	req_admin_notify = 1

	access = list()
	minimal_access = list()
	minimal_player_age = 14
	outfit_type = /decl/hierarchy/outfit/job/security/hos

/datum/job/hos/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(H)

/datum/job/warden
	title = "Warden"
	department = "Security"
	department_flag = SEC

	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#601c1c"

	access = list()
	minimal_access = list()
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/security/warden

/datum/job/detective
	title = "Detective"
	department = "Security"
	department_flag = SEC

	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of security"
	selection_color = "#601c1c"

	access = list()
	minimal_access = list()
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/security/detective

/datum/job/officer
	title = "Security Officer"
	department = "Security"
	department_flag = SEC

	total_positions = 4
	spawn_positions = 4
	supervisors = "the head of security"
	selection_color = "#601c1c"


	access = list()
	minimal_access = list()
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/security/officer
