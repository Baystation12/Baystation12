#define SD_FLOOR_TILE 0
#define SD_WALL_TILE 1
#define SD_DOOR_TILE 2
#define SD_EMPTY_TILE 3
#define SD_SUPPLY_TILE 7

/datum/random_map/droppod
	descriptor = "drop pod"
	initial_wall_cell = 0
	limit_x = 3
	limit_y = 3
	preserve_map = 0

	wall_type = /turf/simulated/wall/titanium
	floor_type = /turf/simulated/floor/reinforced
	var/list/supplied_drop_types = list()
	var/door_type = /obj/structure/droppod_door
	var/drop_type = /mob/living/simple_animal/parrot
	var/auto_open_doors

	var/placement_explosion_dev =   1
	var/placement_explosion_heavy = 2
	var/placement_explosion_light = 6
	var/placement_explosion_flash = 4

/datum/random_map/droppod/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/supplied_drop, var/list/supplied_drops, var/automated)

	if(supplied_drop)
		drop_type = supplied_drop
	else if(islist(supplied_drops) && supplied_drops.len)
		supplied_drop_types = supplied_drops
		drop_type = "custom"
	if(automated)
		auto_open_doors = 1

	//Make sure there is a clear midpoint.
	if(limit_x % 2 == 0) limit_x++
	if(limit_y % 2 == 0) limit_y++
	..()

/datum/random_map/droppod/generate_map()

	// No point calculating these 200 times.
	var/x_midpoint = n_ceil(limit_x / 2)
	var/y_midpoint = n_ceil(limit_y / 2)

	// Draw walls/floors/doors.
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(!current_cell)
				continue

			var/on_x_bound = (x == 1 || x == limit_x)
			var/on_y_bound = (y == 1 || y == limit_x)
			var/draw_corners = (limit_x < 5 && limit_y < 5)
			if(on_x_bound || on_y_bound)
				// Draw access points in midpoint of each wall.
				if(x == x_midpoint || y == y_midpoint)
					map[current_cell] = SD_DOOR_TILE
				// Draw the actual walls.
				else if(draw_corners || (!on_x_bound || !on_y_bound))
					map[current_cell] = SD_WALL_TILE
				//Don't draw the far corners on large pods.
				else
					map[current_cell] = SD_EMPTY_TILE
			else
				// Fill in the corners.
				if((x == 2 || x == (limit_x-1)) && (y == 2 || y == (limit_y-1)))
					map[current_cell] = SD_WALL_TILE
				// Fill in EVERYTHING ELSE.
				else
					map[current_cell] = SD_FLOOR_TILE

	// Draw the drop contents.
	var/current_cell = get_map_cell(x_midpoint,y_midpoint)
	if(current_cell)
		map[current_cell] = SD_SUPPLY_TILE
	return 1

/datum/random_map/droppod/apply_to_map()
	if(placement_explosion_dev || placement_explosion_heavy || placement_explosion_light || placement_explosion_flash)
		var/turf/T = locate((origin_x + n_ceil(limit_x / 2)-1), (origin_y + n_ceil(limit_y / 2)-1), origin_z)
		if(istype(T))
			explosion(T, placement_explosion_dev, placement_explosion_heavy, placement_explosion_light, placement_explosion_flash)
			sleep(15) // Let the explosion finish proccing before we ChangeTurf(), otherwise it might destroy our spawned objects.
	return ..()

/datum/random_map/droppod/get_appropriate_path(var/value)
	if(value == SD_FLOOR_TILE || value == SD_SUPPLY_TILE)
		return floor_type
	else if(value == SD_WALL_TILE)
		return wall_type
	else if(value == SD_DOOR_TILE )
		return wall_type
	return null

// Pods are circular. Get the direction this object is facing from the center of the pod.
/datum/random_map/droppod/get_spawn_dir(var/x, var/y)
	var/x_midpoint = n_ceil(limit_x / 2)
	var/y_midpoint = n_ceil(limit_y / 2)
	if(x == x_midpoint && y == y_midpoint)
		return null
	var/turf/target = locate(origin_x+x-1, origin_y+y-1, origin_z)
	var/turf/middle = locate(origin_x+x_midpoint-1, origin_y+y_midpoint-1, origin_z)
	if(!istype(target) || !istype(middle))
		return null
	return get_dir(middle, target)

/datum/random_map/droppod/get_additional_spawns(var/value, var/turf/T, var/spawn_dir)

	// Splatter anything under us that survived the explosion.
	if(value != SD_EMPTY_TILE && T.contents.len)
		for(var/atom/movable/AM in T)
			if(AM.simulated && !isobserver(AM))
				qdel(AM)

	// Also spawn doors and loot.
	if(value == SD_DOOR_TILE)
		var/obj/structure/S = new door_type(T, auto_open_doors)
		S.set_dir(spawn_dir)

	else if(value == SD_SUPPLY_TILE)
		get_spawned_drop(T)

