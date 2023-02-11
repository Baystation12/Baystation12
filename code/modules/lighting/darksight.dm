/obj/darksight
	plane = LIGHTING_PLANE
	screen_loc = "8,8"

	icon = LIGHTING_ICON
	icon_state = LIGHTING_TRANSPARENT_ICON_STATE

	color = DARKTINT_NONE

	blend_mode = BLEND_OVERLAY
	var/stop_sync = FALSE
	alpha = 1

/obj/darksight/Initialize()
	. = ..()
	SetTransform(scale = world.view * 2.2)

/obj/darksight/proc/sync(new_colour)
	if(stop_sync)
		return
	color = new_colour

/mob
	var/obj/darksight/darksight


/mob/proc/change_light_colour(new_colour)
	if(darksight)
		darksight.sync(new_colour)
