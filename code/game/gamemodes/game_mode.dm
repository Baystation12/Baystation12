//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
 * GAMEMODES (by Rastaf0)
 *
 * In the new mode system all special roles are fully supported.
 * You can have proper wizards/traitors/changelings/cultists during any mode.
 * Only two things really depends on gamemode:
 * 1. Starting roles, equipment and preparations
 * 2. Conditions of finishing the round.
 *
 */


/datum/game_mode
	var/name = "invalid"
	var/config_tag = null
	var/intercept_hacked = 0
	var/votable = 1
	var/probability = 0
	var/station_was_nuked = 0 //see nuclearbomb.dm and malfunction.dm
	var/explosion_in_progress = 0 //sit back and relax
	var/list/datum/mind/modePlayer = new
	var/list/restricted_jobs = list()	// Jobs it doesn't make sense to be.  I.E chaplain or AI cultist
	var/list/protected_jobs = list()	// Jobs that can't be traitors because
	var/required_players = 0
	var/required_players_secret = 0 //Minimum number of players for that game mode to be chose in Secret
	var/required_enemies = 0
	var/recommended_enemies = 0
	var/newscaster_announcements = null
	var/ert_disabled = 0
	var/uplink_welcome = "Illegal Uplink Console:"
	var/uplink_uses = 12
	var/list/datum/uplink_item/uplink_items = list(
		"Ammunition" = list(
			new/datum/uplink_item(/obj/item/ammo_magazine/a357, 2, ".357", "RA"),
			new/datum/uplink_item(/obj/item/ammo_magazine/mc9mm, 2, "9mm", "R9"),
			new/datum/uplink_item(/obj/item/ammo_magazine/chemdart, 2, "Darts", "AD"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/sniperammo, 2, "14.5mm", "SA")
			),
		"Highly Visible and Dangerous Weapons" = list(
			 new/datum/uplink_item(/obj/item/weapon/storage/box/emps, 3, "5 EMP Grenades", "EM"),
			 new/datum/uplink_item(/obj/item/weapon/melee/energy/sword, 4, "Energy Sword", "ES"),
			 new/datum/uplink_item(/obj/item/weapon/gun/projectile/dartgun, 5, "Dart Gun", "DG"),
			 new/datum/uplink_item(/obj/item/weapon/gun/energy/crossbow, 5, "Energy Crossbow", "XB"),
			 new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/g9mm, 5, "Silenced 9mm", "S9"),
			 new/datum/uplink_item(/obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser, 6, "Exosuit Rigged Laser", "RL"),
			 new/datum/uplink_item(/obj/item/weapon/gun/projectile/revolver, 6, "Revolver", "RE"),
			 new/datum/uplink_item(/obj/item/weapon/storage/box/syndicate, 10, "Mercenary Bundle", "BU"),
			 new/datum/uplink_item(/obj/item/weapon/gun/projectile/heavysniper, 12, "Anti-materiel Rifle", "AMR")
			),
		"Stealthy and Inconspicuous Weapons" = list(
			new/datum/uplink_item(/obj/item/weapon/soap/syndie, 1, "Subversive Soap", "SP"),
			new/datum/uplink_item(/obj/item/weapon/cane/concealed, 2, "Concealed Cane Sword", "CC"),
			new/datum/uplink_item(/obj/item/weapon/cartridge/syndicate, 3, "Detomatix PDA Cartridge", "DC"),
			new/datum/uplink_item(/obj/item/weapon/pen/paralysis, 3, "Paralysis Pen", "PP"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/cigarette, 4, "Cigarette Kit", "BH"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/toxin, 4, "Random Toxin - Beaker", "RT")
			),
		"Stealth and Camouflage Items" = list(
			new/datum/uplink_item(/obj/item/weapon/card/id/syndicate, 2, "Agent ID card", "AC"),
			new/datum/uplink_item(/obj/item/clothing/shoes/syndigaloshes, 2, "No-Slip Shoes", "SH"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/spy, 2, "Bug Kit", "BK"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/chameleon, 3, "Chameleon Kit", "CB"),
			new/datum/uplink_item(/obj/item/device/chameleon, 4, "Chameleon-Projector", "CP"),
			new/datum/uplink_item(/obj/item/clothing/mask/gas/voice, 4, "Voice Changer", "VC"),
			new/datum/uplink_item(/obj/item/weapon/disk/file/cameras/syndicate, 6, "Camera Network Access - Floppy", "SF")
			),
		"Devices and Tools" = list(
			new/datum/uplink_item(/obj/item/weapon/storage/toolbox/syndicate, 1, "Fully Loaded Toolbox", "ST"),
			new/datum/uplink_item(/obj/item/weapon/plastique, 2, "C-4 (Destroys walls)", "C4"),
			new/datum/uplink_item(/obj/item/device/encryptionkey/syndicate, 2, "Encrypted Radio Channel Key", "ER"),
			new/datum/uplink_item(/obj/item/device/encryptionkey/binary, 3, "Binary Translator Key", "BT"),
			new/datum/uplink_item(/obj/item/weapon/card/emag, 3, "Cryptographic Sequencer", "EC"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/clerical, 3, "Morphic Clerical Kit", "CK"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/space, 3, "Space Suit", "SS"),
			new/datum/uplink_item(/obj/item/clothing/glasses/thermal/syndi, 3, "Thermal Imaging Glasses", "TM"),
			new/datum/uplink_item(/obj/item/clothing/suit/storage/vest/heavy/merc, 4, "Heavy Armor Vest", "HAV"),
			new/datum/uplink_item(/obj/item/weapon/aiModule/syndicate, 7, "Hacked AI Upload Module", "AI"),
			new/datum/uplink_item(/obj/item/device/powersink, 5, "Powersink (DANGER!)", "PS",),
			new/datum/uplink_item(/obj/item/device/radio/beacon/syndicate, 7, "Singularity Beacon (DANGER!)", "SB"),
			new/datum/uplink_item(/obj/item/weapon/circuitboard/teleporter, 20, "Teleporter Circuit Board", "TP")
			),
		"Implants" = list(
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/imp_freedom, 3, "Freedom Implant", "FI"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/imp_compress, 4, "Compressed Matter Implant", "CI"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/imp_explosive, 6, "Explosive Implant (DANGER!)", "EI"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/imp_uplink, 10, "Uplink Implant (Contains 5 Telecrystals)", "UI")
			),
		"Medical" = list(
			new/datum/uplink_item(/obj/item/weapon/storage/box/sinpockets, 1, "Box of Sin-Pockets", "DP"),
			new/datum/uplink_item(/obj/item/weapon/storage/firstaid/surgery, 5, "Surgery kit", "SK"),
			new/datum/uplink_item(/obj/item/weapon/storage/firstaid/combat, 5, "Combat medical kit", "CM")
		),
		"Hardsuit Modules" = list(
			new/datum/uplink_item(/obj/item/rig_module/vision/thermal, 2, "Thermal Scanner", "RTS"),
			new/datum/uplink_item(/obj/item/rig_module/fabricator/energy_net, 3, "Net Projector", "REN"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/ewar_voice, 4, "Electrowarfare Suite and Voice Synthesiser", "REV"),
			new/datum/uplink_item(/obj/item/rig_module/maneuvering_jets, 4, "Maneuvering Jets", "RMJ"),
			new/datum/uplink_item(/obj/item/rig_module/mounted/egun, 6, "Mounted Energy Gun", "REG"),
			new/datum/uplink_item(/obj/item/rig_module/power_sink, 6, "Power Sink", "RPS"),
			new/datum/uplink_item(/obj/item/rig_module/mounted, 8, "Mounted Laser Cannon", "RLC")
		),
		"(Pointless) Badassery" = list(
			new/datum/uplink_item(/obj/item/toy/syndicateballoon, 10, "For showing that You Are The BOSS (Useless Balloon)", "BS"),
			new/datum/uplink_item(/obj/item/toy/nanotrasenballoon, 10, "For showing that you love NT SOO much (Useless Balloon)", "NT")
			)
		)