/datum/random_map/droppod/proc/get_spawned_drop(var/turf/T)
	var/obj/structure/bed/chair/C = new(T)
	C.set_light(3, l_color = "#CC0000")
	var/mob/living/drop
	// This proc expects a list of mobs to be passed to the spawner.
	// Use the supply pod if you don't want to drop mobs.
	// Mobs will not double up; if you want multiple mobs, you
	// will need multiple drop tiles.
	if(islist(supplied_drop_types) && supplied_drop_types.len)
		while(supplied_drop_types.len)
			drop = pick(supplied_drop_types)
			supplied_drop_types -= drop
			if(istype(drop))
				drop.tag = null
				if(drop.buckled)
					drop.buckled = null
				drop.forceMove(T)
	else if(ispath(drop_type))
		drop = new drop_type(T)
		if(istype(drop))
			if(drop.buckled)
				drop.buckled = null
			drop.forceMove(T)

/datum/admins/proc/call_drop_pod()
	set category = "Fun"
	set desc = "Call an immediate drop pod on your location."
	set name = "Call Drop Pod"

	if(!check_rights(R_FUN)) return

	var/client/selected_player
	var/mob/living/spawned_mob
	var/list/spawned_mobs = list()

	var/spawn_path = input("Select a mob type.", "Drop Pod Selection", null) as null|anything in typesof(/mob/living)-/mob/living
	if(!spawn_path)
		return

	if(alert("Do you wish the mob to have a player?",,"No","Yes") == "No")
		var/spawn_count = input("How many mobs do you wish the pod to contain?", "Drop Pod Selection", null) as num
		if(spawn_count <= 0)
			return
		for(var/i=0;i<spawn_count;i++)
			var/mob/living/M = new spawn_path()
			M.tag = "awaiting drop"
			spawned_mobs |= M
	else
		var/list/candidates = list()
		for(var/client/player in GLOB.clients)
			if(player.mob && isghost(player.mob))
				candidates |= player

		if(!candidates.len)
			to_chat(usr, "There are no candidates for a drop pod launch.")
			return

		// Get a player and a mob type.
		selected_player = input("Select a player.", "Drop Pod Selection", null) as null|anything in candidates
		if(!selected_player)
			return

		// Spawn the mob in nullspace for now.
		spawned_mob = new spawn_path()
		spawned_mob.tag = "awaiting drop"

		// Equip them, if they are human and it is desirable.
		if(istype(spawned_mob, /mob/living/carbon/human))
			var/list/all_antag_types = all_antag_types()
			var/antag_type = input("Select an equipment template to use or cancel for nude.", null) as null|anything in all_antag_types
			if(antag_type)
				var/datum/antagonist/A = all_antag_types[antag_type]
				A.equip(spawned_mob)

	if(alert("Are you SURE you wish to deploy this drop pod? It will cause a sizable explosion and gib anyone underneath it.",,"No","Yes") == "No")
		if(spawned_mob)
			qdel(spawned_mob)
		if(spawned_mobs.len)
			for(var/mob/living/M in spawned_mobs)
				spawned_mobs -= M
				M.tag = null
				qdel(M)
			spawned_mobs.Cut()
		return

	// Chuck them into the pod.
	var/automatic_pod
	if(spawned_mob && selected_player)
		if(selected_player.mob.mind)
			selected_player.mob.mind.transfer_to(spawned_mob)
		else
			spawned_mob.ckey = selected_player.mob.ckey
		spawned_mobs = list(spawned_mob)
		message_admins("[key_name(usr)] dropped a pod containing \the [spawned_mob] ([spawned_mob.key]) at ([usr.x],[usr.y],[usr.z])")
		log_admin("[key_name(usr)] dropped a pod containing \the [spawned_mob] ([spawned_mob.key]) at ([usr.x],[usr.y],[usr.z])")
	else if(spawned_mobs.len)
		automatic_pod = 1
		message_admins("[key_name(usr)] dropped a pod containing [spawned_mobs.len] [spawned_mobs[1]] at ([usr.x],[usr.y],[usr.z])")
		log_admin("[key_name(usr)] dropped a pod containing [spawned_mobs.len] [spawned_mobs[1]] at ([usr.x],[usr.y],[usr.z])")
	else
		return

	new /datum/random_map/droppod(null, usr.x-1, usr.y-1, usr.z, supplied_drops = spawned_mobs, automated = automatic_pod)