
#define RAM_VICTORY 1
#define BOULDER_VICTORY 2

/datum/game_mode/packwar
	name = "Packwar"
	config_tag = "packwar"
	round_description = "Two brute packs fight over the surface of Doisac to determine the strongest."
	extended_round_description = "Two Jiralhanae packs, the Boulder Clan and the Ram Clan, fight to determine who is the stronger. Join your pack as you hunt the enemy chieftain,\
		however there is more than one route to victory..."

	round_autoantag = 0//1
	required_players = 0//2
	antag_tags = list()
	latejoin_antag_tags = list()
	antag_scaling_coeff = 0
	var/datum/mind/boulder_chief_mind
	var/datum/mind/ram_chief_mind
	var/chieftain_slayer_text
	//
	var/list/boulder_clan_captains = list()
	var/list/ram_clan_captains = list()
	//
	var/objective_state = 0		//1 = boulder chieftain death
								//2 = ram chieftain death
	var/mercenary_interval_upper = 15 MINUTES
	var/mercenary_interval_lower = 5 MINUTES
	var/time_next_mercenary_ship = 5 MINUTES

	var/available_champions = 0
	var/available_murmillos = 0
	var/available_defenders = 0
	var/available_snipers = 0
	var/respawn_time = 1.5	//minutes

/datum/game_mode/packwar/announce()
	. = ..()
	to_world("Each clan starts with little weapons and armour. \
		You must mine ore from under the ground to process into metals, \
		grow crops in from soil, and sell what you make to the traders for gekz. \
		A strong clan has many good weapons and armour. You should wait until your clan is strong before battling the other clan. \
		Raid the other clan if you must, but a raid means stealing NOT fighting. \
		Do not hurt the Unggoy if you can as they are valuable slaves to be captured. A desperate clan will force them into battle. \
		A cunning clan will equip them with advanced weapons and armour, and hire Kig-Yar mercenaries to bolster their forces.")

/datum/game_mode/packwar/post_setup()
	. = ..()

	time_next_mercenary_ship = world.time + mercenary_interval_lower

	//grab the two chieftains
	var/datum/job/boulder_chief = job_master.occupations_by_title["Boulder Clan Chieftain"]
	for(var/datum/mind/D in boulder_chief.assigned_players)
		boulder_chief_mind = D
		break
	//
	var/datum/job/ram_chief = job_master.occupations_by_title["Ram Clan Chieftain"]
	for(var/datum/mind/D in ram_chief.assigned_players)
		ram_chief_mind = D
		break

	//grab their captains
	var/datum/job/boulder_captain = job_master.occupations_by_title["Boulder Clan Captain"]
	for(var/datum/mind/D in boulder_captain.assigned_players)
		boulder_clan_captains.Add(D)
		break
	//
	var/datum/job/ram_captain = job_master.occupations_by_title["Ram Clan Captain"]
	for(var/datum/mind/D in ram_captain.assigned_players)
		ram_clan_captains.Add(D)
		break

/datum/game_mode/packwar/handle_mob_death(var/mob/living/carbon/human/M, var/list/args = list())
	ASSERT(M)

	//grab the mind
	var/datum/mind/D = M.mind
	if(!D)
		for(var/datum/mind/check_mind in list(boulder_chief_mind,ram_chief_mind) + ram_clan_captains + boulder_clan_captains)
			if(check_mind.name == M.real_name)
				D = check_mind
				if(M.last_attacker_)
					chieftain_slayer_text = " by [M.last_attacker_.name] the [M.last_attacker_.assigned_role]"

	if(D == boulder_chief_mind)
		objective_state = RAM_VICTORY
	if(D == ram_chief_mind)
		objective_state = BOULDER_VICTORY

	return ..()

/datum/game_mode/packwar/check_finished()

	. = objective_state
	if(!.)
		.  = ..()

/datum/game_mode/packwar/declare_completion()

	var/text = ""
	var/list/winning_captains
	var/datum/mind/dead_chieftain
	var/datum/mind/winning_chieftain
	var/winning_clan_name
	var/losing_clan_name
	switch(objective_state)
		if(RAM_VICTORY)
			winning_clan_name = "Ram"
			losing_clan_name = "Boulder"
			dead_chieftain = boulder_chief_mind
			winning_chieftain = ram_chief_mind
			winning_captains = ram_clan_captains
		if(BOULDER_VICTORY)
			winning_clan_name = "Boulder"
			losing_clan_name = "Ram"
			dead_chieftain = ram_chief_mind
			winning_chieftain = boulder_chief_mind
			winning_captains = boulder_clan_captains

	text += "<span class='boldannounce'>Chieftain [dead_chieftain.name] of the [losing_clan_name] Clan has been slain[chieftain_slayer_text]!</span><br>"
	text += "<span class='passive'>The [winning_clan_name] Clan Alphas were:</span><br>"
	var/none = 1
	if(winning_chieftain)
		text += "	<span class='passive'>Chieftain [winning_chieftain.name]</span><br>"
		none = 0
	for(var/datum/mind/captain_mind in winning_captains)
		text += "	<span class='info'>Captain [captain_mind.name]</span><br>"
		none = 0
	if(none)
		text += "	<span class='info'>(none)</span><br>"
	text += "<h1>[winning_clan_name] Clan Victory</h1>"
	to_world(text)

	return 0

/datum/game_mode/packwar/AnnounceLateArrival(var/mob/living/carbon/human/character, var/datum/job/job, var/join_message)
	var/radio_channel
	switch(job.department)
		if("Boulder Clan")
			radio_channel = "BoulderNet"
		if("Ram Clan")
			radio_channel = "RamNet"
	if(radio_channel)
		GLOB.global_announcer.autosay(\
			"[character.name], [job] has returned from wandering in the wilderness to fight for the clan.", \
			"Clan Barracks", radio_channel, "Sangheili")

/datum/game_mode/packwar/get_respawn_time()
	return respawn_time
