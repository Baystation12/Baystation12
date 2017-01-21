/obj/structure/window/New()
	..()
	for(var/obj/structure/table/T in view(src, 1))
		T.update_connections()
		T.update_icon()

/obj/structure/window/Destroy()
	var/oldloc = loc
	loc=null
	for(var/obj/structure/table/T in view(oldloc, 1))
		T.update_connections()
		T.update_icon()
	loc=oldloc
	..()

/obj/structure/window/Move()
	var/oldloc = loc
	. = ..()
	if(loc != oldloc)
		for(var/obj/structure/table/T in view(oldloc, 1) | view(loc, 1))
			T.update_connections()
			T.update_icon()