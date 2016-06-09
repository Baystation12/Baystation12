/datum/random_room/tomb/
	var/list/corpses = list("human" = 1)
	var/direction = 0 //0 horizontal 1 vertical
	var/chance_of_corpse = 30



//attempts to line the walls with coffins with corpses inside
/datum/random_room/tomb/apply_to_map(var/xorigin, var/yorigin, var/zorigin)
	item_spawns = list()
	direction = pick(0,1)
	var/limit = (direction ? height : width)
	for(var/i = 0, i < limit - 2, i++)
		var/truex = xorigin + (direction ? 0 : i) + x
		var/truey = yorigin + (direction ? i : 0) + y
		var/turf/T1 = locate(truex,truey,zorigin)
		var/turf/T2 = locate(truex + (direction ? width - 3 : 0), truey + (direction ? 0 : height - 3), zorigin)
		var/turf/check = locate(truex + (direction ? -1 : 0), truey + (direction ? 0 : -1), zorigin)
		if(check.density && !T1.density && !T1.contents.len)
			var/obj/structure/closet/coffin/C1 = new(T1)
			if(prob(chance_of_corpse))
				var/type = pickweight(corpses)
				var/mob/M
				if(istext(type))
					M = new /mob/living/carbon/human()
					var/mob/living/carbon/human/H = M
					H.set_species(type)
					H.ChangeToHusk()
				else
					M = new type()
				M.death(0)
				M.forceMove(C1)
				item_spawns += M
		check = locate(truex + (direction ? width - 2 : 0), truey + (direction ? 0 : height - 2), zorigin)
		if(check.density && !T2.density && !T2.contents.len)
			var/obj/structure/closet/coffin/C2 = new(T2)
			if(prob(chance_of_corpse))
				var/type = pickweight(corpses)
				var/mob/M
				if(istext(type))
					M = new /mob/living/carbon/human()
					var/mob/living/carbon/human/H = M
					H.set_species(type)
					H.ChangeToHusk()
				else
					M = new type()
				M.death(0)
				M.forceMove(C2)
				item_spawns += M