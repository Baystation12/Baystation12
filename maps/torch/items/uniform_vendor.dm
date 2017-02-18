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

	var/obj/item/weapon/card/id/ID
	var/list/uniforms = list()
	var/list/selected_outfit = list()
	var/static/decl/hierarchy/mil_uniform/mil_uniforms

/obj/machinery/uniform_vendor/attack_hand(mob/user)
	if(..())
		return
	user.set_machine(src)
	var/dat = list()
	dat += "User ID: <a href='byond://?src=\ref[src];ID=1'>[ID ? "[ID.registered_name], [ID.military_rank], [ID.military_branch]" : "--------"]</a>"
	dat += "<hr>"
	if(!ID)
		dat += "Insert your ID card to proceed."
	else
		var/datum/job/job = job_master.GetJobByType(ID.job_access_type)
		if(job)
			uniforms = find_uniforms(ID.military_rank, ID.military_branch, job.department_flag)
		for(var/T in uniforms)
			dat += "<b>[T]</b> <a href='byond://?src=\ref[src];get_all=[T]'>Select All</a>"
			var/list/uniform = uniforms[T]
			for(var/piece in uniform)
				if(piece)
					var/obj/item/clothing/C = piece
					if(piece in selected_outfit)
						dat += "<span class='linkOn'>[sanitize(initial(C.name))]</span><a href='byond://?src=\ref[src];rem=[piece]'>X</a>"
					else
						dat += "<a href='byond://?src=\ref[src];add=[piece]'>[sanitize(initial(C.name))]</a>"
			dat += "<hr>"
		dat += "<a href='byond://?src=\ref[src];vend=[1]'>Dispense</a>"
	dat = jointext(dat,"<br>")
	var/datum/browser/popup = new(user, "Uniform Dispenser","Uniform Dispenser", 300, 700, src)
	popup.set_content(dat)
	popup.open()

/obj/machinery/uniform_vendor/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["ID"])
		var/mob/M = usr
		if(ID)
			M.put_in_hands(ID)
			ID = null
			selected_outfit.Cut()
		else
			var/obj/item/weapon/card/id/I = M.get_active_hand()
			if(I)
				ID = I
				M.drop_from_inventory(I,src)
		. = 1
	if(href_list["get_all"])
		selected_outfit |= uniforms[href_list["get_all"]]
		. = 1
	if(href_list["add"])
		selected_outfit |= text2path(href_list["add"])
		. = 1
	if(href_list["rem"])
		selected_outfit -= text2path(href_list["rem"])
		. = 1
	if(href_list["vend"])
		spawn_uniform(selected_outfit)
		selected_outfit.Cut()
		. = 1
	if(.)
		attack_hand(usr)

/obj/machinery/uniform_vendor/attackby(obj/item/weapon/W as obj, mob/user as mob)

	var/obj/item/weapon/card/id/I = W.GetIdCard()
	if(I && !ID)
		to_chat(user, "<span class='notice'>You slide [I.registered_name]'s ID into \the [src]!</span>")
		ID = I
		user.drop_from_inventory(I,src)

/*	Outfit structures
	branch
	branch/department
	branch/department/officer
	branch/department/officer/command

	The one exception to the above is the command department, due to the fact that you have to be an officer to
	be in command, and there are no variants as a result. Also no special CO uniform :(
*/
/obj/machinery/uniform_vendor/proc/find_uniforms(var/datum/mil_rank/user_rank, var/datum/mil_branch/user_branch, var/department) //returns 1 if found branch and thus has a base uniform, 2, branch and department, 0 if failed.
	if(!mil_uniforms)
		mil_uniforms = new()

	var/decl/hierarchy/mil_uniform/user_outfit = mil_uniforms
	for(var/decl/hierarchy/mil_uniform/child in user_outfit.children)
		if(istype(user_branch,child.branch))
			user_outfit = child

	if(user_outfit == mil_uniforms) //We haven't found a branch
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

		if(user_rank.sort_order >= 11) //user is an officer
			if(user_outfit.children[1]) // officer outfit exists
				user_outfit = user_outfit.children[1]

				if(department & COM) //user is in command of their department
					if(user_outfit.children[1])// Command outfit exists
						user_outfit = user_outfit.children[1]

	return populate_uniforms(user_outfit) //Generate uniform lists.

/obj/machinery/uniform_vendor/proc/populate_uniforms(var/decl/hierarchy/mil_uniform/user_outfit)
	var/list/res = list()
	res["PT"] = list(
		user_outfit.pt_under,
		user_outfit.pt_shoes
		)

	res["Utility"] = list(
		user_outfit.utility_under,
		user_outfit.utility_shoes,
		user_outfit.utility_hat
		)
	if (user_outfit.utility_extra)
		res["Utility Extras"] = user_outfit.utility_extra

	res["Service"] = list(
		user_outfit.service_under,
		user_outfit.service_over,
		user_outfit.service_shoes,
		user_outfit.service_hat,
		user_outfit.service_gloves
		)
	if(user_outfit.service_extra)
		res["Service Extras"] = user_outfit.service_extra

	res["Dress"] = list(
		user_outfit.dress_under,
		user_outfit.dress_over,
		user_outfit.dress_shoes,
		user_outfit.dress_hat,
		user_outfit.dress_gloves
		)
	if(user_outfit.service_extra)
		res["Dress Extras"] = user_outfit.dress_extra

	return res

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

