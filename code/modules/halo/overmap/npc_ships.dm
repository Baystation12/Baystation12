
#define NPC_SHIP_LOSE_DELAY 20 MINUTES
#define ON_PROJECTILE_HIT_MESSAGES list(\
"We're taking fire. Requesting assistance from nearby ships! Repeat; Taking fire!",\
"Our hull has been breached! Help!",\
"Sweet hell, is this what we pay our taxses for?!","We're on your side!","Please, we're unarmed!","Oh god, they're firing on us!",\
"This is the captain of F-H-419, we're being fired upon. Requesting assistance.","PLEASE! WE HAVE FAMILIES!"\
)
#define ON_DEATH_MESSAGES list(\
"Do you feel like a hero yet?","Oof-",\
"You bastards.","Automated Alert: Fuel lines damaged. Multiple hull breaches. Immediate assistance required."\
)
#define ALL_CIVILLIAN_SHIPNAMES list(\
"Pete's Cube","The Nomad","The Messenger","Slow But Steady","Road Less Travelled","Dawson's Christian","Flexi Taped","Paycheck","Distant Home"\
)

#define STOP_WAIT_TIME 10 MINUTES
#define STOP_DISEMBARK_TIME 2 MINUTES

/obj/effect/overmap/ship/npc_ship
	name = "Ship"
	desc = "A ship, Duh."

	icon = 'code/modules/halo/overmap/freighter.dmi'
	icon_state = "ship"

	var/list/messages_on_hit = ON_PROJECTILE_HIT_MESSAGES
	var/list/messages_on_death = ON_DEATH_MESSAGES

	var/hull = 100 //Essentially used to tell the ship when to "stop" trying to move towards it's area.

	var/move_delay = 6 SECONDS //The amount of ticks to delay for when auto-moving across the system map.
	var/turf/target_loc

	var/unload_at = 0
	var/list/ship_datums = list(/datum/npc_ship)
	var/datum/npc_ship/chosen_ship_datum

	var/list/projectiles_to_spawn = list()

/obj/effect/overmap/ship/npc_ship/proc/can_board() //So this sort of stuff can be overidden later down the line for things like cargo shuttles.
	if(hull < initial(hull)/4)
		return 1
	if(isnull(target_loc))
		return 1
	return 0

/obj/effect/overmap/ship/npc_ship/proc/lose_to_space()
	if(hull > initial(hull)/4)//If they still have more than quarter of their "hull" left, let them drift in space.
		return
	for(var/mob/player in GLOB.player_list)
		if(player.z in map_z)
			return //Don't disappear if there's people aboard.
	for(var/z_level in map_z)
		shipmap_handler.free_map(z_level)
		map_z -= z_level
	GLOB.processing_objects -= src
	qdel(src)

/obj/effect/overmap/ship/npc_ship/proc/generate_ship_name()
	name = pick(ALL_CIVILLIAN_SHIPNAMES)

/obj/effect/overmap/ship/npc_ship/Initialize()
	var/turf/start_turf = locate(x,y,z)
	. = ..()
	map_z.Cut()
	forceMove(start_turf)
	pick_target_loc()
	generate_ship_name()

/obj/effect/overmap/ship/npc_ship/proc/pick_target_loc()

	var/n_x = rand(1, GLOB.using_map.overmap_size - 1)
	var/n_y = rand(1, GLOB.using_map.overmap_size - 1)

	target_loc = locate(n_x,n_y,GLOB.using_map.overmap_z)

/obj/effect/overmap/ship/npc_ship/process()
	is_still() //A way to ensure umbilicals break when we move.
	if(world.time >= unload_at && unload_at != 0)
		lose_to_space()
	if(hull > initial(hull)/4)
		if(loc == target_loc)
			pick_target_loc()
		else
			walk(src,get_dir(src,target_loc),move_delay)
			dir = get_dir(src,target_loc)
	else
		target_loc = null
		walk(src,0)

