
#define COMMS_CUTIN_EVENT_MIN 15 MINUTES
#define COMMS_CUTIN_EVENT_MAX 30 MINUTES
#define COMMS_CUTIN_EVENT_DURATION 1 MINUTES
#define FLOOD_EVENT_MINOR_START 25 MINUTES
#define FLOOD_EVENT_MAJOR_START 30 MINUTES
#define FLOOD_EVENT_REPEAT_TIME 15 MINUTES

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
	var/item_destroy_tag = "destroythis" //Map-set tags for items that need to be destroyed.
	var/list/items_to_destroy = list()
	var/item_retrieve_tag = "retrievethis" //Map-set tags for items that need to be retrieved.
	var/list/items_to_retrieve = list()
	var/list/item_success_tag = "retrieveto"//the tag of an object that when the documents are in the contents of, counts as success
	var/flood_spawn_event_minor
	var/flood_spawn_event_major
	var/obj/machinery/overmap_comms/jammer/spawned_jammer

/datum/ghost_role/flood_prisoner

	mob_to_spawn = /mob/living/simple_animal/hostile/flood/combat_form/prisoner/crew
	objects_spawn_on = list(/obj/effect/landmark/flood_spawn,/obj/structure/biomass)

/datum/game_mode/achlys/proc/populate_items_destroy()
	for(var/atom/destroy in world)
		if(destroy.tag == item_destroy_tag)
			items_to_destroy += destroy

/datum/game_mode/achlys/proc/populate_items_retrieve()
	for(var/atom/retrieve in world)
		if(retrieve.tag == item_retrieve_tag)
			items_to_retrieve += retrieve

/datum/game_mode/achlys/pre_setup()
	..()
	GLOB.MOBILE_SPAWN_RESPAWN_TIME = -1 //Disable mobile respawns
	flood_spawn_event_minor = world.time + FLOOD_EVENT_MINOR_START
	flood_spawn_event_major = world.time + FLOOD_EVENT_MAJOR_START
	populate_items_destroy()
	populate_items_retrieve()
	start_comms_event = world.time + rand(COMMS_CUTIN_EVENT_MIN,COMMS_CUTIN_EVENT_MAX)
	stop_comms_event = start_comms_event + COMMS_CUTIN_EVENT_DURATION

/datum/game_mode/achlys/post_setup()
	..()

	//setup the comms jamming for the asteroid field
	var/obj/effect/overmap/sector/achlys/A = locate() in world
	var/obj/effect/landmark/map_data = A.map_z_data[1]
	spawned_jammer = new /obj/machinery/overmap_comms/jammer (map_data.loc)

	//activate the jammer
	spawned_jammer.toggle_active()

/datum/game_mode/achlys/check_finished()
	. = 0
	. = ((check_item_destroy_status() && check_item_retrieve_status()) == 1)

/datum/game_mode/achlys/proc/check_item_destroy_status()
	if(items_to_destroy.len == 0)
		. = 1
		return
	for(var/atom/item in items_to_destroy)
		. = 0
		if(item.loc == null)
			. = 1
			return
		if(istype(item,/obj/machinery))
			var/obj/machinery/item_machine = item
			if(item_machine.stat & BROKEN)
				. = 1

/datum/game_mode/achlys/proc/check_item_retrieve_status()
	. = 1
	var/atom/retrieval_loc = locate(item_success_tag)
	for(var/atom/movable/item in items_to_retrieve)
		if(!(item.loc == retrieval_loc))
			. = 0
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

/datum/game_mode/achlys/declare_completion()
	..()
	to_world("<span class='warning'>Cole Protocol has been enacted. Marine victory.</span>")

/datum/game_mode/achlys/handle_mob_death(var/mob/victim, var/list/args = list())
	..()

#undef COMMS_CUTIN_EVENT_CHANCE
