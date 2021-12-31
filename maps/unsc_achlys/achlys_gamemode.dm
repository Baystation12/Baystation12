
/datum/game_mode/achlys
	name = "ONI Investigation: Achlys"
	round_description = "Destroy nav consoles and retrieve secret documents aboard the UNSC Achlys. Don't die."
	extended_round_description = "The UNSC Dante responds to a strange distress call aboard the UNSC Achlys. Their mission is to destroy the navigation computers and retrieve secret ONI research."
	config_tag = "achlys"
	votable = 0
	probability = 0
	allowed_ghost_roles = list(/datum/ghost_role/flood_prisoner)
	var/item_destroy_tag = "destroythis" //Map-set tags for items that need to be destroyed.
	var/list/items_to_destroy = list()
	var/item_retrieve_tag = "retrievethis" //Map-set tags for items that need to be retrieved.
	var/list/items_to_retrieve = list()
	var/list/item_success_tag = "retrieveto"//the tag of an object that when the documents are in the contents of, counts as success
	var/special_event_starttime = 0 //Used to determine if we should run the gamemode's "special event" (Currently just a comms cut-in). Is set to the time the event should start.
	var/start_comms_event = 0
	var/stop_comms_event = 0
	var/flood_spawn_event_minor
	var/flood_spawn_event_major
	var/obj/machinery/overmap_comms/jammer/spawned_jammer
	var/living_detachment = list()  //this is a collection of all marines and SL, if they die, mission over
	var/mode_config_deadline = 0 //This is set at mode-start and acts like a barrier to round-end. Allows for latespawns and mission config.
	var/has_configured = 0
	var/evac_deadline = 0		//this gets flipped to end the round in destruction


/datum/ghost_role/flood_prisoner

	mob_to_spawn = /mob/living/simple_animal/hostile/flood/combat_form/prisoner/crew
	objects_spawn_on = list(/obj/effect/landmark/flood_spawn,/obj/structure/biomass)
	respawn_time = 300

/datum/game_mode/achlys/proc/get_roles_from_faction(var/faction) //it's just pasta
	var/list/allowed_roles = list()
	if(faction == "Detachment")
		allowed_roles = DETACHMENT_ROLES
	else if (faction == "ONI")
		allowed_roles = ONI_ROLES
	else if (faction == "Covenant")
		allowed_roles = COVENANT_ROLES
	return allowed_roles

/datum/game_mode/achlys/proc/check_players_live(var/faction)
	var/list/live_players = list()
	var/list/allowed_roles = get_roles_from_faction(faction)
	for(var/mob/living/player in GLOB.player_list)
		if(player.z in GLOB.using_map.admin_levels)
			continue
		if(player.mind.assigned_role in allowed_roles)
			if(player.stat == CONSCIOUS)
				live_players += player
	return live_players

/datum/game_mode/achlys/handle_mob_death(var/mob/living/carbon/human/M, var/faction, var/list/args = list())
	ASSERT(M)

	var/datum/mind/D = M.mind
	if(!D)
		for(var/datum/mind/cur_mind in living_detachment)
			if(cur_mind.name == M.real_name)
				D = cur_mind
				break
	if(D)
		if(faction == "Detachment")
			living_detachment -= D
			return 1

	return ..()

/datum/game_mode/achlys/proc/populate_items_destroy()
	for(var/atom/destroy in world)
		if(destroy.tag == item_destroy_tag)
			items_to_destroy += destroy

/datum/game_mode/achlys/proc/populate_items_retrieve()
	for(var/atom/retrieve in world)
		if(retrieve.tag == item_retrieve_tag)
			items_to_retrieve += retrieve

/datum/game_mode/achlys/proc/populate_detachment_roles()
	//grab detachment roles, marines and SL
	for(var/title in DETACHMENT_ROLES)
		var/datum/job/achlys/job = job_master.occupations_by_title["Marine"]
		living_detachment += job.assigned_players

/datum/game_mode/achlys/proc/deactivate_unsc_jobs()
	for(var/title in DETACHMENT_ROLES + ONI_ROLES + MISC_UNSC_ROLES)
		var/datum/job/achlys/job = job_master.occupations_by_title[title]
		job.total_positions = 0

