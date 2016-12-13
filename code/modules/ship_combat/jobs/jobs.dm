/datum/job/space_battle/is_position_available()
	var/less_populated_team
	var/less_populated_team_count = 0
	var/passed = 0
	for(var/obj/missile_start/S in world)
		if(S.active && S.team == team)
			passed = 1
	if(!passed)
		testing("[src]: Failed passed!")
		return 0
	for(var/i=1 to job_master.teams.len)
		if(job_master.teams[i] in ticker.mode.allowed_factions)
			var/team_name = job_master.teams[i]
			var/team_count = job_master.teams[team_name]
			if(isnull(team_count)) team_count = 0
			if(!less_populated_team || team_count < less_populated_team_count)
				less_populated_team = team_name
				less_populated_team_count = team_count
	for(var/i=1 to job_master.teams.len)
		if(job_master.teams[i] in ticker.mode.allowed_factions)
			var/team_name = job_master.teams[i]
			var/team_count = job_master.teams[team_name]
			if(team_name == less_populated_team || team_count == less_populated_team_count)
				return ..()
	testing("[src]: returning 0")
	return 0

/datum/job/space_battle/player_old_enough(var/client/C)
	var/true = ..()
	if(!true)
		testing("[src]: Player not old enough! ([C])")
	return true

/datum/job/space_battle/job.is_branch_allowed(var/client/C)
	var/true = ..()
	if(!true)
		testing("[src]: Player character branch not allowed! ([C])")
	return true
//access 1-10 = Team One, 11 - 20 = Team Two ... 31-40 = Team Four
//1 = Common(Halls)
//2 = Firing Tubes
//3 = Command
//4 = Navigation
//5 = Engineering
//6 = Security
//7 = Maintenance
//8 = Firing Control
//9 = Research
//10 = Medical
/datum/job/space_battle/var/team = 0
/datum/job/space_battle/equip(var/mob/living/carbon/human/H, var/alt_title)
	H.mind.team = team
	return ..(H, alt_title)

/datum/job/space_battle/team_one
	title = "Team One Sailor"
	department = "NanoTrasen"
	department_flag = null
	faction = "Team One"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the captain"
	selection_color = "#006666"
	economic_modifier = 1
	access = list(1)
	minimal_access = list(1)
	alt_titles = list("Team One Swab")
	outfit_type = /decl/hierarchy/outfit/job/space_battle/sailor
	team = 1

/datum/job/space_battle/team_one/engineer
	title = "Team One Engineer"
	access = list(1,2,5,7)
	minimal_access = list(1,5)
	alt_titles = list("Team One Boatswain")
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/space_battle/engineer

/datum/job/space_battle/team_one/pilot
	title = "Team One Pilot"
	access = list(1,4)
	minimal_access = list(1,4)
	alt_titles = list("Team One Navigator")
	total_positions = 2
	spawn_positions = 1
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/space_battle/pilot

/datum/job/space_battle/team_one/security
	title = "Team One Security"
	access = list(1,6)
	minimal_access = list(1,6)
	alt_titles = list("Team One Quartermaster")
	total_positions = 2
	spawn_positions = 2
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/space_battle/marine

/datum/job/space_battle/team_one/courier
	title = "Team One Courier"
	access = list(1,2,7)
	minimal_access = list(1,2)
	alt_titles = list("Team One Powdermonkey")

/datum/job/space_battle/team_one/officer
	title = "Team One Officer"
	access = list(1,8)
	minimal_access = list(1,8)
	alt_titles = list("Team One Master Gunner")
	total_positions = -1
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/space_battle/officer

/datum/job/space_battle/team_one/medic
	title = "Team One Medic"
	access = list(1,10)
	minimal_access = list(1,10)
	alt_titles = list("Team One Leech")
	total_positions = 2
	spawn_positions = 1
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/space_battle/medic

/datum/job/space_battle/team_one/commander
	title = "Team One Commander"
	access = list(1,2,3,4,5,6,7,8,9,10)
	minimal_access = list(1,3,4)
	alt_titles = list("Team One Captain")
	selection_color = "#009999"
	total_positions = 1
	spawn_positions = 1
	minimal_player_age = 14
	outfit_type = /decl/hierarchy/outfit/job/space_battle/captain
	head_position = 1

/datum/job/space_battle/team_two
	title = "Team Two Sailor"
	department = "NanoTrasen"
	department_flag = null
	faction = "Team Two"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the captain"
	selection_color = "#006600"
	economic_modifier = 1
	access = list(11)
	minimal_access = list(1)
	alt_titles = list("Team Two Swab")
	outfit_type = /decl/hierarchy/outfit/job/space_battle/sailor
	team = 2

/datum/job/space_battle/team_two/engineer
	title = "Team Two Engineer"
	access = list(11,12,15,17)
	minimal_access = list(11,15)
	alt_titles = list("Team Two Boatswain")
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/space_battle/engineer

/datum/job/space_battle/team_two/pilot
	title = "Team Two Pilot"
	access = list(11,14)
	minimal_access = list(11,14)
	alt_titles = list("Team Two Navigator")
	total_positions = 2
	spawn_positions = 1
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/space_battle/pilot

/datum/job/space_battle/team_two/security
	title = "Team Two Security"
	access = list(11,16)
	minimal_access = list(11,16)
	alt_titles = list("Team Two Quartermaster")
	total_positions = 2
	spawn_positions = 2
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/space_battle/marine

/datum/job/space_battle/team_two/courier
	title = "Team Two Courier"
	access = list(11,12,17)
	minimal_access = list(11,12)
	alt_titles = list("Team Two Powdermonkey")

