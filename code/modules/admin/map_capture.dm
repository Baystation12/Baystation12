/datum/admins/proc/capture_map_part(tx as null|num, ty as null|num, tz as null|num, range as null|num)
	set category = "Server"
	set name = "Capture Map Part"
	set desc = "Usage: Capture-Map-Part target_x_cord target_y_cord target_z_cord range (captures part of a map originating from bottom left corner)"

	if(!check_rights(R_ADMIN|R_DEBUG|R_SERVER))
		to_chat(usr, "You are not allowed to use this command")
		return

	if(isnull(tx) || isnull(ty) || isnull(tz) || isnull(range))
		to_chat(usr, "Capture Map Part, captures part of a map using camara like rendering.")
		to_chat(usr, "Usage: Capture-Map-Part target_x_cord target_y_cord target_z_cord range")
		to_chat(usr, "Target coordinates specify bottom left corner of the capture, range defines render distance to opposite corner.")
		return

	if(range > 32 || range <= 0)
		to_chat(usr, "Capturing range is incorrect, it must be within 1-32.")
		return

	if(locate(tx,ty,tz))
		var/ligths = 0
		if(alert("Do you want lighting to be included in capture?", "Map Capture", "No", "Yes") == "Yes")
			ligths = 1
		var/cap = generate_image(tx ,ty ,tz ,range, CAPTURE_MODE_PARTIAL, null, ligths, 1)
		var/file_name = "map_capture_x[tx]_y[ty]_z[tz]_r[range].png"
		to_chat(usr, "Saved capture in cache as [file_name].")
		send_rsc(usr, cap, file_name)
	else
		to_chat(usr, "Target coordinates are incorrect.")

/datum/admins/proc/capture_map_capture_next(currentz, currentx, currenty, ligths)
	if(locate(currentx, currenty, currentz))
		var/cap = generate_image(currentx ,currenty ,currentz ,32, CAPTURE_MODE_PARTIAL, null, ligths, 1)
		var/file_name = "map_capture_x[currentx]_y[currenty]_z[currentz]_r32.png"
		to_chat(usr, "Saved capture in cache as [file_name].")
		send_rsc(usr, cap, file_name)
		currentx = currentx + 32
		addtimer(CALLBACK(src, .proc/capture_map_capture_next, currentz, currentx, currenty, ligths), 0)
	else
		currenty = currenty + 32
		currentx = 1
		if(locate(currentx, currenty, currentz))
			var/cap = generate_image(currentx ,currenty ,currentz ,32, CAPTURE_MODE_PARTIAL, null, ligths, 1)
			var/file_name = "map_capture_x[currentx]_y[currenty]_z[currentz]_r32.png"
			to_chat(usr, "Saved capture in cache as [file_name].")
			send_rsc(usr, cap, file_name)
			currentx = currentx + 32
			addtimer(CALLBACK(src, .proc/capture_map_capture_next, currentz, currentx, currenty, ligths), 0)
		else
			to_chat(usr, "End of map, capture is done.")

/datum/admins/proc/capture_map(tz as null|num)
	set category = "Server"
	set name = "Capture Map"
	set desc = "Usage: Capture-Map target_z_cord (captures map)"

	if(!check_rights(R_ADMIN|R_DEBUG|R_SERVER))
		to_chat(usr, "You are not allowed to use this command")
		return

	if(isnull(tz))
		to_chat(usr, "Map Part, map using camara like rendering.")
		to_chat(usr, "Usage: Capture-Map target_z_cord")
		to_chat(usr, "Target Z coordinates define z level to capture.")
		return

	if(!locate(1, 1, tz))
		to_chat(usr, "Target z-level is incorrect.")
		return

	var/ligths = 0
	if(alert("Do you want lighting to be included in capture?", "Map Capture", "No", "Yes") == "Yes")
		ligths = 1

	switch(alert("Are you sure? (This will cause masive lag!!!)", "Map Capture", "No", "Yes"))
		if("Yes")
			usr.client.holder.capture_map_capture_next(tz, 1, 1, ligths)
