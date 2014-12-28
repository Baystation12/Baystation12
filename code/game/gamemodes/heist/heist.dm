/*
HEIST ROUNDTYPE
*/

var/global/list/raider_spawn = list()
var/global/list/obj/cortical_stacks = list() //Stacks for 'leave nobody behind' objective. Clumsy, rewrite sometime.

/datum/game_mode/
	var/list/datum/mind/raiders = list()  //Antags.
	var/list/raid_objectives = list()     //Raid objectives

/datum/game_mode/heist
	name = "heist"
	config_tag = "heist"
	required_players = 1
	required_players_secret = 1
	required_enemies = 1
	recommended_enemies = 1
	votable = 1

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)

/datum/game_mode/heist/announce()
	world << "<B>The current game mode is - Heist!</B>"
	world << "<B>An unidentified bluespace signature has slipped past the Icarus and is approaching [station_name()]!</B>"
	world << "Whoever they are, they're likely up to no good. Protect the crew and station resources against this dastardly threat!"
	world << "<B>Raiders:</B> Loot [station_name()] for anything and everything you need."
	world << "<B>Personnel:</B> Repel the raiders!"

/datum/game_mode/heist/can_start()

	if(!..())
		return 0

	var/list/candidates = get_players_for_role(BE_RAIDER)
	var/raider_num = 0

	//Check that we have enough raiders.
	if(candidates.len < required_enemies)
		return 0
	else if(candidates.len < recommended_enemies)
		raider_num = candidates.len
	else
		raider_num = recommended_enemies

	//Grab candidates randomly until we have enough.
	while(raider_num > 0)
		var/datum/mind/new_raider = pick(candidates)
		raiders += new_raider
		candidates -= new_raider
		raider_num--

	for(var/datum/mind/raider in raiders)
		raider.assigned_role = "MODE"
		raider.special_role = "Raider"
	return 1

/datum/game_mode/heist/pre_setup()
	return 1

/datum/game_mode/heist/post_setup()

	//Generate objectives for the group.
	if(!config.objectives_disabled)
		raid_objectives = forge_raid_objectives()

	var/index = 1

	//Spawn the raider!
	for(var/datum/mind/raider in raiders)

		if(index > raider_spawn.len)
			index = 1

		raider.current.loc = raider_spawn[index]
		index++

		create_raider(raider)
		greet_raider(raider)

		if(!config.objectives_disabled && raid_objectives)
			raider.objectives = raid_objectives

	spawn (rand(waittime_l, waittime_h))
		send_intercept()

/datum/game_mode/proc/create_raider(var/datum/mind/newraider)
	var/mob/living/carbon/human/raider = newraider.current
	raider.equip_raider()

/datum/game_mode/proc/is_raider_crew_safe()

	/*if(cortical_stacks.len == 0)
		return 0

	for(var/datum/organ/internal/stack/vox/stack in cortical_stacks)
		if(stack.organ_holder && get_area(stack.organ_holder) != locate(/area/shuttle/vox/station))
			return 0*/
	return 1

/datum/game_mode/proc/is_raider_crew_alive()

	for(var/datum/mind/raider in raiders)
		if(raider.current)
			if(istype(raider.current,/mob/living/carbon/human) && raider.current.stat != 2)
				return 1
	return 0

/datum/game_mode/proc/forge_raid_objectives()

	var/i = 1
	var/max_objectives = pick(2,2,2,2,3,3,3,4)
	var/list/objs = list()
	while(i<= max_objectives)
		var/list/goals = list("kidnap","loot","salvage")
		var/goal = pick(goals)
		var/datum/objective/heist/O

		if(goal == "kidnap")
			goals -= "kidnap"
			O = new /datum/objective/heist/kidnap()
		else if(goal == "loot")
			O = new /datum/objective/heist/loot()
		else
			O = new /datum/objective/heist/salvage()
		O.choose_target()
		objs += O

		i++
	return objs

