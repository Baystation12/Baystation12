#define SUPPLY_LIST_ID_CART 1
#define SUPPLY_LIST_ID_REQUEST 2
#define SUPPLY_LIST_ID_DONE 3

/datum/computer_file/program/supply
	filename = "supply"
	filedesc = "Supply Management"
	nanomodule_path = /datum/nano_module/supply
	ui_header = null // Set when enabled by an admin user.
	program_icon_state = "supply"
	program_key_state = "rd_key"
	program_menu_icon = "cart"
	extended_desc = "A management tool that allows for ordering of various supplies through the facility's cargo system. Some features may require additional access."
	size = 21
	available_on_ntnet = 1
	requires_ntnet = 1
	category = PROG_SUPPLY

/datum/computer_file/program/supply/process_tick()
	..()
	var/datum/nano_module/supply/SNM = NM
	if(istype(SNM))
		SNM.emagged = computer.emagged()
		if(SNM.notifications_enabled)
			if(SSsupply.requestlist.len)
				ui_header = "supply_new_order.gif"
			else if(SSsupply.shoppinglist.len)
				ui_header = "supply_awaiting_delivery.gif"
			else
				ui_header = "supply_idle.gif"
		else if(ui_header)
			ui_header = null

/datum/nano_module/supply
	name = "Supply Management program"
	var/screen = 1		// 1: Ordering menu, 2: Statistics, 3: Shuttle control, 4: Orders menu
	var/selected_category
	var/list/category_names = list()
	var/list/category_contents = list()
	var/showing_contents_of_ref = null
	var/list/contents_of_order = list()
	var/emagged = FALSE	// TODO: Implement synchronization with modular computer framework.
	var/emagged_memory = FALSE // Keeps track if the program has to regenerate the catagories after an emag.
	var/current_security_level
	var/notifications_enabled = FALSE
	var/admin_access = list(access_cargo, access_mailsorting)

/datum/nano_module/supply/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/is_admin = check_access(user, admin_access)
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	if(!LAZYLEN(category_names) || !LAZYLEN(category_contents) || current_security_level != security_state.current_security_level || emagged_memory != emagged )
		generate_categories()
		current_security_level = security_state.current_security_level
		emagged_memory = emagged

	data["is_admin"] = is_admin
	if(is_admin)
		data["shopping_cart_length"] = SSsupply.shoppinglist.len
		data["request_length"] = SSsupply.requestlist.len
	data["screen"] = screen
	data["credits"] = "[SSsupply.points]"
	data["currency"] = GLOB.using_map.supply_currency_name
	data["currency_short"] = GLOB.using_map.supply_currency_name_short
	switch(screen)
		if(1)// Main ordering menu
			data["categories"] = category_names
			if(selected_category)
				data["category"] = selected_category
				data["possible_purchases"] = category_contents[selected_category]
				if(showing_contents_of_ref)
					data["showing_contents_of"] = showing_contents_of_ref
					data["contents_of_order"] = contents_of_order

		if(2)// Statistics screen with credit overview
			var/list/point_breakdown = list()
			for(var/tag in SSsupply.point_source_descriptions)
				var/entry = list()
				entry["desc"] = SSsupply.point_source_descriptions[tag]
				entry["points"] = SSsupply.point_sources[tag] || 0
				point_breakdown += list(entry) //Make a list of lists, don't flatten
			data["point_breakdown"] = point_breakdown
			data["can_print"] = can_print()

		if(3)// Shuttle monitoring and control
			var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
			data["shuttle_name"] = shuttle.name
			if(istype(shuttle))
				data["shuttle_location"] = shuttle.at_station() ? GLOB.using_map.name : "Remote location"
			else
				data["shuttle_location"] = "No Connection"
			data["shuttle_status"] = get_shuttle_status()
			data["shuttle_can_control"] = shuttle.can_launch()


		if(4)// Order processing
			if(is_admin) // No bother sending all of this if the user can't see it.
				var/list/cart[0]
				var/list/requests[0]
				var/list/done[0]
				for(var/datum/supply_order/SO in SSsupply.shoppinglist)
					cart.Add(order_to_nanoui(SO, SUPPLY_LIST_ID_CART))
				for(var/datum/supply_order/SO in SSsupply.requestlist)
					requests.Add(order_to_nanoui(SO, SUPPLY_LIST_ID_REQUEST))
				for(var/datum/supply_order/SO in SSsupply.donelist)
					done.Add(order_to_nanoui(SO, SUPPLY_LIST_ID_DONE))
				data["cart"] = cart
				data["requests"] = requests
				data["done"] = done
				data["can_print"] = can_print()
				data["is_NTOS"] = istype(nano_host(), /obj/item/modular_computer) // Can we even use notifications?
				data["notifications_enabled"] = notifications_enabled

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "supply.tmpl", name, 1050, 800, state = state)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

