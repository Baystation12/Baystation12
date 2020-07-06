/obj/structure/armalispod
	name = "large biopod"
	desc = "A bizarre tangle of meat, chitin and wiring."
	icon = 'icons/obj/vox.dmi'
	icon_state = "pod_open_big"
	anchored = 1
	density = 1
	var/mob/living/carbon/human/occupant = null
	var/used = 0

/obj/structure/armalispod/proc/go_out()
	if(!occupant)
		return
	if (occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(get_step(loc, SOUTH))
	occupant = null
	SetName(initial(name))
	return

/obj/structure/armalispod/proc/put_mob(mob/living/carbon/M as mob)
	if(!istype(M))
		to_chat(usr, "<span class='danger'>The biopod cannot process such a lifeform!")
		return
	if(occupant)
		to_chat(usr, "<span class='danger'>The biopod is already occupied!")
		return
	if(used == 1)
		to_chat(usr, "<span class='danger'>The biopod has already been used!")
		return
	if(M.species.get_bodytype(M) == SPECIES_VOX_ARMALIS)
		to_chat(usr, "<span class='danger'>The subject is already an Armalis!")
		return
	if(M.species.get_bodytype(M) != SPECIES_VOX && M.species.get_bodytype(M) != SPECIES_VOX_ARMALIS)
		to_chat(usr, "<span class='danger'>The biopod cannot process a non-Vox lifeform!")
		return
	if (M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.stop_pulling()
	M.forceMove(src)
	occupant = M
	icon_state = "pod_big"
	SetName("[name] ([occupant])")
	if(alert("You feel the pod closing around you, glistening tendrils reaching inwards. Are you sure you want to become a Vox Armalis?", "Armalis Transformation", "Yes", "No") == "No")
		to_chat(M, "The pod retracts its tendrils and slides open, ejecting you.")
		go_out()
		return
	to_chat(M, "The pod's tendrils reach into your skull, extracting your stack as your old body is recycled and the biomass used to create a new Armalis bioform. You can now only speak Vox-Pigdin due to the restructuring of your neural pathways.")
	occupant.set_species(SPECIES_VOX_ARMALIS)
	occupant.add_language(LANGUAGE_VOX)
	occupant.change_appearance (APPEARANCE_EYE_COLOR)
	go_out()
	used = 1
	return

/obj/structure/armalispod/MouseDrop_T(var/mob/target, var/mob/user)
	if(!CanMouseDrop(target, user))
		return
	if (!istype(target))
		return
	if (target.buckled)
		to_chat(user, "<span class='warning'>Unbuckle the subject before attempting to move them.</span>")
		return
	user.visible_message("<span class='notice'>\The [user] begins placing \the [target] into \the [src].</span>", "<span class='notice'>You start placing \the [target] into \the [src].</span>")
	if(!do_after(user, 30, src))
		return
	put_mob(target)


#define BG_READY 0
#define BG_PROCESSING 1
#define BG_NO_BEAKER 2
#define BG_COMPLETE 3
#define BG_EMPTY 4

/obj/machinery/voxfab
	name = "Vox biogenerator"
	desc = "A pulsating mass of flesh and steel"
	icon = 'icons/obj/vox.dmi'
	icon_state = "printer"
	density = 1
	anchored = 1
	idle_power_usage = 40
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	var/processing = 0
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/points = 0
	var/state = BG_READY
	var/denied = 0
	var/build_eff = 1
	var/eat_eff = 1
	var/ingredients = 0 //How many processable ingredients are stored inside.
	var/capacity = 10   //How many ingredients can we store?
	var/list/products = list(
		"Weapons and Armor" = list(
			/obj/item/weapon/gun/launcher/alien/slugsling = 150,
			/obj/item/weapon/gun/energy/sonic = 175,
			/obj/item/weapon/gun/launcher/alien/spikethrower = 200,
			/obj/item/weapon/gun/energy/darkmatter = 250),
		"Animals and Bodies" = list(
			/obj/item/weapon/slugegg = 50,
			/mob/living/carbon/human/vox/stackless/ = 500),
		/*"BioAugments" = list()
		TODO - actually add bioaugments so this section has a reason to exist*/)

/obj/machinery/voxfab/New()
	..()
	create_reagents(100)
	beaker = new /obj/item/weapon/reagent_containers/glass/bottle(src)

/obj/machinery/voxfab/on_reagent_change()			//When the reagents change, change the icon as well.
	update_icon()

/obj/machinery/voxfab/on_update_icon()
	if(state == BG_NO_BEAKER)
		icon_state = "printer-open"
	else if(state == BG_READY || state == BG_COMPLETE)
		icon_state = "printer"
	else
		icon_state = "printer-working"
	return

/obj/machinery/voxfab/components_are_accessible(path)
	return !processing && ..()

/obj/machinery/voxfab/cannot_transition_to(state_path)
	if(processing)
		return SPAN_NOTICE("You must turn \the [src] off first.")
	return ..()

/obj/machinery/voxfab/attackby(var/obj/item/O, var/mob/user)
	if((. = component_attackby(O, user)))
		return
	if(processing)
		to_chat(user, "<span class='notice'>\The [src] is currently processing.</span>")
	if(istype(O, /obj/item/weapon/reagent_containers/glass))
		if(beaker)
			to_chat(user, "<span class='notice'>]The [src] is already loaded.</span>")
			return TRUE
		else if(user.unEquip(O, src))
			beaker = O
			state = BG_READY
			updateUsrDialog()
			return TRUE

	if(ingredients >= capacity)
		to_chat(user, "<span class='notice'>\The [src] is already full! Activate it.</span>")
	else if(istype(O, /obj/item/weapon/storage/))
		var/obj/item/weapon/storage/P = O
		var/hadResin = 0
		for(var/obj/item/stack/material/wood/vox/G in P.contents)
			hadResin = 1
			P.remove_from_storage(G, src, 1) //No UI updates until we are all done.
			ingredients++
			if(ingredients >= capacity)
				to_chat(user, "<span class='notice'>You fill \the [src] to its capacity.</span>")
				break
		P.finish_bulk_removal() //Now do the UI stuff once.
		if(!hadResin)
			to_chat(user, "<span class='notice'>\The [P] has no resin inside.</span>")
		else if(ingredients < capacity)
			to_chat(user, "<span class='notice'>You empty \the [P] into \the [src].</span>")


	else if(!istype(O, /obj/item/stack/material/wood/vox))
		to_chat(user, "<span class='notice'>You cannot put this in \the [src].</span>")
	else if(user.unEquip(O, src))
		ingredients++
		to_chat(user, "<span class='notice'>You put \the [O] in \the [src]</span>")
	update_icon()

/**
 *  Display the NanoUI window for the vending machine.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/voxfab/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)
	var/list/data = list()
	data["state"] = state
	var/name
	var/cost
	var/type_name
	var/path
	if (state == BG_READY)
		data["points"] = points
		var/list/listed_types = list()
		for(var/c_type =1 to products.len)
			type_name = products[c_type]
			var/list/current_content = products[type_name]
			var/list/listed_products = list()
			for(var/c_product =1 to current_content.len)
				path = current_content[c_product]
				var/atom/A = path
				name = initial(A.name)
				cost = current_content[path]
				listed_products.Add(list(list(
					"product_index" = c_product,
					"name" = name,
					"cost" = cost)))
			listed_types.Add(list(list(
				"type_name" = type_name,
				"products" = listed_products)))
		data["types"] = listed_types
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "biogenerator.tmpl", "Biogenerator", 440, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/voxfab/OnTopic(user, href_list)
	switch (href_list["action"])
		if("activate")
			activate()
		if("detach")
			if(beaker)
				beaker.dropInto(src.loc)
				beaker = null
				state = BG_NO_BEAKER
				update_icon()
		if("create")
			if (state == BG_PROCESSING)
				return TOPIC_REFRESH
			var/type = href_list["type"]
			var/product_index = text2num(href_list["product_index"])
			if (isnull(products[type]))
				return TOPIC_REFRESH
			var/list/sub_products = products[type]
			if (product_index < 1 || product_index > sub_products.len)
				return TOPIC_REFRESH
			create_product(type, sub_products[product_index])
		if("return")
			state = BG_READY
	return TOPIC_REFRESH

/obj/machinery/voxfab/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/voxfab/proc/activate()
	if (usr.stat)
		return
	if (stat) //NOPOWER etc
		return

	var/S = 0
	var/amnt = SHEET_MATERIAL_AMOUNT * 0.05
	for(var/obj/item/stack/material/wood/vox/I in contents)
		var/num_of_sheets = I.amount
		S += 5
		ingredients--
		if (amnt < 0.1)
			points += 1
		else points += amnt * (num_of_sheets)
		qdel(I)
	if(S)
		state = BG_PROCESSING
		SSnano.update_uis(src)
		update_icon()
		playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
		use_power_oneoff(S * 30)
		sleep((S + 15))
		state = BG_READY
		update_icon()
	else
		state = BG_EMPTY
	return

/obj/machinery/voxfab/proc/create_product(var/type, var/path)
	state = BG_PROCESSING
	var/cost = products[type][path]
	cost = round(cost/build_eff)
	points -= cost
	SSnano.update_uis(src)
	update_icon()
	sleep(30)
	var/atom/movable/result = new path
	result.dropInto(loc)
	state = BG_COMPLETE
	update_icon()
	return 1
