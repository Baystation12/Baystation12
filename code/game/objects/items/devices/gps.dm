var/global/list/all_gps_units = list()
/obj/item/device/gps
	name = "global coordinate system"
	desc = "A handheld relay used to triangulate the approximate co-ordinates of the device."
	icon = 'icons/obj/locator.dmi'
	icon_state = "gps"
	item_state = "gps"
	origin_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_ALUMINIUM = 1000, MATERIAL_PLASTIC = 750)
	w_class = ITEM_SIZE_SMALL

	var/gps_tag = "GEN0"
	var/emped = FALSE
	/// Will not show other signals or emit its own signal if false.
	var/tracking = FALSE
	/// If true, can see farther, depending on get_map_levels().
	var/long_range = FALSE
	/// If true, only GPS signals of the same Z level are shown.
	var/local_mode = FALSE
	/// If true, signal is not visible to other GPS devices.
	var/hide_signal = FALSE
	/// If it can toggle the above var.
	var/can_hide_signal = FALSE
	/// How the GPS marker should be handled.
	var/is_special_gps_marker = FALSE

	var/mob/holder
	var/is_in_processing_list = FALSE
	var/list/tracking_devices
	var/list/showing_tracked_names
	var/obj/compass_holder/compass
	var/list/decals

// Mapped type for away site GPS.
/obj/item/device/gps/marker
	is_special_gps_marker = TRUE

/obj/item/device/gps/Initialize()
	global.all_gps_units += src
	. = ..()
	name = "[initial(name)] ([gps_tag])"
	GLOB.moved_event.register(holder, src, .proc/update_holder)
	compass = new(src)
	update_holder()
	update_icon()

/obj/item/device/gps/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, SPAN_NOTICE("\The [src]'s screen shows: <i>[fetch_coordinates()]</i>."))

/obj/item/device/gps/proc/fetch_coordinates()
	var/turf/T = get_turf(src)
	return T ? "[T.x]:[T.y]:[T.z]" : "N/A"

/obj/item/device/gps/proc/check_visible_to_holder()
	. = holder && (holder.l_hand == src || holder.r_hand == src)

/obj/item/device/gps/proc/update_holder(var/force_clear = FALSE)

	if(holder && (force_clear || loc != holder))
		GLOB.moved_event.unregister(holder, src)
		GLOB.dir_set_event.unregister(holder, src)
		holder.client?.screen -= compass
		holder = null

	if(!force_clear && istype(loc, /mob))
		holder = loc
		GLOB.moved_event.register(holder, src, .proc/update_compass)
		GLOB.dir_set_event.register(holder, src, .proc/update_compass)

	if(!force_clear && holder && tracking)
		if(!is_in_processing_list)
			START_PROCESSING(SSobj, src)
			is_in_processing_list = TRUE
		if(holder.client)
			if(check_visible_to_holder())
				holder.client.screen |= compass
			else
				holder.client.screen -= compass
	else
		STOP_PROCESSING(SSobj, src)
		is_in_processing_list = FALSE
		if(holder?.client)
			holder.client.screen -= compass

/obj/item/device/gps/equipped_robot()
	. = ..()
	update_holder()

/obj/item/device/gps/equipped()
	. = ..()
	update_holder()

/obj/item/device/gps/Process()
	if(!tracking)
		is_in_processing_list = FALSE
		return PROCESS_KILL
	update_holder()
	if(holder)
		update_compass(TRUE)

/obj/item/device/gps/Destroy()
	STOP_PROCESSING(SSobj, src)
	is_in_processing_list = FALSE
	global.all_gps_units -= src
	GLOB.moved_event.unregister(holder, src, .proc/update_holder)
	update_holder(force_clear = TRUE)
	QDEL_NULL(compass)
	return ..()

/obj/item/device/gps/proc/can_track(var/obj/item/device/gps/other, var/reachable_z_levels)
	if(!other.tracking || other.emped || other.hide_signal)
		return FALSE

	var/turf/origin = get_turf(src)
	var/turf/target = get_turf(other)
	if(!istype(origin) || !istype(target))
		return FALSE
	if(origin.z == target.z)
		return TRUE
	if(local_mode)
		return FALSE

	var/list/adding_sites
	if(long_range)
		adding_sites = (GLOB.using_map.station_levels|GLOB.using_map.contact_levels|GLOB.using_map.player_levels)
	else
		adding_sites = GetConnectedZlevels(origin.z)

	if(LAZYLEN(adding_sites))
		LAZYDISTINCTADD(reachable_z_levels, adding_sites)
	return (target.z in reachable_z_levels)

