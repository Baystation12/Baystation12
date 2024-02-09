
/datum/map/away_sites_testing
	name = "Away Sites Testing"
	full_name = "Away Sites Testing Land"
	path = "away_sites_testing"

	station_levels = list()
	contact_levels = list()
	player_levels = list()

	allowed_spawns = list()

	area_usage_test_exempted_areas = list(
		/area/beach,
		/area/centcom,
		/area/centcom/holding,
		/area/centcom/specops,
		/area/chapel,
		/area/hallway,
		/area/maintenance,
		/area/medical,
		/area/overmap,
		/area/engineering,
		/area/rnd,
		/area/rnd/xenobiology,
		/area/rnd/xenobiology/xenoflora,
		/area/rnd/xenobiology/xenoflora_storage,
		/area/security,
		/area/security/prison,
		/area/security/brig,
		/area/shuttle,
		/area/shuttle/escape,
		/area/shuttle/escape/centcom,
		/area/shuttle/specops,
		/area/shuttle/specops/centcom,
		/area/shuttle/syndicate_elite,
		/area/shuttle/syndicate_elite/mothership,
		/area/shuttle/syndicate_elite/station,
		/area/turbolift,
		/area/supply,
		/area/syndicate_elite_squad,
		/area/template_noop,
		/area/rnd/xenobiology/cell_1,
		/area/rnd/xenobiology/cell_2,
		/area/rnd/xenobiology/cell_3,
		/area/rnd/xenobiology/cell_4
	)

/datum/map/away_sites_testing/build_away_sites()
	var/list/unsorted_sites = list_values(SSmapping.away_sites_templates)
	var/list/sorted_sites = sortTim(unsorted_sites, /proc/cmp_sort_templates_tallest_to_shortest)
	for (var/datum/map_template/ruin/away_site/A in sorted_sites)
		A.load_new_z()
		testing("Spawning [A] in [english_list(GetConnectedZlevelsSet(world.maxz))]")

/proc/cmp_sort_templates_tallest_to_shortest(datum/map_template/a, datum/map_template/b)
	return b.tallness - a.tallness
