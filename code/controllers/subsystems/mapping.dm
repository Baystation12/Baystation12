SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = SS_INIT_MAPPING
	flags = SS_NO_FIRE
	var/map_index = 0 //This is incremented whenever a new map is created, and used to prevent namespace collisions

	var/list/map_templates = list()
	var/list/space_ruins_templates = list()
	var/list/exoplanet_ruins_templates = list()
	var/list/away_sites_templates = list()
	var/list/submaps = list()
	var/list/submap_archetypes = list()
	var/list/zlevels = list()
	var/list/empty_levels = list()
	var/list/all_level_datums = list()
	var/list/all_scene_datums = list()

/datum/controller/subsystem/mapping/Initialize(timeofday)
	//Load level and scene datums
	for (var/t in subtypesof(/datum/scene))
		var/datum/scene/S = new t
		all_scene_datums[S.id] = S

	for (var/t in subtypesof(/datum/level))
		var/datum/level/L = new t
		if (L.base_type == t) //Don't store base types
			continue
		//Lets try to retrieve the scene
		var/datum/scene/S = all_scene_datums[L.scene_id]
		if (S)
			L.scene = S
		//The inverse, populating the scene with a list of levels it contains, will be done later, as the landmarks are loaded and levels are assigned z numbers
		all_level_datums[L.id] = L

	// Load templates and build away sites.
	preloadTemplates()
	for(var/atype in subtypesof(/decl/submap_archetype))
		submap_archetypes[atype] = new atype
	GLOB.using_map.build_away_sites()
	. = ..()

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	map_templates = SSmapping.map_templates
	space_ruins_templates = SSmapping.space_ruins_templates
	exoplanet_ruins_templates = SSmapping.exoplanet_ruins_templates
	away_sites_templates = SSmapping.away_sites_templates

/datum/controller/subsystem/mapping/proc/preloadTemplates(path = "maps/templates/") //see master controller setup
	var/list/filelist = flist(path)
	for(var/map in filelist)
		var/datum/map_template/T = new(path = "[path][map]", rename = "[map]")
		map_templates[T.name] = T
	preloadBlacklistableTemplates()

/datum/controller/subsystem/mapping/proc/preloadBlacklistableTemplates()
	// Still supporting bans by filename
	var/list/banned_exoplanet_dmms = generateMapList("config/exoplanet_ruin_blacklist.txt")
	var/list/banned_space_dmms = generateMapList("config/space_ruin_blacklist.txt")
	var/list/banned_away_site_dmms = generateMapList("config/away_site_blacklist.txt")

	if (!banned_exoplanet_dmms || !banned_space_dmms || !banned_away_site_dmms)
		report_progress("One or more map blacklist files are not present in the config directory!")

	var/list/banned_maps = list() + banned_exoplanet_dmms + banned_space_dmms + banned_away_site_dmms

	for(var/item in sortList(subtypesof(/datum/map_template), /proc/cmp_ruincost_priority))
		var/datum/map_template/map_template_type = item
		// screen out the abstract subtypes
		if(!initial(map_template_type.id))
			continue
		var/datum/map_template/MT = new map_template_type()

		if (banned_maps)
			var/is_banned = FALSE
			for (var/mappath in MT.mappaths)
				if(banned_maps.Find(mappath))
					is_banned = TRUE
					break
			if (is_banned)
				continue

		map_templates[MT.name] = MT

		// This is nasty..
		if(istype(MT, /datum/map_template/ruin/exoplanet))
			exoplanet_ruins_templates[MT.name] = MT
		else if(istype(MT, /datum/map_template/ruin/space))
			space_ruins_templates[MT.name] = MT
		else if(istype(MT, /datum/map_template/ruin/away_site))
			away_sites_templates[MT.name] = MT


//This loops through every zlevel that exists in memory, and throws up errors about those that don't have datums setup
//We do this by looping through numbers until we fail to retrieve a tile
/hook/roundstart/proc/check_zlevel_datums()
	var/done = FALSE
	var/index = 1
	while(!done)
		var/turf/T = locate(1,1,index)
		if (istype(T))//If we found T then this zlevel exists
			var/datum/level/L = SSmapping.zlevels["[T.z]"]
			if (!istype(L))
				log_world("Error: Z level [T.z] has no associated level datum.")
		else
			//If we found no zlevel, we've reached the end
			done = TRUE
		index++

	return TRUE