/obj/item/device/gps/proc/update_compass(var/update_compass_icon)

	compass.hide_waypoints(FALSE)

	var/turf/my_turf = get_turf(src)
	for(var/thing in tracking_devices)
		var/obj/item/device/gps/gps = locate(thing)
		if(!istype(gps) || QDELETED(gps))
			LAZYREMOVE(tracking_devices, thing)
			LAZYREMOVE(showing_tracked_names, thing)
			continue

		var/turf/gps_turf = get_turf(gps)
		var/gps_tag = LAZYACCESS(showing_tracked_names, thing) ? gps.gps_tag : null
		if(istype(gps_turf))
			compass.set_waypoint("\ref[gps]", gps_tag, gps_turf.x, gps_turf.y, gps_turf.z, LAZYACCESS(tracking_devices, "\ref[gps]"))
			if(can_track(gps) && my_turf && gps_turf != my_turf)
				compass.show_waypoint("\ref[gps]")

	compass.rebuild_overlay_lists(update_compass_icon)

/obj/item/device/gps/proc/toggle_tracking(var/mob/user, var/silent)

	if(emped)
		if(!silent)
			to_chat(user, SPAN_WARNING("\The [src] is busted!"))
		return FALSE

	tracking = !tracking
	if(tracking)
		if(!is_in_processing_list)
			is_in_processing_list = TRUE
			START_PROCESSING(SSobj, src)
	else
		is_in_processing_list = FALSE
		STOP_PROCESSING(SSobj, src)

	if(!silent)
		if(tracking)
			to_chat(user, SPAN_NOTICE("\The [src] is now tracking, and visible to other GPS devices."))
		else
			to_chat(user, SPAN_NOTICE("\The [src] is no longer tracking, or visible to other GPS devices."))

	update_compass()
	update_holder()
	update_icon()

/obj/item/device/gps/emp_act(severity)
	if(emped) // Without a fancy callback system, this will have to do.
		return
	if(tracking)
		toggle_tracking(silent = TRUE)
	/// In case emp_act gets called without any arguments.
	var/severity_modifier = severity ? severity : 4
	var/duration = 5 MINUTES / severity_modifier
	emped = TRUE
	update_icon()
	addtimer(CALLBACK(src, .proc/reset_emp), duration)

/obj/item/device/gps/proc/reset_emp()
	emped = FALSE
	update_icon()
	if(ismob(loc))
		to_chat(loc, SPAN_NOTICE("\The [src] appears to be functional again."))

/obj/item/device/gps/on_update_icon()
	overlays.Cut()
	if(emped)
		overlays.Add("gps_emp")
	else if(tracking)
		overlays.Add("gps_on")

/obj/item/device/gps/attack_self(mob/user)
	ui_interact(user)
	return TRUE

/obj/item/device/gps/ui_data(mob/user, ui_key)

	var/turf/curr = get_turf(src)
	var/area/my_area = get_area(src)

	. = list()
	.["tracking"] = tracking
	.["gps_tag"] = gps_tag
	.["my_area_name"] = strip_improper(my_area.name)
	.["hide_signal"] = hide_signal
	.["curr_x"] = curr.x
	.["curr_y"] = curr.y
	.["curr_z"] = curr.z
	.["local_mode"] = local_mode

	var/z_level_detection
	if(long_range)
		z_level_detection = (GLOB.using_map.station_levels|GLOB.using_map.contact_levels|GLOB.using_map.player_levels)
	else
		z_level_detection = GetConnectedZlevels(curr.z)
	.["z_level_detection"] = z_level_detection

	var/list/gps_list = list()
	for(var/obj/item/device/gps/G as anything in global.all_gps_units)
		if(G == src || !can_track(G, z_level_detection))
			continue

		var/gps_data[0]
		var/gps_ref = "\ref[G]"
		gps_data["gps_ref"] = gps_ref
		gps_data["gps_tag"] = G.gps_tag
		gps_data["is_special_gps_marker"] = G.is_special_gps_marker
		gps_data["being_tracked"] = !!(gps_ref in tracking_devices)

		var/square_colour = LAZYACCESS(tracking_devices, gps_ref) || COLOR_CYAN
		gps_data["coloured_square"] = COLORED_SQUARE(square_colour)

		var/area/A = get_area(G)
		gps_data["area_name"] = strip_improper(A.name)

		var/turf/T = get_turf(G)
		gps_data["direction"] = get_compass_direction_string(curr, T)
		gps_data["degrees"] =   round(Get_Angle(curr,T))
		gps_data["distX"] =     T.x - curr.x
		gps_data["distY"] =     T.y - curr.y
		gps_data["distance"] =  round(get_dist(curr, T), 10)
		gps_data["local"] =     (curr.z == T.z)
		gps_data["x"] =         T.x
		gps_data["y"] =         T.y
		gps_list += list(gps_data)

	if(length(gps_list))
		.["gps_list"] = gps_list
	else
		.["no_signals"] = TRUE

