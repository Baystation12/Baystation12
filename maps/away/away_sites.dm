// Hey! Listen! Update \config\away_site_blacklist.txt with your new ruins!

/datum/map_template/ruin/away_site
	var/spawn_weight = 1
	prefix = "maps/away/"

// Used to ensure unique and identifiable area names for overmapped away sites
/obj/effect/overmap/proc/renameAreas(area_type, map_name = null)
	if (map_name != null)
		SetName(map_name)
	
	for (var/area/A in world)
		if (istype(A, area_type))
			A.SetName("\improper [name] - [A.name]")
			GLOB.using_map.area_purity_test_exempt_areas += A.type
	
	if (map_name != null)
		SetName("[name], \a [initial(name)]")
