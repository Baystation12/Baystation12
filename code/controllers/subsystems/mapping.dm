SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = SS_INIT_MAPPING
	flags = SS_NO_FIRE

	var/datum/persistence/world_handle/persistence = new()
	var/list/map_templates = list()
	var/list/space_ruins_templates = list()
	var/list/exoplanet_ruins_templates = list()
	var/list/away_sites_templates = list()
	var/list/submaps = list()
	var/list/submap_archetypes = list()
	var/list/saved_levels = list()
	var/using_save = FALSE // Whether or not we're using a persistence save.

/datum/controller/subsystem/mapping/Initialize(timeofday)
	// Load templates and build away sites.
	preloadTemplates()
	for(var/atype in subtypesof(/decl/submap_archetype))
		submap_archetypes[atype] = new atype
	GLOB.using_map.build_away_sites()


	// Build the list of static persisted levels from our map.
	saved_levels = GLOB.using_map.saved_levels
	persistence.FetchVersion()
#ifdef UNIT_TEST
	report_progress("Unit testing, so not loading saved map")
#else
	// If version is 0, no saves exist.
	if (persistence.version > 0)
		report_progress("Loading world save version [persistence.version].")
		using_save = TRUE
		persistence.LoadWorld()
	else
		report_progress("No world save found. Skipping load step.")
#endif
	return ..()

/datum/controller/subsystem/mapping/proc/Save()
	persistence.SaveWorld()

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	map_templates = SSmapping.map_templates
	space_ruins_templates = SSmapping.space_ruins_templates
	exoplanet_ruins_templates = SSmapping.exoplanet_ruins_templates
	away_sites_templates = SSmapping.away_sites_templates

/datum/controller/subsystem/mapping/proc/preloadTemplates(path = "maps/templates/") //see master controller setup
	var/list/filelist = flist(path)
	for(var/map in filelist)
		var/datum/map_template/T = new(paths = "[path][map]", rename = "[map]")
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

/datum/controller/subsystem/mapping/proc/RegisterSavedLevel(var/z)
	LAZYDISTINCTADD(saved_levels, z)