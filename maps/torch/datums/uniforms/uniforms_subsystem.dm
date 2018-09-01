SUBSYSTEM_DEF(uniforms)
	name = "Uniforms"
	flags = SS_NO_FIRE

	var/decl/hierarchy/mil_uniform/mil_uniforms
	var/list/uniform_items_by_datum = list()

/datum/controller/subsystem/uniforms/Initialize()
	mil_uniforms = new()
	. = ..()

/datum/controller/subsystem/uniforms/proc/get_unform(var/datum/mil_rank/user_rank, var/datum/mil_branch/user_branch, var/department)
	var/decl/hierarchy/mil_uniform/user_outfit = mil_uniforms
	for(var/decl/hierarchy/mil_uniform/child in user_outfit.children)
		if(istype(user_branch,child.branch))
			user_outfit = child

	if(user_outfit == mil_uniforms) //We haven't found a branch
		return null

	// we have found a branch.
	if(department == COM) //Command only has one variant and they have to be an officer
		for(var/decl/hierarchy/mil_uniform/child in user_outfit.children)
			if(child.departments & COM)
				user_outfit = child
	else
		var/tmp_department = department
		tmp_department &= ~COM //Parse departments, with complete disconsideration to the command flag (so we don't flag 2 outfit trees)

		for(var/decl/hierarchy/mil_uniform/child in user_outfit.children)
			if(child.departments & tmp_department)
				user_outfit = child
				break
		for(var/decl/hierarchy/mil_uniform/child in user_outfit.children)
			if(user_rank.sort_order >= child.min_rank && user_outfit.min_rank < child.min_rank)
				user_outfit = child
		if(department & COM) //user is in command of their department
			if(user_outfit.children[1])// Command outfit exists
				user_outfit = user_outfit.children[1]

	if(!uniform_items_by_datum[user_outfit])
		populate_uniforms(user_outfit)
	return uniform_items_by_datum[user_outfit]

//Cretes a list of uniform items by category. Mandatory items also reference their slots so they can be checked
/datum/controller/subsystem/uniforms/proc/populate_uniforms(var/decl/hierarchy/mil_uniform/user_outfit)
	if(!istype(user_outfit))
		return

	var/list/res = list()
	res["PT"] = list(
		user_outfit.pt_under,
		user_outfit.pt_shoes
		)

	res["Utility"] = list(
		user_outfit.utility_under = slot_w_uniform,
		user_outfit.utility_shoes = slot_shoes,
		user_outfit.utility_hat
		)
	if (user_outfit.utility_extra)
		res["Utility Extras"] = user_outfit.utility_extra

	res["Service"] = list(
		user_outfit.service_under = slot_w_uniform,
		user_outfit.service_skirt = slot_w_uniform,
		user_outfit.service_over = slot_wear_suit,
		user_outfit.service_shoes = slot_shoes,
		user_outfit.service_hat,
		user_outfit.service_gloves = slot_gloves
		)
	if(user_outfit.service_extra)
		res["Service Extras"] = user_outfit.service_extra

	res["Dress"] = list(
		user_outfit.dress_under = slot_w_uniform,
		user_outfit.dress_skirt = slot_w_uniform,
		user_outfit.dress_over = slot_wear_suit,
		user_outfit.dress_shoes = slot_shoes,
		user_outfit.dress_hat,
		user_outfit.dress_gloves = slot_gloves
		)
	if(user_outfit.dress_extra)
		res["Dress Extras"] = user_outfit.dress_extra

	uniform_items_by_datum[user_outfit] = res
