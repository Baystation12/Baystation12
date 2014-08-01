/*
 * This roundtype is a replacement for the meteor round on upstream BS12 - players
 * expressed the desire for quick, chaotic and violent rounds, preferrably without
 * dependancy on other players.
 * I wanted to call it clusterfuck, but I figure that's a bit too overt. Think of
 * the children.
 * ~ Zuhayr
 */

/datum/game_mode/calamity
	name = "calamity"
	config_tag = "calamity"
	required_players = 1
	votable = 0 //Remove after testing.

	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10

	//Possible roundstart antag types.
	var/list/atypes = list("syndi","ling","tater","wiz","ninja","vox","slug","cult")
	var/list/chosen_atypes = list()
	var/list/chosen_candidates = list()
	var/list/already_assigned_candidates = list()

	//At one antagonist group per 10 players we are just going to go with tiny groups.
	var/max_antags = 3        // Antag groups spawn with this many members.
	var/antag_type_ratio = 10 // 1 antag type per this many players.

	var/const/waittime_l = 600
	var/const/waittime_h = 1800

/datum/game_mode/calamity/announce()
	world << "<B>The current game mode is - Calamity!</B>"
	world << "<B>This must be a Thursday. You never could get the hang of Thursdays...</B>"

/datum/game_mode/calamity/can_start()

	if(!..())
		return 0

	var/antag_count = player_list.len/antag_type_ratio

	if(!antag_count)
		return 1

	for(var/i=0;i<antag_count;i++)

		var/atype
		var/list/candidates = list()

		while(atypes.len && candidates.len == 0) //While there are untested antag mode types and we don't have any candidates selected, loop.
			atype = pick(atypes)
			log_debug("Calamity: checking [atype].")
			atypes -= atype
			candidates = get_role_candidates(atype)

		if(!candidates.len)
			log_debug("Calamity mode setup failed, no antag types or candidates left.")
			return 0

		log_debug("Calamity: selected [atype] (possible candidates: [candidates.len])")
		chosen_atypes += atype

		for(var/j=0;j<max_antags;j++)
			var/datum/mind/chosen_candidate = pick(candidates)
			//Traitors and lings spawn THEN have roles applied; hence we don't set assigned_role here.
			if(atype != "tater" && atype != "ling" && atype != "cult")
				chosen_candidate.assigned_role = "MODE"
			chosen_candidate.special_role = atype
			chosen_candidates += chosen_candidate

		if(atypes.len - i <= 0) break //Not enough valid types left to populate the remaining antag slots.

	return 1

/datum/game_mode/calamity/post_setup()

	if(chosen_atypes)
		for(var/atype in chosen_atypes)
			var/list/candidates = list()

			for(var/datum/mind/player in chosen_candidates)
				if(player.special_role == atype)
					candidates += player
					chosen_candidates -= player

			if(!candidates || !candidates.len)
				log_debug("No candidates for [atype].")
				continue

			log_debug("Calamity: spawning [atype].")

			for(var/datum/mind/player in candidates)
				player.special_role = get_candidate_role_text(atype)

			switch(atype)
				if("syndi")
					spawn_syndicate(candidates)
				if("ling")
					spawn_changelings(candidates)
				if("tater")
					spawn_traitors(candidates)
				if("wiz")
					spawn_cabal(candidates)
				if("ninja")
					spawn_ninja(candidates)
				if("vox")
					spawn_vox_raiders(candidates)
				if("slug")
					spawn_borers(candidates)
				if("cult")
					spawn_cultists(candidates)

/datum/game_mode/calamity/declare_completion()

	var/text = "<FONT size = 3><B>This terrible, terrible day has finally ended!</B></FONT><BR/>"

	//Group antag objective completion.
	for(var/list/L in list(src.raiders, src.syndicates, src.cult, src.wizards))

		if(L.len)
			var/datum/mind/M = L[1]
			text = "<BR/><FONT size = 2><B>The [M.special_role][L.len == 1 ? " was" : "s were"]:</B></FONT>"

			for(var/datum/mind/P in L)
				text += "<br>[P.key] was [P.name] ("
				if(P.current)
					if(P.current.stat == DEAD)
						text += "died"
					else
						text += "survived"
					if(P.current.real_name != P.name)
						text += " as [P.current.real_name]"
				else
					text += "body destroyed"
				text += ")"

			if(M.objectives.len)
				text += "<BR/><FONT size = 2>Their objectives were:<FONT>"
				var/num = 1
				for(var/datum/objective/O in M.objectives)
					text += "<BR/><B>Objective [num]:</B> [O.explanation_text]"
					num++

	//Single antag objective completion.
	for(var/list/L in list(src.changelings, src.ninjas, src.borers, src.traitors))

		if(L.len)
			var/datum/mind/M = L[1]
			text = "<BR/><FONT size = 2><B>The [M.special_role][L.len == 1 ? " was" : "s were"]:</B></FONT>"
			for(var/datum/mind/P in L)
				var/num = 1
				text += "<BR/><FONT size = 2>[P.key] was [P.name].<FONT>"
				if(P.objectives.len)
					for(var/datum/objective/O in P.objectives)
						text += "<BR/><B>Objective [num]:</B> [O.explanation_text]"
						num++
	..()
	return 1

