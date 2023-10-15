SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = SS_INIT_MAPPING
	flags = SS_NO_FIRE

	var/static/list/map_templates
	var/static/list/space_ruins_templates
	var/static/list/exoplanet_ruins_templates
	var/static/list/away_sites_templates
	var/static/list/submap_archetypes
	var/static/list/submaps = list()


/datum/controller/subsystem/mapping/UpdateStat(time)
	return


/datum/controller/subsystem/mapping/Initialize(start_uptime)
	map_templates = Singletons.GetSubtypeMap(/singleton/map_template)
	space_ruins_templates = Singletons.GetSubtypeMap(/singleton/map_template/ruin/space)
	exoplanet_ruins_templates = Singletons.GetSubtypeMap(/singleton/map_template/ruin/exoplanet)
	away_sites_templates = Singletons.GetSubtypeMap(/singleton/map_template/ruin/away_site)
	submap_archetypes = Singletons.GetSubtypeMap(/singleton/submap_archetype)
