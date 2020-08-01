
/datum/nano_module/program/faction_supply/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	data["screen"] = screen
	data["account_credits"] = "[current_account.money]"
	data["account_num"] = "[current_account.account_number]"
	data["account_owner"] = "[current_account.owner_name]"
	data["income"] = "[my_faction.income]"
	data["payment_time"] = "[my_faction.get_station_income_time()]"
	switch(screen)
		if(SCREEN_BROWSE)// Main ordering menu
			data["categories"] = my_faction.supply_category_names
			if(selected_category)
				data["category"] = selected_category
				data["possible_purchases"] = get_category_contents(selected_category)

		if(SCREEN_STATS)// Statistics screen with credit overview
			data["total_credits"] = my_shuttle.export_credits
			data["exports"] = my_shuttle.exports_formatted
			data["can_print"] = can_print()

		if(SCREEN_SHUTTLE)// Shuttle monitoring and control
			data["shuttle_location"] = my_shuttle.at_station() ? "Onsite" : "Outsystem"
			data["shuttle_status"] = get_shuttle_status()
			data["shuttle_can_control"] = my_shuttle.can_launch()

		if(SCREEN_ORDERS)// Order processing
			var/list/cart[0]
			var/list/requests[0]
			for(var/datum/supply_order/SO in my_shuttle.shoppinglist)
				cart.Add(list(list(
					"id" = SO.ordernum,
					"object" = SO.object.name,
					"orderer" = SO.orderedby,
					"cost" = SO.object.cost * CARGO_CRATE_COST_MULTI,
					"reason" = SO.reason
				)))
			for(var/datum/supply_order/SO in my_shuttle.requestlist)
				requests.Add(list(list(
					"id" = SO.ordernum,
					"object" = SO.object.name,
					"orderer" = SO.orderedby,
					"cost" = SO.object.cost * CARGO_CRATE_COST_MULTI,
					"reason" = SO.reason
					)))
			data["cart"] = cart
			data["requests"] = requests

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "faction_supply.tmpl", name, 1050, 800, state = state)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()
