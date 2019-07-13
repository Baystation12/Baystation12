/datum/craft_step
	var/time = -1

	var/desc = ""
	var/start_msg = ""
	var/end_msg = ""
	var/datum/craft_recipe/parent
	var/icon_type //Typepath of an object we will use for visual icon of this craft step

	var/apply_range = 1
	//Maximum distance allowed between ingredient and craft operation when adding something. 1 requires adjacency
	//Some things, notably passives, may set it higher


/datum/craft_step/New(var/list/params, var/datum/craft_recipe/_parent)
	parent = _parent
	if (parent)
		time = parent.time
	load_params(params)

//Does nothing in base form, this should be overridden
/datum/craft_step/proc/load_params(var/list/params)
	return


/datum/craft_step/proc/load_time(var/input, var/params)
	if (isnum(input))
		time = input
	else if (input == "time")
		time = params["time"]


/datum/craft_step/proc/announce_action(var/msg, mob/living/user, obj/item/tool, atom/target)
	msg = replacetext(msg,"%USER%","[user]")
	msg = replacetext(msg,"%ITEM%","\improper [tool]")
	msg = replacetext(msg,"%TARGET%","\improper [target]")
	user.visible_message(
		msg
	)

/datum/craft_step/proc/apply(obj/item/I, mob/living/user, atom/target = null)
	if (can_apply(I, user, target))
		//Before doing the step, we check passive requirements
		for (var/datum/craft_step/CS in parent.passive_steps)
			if (!CS.can_apply(I, user, target))
				return FALSE

		//Now do the main step
		if (do_apply(I, user, target))
			//And if it succeeded, call post_apply
			post_apply(I, user, target)
			for (var/datum/craft_step/CS in parent.passive_steps)
				CS.post_apply(I, user, target)
			return TRUE

	return FALSE

//Checks whether this item can be applied to this recipe at this time
/datum/craft_step/proc/can_apply(obj/item/I, mob/living/user, atom/target = null)
	//User can't craft things if they're restrained
	//However, we ignore this check if there is no user. Crafting could be done automatically by a script
	if (user && user.incapacitated())
		return FALSE

	//The item needs to be close to the target object
	//A bunch of extra safety checks for target, it might be nonexistent or in nullspace
	if (target && isturf(target.loc) && (get_dist(I, target) > apply_range))
		return FALSE



	//The user has to be adjacent to at least one of the two things
	if (user && !user.Adjacent(I))
		//A bunch of extra safety checks for target, it might be nonexistent or in nullspace
		if (target && isturf(target.loc) && !user.Adjacent(target))
			return FALSE

	return TRUE


//Should be overridden, but is fallback behaviour for non tool things
/datum/craft_step/proc/do_apply(obj/item/I, mob/living/user, atom/target = null)
	//If the craft is instant, then just return success now
	if (!time || time <= 0)
		return TRUE

	if (!user)
		return TRUE //Automated crafting by code

	//A doafter for the work time
	if (do_after(user, time, ( (target && isturf(target.loc)) ? target : user) ) ) //We use the target as the target if it exists, and isn't in nullspace
		return TRUE

	return FALSE


//In post apply, we consume resources, delete ingredients, etc
/datum/craft_step/proc/post_apply(obj/item/I, mob/living/user, atom/target = null)
	if (I && !QDELETED(I))
		I.consume_resources(time)


/datum/craft_step/proc/is_valid_to_consume(var/obj/item/I, var/mob/living/user)
	var/holder = I.get_holding_mob()
	//Next we must check if we're actually allowed to submit it
	if (!holder)
		//If the item is lying on a turf, it's fine
		return I

	if (holder != user)
		//The item is held by someone else, can't use
		return FALSE

	//If we get here, the item is held by our user
	if (I.loc != user)
		//The item must be inside a container on their person, it's fine
		return I

	if (istype(I, /obj/item/stack))
		//Robots are allowed to use stacks, since those will only deplete the amount but not destroy the item
		return I

	//The item is on the user
	if (user.canUnEquip(I))
		//We test if they can remove it, this will return false for robot objects
		return I




	//If we get here, then we found the item but it wasn't valid to use, sorry!
	return FALSE



//Used when searching for components. Returns a list of stuff which can be searched through
/datum/craft_step/proc/get_search_list(var/mob/living/user, var/atom/craft)
	var/list/items = list()
	var/turf/centrepoint = null
	//If there is a user, we add everything that user is wearing and holding
	if (istype(user))
		items.Add(user.get_equipped_items(TRUE))
		centrepoint = get_step(user, user.dir)

	else if (craft)
		centrepoint = get_turf(craft)

	if (centrepoint)
		items.Add(range(centrepoint, apply_range))

	return items

//Override in child classes
//Find item is used in the following situations:
	//1. When starting a new craft, to locate the ingredient for the initial step
	//2. For passive craft steps, to find the thing they need nearby and ensure it's there
	//Possible future TODO: Automated crafting, searching for and applying suitable ingredients
/datum/craft_step/proc/find_item(user, craft)
	return null