// Items removed from above:
/*
/obj/item/weapon/cloaking_device:4:Cloaking Device;	//Replacing cloakers with thermals.	-Pete
*/

/datum/game_mode/proc/announce() //to be calles when round starts
	world << "<B>Notice</B>: [src] did not define announce()"


///can_start()
///Checks to see if the game can be setup and ran with the current number of players or whatnot.
/datum/game_mode/proc/can_start()
	var/playerC = 0
	for(var/mob/new_player/player in player_list)
		if((player.client)&&(player.ready))
			playerC++

	if(master_mode=="secret")
		if(playerC >= required_players_secret)
			return 1
	else
		if(playerC >= required_players)
			return 1
	return 0


///pre_setup()
///Attempts to select players for special roles the mode might have.
/datum/game_mode/proc/pre_setup()
	return 1


///post_setup()
///Everyone should now be on the station and have their normal gear.  This is the place to give the special roles extra things
/datum/game_mode/proc/post_setup()
	spawn (ROUNDSTART_LOGOUT_REPORT_TIME)
		display_roundstart_logout_report()

	feedback_set_details("round_start","[time2text(world.realtime)]")
	if(ticker && ticker.mode)
		feedback_set_details("game_mode","[ticker.mode]")
	feedback_set_details("server_ip","[world.internet_address]:[world.port]")
	return 1


