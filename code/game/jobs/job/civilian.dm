/datum/job/ds13bartender
	title = "Bartender"
	department_flag = CIV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#2f2f7f"
	ideal_character_age = 21

	access = list(access_service)
	outfit_type = /decl/hierarchy/outfit/job/ds13bartender

/datum/job/ds13linecook
	title = "Line Cook"
	department_flag = CIV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#2f2f7f"
	ideal_character_age = 21

	access = list(access_service)
	outfit_type = /decl/hierarchy/outfit/job/ds13linecook

/datum/job/ds13dom
	title = "Director of Mining"
	head_position = 1
	department = "Supply"
	department_flag = SUP
	total_positions = 1
	spawn_positions = 1
	supervisors = "the CEC"
	selection_color = "#515151"
	minimal_player_age = 3
	ideal_character_age = 55

	access = list(access_bridge, access_mining, access_cargo)
	outfit_type = /decl/hierarchy/outfit/job/cargo/ds13dom

/datum/job/ds13supplyofficer
	title = "Supply Officer"
	department = "Supply"
	department_flag = SUP
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#515151"
	minimal_player_age = 3
	ideal_character_age = 40

	access = list(access_bridge, access_cargo)
	outfit_type = /decl/hierarchy/outfit/job/cargo/ds13supplyofficer

/datum/job/ds13cargojockey
	title = "Cargo Transport Specialist"
	department = "Supply"
	department_flag = SUP
	total_positions = 4
	spawn_positions = 4
	supervisors = "the supply officer"
	selection_color = "#515151"

	access = list(access_cargo)
	outfit_type = /decl/hierarchy/outfit/job/cargo/ds13cargojockey

/datum/job/ds13gravityman
	title = "Gravitational Tether Operator" //called them this rather than 'planet crackers'.
	department = "Supply"
	department_flag = SUP
	total_positions = 4
	spawn_positions = 4
	supervisors = "the mining foreman and the captain"
	selection_color = "#515151"

	access = list(access_mining)
	outfit_type = /decl/hierarchy/outfit/job/cargo/ds13gravityman

/datum/job/ds13miningforeman
	title = "Mining Foreman"
	department = "Supply"
	department_flag = SUP
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#515151"

	access = list(access_bridge, access_mining)
	outfit_type = /decl/hierarchy/outfit/job/cargo/ds13miningforeman

/datum/job/ds13necromorphbait
	title = "Aegis VII Colonist" //The idea here is to expand on the colony in some ways, I spoke to Westhybrid about this sort of thing. For now, placeholder, but if colony is decided to be expanded upon and to have more of an impact on the round depending on how it goes, this role is pretty important.
	department = "Supply"
	department_flag = SUP
	total_positions = 20
	spawn_positions = 20
	supervisors = "the CEC"
	selection_color = "#515151"

	access = list()
	outfit_type = /decl/hierarchy/outfit/job/cargo/ds13necromorphbait


////////////////////////////////////////////////////////////////////////////////
////			DEFAULT ROLES BELOW HERE.									////
////			PLACEHOLDERS FOR GAMEMODES TO PREVENT ERRORS, ETC.			////
////////////////////////////////////////////////////////////////////////////////


//Food
/datum/job/bartender
	title = "Bartender"
	department = "Service"
	department_flag = SRV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#515151"
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/service/bartender

/datum/job/chef
	title = "Chef"
	department = "Service"
	department_flag = SRV
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	selection_color = "#515151"
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/service/chef

/datum/job/hydro
	title = "Gardener"
	department = "Service"
	department_flag = SRV
	total_positions = 2
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#515151"
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/service/gardener

//Cargo
/datum/job/qm
	title = "Quartermaster"
	department = "Supply"
	department_flag = SUP
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#515151"
	access = list()
	minimal_access = list()
	minimal_player_age = 3
	ideal_character_age = 40
	outfit_type = /decl/hierarchy/outfit/job/cargo/qm

/datum/job/cargo_tech
	title = "Cargo Technician"
	department = "Supply"
	department_flag = SUP
	total_positions = 2
	spawn_positions = 2
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#515151"
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/cargo/cargo_tech

/datum/job/mining
	title = "Shaft Miner"
	department = "Supply"
	department_flag = SUP
	total_positions = 3
	spawn_positions = 3
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#515151"
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/cargo/mining

/datum/job/janitor
	title = "Janitor"
	department = "Service"
	department_flag = SRV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#515151"
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/service/janitor

//More or less assistants
/datum/job/librarian
	title = "Librarian"
	department = "Civilian"
	department_flag = CIV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#515151"
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/librarian

/datum/job/lawyer
	title = "Internal Affairs Agent"
	department = "Support"
	department_flag = SPT
	total_positions = 2
	spawn_positions = 2
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#515151"
	access = list()
	minimal_access = list()
	minimal_player_age = 10
	outfit_type = /decl/hierarchy/outfit/job/internal_affairs_agent

/datum/job/lawyer/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(H)
