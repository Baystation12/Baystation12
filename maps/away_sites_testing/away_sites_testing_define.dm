
/datum/map/away_sites_testing
	name = "Away Sites Testing"
	full_name = "Away Sites Testing Land"
	path = "away_sites_testing"

	station_levels = list()
	contact_levels = list()
	player_levels = list()

	allowed_spawns = list()

/datum/map/away_sites_testing/build_away_sites()
	var/list/unsorted_sites = list_values(SSmapping.away_sites_templates)
	var/list/sorted_sites = sortTim(unsorted_sites, /proc/cmp_sort_templates_tallest_to_shortest)
	for (var/datum/map_template/ruin/away_site/A in sorted_sites)
		A.load_new_z()
		testing("Spawning [A] in [english_list(GetConnectedZlevels(world.maxz))]")

/proc/cmp_sort_templates_tallest_to_shortest(var/datum/map_template/a, var/datum/map_template/b)
	return b.tallness - a.tallness