/datum/game_mode/proc/greet_raider(var/datum/mind/raider)
	spawn(0)
		raider.current << "<span class='notice'><B>You are a Raider, fresh from lawless space!</b></span>"
		raider.current << "It's been a long trip, but [station_name] is ripe for the picking! Try not to kill too many people or damage it too badly; you might want to come back."
		show_objectives(raider)
		if(is_alien_whitelisted(raider.current, "Vox"))
			raider.current << "<span class='danger'>You are whitelisted for Vox. If you wish to become one, visit the bathroom in the pirate base and use the mirror.</span>"
			raider.current << "<span class='danger'>There's some armour and weapons hidden away to the rear of the base for alien hands.</span>"

/datum/game_mode/heist/declare_completion()

	//No objectives, go straight to the feedback.
	if(!(raid_objectives.len)) return ..()

	var/win_type = "Major"
	var/win_group = "Crew"
	var/win_msg = ""

	var/success = raid_objectives.len

	//Decrease success for failed objectives.
	for(var/datum/objective/O in raid_objectives)
		if(!(O.check_completion())) success--

	//Set result by objectives.
	if(success == raid_objectives.len)
		win_type = "Major"
		win_group = "Raiders"
	else if(success > 2)
		win_type = "Minor"
		win_group = "Raiders"
	else
		win_type = "Minor"
		win_group = "Crew"

	//Now we modify that result by the state of the raiders.
	if(!is_raider_crew_alive())

		win_type = "Major"
		win_group = "Crew"
		win_msg += "<B>The Raiders have been wiped out!</B>"

	else if(!is_raider_crew_safe())

		if(win_group == "Crew" && win_type == "Minor")
			win_type = "Major"

		win_group = "Crew"
		win_msg += "<B>The Raiders have left someone behind!</B>"

	else

		if(win_group == "Raiders")
			if(win_type == "Minor")

				win_type = "Major"
			win_msg += "<B>The Raiders escaped the station!</B>"
		else
			win_msg += "<B>The Raiders were repelled!</B>"

	world << "\red <FONT size = 3><B>[win_type] [win_group] victory!</B></FONT>"
	world << "[win_msg]"
	feedback_set_details("round_end_result","heist - [win_type] [win_group]")

	var/count = 1
	for(var/datum/objective/objective in raid_objectives)
		if(objective.check_completion())
			world << "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
			feedback_add_details("traitor_objective","[objective.type]|SUCCESS")
		else
			world << "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
			feedback_add_details("traitor_objective","[objective.type]|FAIL")
		count++

	..()

datum/game_mode/proc/auto_declare_completion_heist()
	if(raiders.len)
		//var/check_return = 0
		//if(ticker && istype(ticker.mode,/datum/game_mode/heist))
			//check_return = 1
		var/text = "<FONT size = 2><B>The raiders were:</B></FONT>"

		for(var/datum/mind/raider in raiders)
			text += "<br>[raider.key] was [raider.name] ("
			/*if(check_return)
				var/obj/stack = raiders[raider]
				if(get_area(stack) != locate(/area/shuttle/vox/station))
					text += "left behind)"
					continue*/
			if(raider.current)
				if(raider.current.stat == DEAD)
					text += "died"
				else
					text += "survived"
				if(raider.current.real_name != raider.name)
					text += " as [raider.current.real_name]"
			else
				text += "body destroyed"
			text += ")"

		world << text
	return 1

/datum/game_mode/heist/check_finished()
	var/datum/shuttle/multi_shuttle/skipjack = shuttle_controller.shuttles["Skipjack"]
	if (!(is_raider_crew_alive()) || (skipjack && skipjack.returned_home))
		return 1
	return ..()

/datum/game_mode/heist/cleanup()
	//the skipjack and everything in it have left and aren't coming back, so get rid of them.
	var/area/skipjack = locate(/area/shuttle/skipjack/station)
	for (var/mob/living/M in skipjack.contents)
		del(M)
	for (var/obj/O in skipjack.contents)
		del(O)	//no hiding in lockers or anything