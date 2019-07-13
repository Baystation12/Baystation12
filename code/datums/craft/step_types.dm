//A single object which is moved inside the craft item, and will be deleted when its complete
//Arguments:
//Types (list),
	//A list of valid typepaths. All subpaths will be included. For ease of use, this can also just be a lone typepath
//Worktime:
	//Time in deciseconds required to complete the operation. A value of -1, or not specifying anything, will use the recipe's general worktime
//noconsume
	//If noconsume is set true, the object will not be moved in or deleted
/datum/craft_step/object
	var/list/valid_types = list()
	var/noconsume = FALSE


/datum/craft_step/object/load_params(var/list/params)
	//The second var either contains a list of types or a single type
	if (istype(params[2], /list))
		valid_types = params[2] //If its a list, replace our list with it
	else if (ispath(params[2]))
		valid_types = list(params[2]) //If its a type, add it to our list

	//Todo: Show icons for everything in valid types list, rather than just the first
	icon_type = valid_types[1]

	//Third var is the worktime, we feed that through the load_time function
	if (params.len >= 3)
		load_time(params[3], params)

		//Lastly, the noconsume flag
		if (params.len >= 4 && params[4])
			noconsume = params[4]

	//Now setting the name and desc
	desc = "Apply "
	for (var/i = 1; i <= valid_types.len;i++)
		var/var/obj/I = valid_types[i]
		var/name = initial(I.name)
		if (i == 1)
			desc += name
		else
			desc += " or [name]"

	start_msg = "%USER% starts applying %ITEM% to %TARGET%"
	end_msg = "%USER% applied %ITEM% to %TARGET%"



//Object must check if the item is a valid type
/datum/craft_step/object/can_apply(var/obj/I, mob/living/user, atom/target = null)
	.=..()
	if (.)
		if (!noconsume && !is_valid_to_consume(I, user))
			user << "That item can't be used for crafting!"
			return FALSE

		for (var/path in valid_types)
			if (istype(I, path))
				return TRUE
		user << "Wrong item!"
		return FALSE


//Unless noconsume is set, this step moves the ingredient inside the crafting atom
/datum/craft_step/object/post_apply(var/obj/I, mob/living/user, atom/target = null)
	if (noconsume)
		.=..()
	else if (I && target)
		if (user)
			user.unEquip(I, target)
		if (I.loc != target)
			user.unEquip(I, target)
			I.forceMove(target) //The item will be deleted along with the craft object later, when all steps are complete
			//In the meantime, it can be recovered if crafting is cancelled

	//We don't call parent and thus don't consume resources



/datum/craft_step/object/find_item(mob/living/user, var/atom/craft = null)
	var/list/items = get_search_list(user, craft)
	for (var/a in items)
		for (var/b in valid_types)
			if (istype(a, b))
				return a

	return null




//A quantity of sheets of materials which are used to craft something.
//Arguments:
//Material name:
	//Should be one of the MATERIAL_XXXX defines, from __defines/materials.dm
//Quantity
	//How many sheets of material to use. This will be subtracted from the material stack which is applied]
//Worktime:
	//Time in deciseconds required to complete the operation. A value of -1, or not specifying anything, will use the recipe's general worktime
/datum/craft_step/material
	var/required_material
	var/required_quantity = 1

/datum/craft_step/material/load_params(var/list/params)
	//The second var contains the name of a material
	required_material = params[2] //If its a type, add it to our list

	//Third var contains quantity. 1 is a fallback value if none specified
	if (params.len >= 3)
		required_quantity = params[3]

		//Fourth var is the worktime, we feed that through the load_time function
		if (params.len >= 4)
			load_time(params[4], params)


	//Now setting the name and desc

	var/material/M = get_material_by_name("[required_material]")
	icon_type = M.stack_type
	if (required_quantity <= 1)
		desc = "Apply [M.display_name]"
	else
		desc = "Apply [required_quantity] units of [M.display_name]"

	start_msg = "%USER% starts applying %ITEM% to %TARGET%"
	end_msg = "%USER% applied %ITEM% to %TARGET%"



