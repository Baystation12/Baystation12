
#define NPC_SHIP_LOSE_DELAY 10 MINUTES
#define ON_PROJECTILE_HIT_MESSAGES list(\
"We're taking fire. Requesting assistance from nearby ships! Repeat; Taking fire!",\
"Our hull has been breached! Help!",\
"Sweet hell, is this what we pay our taxes for?!","We're on your side!","Please, we're unarmed!","Oh god, they're firing on us!",\
"PLEASE! WE HAVE FAMILIES!"\
)
#define ON_DEATH_MESSAGES list(\
"Do you feel like a hero yet?","Oof-",\
"You bastards.","Automated Alert: Fuel lines damaged. Multiple hull breaches. Immediate assistance required.","Automated Alert: CAPTAIN OVERRIDE: I think we just failed the vibe check."\
)
#define ALL_CIVILIANS_SHIPNAMES list(\
"Pete's Cube","The Nomad","The Alexander","Free Range","Heavenly Punisher","Sky Ruler","Bare Necessities","Arizona Killer","Iron Horse","Linebacker","Last Light","Hopes Eclipse","Fleeting Dawn","Titans Might","Despacito","Skippy","No True Scotsman","Blade Of Mars","Targeting Solution","Wooden Cat","The Cerberus","Message of Peace","Persian Persuader","Beowulf","Trojan Horse","Jade Dragon","Danger Zone","Bigger Stick","Fist of Sol","Hammerhead","Spirit of Jupiter","Trident","The Messenger","Slow But Steady","Road Less Travelled","Dawson's Christian","Flexi Taped","Paycheck","Distant Home","Mileage May Vary","Pimp Hand","Vibe Check"\
)

#define STOP_WAIT_TIME 5 MINUTES
#define STOP_DISEMBARK_TIME 2 MINUTES

#define BROADCAST_ON_HIT_PROB 20

#define ICON_FILES_PICKFROM list('code/modules/halo/overmap/freighter.dmi','code/modules/halo/icons/overmap/large_cargo_ship.dmi','code/modules/halo/icons/overmap/medical_ship.dmi','code/modules/halo/icons/overmap/mariner-class.dmi','code/modules/halo/icons/overmap/heavy_freighter.dmi')

#define LIGHTRANGE_LIKELY_UNUSED 99

#define FLEET_STICKBY_RANGE 2 //The max range a fleet-bound ship will stay from the fleet leader.
#define NPC_SHIP_TARGET_TOLERANCE 2 //At this range, the ship will start braking instead of accelerating.

/obj/effect/overmap/ship/npc_ship
	name = "Ship"
	desc = "A ship, Duh."

	icon = 'code/modules/halo/overmap/freighter.dmi'
	icon_state = "ship"

	var/list/ship_name_list = ALL_CIVILIANS_SHIPNAMES
	var/list/icons_pickfrom_list = ICON_FILES_PICKFROM

	var/list/messages_on_hit = ON_PROJECTILE_HIT_MESSAGES
	var/list/messages_on_death = ON_DEATH_MESSAGES
	var/radio_language = "Galactic Common"
	var/radio_channel = "System"

	var/hull = 1000 //Essentially used to tell the ship when to "stop" trying to move towards it's area.

	var/turf/target_loc

	var/unload_at = 0
	var/list/ship_datums = list(/datum/npc_ship/ccv_star)
	var/datum/npc_ship/chosen_ship_datum
	var/list/available_ship_requests = newlist(/datum/npc_ship_request/halt)

	var/list/projectiles_to_spawn = list()

	var/list/cargo_contained = list()

	var/list/cargo_containers = list()

	var/last_radio_time = 0
	var/radio_cooldown = 5 SECONDS
	var/next_message

/obj/effect/overmap/ship/npc_ship/proc/pick_ship_icon()
	var/list/icons_pickfrom = icons_pickfrom_list
	if(icons_pickfrom.len == 0)
		return
	icon = pick(icons_pickfrom)

/obj/effect/overmap/ship/npc_ship/proc/generate_ship_name()
	name = pick(ship_name_list)