/datum/job/space_battle/team_two/officer
	title = "Team Two Officer"
	access = list(11,18)
	minimal_access = list(11,18)
	alt_titles = list("Team Two Master Gunner")
	total_positions = -1
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/space_battle/officer

/datum/job/space_battle/team_two/medic
	title = "Team Two Medic"
	access = list(11,20)
	minimal_access = list(11,20)
	alt_titles = list("Team Two Leech")
	total_positions = 2
	spawn_positions = 1
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/space_battle/medic

/datum/job/space_battle/team_two/commander
	title = "Team Two Commander"
	access = list(11,12,13,14,15,16,17,18,19,20)
	minimal_access = list(11,13,14)
	alt_titles = list("Team Two Captain")
	selection_color = "#00b300"
	total_positions = 1
	spawn_positions = 1
	minimal_player_age = 14
	outfit_type = /decl/hierarchy/outfit/job/space_battle/captain
	head_position = 1

/datum/job/space_battle/team_three
	title = "Team Three Sailor"
	department = "NanoTrasen"
	department_flag = null
	faction = "Team Three"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the captain"
	selection_color = "#800000"
	economic_modifier = 1
	access = list(21)
	minimal_access = list(21)
	alt_titles = list("Team Three Swab")
	outfit_type = /decl/hierarchy/outfit/job/space_battle/sailor
	team = 3

/datum/job/space_battle/team_three/engineer
	title = "Team Three Engineer"
	access = list(21,22,25,27)
	minimal_access = list(21,25)
	alt_titles = list("Team Three Boatswain")
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/space_battle/engineer

/datum/job/space_battle/team_three/pilot
	title = "Team Three Pilot"
	access = list(21,24)
	minimal_access = list(21,24)
	alt_titles = list("Team Three Navigator")
	total_positions = 2
	spawn_positions = 1
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/space_battle/pilot

/datum/job/space_battle/team_three/security
	title = "Team Three Security"
	access = list(21,26)
	minimal_access = list(21,26)
	alt_titles = list("Team Three Quartermaster")
	total_positions = 2
	spawn_positions = 2
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/space_battle/marine

/datum/job/space_battle/team_three/courier
	title = "Team Three Courier"
	access = list(21,22,27)
	minimal_access = list(21,22)
	alt_titles = list("Team Three Powdermonkey")

/datum/job/space_battle/team_three/officer
	title = "Team Three Officer"
	access = list(21,28)
	minimal_access = list(21,28)
	alt_titles = list("Team Three Master Gunner")
	total_positions = -1
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/space_battle/officer

/datum/job/space_battle/team_three/medic
	title = "Team Three Medic"
	access = list(21,30)
	minimal_access = list(21,30)
	alt_titles = list("Team Three Leech")
	total_positions = 2
	spawn_positions = 1
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/space_battle/medic

/datum/job/space_battle/team_three/commander
	title = "Team Three Commander"
	access = list(21,22,23,24,25,26,27,28,29,20)
	minimal_access = list(21,23,24)
	alt_titles = list("Team Three Captain")
	selection_color = "#cc0000"
	total_positions = 1
	spawn_positions = 1
	minimal_player_age = 14
	outfit_type = /decl/hierarchy/outfit/job/space_battle/captain
	head_position = 1

/datum/job/space_battle/team_four
	title = "Team Four Sailor"
	department = "NanoTrasen"
	department_flag = null
	faction = "Team Four"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the captain"
	selection_color = "#800080"
	economic_modifier = 1
	access = list(31)
	minimal_access = list(31)
	alt_titles = list("Team Four Swab")
	outfit_type = /decl/hierarchy/outfit/job/space_battle/sailor
	team = 4

/datum/job/space_battle/team_four/engineer
	title = "Team Four Engineer"
	access = list(31,32,35,37)
	minimal_access = list(31,35)
	alt_titles = list("Team Four Boatswain")
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/space_battle/engineer

/datum/job/space_battle/team_four/pilot
	title = "Team Four Pilot"
	access = list(31,34)
	minimal_access = list(31,34)
	alt_titles = list("Team Four Navigator")
	total_positions = 2
	spawn_positions = 1
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/space_battle/pilot

/datum/job/space_battle/team_four/security
	title = "Team Four Security"
	access = list(31,36)
	minimal_access = list(31,36)
	alt_titles = list("Team Four Quartermaster")
	total_positions = 2
	spawn_positions = 2
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/space_battle/marine

/datum/job/space_battle/team_four/courier
	title = "Team Four Courier"
	access = list(31,32,37)
	minimal_access = list(31,32)
	alt_titles = list("Team Four Powdermonkey")

/datum/job/space_battle/team_four/officer
	title = "Team Four Officer"
	access = list(31,38)
	minimal_access = list(31,38)
	alt_titles = list("Team Four Master Gunner")
	total_positions = -1
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/space_battle/officer

/datum/job/space_battle/team_four/medic
	title = "Team Four Medic"
	access = list(31,310)
	minimal_access = list(31,40)
	alt_titles = list("Team Four Leech")
	total_positions = 2
	spawn_positions = 1
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/space_battle/medic

/datum/job/space_battle/team_four/commander
	title = "Team Four Commander"
	access = list(31,32,33,34,35,36,37,38,39,40)
	minimal_access = list(1,3,4)
	alt_titles = list("Team Four Captain")
	selection_color = " #cc00cc"
	total_positions = 1
	spawn_positions = 1
	minimal_player_age = 14
	outfit_type = /decl/hierarchy/outfit/job/space_battle/captain
	head_position = 1