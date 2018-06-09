var/global/datum/ghost_role_manager/ghost_role_manager = new /datum/ghost_role_manager

/datum/ghost_role_manager
	var/list/ghost_roles = list()

/datum/ghost_role_manager/proc/get_all_roles()
	if(isnull(ticker.mode))
		return
	for(var/role in ticker.mode.allowed_ghost_roles)
		ghost_roles += new role


/datum/ghost_role_manager/proc/recieve_ghost_input(var/mob/observer/ghost/ghost,var/ghost_input)
	if(isnull(ticker.mode))
		to_chat(ghost,"<span class = 'notice'>Wait until roundstart!</span>")
		return
	if(ghost_input == "Cancel")
		to_chat(ghost,"<span class = 'notice'>Ghost role selection cancelled.</span>")
		return
	else
		var/datum/ghost_role/ghost_role_datum = ghost_input
		if(isnull(ghost_role_datum))
			to_chat(ghost,"<span class = 'notice'>There was an error in ghost role selection.</span>")
			return
		ghost_role_datum.spawn_role(ghost)

//Ghost Role Definitions//

/datum/ghost_role
	var/mob/mob_to_spawn
	var/list/objects_spawn_on = list()
	var/always_spawnable = 1 //Defines if the role should always have a valid spawn point

/datum/ghost_role/proc/unique_role_checks(var/mob/observer/ghost/ghost,var/list/possible_spawns)//Used to check some special circumstances, like welded vents for mice.
	return 1

/datum/ghost_role/proc/spawn_role(var/mob/observer/ghost/ghost)
	var/list/possible_spawns = list()
	for(var/obj/O in world)
		if(O.type in objects_spawn_on)
			possible_spawns += O
	if(possible_spawns.len == 0)
		if(always_spawnable)
			log_admin("ERROR: ([ghost.ckey]/[ghost.name]) attempted to spawn as a [src], but had no valid spawnobjects.")
		to_chat(ghost,"<span class = 'notice'>No locations to spawn your mob!.</span>")
		return
	if(!unique_role_checks(ghost,possible_spawns))
		return
	var/obj/chosen_spawn = pick(possible_spawns)
	do_spawn(ghost,chosen_spawn)

/datum/ghost_role/proc/post_spawn(var/mob/observer/ghost/ghost,var/obj/chosen_spawn,var/mob/created_mob)//Used for any sort of after-spawn effects. EG: Flood form name designation.

/datum/ghost_role/proc/do_spawn(var/mob/observer/ghost/ghost,var/obj/chosen_spawn)
	var/mob/created_mob = new mob_to_spawn
	created_mob.loc = chosen_spawn.loc
	created_mob.ckey = ghost.ckey
	post_spawn(ghost,chosen_spawn,created_mob)

//Converted Mouse Ghost Role//

/datum/ghost_role/mouse
	mob_to_spawn = /mob/living/simple_animal/mouse
	objects_spawn_on = list(/obj/machinery/atmospherics/unary/vent_pump)

/datum/ghost_role/mouse/unique_role_checks(var/mob/observer/ghost/ghost,var/list/possible_spawns)
	for(var/obj/O in possible_spawns)
		var/obj/machinery/atmospherics/unary/vent_pump/v = O
		if(v.welded || v.z != ghost.z)
			possible_spawns -= O
	if(possible_spawns.len == 0)
		to_chat(ghost,"<span class = 'warning'>There are no valid unwelded vents to spawn at.</span>")
		return 0
	return 1

/datum/ghost_role/mouse/spawn_role(var/mob/observer/ghost/g)
	if(config.disable_player_mice)
		to_chat(g, "<span class='warning'>Spawning as a mouse is currently disabled.</span>")
		return

	if(!g.MayRespawn(1, ANIMAL_SPAWN_DELAY))
		return

	var/turf/T = get_turf(g)
	if(!T || (T.z in GLOB.using_map.admin_levels))
		to_chat(g, "<span class='warning'>You may not spawn as a mouse on this Z-level.</span>")
		return

	return ..(g)

/datum/ghost_role/mouse/post_spawn(var/mob/observer/ghost/ghost,var/obj/chosen_spawn,var/mob/living/simple_animal/mouse/created_mob)
	created_mob.status_flags |= NO_ANTAG
	if(config.uneducated_mice)
		created_mob.universal_understand = 0
