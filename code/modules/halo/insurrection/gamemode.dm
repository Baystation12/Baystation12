/*
UNSC Insurrection roundtype
*/

//the unique loaded insurrection base
var/obj/effect/overmapobj/innie_base

/datum/game_mode/insurrection
	name = "Insurrection"
	config_tag = "insurrection"
	required_players = 0
	required_enemies = 0
	end_on_antag_death = 0
	end_on_protag_death = 0
	round_description = "A UNSC ship has been dispatched to eliminate a secret Insurrection base. The insurrectionists are far from defenceless however..."
	antag_tags = list(MODE_INNIE, MODE_INNIE_TRAITOR)
	hub_descriptions = list("putting down the Insurrection", "securing a hidden rebel base", "pacifying the outer colonies")

	var/list/innie_base_paths = list('maps/innie_base1.dmm','maps/innie_base2.dmm')		//make sure these are in the order from top level -> bottom level
	var/obj/effect/overmapobj/innie_base_reference
	var/innie_base_discovered = 0
	var/nuke_result = -1
	var/minutes_to_detect_innie_base = 0.5
	var/time_autofind_innie_base = 0
	var/announced_innie_base_loc = 0

/*
//delete all nuke disks not on a station zlevel
/datum/game_mode/insurrection/proc/check_nuke_disks()
	for(var/obj/item/weapon/disk/nuclear/N in nuke_disks)
		if(isNotStationLevel(N.z)) qdel(N)

//checks if L has a nuke disk on their person
/datum/game_mode/insurrection/proc/check_mob(mob/living/L)
	for(var/obj/item/weapon/disk/nuclear/N in nuke_disks)
		if(N.storage_depth(L) >= 0)
			return 1
	return 0
*/

/datum/game_mode/insurrection/pre_setup()
	//load Insurrection base zlevel
	if(!innie_base)
		//this is advanced mode: just assume the overmapobj has already been setup with everything it needs
		innie_base = locate("Insurrection Asteroid Base")

	if(!innie_base)
		//automatically load the map from file and prepare it for the round
		to_world("<span class='danger'>Loading Insurrectionist base, please stand by...</span>")
		var/starttime = world.time
		for(var/level_path in innie_base_paths)

			var/obj/effect/overmapobj/loaded_obj = overmap_controller.load_premade_map(level_path, innie_base)
			loaded_obj.hide_vehicles = 1
			if(innie_base)
				innie_base.linked_zlevelinfos.Add(loaded_obj.linked_zlevelinfos)
				qdel(loaded_obj)
			else
				innie_base = loaded_obj

		if(innie_base)
			innie_base.name = "Insurrection Asteroid Base"
			innie_base.tag = "Insurrection Asteroid Base"
			innie_base.icon = 'code/modules/overmap/ships/sector_icons.dmi'
			innie_base.icon_state = "listening_post"
			innie_base.sensor_icon_state = "rebelfist"
			innie_base.faction = "Insurrection"
			overmap_controller.antagonist_home = innie_base

			//link all the levels together
			for(var/obj/effect/zlevelinfo/data in innie_base.linked_zlevelinfos)
				data.name = innie_base.tag
				map_sectors["[data.z]"] = innie_base

			to_world("<span class='danger'>Done ([(world.time - starttime)/10]s).</span>")

	//grab a rantom antag datum and reload the antagonist spawn locations
	//this is a really odd way of doing things
	var/datum/antagonist/antagonist = antag_templates[1]
	antagonist.get_starting_locations()

	if(innie_base)
		insurrection_objectives = list()
		insurrection_objectives |= new /datum/objective/insurrection_killcrew
		insurrection_objectives |= new /datum/objective/insurrection_nuke
		innie_base_reference = innie_base

	else
		to_world("<span class='danger'>Could not load Insurrectionist base!</span>")
		return 0

	return ..()

/datum/game_mode/insurrection/post_setup()
	time_autofind_innie_base = world.time + minutes_to_detect_innie_base * 60 * 10
	//overmap_controller.current_starsystem.name = pick(insurrection_systems)

	to_world("<span class='danger'>Spawning random Insurrectionist shuttles...</span>")
	var/starttime = world.time
	sleep(1)

	//get all berths
	var/list/berths = list()
	for(var/obj/effect/roundstart_innie_shuttle_spawner/S in world)
		//it's an individual one so just spawn it straightaway
		if(!S.berth_tag)
			S.spawnme()
		else
			//group all spawners with the same berth_tag so we can go over them later
			if(!berths[S.berth_tag])
				berths[S.berth_tag] = list()
			var/list/spawnlist = berths[S.berth_tag]
			spawnlist.Add(S)

	//pick a random point on the berth
	for(var/berthtag in berths)
		var/list/spawnlist = berths[berthtag]
		var/obj/effect/roundstart_innie_shuttle_spawner/S = pick(spawnlist)
		S.spawnme()
		//to_world("[spawnlist.len] spawners with berthtag \"[berthtag]\", one chosen had dir:[S.dir]")

		//delete the remaining spawners
		for(S in spawnlist)
			qdel(S)

	to_world("<span class='danger'>	Done spawning innie shuttles ([(world.time - starttime)/10]).</span>")

	return ..()

