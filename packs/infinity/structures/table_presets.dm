/obj/structure/table/wallf/New()
	..()
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put

/obj/structure/table/wallf/can_connect()
	return FALSE

/obj/structure/table/wallf/on_update_icon()
	if(material)
		if(material.icon_colour)
			src.color = material.icon_colour

/obj/structure/table/wallf
	icon = 'packs/infinity/icons/obj/tables.dmi'
	icon_state = "wallf_regular"
	color = COLOR_OFF_WHITE
	material = MATERIAL_PLASTIC
	reinforced = DEFAULT_WALL_MATERIAL
	flipped = -1

/obj/structure/table/wallf/can_connect()
	return FALSE

/obj/structure/table/wallf/New()
	..()
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put

/obj/structure/table/wallf/steel
	color = COLOR_GRAY40
	material = DEFAULT_WALL_MATERIAL
	reinforced = DEFAULT_WALL_MATERIAL

/obj/structure/table/wallf/marble
	icon_state = "wallf_marble"
	color = COLOR_GRAY80
	material = "marble"
