/datum/admins/proc/capture_map(tx as null|num, ty as null|num, tz as null|num, range as null|num)
	set category = "Server"
	set name = "Capture Map Part"
	set desc = "Usage: Capture-Map-Part target_x_cord target_y_cord target_z_cord range (captures part of a map originating from bottom left corner)"

	if(!check_rights(R_ADMIN|R_DEBUG|R_SERVER))
		usr << "You are not allowed to use this command"
		return

	if(isnull(tx) || isnull(ty) || isnull(tz) || isnull(range))
		usr << "Capture Map Part, captures part of a map using camara like rendering."
		usr << "Usage: Capture-Map-Part target_x_cord target_y_cord target_z_cord range"
		usr << "Target coordinates specify bottom left corner of the capture, range defines render distance to opposite corner."
		return

	if(range > 32 || range <= 0)
		usr << "Capturing range is incorrect, it must be within 1-32."
		return

	if(locate(tx,ty,tz))
		var/cap = generate_image(tx ,ty ,tz ,range, CAPTURE_MODE_PARTIAL, null, 1, 1)
		var/file_name = "map_capture_x[tx]_y[ty]_z[tz]_r[range].png"
		usr << "Saved capture in cache as [file_name]."
		usr << browse_rsc(cap, file_name)
	else
		usr << "Target coordinates are incorrect."
