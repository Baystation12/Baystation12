
//This station is only really meant for adminspawn events at the moment, so I'm reusing a lot of stuff to get it to work without much hassle.//

/area/om_ships/cov_odp_temp
	name = "Peacemaker Upon Stars"

/datum/npc_ship/peacemaker_station
	mapfile_links = list('maps/faction_bases/Station_Peacemaker/cms_peacemaker_upon_stars.dmm')
	fore_dir = NORTH

/obj/effect/overmap/ship/npc_ship/peacemaker_station
	name = "Peacemaker Upon Stars"
	icon = 'code/modules/halo/icons/overmap/faction_bases.dmi'
	icon_state = "base_cov"
	faction = "Covenant"
	ship_name_list = list("Peacemaker Upon Stars")
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/faction_bases.dmi')
	block_slipspace = 1
	anchored = 1
	occupy_range = 14
	default_delay = 1 SECOND
	ship_datums = list(/datum/npc_ship/peacemaker_station)
