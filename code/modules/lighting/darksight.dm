/obj/darksight
	plane = LIGHTING_PLANE

	icon = 'icons/mob/darksight.dmi'

	screen_loc = "CENTER-7,CENTER-7"

	blend_mode = BLEND_ADD
	invisibility = INVISIBILITY_LIGHTING
	alpha = 0 //By default make it transparent so mobs that don't update it also don't get it

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
