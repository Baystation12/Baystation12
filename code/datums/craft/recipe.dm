//Creates a crafting step of the appropriate subtype, depending on a flag
/datum/craft_recipe/proc/create_step_from_params(var/list/params)
	var/steptype = params[1]
	switch (steptype)
		if (CRAFT_OBJECT)
			return new /datum/craft_step/object(params, src)
		if (CRAFT_MATERIAL)
			return new /datum/craft_step/material(params, src)
		if (CRAFT_STACK)
			return new /datum/craft_step/stack(params, src)
		if (CRAFT_TOOL)
			return new /datum/craft_step/tool(params, src)
		if (CRAFT_PASSIVE)
			return new /datum/craft_step/passive(params, src)
		else
			return null

/datum/craft_recipe
	var/name
	var/category = "Misc"
	var/icon_state = "device"
	var/result

	var/list/steps
	var/list/passive_steps
	var/flags
	var/time = 30 //Used when no specific time is se
	var/difficulty = 0 //Difficulty of each step

/datum/craft_recipe/New()
	var/list/step_definitions = steps
	steps = new

	for(var/i in step_definitions)
		steps += create_step_from_params(i)

	var/list/passive_step_definitions = passive_steps
	passive_steps = new
	for (var/i in passive_step_definitions)
		passive_steps += create_step_from_params(i)


/datum/craft_recipe/proc/is_complete(step)
	return steps.len < step


/datum/craft_recipe/proc/spawn_result(obj/item/craft/C, mob/living/user)
	var/atom/movable/M = new result(get_turf(C))
	M.Created()
	M.dir = user.dir
	var/slot = user.get_inventory_slot(C)
	qdel(C)
	if(! (flags & CRAFT_ON_FLOOR) && (slot in list(slot_r_hand, slot_l_hand)))
		user.put_in_hands(M)


/datum/craft_recipe/proc/get_description()
	. = list()
	var/atom/A = result
	.+="[initial(A.desc)]<br>"
	for(var/item in steps)
		var/datum/craft_step/CS = item
		. += CS.desc
	return jointext(., "<br>")


/datum/craft_recipe/proc/can_build(mob/living/user, var/turf/T)
	if (!T)
		return FALSE

	if(flags & (CRAFT_ONE_PER_TURF|CRAFT_ON_FLOOR))
		if((locate(result) in T))
			user << SPAN_WARNING("You can't create more [name] here!")
			return FALSE
		else
			//Prevent building dense things in turfs that already contain dense objects
			var/atom/A = result
			if (initial(A.density))
				for (var/atom/movable/AM in T)
					if (AM != user && AM.density)
						user << SPAN_WARNING("You can't build here, it's blocked by [AM]!")
						return FALSE

	return TRUE


/datum/craft_recipe/proc/try_step(step, I, user, obj/item/craft/target)
	if(!can_build(user, get_turf(target)))
		return FALSE
	var/datum/craft_step/CS = steps[step]
	return CS.apply(I, user, target, src)


/datum/craft_recipe/proc/try_build(mob/living/user)
	if(!can_build(user, get_turf(user)))
		return

	var/datum/craft_step/CS = steps[1]
	var/obj/item/I = CS.find_item(user, null)

	if(!I)
		user << SPAN_WARNING("You can't find required item!")
		return

	//Robots can craft things on the floor
	if(ishuman(user) && !I.is_held())
		user << SPAN_WARNING("You should hold [I] in hands for doing that!")
		return

	if(!CS.apply(I, user, null, src))
		return

	var/obj/item/CR
	if(steps.len <= 1)
		CR = new result(null)
	else
		CR = new /obj/item/craft (null, src)
	if(flags & CRAFT_ON_FLOOR)
		CR.forceMove(get_turf(user))
	else
		user.put_in_hands(CR)
