/datum/build_mode/meteor
	name = "Meteors"
	icon_state = "buildmode16"
	var/turf/entrance = null
	var/turf/exit = null
	var/list/meteors = list()
	var/turf/spawn_point = null
	var/help_text = {"\
********* Build Mode: Areas ********
Left Click          - Set spawn point for a meteor
Left Click Again    - Set direction of meteor AND spawn it
Right Click Icon    - Change meteor types

When a meteor is spawned, its type is randomly chosen from the list. The list must contain at least one meteor type.
************************************\
"}

/datum/build_mode/meteor/Help()
	to_chat(user, SPAN_NOTICE(help_text))

/datum/build_mode/meteor/Configurate()
	var/choice = alert("Add or remove a meteor type from the list?", "Add/Remove", "Add", "Remove", "Cancel")

	if (choice == "Add")
		var/obj/effect/meteor/M = select_subpath(/obj/effect/meteor)

		if (M)
			meteors += M
			to_chat(user, "Added [M] to the list of meteor types.")

	if (choice == "Remove")
		var/obj/effect/meteor/M = input("Choose a meteor type to remove", "Meteor List") as null | anything in meteors
		if (M)
			meteors -= M
			to_chat(user, "Removed [M] from the list of meteor types.")

/datum/build_mode/meteor/OnClick(atom/A, list/parameters)
	if (parameters["left"])
		if (!length(meteors))
			to_chat(user, SPAN_NOTICE("You must specify at least one meteor type to spawn first!"))
			return
		var/turf/T = get_turf(A)

		if (!T)
			to_chat(user, SPAN_NOTICE("Could not get turf at this location!"))
			return

		if (!spawn_point)
			spawn_point = T


			to_chat(user, SPAN_NOTICE("Spawn point set. Click again to set direction."))
			return

		var/dir = get_dir(spawn_point, get_turf(A))

		if (dir)
			spawn_meteor(dir)
			spawn_point = null
			return

	else if (parameters["right"])
		entrance = null
		exit = null
		to_chat(user, SPAN_NOTICE("Selection cancelled."))


/datum/build_mode/meteor/proc/spawn_meteor(direction)
	set waitfor = FALSE

	var/Me = pickweight(meteors)
	var/obj/effect/meteor/M = new Me(spawn_point)
	var/turf/edge = get_edge_target_turf(spawn_point, direction)
	walk_towards(M, edge, 3)
