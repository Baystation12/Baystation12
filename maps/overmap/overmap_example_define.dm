/datum/map/overmap_example
	name = "Overmap Example"
	full_name = "The Overmap Example"
	path = "overmap"

	station_levels = list(2,3)
	contact_levels = list(2,3)
	player_levels = list(2,3)

/datum/map/overmap_example/setup_map()
	station_levels = list()
	for(var/zz in map_sectors)
		station_levels |= text2num(zz)
	contact_levels = station_levels.Copy()
	player_levels = station_levels.Copy()