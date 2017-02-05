/obj/machinery/uniform_vendor
	name = "uniform Vendor"
	desc= "A uniform vendor for utility, service, and dress uniforms."
	icon = 'icons/obj/vending.dmi'
	icon_state = "robotics"
	layer = BELOW_OBJ_LAYER
	anchored = 1
	density = 1

	var/icon_deny = "robotics-deny"
	var/icon_off = "robotics-off"

	// Power
	use_power = 1
	idle_power_usage = 10
	var/vend_power_usage = 150 //actuators and stuff

	var/state = 0
	//0 waiting for card
	//1 card accepted, waiting for uniform selection.



/*	Outfit structures
	branch
	branch/department
	branch/department/officer
	branch/department/officer/command

	The one exception to the above is the command department, due to the fact that you have to be an officer to
	be in command, and there are no variants as a result. Also no special CO uniform :(
*/
/obj/machinery/uniform_vendor/proc/find_uniforms(var/datum/mil_rank/user_rank, var/datum/mil_branch/user_branch, var/department) //returns 1 if found branch and thus has a base uniform, 2, branch and department, 0 if failed.
	var/decl/hierarchy/mil_uniform/user_outfit = mil_uniforms
	for(var/decl/hierarchy/mil_uniform/child in user_outfit.children)
		if(istype(user_branch,child.branch))
			user_outfit = child

	if(user_outfit == mil_uniforms) //We haven't found a branch
		return null //Return no uniforms, which will cause the machine to spit out an error.
	else // we have found a branch.
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

			if(user_rank.sort_order >= 11) //user is an officer
				if(user_outfit.children[1]) // officer outfit exists
					user_outfit = user_outfit.children[1]

					if(department & COM) //user is in command of their department
						if(user_outfit.children[1])// Command outfit exists
							user_outfit = user_outfit.children[1]
	return populate_uniforms(user_outfit) //Generate uniform lists.

/obj/machinery/uniform_vendor/proc/populate_uniforms(var/decl/hierarchy/mil_uniform/user_outfit)
	var/list/pt_uniform = list(
		user_outfit.pt_under,
		user_outfit.pt_shoes
		)

	var/list/utility_uniform = list(
		user_outfit.utility_under,
		user_outfit.utility_shoes,
		user_outfit.utility_hat
		)

	var/list/service_uniform = list(
		user_outfit.service_under,
		user_outfit.service_over,
		user_outfit.service_shoes,
		user_outfit.service_hat,
		user_outfit.service_gloves
		)

	var/list/dress_uniform = list(
		user_outfit.dress_under,
		user_outfit.dress_over,
		user_outfit.dress_shoes,
		user_outfit.dress_hat,
		user_outfit.dress_gloves
		)
	return list("PT" = pt_uniform, "Utility" = utility_uniform, "Service" = service_uniform, "Dress" = dress_uniform)

/obj/machinery/uniform_vendor/attackby(obj/item/weapon/W as obj, mob/user as mob)

	var/obj/item/weapon/card/id/I = W.GetIdCard()
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(I && state < 1)
		to_chat(user, "<span class='notice'>You swipe [I.registered_name]'\s ID through \the [src]!</span>")

		//The following is going to be incredibly gross, but we don't store instances of job datums in IDs.
		if(I.job_access_type)
			var/datum/job/temp = new I.job_access_type
			var/list/uniforms = find_uniforms(I.military_rank, I.military_branch, temp.department_flag)
			if(uniforms.len) // Any uniforms stored?
				state = 1
				var/choice = input(user,"Please select the uniform you wish to receive") as null|anything in uniforms
				if(choice)
					spawn_uniform(uniforms[choice])
				state = 0
			else
				to_chat(user, "<span class='warning>\the [src] cannot find any valid uniforms for [I.registered_name]'\s ID!</span>")
				playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 100, 1)
				flick(icon_deny, src)
		else
			to_chat(user, "<span class='warning'>\the [src] does not accept [I.registered_name]'\s ID!</span>")
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 100, 1)
			flick(icon_deny, src)


/obj/machinery/uniform_vendor/proc/spawn_uniform(var/list/selected_outfit)
	var/obj/item/weapon/clothingbag/bag = new /obj/item/weapon/clothingbag
	for(var/item in selected_outfit)
		if(item) //Can be null in some cases.
			new item(bag)
	bag.forceMove(get_turf(src))

/obj/item/weapon/clothingbag
	name = "clothing bag"
	desc = "A cheap plastic bag that contains a fresh set of clothes."
	icon = 'icons/obj/trash.dmi'
	icon_state = "trashbag3"

	var/icon_used = "trashbag0"
	var/opened = 0

/obj/item/weapon/clothingbag/attack_self(mob/user as mob)
	if(!opened)
		user.visible_message("<span class='notice'>\The [user] tears open \the [src.name]!</span>", "<span class='notice'>You tear open \the [src.name]!</span>")
		opened = 1
		icon_state = icon_used
		for(var/obj/item in contents)
			item.forceMove(get_turf(src))
	else
		to_chat(user, "<span class='warning'>\The [src.name] is already ripped open and is now completely useless!</span>")

