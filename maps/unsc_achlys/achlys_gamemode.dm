
#define DETACHMENT_ROLES list("Marine","Squad Leader") //pilots don't count
#define ONI_ROLES list("ONI Operative")
#define COVENANT_ROLES list("Sangheili Prisoner") //no representation for human prisoner
#define COMMS_CUTIN_EVENT_MIN 15 MINUTES
#define COMMS_CUTIN_EVENT_MAX 30 MINUTES
#define COMMS_CUTIN_EVENT_DURATION 1 MINUTES
#define FLOOD_EVENT_MINOR_START 25 MINUTES
#define FLOOD_EVENT_MAJOR_START 30 MINUTES
#define FLOOD_EVENT_REPEAT_TIME 15 MINUTES
#define time_to_retreat 10 MINUTES

/datum/game_mode/achlys
	name = "ONI Investigation: Achlys"
	round_description = ""
	extended_round_description = ""
	config_tag = "achlys"
	votable = 0
	probability = 0
	allowed_ghost_roles = list(/datum/ghost_role/flood_prisoner)
	var/special_event_starttime = 0 //Used to determine if we should run the gamemode's "special event" (Currently just a comms cut-in). Is set to the time the event should start.
	var/start_comms_event = 0
	var/stop_comms_event = 0
	var/flood_spawn_event_minor
	var/flood_spawn_event_major
	var/obj/machinery/overmap_comms/jammer/spawned_jammer
	var/living_detachment = list()  //this is a collection of all marines and SL, if they die, mission over
	var/items_to_destroy = list()   //adjusted items to destroy so instances don't need tagged
	var/ruptured_slipspace = 0		//this gets flipped to end the round in destruction

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

/datum/game_mode/achlys/pre_setup()
	..()
	GLOB.MOBILE_SPAWN_RESPAWN_TIME = -1 //Disable mobile respawns
	flood_spawn_event_minor = world.time + FLOOD_EVENT_MINOR_START
	flood_spawn_event_major = world.time + FLOOD_EVENT_MAJOR_START
	start_comms_event = world.time + rand(COMMS_CUTIN_EVENT_MIN,COMMS_CUTIN_EVENT_MAX)
	stop_comms_event = start_comms_event + COMMS_CUTIN_EVENT_DURATION

/datum/game_mode/achlys/proc/slipspace_critical()
	to_world("<span class='danger'>The entire derelict violently shudders and lists forward heavily. The UNSC Achlys is about to have a severe and violent slipspace malfunction that will lurch the ship into oblivion.</span>")
	for(var/mob/M in GLOB.player_list)
		sound_to(M, 'code/modules/halo/sound/crash.ogg')
	ruptured_slipspace = (world.time + time_to_retreat)
		ruptured_slipspace = 1

/datum/game_mode/achlys/post_setup()
	..()
	//remember which items need destroyed
	for(var/obj/structure/navconsole/NC in world)
		NC += items_to_destroy

	//setup the comms jamming for the asteroid field
	var/obj/effect/overmap/sector/achlys/A = locate() in world
	var/obj/effect/landmark/map_data = A.map_z_data[1]
	spawned_jammer = new /obj/machinery/overmap_comms/jammer (map_data.loc)

	//activate the jammer
	spawned_jammer.toggle_active()

	//grab detachment roles, marines and SL
	var/datum/job/achlys/marine = job_master.occupations_by_title["Marine"]
	living_detachment += marine.assigned_players
	var/datum/job/achlys/sl = job_master.occupations_by_title["Squad Leader"]
	living_detachment += sl.assigned_players


/*
	start_comms_event = world.time + rand(COMMS_CUTIN_EVENT_MIN,COMMS_CUTIN_EVENT_MAX)
	stop_comms_event = stop_comms_event + COMMS_CUTIN_EVENT_DURATION
	*/

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

/datum/game_mode/achlys/process()
	..()

	handle_comms_jamming()

	if(flood_spawn_event_major != 0 && world.time > flood_spawn_event_major)
		flood_spawn_event_minor = world.time //Trigger minor-event ASAP.
		flood_spawn_event_major = world.time + FLOOD_EVENT_REPEAT_TIME
		for(var/i = 3 to 5)
			var/list/valid_spawns = list()
			for(var/turf/t in block(locate(1,1,i),locate(world.maxx,world.maxy,i)))
				if(istype(t,/turf/simulated/open) || istype(t,/turf/space) || istype(t,/turf/simulated/wall) || istype(t,/turf/simulated/floor/reinforced/airless) || istype(t,/turf/simulated/floor/airless))
					continue
				valid_spawns += t
			if(valid_spawns.len == 0)
				continue
			for(var/iter = 0 to 8)
				new /obj/structure/biomass/tiny (pick(valid_spawns))

	if(flood_spawn_event_minor != 0 && world.time > flood_spawn_event_minor)
		flood_spawn_event_minor = 0
		for(var/i = 3 to 5)
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

/datum/game_mode/achlys/proc/check_item_destroy_status()
	if(!items_to_destroy)
		slipspace_critical()

/datum/game_mode/achlys/check_finished()
	var/list/living_players_detachment = check_players_live("Detachment")
	if(living_players_detachment.len == 0 && !ruptured_slipspace)
		return 1 //if they did their job, the round can continue for the remaining 10 minutes
	else if(ruptured_slipspace)
		return 1

/datum/game_mode/achlys/declare_completion()
	..()
	announce_win()

/datum/game_mode/achlys/proc/announce_win()
	var/text = ""
	var/list/living_players_detachment = check_players_live("Detachment")
	var/list/living_players_oni = check_players_live("ONI")
	if(ruptured_slipspace)
		text += "<span class='info'>Cole Protocol has been enacted by the marine detachment and the UNSC Achlys has been destroyed. The galaxy has been spared the horrors onboard, but at what cost?</span><br>"
	else text += "<span class='warning'>Cole Protocol has not been enacted and the mission was a failure.</span><br>"
	text += "<br>"
	if(living_players_oni.len == 0)
		text += "<span class='notice'>All ONI Operatives implanted within the detachment were lost during the events onboard the UNSC Achlys.</span><br>"
	else text += "<span class='warning'>There are still remaining ONI Operatives within the detachment and what they will do in the near future will be in the name of keeping humanity safe...</span><br>"
	if(living_players_detachment.len == 0 && ruptured_slipspace)
		text += "<span class='warning'>Though the marines in the detachment were lost with all hands, their sacrifices were not in vain. Their mission was accomplished.</span><br>"
	else if(living_players_detachment.len == 0)
		text += "<span class='notice'>Unfortunately all marines in the detachment were lost, their sacrifice will be remembered.</span><br>"
	else
		text += "<span class='warning'>A number of marines in the detachment survived their encounter aboard the UNSC Achlys and must live with what they've experienced.</span><br>"
	to_world(text)
	return 0

#undef COMMS_CUTIN_EVENT_CHANCE