//Converts chosen atype to an actual role string.
/datum/game_mode/calamity/proc/get_candidate_role_text(var/role)

	var/role_text

	switch(role)
		if("syndi")
			role_text = "Syndicate Operative"
		if("ling")
			role_text = "Changeling"
		if("tater")
			role_text = "Traitor"
		if("wiz")
			role_text = "Cabalist"
		if("ninja")
			role_text = "Ninja"
		if("vox")
			role_text = "Vox Raider"
		if("slug")
			role_text = "Cortical Borer"
		if("cult")
			role_text = "Cultist"

	return role_text

//Grabs candidate lists for various atypes.
/datum/game_mode/calamity/proc/get_role_candidates(var/role)

	var/list/possible_antags = list()
	switch(role)
		if("syndi")
			possible_antags = get_players_for_role(BE_OPERATIVE)
		if("ling")
			possible_antags = get_players_for_role(BE_CHANGELING)
		if("tater")
			possible_antags = get_players_for_role(BE_TRAITOR)
		if("wiz")
			possible_antags = get_players_for_role(BE_WIZARD)
		if("ninja")
			possible_antags = get_players_for_role(BE_NINJA)
		if("vox")
			possible_antags = get_players_for_role(BE_RAIDER)
		if("slug")
			possible_antags = get_players_for_role(BE_ALIEN)
		if("cult")
			possible_antags = get_players_for_role(BE_CULTIST)

	var/list/filtered_antags = list()
	if(possible_antags)
		for(var/datum/mind/candidate in possible_antags)
			if(!(candidate in already_assigned_candidates))
				filtered_antags |= candidate
				already_assigned_candidates |= candidate

	if(filtered_antags && islist(filtered_antags))
		return filtered_antags
	else
		return list(filtered_antags)

//Spawning procs for the various antag types.
//A LOT OF THE FOLLOWING IS COPYPASTED FROM OTHER MODES AND NEEDS
//TO BE FIXED UP. NINJA, NUKE AND CULT IN PARTICULAR ARE FUCKING AWFUL. ~ Z
/datum/game_mode/calamity/proc/spawn_syndicate(var/list/candidates)

	var/obj/effect/landmark/uplinklocker = locate("landmark*Syndicate-Uplink")
	var/obj/effect/landmark/nuke_spawn = locate("landmark*Nuclear-Bomb")

	var/nuke_code = "[rand(10000, 99999)]"
	var/leader_selected = 0
	var/spawnpos = 1

	for(var/datum/mind/player in candidates)

		syndicates += player

		if(spawnpos > synd_spawn.len)
			spawnpos = 1
		player.current.loc = synd_spawn[spawnpos]

		player.current.real_name = "[syndicate_name()] Operative"
		spawn(0)
			NukeNameAssign(player)

		forge_syndicate_objectives(player)
		greet_syndicate(player)
		equip_syndicate(player.current)

		if(!leader_selected)
			prepare_syndicate_leader(player, nuke_code)
			leader_selected = 1

		spawnpos++
		update_synd_icons_added(player)

	update_all_synd_icons()

	if(uplinklocker)
		new /obj/structure/closet/syndicate/nuclear(uplinklocker.loc)
	if(nuke_spawn && synd_spawn.len > 0)
		var/obj/machinery/nuclearbomb/the_bomb = new /obj/machinery/nuclearbomb(nuke_spawn.loc)
		the_bomb.r_code = nuke_code

/datum/game_mode/calamity/proc/spawn_changelings(var/list/candidates)

	for(var/datum/mind/player in candidates)

		changelings += player
		grant_changeling_powers(player.current)
		player.special_role = "Changeling"

		if(!config.objectives_disabled)
			player.objectives += new /datum/objective/escape()
			player.objectives += new /datum/objective/survive()

		show_objectives(player)
		greet_changeling(player)

/datum/game_mode/calamity/proc/spawn_traitors(var/list/candidates)

	for(var/datum/mind/player in candidates)
		traitors += player

		if(!config.objectives_disabled)
			player.objectives += new /datum/objective/escape()
			player.objectives += new /datum/objective/survive()

		show_objectives(player)

		finalize_traitor(player)
		greet_traitor(player)

/datum/game_mode/calamity/proc/spawn_cabal(var/list/candidates)

	for(var/datum/mind/player in candidates)
		wizards += player

		if(!config.objectives_disabled)
			player.objectives += new /datum/objective/escape()
			player.objectives += new /datum/objective/survive()

		show_objectives(player)

		player.current.loc = pick(wizardstart)

		equip_wizard(player.current)
		name_wizard(player.current)
		greet_wizard(player)

