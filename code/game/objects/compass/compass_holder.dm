var/global/list/angle_step_to_dir = list(
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

#define MIN_VIEW 15

/obj/compass_holder
	name = null
	icon = null
	icon_state = null
	screen_loc = "CENTER,CENTER"

	var/interval_colour =        "#7e6f96"
	var/bearing_colour =         COLOR_WHITE
	var/bearing_outline_colour = "#3b2d53"

	/// Number of steps/pips between bolded markers on the compass ring.
	var/compass_interval = 3
	/// Total angle covered by a single span of the compass ring; divided by compass_interval to get individual spans.
	var/compass_period =  45

	var/list/compass_static_labels
	var/list/compass_waypoints
	var/list/compass_waypoint_markers

/obj/compass_holder/Initialize(mapload, ...)
	. = ..()
	rebuild_compass_overlays()

/obj/compass_holder/proc/get_label_offset()
	return (world.icon_size * round(MIN_VIEW/2))

/obj/compass_holder/proc/rebuild_compass_overlays()

	var/effective_compass_period = compass_period/compass_interval
	LAZYCLEARLIST(compass_static_labels)
	for(var/i in 0 to (360/effective_compass_period)-1)

		var/image/compass_marker/I = new
		I.loc = src

		if(i % compass_interval == 0)
			I.maptext = STYLE_SMALLFONTS_OUTLINE("<center>[get_string_from_angle(i * effective_compass_period)]</center>", 7, bearing_colour, bearing_outline_colour)
		else
			I.maptext = STYLE_SMALLFONTS("<center>〡</center>", 7, interval_colour)

		var/matrix/M = matrix()
		M.Translate(0, get_label_offset())
		M.Turn(effective_compass_period * i)
		I.transform = M
		I.filters = filter(type="drop_shadow", color = "#77777777", size = 2, offset = 1,x = 0, y = 0)
		I.layer = HUD_BASE_LAYER
		I.plane = HUD_PLANE
		LAZYADD(compass_static_labels, I)

	rebuild_overlay_lists(TRUE)

/obj/compass_holder/proc/get_string_from_angle(var/angle)
	return global.angle_step_to_dir[clamp(round(angle/45)+1, 1, length(global.angle_step_to_dir))]

/obj/compass_holder/Destroy()
	QDEL_NULL_LIST(compass_waypoints)
	. = ..()

/obj/compass_holder/proc/get_heading_strength()
	return 1

/obj/compass_holder/proc/get_heading_angle()
	var/atom/A = loc
	// Bit of a strange loop - grab the highest atom in our stack that isn't a turf.
	while(istype(A) && A.loc && !isturf(A.loc))
		A = A.loc
	if(istype(A) && !isturf(A))
		. = dir2angle(A.dir)
	else
		. = 0

/obj/compass_holder/on_update_icon()
	overlays = (compass_static_labels | compass_waypoint_markers)

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

/obj/compass_holder/proc/get_compass_origin()
	return get_turf(src)

/obj/compass_holder/proc/rebuild_overlay_lists(var/update_icon = FALSE)
	compass_waypoint_markers = null
	var/turf/T = get_compass_origin()
	if(istype(T))
		var/translate_val = get_label_offset()
		for(var/id in compass_waypoints)
			var/datum/compass_waypoint/wp = compass_waypoints[id]
			if(should_show(wp))
				wp.recalculate_heading(T.x, T.y, translate_val)
				LAZYADD(compass_waypoint_markers, wp.compass_overlay)
	if(update_icon)
		update_icon()

/obj/compass_holder/proc/should_show(var/datum/compass_waypoint/wp)
	return wp && !wp.hidden
