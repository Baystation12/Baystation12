/datum/build_mode/areas
	name = "Area Editor"
	icon_state = "buildmode10"
	var/help_text = {"\
********* Build Mode: Areas ********
Left Click        - Set Turf Area
Left Click + Ctrl - Copy Turf Area
Middle Click      - Copy Turf Area
Right Click       - List/Create Area
************************************\
"}

	var/area/selected_area
	var/color_pool/colors

/datum/build_mode/areas/Destroy()
	UnselectArea()
	Unselected()
	. = ..()

/datum/build_mode/areas/Help()
	to_chat(user, SPAN_NOTICE(help_text))

/datum/build_mode/areas/Selected()
	if (!overlay)
		CreateOverlay("whiteOverlay")
	colors = new
	overlay.Show()

/datum/build_mode/areas/Unselected()
	if (overlay)
		overlay.Hide()
	QDEL_NULL(colors)

/datum/build_mode/areas/UpdateOverlay(atom/movable/M, turf/T)
	if (!overlay?.shown)
		return
	M.color = colors.get(T.loc)

/datum/build_mode/areas/OnClick(var/atom/A, var/list/parameters)
	if (parameters["right"])
		Configurate()
		return
	var/turf/T = get_turf(A)
	var/area/R = T?.loc
	if ((!T) || (!R))
		return
	if (parameters["ctrl"] || parameters["middle"])
		selected_area = R
		to_chat(user, "Picked area [selected_area.name]")
	else if (selected_area)
		ChangeArea(T, selected_area)
		to_chat(user, "Set area of turf [T.name] to [selected_area.name]")
	else
		to_chat(user, "Pick or create an area first")

/datum/build_mode/areas/Configurate()
	var/mode = alert("Pick or Create an area.", "Build Mode: Areas", "Pick", "Create", "Cancel")
	if (mode == "Pick")
		var/area/path = select_subpath((selected_area?.type || /area/space), /area)
		if (path)
			for (var/area/R in world)
				if (R.type == path)
					SelectArea(R)
					to_chat(user, "Picked area [selected_area.name]")
					break
	else if (mode == "Create")
		var/new_name = input("New area name:", "Build Mode: Areas") as text|null
		if (!new_name)
			return
		var/area/new_area = new
		new_area.SetName(new_name)
		new_area.power_equip = 0
		new_area.power_light = 0
		new_area.power_environ = 0
		new_area.always_unpowered = 0
		SelectArea(new_area)
		user.client.debug_variables(selected_area)
		to_chat(user, "Created area [new_area.name]")

/datum/build_mode/areas/proc/SelectArea(var/area/A)
	if(!A || A == selected_area)
		return
	UnselectArea()
	selected_area = A
	GLOB.destroyed_event.register(selected_area, src, .proc/UnselectArea)

/datum/build_mode/areas/proc/UnselectArea()
	if(!selected_area)
		return
	GLOB.destroyed_event.unregister(selected_area, src, .proc/UnselectArea)

	var/has_turf = FALSE
	for(var/turf/T in selected_area)
		has_turf = TRUE
		break
	if(!has_turf)
		qdel(selected_area)
	selected_area = null
