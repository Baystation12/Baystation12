/obj/structure/window/Initialize()
	. = ..()
	for(var/obj/structure/table/T in oview(src, 1))
		T.update_connections()
		ADD_ICON_QUEUE(T)

/obj/structure/window/Destroy()
	var/oldloc = loc
	. = ..()
	for(var/obj/structure/table/T in view(oldloc, 1))
		T.update_connections()
		ADD_ICON_QUEUE(T)

/obj/structure/window/Move()
	var/oldloc = loc
	. = ..()
	if(loc != oldloc)
		for(var/obj/structure/table/T in view(oldloc, 1) | view(loc, 1))
			T.update_connections()
			ADD_ICON_QUEUE(T)