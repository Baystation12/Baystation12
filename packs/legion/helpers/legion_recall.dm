/**
 * Triggers a warp effect and relocates the mob to destination, if provided, or deletes it.
 */
/proc/legion_recall(mob/recallee, turf/destination)
	if (destination && !isturf(destination))
		destination = get_turf(destination)
	recallee.visible_message(
		SPAN_WARNING("\The [recallee] suddenly warps away!"),
		SPAN_LEGION("The Nexus recalls you[destination ? " to a new location" : null]...")
	)
	legion_warp_effect(get_turf(recallee))
	if (destination)
		recallee.dropInto(destination)
	else
		qdel(recallee)


/**
 * Triggers a sequence of "recalls" on legion mobs in connected z-levels, representation a mass retreat, exodus, etc.
 *
 * There is a 0.1 second delay between each mob being yoinked for added flair.
 */
/proc/legion_mass_recall(affected_z)
	var/list/connected_z = GetConnectedZlevels(affected_z)
	var/list/mobs_to_recall = list()

	for (var/mob/mob in GLOB.all_legion_mobs)
		if (get_z(mob) in connected_z)
			mobs_to_recall += mob

	legion_mass_recall_recurse(mobs_to_recall)

/proc/legion_mass_recall_recurse(list/remaining)
	if (!length(remaining))
		return
	var/mob/recallee = pick_n_take(remaining)
	legion_recall(recallee)
	addtimer(new Callback(GLOBAL_PROC, /proc/legion_mass_recall_recurse, remaining), 0.1 SECONDS)


/client/proc/cmd_legion_mass_recall()
	set category = "Special Verbs"
	set name = "Legion Mass Recall"
	set desc = "'Recalls' all legion mobs in connected z-levels."

	if (!check_rights(R_ADMIN))
		return

	var/z_level = input(usr, "Which z-level? Your own z-level is entered by default.", "Legion Narrate", get_z(usr)) as null | num
	if (!z_level)
		return

	legion_mass_recall(z_level)


/// Helper proc for admins to call directly on a mob to run `legion_recall()` on it.
/mob/proc/legion_recall_me(turf/destination)
	legion_recall(src, destination)