/datum/game_mode/calamity/proc/spawn_ninja(var/list/candidates)

	//I hate that this is necessary. ~Z
	for(var/obj/effect/landmark/L in landmarks_list)
		if(L.name == "carpspawn")
			ninjastart.Add(L)

	for(var/datum/mind/player in candidates)
		ninjas += player

		player.current << browse(null, "window=playersetup")
		player.current = create_space_ninja(pick(ninjastart))
		player.current.ckey = player.key

		if(player.current && !(istype(player.current,/mob/living/carbon/human))) return 0

		//Ninja intro crawl goes here.

		if(!config.objectives_disabled)
			player.objectives += new /datum/objective/ninja_highlander()
			player.objectives += new /datum/objective/survive()

		show_objectives(player)

		//Ninja objective announcement goes here.

		//Set ninja internals.
		var/mob/living/carbon/human/N = player.current
		N.internal = N.s_store
		N.internals.icon_state = "internal1"
		if(N.wear_suit && istype(N.wear_suit,/obj/item/clothing/suit/space/space_ninja))
			var/obj/item/clothing/suit/space/space_ninja/S = N.wear_suit
			S:randomize_param()

/datum/game_mode/calamity/proc/spawn_vox_raiders(var/list/candidates)

	//Create objectives.
	var/list/raid_objectives = forge_vox_objectives()

	//Create raiders.
	for(var/datum/mind/player in candidates)
		raiders += player

		//Place them on the shuttle.
		var/index = 1
		if(index > raider_spawn.len)
			index = 1
		player.current.loc = raider_spawn[index]
		index++

		if(!config.objectives_disabled)
			player.objectives = raid_objectives

		//Equip them.
		create_vox(player)
		greet_vox(player)

		player.current << "<b><font color='red'>Your crew is transporting cortical stacks and critical resources back to the Shoal.\
		 No delay or concession can be tolerated. Even putting holes in the station pales in comparison to failure.</b></font>"

	spawn (rand(waittime_l, waittime_h))
		send_intercept()
	..()

/datum/game_mode/calamity/proc/spawn_borers(var/list/candidates)

	var/list/possible_hosts = list()
	for(var/mob/living/carbon/human/H in mob_list)
		if(!(H.species.flags & IS_SYNTHETIC))
			possible_hosts += H

	for(var/datum/mind/player in candidates)

		if(!possible_hosts || possible_hosts.len)
			break

		borers += player
		var/mob/living/carbon/human/target_host = pick(possible_hosts)
		possible_hosts -= target_host

		var/mob/living/simple_animal/borer/roundstart/B = new(target_host)

		player.current = B
		B.mind = player
		B.key = player.key
		player.assigned_role = "Cortical Borer"
		player.special_role = "Cortical Borer"

		B.host = target_host
		B.host_brain.name = target_host.name
		B.host_brain.real_name = target_host.real_name

		var/datum/organ/external/head = target_host.get_organ("head")
		head.implants += B

		player.current << "\blue <b>You are a cortical borer!</b> You are a brain slug that worms its way \
		into the head of its victim, lurking out of sight until it needs to take control."
		player.current << "You can speak to your victim with <b>say</b>, to other borers with <b>say ;</b>, and use your Alien tab for abilities."

		if(!config.objectives_disabled)
			player.objectives += new /datum/objective/borer_survive()
			player.objectives += new /datum/objective/borer_reproduce()
			player.objectives += new /datum/objective/escape()

		show_objectives(player)

/datum/game_mode/calamity/proc/spawn_cultists(var/list/candidates)

	//Prune the list.
	var/list/jobs_to_skip = list("Chaplain","AI", "Cyborg", "Lawyer", "Head of Security", "Captain")
	if(config.protect_roles_from_antagonist)
		jobs_to_skip += list("Security Officer", "Warden", "Detective")

	//Make cult objectives.
	var/cult_objectives = list()
	cult_objectives += new /datum/objective/cult_summon()

	//Actually spawn cultists.
	for(var/datum/mind/player in candidates)

		for(var/job in jobs_to_skip)
			if(player.assigned_role == job)
				continue

		cult += player
		equip_cultist(player.current)
		grant_runeword(player.current)
		update_cult_icons_added(player)
		player.current << "\blue <b>You are a member of the cult!<b> Your dark masters have sent you forth to serve their vile will."
		player.current << "\red <b>This station sails above a weeping tear in the Cosmos. Bring the Geometer of Blood forth.</b>"

		if(!config.objectives_disabled)

			for(var/datum/objective/O in cult_objectives)
				player.objectives += O

			player.objectives += new /datum/objective/escape()
			player.objectives += new /datum/objective/survive()

		show_objectives(player)
		player.special_role = "Cultist"