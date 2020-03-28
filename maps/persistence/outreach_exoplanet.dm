/obj/effect/overmap/visitable/sector/exoplanet/chlorine/outreach
	name = "\improper Outreach"
	desc = "A mining border-world, home to those lost in space."
	planetary_area = /area/exoplanet/chlorine
	lightlevel = 0.9
	daycycle = 25 MINUTES
	daycycle_column_delay = 100
	night = FALSE
	daycolumn = 1
	var/list/surface_z = list(3, 4)

/obj/effect/overmap/visitable/sector/exoplanet/chlorine/outreach/Initialize()
	map_z = GLOB.using_map.station_levels
	register_z_levels() // This makes external calls to update global z level information.

	if(!GLOB.using_map.overmap_z)
		build_overmap()

	start_x = start_x || rand(OVERMAP_EDGE, GLOB.using_map.overmap_size - OVERMAP_EDGE)
	start_y = start_y || rand(OVERMAP_EDGE, GLOB.using_map.overmap_size - OVERMAP_EDGE)

	forceMove(locate(start_x, start_y, GLOB.using_map.overmap_z))

	docking_codes = "[ascii2text(rand(65,90))][ascii2text(rand(65,90))][ascii2text(rand(65,90))][ascii2text(rand(65,90))]"

	// update_biome()
	// generate_planet_image()
	generation_complete = TRUE
	START_PROCESSING(SSobj, src)

	// Set starting light conditions.
	var/light = 0.1
	if(!night)
		light = lightlevel
	for(var/turf/simulated/floor/exoplanet/T in block(locate(daycolumn,1,min(surface_z)),locate(daycolumn,maxy,max(surface_z))))
		T.set_light(light, 0.1, 2)

/obj/effect/overmap/visitable/sector/exoplanet/chlorine/outreach/update_daynight()
	var/light = 0.1
	if(!night)
		light = lightlevel
	for(var/turf/simulated/floor/exoplanet/T in block(locate(daycolumn,1,min(surface_z)),locate(daycolumn,maxy,max(surface_z))))
		T.set_light(light, 0.1, 2)
	daycolumn++
	if(daycolumn > maxx)
		daycolumn = 0
