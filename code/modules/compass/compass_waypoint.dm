/datum/compass_waypoint
	var/name
	var/x
	var/y
	var/z
	var/color
	var/hidden = FALSE
	var/image/compass_overlay

/datum/compass_waypoint/proc/set_values(var/_name, var/_x, var/_y, var/_z, var/_color)
	name = _name
	x = _x
	y = _y
	z = _z
	color = _color
	compass_overlay = new /image/compass_marker
	compass_overlay.loc = src
	compass_overlay.maptext = "<center><font color = '[color]' size = '2px'><b>|</b>\n[name]</font></center>"
	compass_overlay.filters = filter(type="drop_shadow", color = "[color]" + "aa", size = 2, offset = 1,x = 0, y = 0)
	compass_overlay.layer = HOLOMAP_LAYER
	compass_overlay.plane = EFFECTS_ABOVE_LIGHTING_PLANE

/datum/compass_waypoint/proc/recalculate_heading(var/cx, var/cy)
	var/matrix/M = matrix()
	M.Translate(0, (name ? COMPASS_LABEL_OFFSET-4 : COMPASS_LABEL_OFFSET))
	M.Turn(Atan2(cy-y, cx-x)+180)
	compass_overlay.transform = M
