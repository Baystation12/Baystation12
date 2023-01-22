/obj/machinery/ship_map
	name = "ship holomap"
	desc = "A virtual map of the surrounding craft."
	icon = 'icons/obj/machines/stationmap.dmi'
	icon_state = "station_map"
	anchored = TRUE
	density = FALSE
	use_power = POWER_USE_IDLE
	idle_power_usage = 10
	active_power_usage = 500

	light_color = "#64c864"

	uncreated_component_parts = null

	construct_state = /decl/machine_construction/default/panel_closed
	base_type = /obj/machinery/ship_map

	var/light_power_on = 1
	var/light_range_on = 2

	layer = ABOVE_WINDOW_LAYER	// Above windows.

	var/mob/watching_mob = null
	var/image/small_station_map = null
	var/image/floor_markings = null
	var/image/panel = null

	var/original_zLevel = 1	// zLevel on which the station map was initialized.
	var/bogus = TRUE		// set to 0 when you initialize the station map on a zLevel that has its own icon formatted for use by station holomaps.
	var/datum/station_holomap/holomap_datum

/obj/machinery/ship_map/Destroy()
	SSminimap.station_holomaps -= src
	stopWatching()
	QDEL_NULL(holomap_datum)
	return ..()

/obj/machinery/ship_map/Initialize()
	holomap_datum = new()
	original_zLevel = loc.z
	bogus = FALSE
	. = ..()

	//Set pixel offsets based on dir
	if(dir == NORTH)
		pixel_y = -32
	if(dir == SOUTH)
		pixel_y = 32
	if(dir == WEST)
		pixel_x = 32
	if(dir == EAST)
		pixel_x = -32

	SSminimap.station_holomaps += src

	if(SSminimap.initialized)
		update_map_data()

	floor_markings = image('icons/obj/machines/stationmap.dmi', "decal_station_map")
	floor_markings.dir = src.dir
	update_icon()

/obj/machinery/ship_map/proc/update_map_data()
	if(!SSminimap.holomaps[original_zLevel])
		bogus = TRUE
		holomap_datum.initialize_holomap_bogus()
		update_icon()
		return

	holomap_datum.initialize_holomap(get_turf(src), reinit = TRUE)

	small_station_map = image(icon = SSminimap.holomaps[original_zLevel].holomap_small)
	small_station_map.plane = EFFECTS_ABOVE_LIGHTING_PLANE
	small_station_map.layer = ABOVE_LIGHTING_LAYER
	small_station_map.pixel_x = 10
	small_station_map.pixel_y = 10

	update_icon()

/obj/machinery/ship_map/attack_hand(var/mob/user)
	if(watching_mob && (watching_mob != user))
		to_chat(user, SPAN_WARNING("Someone else is currently watching the holomap."))
		return
	if(user.loc != loc)
		to_chat(user, SPAN_WARNING("You need to stand in front of \the [src]."))
		return
	startWatching(user)

// Let people bump up against it to watch
/obj/machinery/ship_map/Bumped(var/atom/movable/AM)
	if(!watching_mob && isliving(AM) && AM.loc == loc)
		startWatching(AM)

// In order to actually get Bumped() we need to block movement.  We're (visually) on a wall, so people
// couldn't really walk into us anyway.  But in reality we are on the turf in front of the wall, so bumping
// against where we seem is actually trying to *exit* our real loc
/obj/machinery/ship_map/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	if(get_dir(target, loc) == dir) // Opposite of "normal" since we are visually in the next turf over
		return FALSE
	else
		return TRUE

/obj/machinery/ship_map/proc/startWatching(var/mob/user)
	if(isliving(user) && anchored && !(stat & (NOPOWER|BROKEN)))
		if(user.client)
			holomap_datum.station_map.loc = GLOB.global_hud.holomap  // Put the image on the holomap hud
			holomap_datum.station_map.alpha = 0 // Set to transparent so we can fade in
			animate(holomap_datum.station_map, alpha = 255, time = 5, easing = LINEAR_EASING)
			flick("station_map_activate", src)
			user.client.screen |= GLOB.global_hud.holomap
			user.client.images |= holomap_datum.station_map

			watching_mob = user
			GLOB.moved_event.register(watching_mob, src, /obj/machinery/ship_map/proc/checkPosition)
			GLOB.destroyed_event.register(watching_mob, src, /obj/machinery/ship_map/proc/stopWatching)
			update_use_power(POWER_USE_ACTIVE)

			if(bogus)
				to_chat(user, SPAN_WARNING("The holomap failed to initialize. This area of space cannot be mapped."))
			else
				to_chat(user, SPAN_NOTICE("A hologram of your current location appears before your eyes."))

			START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/ship_map/Process()
	if((stat & (NOPOWER|BROKEN)))
		stopWatching()
		return PROCESS_KILL

