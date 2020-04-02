/datum/random_room/mimic
	var/mimic_type = /obj/structure/closet/crate
	var/list/mimic_vars = list()
	var/chance_of_mimic = 5

/datum/random_room/mimic/apply_to_map(var/xorigin,var/yorigin,var/zorigin)
	item_spawns = list()
	var/truex = xorigin + x - 1
	var/truey = yorigin + y - 1
	var/turf/T = locate(truex + round(width/2), truey+round(height/2), zorigin)
	var/obj/structure/closet/C = new mimic_type(T)
	item_spawns += C
	if(prob(chance_of_mimic) && mimic_type)
		new /mob/living/simple_animal/hostile/mimic/sleeping(get_turf(C),C)

//BASICALLY:
//Create mimic in center of room.
//put loot inside said mimic


//don't want to keep references to said mimic or closet. Would cause qdel issues.
//so since we know nothing should get moved since we placed it we just find it again.
//inefficient yes but will not cause issues with qdel