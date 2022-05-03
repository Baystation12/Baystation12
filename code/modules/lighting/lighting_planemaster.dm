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
	var/obj/lighting_general/l_general


/mob/proc/change_light_colour(var/new_colour)
	if(l_general)
		l_general.sync(new_colour)
