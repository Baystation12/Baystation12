
#define RESPAWN_TIME 300

/datum/game_mode/slayer
	name = "Free For All Slayer"
	round_description = "Fight to the death with everyone you come across."
	extended_round_description = "No-one has scored a point yet."
	config_tag = "FFA Slayer"
	votable = 1
	probability = 0
	var/list/mode_teams = list("Spartan Slayer")		//jobs are used to represent "teams"
	var/list/team_scores_unsorted = list()
	var/list/scores_with_names = list()
	var/round_end_time = 0
	var/round_length = 6000
	var/nextrespawn
	var/species_included = list("Spartan" = list("Spartan Slayer","Blue Team Spartan","Red Team Spartan")) //This has to be an exact name taken from the datum
	disabled_jobs = list(/datum/job/team_slayer_red, /datum/job/team_slayer_blue,/datum/job/team_slayer_covenant,/datum/job/slayer_spartan_covenant)

/datum/game_mode/slayer/pre_setup()
	..()
	round_end_time = world.time + round_length
	to_world("<h1>Round duration: [round_length/600] minutes. Get the highest score by the end.</h1>")
	GLOB.using_map.allowed_jobs -= disabled_jobs

/datum/game_mode/slayer/check_finished()
	if(world.time > round_end_time)
		return 1
	return 0

/datum/game_mode/slayer/proc/auto_respawn()
	for(var/mob/observer/ghost/G in GLOB.ghost_mob_list)
		if(G.client)
			if(G.can_reenter_corpse != CORPSE_CAN_REENTER_AND_RESPAWN)
				to_chat(G,"<span class = 'danger'>You may now respawn.</span>")
				G.can_reenter_corpse = CORPSE_CAN_REENTER_AND_RESPAWN
				G.timeofdeath = 0
				nextrespawn = world.time + RESPAWN_TIME

/datum/game_mode/slayer/proc/auto_kill()
	for(var/mob/living/carbon/human/i in GLOB.player_list)
		if(i.stat == DEAD) continue
		var/health = i.maxHealth - i.getBruteLoss() - i.getFireLoss() - i.getToxLoss() - i.getCloneLoss()
		if(health <= (i.maxHealth/2))
			i.adjustBrainLoss(i.health+1)

/datum/game_mode/slayer/proc/get_outfit_datum(var/wanted_outfit_name)
	for(var/decl/hierarchy/outfit/outfit_decl in outfits_decls_)
		if(outfit_decl.name == wanted_outfit_name)
			return outfit_decl

/datum/game_mode/slayer/proc/get_assigned_species(var/job_name)
	for(var/species in species_included)
		var/list/species_job_list = species_included[species]
		if(job_name in species_job_list)
			return species

/datum/game_mode/slayer/proc/make_correct_species()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.species.name in species_included)
			continue
		var/new_species_name = get_assigned_species(H.mind.assigned_role) //Choose which species datum we're going to use.
		var/wanted_outfit_name = "[H.mind.assigned_role] [new_species_name]" //Create a string for the wanted outfit name
		var/decl/hierarchy/outfit/outfit = get_outfit_datum(wanted_outfit_name) //Get the outfit
		if(isnull(outfit))
			error("Slayer Outfitter failed to find outfit with outfit name [wanted_outfit_name]")
			return
		H.set_species(new_species_name)
		outfit.equip(H)

/datum/game_mode/slayer/process() //Used to allow respawns after few minutes. Also auto-kills people after a threshold.
	if(world.time >= nextrespawn)
		auto_respawn()
		auto_kill()
		make_correct_species()

/datum/game_mode/slayer/declare_completion()
	var/out_message = "<h1>The round is over! The scores were:</h1>"
	out_message += get_formatted_scores()
	to_world(out_message)

/datum/game_mode/slayer/proc/get_formatted_scores()
	var/return_message = ""
	for(var/team_name in team_scores_unsorted)
		return_message += "[team_name]: [team_scores_unsorted[team_name]]</br>"

	return return_message

/datum/game_mode/slayer/proc/get_team_name(var/datum/mob_lite/team_member)
	return team_member.name

//this is a bit hacky (it uses admin attack logging) but the alternative is writing a new system to do exactly the same thing
/datum/game_mode/slayer/handle_mob_death(var/mob/victim, var/list/args = list())
	var/datum/mob_lite/killer = victim.last_attacker_
	if(killer && killer.assigned_role in mode_teams)
		var/team_name = get_team_name(killer)
		if(!team_scores_unsorted[team_name])
			team_scores_unsorted[team_name] = 0
		if(killer.name != victim.name)
			team_scores_unsorted[team_name] += 1
			to_world("<h1>[victim.real_name] has been killed by [killer.name]: [team_name] ([team_scores_unsorted[team_name]] kills)</h1>")
	return 1
	/*if(!scores_with_names[killer.name]) //Can be used later for by-name scoring, commented out seeing as it's probably not needed right now.
		scores_with_names[killer.name] = 0
	if(killer.name == victim.name)
		scores_with_names[killer.name] -= 1
		to_world("<h2>[killer.name] has committed suicide!</h2>")
	else
		scores_with_names[killer.name] += 1*/
