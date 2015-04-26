/*
VOX HEIST ROUNDTYPE
*/

var/global/list/raider_spawn = list()
var/global/list/obj/cortical_stacks = list() //Stacks for 'leave nobody behind' objective. Clumsy, rewrite sometime.

/datum/game_mode/
	var/list/datum/mind/raiders = list()  //Antags.
	var/list/raid_objectives = list()     //Raid objectives

/datum/game_mode/heist
	name = "heist"
	config_tag = "heist"
	required_players = 15
	required_players_secret = 25
	required_enemies = 4
	recommended_enemies = 6
	votable = 0

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)

/datum/game_mode/heist/announce()
	world << "<B>The current game mode is - Heist!</B>"
	world << "<B>An unidentified bluespace signature has slipped past the Icarus and is approaching [station_name()]!</B>"
	world << "Whoever they are, they're likely up to no good. Protect the crew and station resources against this dastardly threat!"
	world << "<B>Raiders:</B> Loot [station_name()] for anything and everything you need."
	world << "<B>Personnel:</B> Repel the raiders and their low, low prices and/or crossbows."

/datum/game_mode/heist/can_start()

	if(!..())
		return 0

	var/list/candidates = get_players_for_role(BE_RAIDER)
	var/raider_num = 0

	//Check that we have enough vox.
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
		raider.special_role = "Vox Raider"
	return 1

/datum/game_mode/heist/pre_setup()
	return 1

/datum/game_mode/heist/post_setup()

	//Generate objectives for the group.
	if(!config.objectives_disabled)
		raid_objectives = forge_vox_objectives()

	var/index = 1

	//Spawn the vox!
	for(var/datum/mind/raider in raiders)

		if(index > raider_spawn.len)
			index = 1

		raider.current.loc = raider_spawn[index]
		index++

		create_vox(raider)
		greet_vox(raider)

		if(!config.objectives_disabled && raid_objectives)
			raider.objectives = raid_objectives

	spawn (rand(waittime_l, waittime_h))
		send_intercept()

/datum/game_mode/proc/create_vox(var/datum/mind/newraider)


	var/sounds = rand(2,8)
	var/i = 0
	var/newname = ""

	while(i<=sounds)
		i++
		newname += pick(list("ti","hi","ki","ya","ta","ha","ka","ya","chi","cha","kah"))

	var/mob/living/carbon/human/vox = newraider.current

	vox.real_name = capitalize(newname)
	vox.name = vox.real_name
	newraider.name = vox.name
	vox.age = rand(12,20)
	vox.set_species("Vox")
	vox.languages = list() // Removing language from chargen.
	vox.flavor_text = ""
	vox.add_language("Vox-pidgin")
	vox.add_language("Galactic Common")
	vox.add_language("Tradeband")
	vox.h_style = "Short Vox Quills"
	vox.f_style = "Shaved"

	for(var/datum/organ/external/limb in vox.organs)
		limb.status &= ~(ORGAN_DESTROYED | ORGAN_ROBOT)

	// Add and keep track of their stack.
	new /datum/organ/internal/stack/vox(vox)
	if(vox.internal_organs_by_name["stack"])
		cortical_stacks |= vox.internal_organs_by_name["stack"]

	vox.equip_vox_raider()
	vox.regenerate_icons()

/datum/game_mode/proc/is_raider_crew_safe()

	if(cortical_stacks.len == 0)
		return 0

	for(var/datum/organ/internal/stack/vox/stack in cortical_stacks)
		if(stack.organ_holder && get_area(stack.organ_holder) != locate(/area/shuttle/vox/station))
			return 0
	return 1

/datum/game_mode/proc/is_raider_crew_alive()

	for(var/datum/mind/raider in raiders)
		if(raider.current)
			if(istype(raider.current,/mob/living/carbon/human) && raider.current.stat != 2)
				return 1
	return 0

/datum/game_mode/proc/forge_vox_objectives()

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

	//-All- vox raids have these two objectives. Failing them loses the game.
	objs += new /datum/objective/heist/inviolate_crew
	objs += new /datum/objective/heist/inviolate_death

	return objs

/datum/game_mode/proc/greet_vox(var/datum/mind/raider)
	raider.current << "\blue <B>You are a Vox Raider, fresh from the Shoal!</b>"
	raider.current << "\blue The Vox are a race of cunning, sharp-eyed nomadic raiders and traders endemic to the frontier and much of the unexplored galaxy. You and the crew have come to the Exodus for plunder, trade or both."
	raider.current << "\blue Vox are cowardly and will flee from larger groups, but corner one or find them en masse and they are vicious."
	raider.current << "\blue Use :V to voxtalk, :H to talk on your encrypted channel, and don't forget to turn on your nitrogen internals!"
	raider.current << "\red IF YOU HAVE NOT PLAYED A VOX BEFORE, REVIEW THIS THREAD: http://baystation12.net/forums/viewtopic.php?f=6&t=8657."
	show_objectives(raider)

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
		win_group = "Vox"
	else if(success > 2)
		win_type = "Minor"
		win_group = "Vox"
	else
		win_type = "Minor"
		win_group = "Crew"

	//Now we modify that result by the state of the vox crew.
	if(!is_raider_crew_alive())

		win_type = "Major"
		win_group = "Crew"
		win_msg += "<B>The Vox Raiders have been wiped out!</B>"

	else if(!is_raider_crew_safe())

		if(win_group == "Crew" && win_type == "Minor")
			win_type = "Major"

		win_group = "Crew"
		win_msg += "<B>The Vox Raiders have left someone behind!</B>"

	else

		if(win_group == "Vox")
			if(win_type == "Minor")

				win_type = "Major"
			win_msg += "<B>The Vox Raiders escaped the station!</B>"
		else
			win_msg += "<B>The Vox Raiders were repelled!</B>"

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
		var/check_return = 0
		if(ticker && istype(ticker.mode,/datum/game_mode/heist))
			check_return = 1
		var/text = "<FONT size = 2><B>The vox raiders were:</B></FONT>"

		for(var/datum/mind/vox in raiders)
			text += "<br>[vox.key] was [vox.name] ("
			if(check_return)
				var/obj/stack = raiders[vox]
				if(get_area(stack) != locate(/area/shuttle/vox/station))
					text += "left behind)"
					continue
			if(vox.current)
				if(vox.current.stat == DEAD)
					text += "died"
				else
					text += "survived"
				if(vox.current.real_name != vox.name)
					text += " as [vox.current.real_name]"
			else
				text += "body destroyed"
			text += ")"

		world << text
	return 1

/datum/game_mode/heist/check_finished()
	var/datum/shuttle/multi_shuttle/skipjack = shuttle_controller.shuttles["Vox Skipjack"]
	if (!(is_raider_crew_alive()) || (skipjack && skipjack.returned_home))
		return 1
	return ..()

/datum/game_mode/heist/cleanup()
	//the skipjack and everything in it have left and aren't coming back, so get rid of them.
	var/area/skipjack = locate(/area/shuttle/vox/station)
	for (var/mob/living/M in skipjack.contents)
		//maybe send the player a message that they've gone home/been kidnapped? Someone responsible for vox lore should write that.
		del(M)
	for (var/obj/O in skipjack.contents)
		del(O)	//no hiding in lockers or anything