// Supply the order ID and where to look. This is just to reduce copypaste code.
/datum/nano_module/supply/proc/find_order_by_id(var/order_id, var/list/find_in)
	for(var/datum/supply_order/SO in find_in)
		if(SO.ordernum == order_id)
			return SO

/datum/nano_module/supply/Topic(href, href_list)
	var/mob/user = usr
	if(..())
		return 1

	if(href_list["select_category"])
		clear_order_contents()
		selected_category = href_list["select_category"]
		return 1

	if(href_list["set_screen"])
		clear_order_contents()
		screen = text2num(href_list["set_screen"])
		return 1

	if(href_list["show_contents"])
		generate_order_contents(href_list["show_contents"])

	if(href_list["hide_contents"])
		clear_order_contents()

	if(href_list["order"])
		clear_order_contents()
		var/decl/hierarchy/supply_pack/P = locate(href_list["order"]) in SSsupply.master_supply_list
		if(!istype(P))
			return 1

		if(P.hidden && !emagged)
			return 1

		var/reason = sanitize(input(user,"Reason:","Why do you require this item?","") as null|text,,0)
		if(!reason)
			return 1

		var/idname = "*None Provided*"
		var/idrank = "*None Provided*"
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			idname = H.get_authentification_name()
			idrank = H.get_assignment()
		else if(issilicon(user))
			idname = user.real_name

		SSsupply.ordernum++

		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = SSsupply.ordernum
		O.object = P
		O.orderedby = idname
		O.reason = reason
		O.orderedrank = idrank
		O.comment = "#[O.ordernum]"
		SSsupply.requestlist += O

		if(can_print() && alert(user, "Would you like to print a confirmation receipt?", "Print receipt?", "Yes", "No") == "Yes")
			print_order(O, user)
		return 1

	if(href_list["print_summary"])
		if(!can_print())
			return
		print_summary(user)

	// Items requiring cargo access go below this entry. Other items go above.
	if(!check_access(access_cargo))
		return 1

	if(href_list["launch_shuttle"])
		var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
		if(!shuttle)
			to_chat(user, "<span class='warning'>Error connecting to the shuttle.</span>")
			return
		if(shuttle.at_station())
			if (shuttle.forbidden_atoms_check())
				to_chat(usr, "<span class='warning'>For safety reasons the automated supply shuttle cannot transport live organisms, classified nuclear weaponry or homing beacons.</span>")
			else
				shuttle.launch(user)
		else
			shuttle.launch(user)
			var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)
			if(!frequency)
				return

			var/datum/signal/status_signal = new
			status_signal.source = src
			status_signal.transmission_method = 1
			status_signal.data["command"] = "supply"
			frequency.post_signal(src, status_signal)
		return 1

	if(href_list["approve_order"])
		var/id = text2num(href_list["approve_order"])
		var/datum/supply_order/SO = find_order_by_id(id, SSsupply.requestlist)
		if(SO)
			if(SO.object.cost >= SSsupply.points)
				to_chat(usr, "<span class='warning'>Not enough points to purchase \the [SO.object.name]!</span>")
			else
				SSsupply.requestlist -= SO
				SSsupply.shoppinglist += SO
				SSsupply.points -= SO.object.cost

		else
			to_chat(user, "<span class='warning'>Could not find order number [id] to approve.</span>")

		return 1

	if(href_list["deny_order"])
		var/id = text2num(href_list["deny_order"])
		var/datum/supply_order/SO = find_order_by_id(id, SSsupply.requestlist)
		if(SO)
			SSsupply.requestlist -= SO
		else
			to_chat(user, "<span class='warning'>Could not find order number [id] to deny.</span>")

		return 1

	if(href_list["cancel_order"])
		var/id = text2num(href_list["cancel_order"])
		var/datum/supply_order/SO = find_order_by_id(id, SSsupply.shoppinglist)
		if(SO)
			SSsupply.shoppinglist -= SO
			SSsupply.points += SO.object.cost
		else
			to_chat(user, "<span class='warning'>Could not find order number [id] to cancel.</span>")

		return 1

	if(href_list["delete_order"])
		var/id = text2num(href_list["delete_order"])
		var/datum/supply_order/SO = find_order_by_id(id, SSsupply.donelist)
		if(SO)
			SSsupply.donelist -= SO
		else
			to_chat(user, "<span class='warning'>Could not find order number [id] to delete.</span>")

		return 1

	if(href_list["print_receipt"])
		if(!can_print())
			to_chat(user, "<span class='warning'>No printer connected to print receipts.</span>")
			return 1

		var/id = text2num(href_list["print_receipt"])
		var/list_id = text2num(href_list["list_id"])
		var/list/list_to_search
		switch(list_id)
			if(SUPPLY_LIST_ID_CART)
				list_to_search = SSsupply.shoppinglist
			if(SUPPLY_LIST_ID_REQUEST)
				list_to_search = SSsupply.requestlist
			if(SUPPLY_LIST_ID_DONE)
				list_to_search = SSsupply.donelist
			else
				to_chat(user, "<span class='warning'>Invalid list ID for order number [id]. Receipt not printed.</span>")
				return 1

		var/datum/supply_order/SO = find_order_by_id(id, list_to_search)
		if(SO)
			print_order(SO, user)
		else
			to_chat(user, "<span class='warning'>Could not find order number [id] to print receipt.</span>")

		return 1

	if(href_list["toggle_notifications"])
		notifications_enabled = !notifications_enabled
		return 1

