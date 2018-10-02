
/mob/living/simple_animal/npc/proc/check_tradeable(var/obj/O)
	. = 0

	if(!O)
		return 0

	//check if it's a container
	if (istype(O, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = O
		for(var/obj/I in S.contents)
			if(!check_tradeable(I))
				return 0
		return 1

	if(O.trader_category && O.trader_category in trade_categories_by_name)
		return 1

	if(O.type in trade_items_by_type)
		return 1

/mob/living/simple_animal/npc/proc/get_trade_value(var/obj/O)
	if(!O)
		return 0

	//this uses the default SS13 item_worth procs so its a good fallback
	. = get_value(O)

	//see if we are already selling the item
	var/datum/trade_item/T = trade_items_inventory_by_type[O.type]
	if(T)
		return T.value

	//check if its an accepted item
	T = trade_items_by_type[O.type]
	if(T)
		//this is in the accepted trade categories initialise the trade item but keep it hidden for now
		//note: spawn_trade_item() will slightly randomise the sale value to make it different per NPC
		spawn_trade_item(T, 1)
		return T.value

	//check if it's a container
	if (istype(O, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = O
		var/total_value = 0
		for(var/obj/I in S.contents)
			total_value += get_trade_value(I)
		return total_value

	//try and find it via the global controller
	T = trade_controller.trade_items_by_type[O.type]
	if(T)
		return T.value

	//try and find it via the global categories
	/*
	var/obj_category = O.trader_category
	if(obj_category)
		var/datum/trade_category/C = trade_categories_by_name[obj_category]
		var/init_hidden_trade_item = 0
		if(C)
			init_hidden_trade_item = 1
		else
			//we'll have to get the global value
			//dont initialise a hidden trade item because we probably wont be trading it
			C = trade_controller.get_trade_category(obj_category)

		T = C.trade_items_by_type[O.type]
		if(T)
			if(init_hidden_trade_item)
				//this is in the accepted trade categories initialise the trade item but keep it hidden for now
				//note: spawn_trade_item() will slightly randomise the sale value to make it different per NPC
				spawn_trade_item(T, 1)

			. = T.value
			*/
