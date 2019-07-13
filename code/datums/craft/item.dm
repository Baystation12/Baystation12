/obj/item/craft
	icon = 'icons/obj/crafts.dmi'
	icon_state = "device"
	var/datum/craft_recipe/recipe
	var/step = 1


/obj/item/craft/New(loc, new_recipe)
	..(loc)
	recipe = new_recipe
	src.name = "crafting [recipe.name]"
	src.icon_state = recipe.icon_state
	update()


/obj/item/craft/proc/update()
	desc = ""
	var/offset = step + recipe.passive_steps.len
	var/list/allsteps = recipe.passive_steps + recipe.steps
	for (var/datum/craft_step/CS in allsteps)
		if (offset > 0)
			offset--
			continue
		desc += "\n  \icon[CS.icon_type] [CS.desc]"
		//desc += "\n <img src= [a["icon"]] height=16 width=16>[a["desc"]]"


/obj/item/craft/proc/continue_crafting(obj/item/I, mob/living/user)
	if (user && istype(loc, /turf))
		user.face_atom(src) //Look at what you're doing please

	if(recipe.try_step(step+1, I, user, src)) //First step is
		++step
		if(recipe.is_complete(step+1))
			recipe.spawn_result(src, user)
		else
			update()
		return TRUE //Returning true here will prevent afterattack effects for ingredients and tools used on us

	return FALSE

/obj/item/craft/attackby(obj/item/I, mob/living/user)
	return continue_crafting(I, user)

/obj/item/craft/MouseDrop_T(atom/A, mob/user, src_location, over_location, src_control, over_control, params)
	return continue_crafting(A, user)