///process()
///Called by the gameticker
/datum/game_mode/proc/process()
	return 0


/datum/game_mode/proc/check_finished() //to be called by ticker
	if(emergency_shuttle.returned() || station_was_nuked)
		return 1
	return 0

/datum/game_mode/proc/cleanup()	//This is called when the round has ended but not the game, if any cleanup would be necessary in that case.
	return

/datum/game_mode/proc/declare_completion()
	var/clients = 0
	var/surviving_humans = 0
	var/surviving_total = 0
	var/ghosts = 0
	var/escaped_humans = 0
	var/escaped_total = 0
	var/escaped_on_pod_1 = 0
	var/escaped_on_pod_2 = 0
	var/escaped_on_pod_3 = 0
	var/escaped_on_pod_5 = 0
	var/escaped_on_shuttle = 0

	var/list/area/escape_locations = list(/area/shuttle/escape/centcom, /area/shuttle/escape_pod1/centcom, /area/shuttle/escape_pod2/centcom, /area/shuttle/escape_pod3/centcom, /area/shuttle/escape_pod5/centcom)

	for(var/mob/M in player_list)
		if(M.client)
			clients++
			if(ishuman(M))
				if(M.stat != DEAD)
					surviving_humans++
					if(M.loc && M.loc.loc && M.loc.loc.type in escape_locations)
						escaped_humans++
			if(M.stat != DEAD)
				surviving_total++
				if(M.loc && M.loc.loc && M.loc.loc.type in escape_locations)
					escaped_total++

				if(M.loc && M.loc.loc && M.loc.loc.type == /area/shuttle/escape/centcom)
					escaped_on_shuttle++

				if(M.loc && M.loc.loc && M.loc.loc.type == /area/shuttle/escape_pod1/centcom)
					escaped_on_pod_1++
				if(M.loc && M.loc.loc && M.loc.loc.type == /area/shuttle/escape_pod2/centcom)
					escaped_on_pod_2++
				if(M.loc && M.loc.loc && M.loc.loc.type == /area/shuttle/escape_pod3/centcom)
					escaped_on_pod_3++
				if(M.loc && M.loc.loc && M.loc.loc.type == /area/shuttle/escape_pod5/centcom)
					escaped_on_pod_5++

			if(isobserver(M))
				ghosts++

	var/text = ""
	if(surviving_total > 0)
		text += "<br>There [surviving_total>1 ? "were <b>[surviving_total] survivors</b>" : "was <b>one survivor</b>"]</b>"
		text += " (<b>[escaped_total>0 ? escaped_total : "none"] [emergency_shuttle.evac ? "escaped" : "transferred"]</b>) and <b>[ghosts] ghosts</b>.</b><br>"
	else
		text += "There were <b>no survivors</b> (<b>[ghosts] ghosts</b>).</b>"
	world << text

	if(clients > 0)
		feedback_set("round_end_clients",clients)
	if(ghosts > 0)
		feedback_set("round_end_ghosts",ghosts)
	if(surviving_humans > 0)
		feedback_set("survived_human",surviving_humans)
	if(surviving_total > 0)
		feedback_set("survived_total",surviving_total)
	if(escaped_humans > 0)
		feedback_set("escaped_human",escaped_humans)
	if(escaped_total > 0)
		feedback_set("escaped_total",escaped_total)
	if(escaped_on_shuttle > 0)
		feedback_set("escaped_on_shuttle",escaped_on_shuttle)
	if(escaped_on_pod_1 > 0)
		feedback_set("escaped_on_pod_1",escaped_on_pod_1)
	if(escaped_on_pod_2 > 0)
		feedback_set("escaped_on_pod_2",escaped_on_pod_2)
	if(escaped_on_pod_3 > 0)
		feedback_set("escaped_on_pod_3",escaped_on_pod_3)
	if(escaped_on_pod_5 > 0)
		feedback_set("escaped_on_pod_5",escaped_on_pod_5)

	send2mainirc("A round of [src.name] has ended - [surviving_total] survivors, [ghosts] ghosts.")

	return 0


