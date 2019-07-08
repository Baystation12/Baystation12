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
	
	access = list(access_heads, access_security, access_maint_tunnels, access_bar, access_kitchen,
				access_cargo, access_mining, access_mining_station, access_engine, access_emergency_storage,
				access_external_airlocks, access_medical, access_morgue, access_surgery, access_research,
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
	
	access = list(access_heads, access_security, access_maint_tunnels)
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
	
	access = list(access_heads, access_security, access_maint_tunnels)
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

	access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway)

	outfit_type = /decl/hierarchy/outfit/job/hop
