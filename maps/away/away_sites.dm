// Hey! Listen! Update \config\away_site_blacklist.txt with your new ruins!

/datum/map_template/ruin/away_site
	var/spawn_weight = 1
	prefix = "maps/away/"

// Used to ensure unique and identifiable area names for overmapped away sites
/obj/effect/overmap/proc/renameAreas(area_type, map_name = null)
	if (map_name != null)
		SetName(map_name)
	
	var/list/area_list = area_repository.get_areas_by_name(area_type)
	var/area/a
	for (var/i = 1, i <= area_list.len, i++)
		a = area_list[i]
		world.log << "Prefixing '[name]' to '[a.name]'"
		a.SetName("\improper [name] - [a.name]")
		GLOB.using_map.area_purity_test_exempt_areas += a.type
	
	if (map_name != null)
		SetName("[name], \a [initial(name)]")
