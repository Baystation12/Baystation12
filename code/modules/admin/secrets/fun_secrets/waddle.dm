/datum/admin_secret_item/fun_secret/waddle
	name = "Toggle all waddling"
	var/all_waddling = FALSE

/datum/admin_secret_item/fun_secret/waddle/do_execute(mob/user)
	all_waddling = !all_waddling
	for (var/mob/L in GLOB.player_list)
		if (all_waddling)
			L.make_waddle()
		else
			L.stop_waddle()