/obj/item/device/gps/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, var/master_ui = null, var/datum/topic_state/state = GLOB.default_state)

	var/data = ui_data()
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "gps.tmpl", name, 500, 300, master_ui = master_ui, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/item/device/gps/OnTopic(var/mob/user, var/list/href_list)

	if(href_list["toggle_power"])
		toggle_tracking()
		. = TOPIC_REFRESH

	if(href_list["track_label"])
		var/gps_ref = href_list["track_label"]
		var/obj/item/device/gps/gps = locate(gps_ref)
		if(istype(gps) && !QDELETED(gps) && !LAZYACCESS(showing_tracked_names, gps_ref))
			LAZYSET(showing_tracked_names, gps_ref, TRUE)
		else
			LAZYREMOVE(showing_tracked_names, gps_ref)
		to_chat(user, SPAN_NOTICE("\The [src] is [LAZYACCESS(showing_tracked_names, gps_ref) ? "now showing" : "no longer showing"] labels for [gps.gps_tag]."))
		. = TOPIC_REFRESH

	if(href_list["stop_track"])
		var/gps_ref = href_list["stop_track"]
		var/obj/item/device/gps/gps = locate(gps_ref)
		compass.clear_waypoint(gps_ref)
		LAZYREMOVE(tracking_devices, gps_ref)
		LAZYREMOVE(showing_tracked_names, gps_ref)
		if(istype(gps) && !QDELETED(gps))
			to_chat(user, SPAN_NOTICE("\The [src] is no longer tracking [gps.gps_tag]."))
		update_compass()
		. = TOPIC_REFRESH

	if(href_list["start_track"])
		var/gps_ref = href_list["start_track"]
		var/obj/item/device/gps/gps = locate(gps_ref)
		if(istype(gps) && !QDELETED(gps))
			LAZYSET(tracking_devices, gps_ref, COLOR_SILVER)
			LAZYSET(showing_tracked_names, gps_ref, TRUE)
			to_chat(user, SPAN_NOTICE("\The [src] is now tracking [gps.gps_tag]."))
			update_compass()
			. = TOPIC_REFRESH

	if(href_list["track_color"])
		var/obj/item/device/gps/gps = locate(href_list["track_color"])
		if(istype(gps) && !QDELETED(gps))
			var/new_colour = input("Enter a new tracking color.", "GPS Waypoint Color") as color|null
			if(new_colour && istype(gps) && !QDELETED(gps) && holder == user && !user.incapacitated())
				to_chat(user, SPAN_NOTICE("You adjust the colour \the [src] is using to highlight [gps.gps_tag]."))
				LAZYSET(tracking_devices, href_list["track_color"], new_colour)
				update_compass()
				. = TOPIC_REFRESH

	if(href_list["tag"])
		/// Used to hold the sanitised input.
		var/a = input("Please enter desired tag.", name, gps_tag) as text
		a = uppertext(copytext(sanitize(a), 1, 11))
		if(in_range(src, user))
			gps_tag = a
			name = "[initial(name)] ([gps_tag])"
			to_chat(user, SPAN_NOTICE("You set your GPS's tag to '[gps_tag]'."))
			. = TOPIC_REFRESH

	if(href_list["range"])
		local_mode = !local_mode
		to_chat(user, SPAN_NOTICE("You set the signal receiver to [local_mode ? "'NARROW'" : "'BROAD'"]."))
		. = TOPIC_REFRESH

	if(href_list["hide"])
		if(!can_hide_signal)
			return
		hide_signal = !hide_signal
		to_chat(user, SPAN_NOTICE("You set the device to [hide_signal ? "not " : ""]broadcast a signal while scanning for other signals."))
		. = TOPIC_REFRESH

/obj/item/device/gps/AltClick(mob/user)
	toggle_tracking(user)
