GLOBAL_LIST_INIT(mob_spawners, list())

/datum/build_mode/mob_mode
	name = "Mob Spawning"
	icon_state = "buildmode11"
	var/area/current_area
	var/turf/current_turf
	var/turf/center
	var/list/copied_spawner = list()
	var/help_text = {"\
	***** Build Mode: Mob Spawner ******
	Left Click         - Create/Edit Spawner
	Left Click + Ctrl  - Copy Spawner
	Right Click        - Delete Spawner
	Right Click + Ctrl - Paste Spawner

	Definitions:
	Interval: The interval mobs will spawn on (in seconds)
	Variation: Adds a random number of seconds to the interval for each mob spawn, in the range of 0 - Variation.
	Left to spawn: How many mobs will be spawned by the spawner. (set to 0 to spawn mobs indefinitely).
	Radius: The radius in which mobs can spawn from around the designated center, (set to -1 to spawn anywhere in area).
	Mobs: List of mobs the spawner will randomly choose from when spawning a mob.
	Messages: List of visible messages that will be displayed to players who see a mob spawned.
	************************************\
	"}

	var/list/distinct_colors = list(
		"#e6194b", "#3cb44b", "#ffe119", "#4363d8", "#f58231", "#42d4f4",
		"#f032e6", "#fabebe", "#469990", "#e6beff", "#9a6324", "#fffac8",
		"#800000", "#aaffc3", "#000075", "#a9a9a9", "#ffffff", "#000000"
	)
	var/area/selected_area
	var/list/vision_images = list()

/datum/build_mode/mob_mode/Help()
	to_chat(user, SPAN_NOTICE(help_text))

/datum/build_mode/mob_mode/ui_interact(mob/user, ui_key = "mob_spawner", datum/nanoui/ui = null, force_open = 1, var/master_ui = null, var/datum/topic_state/state = GLOB.default_state)
	. = ..()

	if (!current_turf || !current_area)
		to_chat(user, SPAN_WARNING("Could not get an area and/or turf from the selected atom!"))
		return

	var/datum/mob_spawner/spawner = GLOB.mob_spawners[current_turf]

	if (!spawner)
		if (ui)
			ui.close()
		return

	var/data[0]
	data["area"] = current_area
	data["area_name"] = current_area.name
	data["mobs"] = spawner.mobs
	data["messages"] = spawner.messages
	data["message_class"] = spawner.message_class
	data["interval"] = spawner.interval
	data["variation"] = spawner.variation
	data["radius"] = spawner.radius
	data["atmos_immune"] = spawner.atmos_immune
	data["spawn_count"] = spawner.spawn_count
	data["paused"] = spawner.paused


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "mob_mode.tmpl", src.name, 425, 600, master_ui = master_ui, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/build_mode/mob_mode/CanUseTopic(mob/user)
	if (!is_admin(user))
		return STATUS_CLOSE
	return ..()

/datum/build_mode/mob_mode/Topic(user, href_list)
	..()
	var/datum/mob_spawner/spawner = GLOB.mob_spawners[current_turf]

	if (!spawner)
		return TOPIC_HANDLED

	if (href_list["pick"])
		var/type = input("Search for a mob", "Mob") as text
		var/list/types = typesof(/mob/living/simple_animal)
		var/list/matches = new()

		for (var/M in types)
			if (findtext("[M]", type))
				matches += M

		if (!matches.len)
			return TOPIC_HANDLED

		var/mob/living/simple_animal/chosen
		if(matches.len==1)
			chosen = matches[1]
		else
			chosen = input("Choose a mob", "Mob") as null | anything in matches

		if (!chosen)
			return TOPIC_HANDLED

		if (!(chosen in spawner.mobs))
			spawner.mobs += chosen

		return TOPIC_HANDLED

	if (href_list["remove"])
		var/chosen = input("Choose mob to remove", "Mob") as null | anything in spawner.mobs

		if (!chosen)
			return TOPIC_HANDLED

		spawner.mobs -= chosen

		return TOPIC_HANDLED

	if (href_list["set_spawn_count"])
		var/count = input("Set how many mobs will spawn:", "Mob Spawner") as num | null

		if (isnull(count))
			return TOPIC_HANDLED

		spawner.spawn_count = count

		return TOPIC_HANDLED

	if (href_list["set_spawn_interval"])
		var/count = input("Set the interval mobs spawn on (in seconds):", "Mob Spawner") as num | null

		if (isnull(count))
			return TOPIC_HANDLED

		spawner.interval = count SECONDS
		spawner.next_spawn_time = 0

		return TOPIC_HANDLED

	if (href_list["set_spawn_time_variation"])
		var/count = input("Set the random max variation of the spawn interval:", "Mob Spawner") as num | null

		if (!count)
			return

		spawner.variation = count SECONDS

		return TOPIC_HANDLED

	if (href_list["set_radius"])
		var/radius = input("Set the radius mobs can spawn in:", "Mob Spawner") as num | null

		if (isnull(radius))
			return TOPIC_HANDLED

		spawner.radius = radius

		return TOPIC_HANDLED

	if (href_list["atmos_immune"])
		spawner.atmos_immune = !spawner.atmos_immune

		return TOPIC_HANDLED

	if (href_list["add_message"])
		var/message = input("Enter a VISIBLE message to display alongside spawning mobs:", "Mob Spawner") as text | null

		if (!message)
			return TOPIC_HANDLED

		spawner.messages += message

		return TOPIC_HANDLED

	if (href_list["remove_message"])
		var/message = input("Choose a message to remove:", "Mob Spawner") as null | anything in spawner.messages

		if (!message)
			return TOPIC_HANDLED

		spawner.messages -= message

		return TOPIC_HANDLED

	if (href_list["set_span_class"])
		var/list/classes = list(
			"italic",
			"bold",
			"notice",
			"warn",
			"danger",
			"occult",
			"mfauna",
			"subtle",
			"info",
			"none"
		)

		var/class = input("Pick a span-class to be applied to the spawn message:", "Mob Spawner") as null | anything in classes

		if (!class)
			return TOPIC_HANDLED

		spawner.message_class = class

		return TOPIC_HANDLED

	if (href_list["pause"])
		spawner.paused = !spawner.paused

		if (spawner.paused)
			STOP_PROCESSING(SSprocessing, spawner)
		else
			START_PROCESSING(SSprocessing, spawner)

		return TOPIC_HANDLED

	if (href_list["delete"])
		var/datum/nanoui/ui = SSnano.try_update_ui(user, src, "mob_spawner", null)
		if (ui)
			ui.close()

		qdel(GLOB.mob_spawners[current_turf])

		return TOPIC_HANDLED

/datum/build_mode/mob_mode/TimerEvent()
	if (!user.client)
		return
	user.client.images -= vision_images
	vision_images = list()

	var/used_colors = 0
	var/list/max_colors = length(distinct_colors)
	var/list/vision_colors = list()
	for (var/turf/T in GLOB.mob_spawners)
		var/image/I = new('icons/turf/overlays.dmi', T, "whiteOverlay")
		var/ref = "\ref[T.loc]"
		if (!vision_colors[ref])
			if (++used_colors > max_colors)
				vision_colors[ref] = "#" + copytext(md5(ref), 1, 7)
			else
				vision_colors[ref] = distinct_colors[used_colors]
		I.color = vision_colors[ref]
		I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		I.appearance_flags = RESET_COLOR|RESET_ALPHA|RESET_TRANSFORM|NO_CLIENT_COLOR|KEEP_APART
		vision_images.Add(I)
	user.client.images += vision_images

/datum/build_mode/mob_mode/Unselected()
	if (user.client)
		user.client.images -= vision_images
	vision_images = list()

/datum/build_mode/mob_mode/OnClick(atom/object, list/pa)
	current_area = get_area(object)
	current_turf = get_turf(object)

	if(!current_area)
		to_chat(user, SPAN_WARNING("Selected atom is not in an area, a spawner cannot be put here!"))
		return

	if(!current_turf)
		to_chat(user, SPAN_WARNING("That atom does not have a turf!"))
		return

	var/datum/mob_spawner/spawner = GLOB.mob_spawners[current_turf]

	if (!spawner)
		spawner = new /datum/mob_spawner
		spawner.area = current_area
		GLOB.mob_spawners[current_turf] = spawner

		spawner.center = current_turf
		to_chat(user, "Spawner created in [current_area].")

	if (pa["ctrl"])
		if (pa["left"])
			copied_spawner = spawner.copy()
			to_chat(user, "Spawner from area [current_area] copied.")

		else if (pa["right"])
			if (copied_spawner.len == 0)
				to_chat(user, SPAN_WARNING("No spawner copied, cannot paste settings!"))
				return

			spawner.paste(copied_spawner)
			to_chat(user, "Spawner pasted in area [current_area].")

	else if (pa["left"])
		ui_interact(user)

	else if (pa["right"])
		if (spawner)
			QDEL_NULL(spawner)
			to_chat(user, "Deleted spawner in [current_area].")



/datum/build_mode/mob_mode/Destroy()
	. = ..()

	if (user.client)
		user.client.images -= vision_images
	vision_images = list()