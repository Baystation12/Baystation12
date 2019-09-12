/datum/job/ds13captain
	title = "Captain"
	department = "Command"
	head_position = 1
	department_flag = COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "the concordance extraction corporation and your own moral compass"
	selection_color = "#1d1d4f"
	req_admin_notify = 1
	minimal_player_age = 14
	ideal_character_age = 60

	access = list(access_bridge, access_security, access_maint_tunnels, access_service,
				access_cargo, access_mining, access_engineering,
				access_external_airlocks, access_medical, access_research,
				access_armory)
	outfit_type = /decl/hierarchy/outfit/job/ds13captain

/datum/job/ds13flieutenant
	title = "First Lieutenant"
	department_flag = COM|CIV
	head_position = 1
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#2f2f7f"
	req_admin_notify = 1
	minimal_player_age = 7
	ideal_character_age = 35

	access = list(access_bridge, access_security, access_armory, access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/ds13flieutenant

/datum/job/ds13bensign
	title = "Bridge Ensign"
	department_flag = CIV
	total_positions = 4
	spawn_positions = 4
	supervisors = "the captain and the first lieutenant"
	selection_color = "#2f2f7f"
	minimal_player_age = 2
	ideal_character_age = 22

	access = list(access_bridge, access_security, access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/ds13bensign




////////////////////////////////////////////////////////////////////////////////
////			DEFAULT ROLES BELOW HERE.									////
////			PLACEHOLDERS FOR GAMEMODES TO PREVENT ERRORS, ETC.			////
////////////////////////////////////////////////////////////////////////////////






var/datum/announcement/minor/captain_announcement = new(do_newscast = 1)

/datum/job/captain
	title = "Captain"
	department = "Command"
	head_position = 1
	department_flag = COM

	total_positions = 1
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#1d1d4f"
	req_admin_notify = 1
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	minimal_player_age = 14

	ideal_character_age = 70 // Old geezer captains ftw
	outfit_type = /decl/hierarchy/outfit/job/captain

/datum/job/captain/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(src)

/datum/job/captain/get_access()
	return get_all_station_access()

/datum/job/hop
	title = "Head of Personnel"
	head_position = 1
	department_flag = COM|CIV

	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#2f2f7f"
	req_admin_notify = 1
	minimal_player_age = 14
	ideal_character_age = 50

	access = list()

	outfit_type = /decl/hierarchy/outfit/job/hop