/datum/game_mode/proc/check_win() //universal trigger to be called at mob death, nuke explosion, etc. To be called from everywhere.
	return 0


/datum/game_mode/proc/send_intercept()
	var/intercepttext = "<FONT size = 3><B>Cent. Com. Update</B> Requested status information:</FONT><HR>"
	intercepttext += "<B> In case you have misplaced your copy, attached is a list of personnel whom reliable sources&trade; suspect may be affiliated with subversive elements:</B><br>"


	var/list/suspects = list()
	for(var/mob/living/carbon/human/man in player_list) if(man.client && man.mind)
		// NT relation option
		var/special_role = man.mind.special_role
		if (special_role == "Wizard" || special_role == "Ninja" || special_role == "Mercenary" || special_role == "Vox Raider")
			continue	//NT intelligence ruled out possiblity that those are too classy to pretend to be a crew.
		if(man.client.prefs.nanotrasen_relation == "Opposed" && prob(50) || \
		   man.client.prefs.nanotrasen_relation == "Skeptical" && prob(20))
			suspects += man
		// Antags
		else if(special_role == "traitor" && prob(40) || \
		   special_role == "Changeling" && prob(50) || \
		   special_role == "Cultist" && prob(30) || \
		   special_role == "Head Revolutionary" && prob(30))
			suspects += man

		// Some poor people who were just in the wrong place at the wrong time..
		else if(prob(10))
			suspects += man
	for(var/mob/M in suspects)
		switch(rand(1, 100))
			if(1 to 50)
				intercepttext += "Someone with the job of <b>[M.mind.assigned_role]</b> <br>"
			else
				intercepttext += "<b>[M.name]</b>, the <b>[M.mind.assigned_role]</b> <br>"

	for (var/obj/machinery/computer/communications/comm in machines)
		if (!(comm.stat & (BROKEN | NOPOWER)) && comm.prints_intercept)
			var/obj/item/weapon/paper/intercept = new /obj/item/weapon/paper( comm.loc )
			intercept.name = "Cent. Com. Status Summary"
			intercept.info = intercepttext

			comm.messagetitle.Add("Cent. Com. Status Summary")
			comm.messagetext.Add(intercepttext)
	world << sound('sound/AI/commandreport.ogg')

/*	command_alert("Summary downloaded and printed out at all communications consoles.", "Enemy communication intercept. Security Level Elevated.")
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player))
			M << sound('sound/AI/intercept.ogg')
	if(security_level < SEC_LEVEL_BLUE)
		set_security_level(SEC_LEVEL_BLUE)*/