/obj/machinery/ship_map/proc/checkPosition()
	if(!watching_mob || (watching_mob.loc != loc) || (dir != watching_mob.dir))
		stopWatching()

/obj/machinery/ship_map/proc/stopWatching()
	if(watching_mob)
		if(watching_mob.client)
			animate(holomap_datum.station_map, alpha = 0, time = 5, easing = LINEAR_EASING)
			var/mob/M = watching_mob
			addtimer(CALLBACK(src, .proc/clear_image, M, holomap_datum.station_map), 5, TIMER_CLIENT_TIME)//we give it time to fade out
		GLOB.moved_event.unregister(watching_mob, src)
		GLOB.destroyed_event.unregister(watching_mob, src)
	watching_mob = null
	update_use_power(POWER_USE_IDLE)
	if(holomap_datum)
		holomap_datum.legend_deselect()

/obj/machinery/ship_map/proc/clear_image(mob/M, image/I)
	if (M.client)
		M.client.images -= I

/obj/machinery/ship_map/on_update_icon()
	. = ..()
	overlays.Cut()
	if(stat & BROKEN)
		icon_state = "station_mapb"
		set_light(0)
	else if((stat & NOPOWER) || !anchored)
		icon_state = "station_map0"
		set_light(0)
	else
		icon_state = "station_map"
		set_light(0.8, 0.1, 2, 2, "#1dbe17")

		// Put the little "map" overlay down where it looks nice
		if(small_station_map)
			overlays.Add(small_station_map)

	if(floor_markings)
		floor_markings.dir = src.dir
		floor_markings.pixel_x = -src.pixel_x
		floor_markings.pixel_y = -src.pixel_y
		src.overlays.Add(floor_markings)

	if(panel_open)
		overlays.Add("station_map-panel")

/obj/machinery/ship_map/ex_act(severity)
	switch(severity)
		if(EX_ACT_DEVASTATING)
			qdel(src)
		if(EX_ACT_HEAVY)
			if (prob(50))
				qdel(src)
			else
				set_broken()
		if(EX_ACT_LIGHT)
			if (prob(25))
				set_broken()

#define HOLOMAP_LEGEND_STYLING(X) SPAN_STYLE("font-family: 'Small Fonts'; font-size: 7px;", X)

/obj/screen/levelselect
	icon = 'icons/misc/mark.dmi'
	layer = HUD_ITEM_LAYER
	var/active = TRUE
	var/datum/station_holomap/owner = null

/obj/screen/levelselect/Initialize(mapload, datum/station_holomap/_owner)
	. = ..()
	owner = _owner

/obj/screen/levelselect/Click()
	return (!usr.incapacitated() && !isghost(usr))
/obj/screen/levelselect/up
	icon_state = "fup"

/obj/screen/levelselect/up/Click()
	if(..())
		if(owner)
			owner.set_level(owner.displayed_level - 1)

/obj/screen/levelselect/down
	icon_state = "fdn"

/obj/screen/levelselect/down/Click()
	if(..())
		if(owner)
			owner.set_level(owner.displayed_level + 1)

/obj/screen/legend
	icon = null
	maptext_height = 128
	maptext_width = 128
	layer = HUD_ITEM_LAYER
	pixel_x = HOLOMAP_LEGEND_X
	var/saved_color
	var/datum/station_holomap/owner = null
	var/has_areas = FALSE

/obj/screen/legend/cursor
	icon = 'icons/misc/holomap_markers.dmi'
	icon_state = "you"
	maptext_x = 11
	pixel_x = HOLOMAP_LEGEND_X - 3
	has_areas = TRUE

/obj/screen/legend/Initialize(mapload, color, text)
	. = ..()
	src.color = color
	saved_color = color
	maptext = "<A href='?src=\ref[src]' style='color: #ffffff'>[HOLOMAP_LEGEND_STYLING(text)]</A>"
	alpha = 254

/obj/screen/legend/Click(location, control, params)
	if(!usr.incapacitated() && !isghost(usr))
		if(istype(owner))
			owner.legend_select(src)

