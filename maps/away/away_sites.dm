// Hey! Listen! Update \config\away_site_blacklist.txt with your new ruins!

/datum/map_template/ruin/away_site
	var/spawn_weight = 1
	var/list/generate_mining_by_z
	prefix = "maps/away/"

/datum/map_template/ruin/away_site/after_load(z)
	if(islist(generate_mining_by_z))
		for(var/i in generate_mining_by_z)
			var/current_z = z + i - 1
			new /datum/random_map/automata/cave_system(null, 1, 1, current_z, world.maxx, world.maxy)
			new /datum/random_map/noise/ore(null, 1, 1, current_z, world.maxx, world.maxy)
			GLOB.using_map.refresh_mining_turfs(current_z)
	else if (isnum(generate_mining_by_z))
		new /datum/random_map/automata/cave_system(null, 1, 1, z + generate_mining_by_z - 1, world.maxx, world.maxy)
		new /datum/random_map/noise/ore(null, 1, 1, z + generate_mining_by_z - 1, world.maxx, world.maxy)
		GLOB.using_map.refresh_mining_turfs(z + generate_mining_by_z - 1)
