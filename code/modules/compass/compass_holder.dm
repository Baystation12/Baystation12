/obj/compass_holder
	name = null
	icon = null
	icon_state = null
	screen_loc = "CENTER,CENTER"

	var/show_heading = FALSE
	var/numeric_directions = FALSE

	var/image/compass_heading_marker
	var/list/compass_static_labels
	var/list/compass_waypoints
	var/list/compass_waypoint_markers

	var/static/list/angle_step_to_dir = list(
		"N",
		"NE",
		"E",
		"SE",
		"S",
		"SW",
		"W",
		"NW",
		"N"
	)

/obj/compass_holder/Initialize(mapload, ...)
	. = ..()
	if(show_heading)
		compass_heading_marker = new /image/compass_marker
		compass_heading_marker.maptext = "<center><font color = '#00ffffff' size = 2><b>△</b></font></center>"
		compass_heading_marker.filters = filter(type="drop_shadow", color = "#00ffffaa", size = 2, offset = 1,x = 0, y = 0)
		compass_heading_marker.layer = LAYER_HUD_UNDER
		compass_heading_marker.plane = PLANE_PLAYER_HUD

	for(var/i in 0 to (360/(COMPASS_PERIOD))-1)
		var/image/I = new /image/compass_marker
		I.loc = src
		var/str
		var/str_col
		if(i % COMPASS_INTERVAL == 0)
			var/angle = (i * COMPASS_PERIOD)
			if(numeric_directions)
				str = "[angle]"
			else
				str = angle_step_to_dir[CLAMP(round(angle/45)+1, 1, length(angle_step_to_dir))]
			str_col = "#ffffffaa"
		else 
			str = "〡"
			str_col = "#aaaaaa88"
		I.maptext = "<center><font color = '[str_col]' size = '1px'><b>[str]</b></font></center>"
		var/matrix/M = matrix()
		M.Translate(0, COMPASS_LABEL_OFFSET)
		M.Turn(COMPASS_PERIOD * i)
		I.transform = M
		I.filters = filter(type="drop_shadow", color = "#77777777", size = 2, offset = 1,x = 0, y = 0)
		I.layer = LAYER_HUD_UNDER
		I.plane = PLANE_PLAYER_HUD
		LAZYADD(compass_static_labels, I)

	rebuild_overlay_lists(TRUE)

/obj/compass_holder/Destroy()
	QDEL_NULL_LIST(compass_waypoints)
	. = ..()

/obj/compass_holder/proc/get_heading()
	var/atom/A = loc?.loc // is there a get_holder_recursive() equivalent on Polaris?
	if(istype(A))
		. = dir2angle(A.dir)
	else
		. = 0

/obj/compass_holder/update_icon()
	var/set_overlays = (compass_static_labels | compass_waypoint_markers)
	if(show_heading)
		set_overlays |= compass_heading_marker
	overlays = set_overlays

/obj/compass_holder/proc/clear_waypoint(var/id)
	LAZYREMOVE(compass_waypoints, id)
	rebuild_overlay_lists(TRUE)

/obj/compass_holder/proc/set_waypoint(var/id, var/label, var/heading_x, var/heading_y, var/heading_z, var/label_color)
	var/datum/compass_waypoint/wp = LAZYACCESS(compass_waypoints, id)
	if(!wp)
		wp = new /datum/compass_waypoint()
	wp.set_values(label, heading_x, heading_y, heading_z, label_color)
	LAZYSET(compass_waypoints, id, wp)
	rebuild_overlay_lists(TRUE)

/obj/compass_holder/proc/recalculate_heading(var/rebuild_icon = TRUE)
	if(show_heading)
		var/matrix/M = matrix()
		M.Translate(0, round(COMPASS_LABEL_OFFSET - 35))
		M.Turn(get_heading())
		compass_heading_marker.transform = M
		if(rebuild_icon)
			update_icon()

/obj/compass_holder/proc/show_waypoint(var/id)
	var/datum/compass_waypoint/wp = compass_waypoints[id]
	wp.hidden = FALSE

/obj/compass_holder/proc/hide_waypoint(var/id)
	var/datum/compass_waypoint/wp = compass_waypoints[id]
	wp.hidden = TRUE

/obj/compass_holder/proc/hide_waypoints(var/rebuild_overlays = FALSE)
	for(var/id in compass_waypoints)
		hide_waypoint(id)
	if(rebuild_overlays)
		rebuild_overlay_lists(TRUE)

/obj/compass_holder/proc/rebuild_overlay_lists(var/update_icon = FALSE)
	compass_waypoint_markers = null
	var/turf/T = get_turf(src)
	if(istype(T))
		for(var/id in compass_waypoints)
			var/datum/compass_waypoint/wp = compass_waypoints[id]
			if(!wp.hidden)
				wp.recalculate_heading(T.x, T.y)
				LAZYADD(compass_waypoint_markers, wp.compass_overlay)
	if(show_heading)
		recalculate_heading(FALSE)
	if(update_icon)
		update_icon()