/obj/screen/legend/proc/Setup(z_level)
	has_areas = FALSE
	//Get the areas for this z level and mark if we're empty
	overlays.Cut()
	for(var/area/A in SSminimap.holomaps[z_level].holomap_areas)
		if(A.holomap_color == saved_color)
			var/image/area = image(SSminimap.holomaps[z_level].holomap_areas[A])
			area.pixel_x = ((HOLOMAP_ICON_SIZE / 2) - world.maxx / 2) - pixel_x
			area.pixel_y = ((HOLOMAP_ICON_SIZE / 2) - world.maxy / 2) - pixel_y
			overlays += area
			has_areas = TRUE

//What happens when we are clicked on / when another is clicked on
/obj/screen/legend/proc/Select()
	//Start blinking
	animate(src, alpha = 0, time = 2, loop = -1, easing = JUMP_EASING | EASE_IN | EASE_OUT)
	animate(alpha = 254, time = 2, loop = -1, easing = JUMP_EASING | EASE_IN | EASE_OUT)

/obj/screen/legend/proc/Deselect()
	//Stop blinking
	animate(src, flags = ANIMATION_END_NOW)

//Cursor doesnt do anything specific.
/obj/screen/legend/cursor/Setup()

/obj/screen/legend/cursor/Select()

/obj/screen/legend/cursor/Deselect()

// Simple datum to keep track of a running holomap. Each machine capable of displaying the holomap will have one.
/datum/station_holomap
	var/image/station_map
	var/image/cursor
	var/list/obj/screen/legend/legend
	var/list/obj/screen/maptexts
	var/list/obj/screen/levelselect/lbuttons
	var/list/image/levels
	var/list/z_levels
	var/z = -1
	var/displayed_level = 1 //Index of level to display

/datum/station_holomap/Destroy(force)
	QDEL_NULL(station_map)
	QDEL_NULL(cursor)
	QDEL_NULL_LIST(legend)
	QDEL_NULL_LIST(levels)
	QDEL_NULL_LIST(lbuttons)
	QDEL_NULL_LIST(maptexts)
	QDEL_NULL_LIST(z_levels)
	. = ..()

