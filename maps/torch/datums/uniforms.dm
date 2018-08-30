GLOBAL_DATUM_INIT(mil_uniforms, /decl/hierarchy/mil_uniform, new)

/decl/hierarchy/mil_uniform
	name = "Master outfit hierarchy"
	hierarchy_type = /decl/hierarchy/mil_uniform
	var/branch = null
	var/departments = 0
	var/min_rank = 0

	var/pt_under = null
	var/pt_shoes = null

	var/utility_under = null
	var/utility_shoes = null
	var/utility_hat = null
	var/utility_extra = null

	var/service_under = null
	var/service_skirt = null
	var/service_over = null
	var/service_shoes = null
	var/service_hat = null
	var/service_gloves = null
	var/service_extra = null

	var/dress_under = null
	var/dress_skirt = null
	var/dress_over = null
	var/dress_shoes = null
	var/dress_hat = null
	var/dress_gloves = null
	var/dress_extra = null

/decl/hierarchy/mil_uniform/ec
	name = "Master EC outfit"
	hierarchy_type = /decl/hierarchy/mil_uniform/ec
	branch = /datum/mil_branch/expeditionary_corps

	pt_under = /obj/item/clothing/under/solgov/pt/expeditionary
	pt_shoes = /obj/item/clothing/shoes/black

	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary
	utility_shoes = /obj/item/clothing/shoes/dutyboots
	utility_hat = /obj/item/clothing/head/soft/solgov/expedition
	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition, /obj/item/clothing/head/ushanka/solgov, /obj/item/clothing/suit/storage/hooded/wintercoat/solgov, /obj/item/clothing/shoes/jackboots/unathi)

	service_under = /obj/item/clothing/under/solgov/service/expeditionary
	service_skirt = /obj/item/clothing/under/solgov/service/expeditionary/skirt
	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary
	service_shoes = /obj/item/clothing/shoes/dress
	service_hat = /obj/item/clothing/head/solgov/service/expedition

	dress_under = /obj/item/clothing/under/solgov/service/expeditionary
	dress_skirt = /obj/item/clothing/under/solgov/service/expeditionary/skirt
	dress_over = /obj/item/clothing/suit/dress/solgov/expedition
	dress_shoes = /obj/item/clothing/shoes/dress
	dress_hat = /obj/item/clothing/head/solgov/service/expedition
	dress_gloves = /obj/item/clothing/gloves/white

/decl/hierarchy/mil_uniform/fleet
	name = "Master fleet outfit"
	hierarchy_type = /decl/hierarchy/mil_uniform/fleet
	branch = /datum/mil_branch/fleet

	pt_under = /obj/item/clothing/under/solgov/pt/fleet
	pt_shoes = /obj/item/clothing/shoes/black

	utility_under = /obj/item/clothing/under/solgov/utility/fleet
	utility_shoes = /obj/item/clothing/shoes/dutyboots
	utility_hat = /obj/item/clothing/head/solgov/utility/fleet
	utility_extra = list(/obj/item/clothing/head/beret/solgov/fleet, /obj/item/clothing/head/ushanka/solgov/fleet, /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,/obj/item/clothing/head/soft/solgov/fleet)

	service_under = /obj/item/clothing/under/solgov/service/fleet
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt
	service_over = null
	service_shoes = /obj/item/clothing/shoes/dress
	service_hat = /obj/item/clothing/head/solgov/dress/fleet/garrison

	dress_under = /obj/item/clothing/under/solgov/service/fleet
	dress_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt
	dress_over = /obj/item/clothing/suit/dress/solgov/fleet/sailor
	dress_shoes = /obj/item/clothing/shoes/dress
	dress_hat = /obj/item/clothing/head/solgov/dress/fleet
	dress_gloves = /obj/item/clothing/gloves/white

	dress_extra = list(/obj/item/clothing/head/beret/solgov/fleet/dress)

decl/hierarchy/mil_uniform/civilian
	name = "Master civilian outfit"		//Basically just here for the rent-a-tux, ahem, I mean... dress uniform.
	hierarchy_type = /decl/hierarchy/mil_uniform/civilian
	branch = /datum/mil_branch/civilian

	dress_under = /obj/item/clothing/under/rank/internalaffairs/plain
	dress_over = /obj/item/clothing/suit/storage/toggle/suit/black
	dress_shoes = /obj/item/clothing/shoes/dress
	dress_extra = list(/obj/item/clothing/accessory/wcoat,\
	/obj/item/clothing/under/skirt_c/dress/black, /obj/item/clothing/under/skirt_c/dress/long/black,\
	/obj/item/clothing/under/skirt_c/dress/eggshell, /obj/item/clothing/under/skirt_c/dress/long/eggshell)

/*	Outfit structures
	branch
	branch/department
	branch/department/officer
	branch/department/officer/command

	The one exception to the above is the command department, due to the fact that you have to be an officer to
	be in command, and there are no variants as a result. Also no special CO uniform :(
*/
/proc/find_uniforms(var/datum/mil_rank/user_rank, var/datum/mil_branch/user_branch, var/department) //returns 1 if found branch and thus has a base uniform, 2, branch and department, 0 if failed.
	var/decl/hierarchy/mil_uniform/user_outfit = GLOB.mil_uniforms
	for(var/decl/hierarchy/mil_uniform/child in user_outfit.children)
		if(istype(user_branch,child.branch))
			user_outfit = child

	if(user_outfit == GLOB.mil_uniforms) //We haven't found a branch
		return null //Return no uniforms, which will cause the machine to spit out an error.

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

	return user_outfit //Generate uniform lists.