/datum/nano_module/supply/proc/generate_categories()
	category_names.Cut()
	category_contents.Cut()
	var/decl/hierarchy/supply_pack/root = decls_repository.get_decl(/decl/hierarchy/supply_pack)
	for(var/decl/hierarchy/supply_pack/sp in root.children)
		if(!sp.is_category())
			continue // No children
		category_names.Add(sp.name)
		var/list/category[0]
		for(var/decl/hierarchy/supply_pack/spc in sp.get_descendents())
			if((spc.hidden || spc.contraband || !spc.sec_available()) && !emagged)
				continue
			category.Add(list(list(
				"name" = spc.name,
				"cost" = spc.cost,
				"ref" = "\ref[spc]"
			)))
		category_contents[sp.name] = category

/datum/nano_module/supply/proc/generate_order_contents(var/order_ref)
	var/decl/hierarchy/supply_pack/sp = locate(order_ref) in SSsupply.master_supply_list
	if(!istype(sp))
		return FALSE
	contents_of_order.Cut()
	showing_contents_of_ref = order_ref
	for(var/item_path in sp.contains) // Thanks to Lohikar for helping me with type paths - CarlenWhite
		var/obj/item/stack/OB = item_path // Not always a stack, but will always have a name we can fetch.
		var/name = initial(OB.name)
		var/amount = sp.contains[item_path] || 1 // If it's just one item (has no number associated), fallback to 1.
		if(ispath(item_path, /obj/item/stack)) // And if it is a stack, consider the amount
			amount *= initial(OB.amount)


		contents_of_order.Add(list(list(
			"name" = name,
			"amount" = amount
		)))

	if(sp.contains.len == 0) // Handles the case where sp.contains is empty, e.g. for livecargo
		contents_of_order.Add(list(list(
			"name" = sp.containername,
			"amount" = 1
		)))

	return TRUE


/datum/nano_module/supply/proc/clear_order_contents()
	contents_of_order.Cut()
	showing_contents_of_ref = null

/datum/nano_module/supply/proc/get_shuttle_status()
	var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
	if(!istype(shuttle))
		return "No Connection"

	if(shuttle.has_arrive_time())
		return "In transit ([shuttle.eta_seconds()] s)"

	if (shuttle.can_launch())
		return "Docked"
	return "Docking/Undocking"

/datum/nano_module/supply/proc/order_to_nanoui(var/datum/supply_order/SO, var/list_id)
	return list(list(
		"id" = SO.ordernum,
		"object" = SO.object.name,
		"orderer" = SO.orderedby,
		"cost" = SO.object.cost,
		"reason" = SO.reason,
		"list_id" = list_id
		))

/datum/nano_module/supply/proc/can_print()
	var/datum/extension/interactive/ntos/os = get_extension(nano_host(), /datum/extension/interactive/ntos)
	if(os)
		return os.has_component(PART_PRINTER)
	return 0

/datum/nano_module/supply/proc/print_order(var/datum/supply_order/O, var/mob/user)
	if(!O)
		return

	var/t = ""
	t += "<h3>[GLOB.using_map.station_name] Supply Requisition Reciept</h3><hr>"
	t += "INDEX: #[O.ordernum]<br>"
	t += "REQUESTED BY: [O.orderedby]<br>"
	t += "RANK: [O.orderedrank]<br>"
	t += "REASON: [O.reason]<br>"
	t += "SUPPLY CRATE TYPE: [O.object.name]<br>"
	t += "ACCESS RESTRICTION: [get_access_desc(O.object.access)]<br>"
	t += "CONTENTS:<br>"
	t += O.object.manifest
	t += "<hr>"
	print_text(t, user)

/datum/nano_module/supply/proc/print_summary(var/mob/user)
	var/t = ""
	t += "<center><BR><b><large>[GLOB.using_map.station_name]</large></b><BR><i>[station_date]</i><BR><i>Export overview<field></i></center><hr>"
	for(var/source in SSsupply.point_source_descriptions)
		t += "[SSsupply.point_source_descriptions[source]]: [SSsupply.point_sources[source] || 0]<br>"
	print_text(t, user)

#undef SUPPLY_LIST_ID_CART
#undef SUPPLY_LIST_ID_REQUEST
#undef SUPPLY_LIST_ID_DONE