/datum/station_holomap/proc/initialize_holomap(turf/T, isAI = null, mob/user = null, reinit = FALSE)
	z = T.z
	if(!station_map || reinit)
		station_map = image(SSminimap.holomaps[z].holomap_combined)
	if(!cursor || reinit)
		cursor = image('icons/misc/holomap_markers.dmi', "you")
		cursor.layer = HUD_ABOVE_ITEM_LAYER
	if(!LAZYLEN(legend) || reinit)
		if(LAZYLEN(legend))
			QDEL_NULL_LIST(legend)
		LAZYINITLIST(legend)
		LAZYADD(legend, new /obj/screen/legend(null ,HOLOMAP_AREACOLOR_COMMAND, "■ Command"))
		LAZYADD(legend, new /obj/screen/legend(null ,HOLOMAP_AREACOLOR_SECURITY, "■ Security"))
		LAZYADD(legend, new /obj/screen/legend(null ,HOLOMAP_AREACOLOR_MEDICAL, "■ Medical"))
		LAZYADD(legend, new /obj/screen/legend(null ,HOLOMAP_AREACOLOR_SCIENCE, "■ Research"))
		LAZYADD(legend, new /obj/screen/legend(null ,HOLOMAP_AREACOLOR_EXPLORATION, "■ Exploration"))
		LAZYADD(legend, new /obj/screen/legend(null ,HOLOMAP_AREACOLOR_ENGINEERING, "■ Engineering"))
		LAZYADD(legend, new /obj/screen/legend(null ,HOLOMAP_AREACOLOR_CARGO, "■ Supply"))
		LAZYADD(legend, new /obj/screen/legend(null ,HOLOMAP_AREACOLOR_AIRLOCK, "■ Airlock"))
		LAZYADD(legend, new /obj/screen/legend(null ,HOLOMAP_AREACOLOR_ESCAPE, "■ Escape"))
		LAZYADD(legend, new /obj/screen/legend(null ,HOLOMAP_AREACOLOR_CREW, "■ Crew"))
		LAZYADD(legend, new /obj/screen/legend/cursor(null ,HOLOMAP_AREACOLOR_BASE, "You are here"))
	if(reinit)
		QDEL_NULL_LIST(maptexts)
		QDEL_NULL_LIST(levels)
		QDEL_NULL_LIST(z_levels)
		QDEL_NULL_LIST(lbuttons)

	station_map = image(icon(HOLOMAP_ICON, "stationmap"))
	station_map.layer = UNDER_HUD_LAYER

	//This is where the fun begins
	if(GLOB.using_map.use_overmap)
		var/obj/effect/overmap/visitable/O = map_sectors["[z]"]

		var/current_z_offset_x = (HOLOMAP_ICON_SIZE / 2) - world.maxx / 2
		var/current_z_offset_y = (HOLOMAP_ICON_SIZE / 2) - world.maxy / 2

		//For the given z level fetch the related map sector and build the list
		if(istype(O))
			var/z_count = length(O.map_z)
			var/current_z_index = 1
			z_levels = O.map_z.Copy()

			if(z_count > 1)
				if(!LAZYLEN(lbuttons))
					//Add the buttons for switching levels
					LAZYADD(lbuttons, new /obj/screen/levelselect/up(null, src))
					LAZYADD(lbuttons, new /obj/screen/levelselect/down(null, src))
				lbuttons[1].pixel_y = HOLOMAP_MARGIN - 22
				lbuttons[2].pixel_y = HOLOMAP_MARGIN + 5
				lbuttons[1].pixel_x = 254
				lbuttons[2].pixel_x = 196

			//Each level now has to be built and offset properly. Then stored to be showed later
			for(var/level = 1; level <= z_count; level++)
				if (z == O.map_z[level])
					current_z_index = level

				//Turfs and walls
				var/image/map_image = image(SSminimap.holomaps[O.map_z[level]].holomap_base)

				map_image.color = HOLOMAP_HOLOFIER
				map_image.layer = HUD_BASE_LAYER

				map_image.pixel_x = (HOLOMAP_ICON_SIZE / 2) - world.maxx / 2
				map_image.pixel_y = (HOLOMAP_ICON_SIZE / 2) - world.maxy / 2

				//Store the image for future use
				//LAZYADD(levels, map_image)
				LAZYSET(levels, "[O.map_z[level]]", map_image)

				var/obj/screen/maptext_overlay = new(null)
				maptext_overlay.icon = null
				maptext_overlay.layer = HUD_ITEM_LAYER
				maptext_overlay.maptext = "<span style='text-align:center'>LEVEL [level-1]</span>"
				maptext_overlay.maptext_width = 96
				maptext_overlay.pixel_x = (HOLOMAP_ICON_SIZE / 2) - (maptext_overlay.maptext_width / 2)
				maptext_overlay.pixel_y = HOLOMAP_MARGIN

				LAZYSET(maptexts, "[O.map_z[level]]", maptext_overlay)

			//Reset to starting zlevel
			set_level(current_z_index)
		if(isAI)
			T = get_turf(user.client.eye)
		cursor.pixel_x = (T.x - 6 + current_z_offset_x) * PIXEL_MULTIPLIER
		cursor.pixel_y = (T.y - 6 + current_z_offset_y) * PIXEL_MULTIPLIER


/datum/station_holomap/proc/set_level(level)
	if(level > z_levels.len)
		return

	displayed_level = level

	station_map.overlays.Cut()
	station_map.vis_contents.Cut()

	if(z == z_levels[displayed_level])
		station_map.overlays += cursor

	station_map.overlays += levels["[z_levels[displayed_level]]"]
	station_map.vis_contents += maptexts["[z_levels[displayed_level]]"]

	//Fix legend position
	var/pixel_y = HOLOMAP_LEGEND_Y
	for(var/obj/screen/legend/element in legend)
		element.owner = src
		element.pixel_y = pixel_y //Set adjusted pixel y as it will be needed for area placement
		element.Setup(z_levels[displayed_level])
		if(element.has_areas)
			pixel_y -= 10
			station_map.vis_contents += element

	if(displayed_level > 1)
		station_map.vis_contents += lbuttons[1]

	if(displayed_level < z_levels.len)
		station_map.vis_contents += lbuttons[2]

/datum/station_holomap/proc/legend_select(obj/screen/legend/L)
	legend_deselect()
	L.Select()

/datum/station_holomap/proc/legend_deselect()
	for(var/obj/screen/legend/entry in legend)
		entry.Deselect()

/datum/station_holomap/proc/initialize_holomap_bogus()
	station_map = image('icons/480x480.dmi', "stationmap")
	station_map.overlays |= image('icons/effects/64x64.dmi', "notfound", pixel_x = 7 * WORLD_ICON_SIZE, pixel_y = 7 * WORLD_ICON_SIZE)

#undef HOLOMAP_LEGEND_STYLING