/obj/effect/overmap/ship/npc_ship/Initialize()
	my_faction = GLOB.factions_by_name[get_faction()]
	generate_ship_name()
	pick_ship_icon()
	var/turf/start_turf = locate(x,y,z)
	. = ..()
	map_z.Cut()
	if(!isnull(start_turf))
		forceMove(start_turf)
	pick_target_loc()

/obj/effect/overmap/ship/npc_ship/proc/cargo_init()
	if(cargo_containers.len == 0 || cargo_contained.len == 0)
		return
	var/counter = 0
	var/objs_per_container = max((cargo_contained.len / cargo_containers.len),1)
	var/list/valid_containers = cargo_containers
	for(var/typepath in cargo_contained)
		var/obj/structure/closet/our_container
		if(counter >= objs_per_container || isnull(our_container))
			our_container.store_contents()
			our_container = pick(valid_containers)
			counter = 0
		if(cargo_contained.Find(typepath) == cargo_contained.len)
			our_container.store_contents()
		counter += 1
		var/obj/new_obj = new typepath
		new_obj.loc = our_container.loc

/obj/effect/overmap/ship/npc_ship/get_faction()
	if(!unload_at)
		return faction
	else if(nav_comp)
		return nav_comp.get_faction()
	else
		return null

/obj/effect/overmap/ship/npc_ship/proc/is_player_controlled()
	for(var/datum/npc_ship_request/player_controlled/pc in available_ship_requests)
		return 1
	return 0

/obj/effect/overmap/ship/npc_ship/proc/can_board() //So this sort of stuff can be overidden later down the line for things like cargo shuttles.
	if(is_player_controlled())
		return 1
	if(hull < initial(hull)/4)
		return 1
	if(isnull(target_loc) || target_loc = loc)
		return 1
	return 0

/obj/effect/overmap/ship/npc_ship/proc/radio_message(var/message, var/ignore_cooldown = 0)
	//check if we're still on cooldown from last radio message
	if(world.time >= last_radio_time + radio_cooldown || ignore_cooldown)
		last_radio_time = world.time
		GLOB.global_headset.autosay(message, src.name, radio_channel, radio_language)
	else
		//otherwise queue it up
		//note: if there is lots of radio spam some messages will be lost so only send the latest message
		next_message = message

/obj/effect/overmap/ship/npc_ship/proc/lose_to_space()
	if(hull > initial(hull)/4 || is_player_controlled())//If they still have more than quarter of their "hull" left, let them drift in space.
		return
	unload_at = world.time + NPC_SHIP_LOSE_DELAY / 2
	for(var/mob/player in GLOB.player_list)
		if(player.stat != DEAD)
			for(var/z_level in map_z)
				if("[player.z]" == "[z_level]")
					return//Don't disappear if there's people aboard.
	for(var/obj/docking_umbilical/umbi in connectors)//Don't disappear if we're docked with something
		if(umbi.current_connected)
			return
	for(var/z_level in map_z)
		shipmap_handler.free_map(z_level)
		map_z -= z_level
	GLOB.processing_objects -= src
	if(my_faction)
		my_faction.npc_ships -= src
	qdel(src)

/obj/effect/overmap/ship/npc_ship/proc/ship_targetedby_defenses()
	target_loc = pick(GLOB.overmap_tiles_uncontrolled)

/obj/effect/overmap/ship/npc_ship/proc/pick_target_loc()
	walk(src,0)
	if(isnull(loc))
		return
	if(our_fleet && our_fleet.leader_ship != src)
		target_loc = pick(range(FLEET_STICKBY_RANGE,our_fleet.leader_ship.loc))
		return
	var/list/sectors_onmap = list()
	for(var/type in typesof(/obj/effect/overmap/sector) - /obj/effect/overmap/sector)
		var/obj/effect/overmap/om_obj = locate(type)
		if(om_obj && !isnull(om_obj.loc) && om_obj.base && my_faction && !(om_obj.get_faction() in my_faction.enemy_factions)) //Only even try going if it's a "base" object
			sectors_onmap += om_obj
	if(sectors_onmap.len == 0)
		target_loc = pick(GLOB.overmap_tiles_uncontrolled)
	else
		var/obj/chosen = pick(sectors_onmap)
		var/list/turfs_nearobj = list()
		for(var/turf/unsimulated/map/t in range(7,chosen))
			if(istype(t,/turf/unsimulated/map/edge))
				continue
			turfs_nearobj += t
		if(turfs_nearobj.len > 0)
			target_loc = pick(turfs_nearobj)
		else
			target_loc = loc

