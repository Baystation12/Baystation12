/datum/build_mode/radiation
	name = "Radiation"
	icon_state = "mode_radiation"
	var/help_text = {"
Build Mode: Radiation - Visualizer for radiation sources & affected turfs.
"}


/datum/build_mode/radiation/Destroy()
	Unselected()
	. = ..()


/datum/build_mode/radiation/Help()
	to_chat(user, SPAN_NOTICE(help_text))


/datum/build_mode/radiation/Selected()
	if (!overlay)
		CreateOverlay()
	overlay.Show()


/datum/build_mode/radiation/Unselected()
	if (overlay)
		overlay.Hide()


/datum/build_mode/radiation/UpdateOverlay(atom/movable/M, turf/T)
	if (!overlay?.shown)
		return
	var/datum/radiation_source/R = SSradiation.sources_assoc[T]
	var/rads = SSradiation.get_rads_at_turf(T)
	if (rads)
		rads = min(round(log(2, max(rads*0.4, 2))), 8)
	if (R)
		M.icon_state = "bm_rads_source"
	else if (rads)
		M.icon_state = "bm_rads_str_[rads]"
	else
		M.icon_state = ""

