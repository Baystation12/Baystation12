
/* SmartFridge.  Much todo
*/
/obj/machinery/smartfridge
	name = "\improper SmartFridge"
	icon = 'icons/obj/vending.dmi'
	icon_state = "fridge_sci"
	layer = BELOW_OBJ_LAYER
	density = 1
	anchored = 1
	idle_power_usage = 5
	active_power_usage = 100
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT
	var/global/max_n_of_items = 999 // Sorry but the BYOND infinite loop detector doesn't look things over 1000.
	var/icon_base = "fridge_sci"
	var/icon_contents = "chem"
	var/list/item_records = list()
	var/datum/stored_items/currently_vending = null	//What we're putting out of the machine.
	var/seconds_electrified = 0;
	var/shoot_inventory = 0
	var/locked = 0
	var/scan_id = 1
	var/is_secure = 0

/obj/machinery/smartfridge/secure
	is_secure = 1

/obj/machinery/smartfridge/New()
	..()
	if(is_secure)
		wires = new/datum/wires/smartfridge/secure(src)
	else
		wires = new/datum/wires/smartfridge(src)
	update_icon()

/obj/machinery/smartfridge/Destroy()
	for(var/datum/stored_items/S in item_records)
		qdel(S)
	item_records = null
	return ..()

/obj/machinery/smartfridge/get_req_access()
	if(!scan_id)
		return list()
	return ..()

/obj/machinery/smartfridge/proc/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/grown/) || istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/machinery/smartfridge/seeds
	name = "\improper MegaSeed Servitor"
	desc = "When you need seeds fast!"

/obj/machinery/smartfridge/seeds/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/machinery/smartfridge/secure/extract
	name = "\improper Slime Extract Storage"
	desc = "A refrigerated storage unit for slime extracts."
	icon_contents = "slime"
	req_access = list(access_research)

/obj/machinery/smartfridge/secure/extract/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/slime_extract))
		return 1
	return 0

/obj/machinery/smartfridge/secure/medbay
	name = "\improper Refrigerated Medicine Storage"
	desc = "A refrigerated storage unit for storing medicine and chemicals."
	icon_contents = "chem"
	req_access = list(list(access_medical,access_chemistry))

/obj/machinery/smartfridge/secure/medbay/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass/))
		return 1
	if(istype(O,/obj/item/weapon/storage/pill_bottle/))
		return 1
	if(istype(O,/obj/item/weapon/reagent_containers/pill/))
		return 1
	return 0

/obj/machinery/smartfridge/secure/virology
	name = "\improper Refrigerated Virus Storage"
	desc = "A refrigerated storage unit for storing viral material."
	req_access = list(access_virology)
	icon_contents = "chem"

/obj/machinery/smartfridge/secure/virology/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass/beaker/vial/))
		return 1
	return 0

/obj/machinery/smartfridge/chemistry
	name = "\improper Smart Chemical Storage"
	desc = "A refrigerated storage unit for medicine and chemical storage."
	icon_contents = "chem"

/obj/machinery/smartfridge/chemistry/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/storage/pill_bottle) || istype(O,/obj/item/weapon/reagent_containers))
		return 1
	return 0

/obj/machinery/smartfridge/chemistry/virology
	name = "\improper Smart Virus Storage"
	desc = "A refrigerated storage unit for volatile sample storage."


/obj/machinery/smartfridge/drinks
	name = "\improper Drink Showcase"
	desc = "A refrigerated storage unit for tasty tasty alcohol."
	icon_state = "fridge_dark"
	icon_base = "fridge_dark"
	icon_contents = "drink"

/obj/machinery/smartfridge/drinks/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass) || istype(O,/obj/item/weapon/reagent_containers/food/drinks) || istype(O,/obj/item/weapon/reagent_containers/food/condiment))
		return 1

/obj/machinery/smartfridge/foods
	name = "\improper Hot Foods Display"
	desc = "A heated storage unit for piping hot meals."
	icon_state = "fridge_food"
	icon_state = "fridge_food"
	icon_contents = "food"

/obj/machinery/smartfridge/foods/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/food/snacks) || istype(O,/obj/item/weapon/material/kitchen/utensil))
		return 1

