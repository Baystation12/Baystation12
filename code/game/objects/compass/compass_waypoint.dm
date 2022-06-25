/datum/compass_waypoint
	var/name
	var/x
	var/y
	var/z
	var/color
	var/hidden = FALSE
	var/image/compass_marker/compass_overlay

/datum/compass_waypoint/proc/set_values(var/_name, var/_x, var/_y, var/_z, var/_color)
	name = _name
	x = _x
	y = _y
	z = _z
	color = _color
	compass_overlay = new
	compass_overlay.loc = src

	compass_overlay.maptext = STYLE_SMALLFONTS_OUTLINE("<center><b>|</b>\n[uppertext(name)]</center>", 9, color, COLOR_BLACK)
	compass_overlay.filters = filter(type="drop_shadow", color = "[color]" + "aa", size = 2, offset = 1,x = 0, y = 0)
	compass_overlay.layer = HUD_BASE_LAYER
	compass_overlay.plane = HUD_PLANE

/datum/compass_waypoint/proc/recalculate_heading(var/cx, var/cy, var/translate_val)
	var/matrix/M = matrix()
	if(name)
		translate_val -= 4
	M.Translate(0, translate_val)
	M.Turn(Atan2(cy-y, cx-x)+180)
	compass_overlay.transform = M