/obj/effect/overmap/ship/npc_ship/can_burn()
	if(!is_player_controlled())
		return 1
	else
		return ..()

/obj/effect/overmap/ship/npc_ship/process()
	//despawn after a while
	if(world.time >= unload_at && unload_at != 0)
		lose_to_space()

	//a delay to chat messages
	if(next_message)
		if(world.time >= last_radio_time + radio_cooldown)
			radio_message(next_message)
			next_message = null

	if(hull > initial(hull)/4)
		var/stop_normal_operations = 0
		for(var/datum/npc_ship_request/request in available_ship_requests)
			if(request.request_requires_processing)
				stop_normal_operations = request.do_request_process(src)
		if(stop_normal_operations || is_player_controlled())
			return ..()
		if(!target_loc || is_still())
			pick_target_loc()
		if(get_dist(src,target_loc) < NPC_SHIP_TARGET_TOLERANCE)
			decelerate() //NPC ships process less often so we let them cheat with multiple calls at the same time.
			decelerate()
			decelerate()
		else
			accelerate(get_dir(src,target_loc))
			accelerate(get_dir(src,target_loc))
		break_umbilicals()
		if(our_fleet && our_fleet.leader_ship != src)
			pick_target_loc()
	else
		if(is_player_controlled())
			. = ..()
		if(target_loc)
			walk(src,0)
			target_loc = null

/obj/effect/overmap/ship/npc_ship/proc/broadcast_hit(var/ship_disabled = 0)
	var/message_to_use = pick(messages_on_hit)
	if(ship_disabled)
		message_to_use = pick(messages_on_death)
	radio_message("[message_to_use]")

/obj/effect/overmap/ship/npc_ship/proc/take_projectiles(var/obj/item/projectile/overmap/proj,var/add_proj = 1)
	if(add_proj)
		projectiles_to_spawn += proj
	if(is_player_controlled())
		return
	hull -= proj.damage
	if(hull <= initial(hull)/4 && target_loc)
		broadcast_hit(1)
		target_loc = null
	else
		if(prob(BROADCAST_ON_HIT_PROB)) //If we get the probability, broadcast the hit.
			broadcast_hit()

	if(add_proj && hull <=0) // So we don't delete the ship from damage when it's loaded in.
		lose_to_space()

/obj/effect/overmap/ship/npc_ship/proc/pick_ship_datum()
	chosen_ship_datum = pick(ship_datums)
	chosen_ship_datum = new chosen_ship_datum

/obj/effect/overmap/ship/npc_ship/proc/mapload_reset_lights(var/list/light_list)
	if(isnull(light_list))
		light_list = map_z
	var/list/lights_reset = list() //FORMAT light ref, original light val
	for(var/obj/machinery/light/light in GLOB.machines)
		if(!(text2num("[light.z]") in light_list))
			continue
		var/orig_range = light.light_range
		light.set_light(LIGHTRANGE_LIKELY_UNUSED)
		lights_reset[light] = "[orig_range]"
	var/datum/controller/process/lighting_controller = processScheduler.nameToProcessMap["lighting"]
	lighting_controller.doWork(0)
	for(var/obj/machinery/light/l in lights_reset)
		l.set_light(text2num(lights_reset[l]))