/datum/game_mode/proc/get_players_for_role(var/role, override_jobbans=0)
	var/list/players = list()
	var/list/candidates = list()
	//var/list/drafted = list()
	//var/datum/mind/applicant = null

	var/roletext
	switch(role)
		if(BE_CHANGELING)	roletext="changeling"
		if(BE_TRAITOR)		roletext="traitor"
		if(BE_OPERATIVE)	roletext="operative"
		if(BE_WIZARD)		roletext="wizard"
		if(BE_REV)			roletext="revolutionary"
		if(BE_CULTIST)		roletext="cultist"
		if(BE_NINJA)		roletext="ninja"
		if(BE_RAIDER)		roletext="raider"

	// Assemble a list of active players without jobbans.
	for(var/mob/new_player/player in player_list)
		if( player.client && player.ready )
			if(!jobban_isbanned(player, "Syndicate") && !jobban_isbanned(player, roletext))
				players += player

	// Shuffle the players list so that it becomes ping-independent.
	players = shuffle(players)

	// Get a list of all the people who want to be the antagonist for this round
	for(var/mob/new_player/player in players)
		if(player.client.prefs.be_special & role)
			log_debug("[player.key] had [roletext] enabled, so we are drafting them.")
			candidates += player.mind
			players -= player

	// If we don't have enough antags, draft people who voted for the round.
	if(candidates.len < recommended_enemies)
		for(var/key in round_voters)
			for(var/mob/new_player/player in players)
				if(player.ckey == key)
					log_debug("[player.key] voted for this round, so we are drafting them.")
					candidates += player.mind
					players -= player
					break

	// Remove candidates who want to be antagonist but have a job that precludes it
	if(restricted_jobs)
		for(var/datum/mind/player in candidates)
			for(var/job in restricted_jobs)
				if(player.assigned_role == job)
					candidates -= player

	/*if(candidates.len < recommended_enemies)
		for(var/mob/new_player/player in players)
			if(player.client && player.ready)
				if(!(player.client.prefs.be_special & role)) // We don't have enough people who want to be antagonist, make a seperate list of people who don't want to be one
					if(!jobban_isbanned(player, "Syndicate") && !jobban_isbanned(player, roletext)) //Nodrak/Carn: Antag Job-bans
						drafted += player.mind

	if(restricted_jobs)
		for(var/datum/mind/player in drafted)				// Remove people who can't be an antagonist
			for(var/job in restricted_jobs)
				if(player.assigned_role == job)
					drafted -= player

	drafted = shuffle(drafted) // Will hopefully increase randomness, Donkie

	while(candidates.len < recommended_enemies)				// Pick randomlly just the number of people we need and add them to our list of candidates
		if(drafted.len > 0)
			applicant = pick(drafted)
			if(applicant)
				candidates += applicant
				log_debug("[applicant.key] was force-drafted as [roletext], because there aren't enough candidates.")
				drafted.Remove(applicant)

		else												// Not enough scrubs, ABORT ABORT ABORT
			break

	if(candidates.len < recommended_enemies && override_jobbans) //If we still don't have enough people, we're going to start drafting banned people.
		for(var/mob/new_player/player in players)
			if (player.client && player.ready)
				if(jobban_isbanned(player, "Syndicate") || jobban_isbanned(player, roletext)) //Nodrak/Carn: Antag Job-bans
					drafted += player.mind

	if(restricted_jobs)
		for(var/datum/mind/player in drafted)				// Remove people who can't be an antagonist
			for(var/job in restricted_jobs)
				if(player.assigned_role == job)
					drafted -= player

	drafted = shuffle(drafted) // Will hopefully increase randomness, Donkie

	while(candidates.len < recommended_enemies)				// Pick randomlly just the number of people we need and add them to our list of candidates
		if(drafted.len > 0)
			applicant = pick(drafted)
			if(applicant)
				candidates += applicant
				drafted.Remove(applicant)
				log_debug("[applicant.key] was force-drafted as [roletext], because there aren't enough candidates.")

		else												// Not enough scrubs, ABORT ABORT ABORT
			break
	*/

	return candidates		// Returns: The number of people who had the antagonist role set to yes, regardless of recomended_enemies, if that number is greater than recommended_enemies
							//			recommended_enemies if the number of people with that role set to yes is less than recomended_enemies,
							//			Less if there are not enough valid players in the game entirely to make recommended_enemies.


/datum/game_mode/proc/latespawn(var/mob)

/*
/datum/game_mode/proc/check_player_role_pref(var/role, var/mob/new_player/player)
	if(player.preferences.be_special & role)
		return 1
	return 0
*/

/datum/game_mode/proc/num_players()
	. = 0
	for(var/mob/new_player/P in player_list)
		if(P.client && P.ready)
			. ++


///////////////////////////////////
//Keeps track of all living heads//
///////////////////////////////////
/datum/game_mode/proc/get_living_heads()
	var/list/heads = list()
	for(var/mob/living/carbon/human/player in mob_list)
		if(player.stat!=2 && player.mind && (player.mind.assigned_role in command_positions))
			heads += player.mind
	return heads


////////////////////////////
//Keeps track of all heads//
////////////////////////////
/datum/game_mode/proc/get_all_heads()
	var/list/heads = list()
	for(var/mob/player in mob_list)
		if(player.mind && (player.mind.assigned_role in command_positions))
			heads += player.mind
	return heads

/datum/game_mode/proc/check_antagonists_topic(href, href_list[])
	return 0

