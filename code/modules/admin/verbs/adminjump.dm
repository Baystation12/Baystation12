/mob/proc/jumpTo(var/location)
	forceMove(location)

/mob/observer/ghost/jumpTo()
	stop_following()
	..()

/client/proc/Jump(var/selected_area in area_repository.get_areas_by_z_level())
	set name = "Jump to Area"
	set desc = "Area to jump to"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	if(!config.allow_admin_jump)
		return alert("Admin jumping disabled")

	var/list/areas = area_repository.get_areas_by_z_level()
	var/area/A = areas[selected_area]
	mob.jumpTo(pick(get_area_turfs(A)))
	log_and_message_admins("jumped to [A]")
	feedback_add_details("admin_verb","JA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/jumptoturf(var/turf/T in turfs)
	set name = "Jump to Turf"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	if(!config.allow_admin_jump)
		return alert("Admin jumping disabled")
		
	log_and_message_admins("jumped to [T.x],[T.y],[T.z] in [T.loc]")
	mob.jumpTo(T)
	feedback_add_details("admin_verb","JT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/jumptomob(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Jump to Mob"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		log_and_message_admins("jumped to [key_name(M)]")
		if(mob)
			var/turf/T = get_turf(M)
			if(T && isturf(T))
				feedback_add_details("admin_verb","JM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
				mob.jumpTo(T)
			else
				to_chat(mob, "This mob is not located in the game world.")
	else
		alert("Admin jumping disabled")

/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set category = "Admin"
	set name = "Jump to Coordinate"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(!config.allow_admin_jump)
		alert("Admin jumping disabled")
		return
	if(!mob)
		return

	var/turf/T = locate(tx, ty, tz)
	if(!T)
		return
	mob.jumpTo(T)

	feedback_add_details("admin_verb","JC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_and_message_admins("jumped to coordinates [tx], [ty], [tz]")

/proc/sorted_client_keys()
	return sortKey(clients.Copy())

/client/proc/jumptokey(client/C in sorted_client_keys())
	set category = "Admin"
	set name = "Jump to Key"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		if(!istype(C))
			to_chat(usr, "[C] is not a client, somehow.")
			return

		var/mob/M = C.mob
		log_and_message_admins("jumped to [key_name(M)]")
		mob.jumpTo(get_turf(M))
		feedback_add_details("admin_verb","JK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")

/client/proc/Getmob(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Get Mob"
	set desc = "Mob to teleport"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	if(config.allow_admin_jump)
		log_and_message_admins("teleported [key_name(M)] to self.")
		M.jumpTo(get_turf(mob))
		feedback_add_details("admin_verb","GM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")

/client/proc/Getkey()
	set category = "Admin"
	set name = "Get Key"
	set desc = "Key to teleport"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		var/list/keys = list()
		for(var/mob/M in player_list)
			keys += M.client
		var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
		if(!selection)
			return
		var/mob/M = selection:mob

		if(!M)
			return
		log_and_message_admins("teleported [key_name(M)] to self.")
		if(M)
			M.jumpTo(get_turf(mob))
			feedback_add_details("admin_verb","GK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")

/client/proc/sendmob(var/mob/M in sortmobs())
	set category = "Admin"
	set name = "Send Mob"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	if(!config.allow_admin_jump)
		alert("Admin jumping disabled")
		return

	var/list/areas = area_repository.get_areas_by_name()
	var/area/A = input(usr, "Pick an area.", "Pick an area") as null|anything in areas
	A = A ? areas[A] : A
	if(A)
		M.jumpTo(pick(get_area_turfs(A)))
		feedback_add_details("admin_verb","SMOB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		log_and_message_admins("teleported [key_name(M)] to [A].")

