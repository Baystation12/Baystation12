/datum/job/ds13seniormedofficer
	title = "Senior Medical Officer"
	head_position = 1
	department = "Medical"
	department_flag = MED|COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#026865"
	req_admin_notify = 1
	minimal_player_age = 7
	ideal_character_age = 50

	access = list(access_heads, access_medical, access_morgue, access_surgery, 
					access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/medical/ds13seniormedofficer

/datum/job/ds13meddoctor
	title = "Medical Doctor"
	department = "Medical"
	department_flag = MED
	minimal_player_age = 5
	total_positions = 6
	spawn_positions = 6
	supervisors = "the senior medical officer"
	selection_color = "#013d3b"

	access = list(access_medical, access_morgue)
	outfit_type = /decl/hierarchy/outfit/job/medical/ds13meddoctor

/datum/job/ds13medsurgeon
	title = "Surgeon"
	department = "Medical"
	department_flag = MED
	minimal_player_age = 7
	total_positions = 2
	spawn_positions = 2
	supervisors = "the senior medical officer"
	selection_color = "#013d3b"

	access = list(access_medical, access_morgue, access_surgery)
	outfit_type = /decl/hierarchy/outfit/job/medical/ds13medsurgeon


////////////////////////////////////////////////////////////////////////////////
////			DEFAULT ROLES BELOW HERE.									////
////			PLACEHOLDERS FOR GAMEMODES TO PREVENT ERRORS, ETC.			////
////////////////////////////////////////////////////////////////////////////////





/datum/job/cmo
	title = "Chief Medical Officer"
	head_position = 1
	department = "Medical"
	department_flag = MED|COM

	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#026865"
	req_admin_notify = 1
	
	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_maint_tunnels, access_external_airlocks)

	minimal_player_age = 14
	ideal_character_age = 50
	outfit_type = /decl/hierarchy/outfit/job/medical/cmo

/datum/job/doctor
	title = "Medical Doctor"
	department = "Medical"
	department_flag = MED

	minimal_player_age = 3
	total_positions = 5
	spawn_positions = 3
	supervisors = "the chief medical officer"
	selection_color = "#013d3b"

	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_virology)

	outfit_type = /decl/hierarchy/outfit/job/medical/doctor

//Chemist is a medical job damnit	//YEAH FUCK YOU SCIENCE	-Pete	//Guys, behave -Erro
/datum/job/chemist
	title = "Chemist"
	department = "Medical"
	department_flag = MED

	minimal_player_age = 7
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#013d3b"

	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	minimal_access = list(access_medical, access_medical_equip, access_chemistry)

	outfit_type = /decl/hierarchy/outfit/job/medical/chemist

/datum/job/geneticist
	title = "Geneticist"
	department = "Medical"
	department_flag = MED

	total_positions = 0
	spawn_positions = 0
	minimal_player_age = 7
	supervisors = "the chief medical officer and research director"
	selection_color = "#013d3b"

	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_research)
	minimal_access = list(access_medical, access_morgue, access_genetics, access_research)
	outfit_type = /decl/hierarchy/outfit/job/medical/geneticist

/datum/job/psychiatrist
	title = "Psychiatrist"
	department = "Medical"
	department_flag = MED

	total_positions = 1
	spawn_positions = 1

	minimal_player_age = 3
	supervisors = "the chief medical officer"
	selection_color = "#013d3b"
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_psychiatrist)
	minimal_access = list(access_medical, access_medical_equip, access_psychiatrist)

	outfit_type = /decl/hierarchy/outfit/job/medical/psychiatrist

/datum/job/Paramedic
	title = "Paramedic"
	department = "Medical"
	department_flag = MED

	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#013d3b"

	minimal_player_age = 7
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_eva, access_maint_tunnels, access_external_airlocks, access_psychiatrist)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_eva, access_maint_tunnels, access_external_airlocks)
	
	outfit_type = /decl/hierarchy/outfit/job/medical/paramedic
