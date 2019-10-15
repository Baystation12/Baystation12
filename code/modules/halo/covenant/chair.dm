/obj/structure/bed/chair/covenant
	icon = 'code/modules/halo/covenant/chair.dmi'
	icon_state = "coviechair_preview"
	base_icon = "coviechair"
	material_alteration = MATERIAL_ALTERATION_NONE

/obj/structure/bed/chair/covenant/update_icon()
	return

/obj/structure/bed/chair/covenant/set_dir()
	..()
	overlays = null
	var/image/O = image(icon = 'code/modules/halo/covenant/chair.dmi', icon_state = "[base_icon]_over", dir = src.dir)
	O.plane = ABOVE_HUMAN_PLANE
	O.layer = ABOVE_HUMAN_LAYER
	overlays += O
	if(buckled_mob)
		buckled_mob.set_dir(dir)

/obj/structure/bed/chair/covenant_stool
	name = "anti-grav stool"
	icon = 'code/modules/halo/covenant/chair.dmi'
	icon_state = "coviestool"
	base_icon = "coviestool"
	material_alteration = MATERIAL_ALTERATION_NONE

/obj/structure/bed/chair/covenant_stool/update_icon()
	return