/datum/game_mode/achlys/pre_setup()
	..()
	GLOB.MOBILE_SPAWN_RESPAWN_TIME = -1 //Disable mobile respawns
	flood_spawn_event_minor = world.time + FLOOD_EVENT_MINOR_START
	flood_spawn_event_major = world.time + FLOOD_EVENT_MAJOR_START
	mode_config_deadline = world.time + MODE_CONFIG_DEADLINE_TIME
	start_comms_event = world.time + rand(COMMS_CUTIN_EVENT_MIN,COMMS_CUTIN_EVENT_MAX)
	stop_comms_event = start_comms_event + COMMS_CUTIN_EVENT_DURATION

/datum/game_mode/achlys/proc/slipspace_critical()
	to_world("<span class='danger'>The entire derelict violently shudders and lists forward heavily. The UNSC Achlys is about to have a severe and violent slipspace malfunction that will lurch the ship into oblivion.</span>")
	for(var/mob/M in GLOB.player_list)
		sound_to(M, 'code/modules/halo/sound/crash.ogg')
	do_flood_event_major()
	do_flood_event_major()
	evac_deadline = (world.time + EVAC_TIME)

/datum/game_mode/achlys/post_setup()
	..()

	//setup the comms jamming for the asteroid field
	var/obj/effect/overmap/sector/achlys/A = locate() in world
	ASSERT(istype(A))
	var/obj/effect/landmark/map_data = A.map_z_data[1]
	spawned_jammer = new /obj/machinery/overmap_comms/jammer (map_data.loc)
	spawned_jammer.jam_power = 20
	spawned_jammer.jam_range = 2

	//activate the jammer
	spawned_jammer.toggle_active()

/datum/game_mode/achlys/proc/handle_comms_jamming()
	//a comms window opens in the asteroid field
	if(world.time > start_comms_event)
		//reset the timer
		start_comms_event = stop_comms_event + rand(COMMS_CUTIN_EVENT_MIN,COMMS_CUTIN_EVENT_MAX)

		//deactivate the jammer
		spawned_jammer.toggle_active()

		//tell the players
		command_announcement.Announce("There is a brief burst of static across the ship's intercomms as the Fresnel zone clears up, allowing radio communications.")

	//the asteroid field is now blocking comms again
	if(world.time > stop_comms_event)
		//reset the timer
		stop_comms_event = start_comms_event + COMMS_CUTIN_EVENT_DURATION

		//activate the jammer
		spawned_jammer.toggle_active()

/*
25 minutes in: flood spore and spore growing appear across the Achlys area

35 minutes in: more spores and growing spores + tiny biomass spawn across the Achlys area with tiny biomass spawning only on floors

Repeat 35 minute mark every 15 minutes after 35 minutes is up.

All 3 of these cannot spawn on open space

30 spores, 10 spore growing. 8 tiny biomass per z


*/

/datum/game_mode/achlys/proc/do_flood_event_major()
	for(var/i = FLOOD_EVENT_Z_START to FLOOD_EVENT_Z_END) //The numbers here are the z-levels containing the area we want to search.
		var/list/valid_spawns = list()
		for(var/turf/t in block(locate(1,1,i),locate(world.maxx,world.maxy,i)))
			if(istype(t,/turf/simulated/open) || istype(t,/turf/space) || istype(t,/turf/simulated/wall) || istype(t,/turf/simulated/floor/reinforced/airless) || istype(t,/turf/simulated/floor/airless))
				continue
			valid_spawns += t
		if(valid_spawns.len == 0)
			continue
		for(var/iter = 0 to 8)
			new /obj/structure/biomass/tiny (pick(valid_spawns))

/datum/game_mode/achlys/proc/do_flood_event_minor()
	for(var/i = FLOOD_EVENT_Z_START to FLOOD_EVENT_Z_END) //The numbers here are the z-levels containing the area we want to search.
		var/list/valid_spawns = list()
		for(var/turf/t in block(locate(1,1,i),locate(world.maxx,world.maxy,i)))
			if(istype(t,/turf/simulated/open) || istype(t,/turf/space) || istype(t,/turf/simulated/floor/reinforced/airless) || istype(t,/turf/simulated/floor/airless))
				continue
			valid_spawns += t
		if(valid_spawns.len == 0)
			continue
		for(var/iter = 0 to 40)
			var/typepath_to_spawn = /obj/item/flood_spore
			if(iter > 30)
				typepath_to_spawn = /obj/item/flood_spore_growing
			new typepath_to_spawn (pick(valid_spawns))