/obj/effect/overmap/ship/npc_ship/proc/broadcast_hit(var/ship_disabled = 0)
	var/message_to_use = pick(messages_on_hit)
	if(ship_disabled)
		message_to_use = pick(messages_on_death)
	GLOB.global_headset.autosay("[message_to_use]","[name]","EBAND")

/obj/effect/overmap/ship/npc_ship/proc/take_projectiles(var/obj/item/projectile/overmap/proj,var/add_proj = 1)
	if(add_proj)
		projectiles_to_spawn += proj
	hull -= proj.damage
	if(hull <= initial(hull)/4 && target_loc)
		broadcast_hit(1)
	else
		broadcast_hit()
	if(add_proj && hull <=0) // So we don't delete the ship from damage when it's loaded in.
		lose_to_space()

/obj/effect/overmap/ship/npc_ship/proc/pick_ship_datum()
	chosen_ship_datum = pick(ship_datums)
	chosen_ship_datum = new chosen_ship_datum

/obj/effect/overmap/ship/npc_ship/proc/load_mapfile()
	if(unload_at)
		return
	if(!chosen_ship_datum)
		pick_ship_datum()
	map_bounds = chosen_ship_datum.map_bounds
	fore_dir = chosen_ship_datum.fore_dir
	map_z = list()
	for(var/link in chosen_ship_datum.mapfile_links)
		to_world("Loading Ship-Map: [link]... This may cause lag.")
		sleep(10) //A small sleep to ensure the above message is printed before the loading operation commences.
		var/z_to_load_at = shipmap_handler.get_next_usable_z()
		shipmap_handler.un_free_map(z_to_load_at)
		spawn(-1)
			maploader.load_map(link,z_to_load_at)
			create_lighting_overlays_zlevel(z_to_load_at)
		map_z += z_to_load_at //The above proc will increase the maxz by 1 to accomodate the new map. This deals with that.
	for(var/zlevel in map_z)
		map_sectors["[zlevel]"] = src
	damage_spawned_ship()
	unload_at = world.time + NPC_SHIP_LOSE_DELAY
	GLOB.processing_objects += src

/obj/effect/overmap/ship/npc_ship/proc/damage_spawned_ship()
	for(var/obj/item/projectile/overmap/proj in projectiles_to_spawn)
		projectiles_to_spawn -= proj
		proj.do_z_level_proj_spawn(pick(map_z),src)
		qdel(proj)

/obj/effect/overmap/ship/npc_ship/proc/get_requestable_actions(var/authority_level)
	var/list/requestable_actions = list()
	if(authority_level >= AUTHORITY_LEVEL_UNSC)
		requestable_actions += "Cargo Inspection."
		requestable_actions += "Halt"
	return requestable_actions

/obj/effect/overmap/ship/npc_ship/proc/parse_action_request(var/request,var/mob/requester)
	if(request == "Cargo Inspection" || "Halt")
		target_loc = null
		GLOB.global_headset.autosay("Slowing down..\nI can only give you [STOP_WAIT_TIME/600] minutes.","[name]","System")
		spawn(STOP_WAIT_TIME)
			GLOB.global_headset.autosay("I need to leave now. I'll give you [STOP_DISEMBARK_TIME/600] minutes to disembark.","[name]","System")
			spawn(STOP_DISEMBARK_TIME)
				pick_target_loc()

/datum/npc_ship
	var/list/mapfile_links = list('maps/civ_hauler/civhauler.dmm')//Multi-z maps should be included in a bottom to top order.

	var/fore_dir = WEST //The direction of "fore" for the mapfile.
	var/list/map_bounds = list(1,50,50,1)//Used for projectile collision bounds for the selected mapfile.

#undef NPC_SHIP_LOSE_DELAY
#undef ON_PROJECTILE_HIT_MESSAGES
#undef ON_DEATH_MESSAGES
#undef ALL_CIVILLIAN_SHIPNAMES