/datum/game_mode/insurrection/process()
	if(world.time > time_autofind_innie_base && !announced_innie_base_loc)
		oni_report_base_coords()
	..()

/datum/game_mode/insurrection/proc/oni_report_base_coords()
	announced_innie_base_loc = 1

	if(innie_base)
		var/report_text = "<FONT size = 3><B>ONI Intelligence Report:</B> Mission critical status update:</FONT><HR>"
		report_text += "Radio listening stations in your system have managed to triangulate the location of \
		the Insurrection base you are hunting for in a nearby asteroid field.<br>"
		report_text += "<BR>"
		report_text += "The coordinates of the hidden Insurrection asteroid base are: <B>[innie_base.x],[innie_base.y]</B><br>"
		report_text += "<BR>"

		report_text += "Good luck on your mission, <i>[station_name()]</i>. \
		Remember we've got a stealth prowler on standby for retrieval if everything goes [pick("belly up","pear shaped","to hell")].<br>"

		for (var/obj/machinery/computer/communications/comm in machines)
			if (!(comm.stat & (BROKEN | NOPOWER)) && comm.prints_intercept)
				var/obj/item/weapon/paper/intercept = new /obj/item/weapon/paper( comm.loc )
				intercept.name = "ONI Intelligence Report"
				intercept.info = report_text

				comm.messagetitle.Add("ONI Intelligence Report")
				comm.messagetext.Add(report_text)
		to_world(sound('sound/AI/commandreport.ogg'))
		to_world("<span class='warning'>ONI has discovered the location of the hidden insurrection Base! The commanding officers of any UNSC warships in the area have surely been notified...</span>")
		overmap_controller.overmap_scanner_manager.add_station(innie_base)

/datum/game_mode/insurrection/handle_nuke_explosion()
	//todo: rework this proc
	//0: station hit (protagonist/unsc ship)
	//1: nuke near station (insurrection base)
	//2: nuke missed
	//lets say option 1 for innie base blown up, option 2 for UNSC ship blown up
	nuke_result = 2
	if(nuked_zlevel)
		if(overmap_controller.protagonist_home && nuked_zlevel in overmap_controller.protagonist_home.linked_zlevelinfos)
			nuke_result = 0
		if(innie_base && nuked_zlevel in innie_base.linked_zlevelinfos)
			nuke_result = 1

	ticker.station_explosion_cinematic(nuke_result,null)
	return 1

/datum/game_mode/insurrection/check_finished()
	. = ..()

	if(protags_are_dead)
		for(var/datum/objective/insurrection_killcrew/killcrew in insurrection_objectives)
			killcrew.completed = 1

/*
/datum/game_mode/insurrection/can_start()
	//fail and return to lobby
	if(!innie_base)
		to_world("<span class='danger'>[innie_base_paths[1]] not loaded</span>")

	return ..()
	*/

/datum/game_mode/insurrection/declare_completion()
	if(config.objectives_disabled)
		return

	var/innie_score = 0
	var/unsc_score = 0
	var/list/result_text = list()

	switch(nuke_result)
		if(0)
			//UNSC ship destroyed
			innie_score += 2
			unsc_score -= 2
			result_text.Add("<span class='rose'>- Insurrection operatives have destroyed the UNSC ship (2 pts).</span>")

			for(var/datum/objective/insurrection_nuke/nuke in insurrection_objectives)
				nuke.completed = 1

		if(1)
			//innie base destroyed
			unsc_score += 2
			innie_score -= 2
			result_text.Add("<span class='khaki'>- The UNSC have destroyed the Insurrection base (2 pts).</span>")

	if(antags_are_dead)
		unsc_score += 1
		innie_score -= 1
		result_text.Add("<span class='khaki'>- The insurrectionists are all dead (1 pt).</span>")

	if(protags_are_dead)
		innie_score += 1
		unsc_score -= 1
		result_text.Add("<span class='rose'>- The UNSC crew are all dead (1 pt).</span>")
		/*for(var/datum/objective/insurrection_capture/O in global_objectives)
			O.completed = 1*/

	//todo: score bonus if it was a short round

	//work out who won
	var/win_faction = ""
	var/win_type = ""
	var/winning_score = 0

	if(unsc_score > innie_score)
		winning_score = unsc_score
		win_faction = "UNSC "
	else if(innie_score > unsc_score)
		winning_score = innie_score
		win_faction = "Insurrection "
	else
		win_type = "Draw!"

	if(winning_score >= 4)
		win_type = "Supreme Victory!"
	else if(winning_score >= 3)
		win_type = "Major Victory!"
	else if(winning_score >= 2)
		win_type = "Moderate Victory!"
	else
		win_type = "Minor Victory!"

	feedback_set_details("round_end_result","[win_faction][win_type] - score: [winning_score]")
	to_world("<span class='info'>UNSC score: [unsc_score] points, Insurrection score: [innie_score] points</span>")
	to_world("<span class='infobold'>Result is: [win_faction][win_type]</span>")
	for(var/entry in result_text)
		to_world(entry)

	//get rid of the innie base
	overmap_controller.recycle_omapobj(innie_base)
	innie_base = null

	..()
	return
