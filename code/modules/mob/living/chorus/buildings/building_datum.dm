/datum/chorus_building
	var/desc = "Stuff"
	var/building_type_to_build
	var/build_level = 1 //What row to show them on
	var/unique = FALSE //Can only be built once?
	var/build_distance = 2 //Must be built within this amount of spaces to another. Set to 0 to be any distance
	var/build_time = 0
	var/list/resource_cost = list() //Name = cost
	var/list/building_requirements //type = num

/datum/chorus_building/proc/can_build(var/mob/living/chorus/c, var/atom/A, var/warnings = FALSE)
	A = get_turf(A)
	if(A.density)
		if(warnings)
			to_chat(c, "<span class='warning'>You cannot build on a wall</span>")
		return FALSE
	if(istype(A, /turf/space) || istype(A, /turf/simulated/open))
		if(warnings)
			to_chat(c, "<span class='warning'>You must build on solid ground</span>")
		return FALSE
	if(unique && c.get_building_type_amount(type) > 0)
		if(warnings)
			to_chat(c, "<span class='warning'>You can only have one of these at a time!</span>")
		return FALSE
	for(var/a in A)
		var/atom/atom = a
		if(atom.density || istype(atom, /obj/structure/chorus_blueprint) || istype(atom, /mob/living/chorus) || istype(atom, /obj/structure/chorus))
			if(warnings)
				to_chat(c, "<span class='warning'>You cannot build there!</span>")
			return FALSE

	for(var/type in resource_cost)
		if(!c.has_enough_resource(type, resource_cost[type]))
			if(warnings)
				var/datum/chorus_resource/cr = c.get_resource(type)
				to_chat(c, "<span class='warning'>You do not have enough [cr.name] to build that</span>")
			return FALSE
	if(building_requirements)
		for(var/type in building_requirements)
			if(c.get_building_type_amount(type) < building_requirements[type])
				if(warnings)
					var/obj/structure/O = type
					to_chat(c, "<span class='warning'>You need more [initial(O.name)] to build that</span>")
				return FALSE

	if(build_distance)
		var/r = c.get_dist_to_nearest_building(A) <= build_distance
		if(!r && warnings)
			to_chat(c, "<span class='warning'>You must build that closer to another chorus building</span>")
		return r
	return TRUE

/datum/chorus_building/proc/pay_costs(var/mob/living/chorus/c)
	for(var/name in resource_cost)
		if(!c.use_resource(name, resource_cost[name]))
			return FALSE
	return TRUE

/datum/chorus_building/proc/build(var/atom/target, var/mob/living/chorus/C, var/warnings = FALSE)
	if(can_build(C, target, warnings) && pay_costs(C))
		return new /obj/structure/chorus_blueprint(target, src, C)

/datum/chorus_building/proc/get_print_icon_state()
	return "<img src=\"[get_rsc_path()]\">"

/datum/chorus_building/proc/get_rsc_path()
	return "cult[get_icon_state()].png"

/datum/chorus_building/proc/get_rsc()
	return icon('icons/obj/cult.dmi', get_icon_state())

/datum/chorus_building/proc/get_icon_state()
	var/obj/structure/O = building_type_to_build
	return initial(O.icon_state)

/datum/chorus_building/proc/get_image()
	return image('icons/obj/cult.dmi', icon_state = get_icon_state())

/datum/chorus_building/proc/get_name()
	var/obj/structure/O = building_type_to_build
	return initial(O.name)

/datum/chorus_building/proc/get_nano_data(var/mob/living/chorus/C)
	. = list()
	var/obj/structure/chorus/O = building_type_to_build
	.["name"] = get_name()
	.["icon"] = get_print_icon_state()
	.["desc"] = desc
	.["cost"] = get_printed_cost(C)
	.["requirements"] = get_printed_requirements()
	var/datum/chorus_resource/cr = C.get_resource(initial(O.activation_cost_resource))
	if(cr)
		.["activation_res"] = cr.printed_cost()
		.["activation_amt"] = initial(O.activation_cost_amount)

/datum/chorus_building/proc/get_printed_cost(var/mob/living/chorus/C)
	. = list()
	for(var/res in resource_cost)
		var/datum/chorus_resource/cr = C.get_resource(res)
		if(cr)
			. += list(list("print" = cr.printed_cost(TRUE), "amount" = resource_cost[res]))

/datum/chorus_building/proc/get_printed_requirements()
	. = list()
	if(building_requirements)
		for(var/r in building_requirements)
			var/obj/structure/s = r
			. += list(list("name" = initial(s.name), "amount" = building_requirements[r]))

/datum/chorus_building/delete/get_icon_state()
	return "remove"

/datum/chorus_building/delete/can_build(var/mob/living/chorus/c, var/atom/A, var/warnings = FALSE)
	if(istype(A, /obj/structure/chorus))
		var/obj/structure/chorus/s = A
		return s.owner == c
	return FALSE

/datum/chorus_building/delete/build(var/atom/target, var/mob/living/chorus/C, var/warnings = FALSE)
	if(can_build(C, target, warnings))
		to_chat(C, "Removing [target]")
		qdel(target)

/datum/chorus_building/set_to_turf
	var/range = 0
	var/turf_to_change_to

/datum/chorus_building/set_to_turf/build(var/atom/target, var/mob/living/chorus/C, var/warnings = FALSE)
	. = ..()
	if(.)
		for(var/turf/T in range(range, target))
			if(T.density || istype(T, /turf/space))
				continue
			T.ChangeTurf(turf_to_change_to)
