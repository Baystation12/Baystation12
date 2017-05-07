/datum/evacuation_controller/bluespace
	name = "bluespace jump controller"
	evac_prep_delay = 10 MINUTES
	evac_launch_delay =  2 MINUTES
	evac_transit_delay = 3 MINUTES
	var/list/saved = list()

/datum/evacuation_controller/bluespace/launch_evacuation()
	if(!..())
		return 0
	world.maxz++	//create a place for stragglers
	using_map.sealed_levels |= world.maxz
	for(var/mob/living/M in mob_list)
		if(M.z in using_map.station_levels)
			var/area/A = get_area(M)
			if(istype(A,/area/space)) //straggler
				var/turf/T = locate(M.x,M.y,world.maxz)
				if(T)
					M.forceMove(T)
			else
				if(M.client)
					M.client.color = "#5050FF"
				M.incorporeal_move = 1
				saved |= M

/datum/evacuation_controller/bluespace/finish_evacuation()
	..()
	for(var/mob/living/M in saved)
		if(M.client)
			M.client.color = null
		M.incorporeal_move = 0
		var/turf/T = get_turf(M)
		if(T.density)
			M << "<span class='danger'>[T] suddenly appears inside you!</span>"
			M.gib()