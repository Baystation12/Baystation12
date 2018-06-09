
/mob/living/simple_animal/npc/proc/generate_trade_items()

	//setup the accepted trade categories
	for(var/category in trade_categories_by_name)
		var/datum/trade_category/C = trade_controller.get_trade_category(category)
		if(C)
			trade_categories_by_name[category] = C
			trade_items += C.trade_items
			trade_items_by_type += C.trade_items_by_type
			total_trade_weight += C.total_weighting

	//pick 6 items randomly weighted from the accepted trade categories
	var/trade_items_left = 6
	var/trade_weight_left = total_trade_weight
	var/list/trade_items_other = trade_items.Copy()
	while(trade_items_left > 0 && trade_items_other.len)
		var/target_weight = rand(1,trade_weight_left)

		var/index_weight = 0
		var/success = 0
		for(var/datum/trade_item/I in trade_items_other)
			index_weight += I.trader_weight
			if(index_weight >= target_weight)
				spawn_trade_item(I)
				trade_weight_left -= I.trader_weight
				trade_items_other -= I
				trade_items_left -= 1

				//some trade items automatically enable other trade items for sale... mostly ammo type items
				for(var/trade_type in I.bonus_items)
					var/datum/trade_item/bonus_item = trade_controller.trade_items_by_type[trade_type]
					spawn_trade_item(bonus_item)

				success = 1
				break
		if(!success)
			break

/mob/living/simple_animal/npc/proc/spawn_trade_item(var/datum/trade_item/I, var/hidden = 0)
	if(!I)
		return

	//check if we're using a global template
	if(I.is_template)
		//create our own instance of the trade item
		var/datum/trade_item/copy = DuplicateObject(I, 1)
		copy.is_template = 0

		//clear out the old one
		trade_items -= I
		trade_items_by_type -= I.item_type

		//forget about the global one and use our own
		I = copy

		//add the new one
		trade_items += I
		trade_items_by_type += I.item_type

	trade_items_inventory += I
	trade_items_inventory_by_name[I.name] = I
	trade_items_inventory_by_type[I.item_type] = I

	//randomise the value between 75% and 125%
	I.value = round(I.value * (75 + rand(0,50))/100)

	if(hidden)
		I.quantity = 0
	else
		//randomise the quantity
		I.quantity = max(I.quantity + rand(-5,5), 1)

		//add it to the shop list in the NanoUI window
		generate_trade_item_ui(I)

/mob/living/simple_animal/npc/proc/generate_trade_item_ui(var/datum/trade_item/T)
	if(T)
		interact_inventory.Add(list(list("name" = T.name, "quantity" = T.quantity, "value" = T.value)))

/mob/living/simple_animal/npc/proc/update_trade_item_ui(var/datum/trade_item/T)
	if(T)
		var/found = 0
		for(var/i=1, i<=interact_inventory.len, i++)
			if(interact_inventory[i]["name"] == T.name)
				if(T.quantity > 0)
					interact_inventory[i]["quantity"] = T.quantity
					interact_inventory[i]["value"] = T.value
				else
					interact_inventory.Cut(i, i+1)
				found = 1
				break
		if(!found)
			generate_trade_item_ui(T)
