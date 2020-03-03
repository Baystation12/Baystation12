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
	var/list/distinct_colors = list(
		"#e6194b", "#3cb44b", "#ffe119", "#4363d8", "#f58231", "#42d4f4",
		"#f032e6", "#fabebe", "#469990", "#e6beff", "#9a6324", "#fffac8",
		"#800000", "#aaffc3", "#000075", "#a9a9a9", "#ffffff", "#000000"
	)
	var/area/selected_area
	var/list/vision_images = list()

/datum/build_mode/areas/Destroy()
	UnselectArea()
	Unselected()
	. = ..()

/datum/build_mode/areas/Help()
	to_chat(user, SPAN_NOTICE(help_text))

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

/datum/build_mode/areas/TimerEvent()
	user.client.images -= vision_images
	vision_images = list()

	var/used_colors = 0
	var/list/max_colors = length(distinct_colors)
	var/list/vision_colors = list()
	for (var/turf/T in range(user.client.view, user))
		var/image/I = new('icons/turf/overlays.dmi', T, "whiteOverlay")
		var/ref = "\ref[T.loc]"
		if (!vision_colors[ref])
			if (++used_colors > max_colors)
				vision_colors[ref] = "#" + copytext(md5(ref), 1, 7)
			else
				vision_colors[ref] = distinct_colors[used_colors]
		I.color = vision_colors[ref]
		vision_images.Add(I)
	user.client.images += vision_images

/datum/build_mode/areas/Unselected()
	user.client.images -= vision_images
	vision_images = list()

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
