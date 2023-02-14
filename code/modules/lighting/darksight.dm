/obj/darksight
	plane = LIGHTING_PLANE

	icon = 'icons/mob/darksight.dmi'

	screen_loc = "CENTER-7,CENTER-7"

	blend_mode = BLEND_ADD

/obj/darksight/Initialize()
	. = ..()
	SetTransform((world.icon_size/DARKSIGHT_GRADIENT_SIZE) * 0.9)

/obj/darksight/proc/sync(new_colour)
	color = new_colour

/mob
	var/obj/darksight/darksight = null


/mob/proc/change_light_colour(new_colour)
	if(darksight)
		darksight.sync(new_colour)