/datum/game_mode/New()
	newscaster_announcements = pick(newscaster_standard_feeds)

//////////////////////////
//Reports player logouts//
//////////////////////////
proc/display_roundstart_logout_report()
	var/msg = "\blue <b>Roundstart logout report\n\n"
	for(var/mob/living/L in mob_list)

		if(L.ckey)
			var/found = 0
			for(var/client/C in clients)
				if(C.ckey == L.ckey)
					found = 1
					break
			if(!found)
				msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='#ffcc00'><b>Disconnected</b></font>)\n"


		if(L.ckey && L.client)
			if(L.client.inactivity >= (ROUNDSTART_LOGOUT_REPORT_TIME / 2))	//Connected, but inactive (alt+tabbed or something)
				msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='#ffcc00'><b>Connected, Inactive</b></font>)\n"
				continue //AFK client
			if(L.stat)
				if(L.suiciding)	//Suicider
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='red'><b>Suicide</b></font>)\n"
					continue //Disconnected client
				if(L.stat == UNCONSCIOUS)
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (Dying)\n"
					continue //Unconscious
				if(L.stat == DEAD)
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (Dead)\n"
					continue //Dead

			continue //Happy connected client
		for(var/mob/dead/observer/D in mob_list)
			if(D.mind && (D.mind.original == L || D.mind.current == L))
				if(L.stat == DEAD)
					if(L.suiciding)	//Suicider
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>Suicide</b></font>)\n"
						continue //Disconnected client
					else
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (Dead)\n"
						continue //Dead mob, ghost abandoned
				else
					if(D.can_reenter_corpse)
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>This shouldn't appear.</b></font>)\n"
						continue //Lolwhat
					else
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>Ghosted</b></font>)\n"
						continue //Ghosted while alive



	for(var/mob/M in mob_list)
		if(M.client && M.client.holder)
			M << msg


proc/get_nt_opposed()
	var/list/dudes = list()
	for(var/mob/living/carbon/human/man in player_list)
		if(man.client)
			if(man.client.prefs.nanotrasen_relation == "Opposed")
				dudes += man
			else if(man.client.prefs.nanotrasen_relation == "Skeptical" && prob(50))
				dudes += man
	if(dudes.len == 0) return null
	return pick(dudes)

//Announces objectives/generic antag text.
/proc/show_generic_antag_text(var/datum/mind/player)
	if(player.current)
		player.current << \
		"You are an antagonist! <font color=blue>Within the rules,</font> \
		try to act as an opposing force to the crew. Further RP and try to make sure \
		other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to antagonists.</b>"

/proc/show_objectives(var/datum/mind/player)

	if(!player || !player.current) return

	if(config.objectives_disabled)
		show_generic_antag_text(player)
		return

	var/obj_count = 1
	player.current << "\blue Your current objectives:"
	for(var/datum/objective/objective in player.objectives)
		player.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++

/datum/game_mode/proc/print_player_lite(var/datum/mind/ply)
	var/role = ply.assigned_role == "MODE" ? "\improper[ply.special_role]" : "\improper[ply.assigned_role]"
	var/text = "<br><b>[ply.name]</b> (<b>[ply.key]</b>) as \a <b>[role]</b> ("
	if(ply.current)
		if(ply.current.stat == DEAD)
			text += "died"
		else
			text += "survived"
		if(ply.current.real_name != ply.name)
			text += " as <b>[ply.current.real_name]</b>"
	else
		text += "body destroyed"
	text += ")"

	return text

/datum/game_mode/proc/print_player_full(var/datum/mind/ply)
	var/text = print_player_lite(ply)

	var/TC_uses = 0
	var/uplink_true = 0
	var/purchases = ""
	for(var/obj/item/device/uplink/H in world_uplinks)
		if(H && H.uplink_owner && H.uplink_owner == ply)
			TC_uses += H.used_TC
			uplink_true = 1
			var/list/refined_log = new()
			for(var/datum/uplink_item/UI in H.purchase_log)
				var/obj/I = new UI.path
				refined_log.Add("[H.purchase_log[UI]]x\icon[I][UI.name]")
				del(I)
			purchases = english_list(refined_log, nothing_text = "")
	if(uplink_true)
		text += " (used [TC_uses] TC)"
		if(purchases)
			text += "<br>[purchases]"

	return text