/datum/game_mode/achlys/process()
	..()
	if(!has_configured)
		if(world.time >= mode_config_deadline)
			populate_items_destroy()
			populate_items_retrieve()
			populate_detachment_roles()
			deactivate_unsc_jobs()
			do_flood_event_major()
			has_configured = 1

	handle_comms_jamming()

	if(flood_spawn_event_major != 0 && world.time > flood_spawn_event_major)
		flood_spawn_event_minor = 1 //Trigger minor-event ASAP.
		flood_spawn_event_major = world.time + FLOOD_EVENT_REPEAT_TIME
		do_flood_event_major()

	if(flood_spawn_event_minor != 0 && world.time > flood_spawn_event_minor)
		flood_spawn_event_minor = 0
		do_flood_event_minor()

/datum/game_mode/achlys/proc/check_item_destroy_status()
	if(items_to_destroy.len == 0)
		. = 1
		return
	for(var/i in items_to_destroy)
		. = 0
		var/atom/item = i
		if(isnull(item) || item.loc == null)
			. = 1
		if(istype(item,/obj/machinery))
			var/obj/machinery/item_machine = item
			if(item_machine.stat & BROKEN)
				. = 1
		if(. == 0)
			return //One's alive, no reason to check further.

/datum/game_mode/achlys/proc/check_item_retrieve_status()
	. = 1
	var/atom/retrieval_loc = locate(item_success_tag)
	for(var/atom/movable/item in items_to_retrieve)
		if(!(item.loc == retrieval_loc))
			. = 0
/datum/game_mode/achlys/proc/kill_unevaced_players()
	for(var/mob/living/carbon/human/h in GLOB.player_list)
		if(h.z >= FLOOD_EVENT_Z_START && h.z <= FLOOD_EVENT_Z_END)
			qdel(h)

/datum/game_mode/achlys/check_finished()
	. = 0
	if(!has_configured)
		return
	var/list/detachment_alive = check_players_live("Detachment")
	//We don't care about the documents for mission-end, they're optional
	var/destroy_status = check_item_destroy_status()
	if(destroy_status == 1 && evac_deadline == 0)//This means we need to set our evac deadline.
		slipspace_critical()
	. = ((destroy_status == 1 || detachment_alive.len == 0) && world.time > evac_deadline)

/datum/game_mode/achlys/declare_completion()
	..()
	announce_win()

/datum/game_mode/achlys/proc/announce_win()
	var/text = ""
	kill_unevaced_players()
	var/list/living_players_detachment = check_players_live("Detachment")
	var/list/living_players_oni = check_players_live("ONI")
	var/was_success = check_item_destroy_status()
	var/success_counter = 0
	if(was_success)
		text += "<span class='info'>Cole Protocol has been enacted by the marine detachment and the UNSC Achlys has been destroyed. The galaxy has been spared the horrors onboard, but at what cost?</span><br>"
		success_counter += 2
	else
		text += "<span class='warning'>Cole Protocol has not been enacted and the mission was a failure.</span><br>"
	text += "<br>"
	if(living_players_oni.len == 0)
		text += "<span class='notice'>All ONI Operatives implanted within the detachment were lost during the events onboard the UNSC Achlys.</span><br>"
		success_counter += 1
	else
		text += "<span class='warning'>There are still remaining ONI Operatives within the detachment and what they will do in the near future will be in the name of keeping humanity safe...</span><br>"
	text += "<br>"
	if(living_players_detachment.len == 0)
		if(was_success)
			text += "<span class='notice'>Though the marines in the detachment were lost with all hands, their sacrifices were not in vain. Their mission was accomplished.</span><br>"
		else
			text += "<span class='warning'>Unfortunately all marines in the detachment were lost, their sacrifice will be remembered.</span><br>"
	else
		text += "<span class='notice'>A number of marines in the detachment survived their encounter aboard the UNSC Achlys and must live with what they've experienced.</span><br>"
		success_counter += 1
	text += "<br>"
	if(check_item_retrieve_status())
		text += "<span class = 'notice'>Valuable intel was obtained by the detachment, and returned to the Dante. Whilst much was redacted by ONI, some speculate that it greatly boosted the efforts in researching the Flood.</span>"
		success_counter += 2
	else
		text += "<span class = 'warning'>The detachment was unable to retrieve the research documents aboard the UNSC Achlys. Many lives were lost in recreating this valuable intel.</span>"
	text += "<br><br>"
	var/success_text = "Failure"
	if(success_counter > 1)
		success_text = "Minor Success"
	if(success_counter > 2)
		success_text = "Success"
	if(success_counter > 4)
		success_text = "Major Success"
	if(success_counter > 5)
		success_text = "Supreme Success"
	text += "<span class = 'danger'>Mission Status:\n[success_text]</span>"
	to_world(text)
	return 0