/obj/machinery/smartfridge/drying_rack
	name = "drying rack"
	desc = "A machine for drying plants."
	icon_state = "drying_rack"

/obj/machinery/smartfridge/drying_rack/accept_check(var/obj/item/O as obj)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/))
		var/obj/item/weapon/reagent_containers/food/snacks/S = O
		return S.dried_type
	else if(istype(O, /obj/item/stack/material))
		var/obj/item/stack/material/mat = O
		var/material/skin/skin_mat = mat.material
		return istype(skin_mat)
	return 0

/obj/machinery/smartfridge/drying_rack/Process()
	..()
	if(inoperable())
		return
	if(contents.len)
		dry()
		update_icon()

/obj/machinery/smartfridge/drying_rack/on_update_icon()
	overlays.Cut()
	if(inoperable())
		if(contents.len)
			icon_state = "drying_rack-plant-off"
		else
			icon_state = "drying_rack-off"
	else
		icon_state = "drying_rack"
	if(contents.len)
		icon_state = "drying_rack-plant"
		if(!inoperable())
			icon_state = "drying_rack-close"

/obj/machinery/smartfridge/drying_rack/proc/dry()
	for(var/datum/stored_items/I in item_records)
		for(var/thing in I.instances)
			var/remove_thing = FALSE
			if(istype(thing, /obj/item/weapon/reagent_containers/food/snacks))
				var/obj/item/weapon/reagent_containers/food/snacks/S = thing
				if(S.dry || !I.get_specific_product(get_turf(src), S))
					continue
				if(S.dried_type == S.type)
					S.dry = 1
					S.SetName("dried [S.name]")
					S.color = "#a38463"
					stock_item(S)
					I.instances -= thing
					I.amount--
				else
					var/D = S.dried_type
					new D(get_turf(src))
					remove_thing = TRUE

			else if(istype(thing, /obj/item/stack/material))
				var/obj/item/stack/material/skin = thing
				if(!istype(skin.material, /material/skin))
					continue
				var/material/skin/skin_mat = skin.material
				if(!skin_mat.tans_to)
					continue
				var/material/leather_mat = SSmaterials.get_material_by_name(skin_mat.tans_to)
				stock_item(new leather_mat.stack_type(get_turf(src), skin.amount, skin_mat.tans_to))
				remove_thing = TRUE

			if(remove_thing)
				I.instances -= thing
				I.amount--
				qdel(thing)
				return


/obj/machinery/smartfridge/Process()
	if(stat & (BROKEN|NOPOWER))
		return
	if(src.seconds_electrified > 0)
		src.seconds_electrified--
	if(src.shoot_inventory && prob(2))
		src.throw_item()

/obj/machinery/smartfridge/on_update_icon()
	overlays.Cut()
	if(stat & (BROKEN|NOPOWER))
		icon_state = "[icon_base]-off"
	else
		icon_state = icon_base

	if(is_secure)
		overlays += image(icon, "[icon_base]-sidepanel")

	if(panel_open)
		overlays += image(icon, "[icon_base]-panel")

	var/image/I
	var/is_off = ""
	if(inoperable())
		is_off = "-off"

	// Fridge contents
	switch(contents.len)
		if(0)
			I = image(icon, "empty[is_off]")
		if(1 to 2)
			I = image(icon, "[icon_contents]-1[is_off]")
		if(3 to 5)
			I = image(icon, "[icon_contents]-2[is_off]")
		if(6 to 8)
			I = image(icon, "[icon_contents]-3[is_off]")
		else
			I = image(icon, "[icon_contents]-4[is_off]")
	overlays += I

	// Fridge top
	I = image(icon, "[icon_base]-top")
	I.pixel_z = 32
	I.layer = ABOVE_WINDOW_LAYER
	overlays += I

/*******************
*   Item Adding
********************/

