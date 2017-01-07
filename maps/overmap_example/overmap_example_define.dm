/datum/map/overmap_example
	name = "Overmap Example"
	full_name = "The Overmap Example"
	path = "overmap_example"

	lobby_icon = 'maps/overmap_example/overmap_example_lobby.dmi'

	allowed_spawns = list("Arrivals Shuttle")
	use_overmap = 1

/datum/map/overmap_example/setup_map()
	..()
	station_levels = list()
	for(var/zz in map_sectors)
		station_levels |= text2num(zz)
	contact_levels = station_levels.Copy()
	player_levels = station_levels.Copy()
