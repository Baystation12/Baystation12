
/obj/effect/overmap/ship/nilfheim
	name = "Nilfheim Prison Facility"
	desc = "A large, reinforced prison structure."

/obj/effect/overmap/ship/nilfheim_shuttle
	name = "Nilfheim Transport Shuttle"
	desc = "A small shuttle used to move prisoners to and from the Nilfheim facility"

/obj/effect/overmap/ship/nilfheim_shuttle/Initialize()
	. = ..()
	var/obj/n_heim
	for(var/obj/effect/overmap/ship/nilfheim/n in world)
		n_heim = n
	if(isnull(n_heim))
		return
	forceMove(n_heim)
