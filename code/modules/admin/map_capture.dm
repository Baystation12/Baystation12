/datum/admins/proc/capture_map(tx as null|num, ty as null|num, tz as null|num, range as null|num)
	set category = "Server"
	set name = "Capture Map Part"
	set desc = "Usage: Capture-Map-Part target_x_cord target_y_cord target_z_cord range (captures part of a map originating from bottom left corner)"

	if(!check_rights(R_ADMIN|R_DEBUG|R_SERVER))
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
		var/list/turfstocapture = list()
		var/hasasked = 0
		for(var/xoff = 0 to range)
			for(var/yoff = 0 to range)
				var/turf/T = locate(tx + xoff,ty + yoff,tz)
				if(T)
					turfstocapture.Add(T)
				else
					if(!hasasked)
						var/answer = alert("Capture includes non existant turf, Continue capture?","Continue capture?", "No", "Yes")
						hasasked = 1
						if(answer == "No")
							return

		var/list/atoms = list()
		for(var/turf/T in turfstocapture)
			atoms.Add(T)
			for(var/atom/A in T)
				if(A.invisibility) continue
				atoms.Add(A)

		atoms = sort_atoms_by_layer(atoms)
		var/icon/cap = icon('icons/effects/96x96.dmi', "")
		cap.Scale(range*32, range*32)
		cap.Blend("#000", ICON_OVERLAY)
		for(var/atom/A in atoms)
			if(A)
				var/icon/img = getFlatIcon(A)
				if(istype(img, /icon))
					if(istype(A, /mob/living) && A:lying)
						img.BecomeLying()
					var/xoff = (A.x - tx) * 32
					var/yoff = (A.y - ty) * 32
					cap.Blend(img, blendMode2iconMode(A.blend_mode),  A.pixel_x + xoff, A.pixel_y + yoff)

		var/file_name = "map_capture_x[tx]_y[ty]_z[tz]_r[range].png"
		usr << "Saved capture in cache as [file_name]."
		usr << browse_rsc(cap, file_name)
	else
		usr << "Target coordinates are incorrect."