/obj/effect/overmap/ship/npc_ship/proc/load_mapfile()
	if(unload_at)
		return
	if(!chosen_ship_datum)
		pick_ship_datum()
	unload_at = world.time + NPC_SHIP_LOSE_DELAY
	map_bounds = chosen_ship_datum.map_bounds
	fore_dir = chosen_ship_datum.fore_dir
	map_z = list()
	lighting_overlays_initialised = FALSE
	for(var/link in chosen_ship_datum.mapfile_links)
		to_world("Loading Ship-Map: [link]... This may cause lag.")
		sleep(10) //A small sleep to ensure the above message is printed before the loading operation commences.
		var/z_to_load_at = shipmap_handler.get_next_usable_z()
		sleep(10) //Wait a tick again, to ensure te map is actually loaded in
		shipmap_handler.un_free_map(z_to_load_at)
		map_sectors["[z_to_load_at]"] = src
		maploader.load_map(link,z_to_load_at)
		var/obj/effect/landmark/map_data/md = new(locate(1,1,z_to_load_at))
		src.link_zlevel(md)
		map_z += z_to_load_at //The above proc will increase the maxz by 1 to accomodate the new map. This deals with that.
		create_lighting_overlays_zlevel(z_to_load_at)

	mapload_reset_lights()

	lighting_overlays_initialised = TRUE
	makepowernets()

	cargo_init()
	damage_spawned_ship()
	GLOB.processing_objects |= src
	superstructure_failing = 0 //If we had a process tick inbetween all of this, let's reset our superstructure failure status.

/obj/effect/overmap/ship/npc_ship/proc/damage_spawned_ship()
	for(var/obj/item/projectile/overmap/proj in projectiles_to_spawn)
		projectiles_to_spawn -= proj
		proj.do_z_level_proj_spawn(pick(map_z),src)
		qdel(proj)

/obj/effect/overmap/ship/npc_ship/proc/get_requestable_actions(var/authority_level)
	var/list/requestable_actions = list()
	. = requestable_actions
	for(var/datum/npc_ship_request/npc_ship_request in available_ship_requests)
		if(npc_ship_request.request_name == "")
			continue
		for(var/auth_level in npc_ship_request.request_auth_levels)
			if("[authority_level]" == "[auth_level]")
				requestable_actions += npc_ship_request.request_name
				break

/obj/effect/overmap/ship/npc_ship/proc/parse_action_request(var/request,var/mob/requester,var/auth_level)
	for(var/datum/npc_ship_request/npc_ship_request in available_ship_requests)
		if(request == npc_ship_request.request_name && auth_level in npc_ship_request.request_auth_levels)
			npc_ship_request.do_request(src,requester)

/datum/npc_ship_request
	var/request_name = "Request" //Name of the request. Use "" if you don't want it to appear in the request-list and merely want to use if for behind-the-scense processing.
	var/list/request_auth_levels = list()
	var/request_requires_processing = 0

/datum/npc_ship_request/proc/do_request(var/obj/effect/overmap/ship/npc_ship/ship_source,var/mob/requester)

/datum/npc_ship_request/proc/do_request_process(var/obj/effect/overmap/ship/npc_ship/ship_source) //Return 1 in this to stop normal NPC ship move processing.

/datum/npc_ship
	var/list/mapfile_links = list('maps/npc_ships/old/civhauler.dmm')//Multi-z maps should be included in a bottom to top order.

	var/fore_dir = WEST //The direction of "fore" for the mapfile.
	var/list/map_bounds = list(1,50,50,1)//Used for projectile collision bounds for the selected mapfile. Format: Topleft-x,Topleft-y,bottomright-x,bottomright-y

/datum/npc_ship/ccv_star
	mapfile_links = list('maps/npc_ships/old/CCV_Star.dmm')
	fore_dir = WEST
	map_bounds = list(1,50,50,1)

/datum/npc_ship/ccv_comet
	mapfile_links = list('maps/npc_ships/old/CCV_Comet.dmm')
	fore_dir = WEST
	map_bounds = list(1,50,50,1)

/datum/npc_ship/ccv_sbs
	mapfile_links = list('maps/npc_ships/old/CCV_Slow_But_Steady.dmm')
	fore_dir = WEST
	map_bounds = list(6,51,72,27)

/datum/npc_ship/unsc_patrol
	mapfile_links = list('maps/npc_ships/old/UNSC_Corvette.dmm')
	fore_dir = WEST
	map_bounds = list(7,70,54,29)

/datum/npc_ship/cov_patrol
	mapfile_links = list('maps/npc_ships/old/kigyar_missionary.dmm')
	fore_dir = WEST
	map_bounds = list(2,114,139,44)

#undef LIGHTRANGE_LIKELY_UNUSED
#undef NPC_SHIP_LOSE_DELAY
#undef ON_PROJECTILE_HIT_MESSAGES
#undef ON_DEATH_MESSAGES
#undef ALL_Civilian_SHIPNAMES
