/obj/lighting_plane
	screen_loc = "1,1"
	plane = LIGHTING_PLANE

	blend_mode = BLEND_MULTIPLY
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	// use 20% ambient lighting; be sure to add full alpha

	color = list(
			-1, 00, 00, 00,
			00, -1, 00, 00,
			00, 00, -1, 00,
			00, 00, 00, 00,
			01, 01, 01, 01
		)

	mouse_opacity = 0    // nothing on this plane is mouse-visible

/obj/lighting_general
	plane = LIGHTING_PLANE
	screen_loc = "8,8"

	icon = LIGHTING_ICON
	icon_state = LIGHTING_ICON_STATE_DARK

	color = "#ffffff"

	blend_mode = BLEND_MULTIPLY

/obj/lighting_general/Initialize()
	. = ..()
	var/matrix/M = matrix()
	M.Scale(world.view*2.2)

	transform = M

/obj/lighting_general/proc/sync(var/new_colour)
	color = new_colour

/mob
	var/obj/lighting_plane/l_plane
	var/obj/lighting_general/l_general


/mob/proc/change_light_colour(var/new_colour)
	if(l_general)
		l_general.sync(new_colour)