//Check that this is the correct material and there's enough of it
/datum/craft_step/material/can_apply(var/obj/I, mob/living/user, atom/target = null)
	.=..()
	if (.)
		if (istype(I, /obj/item/stack/material))
			var/obj/item/stack/material/MA = I
			if (MA.material && (MA.material.name == required_material))
				if (MA.can_use(required_quantity))
					return TRUE
				else
					user << SPAN_DANGER("Insufficient quantity, this crafting operation requires! [required_quantity] units of [required_material]")
			else
				user << "Wrong material, this crafting operation requires! [required_quantity] units of [required_material]"
		else
			user << "Wrong item!"
	return FALSE



//Consume things from the stack
/datum/craft_step/material/post_apply(var/obj/I, mob/living/user, atom/target = null)
	var/obj/item/stack/material/MA = I
	MA.use(required_quantity)



/datum/craft_step/material/find_item(mob/living/user, var/atom/craft = null)
	var/list/items = get_search_list(user, craft)
	var/foundmat = FALSE
	for (var/a in items)
		if (istype(a, /obj/item/stack/material))
			var/obj/item/stack/material/MA = a
			if (MA.material && (MA.material.name == required_material))
				foundmat = TRUE
				if (MA.can_use(required_quantity))
					return MA

	if (foundmat)
		user << SPAN_DANGER("Insufficient quantity, this crafting operation requires! [required_quantity] units of [required_material]")
	return null


//A quantity of some non-material stack object
//Arguments:
//Type
	//A typepath of which stack to use, subtypes are counted too
//Quantity
	//How many units of the stack to use, this is subtracted from the quantity
//Worktime:
	//Time in deciseconds required to complete the operation. A value of -1, or not specifying anything, will use the recipe's general worktime
/datum/craft_step/stack
	var/required_type = /obj/item/stack
	var/required_quantity = 1

/datum/craft_step/stack/load_params(var/list/params)
	//The second var contains the typepath
	required_type = params[2]
	icon_type = required_type
	//Third var contains quantity. 1 is a fallback value if none specified
	if (params.len >= 3)
		required_quantity = params[3]

		//Fourth var is the worktime, we feed that through the load_time function
		if (params.len >= 4)
			load_time(params[4], params)


	//Now setting the name and desc
	var/var/obj/item/stack/I = required_type
	var/name = (required_quantity > 1?initial(I.name):initial(I.singular_name))

	if (required_quantity > 1)
		desc = "Apply [name]"
	else
		desc = "Apply [required_quantity] [name]\s"

	start_msg = "%USER% starts applying %ITEM% to %TARGET%"
	end_msg = "%USER% applied %ITEM% to %TARGET%"



//Check that this is the correct stack and there's enough of it
/datum/craft_step/stack/can_apply(var/obj/I, mob/living/user, atom/target = null)
	.=..()
	if (.)
		if (istype(I, required_type))
			var/obj/item/stack/MA = I
			if (MA.can_use(required_quantity))
				return TRUE
			else
				user << SPAN_DANGER("Insufficient quantity, this crafting operation requires! [required_quantity] units of [I.name]")
		else
			user << "Wrong item!"
	return FALSE


//Consume things from the stack
/datum/craft_step/stack/post_apply(var/obj/I, mob/living/user, atom/target = null)
	var/obj/item/stack/MA = I
	MA.use(required_quantity)


/datum/craft_step/stack/find_item(mob/living/user, var/atom/craft = null)
	var/list/items = get_search_list(user, craft)
	var/foundstack = FALSE
	for (var/a in items)
		if (istype(a, required_type))
			var/obj/item/stack/MA = a
			foundstack = TRUE
			if (MA.can_use(required_quantity))
				return MA

	if (foundstack)
		user << SPAN_DANGER("Insufficient quantity, this crafting operation requires! [required_quantity] units")
	return null


//A tool with specified qualities which must be used on the craft.
//The tool is not used up by this operation, but it will consume its own resources as normal (fuel, power, quantity, etc)
//Arguments:
	//Required quality, must be one of the QUALITY_XXXX defines in tools_and_qualities.dm
	//Required level, must be a number generally in the range 0-50
	//Worktime:Time in deciseconds required to complete the operation. A value of -1, or not specifying anything, will use the recipe's general worktime
	//Failchance: The difficulty of the tool operation
	//Required skill: UNIMPLEMENTED: This is subtracted from the required level, and also set as the failchance on
