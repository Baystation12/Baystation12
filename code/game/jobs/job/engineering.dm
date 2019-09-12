/datum/job/ds13chiefofengines
	title = "Chief Engineer"
	head_position = 1
	department = "Engineering"
	department_flag = ENG|COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#7f6e2c"
	req_admin_notify = 1
	ideal_character_age = 45
	minimal_player_age = 14

	access = list(access_bridge, access_engineering, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/engineering/ds13chiefofengines

/datum/job/ds13expendableengineer
	title = "Technical Engineer"
	department = "Engineering"
	department_flag = ENG
	total_positions = 4
	spawn_positions = 4
	supervisors = "the chief engineer"
	selection_color = "#5b4d20"
	ideal_character_age = 30
	minimal_player_age = 7

	access = list(access_engineering, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/engineering/ds13expendableengineer


////////////////////////////////////////////////////////////////////////////////
////			DEFAULT ROLES BELOW HERE.									////
////			PLACEHOLDERS FOR GAMEMODES TO PREVENT ERRORS, ETC.			////
////////////////////////////////////////////////////////////////////////////////



/datum/job/chief_engineer
	title = "Chief Engineer"
	head_position = 1
	department = "Engineering"
	department_flag = ENG|COM

	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#7f6e2c"
	req_admin_notify = 1

	ideal_character_age = 50


	access = list()
	minimal_access = list()
	minimal_player_age = 14
	outfit_type = /decl/hierarchy/outfit/job/engineering/chief_engineer

/datum/job/engineer
	title = "Engineer"
	department = "Engineering"
	department_flag = ENG

	total_positions = 8
	spawn_positions = 7
	supervisors = "the chief engineer"
	selection_color = "#5b4d20"
	minimal_player_age = 7
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/engineering/engineer

/datum/job/atmos
	title = "Atmospheric Technician"
	department = "Engineering"
	department_flag = ENG

	total_positions = 0
	spawn_positions = 0
	supervisors = "the chief engineer"
	selection_color = "#5b4d20"

	minimal_player_age = 7
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/engineering/atmos