/obj/machinery/smartfridge/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(isScrewdriver(O))
		panel_open = !panel_open
		user.visible_message("[user] [panel_open ? "opens" : "closes"] the maintenance panel of \the [src].", "You [panel_open ? "open" : "close"] the maintenance panel of \the [src].")
		update_icon()
		SSnano.update_uis(src)
		return

	if(isMultitool(O) || isWirecutter(O))
		if(panel_open)
			attack_hand(user)
		return

	if(stat & NOPOWER)
		to_chat(user, "<span class='notice'>\The [src] is unpowered and useless.</span>")
		return

	if(accept_check(O))
		if(!user.unEquip(O))
			return
		stock_item(O)
		user.visible_message("<span class='notice'>\The [user] has added \the [O] to \the [src].</span>", "<span class='notice'>You add \the [O] to \the [src].</span>")
		update_icon()

	else if(istype(O, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/bag/P = O
		var/plants_loaded = 0
		for(var/obj/G in P.contents)
			if(accept_check(G) && P.remove_from_storage(G, src, 1))
				plants_loaded++
				stock_item(G)
		P.finish_bulk_removal()

		if(plants_loaded)
			user.visible_message("<span class='notice'>\The [user] loads \the [src] with the contents of \the [P].</span>", "<span class='notice'>You load \the [src] with the contents of \the [P].</span>")
			if(P.contents.len > 0)
				to_chat(user, "<span class='notice'>Some items were refused.</span>")

	else
		to_chat(user, "<span class='notice'>\The [src] smartly refuses [O].</span>")
	return 1

/obj/machinery/smartfridge/secure/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		locked = -1
		req_access.Cut()
		to_chat(user, "You short out the product lock on [src].")
		return 1

/obj/machinery/smartfridge/proc/stock_item(var/obj/item/O)
	for(var/datum/stored_items/I in item_records)
		if(istype(O, I.item_path) && O.name == I.item_name)
			stock(I, O)
			return

	var/datum/stored_items/I = new/datum/stored_items(src, O.type, O.name)
	dd_insertObjectList(item_records, I)
	stock(I, O)

/obj/machinery/smartfridge/proc/stock(var/datum/stored_items/I, var/obj/item/O)
	I.add_product(O)
	SSnano.update_uis(src)

/obj/machinery/smartfridge/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/*******************
*   SmartFridge Menu
********************/

/obj/machinery/smartfridge/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/data[0]
	data["contents"] = null
	data["electrified"] = seconds_electrified > 0
	data["shoot_inventory"] = shoot_inventory
	data["locked"] = locked
	data["secure"] = is_secure

	var/list/items[0]
	for (var/i=1 to length(item_records))
		var/datum/stored_items/I = item_records[i]
		var/count = I.get_amount()
		if(count > 0)
			items.Add(list(list("display_name" = html_encode(capitalize(I.item_name)), "vend" = i, "quantity" = count)))

	if(items.len > 0)
		data["contents"] = items

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "smartfridge.tmpl", src.name, 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/smartfridge/Topic(href, href_list)
	if(..()) return 0

	var/mob/user = usr
	var/datum/nanoui/ui = SSnano.get_open_ui(user, src, "main")

	if(href_list["close"])
		user.unset_machine()
		ui.close()
		return 0

	if(href_list["vend"])
		var/index = text2num(href_list["vend"])
		var/amount = text2num(href_list["amount"])
		var/datum/stored_items/I = item_records[index]
		var/count = I.get_amount()

		// Sanity check, there are probably ways to press the button when it shouldn't be possible.
		if(count > 0)
			if((count - amount) < 0)
				amount = count
			for(var/i = 1 to amount)
				I.get_product(get_turf(src))
				update_icon()

		return 1
	return 0

/obj/machinery/smartfridge/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/stored_items/I in src.item_records)
		throw_item = I.get_product(loc)
		if (!throw_item)
			continue
		break

	if(!throw_item)
		return 0
	spawn(0)
		throw_item.throw_at(target,16,3)
	src.visible_message("<span class='warning'>[src] launches [throw_item.name] at [target.name]!</span>")
	update_icon()
	return 1

/************************
*   Secure SmartFridges
*************************/

/obj/machinery/smartfridge/secure/CanUseTopic(mob/user, datum/topic_state/state, href_list)
	if(!allowed(user) && !emagged && locked != -1 && href_list && href_list["vend"] && scan_id)
		to_chat(user, "<span class='warning'>Access denied.</span>")
		return STATUS_CLOSE
	return ..()