/datum/craft_step/tool
	var/required_quality
	var/required_level = 1
	var/difficulty = 0

/datum/craft_step/tool/load_params(var/list/params)
	//The second var contains the typepath
	required_quality = params[2]
	icon_type = GLOB.iconic_tools[required_quality]

	//Third var contains quantity. 1 is a fallback value if none specified
	if (params.len >= 3)
		required_level = params[3]

		//Fourth var is the worktime, we feed that through the load_time function
		if (params.len >= 4)
			load_time(params[4], params)


			//Fifth var is the worktime, we feed that through the load_time function
			if (params.len >= 5)
				difficulty = params[5]



	desc = "Apply a tool with [required_level>1?"[required_level] ":""][required_quality] quality."

	start_msg = "%USER% starts applying %ITEM% to %TARGET%"
	end_msg = "%USER% applied %ITEM% to %TARGET%"



//Check that this tool has the correct qualities
/datum/craft_step/tool/can_apply(var/obj/I, mob/living/user, atom/target = null)
	.=..()
	if (.)
		if (I.get_tool_quality(required_quality) >= required_level)
			return TRUE
		else
			user << SPAN_WARNING("Wrong type of tool. You need a tool with [required_quality] quality")
	return FALSE


//Unlike most of the other step types, tools override do_apply
/datum/craft_step/tool/do_apply(var/obj/I, mob/living/user, atom/target = null)
	//If the craft is instant, then just return success now
	if (!user)
		return TRUE //Automated crafting by code

	//We do use_tool instead of doafter. This contains all the necessary stuff, including resource consumption
	if (I.use_tool(user, target, time, required_quality, difficulty))
		return TRUE

	return FALSE

//Consume things from the stack
/datum/craft_step/tool/post_apply(var/obj/I, mob/living/user, atom/target = null)
	return //Use tool already consumed resources so we short circuit this



/datum/craft_step/tool/find_item(mob/living/user, var/atom/craft = null)
	var/list/items = get_search_list(user, craft)
	for (var/obj/I in items)
		if (I.get_tool_quality(required_quality) >= required_level)
			return I

	return null


//This is put into the passive steps list, not the normal steps list
//Requires a tool to be near the crafting site. Within 1 tile generally
//The presence of this tool is checked for, and use_tool is called on it, at every crafting step.
//This is primarily intended for workbenches, and similar emplaced-object tools which cannot be picked up
//Arguments:
		//Required quality, must be one of the QUALITY_XXXX defines in tools_and_qualities.dm
		//Required level, must be a number generally in the range 0-50
		//Search range: How far around the search point we'll look for the item
/datum/craft_step/passive
	var/required_quality
	var/required_level = 1


/datum/craft_step/passive/load_params(var/list/params)
	//The second var contains the typepath
	required_quality = params[2]
	icon_type = GLOB.iconic_tools[required_quality]
	//Third var contains quantity. 1 is a fallback value if none specified
	if (params.len >= 3)
		required_level = params[3]
		if (params.len >= 4 && isnum(params[4]))
			apply_range = params[4]

	desc = SPAN_NOTICE("Requires a [required_quality].")

	start_msg = "%USER% starts applying %ITEM% to %TARGET%"
	end_msg = "%USER% applied %ITEM% to %TARGET%"



//Look for the required thing in a radius around the construction
//Possible TODO: Find some way to cache the found object so we don't need to search for it
/datum/craft_step/passive/can_apply(var/obj/I, mob/living/user, atom/target = null)
	if (find_item(user, target))
		return TRUE
	user << SPAN_WARNING("You need have a [required_quality] [apply_range > 0?"within [apply_range] tiles":"in the same tile"] in order to continue crafting this!")
	return FALSE


//Passives are never directly applied, they have no do_apply
/datum/craft_step/passive/post_apply(var/obj/I, mob/living/user, atom/target = null)
	I = find_item(user, target)
	.=..(I, user, target)


/datum/craft_step/passive/find_item(mob/living/user, var/atom/craft = null)
	var/list/items = get_search_list(user, craft)
	for (var/obj/I in items)
		world << "[I] [I.type] Workbench:[I.get_tool_quality(required_quality)]/[required_level]"
		if (I.get_tool_quality(required_quality) >= required_level)
			return I

	return null
