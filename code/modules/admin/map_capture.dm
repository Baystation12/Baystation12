/datum/admins/proc/toggle_capture_mode()
	set category = "Server"
	set name = "Toggle Map Capture Mode"
	if(/datum/admins/proc/capture_map in usr.verbs)
		//Remove verbs
		usr.verbs -= /datum/admins/proc/capture_map
		usr.verbs -= /datum/admins/proc/capture_map_all
	else
		//Add verbs
		usr.verbs += /datum/admins/proc/capture_map
		usr.verbs += /datum/admins/proc/capture_map_all


/datum/admins/proc/capture_map(tx as num, ty as num, tz as num, range as num)
	set category = "Tools"
	set name = "Capture Map Part"

	if(!check_rights(R_ADMIN|R_DEBUG|R_SERVER))
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
						var/answer = alert("Capture includes non existant turf, continue capture?", "Yes", "No")
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
					if(istype(A, /mob/living) && A.lying)
						img.BecomeLying()
					var/xoff = (A.x - tx) * 32
					var/yoff = (A.y - ty) * 32
					cap.Blend(img, blendMode2iconMode(A.blend_mode),  A.pixel_x + xoff, A.pixel_y + yoff)

		for(var/turf/Tu in turfstocapture)
			var/xoff = (Tu.x - tx) * 32
			var/yoff = (Tu.y - ty) * 32
			//What this even does?
			//cap.Blend(getFlatIcon(Tu.loc), blendMode2iconMode(Tu.blend_mode), xoff, yoff)

		usr << browse_rsc(cap, "map_capture_x[tx]_y[ty]_z[tz]_r[range].png")


/datum/admins/proc/capture_map_all(z as num)
	set category = "Tools"
	set name = "Generate map capturing links"
	var/x_tile = 255 / 17
	var/y_tile = 255 / 17
	for(var/xt = 0 to x_tile)
		for(var/yt = 0 to y_tile)
			var/captileX = xt ? xt * 17 : 1
			var/captileY = yt ? yt * 17 : 1

			usr << "<a href='?src=\ref[/datum/admins/map_capture];action=capture;x=[captileX];y=[captileY];z=[z];r=17'>Capture tile [xt]:[yt]</a>"


/datum/admins/map_capture/Topic(href, href_list[])
	if(href_list["action"] == "capture")
		capture_map(text2num(href_list["x"]),text2num(href_list["y"]),text2num(href_list["z"]),text2num(href_list["r"]))