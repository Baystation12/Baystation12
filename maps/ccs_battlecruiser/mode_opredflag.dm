
/datum/game_mode/opredflag
	name = "Operation: Red Flag"
	config_tag = "opredflag"
	round_description = "The UNSC Spartan-IIs are dispatched to take down a Covenant Prophet."
	extended_round_description = "Everyone single Spartan II has been summoned from the far reaches of space. \
		Their mission is to board a Covenant battlecruiser and identify then terminate one of the Covenant's religous leaders... a Prophet."

	end_on_antag_death = 1
	round_autoantag = 1
	required_players = 0
	required_enemies = 1
	antag_tags = list("prophet","hunter")
	latejoin_antag_tags = list("hunter")
	antag_scaling_coeff = 0

	var/elite_shipmaster
	var/elite_shipmaster_ckey
	var/spartan_commander
	var/spartan_commander_ckey

	var/list/living_prophets = list()
	var/list/dead_prophets = list()

	var/list/living_spartans = list()
	var/list/dead_spartans = list()

	var/round_start = 0
	var/round_completion_delay = 150

/datum/game_mode/opredflag/post_setup()
	. = ..()

	round_start = world.time

	//grab the prophets
	for(var/datum/antagonist/opredflag_cov/prophet/prophets in antag_templates)
		for(var/D in prophets.current_antagonists)
			living_prophets.Add(D)

	//grab the spartan list
	var/datum/job/spartans = job_master.occupations_by_title["Spartan II"]
	living_spartans += spartans.assigned_players

	//dont let spartans latejoin
	spartans.total_positions = 0

	//grab the elite shipmaster
	var/datum/job/opredflag_cov/elite/shipmaster = job_master.occupations_by_title["Sangheili Shipmaster"]
	for(var/mob/M in shipmaster.assigned_players)
		elite_shipmaster = M.name
		elite_shipmaster_ckey = M.ckey
		break

	//grab the spartan commander
	var/datum/job/opredflag_spartan/commander = job_master.occupations_by_title["Spartan II Commander"]
	//dont let a commander latejoin
	commander.total_positions = 0
	for(var/mob/M in commander.assigned_players)
		spartan_commander = M.name
		spartan_commander_ckey = M.ckey
		break

/datum/game_mode/opredflag/get_respawn_time()
	return 0.5		//minutes

/datum/game_mode/opredflag/handle_mob_death(var/mob/living/carbon/human/M, var/list/args = list())
	ASSERT(M)

	//work out the mob species
	var/type = 0
	if(istype(M, /mob/living/carbon/human/covenant/sanshyuum))
		type = 1
	else if(istype(M, /mob/living/carbon/human/spartan))
		type = 2
	else
		var/datum/species/S = M.species
		if(istype(S, /datum/species/sanshyuum))
			type = 1
		else if(istype(S, /datum/species/spartan))
			type = 2

	//grab the mind
	var/datum/mind/D = M.mind
	if(!D)
		for(var/datum/mind/cur_mind in living_prophets + living_spartans)
			if(cur_mind.name == M.real_name)
				D = cur_mind
				break

	if(D)
		//prophets
		if(type == 1)
			living_prophets -= D
			dead_prophets += D
			return 1

		//spartans
		if(type == 2)
			living_spartans -= D
			dead_spartans += D
			return 1

	return ..()

/datum/game_mode/opredflag/check_finished()
	//dont finish the game for the first 15 seconds
	if(world.time < round_start + round_completion_delay)
		return 0

	if(!living_prophets.len)
		return 1
	if(!living_spartans.len)
		return 1

	return 0

/datum/game_mode/opredflag/declare_completion()
	var/text = ""
	if(!living_prophets.len)
		text += "<span class='boldannounce'>All Prophets were slain!</span><br>"

	text += "<span class='cult'>The Prophets were:</span><br>"
	for(var/datum/mind/D in living_prophets)
		text += "<span class='cult'>[D] (played by [D.key])</span><br>"
	for(var/datum/mind/D in dead_prophets)
		text += "<span class='cult'>[D.name] (played by [D.key])(slain)</span><br>"
	text += "<br>"
	if(elite_shipmaster)
		text += "<span class='cult'>The Elite Shipmaster was [elite_shipmaster] (played by [elite_shipmaster_ckey])</span><br>"
	if(spartan_commander)
		text += "<span class='passive'>The Spartan II commander was [spartan_commander] (played by [spartan_commander_ckey])</span><br>"
	if(!living_spartans.len)
		text = "<span class='boldannounce'>All Spartans have failed to return!</span><br>"
	text += "<span class='passive'>The Spartan IIs were:</span><br>"
	for(var/datum/mind/M in living_spartans)
		text += "<span class='passive'>[M] (played by [M.key])</span><br>"
	for(var/datum/mind/M in dead_spartans)
		text += "<span class='passive'>[M] (played by [M.key])(MIA)</span><br>"
	text += "<br>"

	if(!living_prophets.len)
		if(living_spartans.len)
			text += "<h1 class='alert'>UNSC Major Victory</h1>"
		else
			text += "<h1 class='alert'>UNSC Pyrrhic Victory</h1>"
	else if(living_spartans.len)
		text += "<h1 class='alert'>Covenant Minor Victory</h1>"
	else
		text += "<h1 class='alert'>Covenant Major Victory</h1>"

	to_world(text)

	return 0
