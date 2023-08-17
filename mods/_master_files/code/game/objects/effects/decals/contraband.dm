/obj/structure/sign/poster/set_poster(poster_type)
	var/singleton/poster/design = GET_SINGLETON(poster_type)
	icon = design.icon
