//---------- external shield generator
//generates an energy field that loops around any built up area in space (is useless inside) halts movement and airflow, is blocked by walls, windows, airlocks etc

/obj/machinery/shield_gen/external
	name = "hull shield generator"

/obj/machinery/shield_gen/external/New()
	..()

/obj/machinery/shield_gen/external/get_shielded_turfs()
	var
		list
			open = list(get_turf(src))
			closed = list()

	while(open.len)
		for(var/turf/T in open)
			for(var/turf/O in orange(1, T))
				if(get_dist(O,src) > field_radius)
					continue
				var/add_this_turf = 0
				if(istype(O,/turf/space))
					for(var/turf/simulated/G in orange(1, O))
						add_this_turf = 1
						break

					//uncomment this for structures (but not lattices) to be surrounded by shield as well
					/*if(!add_this_turf)
						for(var/obj/structure/S in orange(1, O))
							if(!istype(S, /obj/structure/lattice))
								add_this_turf = 1
								break
					if(add_this_turf)
						for(var/obj/structure/S in O)
							if(!istype(S, /obj/structure/lattice))
								add_this_turf = 0
								break*/

					if(add_this_turf && !(O in open) && !(O in closed))
						open += O
			open -= T
			closed += T

	return closed
