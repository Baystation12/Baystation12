/obj/machinery/uniform_vendor
	name = "uniform vendor"
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
	var/global/list/issued_items = list()

/obj/machinery/uniform_vendor/attack_hand(mob/user)
	if(..())
		return

	var/dat = list()
	dat += "User ID: <a href='byond://?src=\ref[src];ID=1'>[ID ? "[ID.registered_name], [ID.military_rank], [ID.military_branch]" : "--------"]</a>"
	dat += "<hr>"
	if(!ID)
		dat += "Insert your ID card to proceed."
	else
		var/datum/job/job = job_master.GetJobByType(ID.job_access_type)
		if(job)
			var/decl/hierarchy/mil_uniform/user_outfit = find_uniforms(ID.military_rank, ID.military_branch, job.department_flag)
			uniforms = populate_uniforms(user_outfit)
		for(var/T in uniforms)
			dat += "<b>[T]</b> <a href='byond://?src=\ref[src];get_all=[T]'>Select All</a>"
			var/list/uniform = uniforms[T]
			for(var/piece in uniform)
				if(piece)
					var/obj/item/clothing/C = piece
					if(piece in selected_outfit)
						dat += "<span class='linkOn'>[sanitize(initial(C.name))]</span><a href='byond://?src=\ref[src];rem=\ref[piece]'>X</a>"
					else if (can_issue(C))
						dat += "<a href='byond://?src=\ref[src];add=\ref[piece]'>[sanitize(initial(C.name))]</a>"
					else
						dat += "[sanitize(initial(C.name))] (ISSUED)"
			dat += "<hr>"
		dat += "<a href='byond://?src=\ref[src];vend=[1]'>Dispense</a>"
	dat = jointext(dat,"<br>")
	var/datum/browser/popup = new(user, "Uniform Dispenser","Uniform Dispenser", 300, 700, src)
	popup.set_content(dat)
	popup.open()

/obj/machinery/uniform_vendor/OnTopic(var/mob/user, href_list)
	if(href_list["ID"])
		if(ID)
			if(!issilicon(user))
				user.put_in_hands(ID)
			else
				ID.dropInto(loc)
			ID = null
			selected_outfit.Cut()
		else
			var/obj/item/weapon/card/id/I = user.get_active_hand()
			if(istype(I) && user.unEquip(I, src))
				ID = I
		. = TOPIC_REFRESH
	if(href_list["get_all"])
		if(!(href_list["get_all"] in uniforms))
			return TOPIC_NOACTION
		var/list/addition = uniforms[href_list["get_all"]]
		for(var/G in addition)
			if(can_issue(G))
				selected_outfit |= addition
		. = TOPIC_REFRESH
	if(href_list["add"])
		var/uniform_path = locate(href_list["add"])
		if(ispath(uniform_path))
			selected_outfit |= uniform_path
			. = TOPIC_REFRESH
		else
			. = TOPIC_NOACTION
	if(href_list["rem"])
		selected_outfit -= locate(href_list["rem"])
		. = TOPIC_REFRESH
	if(href_list["vend"])
		spawn_uniform(selected_outfit)
		selected_outfit.Cut()
		. = TOPIC_REFRESH
	if(.)
		attack_hand(user)

/obj/machinery/uniform_vendor/attackby(var/obj/item/weapon/W, var/mob/user)
	if(istype(W, /obj/item/weapon/clothingbag))
		if(W.contents.len)
			to_chat(user, "<span class='notice'>You must empty \the [W] before you can put it in \the [src].</span>")
			return
		to_chat(user, "<span class='notice'>You put \the [W] into \the [src]'s recycling slot.</span>")
		qdel(W)
	else if(istype(W, /obj/item/weapon/card/id) && !ID && user.unEquip(W, src))
		to_chat(user, "<span class='notice'>You slide \the [W] into \the [src]!</span>")
		ID = W
		attack_hand(user)
	else
		..()

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
		user_outfit.service_skirt,
		user_outfit.service_over,
		user_outfit.service_shoes,
		user_outfit.service_hat,
		user_outfit.service_gloves
		)
	if(user_outfit.service_extra)
		res["Service Extras"] = user_outfit.service_extra

	res["Dress"] = list(
		user_outfit.dress_under,
		user_outfit.dress_skirt,
		user_outfit.dress_over,
		user_outfit.dress_shoes,
		user_outfit.dress_hat,
		user_outfit.dress_gloves
		)
	if(user_outfit.dress_extra)
		res["Dress Extras"] = user_outfit.dress_extra

	return res

/obj/machinery/uniform_vendor/proc/spawn_uniform(var/list/selected_outfit)
	listclearnulls(selected_outfit)
	if(!issued_items[user_id()])
		issued_items[user_id()] = list()
	var/list/checkedout = issued_items[user_id()]
	if(selected_outfit.len > 1)
		var/obj/item/weapon/clothingbag/bag = new /obj/item/weapon/clothingbag
		for(var/item in selected_outfit)
			new item(bag)
			checkedout += item
		bag.forceMove(get_turf(src))
	else if (selected_outfit.len)
		var/obj/item/clothing/C = selected_outfit[1]
		new C(get_turf(src))
		checkedout += C

/obj/machinery/uniform_vendor/proc/user_id()
	if(!ID)
		return "UNKNOWN"
	else
		return "[ID.registered_name], [ID.military_rank], [ID.military_branch]"

/obj/machinery/uniform_vendor/proc/can_issue(var/gear)
	var/list/issued = issued_items[user_id()]
	if(!issued || !issued.len)
		return TRUE
	return !(gear in issued)