/atom/movable/cultify()
	var/turf/T = get_turf(src)
	if(T.holy)
		return
	..()

/obj/structure/grille/cultify()
	..()
	var/turf/T = get_turf(src)
	qdel(src)
	new /obj/structure/grille/cult(T)


/obj/structure/window/cultify()
	..()
	var/turf/T = get_turf(src)
	qdel(src)
	var/obj/structure/window/cult/W = new(T)
	W.dir = dir
	W.silicate = silicate
	W.update_icon()